--====== adminProduct_GetArchivingProductIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10,
@lastProcessedProductId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) pro.[product_id] AS [id]
	FROM	product pro
			LEFT JOIN lead ld on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
			LEFT JOIN dbo.product_to_product ptp ON ptp.parent_product_id = pro.product_id
	WHERE	pro.search_content_modified = 0 --elastic search processed
			--AND pro.content_modified = 0 --content update synced --todo temporary removed 
			AND pro.enabled = 0
			AND pro.archived = 1 
			AND (ld.lead_id IS NULL OR ld.lead_state_type_id = 7) --lead sent
			AND (ptp.product_to_product_id IS NULL) --not parent product
			AND pro.product_id > @lastProcessedProductId
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO


--====== adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts]
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
	
	UPDATE TOP(@batchSize) pro 
	SET pro.search_content_modified = 0
	FROM	dbo.product pro WITH(NOLOCK)
	LEFT JOIN search_content_status scs WITH(NOLOCK) ON scs.content_id = pro.product_id AND scs.content_type_id = 2
	WHERE scs.search_content_status_id IS NULL
	AND pro.site_id = @siteId
	AND	pro.enabled = 0
	AND pro.search_content_modified = 1
	AND pro.modified > @lastSuccessfulRunDate

	SET @totalCount = @@ROWCOUNT

END

GO

GRANT EXECUTE ON dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts TO VpWebApp 
GO



--===== adminSearch_DeleteSearchContentStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteSearchContentStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteSearchContentStatus
	@id int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	--updating aricle search content modified flag
	UPDATE art
	SET art.search_content_modified = 0
		,art.modified = GETDATE()
	FROM dbo.article art
	INNER JOIN search_content_status acs ON acs.content_id = art.article_id
	WHERE acs.content_type_id = 4 --article
	AND acs.search_content_status_id = @id


	DELETE FROM search_content_status
	WHERE search_content_status_id= @id

END
GO

GRANT EXECUTE ON adminSearch_DeleteSearchContentStatus TO VpWebApp

--==== adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts]
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
	
	UPDATE TOP(@batchSize) pro 
	SET pro.search_content_modified = 0
		,pro.modified = GETDATE()
	FROM	dbo.product pro WITH(NOLOCK)
	LEFT JOIN search_content_status scs WITH(NOLOCK) ON scs.content_id = pro.product_id AND scs.content_type_id = 2
	WHERE scs.search_content_status_id IS NULL
	AND pro.site_id = @siteId
	AND	pro.enabled = 0
	AND pro.search_content_modified = 1
	AND pro.modified > @lastSuccessfulRunDate

	SET @totalCount = @@ROWCOUNT

END

GO

GRANT EXECUTE ON dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts TO VpWebApp 
GO


