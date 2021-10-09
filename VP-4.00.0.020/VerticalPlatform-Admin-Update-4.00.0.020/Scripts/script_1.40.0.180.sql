IF OBJECT_ID('dbo.DF__site_to_p__descr__0C140A5D') IS NOT NULL
BEGIN
	ALTER TABLE [page]
	DROP CONSTRAINT DF__site_to_p__descr__0C140A5D	
END

IF(COL_LENGTH('Page', 'description_prefix') <> -1)
BEGIN
	ALTER TABLE [page]
	ALTER COLUMN description_prefix VARCHAR(MAX)
	
	ALTER TABLE [page]
	ADD DEFAULT('') FOR description_prefix
END

----------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddPage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddPage
	@siteId int,
	@predefinedPageId int,
	@parentPageId int = null,
	@pageName varchar(50), 
	@pageTitle varchar(100),
	@pageTitlePrefix varchar(100),
	@pageTitleSuffix varchar(100),
	@descriptionPrefix varchar(MAX),
	@descriptionSuffix varchar(100),
	@keywords varchar(500), 
	@templateName varchar(100),
	@enabled bit,
	@logInToView bit,
	@id int output,
	@created smalldatetime output,
	@hidden bit,
	@navigable bit,
	@navigationTitle varchar(max),
	@sortOrder smallint,
	@defaultTitlePrefix varchar(100)
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO page(site_id, predefined_page_id, parent_page_id, page_name, page_title
			, page_title_prefix, page_title_suffix, description_prefix, description_suffix, keywords 
			, template_name, sort_order, navigable, [hidden], log_in_to_view, [enabled], modified, created, navigation_title, default_title_prefix) 
	VALUES (@siteId, @predefinedPageId, @parentPageId, @pageName, @pageTitle
			, @pageTitlePrefix, @pageTitleSuffix, @descriptionPrefix, @descriptionSuffix, @keywords
			, @templateName, @sortOrder, @navigable, @hidden, @logInToView, @enabled, @created, @created,@navigationTitle, @defaultTitlePrefix) 

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddPage TO VpWebApp
GO

---------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdatePage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdatePage
	@id int,
	@predefinedPageId int,
	@siteId int,
	@parentPageId int,
	@pageName varchar(50),
	@pageTitle varchar(100),
	@pageTitlePrefix varchar(100),
	@pageTitleSuffix varchar(100),
	@descriptionPrefix varchar(MAX),
	@descriptionSuffix varchar(100),
	@keywords varchar(500), 
	@templateName varchar(100),
	@enabled bit,
	@modified smalldatetime output,
	@hidden bit,
	@logInToView bit,
	@navigable bit,
	@navigationTitle varchar(max),
	@sortOrder int,
	@defaultTitlePrefix varchar(100)
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE page 
	SET
		site_id = @siteId,
		predefined_page_id = @predefinedPageId,
		parent_page_id = @parentPageId,
		page_name = @pageName ,
		page_title = @pageTitle,
		page_title_prefix = @pageTitlePrefix,
		page_title_suffix = @pageTitleSuffix,
		description_prefix = @descriptionPrefix,
		description_suffix = @descriptionSuffix,
		keywords = @keywords, 
		template_name = @templateName,
		[enabled] = @enabled,
		modified = @modified,
		[hidden] = @hidden,
		sort_order = @sortOrder,
		navigable = @navigable,
		log_in_to_view = @logInToView,
		navigation_title = @navigationTitle,
		default_title_prefix = @defaultTitlePrefix
	WHERE page_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdatePage TO VpWebApp 
GO