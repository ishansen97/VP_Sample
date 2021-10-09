IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'RapidLog')
DROP SYNONYM [dbo].[RapidLog]
GO

------------------------------**************************------------------------------------
-- If the Rapid database name is not [Rapid] replace it with the correct database name
------------------------------**************************------------------------------------
/****** Object:  Synonym [dbo].[rapid_log]    ******/
CREATE SYNONYM [dbo].[RapidLog] FOR [Rapid].[dbo].[rapid_log]
GO

---------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'RapidJobQueue')
DROP SYNONYM [dbo].[RapidJobQueue]
GO

------------------------------**************************------------------------------------
-- If the Rapid database name is not [Rapid] replace it with the correct database name
------------------------------**************************------------------------------------
/****** Object:  Synonym [dbo].[rapid_job_queue]    ******/
CREATE SYNONYM [dbo].[RapidJobQueue] FOR [Rapid].[dbo].[rapid_job_queue]
GO

-------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidJobQueues'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidJobQueues
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUTPUT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT *
	FROM(
		SELECT ROW_NUMBER() OVER (ORDER BY [queue_time] DESC) AS row, 
			[job_queue_id] AS id
		  ,[vendor_id]
		  ,[queue_time]
		  ,[start_time]
		  ,[job_id]
		  ,[action]
		  ,[priority]
		  ,[completed]
		  ,[stop_time]
		  ,[has_errors]
		  ,[error_description] 
		FROM RapidJobQueue) rj
		WHERE row BETWEEN @startIndex AND @endIndex
		ORDER BY row 
	
	SELECT @totalCount = COUNT(*)
	FROM RapidJobQueue rjq

	END
	GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidJobQueues TO VpWebApp 
GO

-------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidLogByQueueId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidLogByQueueId
	@id NVARCHAR(50)
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT rl.job_id, rl.date, rl.level, rl.message, rl.exception, rl.count, rl.action
	FROM RapidLog rl
	INNER JOIN RapidJobQueue rjq
		ON rl.job_id = rjq.job_id AND (rl.date BETWEEN rjq.start_time AND rjq.stop_time)
	WHERE rjq.job_queue_id = @id
	ORDER BY rl.date DESC

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidLogByQueueId TO VpWebApp 
GO

-----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidLogDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidLogDetail
	@id NVARCHAR(50)
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT job_id, date, level, message, exception, count, action
	FROM RapidLog
	WHERE job_id = @id

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidLogDetail TO VpWebApp 
GO

------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_DeleteRapidLog'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_DeleteRapidLog
	@id NVARCHAR(50)
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM RapidLog
	WHERE  job_id = @id

END
GO

GRANT EXECUTE ON dbo.adminRapid_DeleteRapidLog TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_UpdateRapidLog'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_UpdateRapidLog
	@id NVARCHAR(50),
	@jobId NVARCHAR(50),
	@date DATETIME,
	@level NCHAR(10),
	@message NVARCHAR(max),
	@exception NVARCHAR(max),
	@count int,
	@action varchar(50),
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE RapidLog
	SET job_id = @jobId, 
	date = @date, 
	level = @level, 
	message = @message, 
	exception = @exception, 
	count = @count, 
	action = @action
	WHERE job_id = @id

END
GO

GRANT EXECUTE ON dbo.adminRapid_UpdateRapidLog TO VpWebApp 
GO
---------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_AddRapidLog'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_AddRapidLog
	@jobId NVARCHAR(50),
	@date DATETIME,
	@level NCHAR(10),
	@message NVARCHAR(max),
	@exception NVARCHAR(max),
	@count int,
	@action varchar(50),
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO RapidLog(job_id, date, level, message, exception, count, action)
	VALUES (@jobId, @date, @level, @message, @exception, @count, @action)

	SET @id = @jobId

END
GO

GRANT EXECUTE ON dbo.adminRapid_AddRapidLog TO VpWebApp 
GO

GO

----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidJobQueueDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidJobQueueDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT job_queue_id AS id, vendor_id, queue_time, start_time, job_id, action, priority, completed, stop_time, has_errors, error_description
	FROM RapidJobQueue
	WHERE job_queue_id = @id

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidJobQueueDetail TO VpWebApp 
GO

--------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_DeleteRapidJobQueue'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_DeleteRapidJobQueue
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM RapidJobQueue
	WHERE job_queue_id = @id

END
GO

GRANT EXECUTE ON dbo.adminRapid_DeleteRapidJobQueue TO VpWebApp 
GO

---------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_UpdateRapidJobQueue'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_UpdateRapidJobQueue
	@id int,
	@vendorId int,
	@queueTime DATETIME,
	@startTime DATETIME,
	@jobId varchar(255),
	@action varchar(255),
	@priority int,
	@completed bit,
	@stopTime DATETIME,
	@hasErrors bit,
	@errorDescription varchar(max),
	@modified DATETIME OUTPUT

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE RapidJobQueue
	SET vendor_id = @vendorId, 
	queue_time = @queueTime, 
	start_time = @startTime, 
	job_id = @jobId, 
	action = @action, 
	priority = @priority, 
	completed = @completed, 
	stop_time = @stopTime, 
	has_errors = @hasErrors, 
	error_description = @errorDescription
	WHERE job_queue_id = @id
	
	SET @modified = GETDATE();

END
GO

GRANT EXECUTE ON dbo.adminRapid_UpdateRapidJobQueue TO VpWebApp 
GO

--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_AddRapidJobQueue'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_AddRapidJobQueue
	@vendorId int,
	@queueTime DATETIME,
	@startTime DATETIME,
	@jobId varchar(255),
	@action varchar(255),
	@priority int,
	@completed bit,
	@stopTime DATETIME,
	@hasErrors bit,
	@errorDescription varchar(max),
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO RapidJobQueue(vendor_id, queue_time, start_time, job_id, action, priority, completed, stop_time, has_errors, error_description)
	VALUES (@vendorId, @queueTime, @startTime, @jobId, @action, @priority, @completed, @stopTime, @hasErrors, @errorDescription)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminRapid_AddRapidJobQueue TO VpWebApp 
GO