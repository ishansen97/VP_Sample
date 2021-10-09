EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsToIndexInSearchProviderList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsToIndexInSearchProviderList
	@siteId int,
	@batchSize int,
	@totalCount int output
	
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1 AND hidden = 0
	ORDER BY product_id
	
	SELECT @totalCount = COUNT(*)
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1 AND hidden = 0
	
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsToIndexInSearchProviderList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedProduct(id, row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, 
		created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden,
		business_value,ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
)
	AS
	(
		SELECT  product_id, ROW_NUMBER() OVER (ORDER BY product_id DESC) AS row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified,
			created, product_type, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4, search_rank, search_content_modified
			, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product
		WHERE enabled = 1 AND site_id = @siteId AND hidden = 0
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status,
		has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
		show_in_matrix, show_detail_page, default_rank, default_search_rank

	FROM selectedProduct
	WHERE row_id BETWEEN @startIndex AND @endIndex
	ORDER BY row_id
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList TO VpWebApp
GO
