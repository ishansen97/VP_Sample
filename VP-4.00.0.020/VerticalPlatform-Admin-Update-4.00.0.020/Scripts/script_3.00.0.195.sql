
--------------adminRapidJob_GetQueuedCleanupJob--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'adminRapidJob_GetQueuedCleanupJob';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminRapidJob_GetQueuedCleanupJob]
	
AS
-- ==========================================================================
-- Author: Deshapriya
-- ==========================================================================
BEGIN


SELECT  TOP 1  
J.rapid_job_id as id,
J.vendor_id,
J.rapid_status_id,
J.rapid_state_id,
J.data_file_name,
J.rule_file,
J.order_by,
J.emails,
J.enabled,
J.is_error,
J.error_message,
J.modified,
J.created,
J.site_id,
J.is_warning,
J.warning_message

FROM dbo.rapid_job J
WHERE 		
EXISTS -- There should be a clean up task queued
(
	SELECT 1 FROM rapid_task T 
	WHERE T.rapid_job_id = J.rapid_job_id AND 
	T.rapid_task_type_id = 6 AND --Clean up
	T.rapid_status_id = 2 -- QUEUE 				
) 
AND
NOT EXISTS  -- check if there are any queued or in-progess manual report requests for the job
(
	SELECT 1 FROM rapid_task T2 
	WHERE T2.rapid_job_id = J.rapid_job_id AND 
	(T2.rapid_status_id = 2 OR T2.rapid_status_id = 3) AND -- QUEUE OR IN PROGESS
	(
		T2.rapid_task_type_id = 7 OR   --ReportingInsertReport
		T2.rapid_task_type_id = 8 OR   --ReportingUpdateReport
		T2.rapid_task_type_id = 9 OR   --ReportingDeleteReport
		T2.rapid_task_type_id = 10 OR   --ReportingErrorReport
		T2.rapid_task_type_id = 11 OR   --ProductionPushInsertReport
		T2.rapid_task_type_id = 12 OR   --ProductionPushUpdateReport
		T2.rapid_task_type_id = 13 OR   --ProductionPushDeleteReport
		T2.rapid_task_type_id = 14 OR   --ProductionPushErrorReport		
		T2.rapid_task_type_id = 15 OR    --Reportint Reenabled Report
		T2.rapid_task_type_id = 16 OR    --Reportint Ignored search option Report
		T2.rapid_task_type_id = 17    --Reportint Ignore in rapid Report
	)
) 
ORDER BY J.rapid_job_id
	
END;
GO


GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedCleanupJob TO VpWebApp;
GO


