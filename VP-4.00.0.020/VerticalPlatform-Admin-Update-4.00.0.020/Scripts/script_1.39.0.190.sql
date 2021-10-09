EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds
	@articleTypeIds NVARCHAR(MAX),
	@siteId INT,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH FeaturedVendorArticles AS
	(
		SELECT v.[vendor_id], a.[article_id] AS [id],a.[article_type_id],a.[site_id],a.[article_title],a.[article_summary],a.[enabled]
			,a.[modified],a.[created],a.[article_short_title],a.[is_article_template],a.[is_external],a.[featured_identifier]
			,a.[thumbnail_image_code],a.[date_published],a.[external_url_id],a.[is_template],a.[article_template_id]
			,a.[open_new_window],a.[end_date],a.[flag1],a.[flag2],a.[flag3],a.[flag4],a.[published],a.[start_date]
			,a.[legacy_content_id],a.[search_content_modified],a.[deleted], ROW_NUMBER() OVER (ORDER BY a.[article_title]) AS rowNumber
		FROM [article] a
			INNER JOIN vendor_parameter vp
				ON vp.[vendor_parameter_value] = a.[article_id] AND vp.[parameter_type_id] = 174
			INNER JOIN vendor_parameter vp2
				ON vp2.[vendor_id] = vp.[vendor_id] AND vp2.[parameter_type_id] = 179 AND (
						vp2.[vendor_parameter_value] LIKE '5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5' OR 
						vp2.[vendor_parameter_value] = '5')
			INNER JOIN vendor v 
				ON v.[vendor_id] = vp2.[vendor_id]
		WHERE v.[site_id] = @siteId AND v.[enabled] = 1 AND a.[enabled] = 1 AND a.[published] = 1 AND (
				@articleTypeIds IS NULL OR 
				a.[article_type_id] IN (
						SELECT gs.[value] 
						FROM dbo.global_Split(@articleTypeIds, ',') gs
					)
			)
	)
	
	SELECT [vendor_id], [id], [article_type_id], [site_id], [article_title], [article_summary], [enabled]
		, [modified], [created], [article_short_title], [is_article_template], [is_external], [featured_identifier]
		, [thumbnail_image_code], [date_published], [external_url_id], [is_template], [article_template_id]
		, [open_new_window], [end_date], [flag1], [flag2], [flag3], [flag4], [published], [start_date]
		, [legacy_content_id], [search_content_modified], [deleted]
	FROM FeaturedVendorArticles
	WHERE rowNumber BETWEEN @startIndex AND @endIndex
	
	SELECT @totalCount = COUNT(*)
	FROM [article] a
			INNER JOIN vendor_parameter vp
				ON vp.[vendor_parameter_value] = a.[article_id] AND vp.[parameter_type_id] = 174
			INNER JOIN vendor_parameter vp2
				ON vp2.[vendor_id] = vp.[vendor_id] AND vp2.[parameter_type_id] = 179 AND (
						vp2.[vendor_parameter_value] LIKE '5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5' OR 
						vp2.[vendor_parameter_value] = '5')
			INNER JOIN vendor v 
				ON v.[vendor_id] = vp2.[vendor_id]
		WHERE v.[site_id] = @siteId AND v.[enabled] = 1 AND a.[enabled] = 1 AND a.[published] = 1 AND (
				@articleTypeIds IS NULL OR 
				a.[article_type_id] IN (
						SELECT gs.[value] 
						FROM dbo.global_Split(@articleTypeIds, ',') gs
					)
			)

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__product__search___23569711]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[product] DROP CONSTRAINT [DF__product__search___23569711]
END
GO

ALTER TABLE product
ALTER COLUMN search_rank FLOAT
GO

ALTER TABLE [dbo].[product] ADD  DEFAULT (0) FOR [search_rank]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__product__default__02166A2E]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[product] DROP CONSTRAINT [DF__product__default__02166A2E]
END
GO

ALTER TABLE product
ALTER COLUMN default_search_rank FLOAT
GO

ALTER TABLE [dbo].[product] ADD  DEFAULT (0) FOR [default_search_rank]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__product_d__searc__43E42D8B]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[product_display_status] DROP CONSTRAINT [DF__product_d__searc__43E42D8B]
END
GO

ALTER TABLE product_display_status
ALTER COLUMN search_rank FLOAT
GO

ALTER TABLE [dbo].[product_display_status] ADD  DEFAULT (0) FOR [search_rank]
GO

--------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProduct
	@id int, 
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank float,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank float
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE product 
	SET
		site_id = @siteId,
		product_name = @productName,
		rank = @rank,
		has_image = @hasImage,
		catalog_number = @catalogNumber,
		[enabled] = @enabled,
		modified = @modified,
		product_type = @productType,
		status = @status,
		has_related = @hasRelated,
		has_model = @hasModel,
		completeness = @completeness,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		search_rank = @searchRank,
		search_content_modified = @searchContentModified,
		hidden = @hidden,
		business_value = @businessValue,
		ignore_in_rapid = @ignoreInRapid,
		show_in_matrix = @showInMatrix,
		show_detail_page = @showDetailPage,
		default_rank = @defaultRank,
		default_search_rank = @defaultSearchRank
		
		
	WHERE product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProduct TO VpWebApp 
GO

-----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProduct
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank float,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank float
	
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO product(site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank) 
	VALUES (@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @created, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue,@ignoreInRapid, @showInMatrix, @showDetailPage, @defaultRank, @defaultSearchRank) 

	SET @id = SCOPE_IDENTITY() 

END

GO

GRANT EXECUTE ON dbo.adminProduct_AddProduct TO VpWebApp 
GO

----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductDisplayStatus
	@id int output,
	@productId int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@SearchRank float,
	@newRank int,
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [product_display_status] (product_id, start_date, end_date, search_rank, new_rank, [enabled], modified, created)
	VALUES (@productId, @startDate, @endDate, @SearchRank, @newRank, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductDisplayStatus TO VpWebApp 
GO

--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductDisplayStatus
	@id int,
	@productId int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@SearchRank float,
	@newRank int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[product_display_status]
	SET product_id = @productId,
		start_date = @startDate,
		end_date = @endDate,
		search_rank = @SearchRank,
		new_rank = @newRank,
		enabled = @enabled,		
		modified = @modified
	WHERE product_display_status_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductDisplayStatus TO VpWebApp 
GO

--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdPageList
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
-- Author: Sahan
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
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY specification ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE IF (@sortBy = 'Product')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY product_name ' + @sortOrderBy + ') AS row, '
	ELSE IF (@sortBy = 'Vendor')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY vendor_name ' + @sortOrderBy + ', product_name) AS row, '
	ELSE IF (@sortBy = 'Price')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price_sort_order ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
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

-----------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsSearchResults'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsSearchResults
	@productIds varchar(8000),
	@startIndex int,
	@endIndex int,
	@sortBy varchar(20),
	@total int output,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@filterVendorIds varchar(MAX)
	
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	--Create temp table to store the product ids ordered by its relevancy score
	CREATE TABLE #relevancy_based_product(relevancy_id int identity(1,1) , product_id int)

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, relevancy_order int, vendor_name varchar(100), price money
		, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank float, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, show_in_matrix bit, show_detail_page bit
		, default_rank bit, default_search_rank float)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, product_row int, vendor_row int
		, price_row int, relevancy_row int, rank_row int, parent_product_id int
		, product_name varchar(500), [rank] int
		, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit
		, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank float, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit
		, default_rank bit, default_search_rank float)

	--Populate relevancy based product results
	INSERT INTO #relevancy_based_product
	SELECT [value] FROM global_Split(@productIds, ',')
	
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
		, rbp.relevancy_id
		, vendor.vendor_name
		, null
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
		, product.show_in_matrix
		, product.show_detail_page
		, product.default_rank
		, product.default_search_rank
	FROM product
		INNER JOIN #relevancy_based_product AS rbp
			ON rbp.product_id = product.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id

	WHERE product.enabled = 1 AND vendor.enabled = 1 AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)

	--- update price to the temporary table, to sort with price.
	UPDATE #total_ranked_product
	SET price =  product_to_vendor_to_price.price	
	FROM  #total_ranked_product
		INNER JOIN product_to_vendor_to_price
			ON product_to_vendor_to_price.product_to_vendor_id = #total_ranked_product.product_to_vendor_id
				AND product_to_vendor_to_price.price =
				(SELECT TOP(1) product_to_vendor_to_price.price  
				FROM product_to_vendor_to_price 
				WHERE #total_ranked_product.product_to_vendor_id = product_to_vendor_to_price.product_to_vendor_id
					AND
					(
						(product_to_vendor_to_price.country_flag1 & @countryFlag1 > 0) OR (product_to_vendor_to_price.country_flag2 & @countryFlag2 > 0) OR 
						(product_to_vendor_to_price.country_flag3 & @countryFlag3 > 0) OR (product_to_vendor_to_price.country_flag4 & @countryFlag4 > 0)
					)					
				)


	--Populate with row number columns
	INSERT INTO #temp_product
	SELECT product_id, site_id
		, ROW_NUMBER() OVER(ORDER BY product_name) AS product_row
		, ROW_NUMBER() OVER(ORDER BY vendor_name, product_name) AS vendor_row
		, ROW_NUMBER() OVER(ORDER BY price) AS price_row
		, ROW_NUMBER() OVER(ORDER BY relevancy_order) AS relevancy_row
		, ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS rank_row
		, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		, default_rank, default_search_rank
		, parent_vendor_id
	FROM #total_ranked_product
	WHERE	(
			DATALENGTH(@filterVendorIds) = 0 
			OR
			parent_vendor_id IN (SELECT [value] FROM Global_Split(@filterVendorIds, ','))
		)

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT id, site_id, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM
	(
		SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, enabled, modified, created, product_type, status
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page, default_rank, default_search_rank
			, CASE @sortBy
				WHEN 'Product' THEN product_row
				WHEN 'Vendor' THEN vendor_row
				WHEN 'Price' THEN price_row
				WHEN 'Relevancy' THEN relevancy_row
				ELSE rank_row
			END AS row
		FROM #temp_product
	) AS temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #relevancy_based_product
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsSearchResults TO VpWebApp
GO

-----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductForSearchList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductForSearchList
	@siteId int,
	@search varchar(255),
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
-- Author: Sahan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #search_product (search_product_id int)

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, vendor_name varchar(100), price money, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank float, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL,
		show_in_matrix bit, show_detail_page bit, price_sort_order money,  default_rank int, default_search_rank float)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit,  default_rank float, default_search_rank float)

	INSERT INTO #search_product
	SELECT DISTINCT content_id AS search_product_id
	FROM FREETEXTTABLE(content_text, *, @search) RankedTable
		INNER JOIN content_text
			ON [KEY] = content_text.content_text_id AND content_text.site_id = @siteId
		INNER JOIN product_to_category
			ON content_type_id IN (2,3) AND content_id = product_to_category.product_id
	WHERE content_text.enabled = '1' AND product_to_category.category_id = @categoryId


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
		,NULL
		,default_rank
		,default_search_rank
	FROM product
		INNER JOIN #search_product ON search_product_id = product.product_id
		INNER JOIN product_to_category
			ON product.product_id = product_to_category.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id
	WHERE product_to_category.category_id = @categoryId AND 
		product.enabled = 1 AND 
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
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY specification ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE IF (@sortBy = 'Product')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY product_name ' + @sortOrderBy + ') AS row, '
	ELSE IF (@sortBy = 'Vendor')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY vendor_name ' + @sortOrderBy + ', product_name) AS row, '
	ELSE IF (@sortBy = 'Price')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price_sort_order ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE  
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row, '
	
	SET @query = @query + 'parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		,default_rank, default_search_rank
	FROM #total_ranked_product '	

	IF (DATALENGTH(@filterVendorIds) > 0)
		SET @query = @query + 'WHERE parent_vendor_id IN (SELECT [value] FROM Global_Split(''' + @filterVendorIds + ''','',''))'

	EXECUTE sp_executesql @query

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status, has_related, has_model
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		, default_rank, default_search_rank
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductForSearchList TO VpWebApp
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductBySiteIdCategoryIdVendorIdRankWithSortingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductBySiteIdCategoryIdVendorIdRankWithSortingList
	@siteId int,
	@categoryIds varchar(1000),
	@autoCategoryIds varchar(1000),
	@autoVendorIds varchar(1000),
	@ranks varchar(1000),
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@startIndex int,
	@endIndex int,
	@productIdList varchar(1000),
	@pagingEnabled bit,
	@subHomeCategoryId int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author:  Sahan $
-- ==========================================================================

BEGIN

SET NOCOUNT ON;

	CREATE TABLE #temp_product (idCol int identity(1, 1), id int, site_id int, parent_product_id int, product_name varchar(500)
			,  [rank] int, has_image bit, catalog_number varchar(255), [enabled] bit, modified smalldatetime
			, created smalldatetime, product_type int, [status] int, has_related bit
			, has_model bit, completeness int
			, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint
			, search_rank float)

	CREATE TABLE #subhome_category (idCol int identity(1, 1), id int)

IF @subHomeCategoryId > 0
BEGIN

	DECLARE @categoryType int
	
	SELECT @categoryType = category_type_id	FROM category where category_id = @subHomeCategoryId AND enabled = 1
	
	IF @categoryType = 4
		BEGIN
			INSERT INTO #subhome_category
				SELECT category_id FROM category WHERE category_id = @subHomeCategoryId AND enabled = 1
		END
	ELSE
		BEGIN
			WITH category_hierarchy (category_id, sub_category_id) AS
			(
				SELECT category_id, sub_category_id 
				FROM category_to_category_branch
				WHERE category_id = @subHomeCategoryId AND category_to_category_branch.enabled = '1'

				UNION ALL 

				SELECT cb.category_id, cb.sub_category_id 
				FROM category_to_category_branch cb
					INNER JOIN category_hierarchy ch 
						ON cb.category_id = ch.sub_category_id
				WHERE cb.enabled = 1
			)
			INSERT INTO #subhome_category
				SELECT DISTINCT cat.category_id FROM category cat
					INNER JOIN category_hierarchy cat_hier
						ON cat.category_id = cat_hier.sub_category_id
				WHERE cat.enabled = 1
		END
		
END

IF @autoCategoryIds IS NOT NULL

	IF @subHomeCategoryId > 0
		BEGIN
		-- Filter by auto category and sub home
		INSERT INTO #temp_product 
		SELECT DISTINCT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name
					, pro.[rank], pro.has_image, pro.catalog_number
					, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.[status]
					, pro.has_related, pro.has_model, pro.completeness
					, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			FROM product AS pro
					LEFT JOIN product_to_category AS proCat
						ON pro.product_id = proCat.product_id
			WHERE 
					pro.site_id = @siteId 
				AND 
					pro.product_type <> 3
				AND
					pro.enabled = 1
				AND
				(
					proCat.category_id IN 
					(
						SELECT [value] FROM global_Split(@autoCategoryIds, '|')
					)
				)
				AND
					proCat.category_id IN (SELECT id FROM #subhome_category)
			ORDER BY pro.created DESC
		END
	ELSE
		BEGIN

		-- Filter by auto category

		INSERT INTO #temp_product 
		SELECT DISTINCT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name
					, pro.[rank], pro.has_image, pro.catalog_number
					, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.[status]
					, pro.has_related, pro.has_model, pro.completeness
					, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			FROM product AS pro
					LEFT JOIN product_to_category AS proCat
						ON pro.product_id = proCat.product_id
			WHERE 
					pro.site_id = @siteId 
				AND 
					pro.product_type <> 3
				AND
					pro.enabled = 1
				AND
				(
					proCat.category_id IN 
					(
						SELECT [value] 
						FROM global_Split(@autoCategoryIds, '|')
					)
				)
			ORDER BY pro.created DESC
		END

ELSE IF @autoVendorIds IS NOT NULL

	BEGIN

		-- Filter by auto vendor

		INSERT INTO #temp_product 
		SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name
					, pro.[rank], pro.has_image, pro.catalog_number
					, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.[status]
					, pro.has_related, pro.has_model, pro.completeness
					, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			FROM product AS pro
					INNER JOIN product_to_vendor proVen
						ON  pro.product_id = proVen.product_id
			WHERE 
					pro.site_id = @siteId 
				AND 
					pro.product_type <> 3
				AND
					pro.enabled = 1
				AND
				(
					proVen.vendor_id IN 
					(
						SELECT [value] 
						FROM global_Split(@autoVendorIds, '|')
					)
				)
			ORDER BY pro.created DESC

	END

ELSE IF @productIdList IS NOT NULL

	BEGIN
		
		INSERT INTO #temp_product 
		SELECT product_id AS id, site_id, parent_product_id, product_name
						, [rank], has_image, catalog_number
						, [enabled], modified, created, product_type, [status]
						, has_related, has_model, completeness
						, flag1, flag2, flag3, flag4, search_rank
				FROM product AS pro
						INNER JOIN 
							global_Split(@productIdList, '|') as manualProducts
							on product_id = manualProducts.value	
				WHERE pro.enabled = 1

	END

ELSE
	IF @subHomeCategoryId > 0
		BEGIN
			-- Filter by subhome id
			INSERT INTO #temp_product 
			SELECT DISTINCT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name
						, pro.[rank], pro.has_image, pro.catalog_number
						, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.[status]
						, has_related, has_model, completeness
						, flag1, flag2, flag3, flag4, search_rank
				FROM product AS pro
						LEFT JOIN product_to_category AS proCat
							ON pro.product_id = proCat.product_id					
				WHERE 
						pro.site_id = @siteId 
					AND 
						pro.product_type <> 3
					AND
						pro.enabled = 1
					AND
					(
						@categoryIds IS NULL 
						OR
						@categoryIds = ''
						OR 
						proCat.category_id IN 
						(
							SELECT [value] 
							FROM global_Split(@categoryIds, '|')
						)
					)
					AND
					proCat.category_id IN (SELECT id FROM #subhome_category)
					AND
					(
						@ranks IS NULL 
						OR
						@ranks = ''
						OR 
						pro.[rank] IN 
						(
							SELECT [value] 
							FROM global_Split(@ranks, '|')
						)
					)
				ORDER BY pro.created DESC
		END
	ELSE
		BEGIN
		
		INSERT INTO #temp_product 
		SELECT DISTINCT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name
					, pro.[rank], pro.has_image, pro.catalog_number
					, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.[status]
					, pro.has_related, pro.has_model, pro.completeness
					, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			FROM product AS pro
					LEFT JOIN product_to_category AS proCat
						ON pro.product_id = proCat.product_id					
			WHERE 
					pro.site_id = @siteId 
				AND 
					pro.product_type <> 3
				AND
					pro.enabled = 1
				AND
				(
					@categoryIds IS NULL 
					OR
					@categoryIds = ''
					OR 
					proCat.category_id IN 
					(
						SELECT [value] FROM global_Split(@categoryIds, '|')
					)
				)
				AND
				(
					@ranks IS NULL 
					OR
					@ranks = ''
					OR 
					pro.[rank] IN 
					(
						SELECT [value] 
						FROM global_Split(@ranks, '|')
					)
				)
			ORDER BY pro.created DESC
		END
	;

--	select * from #temp_product

	WITH temp_sorted_product AS
	(
		SELECT id, site_id, parent_product_id, product_name, [rank], has_image, catalog_number
				, [enabled], modified, created, product_type, [status]
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank				
				, ROW_NUMBER() OVER (ORDER BY idCol) AS row
				
		FROM #temp_product
	)

	SELECT id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type, [status]
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank
	FROM temp_sorted_product
	WHERE @pagingEnabled IS NULL OR (row BETWEEN @startIndex AND @endIndex) 


	SELECT @totalCount = COUNT(*)
	FROM #temp_product
	

	drop table #temp_product
	drop table #subhome_category


END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductBySiteIdCategoryIdVendorIdRankWithSortingList TO VpWebApp 
Go
-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList]
	@categoryId int,
	@vendorId int,
	@startRowIndex int,
	@endRowIndex int,
	@actionId int,
	@totalRowCount int output	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #TempProductList
	(
		id int NOT NULL,
		site_id int NOT NULL,
		product_name varchar(500) NOT NULL,
		row_id int NOT NULL,
		rank int NOT NULL,
		has_image bit NOT NULL,
		catalog_number varchar(255) NULL,
		enabled bit NOT NULL,
		modified smalldatetime NOT NULL,
		created smalldatetime NOT NULL,
		product_type int NOT NULL DEFAULT ((1)),
		status int NOT NULL DEFAULT ((0)),
		has_related bit NOT NULL,
		has_model bit NOT NULL,
		completeness int NOT NULL,
		flag1 bigint NOT NULL,
		flag2 bigint NOT NULL,
		flag3 bigint NOT NULL,
		flag4 bigint NOT NULL,
		search_rank float NOT NULL DEFAULT ((50)),
		search_content_modified bit,
		hidden bit,
		business_value int,
		ignore_in_rapid bit,
		show_in_matrix bit,
		show_detail_page bit,
		default_rank int,
		default_search_rank float

	)

	

	INSERT INTO #TempProductList
	
		SELECT DISTINCT p.product_id as id, p.site_id as site_id, p.product_name as product_name, ROW_NUMBER() OVER (ORDER BY v.rank DESC, product_Name) AS row_id
						, p.rank as rank 
						, p.has_image as has_image, p.catalog_number as catalog_number, p.enabled as enabled, p.modified as modified
						, p.created as created, p.product_type as product_type, p.status as status, p.has_related as has_related, p.has_model as has_model
						, p.completeness as completeness, p.flag1, p.flag2, p.flag3, p.flag4
						, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page
						, p.default_rank, p.default_search_rank

		FROM product p
		INNER JOIN product_to_vendor ptv
			ON p.product_id = ptv.product_id AND ptv.enabled = 1 AND ptv.is_manufacturer = 1 AND ptv.lead_enabled = 1
		INNER JOIN vendor v
			ON ptv.vendor_id = v.vendor_id AND v.enabled = 1
		INNER JOIN product_to_category ptc
			ON p.product_id = ptc.product_id AND ptc.enabled = 1
		LEFT OUTER JOIN vendor_parameter vpALL
			ON v.vendor_id = vpALL.vendor_id AND vpALL.parameter_type_id = 101
		LEFT OUTER JOIN vendor_parameter vpVENDOR
			ON v.vendor_id = vpVENDOR.vendor_id AND vpVENDOR.parameter_type_id = 47
		LEFT OUTER JOIN product_parameter vpPRODUCT
			ON p.product_id = vpPRODUCT.product_id AND vpPRODUCT.parameter_type_id = 104

		LEFT OUTER JOIN action_to_content atcp
			ON atcp.action_id = @actionId AND atcp.content_id = p.product_id AND atcp.content_type_id = 2
		LEFT OUTER JOIN action_to_content atcv
			ON atcv.action_id = @actionId AND atcv.content_id = ptv.vendor_id AND atcv.content_type_id = 6
		LEFT OUTER JOIN action_to_content atcc
			ON atcc.action_id = @actionId AND atcc.content_id = @categoryId AND atcc.content_type_id = 1
		LEFT OUTER JOIN action_to_content atcs
			ON atcs.action_id = @actionId AND atcs.content_id = p.site_id AND atcs.content_type_id = 5

		WHERE p.enabled = 1 AND ptc.category_id = @categoryId AND ptv.vendor_id <> @vendorId
			  AND (COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) = 1 
			  OR COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) IS NULL)
			  AND (vpVENDOR.vendor_parameter_value = 1 OR vpVENDOR.vendor_parameter_value IS NULL) 
			  AND (vpALL.vendor_parameter_value = 0 OR vpALL.vendor_parameter_value IS NULL)
			  AND (vpPRODUCT.product_parameter_value = 0 OR vpPRODUCT.product_parameter_value IS NULL)
		
		
		SELECT id, site_id, product_Name, [rank], has_image, catalog_number
			, [enabled], modified, created, product_type, status, has_related, has_model
			, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page, default_rank, default_search_rank

		FROM #TempProductList
		WHERE row_id BETWEEN @startRowIndex AND @endRowIndex
		ORDER BY row_id
		
		SELECT @totalRowCount = COUNT(*)
		FROM  #TempProductList

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList TO VpWebApp 
GO
