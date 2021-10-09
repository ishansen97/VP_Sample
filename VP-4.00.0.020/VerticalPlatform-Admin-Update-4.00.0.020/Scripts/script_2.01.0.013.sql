
--- site_id
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[rapid_job]') AND name = 'site_id' )
BEGIN
	ALTER TABLE [dbo].[rapid_job] 
	ADD site_id INT NOT NULL CONSTRAINT con_rapid_job_site_id DEFAULT 37,
	FOREIGN KEY(site_id) REFERENCES dbo.site(site_id);

	ALTER TABLE [rapid_job]
	DROP CONSTRAINT con_rapid_job_site_id
END
GO



--==== adminRapidJob_AddRapidJob

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
		site_id
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
		@site_id
	);

	SET @id = SCOPE_IDENTITY();

END;
GO


GRANT EXECUTE ON dbo.adminRapidJob_AddRapidJob TO VpWebApp;
GO


--==== adminRapidJob_UpdateRapidJob

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
		modified = @modified
	WHERE rapid_job_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_UpdateRapidJob TO VpWebApp 
GO


--==== publicRapidJob_GetRapidJob

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
			modified,
			created
	FROM rapid_job 
	WHERE rapid_job_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidJob_GetRapidJob TO VpWebApp 
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
			rj.site_id,
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


--==== adminRapidJob_GetQueuedRapidJobForProductionPush

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetQueuedRapidJobForProductionPush'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_GetQueuedRapidJobForProductionPush]	
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
	j.site_id

	FROM rapid_task T
	INNER JOIN rapid_job J ON J.rapid_job_id = T.rapid_job_id
	
	WHERE 
	T.rapid_status_id = 2 -- Queue
	AND
	(
	T.rapid_task_type_id = 1 OR  -- Update
	T.rapid_task_type_id = 2 OR  -- Update Plus
	T.rapid_task_type_id = 3 OR  -- Insert
	T.rapid_task_type_id = 4     -- Delete
	)
	ORDER BY J.order_by
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidJobForProductionPush TO VpWebApp 
GO

--==== adminRapidJob_GetQueuedRapidJobForReporting

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
	J.site_id

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

--==== adminRapidJob_GetQueuedCleanupJob

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
J.site_id
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

--==== adminRapidJob_GetRapidJobsByState

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetRapidJobsByState'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetRapidJobsByState
	@rapid_state_id int
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
			site_id
	FROM rapid_job 
	WHERE rapid_state_id = @rapid_state_id


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidJobsByState TO VpWebApp 
GO


--==== adminRapidJob_GetReportRapidJobs
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
			site_id
	FROM rapid_job 
	WHERE rapid_state_id = 1
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetReportRapidJobs TO VpWebApp 
GO

--==== adminRapidJob_GetProductionPushRapidJobs
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
			site_id
	FROM rapid_job 
	WHERE rapid_state_id = 2
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetProductionPushRapidJobs TO VpWebApp 
GO

--===== adminRapidJob_GetCleanUpRapidJobs
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
			site_id
	FROM rapid_job 
	WHERE rapid_state_id = 4
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetCleanUpRapidJobs TO VpWebApp 
GO

--===== adminRapidJob_GetCompletedRapidJobs

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetCompletedRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetCompletedRapidJobs
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
			site_id
	FROM rapid_job 
	WHERE rapid_state_id = 3
	ORDER BY modified DESC

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetCompletedRapidJobs TO VpWebApp 
GO


