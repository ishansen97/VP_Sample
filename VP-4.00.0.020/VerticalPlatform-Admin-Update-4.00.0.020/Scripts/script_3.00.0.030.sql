
--==== adminRapidJob_GetCompletedRapidJobs
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetCompletedRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetCompletedRapidJobs
 @startRowIndex int,  
 @endRowIndex int,  
 @totalRowCount int output  
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row , rapid_job_id AS id
	INTO #temp_rapid_jobs FROM [dbo].[rapid_job] ar WITH(NOLOCK) 
		WHERE rapid_state_id = 3

	SELECT 
	rj.rapid_job_id as id,
	rj.vendor_id,
	rj.rapid_status_id,
	rj.rapid_state_id,
	rj.data_file_name,
	rj.rule_file,
	rj.order_by,
	rj.emails,
	rj.enabled,
	rj.is_error,
	rj.error_message,
	rj.modified,
	rj.created,
	rj.site_id
	FROM rapid_job rj
	INNER JOIN  #temp_rapid_jobs trj ON trj.id = rj.rapid_job_id 
	WHERE row BETWEEN @startRowIndex AND @endRowIndex  
	ORDER BY trj.row

	SELECT @totalRowCount = COUNT(*)  
	FROM #temp_rapid_jobs

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetCompletedRapidJobs TO VpWebApp 
GO


--==== adminRapidJob_GetRapidTaskByJobIdAndTaskType
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetRapidTaskByJobIdAndTaskType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetRapidTaskByJobIdAndTaskType
	@rapidJobId int,
	@rapidTaskType int
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [rapid_task_id] AS id
		,[rapid_job_id]
		,[rapid_status_id]
		,[rapid_task_type_id]
		,[start_time]
		,[end_time]
		,[enabled]
		,is_error
		,error_message
		,inserted_records
		,updated_records
		,deleted_records
		,error_records
		,[modified]
		,[created]
		,report_path
	FROM dbo.rapid_task
	WHERE rapid_job_id = @rapidJobId AND 
	rapid_task_type_id = @rapidTaskType


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidTaskByJobIdAndTaskType TO VpWebApp 
GO


