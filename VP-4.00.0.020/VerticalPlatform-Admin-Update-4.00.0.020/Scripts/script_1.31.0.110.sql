EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_GetTaskBySiteIdStartIndexEndIndexTaskTypeTaskNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_GetTaskBySiteIdStartIndexEndIndexTaskTypeTaskNameList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@taskTypeId int,
	@taskStatus  int,
	@taskName varchar(255),
	@totalCount int output
AS
-- ==========================================================================
-- $Author:  Tharaka Wanigasekera
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY task_id) AS row, task_id AS id, task_name, site_id, 
		last_run_time, [status], task_type, notification_emails, [enabled], modified, created
	INTO #temp_task
	FROM task
	WHERE  (@siteId IS NULL OR site_id = @siteId) AND (@taskTypeId IS NULL OR task_type = @taskTypeId) AND
			(@taskName = '' OR task_name LIKE '%' + @taskName + '%') 
			AND	(@taskStatus IS NULL OR @taskStatus = (SELECT top 1 status_code FROM task_history
				WHERE task_id=task.task_id
				ORDER BY start_time desc))

	SELECT id, task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], 
		modified, created
	FROM #temp_task
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY created DESC

	SELECT @totalCount = COUNT(*)
	FROM #temp_task

END
GO

GRANT EXECUTE ON dbo.adminScheduler_GetTaskBySiteIdStartIndexEndIndexTaskTypeTaskNameList TO VpWebApp 
GO
-----------------------------------------------------------------------------