IF NOT EXISTS 
(
SELECT [name] FROM syscolumns where [name] = 'email_notification_setting' AND id = 
(SELECT object_id FROM sys.objects 
WHERE object_id = OBJECT_ID(N'task') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [task]
	ADD email_notification_setting int null
END
GO
----------------------------------------------------------------------------------------
IF EXISTS
(SELECT [name] FROM syscolumns where [name] = 'email_notification_setting' AND id = (SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'task') AND type in (N'U')))
		BEGIN
			UPDATE task SET email_notification_setting = 5 where task_type != 3
			UPDATE task SET email_notification_setting = 6 where task_type = 3
		END
GO
----------------------------------------------------------------------------------------
IF EXISTS
(SELECT [name] FROM syscolumns where [name] = 'email_notification_setting' AND id = (SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'task') AND type in (N'U')))
		BEGIN
			ALTER TABLE task
			ALTER COLUMN email_notification_setting int not null
		END
GO
----------------------------------------------------------------------------------------

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

	SELECT ROW_NUMBER() OVER (ORDER BY task_id desc) AS row, task_id AS id, task_name, site_id, 
		last_run_time, [status], task_type, notification_emails, [enabled], modified, created, email_notification_setting
	INTO #temp_task
	FROM task
	WHERE  (@siteId IS NULL OR site_id = @siteId) AND (@taskTypeId IS NULL OR task_type = @taskTypeId) AND
			(@taskName = '' OR task_name LIKE '%' + @taskName + '%') 
			AND	(@taskStatus IS NULL OR @taskStatus = (SELECT top 1 status_code FROM task_history
				WHERE task_id=task.task_id
				ORDER BY start_time desc))

	SELECT id, task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], 
		modified, created, email_notification_setting
	FROM #temp_task
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

	SELECT @totalCount = COUNT(*)
	FROM #temp_task

END
GO

GRANT EXECUTE ON dbo.adminScheduler_GetTaskBySiteIdStartIndexEndIndexTaskTypeTaskNameList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_GetTaskByTaskTypesList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_GetTaskByTaskTypesList
	@taskTypes varchar(255)
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminScheduler_GetTaskByTaskTypesList.sql $
-- $Revision: 4961 $
-- $Date: 2010-04-01 18:36:59 +0530 (Thu, 01 Apr 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT task_id AS id, task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], modified, created, email_notification_setting
	FROM task
	WHERE task_type IN (SELECT [value] FROM global_Split(@taskTypes, ','))

END
GO

GRANT EXECUTE ON dbo.adminScheduler_GetTaskByTaskTypesList TO VpWebApp 
GO

----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_GetTaskByTaskTypesPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_GetTaskByTaskTypesPageList
	@taskTypes varchar(255),
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminScheduler_GetTaskByTaskTypesPageList.sql $
-- $Revision: 8243 $
-- $Date: 2011-01-04 13:50:45 +0530 (Tue, 04 Jan 2011) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_task (row, id, task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], 
		modified, created, email_notification_setting) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY task_id) AS row, task_id AS id, task_name, site_id, 
			last_run_time, [status], task_type, notification_emails, [enabled], modified, created, email_notification_setting
		FROM task
		WHERE task_type IN (SELECT [value] FROM global_Split(@taskTypes, ','))
	)

	SELECT id, task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], 
		modified, created, email_notification_setting
	FROM temp_task
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminScheduler_GetTaskByTaskTypesPageList TO VpWebApp 
GO

----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_GetTaskDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_GetTaskDetail
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminScheduler_GetTaskDetail.sql $
-- $Revision: 4961 $
-- $Date: 2010-04-01 18:36:59 +0530 (Thu, 01 Apr 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT task_id AS id, task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], modified, created, email_notification_setting
	FROM task
	WHERE task_id = @id

END
GO

GRANT EXECUTE ON dbo.adminScheduler_GetTaskDetail TO VpWebApp 
GO

----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_UpdateTask
	@id int,
	@siteId int,
	@taskname varchar(255),
	@lastRunTime smalldatetime,
	@status varchar(255),
	@taskType int,
	@notificationEmails varchar(255),
	@enabled bit,
	@emailNotificationSetting int,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminScheduler_UpdateTask.sql $
-- $Revision: 4961 $
-- $Date: 2010-04-01 18:36:59 +0530 (Thu, 01 Apr 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	
	UPDATE task
	SET site_id = @siteId,
		task_name = @taskName,
		last_run_time = @lastRunTime,
		[status] = @status,
		task_type = @taskType,
		notification_emails = @notificationEmails,
		enabled = @enabled,
		modified = @modified,
		email_notification_setting = @emailNotificationSetting
	WHERE task_id = @id

END
GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateTask TO VpWebApp 
GO

----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_AddTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_AddTask
	@siteId int,
	@taskName varchar(255),
	@lastRunTime smalldatetime,
	@status varchar(255),
	@taskType int,
	@notificationEmails varchar(255),
	@enabled bit,
	@emailNotificationSetting int,
	@created smalldatetime output,
	@id int output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminScheduler_AddTask.sql $
-- $Revision: 4961 $
-- $Date: 2010-04-01 18:36:59 +0530 (Thu, 01 Apr 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO task(task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], modified, created, email_notification_setting)
	VALUES(@taskName, @siteId, @lastRunTime, @status, @taskType, @notificationEmails, @enabled, @created, @created, @emailNotificationSetting)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminScheduler_AddTask TO VpWebApp 
GO
---------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	SELECT count(pro.product_id) FROM product pro
		INNER JOIN [product_display_status] pds
			ON pro.product_id = pds.product_id
	WHERE pro.site_id = @siteId
		AND NOT(pds.start_date <= @today AND @today <= pds.end_date)
		AND 
		(pro.rank <> pro.default_rank OR pro.search_rank <> pro.default_search_rank)
		AND pro.product_id NOT IN 
		(
			SELECT p.product_id
			FROM [product_display_status] pds
				INNER JOIN product p
					ON p.product_id = pds.product_id
			WHERE p.site_id = @siteId	AND 
				(
					pds.start_date <= @today AND @today <= pds.end_date
				) 
		)
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId TO VpWebApp 
GO
-----------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	UPDATE p
		SET p.rank = p.default_rank,
			p.search_rank = p.default_search_rank,
			p.search_content_modified = 1,
			p.modified = GETDATE()
	FROM product p
	WHERE p.product_id IN
	(
		SELECT top (@batchSize) pro.product_id FROM product pro
			INNER JOIN [product_display_status] pds
				ON pro.product_id = pds.product_id
		WHERE pro.site_id = @siteId
			AND NOT(pds.start_date <= @today AND @today <= pds.end_date)
			AND 
			(pro.rank <> pro.default_rank OR pro.search_rank <> pro.default_search_rank)
			AND pro.product_id NOT IN 
			(
				SELECT p.product_id
				FROM [product_display_status] pds
					INNER JOIN product p
						ON p.product_id = pds.product_id
				WHERE p.site_id = @siteId	AND 
					(
						pds.start_date <= @today AND @today <= pds.end_date
					)
			)
	)

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId TO VpWebApp 
GO
---------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	UPDATE p
	SET p.[rank] = CASE WHEN product_display.new_rank IS NULL THEN p.default_rank ELSE product_display.new_rank END,
		p.search_rank = CASE WHEN product_display.search_rank = 0 THEN p.default_search_rank ELSE product_display.search_rank END,
		p.search_content_modified = 1,
		p.modified = GETDATE()
	FROM 
		(
		SELECT top (@batchSize) p.product_id, pds.new_rank, pds.search_rank
		FROM [product_display_status] pds
			INNER JOIN product p
				ON p.product_id = pds.product_id
		WHERE p.site_id = @siteId	AND 
			(
				pds.start_date <= @today AND @today <= pds.end_date
			) AND
			(
				( pds.new_rank IS NULL AND  p.search_rank <> pds.search_rank) 
				OR ( pds.new_rank IS NULL AND  p.[rank] <> p.default_rank) 
				OR ( pds.search_rank = 0  AND p.search_rank <> p.default_search_rank) 
				OR ( pds.search_rank = 0  AND  p.[rank] <> pds.new_rank ) 
				OR ( pds.new_rank IS NOT NULL AND pds.search_rank <> 0 AND ( p.rank <> pds.new_rank OR p.search_rank <> pds.search_rank))
			)
	)product_display
	INNER JOIN product p
		ON p.product_id = product_display.product_id


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateDisplayStatusProductsBySiteId TO VpWebApp 
GO
--------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetDisplayStatusProductCountBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetDisplayStatusProductCountBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	SELECT COUNT(*)
	FROM [product_display_status] pds
		INNER JOIN product p
			on p.product_id = pds.product_id
	WHERE p.site_id = @siteId	AND 
		(
			pds.start_date <= @today AND @today <= pds.end_date
		) AND
		(
			( pds.new_rank IS NULL AND  p.search_rank <> pds.search_rank) 
			OR ( pds.new_rank IS NULL AND  p.[rank] <> p.default_rank) 
			OR ( pds.search_rank = 0  AND p.search_rank <> p.default_search_rank) 
			OR ( pds.search_rank = 0  AND  p.[rank] <> pds.new_rank ) 
			OR ( pds.new_rank IS NOT NULL AND pds.search_rank <> 0 AND ( p.rank <> pds.new_rank OR p.search_rank <> pds.search_rank))
		)
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetDisplayStatusProductCountBySiteId TO VpWebApp 
GO
----------------------------
