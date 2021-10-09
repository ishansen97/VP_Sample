-------- Add report path to the Rapid task table

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'report_path'
          AND Object_ID = Object_ID(N'rapid_task'))
BEGIN
    ALTER TABLE dbo.rapid_task
    ADD report_path VARCHAR(1000)	
END
GO




--===== adminRapidTask_UpdateRapidTask


EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateRapidTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateRapidTask]
	@id INT OUTPUT,
	@rapid_job_id INT,
    @rapid_status_id INT,
    @rapid_task_type_id INT,
	@start_time smalldatetime,
	@end_time smalldatetime,
	@enabled BIT,
	@is_error BIT,
	@error_message VARCHAR(1000),
	@inserted_records INT,
	@updated_records INT,
	@deleted_records INT,
	@error_records INT,
	@report_path VARCHAR(1000),
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Deshapriya
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.rapid_task
	SET rapid_job_id = @rapid_job_id,
		rapid_status_id = @rapid_status_id,
		rapid_task_type_id = @rapid_task_type_id,
		start_time = @start_time,
		end_time = @end_time,
		enabled = @enabled,
		is_error = @is_error,
		error_message  = @error_message,
		inserted_records  = @inserted_records,
		updated_records  = @updated_records,
		deleted_records  = @deleted_records,
		error_records  = @error_records,
		report_path = @report_path,
		modified = @modified
	WHERE rapid_task_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidTask TO VpWebApp
GO



--===== adminRapidTask_AddRapidTask


EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_AddRapidTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_AddRapidTask]
    @rapid_job_id INT,
    @rapid_status_id INT,
    @rapid_task_type_id INT,
	@start_time smalldatetime,
	@end_time smalldatetime,
	@enabled BIT,
	@is_error BIT,
	@error_message VARCHAR(1000),
	@inserted_records INT,
	@updated_records INT,
	@deleted_records INT,
	@error_records INT,
	@report_path VARCHAR(1000),
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Deshapriya
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()

	INSERT INTO rapid_task
	(
		rapid_job_id,
		rapid_status_id,
		rapid_task_type_id,
		start_time,
		end_time,
		enabled,
		is_error,
		error_message,
		inserted_records,
		updated_records,
		deleted_records,
		error_records,
		report_path,
		modified,
		created
	)
	VALUES
	(
		@rapid_job_id,
		@rapid_status_id,
		@rapid_task_type_id,
		@start_time,
		@end_time,
		@enabled,
		@is_error,
		@error_message,
		@inserted_records,
		@updated_records,
		@deleted_records,
		@error_records,
		@report_path,
		@created,
		@created
	);

	SET @id = SCOPE_IDENTITY();

END
GO

GRANT EXECUTE ON dbo.adminRapidTask_AddRapidTask TO VpWebApp
GO



--===== publicRapidTask_GetRapidTask


EXEC dbo.global_DropStoredProcedure 'dbo.publicRapidTask_GetRapidTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicRapidTask_GetRapidTask]
@id int
	
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT	rapid_task_id as id,
			rapid_job_id,
			rapid_status_id,
			rapid_task_type_id,
			start_time,
			end_time,
			enabled,
			is_error,
			error_message,
			inserted_records,
			updated_records,
			deleted_records,
			error_records,
			report_path,
			modified,
			created
	FROM rapid_task 
	WHERE rapid_task_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidTask_GetRapidTask TO VpWebApp
GO




--===== adminRapidTask_UpdateRapidReportTask


EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateRapidReportTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateRapidReportTask]
	@id INT,
    @rapid_status_id INT,
	@duration DECIMAL (14,2),
	@inserted_records INT,
	@updated_records INT,
	@deleted_records INT,
	@error_records INT,
	@error_message VARCHAR,
	@is_error BIT,
	@report_path VARCHAR(1000)

AS
-- ==========================================================================
-- Author : Deshapriya
-- ==========================================================================
BEGIN

	DECLARE @endtime DATETIME = GETDATE()
	UPDATE dbo.rapid_task
	SET rapid_status_id = @rapid_status_id,	
	start_time = DATEADD(second, -@duration, @endtime),	
	end_time = @endtime,	
	inserted_records = @inserted_records,
	updated_records = @updated_records,
	deleted_records = @deleted_records,
	error_records = @error_records,
	error_message = @error_message,
	is_error = @is_error,
	modified = @endtime,
	report_path = @report_path
	WHERE rapid_task_id = @id
		
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidReportTask TO VpWebApp
GO




--===== adminRapidJob_GetRapidTasksByRapidJobId


EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetRapidTasksByRapidJobId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_GetRapidTasksByRapidJobId]
	@rapidJobId int
AS
-- ==========================================================================
-- Author: Chinthaka
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
		,report_path
		,[modified]
		,[created]
	FROM dbo.rapid_task
	WHERE rapid_job_id = @rapidJobId


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidTasksByRapidJobId TO VpWebApp
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
	SELECT	rj.rapid_job_id,
			rj.vendor_id
	INTO #tmp_rapid_jobs
	FROM rapid_job rj
	INNER JOIN dbo.rapid_task rt ON rt.rapid_job_id = rj.rapid_job_id
	WHERE rt.rapid_task_type_id = 5 --reporting
	AND	rt.rapid_status_id = 2 --queued
	AND	rj.rapid_status_id = 2 --queued
	AND	rj.rapid_state_id = 1 --reporting
	ORDER BY rj.rapid_job_id

	SELECT DISTINCT tmp.rapid_job_id
	INTO #tmp_not_synced_jobs
	FROM #tmp_rapid_jobs tmp
	INNER JOIN dbo.product_to_vendor ptv WITH(NOLOCK) ON ptv.vendor_id = tmp.vendor_id
	INNER JOIN dbo.product pro WITH(NOLOCK) ON pro.product_id = ptv.product_id
	WHERE pro.content_modified = 1

	SELECT TOP(1) rj.rapid_job_id as id,
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
			rj.site_id,
			rj.created
	FROM #tmp_rapid_jobs trj
	INNER JOIN rapid_job rj ON rj.rapid_job_id = trj.rapid_job_id
	LEFT JOIN #tmp_not_synced_jobs nsj ON nsj.rapid_job_id = trj.rapid_job_id
	WHERE nsj.rapid_job_id IS NULL
	ORDER BY rj.rapid_job_id

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidJobs TO VpWebApp 
GO

