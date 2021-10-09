

-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'is_https' AND Object_ID = Object_ID(N'site'))
BEGIN
    ALTER TABLE site
	ADD is_https BIT NOT NULL DEFAULT 0
END
GO

----------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetSiteDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetSiteDetail
	@id int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT site_id AS id, site_name, [enabled], modified, created, homepage_id, theme_name, media_url
		, code, header_image, site_type_id, is_https
	FROM [site]
	WHERE site_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetSiteDetail TO VpWebApp 
GO


----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddSite'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddSite
	@siteName varchar(50),
	@enabled bit,
	@id int output,
	@homepageId int,
	@themeName varchar (50),
	@mediaUrl varchar(255),
	@code varchar(10),
	@headerImage varchar(100),
	@siteTypeId int,
	@isHttps bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @created = GETDATE()
	INSERT INTO [site] (site_name, [enabled], modified, created, homepage_id, theme_name
		, media_url, code, header_image, site_type_id, is_https) 
	VALUES (@siteName, @enabled, @created, @created, @homepageId, @themeName
		, @mediaUrl, @code, @headerImage, @siteTypeId, @isHttps)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddSite TO VpWebApp 
GO


----------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetSiteList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetSiteList
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT site_id AS id, site_name, homepage_id, theme_name, media_url, code, header_image, site_type_id
		, [enabled], modified, created, is_https
	FROM [site]

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetSiteList TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateSite'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateSite
	@id int,
	@siteName varchar(50),
	@enabled bit,
	@homepageId int,
	@themeName varchar (50),
	@mediaUrl varchar (255),
	@code varchar(10),
	@headerImage varchar(100),
	@siteTypeId int,
	@modified smalldatetime output,
	@isHttps bit
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [site]
	SET site_name = @siteName,
		[enabled] = @enabled,
		modified = @modified,
		homepage_id = @homepageId,
		theme_name = @themeName,
		media_url = @mediaUrl,
		code = @code,
		header_image = @headerImage,
		site_type_id = @siteTypeId,
		is_https = @isHttps
	WHERE site_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateSite TO VpWebApp 
GO