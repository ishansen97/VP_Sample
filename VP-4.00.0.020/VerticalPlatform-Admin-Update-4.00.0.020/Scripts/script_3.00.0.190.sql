
--------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [rapid_task_type] WHERE [rapid_task_type_id] = 15)
BEGIN

	INSERT INTO [rapid_task_type] ([rapid_task_type_id],[rapid_task_type],[modified],[created])
  VALUES (15,'ReportingReEnabledReport',GETDATE(),GETDATE())

END
GO

IF NOT EXISTS (SELECT 1 FROM [rapid_task_type] WHERE [rapid_task_type_id] = 16)
BEGIN

	INSERT INTO [rapid_task_type] ([rapid_task_type_id],[rapid_task_type],[modified],[created])
  VALUES (16,'ReportingIgnoredSearchOptionReport',GETDATE(),GETDATE())

END
GO

IF NOT EXISTS (SELECT 1 FROM [rapid_task_type] WHERE [rapid_task_type_id] = 17)
BEGIN

	INSERT INTO [rapid_task_type] ([rapid_task_type_id],[rapid_task_type],[modified],[created])
  VALUES (17,'ReportingIgnoredInRapidReport',GETDATE(),GETDATE())

END
GO

--------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM [rapid_task_effected_record_count_type] WHERE [rapid_task_effected_record_count_type_id] = 8)
BEGIN

	INSERT INTO [rapid_task_effected_record_count_type] ([rapid_task_effected_record_count_type_id],[name],[created],[modified])
  VALUES (8,'IgnoredSearchOptionProductCount',GETDATE(),GETDATE())

END
GO

--------------is_warning--------------------------------------------------------------------------------------------------

IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[rapid_job]') AND name = 'is_warning' )
BEGIN
	ALTER TABLE [dbo].[rapid_job] ADD is_warning BIT NOT NULL DEFAULT 0
END
GO

--------------warning_message--------------------------------------------------------------------------------------------------

IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[rapid_job]') AND name = 'warning_message' )
BEGIN
	ALTER TABLE [dbo].[rapid_job] ADD warning_message VARCHAR (1000) NULL
END
GO

--------------adminRapidJob_AddRapidJob--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'adminRapidJob_AddRapidJob';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminRapidJob_AddRapidJob]
    @vendor_id INT,
    @rapid_status_id INT,
    @rapid_state_id INT,
    @data_file_name VARCHAR(1000),
    @rule_file VARCHAR(MAX),
    @order_by INT,
    @emails VARCHAR(1000),
	@enabled bit,
	@is_error BIT,
	@error_message VARCHAR(1000),
	@site_id INT,
	@is_warning BIT,
	@warning_message VARCHAR(1000),
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()

	INSERT INTO rapid_job
	(
		vendor_id,
		rapid_status_id,
		rapid_state_id,
		data_file_name,
		rule_file,
		order_by,
		emails,
		enabled,
		is_error,
		error_message,
		modified,
		created,
		site_id,
		is_warning,
		warning_message
	)
	VALUES
	(
		@vendor_id,
		@rapid_status_id,
		@rapid_state_id,
		@data_file_name,
		@rule_file,
		@order_by,
		@emails,
		@enabled,
		@is_error,
		@error_message,
		@created,
		@created,
		@site_id,
		@is_warning,
		@warning_message
	);

	SET @id = SCOPE_IDENTITY();

END;
GO


GRANT EXECUTE ON dbo.adminRapidJob_AddRapidJob TO VpWebApp;
GO

--------------adminRapidJob_GetCleanUpRapidJobs--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetCleanUpRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetCleanUpRapidJobs
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT rapid_job_id as id,
			vendor_id,
			rapid_status_id,
			rapid_state_id,
			data_file_name,
			rule_file,
			order_by,
			emails,
			enabled,
			is_error,
			error_message,
			modified,
			created,
			site_id,
			is_warning,
			warning_message
	FROM rapid_job 
	WHERE rapid_state_id = 4
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetCleanUpRapidJobs TO VpWebApp 
GO

--------------adminRapidJob_GetCompletedRapidJobs--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetCompletedRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetCompletedRapidJobs
 @startRowIndex int,  
 @endRowIndex int,  
 @vendorId int,
 @siteId int,
 @fromDate date,
 @toDate date,
 @totalRowCount int output  
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row , rapid_job_id AS id
	INTO #temp_rapid_jobs FROM [dbo].[rapid_job] ar WITH(NOLOCK) 
		WHERE rapid_state_id = 3 AND 
		((@vendorId IS NULL OR vendor_id = @vendorId)
		AND
		(@siteId IS NULL OR site_id = @siteId)
		AND
		(@fromDate IS NULL OR created >= @fromDate)
		AND
		(@toDate IS NULL OR created < (DATEADD(DAY,1,@toDate))))

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
	rj.site_id,
	rj.is_warning,
	rj.warning_message
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

--------------adminRapidJob_GetProductionPushRapidJobs--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetProductionPushRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetProductionPushRapidJobs
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT rapid_job_id as id,
			vendor_id,
			rapid_status_id,
			rapid_state_id,
			data_file_name,
			rule_file,
			order_by,
			emails,
			enabled,
			is_error,
			error_message,
			modified,
			created,
			site_id,
			is_warning,
			warning_message
	FROM rapid_job 
	WHERE rapid_state_id = 2
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetProductionPushRapidJobs TO VpWebApp 
GO

--------------adminRapidJob_GetQueuedCleanupJob--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetQueuedCleanupJob'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
		T2.rapid_task_type_id = 14    --ProductionPushErrorReport
	)
) 
ORDER BY J.rapid_job_id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedCleanupJob TO VpWebApp 
GO

--------------adminRapidJob_GetQueuedRapidJobForReporting--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetQueuedRapidJobForReporting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_GetQueuedRapidJobForReporting]	
AS
-- ==========================================================================
-- Author: Deshapriya
-- ==========================================================================
BEGIN

	SELECT TOP (1) 
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

	FROM rapid_task T
	INNER JOIN rapid_job J ON J.rapid_job_id = T.rapid_job_id
	
	WHERE 
	T.rapid_status_id = 2 -- Queue
	AND
	(
		T.rapid_task_type_id IN (7,8,9,10,11,12,13,14)	
	)
	ORDER BY J.order_by
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidJobForReporting TO VpWebApp 
GO

--------------adminRapidJob_GetQueuedRapidJobs--------------------------------------------------------------------------------------------------

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
			rj.is_warning,
			rj.warning_message,
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



--------------adminRapidJob_GetReportRapidJobs--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetReportRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetReportRapidJobs
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT rapid_job_id as id,
			vendor_id,
			rapid_status_id,
			rapid_state_id,
			data_file_name,
			rule_file,
			order_by,
			emails,
			enabled,
			is_error,
			error_message,
			modified,
			created,
			site_id,
			is_warning,
			warning_message
	FROM rapid_job 
	WHERE rapid_state_id = 1
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetReportRapidJobs TO VpWebApp 
GO

--------------adminRapidJob_ProcessQueuedRapidJobForProductionPush--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_ProcessQueuedRapidJobForProductionPush'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_ProcessQueuedRapidJobForProductionPush]	
AS
-- ==========================================================================
-- Author: Deshapriya
-- ==========================================================================
BEGIN

	SELECT TOP (1) 
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
	j.site_id,
	J.is_warning,
	J.warning_message
	INTO #tmp_prod_push_job
	FROM rapid_task T
	INNER JOIN rapid_job J ON J.rapid_job_id = T.rapid_job_id
	
	WHERE 
	T.rapid_status_id = 2 -- Queue
	AND	
	T.rapid_task_type_id IN (1,2,3,4)
	ORDER BY J.order_by
	
	UPDATE rj 
	SET  rj.rapid_status_id = 3
	FROM rapid_job rj INNER JOIN #tmp_prod_push_job tmp on rj.rapid_job_id = tmp.id
	
	SELECT * FROM #tmp_prod_push_job;
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_ProcessQueuedRapidJobForProductionPush TO VpWebApp 
GO

--------------adminRapidJob_UpdateRapidJob--------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'adminRapidJob_UpdateRapidJob';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminRapidJob_UpdateRapidJob]
	@id INT OUTPUT,
    @vendor_id INT,
    @rapid_status_id INT,
    @rapid_state_id INT,
    @data_file_name VARCHAR(1000),
    @rule_file VARCHAR(MAX),
    @order_by INT,
    @emails VARCHAR(1000),
	@enabled BIT,
	@is_error BIT,
	@error_message VARCHAR(1000),
	@site_id INT,
	@is_warning BIT,
	@warning_message VARCHAR(1000),
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.rapid_job
	SET vendor_id = @vendor_id,
		rapid_status_id = @rapid_status_id,
		rapid_state_id = @rapid_state_id,
		data_file_name = @data_file_name,
		rule_file = @rule_file,
		order_by = @order_by,
		emails = @emails,
		enabled = @enabled,
		is_error = @is_error,
		error_message = @error_message,
		site_id = @site_id,
		is_warning = @is_warning,
		warning_message = @warning_message,
		modified = @modified
	WHERE rapid_job_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_UpdateRapidJob TO VpWebApp 
GO


--------------publicRapidJob_GetRapidJob--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicRapidJob_GetRapidJob'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicRapidJob_GetRapidJob
@id int
	
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT	rapid_job_id as id,
			vendor_id,
			rapid_status_id,
			rapid_state_id,
			data_file_name,
			rule_file,
			order_by,
			emails,
			enabled,
			is_error,
			error_message,
			site_id,
			is_warning,
			warning_message, 
			modified,
			created
	FROM rapid_job 
	WHERE rapid_job_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidJob_GetRapidJob TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------------


-- adminRapidJob_GetQueuedRapidJobForReporting

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetQueuedRapidJobForReporting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_GetQueuedRapidJobForReporting]	
AS
-- ==========================================================================
-- Author: Deshapriya
-- ==========================================================================
BEGIN

	SELECT TOP (1) 
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

	FROM rapid_task T
	INNER JOIN rapid_job J ON J.rapid_job_id = T.rapid_job_id
	
	WHERE 
	T.rapid_status_id = 2 -- Queue
	AND
	(
		T.rapid_task_type_id IN (7,8,9,10,11,12,13,14,15,16,17)	
	)
	ORDER BY J.order_by
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidJobForReporting TO VpWebApp
GO
