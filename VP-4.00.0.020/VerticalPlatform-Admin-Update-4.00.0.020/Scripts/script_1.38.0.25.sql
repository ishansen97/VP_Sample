
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCatalogNumber'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCatalogNumber
	@catalogNumber VARCHAR(255),
	@siteId INT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4
		, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product
	WHERE catalog_number = @catalogNumber
		AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductDetail TO VpWebApp 
GO
