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
	j.site_id
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


--rapid_task_effected_record_count_type

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'rapid_task_effected_record_count_type')
BEGIN
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	
	CREATE TABLE [dbo].[rapid_task_effected_record_count_type](
		[rapid_task_effected_record_count_type_id] int NOT NULL,
		[name] VARCHAR(100),
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL
	 CONSTRAINT [PK_rapid_task_effected_record_count_type] PRIMARY KEY CLUSTERED 
	(
		[rapid_task_effected_record_count_type_id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY]


	---records

	INSERT INTO dbo.rapid_task_effected_record_count_type
	(
	    rapid_task_effected_record_count_type_id,
	    name,
	    created,
	    modified
	)
	VALUES
		(   1,                     -- rapid_task_effected_record_count_type_id - int
	    'InsertedProductCount',                    -- name - varchar(100)
	    GETDATE(), -- created - smalldatetime
	    GETDATE()  -- modified - smalldatetime
	),
		(   2,                     -- rapid_task_effected_record_count_type_id - int
	    'UpdatedProductCount',                    -- name - varchar(100)
	    GETDATE(), -- created - smalldatetime
	    GETDATE()  -- modified - smalldatetime
	),
		(   3,                     -- rapid_task_effected_record_count_type_id - int
	    'DeletedProductCount',                    -- name - varchar(100)
	    GETDATE(), -- created - smalldatetime
	    GETDATE()  -- modified - smalldatetime
	),
		(   4,                     -- rapid_task_effected_record_count_type_id - int
	    'ErrorCount',                    -- name - varchar(100)
	    GETDATE(), -- created - smalldatetime
	    GETDATE()  -- modified - smalldatetime
	),
		(   5,                     -- rapid_task_effected_record_count_type_id - int
	    'UnchangedProductCount',                    -- name - varchar(100)
	    GETDATE(), -- created - smalldatetime
	    GETDATE()  -- modified - smalldatetime
	),
		(   6,                     -- rapid_task_effected_record_count_type_id - int
	    'ReEnabledProductCount',                    -- name - varchar(100)
	    GETDATE(), -- created - smalldatetime
	    GETDATE()  -- modified - smalldatetime
	),
		(   7,                     -- rapid_task_effected_record_count_type_id - int
	    'IgnoredInRapidProductCount',                    -- name - varchar(100)
	    GETDATE(), -- created - smalldatetime
	    GETDATE()  -- modified - smalldatetime
	)
		
END

GO

--rapid_task_effected_record_count

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'rapid_task_effected_record_count')
BEGIN
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	
	CREATE TABLE [dbo].[rapid_task_effected_record_count](
		[rapid_task_effected_record_count_id] int IDENTITY(1,1) NOT NULL,
		[rapid_task_id] [INT] NOT NULL,
		[rapid_task_effected_record_count_type_id] [INT] NOT NULL,
		[record_count] [INT] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL
	 CONSTRAINT [PK_rapid_task_effected_record_count] PRIMARY KEY CLUSTERED 
	(
		rapid_task_effected_record_count_id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY]
	

	ALTER TABLE [dbo].rapid_task_effected_record_count  WITH CHECK ADD  CONSTRAINT [FK_rapid_task_effected_record_count_rapid_task_id] FOREIGN KEY([rapid_task_id])
	REFERENCES [dbo].[rapid_task] ([rapid_task_id])

	ALTER TABLE [dbo].rapid_task_effected_record_count  WITH CHECK ADD  CONSTRAINT [FK_rapid_task_effected_record_count_count_type_id] FOREIGN KEY([rapid_task_effected_record_count_type_id])
	REFERENCES [dbo].[rapid_task_effected_record_count_type] ([rapid_task_effected_record_count_type_id])

END

GO

-- adminRapidTask_AddRapidTaskEffectedRecordCount

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_AddRapidTaskEffectedRecordCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_AddRapidTaskEffectedRecordCount]
    @rapid_task_id INT,
    @rapid_task_effected_record_count_type_id INT,
    @record_count INT,
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

	INSERT INTO dbo.rapid_task_effected_record_count
	(
	    rapid_task_id,
	    rapid_task_effected_record_count_type_id,
	    record_count,
	    enabled,
	    created,
	    modified
	)
	VALUES
	(   @rapid_task_id,                     -- rapid_task_id - int
	    @rapid_task_effected_record_count_type_id,                     -- rapid_task_effected_record_count_type_id - int
	    @record_count,                     -- record_count - int
	    @enabled,                  -- enabled - bit
	    @created, -- created - smalldatetime
	    @created  -- modified - smalldatetime
	    )

	SET @id = SCOPE_IDENTITY();

END
GO

GRANT EXECUTE ON dbo.adminRapidTask_AddRapidTaskEffectedRecordCount TO VpWebApp
GO

--adminRapidTask_DeleteRapidTaskEffectedRecordCount

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_DeleteRapidTaskEffectedRecordCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_DeleteRapidTaskEffectedRecordCount]
@id int
	
AS
-- ==========================================================================
-- Author: Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE	
	FROM [rapid_task_effected_record_count] 
	WHERE [rapid_task_effected_record_count_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminRapidTask_DeleteRapidTaskEffectedRecordCount TO VpWebApp
GO


--adminRapidTask_UpdateRapidTaskEffectedRecordCount

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateRapidTaskEffectedRecordCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateRapidTaskEffectedRecordCount]
	@id INT,
	@rapid_task_id INT,
	@rapid_task_effected_record_count_type_id INT,
    @record_count INT,
	@enabled BIT,
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE [dbo].[rapid_task_effected_record_count]
	SET [rapid_task_id] = @rapid_task_id
      ,[rapid_task_effected_record_count_type_id] = @rapid_task_effected_record_count_type_id
      ,[record_count] = @record_count
      ,[enabled] = @enabled
      ,[modified] = @modified
	WHERE rapid_task_effected_record_count_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidTaskEffectedRecordCount TO VpWebApp
GO


--publicRapidTask_GetRapidTaskEffectedRecordCount

EXEC dbo.global_DropStoredProcedure 'dbo.publicRapidTask_GetRapidTaskEffectedRecordCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicRapidTask_GetRapidTaskEffectedRecordCount]
@id int
	
AS
-- ==========================================================================
-- Author: Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT	rapid_task_effected_record_count_id as id,
			rapid_task_id,
			rapid_task_effected_record_count_type_id,
			record_count,
			enabled,
			modified,
			created
	FROM [rapid_task_effected_record_count] 
	WHERE rapid_task_effected_record_count_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidTask_GetRapidTaskEffectedRecordCount TO VpWebApp
GO

-- ==========================================================================

-- ================adminRapidJob_GetRapidTaskByJobIdAndTaskType=======================

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

-- =======adminRapidJob_GetRapidTasksByRapidJobId=============================

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
		,report_path
		,[modified]
		,[created]
	FROM dbo.rapid_task
	WHERE rapid_job_id = @rapidJobId


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetRapidTasksByRapidJobId TO VpWebApp
GO

-- ================adminRapidTask_AddRapidTask===============================

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
		@report_path,
		@created,
		@created
	);

	SET @id = SCOPE_IDENTITY();

END
GO

GRANT EXECUTE ON dbo.adminRapidTask_AddRapidTask TO VpWebApp
GO

-- ======================adminRapidTask_UpdateRapidReportTask==================

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateRapidReportTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateRapidReportTask]
	@id INT,
    @rapid_status_id INT,
	@duration DECIMAL (14,2),
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
	error_message = @error_message,
	is_error = @is_error,
	modified = @endtime,
	report_path = @report_path
	WHERE rapid_task_id = @id
		
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidReportTask TO VpWebApp
GO

-- ==================adminRapidTask_UpdateRapidTask=====================

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
		start_time = CASE WHEN rapid_status_id IN(1,2) AND @rapid_status_id = 3 THEN GETDATE() ELSE start_time END,
		end_time = CASE WHEN rapid_status_id = 3 AND @rapid_status_id = 4 THEN GETDATE() ELSE end_time END,
		enabled = @enabled,
		is_error = @is_error,
		error_message  = @error_message,
		report_path = @report_path,
		modified = @modified
	WHERE rapid_task_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidTask TO VpWebApp
GO

-- =========================publicRapidTask_GetRapidTask================

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
			report_path,
			modified,
			created
	FROM rapid_task 
	WHERE rapid_task_id = @id

END
GO

GRANT EXECUTE ON dbo.publicRapidTask_GetRapidTask TO VpWebApp
GO



-- =========================adminRapidTask_SaveRapidTaskEffectedRecordCount================

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_SaveRapidTaskEffectedRecordCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_SaveRapidTaskEffectedRecordCount]
	
	@rapid_task_id INT,
	@rapid_task_effected_record_count_type_id INT,
    @record_count INT,
	@enabled BIT,
	
	@id INT output,
	@created smalldatetime output,
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Deshapriya
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;	
	SET @modified = GETDATE()	

	SELECT @id = rapid_task_effected_record_count_id, @created = created  from [rapid_task_effected_record_count] RC 
	WHERE RC.rapid_task_id = @rapid_task_id AND RC.rapid_task_effected_record_count_type_id = @rapid_task_effected_record_count_type_id 

	IF @id IS NULL
	BEGIN
		-- INSERT
		INSERT INTO [dbo].[rapid_task_effected_record_count]
		(
			--rapid_task_effected_record_count_id
			rapid_task_id,
			rapid_task_effected_record_count_type_id,
			record_count,
			enabled,
			created,
			modified
		)
		VALUES
		(
			@rapid_task_id,
			@rapid_task_effected_record_count_type_id,
			@record_count,
			@enabled,
			@modified,
			@modified 
		)
		set @created = @modified
		set @id = scope_identity()

	END
	ELSE
	BEGIN
		-- UPDATE
		UPDATE [dbo].[rapid_task_effected_record_count]
		SET 
		   --[rapid_task_id] = @rapid_task_id
		  --,[rapid_task_effected_record_count_type_id] = @rapid_task_effected_record_count_type_id
		  [record_count] = @record_count
		  ,[enabled] = @enabled
		  ,[modified] = @modified
		WHERE rapid_task_effected_record_count_id = @id
	END
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_SaveRapidTaskEffectedRecordCount TO VpWebApp
GO

-- ==========================================================================

EXEC dbo.global_DropStoredProcedure 'dbo.publicRapidTask_GetRapidTaskCountsByRapidTaskId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicRapidTask_GetRapidTaskCountsByRapidTaskId]
@rapidTaskId int
	
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT	rapid_task_effected_record_count_id as id,
			rapid_task_id,
			rapid_task_effected_record_count_type_id,
			record_count,
			enabled,
			modified,
			created
	FROM [rapid_task_effected_record_count] 
	WHERE rapid_task_id = @rapidTaskId

END
GO

GRANT EXECUTE ON dbo.publicRapidTask_GetRapidTaskCountsByRapidTaskId TO VpWebApp
GO
GO

--==== adminRapidJob_UnsheduleJobAndTasks
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_UnsheduleJobAndTasks'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_UnsheduleJobAndTasks
 @id int,
 @boolean_val int output,
 @error VARCHAR(250) output

AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT @error = ''

	IF (EXISTS (SELECT TOP (1) rapid_job_id
			FROM rapid_job
			WHERE rapid_job_id = @id AND
			rapid_status_id NOT IN (3)))
		BEGIN
			UPDATE rapid_job SET rapid_status_id = 1 
			WHERE rapid_job_id = @id

			UPDATE rapid_task SET rapid_status_id = 1 
			WHERE rapid_job_id = @id AND rapid_status_id = 2

			SELECT @boolean_val = 1
		END
	ELSE
		BEGIN
			SELECT @boolean_val = 0

			DECLARE @status int

			SELECT TOP (1)  @status = rapid_status_id
				FROM rapid_job
				WHERE rapid_job_id = @id

			IF(@status = 3)
			BEGIN
				SELECT @error = 'Job in Processing state'
			END
		END	


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_UnsheduleJobAndTasks TO VpWebApp 
GO

-- =====================adminRapidJob_GetCompletedRapidJobs===================

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

-- =======================adminRapidJob_UnsheduleJobAndTasks==============

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_UnsheduleJobAndTasks'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_UnsheduleJobAndTasks
 @id int,
 @boolean_val int output

AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF (EXISTS (SELECT TOP (1) rapid_job_id
			FROM rapid_job
			WHERE rapid_job_id = @id AND
			rapid_status_id NOT IN (3)))
		BEGIN
			UPDATE rapid_job SET rapid_status_id = 1 
			WHERE rapid_job_id = @id

			UPDATE rapid_task SET rapid_status_id = 1 
			WHERE rapid_job_id = @id AND rapid_status_id = 2

			SELECT @boolean_val = 1
		END
	ELSE
		BEGIN
			SELECT @boolean_val = 0
		END	


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_UnsheduleJobAndTasks TO VpWebApp 
GO