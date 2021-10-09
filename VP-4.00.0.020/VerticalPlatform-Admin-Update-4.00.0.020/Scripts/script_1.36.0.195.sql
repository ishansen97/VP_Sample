EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNonPayingVendorCountByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNonPayingVendorCountByCategoryId
	@categoryId int
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

	CREATE TABLE #vendor_ids (vendor_id int)

	INSERT INTO #vendor_ids
	SELECT vendor.vendor_id
		FROM vendor
			INNER JOIN category_to_vendor
				ON vendor.vendor_id = category_to_vendor.vendor_id
		WHERE category_id = @categoryId AND category_to_vendor.[enabled] = 1 AND vendor.[enabled] = 1
		
	IF EXISTS (SELECT * FROM #vendor_ids)
	BEGIN
		DELETE FROM #vendor_ids 
		WHERE vendor_id IN
		(
			SELECT DISTINCT vendor.vendor_id
			FROM vendor 
				INNER JOIN product_to_vendor
					ON vendor.vendor_id = product_to_vendor.vendor_id 
				INNER JOIN product_to_category
					ON product_to_vendor.product_id = product_to_category.product_id 
				INNER JOIN product
					ON product_to_category.product_id = product.product_id
			WHERE product_to_category.category_id = @categoryId
		)
	END

	SELECT COUNT(*) [count] FROM #vendor_ids
	
	DROP TABLE #vendor_ids

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNonPayingVendorCountByCategoryId TO VpWebApp 
GO


-----------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNonPayingVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNonPayingVendorByCategoryIdList
	@categoryId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

	CREATE TABLE #vendor_ids (vendor_id int)

	INSERT INTO #vendor_ids
	SELECT vendor.vendor_id
		FROM vendor
			INNER JOIN category_to_vendor
				ON vendor.vendor_id = category_to_vendor.vendor_id
		WHERE category_id = @categoryId AND category_to_vendor.[enabled] = 1 AND vendor.[enabled] = 1
		
	IF EXISTS (SELECT * FROM #vendor_ids)
	BEGIN
		DELETE FROM #vendor_ids 
		WHERE vendor_id IN
		(
			SELECT DISTINCT vendor.vendor_id
			FROM vendor 
				INNER JOIN product_to_vendor
					ON vendor.vendor_id = product_to_vendor.vendor_id 
				INNER JOIN product_to_category
					ON product_to_vendor.product_id = product_to_category.product_id 
				INNER JOIN product
					ON product_to_category.product_id = product.product_id
			WHERE product_to_category.category_id = @categoryId
		)
	END

	SELECT @totalRowCount = COUNT(*) FROM #vendor_ids

	;WITH cvendors (id, site_id, vendor_name, [rank], has_image, [enabled], modified, created,
		parent_vendor_id, vendor_keywords, internal_name, [description], vendorRow) AS
	(
		SELECT vendor.vendor_id AS id, site_id, vendor_name, [rank], has_image, [enabled], modified, created
			, parent_vendor_id, vendor_keywords, internal_name, [description]
			, ROW_NUMBER() OVER (ORDER BY vendor_name) AS vendorRow	
		FROM #vendor_ids
			INNER JOIN vendor
				ON #vendor_ids.vendor_id = vendor.vendor_id
	)

	SELECT id, site_id, vendor_name, [rank], has_image, [enabled], modified, created,
		parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM cvendors
	WHERE vendorRow BETWEEN @startRowIndex AND @endRowIndex
	ORDER BY vendorRow

DROP TABLE #vendor_ids

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNonPayingVendorByCategoryIdList TO VpWebApp 
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetMissingProductByCategoryIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetMissingProductByCategoryIdPageList
	@categoryId int,
	@vendorId int,
	@startIndex int,
	@endIndex int,
	@sortBy varchar(8),
	@total int output,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@filterVendorIds varchar(MAX),
	@sortBySpecificationTypeId int,
	@productIds varchar(MAX),
	@sortOrderBy varchar(4)
AS
-- ==========================================================================
-- Author: Sujith
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, product_name varchar(500), total_rank int, vendor_name varchar(100), price money, vendor_id int,
		product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL)

	--Populate filtered products with calculated total rank
	INSERT INTO #total_ranked_product
	SELECT product.product_id
		, product.product_name
		, CASE WHEN product.[rank] = 3 THEN 6
			WHEN vendor.[rank] = 3 THEN 5
			ELSE product.[rank] + vendor.[rank]
			END total_rank
		, vendor.vendor_name
		, NULL
		, vendor.vendor_id
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
		, NULL
	FROM product
		INNER JOIN product_to_category
			ON product.product_id = product_to_category.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id
	WHERE product_to_category.category_id = @categoryId AND 
		product.enabled = 1 AND 
		product.show_in_matrix = 1 AND
		product_to_category.enabled = 1 AND 
		vendor.enabled = 1 AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		) AND
		product.product_id NOT IN 
		(
			SELECT [value] FROM dbo.global_Split(@productIds, ',')
		)

	--Increase the vendors total rank
	--If vendor id is passed to the sp and sort parameter is by 'rank' we need to boost the rank.
	--Number 8 is used to boost since the rank at the moment of all products going to be below 8. 
	IF @vendorId IS NOT NULL
	BEGIN
		UPDATE #total_ranked_product
		SET total_rank = total_rank + 8
		WHERE vendor_id = @vendorId
	END

	--- update price to the temporary table, to sort with price.
	UPDATE #total_ranked_product
	SET price =  (
		SELECT TOP 1 price
		FROM product_to_vendor_to_price p
		WHERE p.product_to_vendor_id = #total_ranked_product.product_to_vendor_id
			AND
			(
				(p.country_flag1 & @countryFlag1 > 0) OR (p.country_flag2 & @countryFlag2 > 0) OR 
				(p.country_flag3 & @countryFlag3 > 0) OR (p.country_flag4 & @countryFlag4 > 0)
			)
		ORDER BY p.country_flag1, p.country_flag2, p.country_flag3, p.country_flag4)	

	IF (@sortBySpecificationTypeId > 0)
	BEGIN
		UPDATE #total_ranked_product
		SET #total_ranked_product.specification = s.specification
		FROM #total_ranked_product p 
			INNER JOIN specification s
				ON s.content_type_id = 2 AND s.content_id = p.product_id
		WHERE s.spec_type_id = @sortBySpecificationTypeId
	END

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, row int)
		
	--Populate with row number columns
	DECLARE @query nvarchar(MAX)
	SET @query = 'INSERT INTO #temp_product
		SELECT product_id, '
	IF (@sortBySpecificationTypeId > 0)
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY specification ' + @sortOrderBy + ', vendor_name, product_name) AS row'
	ELSE IF (@sortBy = 'Product')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY product_name ' + @sortOrderBy + ') AS row'
	ELSE IF (@sortBy = 'Vendor')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY vendor_name ' + @sortOrderBy + ', product_name) AS row'
	ELSE IF (@sortBy = 'Price')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price ' + @sortOrderBy + ', vendor_name, product_name) AS row'
	ELSE   
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row'
	
	SET @query = @query + ' FROM #total_ranked_product '	

	IF (DATALENGTH(@filterVendorIds) > 0)
		SET @query = @query + 'WHERE parent_vendor_id IN (SELECT [value] FROM Global_Split(''' + @filterVendorIds + ''','',''))'

	EXECUTE sp_executesql @query

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT product.product_id AS id, site_id, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status, has_related, has_model
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM #temp_product
		INNER JOIN product
			ON #temp_product.product_id = product.product_id
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetMissingProductByCategoryIdPageList TO VpWebApp
GO

