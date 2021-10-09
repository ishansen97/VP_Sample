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
	WHERE is_synced = 'true'

	END
GO

GRANT EXECUTE ON dbo.adminRapid_GetSyncedJobs TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidProductUpdateJobByJobId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidProductUpdateJobByJobId
	@jobId INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(1) rapid_product_update_job_id as id, enabled, created, modified, is_synced, rapid_job_id FROM rapid_product_update_job
	WHERE rapid_job_id = @jobId AND is_synced = 'true'

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidProductUpdateJobByJobId TO VpWebApp 
GO
------------------------------------------------------------------------------


--===== adminRapidJob_GetRapidJobMaxOrder

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetRapidJobMaxOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetRapidJobMaxOrder

AS
-- ==========================================================================
-- $Author: madushan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ISNULL(MAX(order_by),0)  AS [order] FROM rapid_job;

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidJobMaxOrder TO VpWebApp 
GO


--==== adminRapidJob_GetQueuedRapidJobs


EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetQueuedRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetQueuedRapidJobs
AS
-- ==========================================================================
-- Author: Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT	TOP(1) rj.rapid_job_id as id,
			rj.vendor_id,
			rj.rapid_status_id,
			rj.rapid_state_id,
			rj.data_file_name,
			rj.rule_file,
			rj.order_by,
			rj.emails,
			rj.modified,
			rj.enabled,
			rj.is_error,
			rj.error_message,
			rj.created
	FROM rapid_job rj
	INNER JOIN dbo.rapid_task rt ON rt.rapid_job_id = rj.rapid_job_id
	WHERE rt.rapid_task_type_id = 5 --reporting
	AND	rt.rapid_status_id = 2 --queued
	AND	rj.rapid_status_id = 2 --queued
	AND	rj.rapid_state_id = 1 --reporting
	ORDER BY rj.rapid_job_id

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidJobs TO VpWebApp 
GO

