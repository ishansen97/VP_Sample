
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductDetail
	@id int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4
		, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM product
	WHERE product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductDetail TO VpWebApp 
GO


------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdListWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdListWithSorting
	@siteId int,
	@vendorId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@pageSize int,
	@pageIndex int,
	@totalRowCount int output	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, 
					id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, 
					product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow, 
					catalog_number, [enabled], modified, created, product_type, [status], 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
					,show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					,p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					,p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
					,p.show_in_matrix, p.show_detail_page
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status, 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page

			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
				
			ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow 
					WHEN 'Name' THEN nameRow 
					WHEN 'CatalogNumber' THEN catalogNoRow
				END
			ASC
		END
	ELSE
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status, 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page

			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
			ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow
					WHEN 'Name' THEN nameRow 
					WHEN 'CatalogNumber' THEN catalogNoRow
				END
			DESC
		END	

	SELECT @totalRowCount = COUNT(id) 
	FROM #tmpProducts

	DROP TABLE #tmpProducts	
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdListWithSorting TO VpWebApp
GO
---------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByVendorIdRandom'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByVendorIdRandom
	@vendorId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP 1 product.product_id as id, product.site_id, product_Name, product.[rank], has_image
		, catalog_number, product.[enabled], product.modified, product.created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page

	FROM product
		INNER JOIN product_to_vendor 
			ON product.product_id = product_to_vendor.product_id
	WHERE product_to_vendor.vendor_id = @vendorId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByVendorIdRandom TO VpWebApp 
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdListEnabledWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdListEnabledWithSorting
	@siteId int,
	@vendorId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@pageSize int,
	@pageIndex int,
	@enabled int,
	@totalRowCount int output	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, 
					id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, 
					product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow, 
					catalog_number, [enabled], modified, created, product_type, [status], 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
					show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					, p.has_related, p.has_model, p.completeness
					, p.flag1, p.flag2, p.flag3, p.flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId AND p.[enabled] = @enabled 
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status
					, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
				
			ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow 
					WHEN 'Name' THEN nameRow 
					WHEN 'CatalogNumber' THEN catalogNoRow
				END
			ASC
		END
	ELSE
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type
					, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
			ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow
					WHEN 'Name' THEN nameRow 
					WHEN 'CatalogNumber' THEN catalogNoRow
				END
			DESC
		END	

	SELECT @totalRowCount = COUNT(id) 
	FROM #tmpProducts

	DROP TABLE #tmpProducts	
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdListEnabledWithSorting TO VpWebApp
GO
--------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdSearchList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdSearchList
	@siteId int,
	@search varchar(255),
	@numberOfItems int 
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@numberOfItems) product_id AS id, site_id, parent_product_id, product_name, rank
		, has_image, catalog_number, enabled, modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page
	FROM product
	WHERE site_id = @siteId AND product_name LIKE '%' + @search + '%'

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdSearchList TO VpWebApp 
GO

----------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetGenericProductByCategoryIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetGenericProductByCategoryIdDetail
	@categoryId int 
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, pro.product_type, pro.status
			, pro.has_related , pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4
			, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page

	FROM product_to_category catPro
			INNER JOIN product pro
				ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @categoryId AND pro.product_type = 3


END
GO

GRANT EXECUTE ON dbo.adminProduct_GetGenericProductByCategoryIdDetail TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByVendorIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByVendorIdList
	@vendorId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id as id, pro.site_id, pro.product_Name, pro.[rank]
		, pro.has_image,pro.catalog_number, pro.[enabled], pro.modified, pro.created
		, product_type, status, has_related, has_model, completeness
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, pro.ignore_in_rapid, show_in_matrix, show_detail_page
	FROM product pro
			INNER JOIN product_to_vendor proVen
				ON pro.product_id = proVen.product_id
	WHERE proVen.vendor_id = @vendorId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByVendorIdList TO VpWebApp 
GO
---------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) prod.product_id AS id, prod.site_id, prod.product_Name, prod.[rank]
	, prod.has_image, prod.catalog_number, prod.enabled, prod.modified, prod.created, prod.product_type, prod.status
	, prod.has_related, prod.has_model, prod.completeness
	, prod.flag1, prod.flag2, prod.flag3, prod.flag4, prod.search_rank, prod.search_content_modified, prod.hidden, prod.business_value, prod.ignore_in_rapid
	, prod.show_in_matrix, prod.show_detail_page
	FROM product prod
		LEFT OUTER JOIN content_text 
			ON prod.product_id = content_text.content_id AND content_text.content_type_id = 2
	WHERE prod.site_id = @siteId AND prod.enabled = 1 AND prod.product_type <> 3 AND prod.hidden = 0
		AND ((prod.modified > content_text.modified) OR (content_text.modified IS NULL))

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedList TO VpWebApp
GO


----------



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductLocalized'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductLocalized
	@productId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status], has_related
		, has_model, flag1, flag2, flag3, flag4, search_rank, completeness, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page
	FROM product
	WHERE product_id = @productId AND [enabled] = 1 AND
		((flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR 
		(flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0))
	

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductLocalized TO VpWebApp 
GO
----------



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdRankListWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdRankListWithSorting
	@siteId int,
	@vendorId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@pageSize int,
	@pageIndex int,
	@productStatus int,
	@totalRowCount int output
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, 
					id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, 
					product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow, 
					catalog_number, [enabled], modified, created, product_type, [status], 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
					show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					,p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					,p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4
					,p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId AND p.[rank] = @productStatus 
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model
					, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
				
			ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow 
					WHEN 'Name' THEN nameRow 
					WHEN 'CatalogNumber' THEN catalogNoRow
				END
			ASC
		END
	ELSE
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type
					, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
					, show_in_matrix, show_detail_page
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
			ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow
					WHEN 'Name' THEN nameRow 
					WHEN 'CatalogNumber' THEN catalogNoRow
				END
			DESC
		END	

	SELECT @totalRowCount = COUNT(id) 
	FROM #tmpProducts

	DROP TABLE #tmpProducts	
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdRankListWithSorting TO VpWebApp
GO
------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) p.product_id as id, p.site_id, p.product_Name, p.rank
		, p.has_image, p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
		, p.show_in_matrix, p.show_detail_page
	FROM product p
		INNER JOIN product_to_vendor pv
			ON p.product_id = pv.product_id
		INNER JOIN product_to_category pc
			ON p.product_id = pc.product_id
		INNER JOIN category c
			ON c.category_id = pc.category_id AND c.hidden = '0' 
		LEFT OUTER JOIN content_text ct
			ON p.product_id = ct.content_id AND ct.content_type_id = 2
			
	WHERE (p.enabled = '1') 
		AND ((pv.modified > ct.modified) OR (ct.modified IS NULL))
		AND (p.site_id = @siteId OR @siteId IS NULL)

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList TO VpWebApp 
GO
-------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdGeoLocationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdGeoLocationList
	@id int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, product_type, status
			, has_related, has_model, completeness, business_value, pro.ignore_in_rapid, show_in_matrix, show_detail_page
			, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @id AND
	(
		(pro.flag1 & @countryFlag1 > 0) OR (pro.flag2 & @countryFlag2 > 0) OR 
		(pro.flag3 & @countryFlag3 > 0) OR (pro.flag4 & @countryFlag4 > 0)
	)

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdGeoLocationList TO VpWebApp 
GO


------



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsByCategoryIdLikeProductNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsByCategoryIdLikeProductNameList
	@categoryId int,
	@name varchar(500),
	@numberOfResults int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@numberOfResults) p.product_id AS id, p.site_id, p.parent_product_id
			, p.product_name, p.rank
			, p.has_image, p.catalog_number
			, p.[enabled], p.modified, p.created, p.product_type, p.status
			, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank
			, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page
	FROM product p
		INNER JOIN product_to_category pc
			ON pc.product_id = p.product_id
	WHERE pc.category_id = @categoryId AND p.product_name LIKE (@name + '%')

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsByCategoryIdLikeProductNameList TO VpWebApp 
GO
---------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdList
	@id int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, product_type, status
			, has_related, has_model, completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, show_in_matrix, show_detail_page
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdList TO VpWebApp 
GO

---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByCategoryIdVendorIdSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByCategoryIdVendorIdSiteIdList
	@categoryId int,
	@vendorId int,
	@siteId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id as id, pro.site_id, pro.product_Name, pro.[rank], pro.has_image
		, pro.catalog_number, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.status
		, pro.has_related, pro.has_model, pro.completeness
		, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid
		, pro.show_in_matrix, pro.show_detail_page
	FROM product pro
		INNER JOIN product_to_category proCat
			ON pro.product_id = proCat.product_id
		INNER JOIN product_to_vendor proVen
			ON pro.product_id = proVen.product_id 
	WHERE proCat.category_id = @categoryId AND proVen.vendor_id = @vendorId AND pro.site_id = @siteId
	ORDER BY pro.created DESC

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByCategoryIdVendorIdSiteIdList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList
	@id int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, product_type, status
			, pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4
			, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @id AND catPro.[enabled] = '1'

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList TO VpWebApp 
GO


---------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductIdsList
	@productIds varchar(MAX),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page
	FROM product
		INNER JOIN global_Split(@productIds, ',') AS product_id_table
			ON product.product_id = product_id_table.[value]
		AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductIdsList TO VpWebApp 
GO

------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductIdStringList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductIdStringList
	@productIds varchar(MAX)
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page
	FROM product 
		INNER JOIN global_Split(@productIds, ',') AS product_id_table 
			ON product.product_id = product_id_table.[value]
	ORDER BY product_id_table.id
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductIdStringList TO VpWebApp 
GO

------



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
-- Author: Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, vendor_name varchar(100), price money, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL
		, show_in_matrix bit, show_detail_page bit)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

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
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE  
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row, '
	
	SET @query = @query + 'parent_product_id, product_name, [rank], has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page

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
		search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdPageList TO VpWebApp
GO

-------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdProductIdsList
	@categoryId int,
	@productIds varchar(100),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : nilushi
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #vendor_product (id int identity(1,1), product_id int, product_name varchar(512), 
		vendor_id int)

	INSERT INTO #vendor_product (product_id, product_name, vendor_id)
	SELECT product.product_id, product.product_name, product_to_vendor.vendor_id
	FROM product 
		INNER JOIN product_to_category 
			ON product.product_id = product_to_category.product_id 
		INNER JOIN product_to_vendor 
			ON product.product_id = product_to_vendor.product_id AND 
				product_to_vendor.is_manufacturer = 1 AND product_to_vendor.lead_enabled = 1
	WHERE product_to_category.category_id = @categoryId 
		AND
		product.product_id NOT IN 
			(SELECT [value] FROM global_Split(@productIds, ','))
		AND 
		product_to_vendor.vendor_id NOT IN 
			(SELECT vendor_id FROM product_to_vendor WHERE product_to_vendor.product_id IN 
				(SELECT [value] FROM global_Split(@productIds, ',')))
		AND product.enabled = 1 AND product_to_category.enabled = 1 
		AND product_to_vendor.enabled = 1
		AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)
	ORDER BY product_to_vendor.vendor_id, product.product_name

	SELECT product.product_id AS id, site_id, parent_product_id, product.product_name, [rank],
		has_image, catalog_number, product.[enabled], product.modified, product.created, 
		product_type, [status], has_related, has_model, completeness, 
		product.flag1, product.flag2, product.flag3, product.flag4, product.search_rank, product.search_content_modified, hidden, business_value, ignore_in_rapid,
		show_in_matrix, show_detail_page
	FROM #vendor_product 
		INNER JOIN (
			SELECT MIN(id) AS id
			FROM #vendor_product
			GROUP BY vendor_id
		) temp
			ON #vendor_product.id = temp.id
		INNER JOIN product 
			ON #vendor_product.product_id = product.product_id

	DROP TABLE #vendor_product
	
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdProductIdsList TO VpWebApp 
GO

-------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdStartIndexEndIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdStartIndexEndIndexList
	@siteId int,
	@startRowIndex int,
	@endRowIndex int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedProduct(id, row_id, site_id, product_Name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type
			, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4
			, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page)
	AS
	(
		SELECT  product_id AS id, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id, site_id, product_Name, [rank]
				, has_image, catalog_number, [enabled], modified, created, product_type
				, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4
				, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page
		FROM product
		WHERE site_id = @siteId AND enabled = 1 AND hidden = 0 AND product_type <> 3
	)

	SELECT id, site_id, product_Name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type
			, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4
			, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page
	FROM selectedProduct
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdStartIndexEndIndexList TO VpWebApp
GO

----------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdVendorIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdVendorIdList
	@categoryId int,
	@vendorId int
AS
-- ==========================================================================
-- Author: Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name, pro.[rank]
			, pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created, product_type, status
			, pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page

	FROM (
			SELECT product_id, site_id, parent_product_id, product_name, [rank]
				, has_image, catalog_number, enabled, modified, created, product_type
				, status, has_related, has_model
				, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
				,CASE
				WHEN((SELECT COUNT(product_id) 
				FROM vendor 
				INNER JOIN product_to_vendor
				ON vendor.vendor_id = product_to_vendor.vendor_id
				WHERE product_to_vendor.product_id = product.product_id AND ([rank] = 2 OR [rank] = 3)) > 0)
				THEN 1
				ELSE 2
				END payed
				FROM product
			) pro
			INNER JOIN product_to_category proCat
				ON pro.product_id = proCat.product_id AND pro.enabled = '1' AND proCat.enabled = '1'
			INNER JOIN product_to_vendor proVen
				ON pro.product_id = proVen.product_id AND proVen.enabled = '1'
	WHERE proCat.category_Id = @categoryId AND proVen.vendor_Id = @vendorId AND payed = 2

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdVendorIdList TO VpWebApp 
GO

-------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetRandomizedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetRandomizedProducts
	@siteId int,
	@products varchar(1000),
	@numberofProducts int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@numberofProducts) product_id as id, site_id, product_Name, rank
			, has_image, catalog_number, [enabled], modified, created, product_type, status
			, has_related, has_model, flag1, flag2, flag3, flag4, search_rank, completeness, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page
	FROM product 
	WHERE site_id = @siteId AND [enabled] = 1 AND product_id IN (Select [value] FROM global_Split(@products, ',')) AND
		(
			(flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR 
			(flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0)
		)
	ORDER BY newid()

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetRandomizedProducts TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetArticleAssociatedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetArticleAssociatedProducts
	@articleId int,
	@numberOfSlots int,
	@siteId int,
	@addedProducts varchar(1000),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT  TOP (@numberOfSlots) p.product_id as id, p.site_id, p.product_Name, p.[rank], p.has_image
		, p.catalog_number, p.[enabled], p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
		, p.show_in_matrix, p.show_detail_page
		, p.completeness, content_to_content_id, content_id, content_type_id
		, associated_content_id, associated_content_type_id, associated_site_id
	FROM content_to_content cc 
		INNER JOIN product p 
			ON cc.associated_content_id = p.product_id AND associated_content_type_id = 2
	WHERE cc.content_id = @articleId AND cc.enabled = 1 AND content_type_id = 4 
		AND p.enabled=1 AND cc.site_id = @siteId AND
		(
			(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
			(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
		)
		AND p.product_id NOT IN  (Select [value] FROM global_Split(@addedProducts, ','))
	ORDER BY newid()

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetArticleAssociatedProducts TO VpWebApp 
GO

------


EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductsArticleRelatedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductsArticleRelatedCategories
	@numberofProducts int,
	@articleId int,
	@siteId int,
	@addedProducts varchar(1000),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	

	SELECT TOP (@numberofProducts)  p.product_id as id, p.site_id, p.product_Name, p.[rank], p.has_image
		, p.catalog_number, p.[enabled], p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
		, p.show_in_matrix, p.show_detail_page
		, p.completeness, pc.product_to_category_id, pc.category_id, pc.product_id, ROUND(RAND() * 10000, 0) as randomId
	FROM product_to_category pc
		INNER JOIN product p
			ON p.product_id = pc.product_id
				AND p.enabled = 1
	WHERE pc.enabled = 1 AND pc.category_id IN 
	(

		SELECT associated_content_id
		FROM content_to_content
		WHERE content_id = @articleId AND content_type_id = 4 AND enabled = 1 
		AND associated_content_type_id = 1 AND site_id = @siteId 

	)  
	AND
	(
		(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
		(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
	)
	AND p.product_id NOT IN  (Select [value] FROM global_Split(@addedProducts, ','))
	ORDER BY randomId


END

GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductsArticleRelatedCategories TO VpWebApp 
GO


----


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
		search_rank int NOT NULL DEFAULT ((50)),
		search_content_modified bit,
		hidden bit,
		business_value int,
		ignore_in_rapid bit,
		show_in_matrix bit,
		show_detail_page bit

	)

	

	INSERT INTO #TempProductList
	
		SELECT DISTINCT p.product_id as id, p.site_id as site_id, p.product_name as product_name, ROW_NUMBER() OVER (ORDER BY product_Name) AS row_id
						, p.rank as rank 
						, p.has_image as has_image, p.catalog_number as catalog_number, p.enabled as enabled, p.modified as modified
						, p.created as created, p.product_type as product_type, p.status as status, p.has_related as has_related, p.has_model as has_model
						, p.completeness as completeness, p.flag1, p.flag2, p.flag3, p.flag4
						, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page

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

		WHERE p.enabled = 1 AND ptc.category_id = @categoryId AND ptv.vendor_id <> @vendorId AND (COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) = 1 OR COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) IS NULL)
			  AND (vpVENDOR.vendor_parameter_value = 1 OR vpVENDOR.vendor_parameter_value IS NULL) AND (vpALL.vendor_parameter_value = 0 OR vpALL.vendor_parameter_value IS NULL)
			  AND (vpPRODUCT.product_parameter_value = 0 OR vpPRODUCT.product_parameter_value IS NULL)
		
		
		SELECT id, site_id, product_Name, [rank], has_image, catalog_number
			, [enabled], modified, created, product_type, status, has_related, has_model
			, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page

		FROM #TempProductList
		WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

		
		SELECT @totalRowCount = COUNT(*)
		FROM  #TempProductList

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList TO VpWebApp 
GO
--------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList
	@categoryId int,
	@manufacturerId int,
	@productId int,
	@startRowIndex int,
	@endRowIndex int,
	@partialLeadEnabled bit,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@totalRowCount int output
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH ProductList AS
	(
		SELECT product.product_id as id, site_id, product_Name, ROW_NUMBER() OVER (ORDER BY product_Name) AS row_id, [rank]
				, has_image, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page
		FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id AND product_to_vendor.enabled = '1' 
						AND product_to_vendor.is_manufacturer = 1
		WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id = @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1
				AND
				(
					(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
					(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
				)
				AND (product.product_id IN (SELECT content_id FROM action_url) 
				OR 
				(@partialLeadEnabled IS NULL OR product_to_vendor.lead_enabled = @partialLeadEnabled))
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled]
			 , modified, created, product_type, status,  has_related, has_model, completeness
			 , flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM ProductList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(*)
	FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id AND product_to_vendor.enabled = '1' 
						AND product_to_vendor.is_manufacturer = 1
		WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id = @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1
				AND
				(
					(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
					(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
				)
				AND (product.product_id IN (SELECT content_id FROM action_url) 
				OR 
				(@partialLeadEnabled IS NULL OR product_to_vendor.lead_enabled = @partialLeadEnabled))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList TO VpWebApp 
GO