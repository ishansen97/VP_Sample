EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductsModifiedSince'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductsModifiedSince
	@modifiedSince smalldatetime,
	@startIndex int,
	@endIndex int,
	@siteId int
AS
-- ==========================================================================

-- $Author: Akila$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_Products (row, id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY product_id) AS row, product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product
		WHERE modified > @modifiedSince AND site_id = @siteId AND [enabled] = 1
		
	)

	SELECT id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM temp_Products
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductsModifiedSince TO VpWebApp 
GO

----------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoriesByProductIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoriesByProductIds	
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author : Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id, product_id
	FROM category AS cat
		INNER JOIN product_to_category
			ON cat.category_id = product_to_category.category_id
	WHERE (product_to_category.product_id IN 
		(SELECT [value] FROM dbo.global_Split(@productIds, ','))) AND (cat.[enabled] = 1)

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoriesByProductIds TO VpWebApp 
GO

----------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetAllVendorsByProductIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetAllVendorsByProductIds	
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author : Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ven.vendor_id as id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified,ven.created, ven.parent_vendor_id, ven.vendor_keywords, product_id, ven.internal_name, ven.[description]
	FROM vendor ven
		INNER JOIN product_to_vendor
			ON ven.vendor_id = product_to_vendor.vendor_id
	WHERE (product_to_vendor.product_id IN 
		(SELECT [value] FROM dbo.global_Split(@productIds, ',')))

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetAllVendorsByProductIds TO VpWebApp 
GO

