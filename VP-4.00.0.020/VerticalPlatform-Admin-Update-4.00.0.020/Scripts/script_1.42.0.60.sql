----------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductsModifiedSince'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductsModifiedSince
	@modifiedSince smalldatetime,
	@startIndex int,
	@endIndex int,
	@siteId int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Ravindu$
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
	
	SELECT @totalCount = COUNT(*)
	FROM product
	WHERE modified > @modifiedSince AND site_id = @siteId AND [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoriesByProductIds TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------