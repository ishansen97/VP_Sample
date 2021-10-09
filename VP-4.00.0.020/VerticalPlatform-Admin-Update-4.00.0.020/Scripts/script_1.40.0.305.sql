EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList
	@siteId int,
	@batchSize int,
	@lastSuccessfulRunDate smalldatetime,
	@totalCount int OUTPUT
AS
-- ==========================================================================
-- $Author: Akila Tharuka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) scs.search_content_status_id AS id, scs.site_id, scs.content_type_id, scs.content_id, scs.[enabled], scs.created, scs.modified
	FROM search_content_status scs
		INNER JOIN product p
			ON scs.content_id = p.product_id
	WHERE scs.content_type_id = 2 AND scs.site_id = @siteId AND (p.enabled = 0 OR p.hidden = 1)  AND p.modified > @lastSuccessfulRunDate
	OPTION(OPTIMIZE FOR (@siteId = 37))
		
	SELECT @totalCount = COUNT(*)
	FROM search_content_status scs
		INNER JOIN product p
			ON scs.content_id = p.product_id
	WHERE scs.content_type_id = 2 AND scs.site_id = @siteId AND (p.enabled = 0 OR p.hidden = 1)  AND p.modified > @lastSuccessfulRunDate
	OPTION(OPTIMIZE FOR (@siteId = 37))

END
GO

GRANT EXECUTE ON dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList TO VpWebApp 
GO
