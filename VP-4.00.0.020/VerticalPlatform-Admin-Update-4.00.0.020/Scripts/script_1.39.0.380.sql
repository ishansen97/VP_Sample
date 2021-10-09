EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET XACT_ABORT ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsBySiteId
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) p.[product_id] AS [id],p.[site_id],p.[parent_product_id],p.[product_name],p.[rank],p.[has_image]
		,p.[catalog_number],p.[enabled],p.[modified],p.[created],p.[product_type],p.[status],p.[has_model]
		,p.[has_related],p.[flag1],p.[flag2],p.[flag3],p.[flag4],p.[completeness],p.[search_rank],p.[legacy_content_id]
		,p.[search_content_modified],p.[hidden],p.[business_value],p.[ignore_in_rapid],p.[show_in_matrix]
		,p.[show_detail_page],p.[default_rank],p.[default_search_rank]
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
	OPTION (OPTIMIZE FOR (@siteId = 37))
	
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteId TO VpWebApp
GO
