
--====  adminPlatform_GetUnindexedProductIdsBySiteId

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
	FROM product p WITH(NOLOCK)
	WHERE p.site_id = @siteId
		AND p.[enabled] = 1
		AND p.hidden = 0
		AND p.product_id NOT IN (
			SELECT content_id
			FROM search_content_status scs WITH(NOLOCK)
			WHERE scs.site_id = @siteId
				AND scs.content_type_id = 2
		)
	
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductIdsBySiteId TO VpWebApp
GO


--==== adminSearch_GetDeletedOrDisabledProductSearchContentsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminSearch_GetDeletedOrDisabledProductSearchContentsList]
	@siteId int,
	@batchSize int,
	@lastSuccessfulRunDate smalldatetime,
	@totalCount int OUTPUT
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON
	
	SET @lastSuccessfulRunDate = DATEADD(DAY, -1, @lastSuccessfulRunDate);

	SELECT scs.search_content_status_id
	into #tmp_all_products
	FROM search_content_status scs WITH(NOLOCK)
		INNER JOIN product p WITH(NOLOCK)
			ON scs.content_id = p.product_id
	WHERE scs.content_type_id = 2 
		AND scs.site_id = @siteId 
		AND (p.enabled = 0 OR p.hidden = 1) 
		AND p.modified > @lastSuccessfulRunDate
	OPTION(OPTIMIZE FOR (@siteId = 37))

	SELECT @totalCount = count(1)
	from #tmp_all_products

	SELECT TOP(@batchSize) scs.search_content_status_id AS id, scs.site_id, scs.content_type_id, scs.content_id, scs.[enabled], scs.created, scs.modified
	FROM search_content_status scs WITH(NOLOCK)
		INNER JOIN #tmp_all_products p WITH(NOLOCK)
			ON scs.search_content_status_id = p.search_content_status_id

END

GO

GRANT EXECUTE ON dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList TO VpWebApp 
GO

