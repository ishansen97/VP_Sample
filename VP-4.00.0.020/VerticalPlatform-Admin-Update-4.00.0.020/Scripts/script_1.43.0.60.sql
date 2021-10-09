IF NOT EXISTS (SELECT [name] FROM sys.tables where [name] = 'menu_action')
BEGIN

CREATE TABLE [dbo].[menu_action](
	[menu_action_id] [int] IDENTITY(1,1) NOT NULL,
	[menu_action_type_id] [int] NOT NULL,
	[menu_action_text] [varchar](1000),
	[menu_action_custom_css] [varchar](1000),
	[site_id] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	[created] [smalldatetime] NOT NULL
 CONSTRAINT [PK_menu_action] PRIMARY KEY CLUSTERED 
(
	[menu_action_id] ASC,
	[menu_action_type_id],
	[site_id]
)WITH (IGNORE_DUP_KEY = OFF, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetMenuActionDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetMenuActionDetail
	@id int
AS
-- ==========================================================================
-- $Author: Ravindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT menu_action_id AS id, menu_action_type_id, menu_action_text, menu_action_custom_css, site_id,[enabled], modified, created
	FROM menu_action
	WHERE menu_action_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetMenuActionDetail TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddMenuAction'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddMenuAction
	@menuActionTypeId int,
	@menuActionText varchar(1000),
	@menuActionCustomCss varchar(1000),
	@siteId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Ravindu $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO menu_action(menu_action_type_id, menu_action_text, menu_action_custom_css, site_id, [enabled], modified, created)
	VALUES (@menuActionTypeId, @menuActionText, @menuActionCustomCss, @siteId, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddMenuAction TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteMenuAction'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteMenuAction
	@id int
AS
-- ==========================================================================
-- $Author: Ravindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM menu_action
	WHERE menu_action_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteMenuAction TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateMenuAction'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateMenuAction
	@id int,
	@menuActionTypeId int,
	@menuActionText varchar(1000),
	@menuActionCustomCss varchar(1000),
	@siteId int,
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Ravindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE menu_action
	SET menu_action_type_id = @menuActionTypeId,
	menu_action_text = @menuActionText, 
	menu_action_custom_css = @menuActionCustomCss, 
	site_id = @siteId, 
	enabled = @enabled,
	modified = @modified
	WHERE menu_action_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateMenuAction TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetMenuActionListBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetMenuActionListBySiteId	
	@siteId int
AS
-- ==========================================================================
-- $Author: Ravindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ma.menu_action_id AS id, ma.menu_action_type_id, ma.menu_action_text,
		ma.menu_action_custom_css, ma.site_id, ma.[enabled], ma.modified, ma.created
	FROM menu_action ma
	WHERE ma.site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetMenuActionListBySiteId TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetMenuActionByType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetMenuActionByType
	@siteId int,
	@menuActionType int
AS
-- ==========================================================================
-- $Author: Ravindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT menu_action_id AS id, menu_action_type_id, menu_action_text, menu_action_custom_css, site_id,[enabled], modified, created
	FROM menu_action
	WHERE site_id = @siteId AND menu_action_type_id = @menuActionType

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetMenuActionByType TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteMenuActionListBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteMenuActionListBySiteId
	@siteId int
AS
-- ==========================================================================
-- $Author: Ravindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM menu_action
	WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteMenuActionListBySiteId TO VpWebApp 
GO
