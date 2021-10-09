--==== rapid_task_type

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rapid_task_type' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[rapid_task_type](
		[rapid_task_type_id] [int] NOT NULL,
		[rapid_task_type] [varchar] (500) NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	CONSTRAINT [PK_rapid_task_type] PRIMARY KEY CLUSTERED
	(
		[rapid_task_type_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY];


	insert into rapid_task_type ([rapid_task_type_id],[rapid_task_type],[modified],[created])
	values (1,'Update',GETDATE(),GETDATE()),
	(2,'UpdatePlus',GETDATE(),GETDATE()),
	(3,'Insert',GETDATE(),GETDATE()),
	(4,'Delete',GETDATE(),GETDATE()),
	(5,'Reports',GETDATE(),GETDATE()),
	(6,'CleanUp',GETDATE(),GETDATE());

END
GO




--==== rapid_task_type

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rapid_status' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[rapid_status](
		[rapid_status_id] [int] NOT NULL,
		[rapid_status] [varchar] (500) NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	CONSTRAINT [PK_rapid_status] PRIMARY KEY CLUSTERED
	(
		[rapid_status_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY];


	insert into rapid_status ([rapid_status_id],[rapid_status],[modified],[created])
	values (1,'Pending',GETDATE(),GETDATE()),
	(2,'Queue',GETDATE(),GETDATE()),
	(3,'InProgress',GETDATE(),GETDATE()),
	(4,'Finished',GETDATE(),GETDATE());

END
GO


--==== rapid_state

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rapid_state' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[rapid_state](
		[rapid_state_id] [int] NOT NULL,
		[rapid_state] [varchar] (500) NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	CONSTRAINT [PK_rapid_state] PRIMARY KEY CLUSTERED
	(
		[rapid_state_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY];


	insert into rapid_state ([rapid_state_id],[rapid_state],[modified],[created])
	values (1,'Reports',GETDATE(),GETDATE()),
	(2,'ProductionPush',GETDATE(),GETDATE()),
	(3,'Completed',GETDATE(),GETDATE());

END
GO


--rapid_job table

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rapid_job' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[rapid_job](
		[rapid_job_id] [int] IDENTITY(1,1) NOT NULL,
		[vendor_id] [int] NOT NULL,
		[rapid_status_id] [int] NOT NULL,
		[rapid_state_id] [int] NOT NULL,
		[data_file_name] [varchar] (500) NOT NULL,
		[rule_file] [varchar](MAX) NOT NULL,
		[order_by] [int] NOT NULL,
		[emails] [varchar] (1000) NULL,
		[enabled] [bit] NOT NULL,
		[is_error] [bit] NOT NULL,
		[error_message] [varchar] (1000) NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	CONSTRAINT [PK_rapid_job_id] PRIMARY KEY CLUSTERED
	(
		[rapid_job_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY];

	ALTER TABLE [dbo].[rapid_job]  WITH CHECK ADD  CONSTRAINT [FK_rapid_job_rapid_status] FOREIGN KEY([rapid_status_id])
	REFERENCES [dbo].[rapid_status] ([rapid_status_id]);

	ALTER TABLE [dbo].[rapid_job] CHECK CONSTRAINT [FK_rapid_job_rapid_status];

	ALTER TABLE [dbo].[rapid_job]  WITH CHECK ADD  CONSTRAINT [FK_rapid_job_rapid_state] FOREIGN KEY([rapid_state_id])
	REFERENCES [dbo].[rapid_state] ([rapid_state_id]);

	ALTER TABLE [dbo].[rapid_job] CHECK CONSTRAINT [FK_rapid_job_rapid_state];

END
GO


--rapid_task table

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rapid_task' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[rapid_task](
		[rapid_task_id] [int] IDENTITY(1,1) NOT NULL,
		[rapid_job_id] [int] NOT NULL,
		[rapid_status_id] [int] NOT NULL,
		[rapid_task_type_id] [int] NOT NULL,
		[start_time] [smalldatetime] NULL,
		[end_time] [smalldatetime] NULL,
		[enabled] [bit] NOT NULL,
		[is_error] [bit] NOT NULL,
		[error_message] [varchar] (1000) NULL,
		[inserted_records] [int] NULL,
		[updated_records] [int] NULL,
		[deleted_records] [int] NULL,
		[error_records] [int] NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	CONSTRAINT [PK_rapid_task_id] PRIMARY KEY CLUSTERED
	(
		[rapid_task_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY];

	ALTER TABLE [dbo].[rapid_task]  WITH CHECK ADD  CONSTRAINT [FK_rapid_task_job] FOREIGN KEY([rapid_job_id])
	REFERENCES [dbo].[rapid_job] ([rapid_job_id]);
	
	ALTER TABLE [dbo].[rapid_task] CHECK CONSTRAINT [FK_rapid_task_job];

	ALTER TABLE [dbo].[rapid_task]  WITH CHECK ADD  CONSTRAINT [FK_rapid_task_rapid_status] FOREIGN KEY([rapid_status_id])
	REFERENCES [dbo].[rapid_status] ([rapid_status_id]);

	ALTER TABLE [dbo].[rapid_task] CHECK CONSTRAINT [FK_rapid_task_rapid_status];

	ALTER TABLE [dbo].[rapid_task]  WITH CHECK ADD  CONSTRAINT [FK_rapid_task_rapid_task_type] FOREIGN KEY([rapid_task_type_id])
	REFERENCES [dbo].[rapid_task_type] ([rapid_task_type_id]);

	ALTER TABLE [dbo].[rapid_task] CHECK CONSTRAINT [FK_rapid_task_rapid_task_type];

END
GO

-- ===== adminRapidJob_AddRapidJob

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
		created
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
		@created
	);

	SET @id = SCOPE_IDENTITY();

END;
GO


GRANT EXECUTE ON dbo.adminRapidJob_AddRapidJob TO VpWebApp;
GO

-- ===== adminRapidTask_AddRapidTask

EXEC dbo.global_DropStoredProcedure 'adminRapidTask_AddRapidTask';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
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
		@created,
		@created
	);

	SET @id = SCOPE_IDENTITY();

END;
GO


GRANT EXECUTE ON dbo.adminRapidTask_AddRapidTask TO VpWebApp;
GO


-- ===== adminRapidJob_UpdateRapidJob

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
		modified = @modified
	WHERE rapid_job_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_UpdateRapidJob TO VpWebApp 
GO


-- ===== adminRapidTask_UpdateRapidTask

EXEC dbo.global_DropStoredProcedure 'adminRapidTask_UpdateRapidTask';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
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
		modified = @modified
	WHERE rapid_task_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidTask TO VpWebApp 
GO


-- ====== publicRapidJob_GetRapidJob

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
			modified,
			created
	FROM rapid_job 
	WHERE rapid_job_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidJob_GetRapidJob TO VpWebApp 
GO

-- ====== publicRapidTask_GetRapidTask

EXEC dbo.global_DropStoredProcedure 'dbo.publicRapidTask_GetRapidTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicRapidTask_GetRapidTask
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
			modified,
			created
	FROM rapid_task 
	WHERE rapid_task_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidTask_GetRapidTask TO VpWebApp 
GO

-- ==========================================================================

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetClientTokenByTokenName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetClientTokenByTokenName
	@tokenName varchar(50)
AS
-- ==========================================================================
-- $Author: Madushan Fernando $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(1) client_token_id AS id, name, email, token, site_id, created, enabled, modified, site_logo
	FROM client_token
	WHERE name = @tokenName

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenByTokenName TO VpWebApp
GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenByTokenName TO VpWebAPI
GO

-- ==========================================================================

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

	SELECT MAX(order_by) AS [order] FROM rapid_job;

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
	SELECT	TOP(1) rapid_job_id as id,
			vendor_id,
			rapid_status_id,
			rapid_state_id,
			data_file_name,
			rule_file,
			order_by,
			emails,
			modified,
			enabled,
			is_error,
			error_message,
			created
	FROM rapid_job 
	ORDER BY rapid_job_id

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidJobs TO VpWebApp 
GO


--==== adminRapidJob_GetRapidTasksByRapidJobId

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetRapidTasksByRapidJobId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetRapidTasksByRapidJobId
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
		,[modified]
		,[created]
	FROM dbo.rapid_task
	WHERE rapid_job_id = @rapidJobId


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidTasksByRapidJobId TO VpWebApp 
GO


-- ================= adminRapidTask_UpdateRapidTaskStatusById

EXEC dbo.global_DropStoredProcedure 'adminRapidTask_UpdateRapidTaskStatusById';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateRapidTaskStatusById]
	@id INT OUTPUT,
    @rapid_status_id INT
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE dbo.rapid_task
	SET rapid_status_id = @rapid_status_id,
		modified = GETDATE()
	WHERE rapid_task_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidTaskStatusById TO VpWebApp 
GO


-- ================= adminRapidJob_UpdateRapidJobStatusById

EXEC dbo.global_DropStoredProcedure 'adminRapidJob_UpdateRapidJobStatusById';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminRapidJob_UpdateRapidJobStatusById]
	@id INT OUTPUT,
    @rapid_status_id INT
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE dbo.rapid_job
	SET rapid_status_id = @rapid_status_id,
		modified = GETDATE()
	WHERE rapid_job_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidJob_UpdateRapidJobStatusById TO VpWebApp 
GO


-- ================= adminRapidJob_GetRapidJobsByState

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
			created
	FROM rapid_job 
	WHERE rapid_state_id = @rapid_state_id


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidJobsByState TO VpWebApp 
GO

-- ================= adminRapidJob_ReOrderJob

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_ReOrderJob'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_ReOrderJob
	@new_index int,
	@job_id int
AS
-- ==========================================================================
-- $Author: madushan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE dbo.rapid_job 
	SET	order_by = (CASE  
		WHEN rapid_job_id = @job_id THEN @new_index 
		WHEN order_by >= @new_index THEN order_by + 1
		ELSE order_by 
		END)
	

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_ReOrderJob TO VpWebApp 
GO

-- ================= adminRapidJob_GetReportRapidJobs

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
			created
	FROM rapid_job 
	WHERE rapid_state_id = 1
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetReportRapidJobs TO VpWebApp 
GO

-- ================= adminRapidJob_GetProductionPushRapidJobs

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
			created
	FROM rapid_job 
	WHERE rapid_state_id = 2
	ORDER BY order_by

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetProductionPushRapidJobs TO VpWebApp 
GO

-- ================= adminRapidJob_GetCompletedRapidJobs

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
			created
	FROM rapid_job 
	WHERE rapid_state_id = 3
	ORDER BY modified DESC

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetCompletedRapidJobs TO VpWebApp 
GO


-- ================= adminRapidJob_AddRapidProductUpdates


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


-- ================= adminRapidJob_GetQueuedRapidJobForProductionPush

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
	J.created

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


-- ================= adminRapidJob_GetQueuedRapidJobForReporting



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
	J.created

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



-- ================= adminRapidJob_GetQueuedRapidReportingTasksByRapidJobId



EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetQueuedRapidReportingTasksByRapidJobId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidJob_GetQueuedRapidReportingTasksByRapidJobId]
	@rapidJobId int
AS
-- ==========================================================================
-- Author: Deshapriya
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
	WHERE 
	rapid_job_id = @rapidJobId AND
	rapid_status_id = 2 AND --Queue
	(
	rapid_task_type_id = 7 OR   --ReportingInsertReport
	rapid_task_type_id = 8 OR   --ReportingUpdateReport
	rapid_task_type_id = 9 OR   --ReportingDeleteReport
	rapid_task_type_id = 10 OR   --ReportingErrorReport
	rapid_task_type_id = 11 OR   --ProductionPushInsertReport
	rapid_task_type_id = 12 OR   --ProductionPushUpdateReport
	rapid_task_type_id = 13 OR   --ProductionPushDeleteReport
	rapid_task_type_id = 14    --ProductionPushErrorReport
	)
	END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetQueuedRapidReportingTasksByRapidJobId TO VpWebApp 
GO


-- ================= adminRapidTask_UpdateReportTaskStatusById



EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateReportTaskStatusById'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateReportTaskStatusById]
	@id INT OUTPUT,
    @rapid_status_id INT,
	@isError BIT,
	@errormessage  VARCHAR (1000)
	

AS
-- ==========================================================================
-- Author : Deshapriya
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE dbo.rapid_task
	SET rapid_status_id = @rapid_status_id,	
	is_error = @isError,
	[error_message] = @errormessage,
	modified = GETDATE()
	WHERE rapid_task_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateReportTaskStatusById TO VpWebApp 
GO




