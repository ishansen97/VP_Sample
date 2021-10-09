IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='spider_page_views' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[spider_page_views](
		[spider_page_views_id] [int] IDENTITY(1,1) NOT NULL,
		[ip_address] [varchar](50) NOT NULL,
		[ip_numeric] [bigint] NOT NULL,
		[timestamp] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[enabled] bit NOT NULL
	 CONSTRAINT [PK_spider_page_views] PRIMARY KEY CLUSTERED 
	(
		[spider_page_views_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_AddSpiderPageViews'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_AddSpiderPageViews
	@ipAddress varchar(50),
	@ipNumeric bigint,
	@enabled bit,
	@timeStamp smalldatetime,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @created = GETDATE();

	INSERT INTO spider_page_views(ip_address, ip_numeric, [timestamp], enabled, created, modified)
	VALUES (@ipAddress, @ipNumeric, @timeStamp, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSpider_AddSpiderPageViews TO VpWebApp 
GO

----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_UpdateSpiderPageViews'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_UpdateSpiderPageViews
	@id int,
	@ipAddress varchar(50),
	@ipNumeric bigint,
	@timeStamp smalldatetime,
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE spider_page_views
	SET ip_address = @ipAddress, 
	ip_numeric = @ipNumeric,
	[timestamp] = @timeStamp,
	enabled = @enabled,
	modified = @modified
	WHERE spider_page_views_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpider_UpdateSpiderPageViews TO VpWebApp 
GO

---------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_DeleteSpiderPageViews'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_DeleteSpiderPageViews
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM spider_page_views
	WHERE spider_page_views_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpider_DeleteSpiderPageViews TO VpWebApp 
Go

------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_GetSpiderPageViewsDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_GetSpiderPageViewsDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT spider_page_views_id AS id, ip_address, ip_numeric, [timestamp], created, enabled, modified
	FROM spider_page_views
	WHERE spider_page_views_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpider_GetSpiderPageViewsDetail TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_GetSpiderPageViewsByTimeIntervalAndThreshold'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_GetSpiderPageViewsByTimeIntervalAndThreshold
	@timeInterval smalldatetime,
	@threshold int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT ip_address, COUNT(ip_address) AS [count]
	FROM spider_page_views
	WHERE [timestamp] > @timeInterval
	GROUP BY ip_address
	HAVING COUNT(ip_address) > @threshold
END
GO

GRANT EXECUTE ON dbo.adminSpider_GetSpiderPageViewsByTimeIntervalAndThreshold TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_ip_address_timestamp' AND object_id = OBJECT_ID('spider_page_views'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ip_address_timestamp] ON [dbo].[spider_page_views] 
	(
		[ip_address] ASC,
		[timestamp] DESC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO

----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_DeleteSpiderPageViewsByDateTime'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_DeleteSpiderPageViewsByDateTime
	@expirationDateTime smalldatetime
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM spider_page_views
	WHERE [timestamp] < @expirationDateTime

END
GO

GRANT EXECUTE ON dbo.adminSpider_DeleteSpiderPageViews TO VpWebApp 
Go

------------------------------------------------------------------------------------------