EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetProductByCategoryIdPageList]
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
	@sortOrderBy varchar(4)
AS
-- ==========================================================================
-- Author: Dulip
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, vendor_name varchar(100), price money, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank float, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL
		, show_in_matrix bit, show_detail_page bit, default_rank int, default_search_rank float, price_sort_order money)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank float, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit, default_rank int, default_search_rank float)

	--Populate filtered products with calculated total rank
	INSERT INTO #total_ranked_product
	SELECT product.product_id, product.site_id, product.parent_product_id
		, product.product_name, product.[rank]
		, product.has_image, product.catalog_number, product.enabled, product.modified
		, product.created
		, CASE WHEN product.[rank] = 3 THEN 6
			WHEN vendor.[rank] = 3 THEN 5
			ELSE product.[rank] + vendor.[rank]
			END total_rank
		, vendor.vendor_name
		, NULL
		, vendor.vendor_id
		, product.product_type
		, product.status
		, product.has_related
		, product.has_model
		, product.completeness
		, product.flag1
		, product.flag2
		, product.flag3
		, product.flag4
		, product.search_rank
		, product.search_content_modified
		, product.hidden
		, product.business_value
		, product.ignore_in_rapid
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
		, NULL
		,product.show_in_matrix
		,product.show_detail_page
		, product.default_rank
		, product.default_search_rank
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
		product.hidden = 0 AND
		product.show_in_matrix = 1 AND
		product_to_category.enabled = 1 AND 
		vendor.enabled = 1 AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
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

	--- update price sort order to the temporary table.
	UPDATE #total_ranked_product
	SET price_sort_order = (
		CASE 
		WHEN @sortOrderBy = 'ASC' AND (price IS NULL OR price = 0)
		THEN
			'100000'
		ELSE
			price
		END
	)

	IF (@sortBySpecificationTypeId > 0)
	BEGIN
		UPDATE #total_ranked_product
		SET #total_ranked_product.specification = s.specification
		FROM #total_ranked_product p 
			INNER JOIN specification s
				ON s.content_type_id = 2 AND s.content_id = p.product_id
		WHERE s.spec_type_id = @sortBySpecificationTypeId
	END

	--Populate with row number columns
	DECLARE @query nvarchar(MAX)
	SET @query = 'INSERT INTO #temp_product
		SELECT product_id, site_id, '
	IF (@sortBySpecificationTypeId > 0)
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC,specification ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE IF (@sortBy = 'Product')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC,product_name ' + @sortOrderBy + ') AS row, '
	ELSE IF (@sortBy = 'Vendor')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC,vendor_name ' + @sortOrderBy + ', product_name) AS row, '
	ELSE IF (@sortBy = 'Price')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC,price_sort_order ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE  
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row, '
	
	SET @query = @query + 'parent_product_id, product_name, [rank], has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank

	FROM #total_ranked_product '	

	IF (DATALENGTH(@filterVendorIds) > 0)
		SET @query = @query + 'WHERE parent_vendor_id IN (SELECT [value] FROM Global_Split(''' + @filterVendorIds + ''','',''))'

	EXECUTE sp_executesql @query

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank], has_image, catalog_number, enabled, 
		modified, created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, 
		search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdPageList TO VpWebApp
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_AssociateAndDeleteProductsForGeneratedCategories]
	@categoryId int,
	@associateSearchCategoryId int
AS
-- ==========================================================================
-- $ Author : Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT

	SELECT @optionsCount = COUNT(*)
	FROM category_to_search_option ctso
	WHERE ctso.category_id = @categoryId

	SELECT p.product_id
	INTO #tmpProducts
	FROM product p
	INNER JOIN product_to_search_option ptso
		ON ptso.product_id = p.product_id
	INNER JOIN category_to_search_option ctso
		ON ctso.search_option_id = ptso.search_option_id
	INNER JOIN product_to_category ptc
		ON ptc.product_id = p.product_id
	WHERE ctso.category_id = @categoryId
		AND p.enabled = 1
		AND ptc.category_id = @associateSearchCategoryId
	GROUP BY p.product_id
	HAVING COUNT(ptso.product_id) = @optionsCount

	INSERT INTO product_to_category (category_id, product_id, [enabled], modified, created)
	SELECT @categoryId, product_id, 1, GETDATE(), GETDATE()
	FROM #tmpProducts
	WHERE product_id NOT IN (
		SELECT product_id
		FROM product_to_category ptc
		WHERE ptc.category_id = @categoryId
		)

	--updating for elastic search index
	UPDATE  pro
	SET		pro.search_content_modified = 1 
	FROM	product pro
			INNER JOIN product_to_category prc ON	prc.product_id = pro.product_id
	WHERE   prc.category_id = @categoryId


	DELETE
	FROM product_to_category
	WHERE category_id = @categoryId
		AND product_id NOT IN (
			SELECT p.product_id
			FROM product p
			INNER JOIN product_to_search_option ptso
				ON ptso.product_id = p.product_id
			INNER JOIN category_to_search_option ctso
				ON ctso.search_option_id = ptso.search_option_id
			INNER JOIN product_to_category ptc
		        ON ptc.product_id = p.product_id
			WHERE ctso.category_id = @categoryId
				AND p.enabled = 1
				AND ptc.category_id = @associateSearchCategoryId
			GROUP BY p.product_id
			HAVING COUNT(ptso.product_id) = @optionsCount
		)
		
	DROP TABLE #tmpProducts
END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp 
GO
------------------------------------------------------------------------------------------------