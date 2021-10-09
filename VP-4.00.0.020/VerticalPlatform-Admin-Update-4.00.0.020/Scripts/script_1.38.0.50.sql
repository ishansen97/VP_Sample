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
-- Author : Sahan Diasena
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
	OPTION(OPTIMIZE FOR (@siteId = 37))
	
	SELECT @totalCount = COUNT(*)
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1 AND hidden = 0
	OPTION(OPTIMIZE FOR (@siteId = 37))
	
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsToIndexInSearchProviderList TO VpWebApp 
GO

-------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList
	@siteId int,
	@batchSize int,
	@totalCount int OUTPUT
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) scs.search_content_status_id AS id, scs.site_id, scs.content_type_id, scs.content_id, scs.[enabled], scs.created, scs.modified
	FROM search_content_status scs
		INNER JOIN product p
			ON scs.content_id = p.product_id
	WHERE scs.content_type_id = 2 AND scs.site_id = @siteId AND (p.enabled = 0 OR p.hidden = 1)
	OPTION(OPTIMIZE FOR (@siteId = 37))
		
	SELECT @totalCount = COUNT(*)
	FROM search_content_status scs
		INNER JOIN product p
			ON scs.content_id = p.product_id
	WHERE scs.content_type_id = 2 AND scs.site_id = @siteId AND (p.enabled = 0 OR p.hidden = 1)
	OPTION(OPTIMIZE FOR (@siteId = 37))

END
GO

GRANT EXECUTE ON dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList TO VpWebApp 
GO
