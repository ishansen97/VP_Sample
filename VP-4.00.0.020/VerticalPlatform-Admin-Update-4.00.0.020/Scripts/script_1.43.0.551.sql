
---------------------------------
-- Akila
---------------------------------
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'action_url' AND Object_ID = Object_ID(N'action_url'))
BEGIN
    ALTER TABLE action_url
	ALTER COLUMN action_url varchar(2000)
END
GO
---------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminActionUrl_AddActionUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminActionUrl_AddActionUrl
	@id int output,
	@actionId int,
	@actionUrl varchar(2000),
	@contentTypeId int,
	@contentId int,
	@enabled bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@created smalldatetime output,
	@newWindow bit
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO action_url (action_id, action_url, content_type_id, content_id, enabled ,flag1, flag2, flag3, flag4,
		created, modified, new_window)
	VALUES (@actionId, @actionUrl, @contentTypeId, @contentId, @enabled, @flag1, @flag2, @flag3, @flag4, 
		@created, @created, @newWindow)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminActionUrl_AddActionUrl TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminActionUrl_UpdateActionUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminActionUrl_UpdateActionUrl
	@id int output,
	@actionId int,
	@actionUrl varchar(2000),
	@contentTypeId int,
	@contentId int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@enabled bit,
	@modified smalldatetime output,
	@newWindow bit
AS
-- ==========================================================================
-- $Author: Akila $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.action_url
	SET action_id = @actionId,
		action_url =  @actionUrl,
		content_type_id = @contentTypeId,
		content_id = @contentId,
		[enabled] = @enabled,		
		modified = @modified,
		new_window = @newWindow,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4
	WHERE action_url_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminActionUrl_UpdateActionUrl TO VpWebApp 
GO