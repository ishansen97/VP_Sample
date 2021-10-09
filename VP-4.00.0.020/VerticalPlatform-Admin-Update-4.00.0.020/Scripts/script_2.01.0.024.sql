EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetSyncedJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetSyncedJobs
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT rapid_product_update_job_id as id, enabled, created, modified, is_synced, rapid_job_id
	FROM rapid_product_update_job
	WHERE is_synced = 1

	END
GO

GRANT EXECUTE ON dbo.adminRapid_GetSyncedJobs TO VpWebApp 
GO

---------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus
	@limit int = 20,
	@status int,
	@jobId int,
	@rapidProductUpdateType int
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) rapid_product_update_id AS id, product_json, job_id, product_update_type, status,created,modified,enabled 
	FROM rapid_product_updates 
	WHERE Status = @status AND job_id = @jobId AND product_update_type=@rapidProductUpdateType
	ORDER BY rapid_product_update_id

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus TO VpWebApp 
GO
--------------------------------------------------------------------------------

GO
CREATE NONCLUSTERED INDEX [IX_rapid_product_updates_product_update_type]
ON [dbo].[rapid_product_updates] ([product_update_type])

GO