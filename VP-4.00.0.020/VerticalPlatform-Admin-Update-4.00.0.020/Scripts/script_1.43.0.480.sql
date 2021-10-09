EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductIdsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET XACT_ABORT ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductIdsBySiteId
	@siteId int
AS
-- ==========================================================================
-- Author : Akila
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT p.[product_id] AS [id]
	FROM product p
	WHERE p.site_id = @siteId
		AND p.[enabled] = 1
		AND p.hidden = 0
		AND p.product_id NOT IN (
			SELECT content_id
			FROM search_content_status scs
			WHERE scs.site_id = @siteId
				AND scs.content_type_id = 2
		)
	
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductIdsBySiteId TO VpWebApp
GO

--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductIdsToIndexInSearchProviderList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductIdsToIndexInSearchProviderList
	@siteId int
	
AS
-- ==========================================================================
-- Author : Akila
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1 AND hidden = 0	
	
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductIdsToIndexInSearchProviderList TO VpWebApp 
GO
