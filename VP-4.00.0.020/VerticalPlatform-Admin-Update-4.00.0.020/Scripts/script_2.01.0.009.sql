IF NOT EXISTS (SELECT 1 FROM rapid_task_type WHERE [rapid_task_type_id] = 7)
BEGIN
	insert into rapid_task_type ([rapid_task_type_id],[rapid_task_type],[modified],[created])
	values (7,'ReportingInsertReport',GETDATE(),GETDATE()),
	(8,'ReportingUpdateReport',GETDATE(),GETDATE()),
	(9,'ReportingDeleteReport',GETDATE(),GETDATE()),
	(10,'ReportingErrorReport',GETDATE(),GETDATE()),
	(11,'ProductionPushInsertReport',GETDATE(),GETDATE()),
	(12,'ProductionPushUpdateReport',GETDATE(),GETDATE()),
	(13,'ProductionPushDeleteReport',GETDATE(),GETDATE()),
	(14,'ProductionPushErrorReport',GETDATE(),GETDATE());

END
GO



-- ===============adminRapidJob_GetRapidTaskByJobIdAndTaskType=========================

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
	FROM dbo.rapid_task
	WHERE rapid_job_id = @rapidJobId AND 
	rapid_task_type_id = @rapidTaskType


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidTaskByJobIdAndTaskType TO VpWebApp 
GO


-- ================= adminRapidJob_GetQueuedCleanupJob



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
J.created	
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



-- ================= adminRapidJob_GetPendingReportingTasksForCleanup



EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetPendingReportingTasksForCleanup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_GetPendingReportingTasksForCleanup]
	
	@rapidJobId int 
AS
-- ==========================================================================
-- Author: Deshapriya
-- ==========================================================================
BEGIN


SELECT
T.[rapid_task_id] AS id 
,T.[rapid_job_id]
, T.[rapid_status_id]
,T.[rapid_task_type_id]
,T.[start_time]
,T.[end_time]
,T.[enabled]
,T.is_error
,T.error_message
,T.inserted_records
,T.updated_records
,T.deleted_records
,T.error_records
,T.[modified]
,T.[created]


FROM rapid_task T
WHERE 
T.rapid_job_id = @rapidJobId AND
(
(
(T.rapid_status_id = 1) AND -- pending
(
T.rapid_task_type_id = 7 OR   --ReportingInsertReport
T.rapid_task_type_id = 8 OR   --ReportingUpdateReport
T.rapid_task_type_id = 9 OR   --ReportingDeleteReport
T.rapid_task_type_id = 10 OR   --ReportingErrorReport
T.rapid_task_type_id = 11 OR   --ProductionPushInsertReport
T.rapid_task_type_id = 12 OR   --ProductionPushUpdateReport
T.rapid_task_type_id = 13 OR   --ProductionPushDeleteReport
T.rapid_task_type_id = 14    --ProductionPushErrorReport
)
)
OR 
(
T.rapid_status_id = 2 AND -- QUEUE
T.rapid_task_type_id = 6    --Clean up
)
)
	
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetPendingReportingTasksForCleanup TO VpWebApp 
GO

-------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_AddRapidProductUpdates'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_AddRapidProductUpdates]
	@productjson varchar(MAX),
	@status int,
	@jobId int,
	@productUpdateType int,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author: Deshapriya
-- ==========================================================================
BEGIN
	
	SET @created = GETDATE()

	INSERT INTO rapid_product_updates
	(
		product_json,
		status,
		enabled,
		job_id,
		product_update_type,
		created,
		modified
	)
	VALUES
	(
		@productjson,
		@status,
		@enabled,
		@jobId,
		@productUpdateType,
		@created,
		@created
	)
	SET @id = SCOPE_IDENTITY();

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_AddRapidProductUpdates TO VpWebApp 
GO
------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus
	@limit int = 20,
	@status int,
	@jobId int
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) rapid_product_update_id AS id, product_json, job_id, product_update_type, status,created,modified,enabled 
	FROM rapid_product_updates 
	WHERE Status = @status AND job_id = @jobId;

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus TO VpWebApp 
GO
-----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_UpdateRapidProductUpdateStatusById'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_UpdateRapidProductUpdateStatusById
	@rapidUpdateId INT,
	@status INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE rapid_product_updates
	SET status = @status
	WHERE rapid_product_update_id = @rapidUpdateId

END
GO

GRANT EXECUTE ON dbo.adminRapid_UpdateRapidProductUpdateStatusById TO VpWebApp 
GO
--------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchOption_GetSearchOptionBySearchOptionNameAndGroupId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchOption_GetSearchOptionBySearchOptionNameAndGroupId
	@searchOptionName varchar(150),
	@searchGroupId int
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(1) [search_option_id] as id,[search_group_id],[name],[enabled],[created],[modified],[sort_order]
	FROM search_option WHERE name = @searchOptionName AND search_group_id=@searchGroupId

	END
GO

GRANT EXECUTE ON dbo.adminSearchOption_GetSearchOptionBySearchOptionNameAndGroupId TO VpWebApp 
GO



--==== rapid_product_update_jobs


IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rapid_product_update_job' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[rapid_product_update_job](
		[rapid_product_update_job_id] [int] IDENTITY(1,1) NOT NULL,
		[rapid_job_id] [int] NOT NULL,
		[is_synced] [bit] NOT NULL,
		[enabled] [bit] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	CONSTRAINT [PK_rapid_product_update_job_id] PRIMARY KEY CLUSTERED
	(
		[rapid_product_update_job_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY];

	ALTER TABLE [dbo].[rapid_product_update_job]  WITH CHECK ADD  CONSTRAINT [FK_rapid_product_update_status_rapid_job_id] FOREIGN KEY([rapid_job_id])
	REFERENCES [dbo].[rapid_job] ([rapid_job_id]);

	ALTER TABLE [dbo].[rapid_product_update_job] CHECK CONSTRAINT [FK_rapid_product_update_status_rapid_job_id];

END
GO




--==== adminRapidProductUpdateJob_AddRapidProductUpdateJob =====

EXEC dbo.global_DropStoredProcedure 'adminRapidProductUpdateJob_AddRapidProductUpdateJob';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminRapidProductUpdateJob_AddRapidProductUpdateJob]
    @rapid_job_id INT,
    @is_synced BIT,
	@enabled BIT,
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()

	INSERT INTO rapid_product_update_job
	(
		rapid_job_id,
		is_synced,
		enabled,
		modified,
		created
	)
	VALUES
	(
		@rapid_job_id,
		@is_synced,
		@enabled,
		@created,
		@created
	);

	SET @id = SCOPE_IDENTITY();

END;
GO


GRANT EXECUTE ON dbo.adminRapidProductUpdateJob_AddRapidProductUpdateJob TO VpWebApp;
GO


--===== adminRapidProductUpdateJob_UpdateRapidProductUpdateJob =====

EXEC dbo.global_DropStoredProcedure 'adminRapidProductUpdateJob_UpdateRapidProductUpdateJob';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminRapidProductUpdateJob_UpdateRapidProductUpdateJob]
	@id INT OUTPUT,
    @rapid_job_id INT,
    @is_synced BIT,
	@enabled BIT,
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.rapid_product_update_job
	SET rapid_job_id = @rapid_job_id,
		is_synced = @is_synced,
		enabled = @enabled,
		modified = @modified
	WHERE rapid_product_update_job_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidProductUpdateJob_UpdateRapidProductUpdateJob TO VpWebApp 
GO


--==== adminRapidProductUpdateJob_DeleteRapidProductUpdateJob ====

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidProductUpdateJob_DeleteRapidProductUpdateJob'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidProductUpdateJob_DeleteRapidProductUpdateJob
	@id int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM rapid_product_update_job
	WHERE rapid_product_update_job_id = @id

END
GO

GRANT EXECUTE ON dbo.adminRapidProductUpdateJob_DeleteRapidProductUpdateJob TO VpWebApp 
GO

--==== publicRapidProductUpdateJob_GetRapidProductUpdateJob ====

EXEC dbo.global_DropStoredProcedure 'dbo.publicRapidProductUpdateJob_GetRapidProductUpdateJob'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicRapidProductUpdateJob_GetRapidProductUpdateJob
@id int
	
AS
-- ==========================================================================
-- Author: Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT	rapid_product_update_job_id as id,
			rapid_job_id,
			is_synced,
			enabled,
			modified,
			created
	FROM rapid_product_update_job 
	WHERE rapid_product_update_job_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidProductUpdateJob_GetRapidProductUpdateJob TO VpWebApp 
-------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetSyncedRapidProducUpdateJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetSyncedRapidProducUpdateJobs

AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT rapid_product_update_job_id AS id
		,rapid_job_id
		,is_synced
		,enabled
		,modified
		,created
	FROM rapid_product_update_job
	WHERE is_synced = 'true'

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetSyncedRapidProducUpdateJobs TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus
	@limit int = 20,
	@status int,
	@jobId int
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) rapid_product_update_id AS id, product_json, job_id, product_update_type, status,created,modified,enabled 
	FROM rapid_product_updates 
	WHERE Status = @status AND job_id = @jobId;

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------
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
	WHERE Status = @status AND job_id = @jobId AND product_update_type=@rapidProductUpdateType;

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidUpdatesByJobIdAndStatus TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchOption_GetMaximumSortOrderOfSearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchOption_GetMaximumSortOrderOfSearchOptions
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT MAX(sort_order) AS max_sort_order FROM search_option;

	END
GO

GRANT EXECUTE ON dbo.adminSearchOption_GetMaximumSortOrderOfSearchOptions TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------
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

	SELECT rapid_job_id as id, enabled, created, modified, is_synced, rapid_job_id
	FROM rapid_product_update_job
	WHERE is_synced = 'true'

	END
GO

GRANT EXECUTE ON dbo.adminRapid_GetSyncedJobs TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_DeleteCompletedRapidProductUpdatesByJobIdAndTaskType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_DeleteCompletedRapidProductUpdatesByJobIdAndTaskType
	@jobId INT,
	@taskType INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM rapid_product_updates WHERE job_id = @jobId AND product_update_type = @taskType AND status = 2

END
GO

GRANT EXECUTE ON dbo.adminRapid_DeleteCompletedRapidProductUpdatesByJobIdAndTaskType TO VpWebApp 
GO


--------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateReportTaskStatusById'
GO


--------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetPendingReportingTasksForCleanup'
GO


--------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetQueuedRapidReportingTasksByRapidJobId'
GO

--------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM rapid_status WHERE rapid_status_id = 5)
BEGIN

	insert into rapid_status ([rapid_status_id],[rapid_status],[modified],[created])
	values (5,'Canceled',GETDATE(),GETDATE())

END
GO

--------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM rapid_state WHERE rapid_state_id = 4)
BEGIN

	insert into rapid_state ([rapid_state_id],[rapid_state],[modified],[created])
	values (4,'CleanUp',GETDATE(),GETDATE())

END
GO

--------------------------------------------------------------------------------------------------------------------------

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
			created
	FROM rapid_job 
	WHERE rapid_state_id = 4
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetCleanUpRapidJobs TO VpWebApp 
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
	AND	rj.rapid_status_id = 2 --queued
	ORDER BY rj.rapid_job_id

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidJobs TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetVendorSettingsTemplateHierarchy'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetVendorSettingsTemplateHierarchy
	@vendor_settings_template_id int

AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [vendor_settings_template_id],[vendor_settings_template_name],[vendor_id],[sort_order],[enabled],[modified],[created]
	FROM [dbo].[vendor_settings_template] WITH(nolock)
	WHERE [vendor_settings_template_id] = @vendor_settings_template_id
		
	SELECT [vendor_settings_template_category_id],[vendor_settings_template_id],[category_id],[enabled],[modified],[created]
	FROM [dbo].[vendor_settings_template_category] WITH(nolock)
	WHERE [vendor_settings_template_id] = @vendor_settings_template_id	
	
	SELECT [vendor_settings_template_currency_id],[vendor_settings_template_id],[currency_id],[enabled],[created],[modified],[vendor_settings_template_currency_name]
	FROM [dbo].[vendor_settings_template_currency] 
	WHERE [vendor_settings_template_id] = @vendor_settings_template_id

END
GO

GRANT EXECUTE ON dbo.adminVendor_GetVendorSettingsTemplateHierarchy TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetModifiedContentLocations'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetModifiedContentLocations
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) c.content_location_id as id,c.content_type_id,c.content_id,c.location_type_id,c.location_id,c.exclude,c.enabled,c.site_id, c.created,c.modified
	FROM content_location c WITH(nolock)
	WHERE c.content_modified=1 AND content_type_id IN (6,34,35) --Vendor,VendorSettingsTemplate,VendorSettingsTemplateCurrency

END
GO

GRANT EXECUTE ON dbo.adminVendor_GetModifiedContentLocations TO VpWebApp 
GO