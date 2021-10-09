EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserFieldsOfUsers'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserFieldsOfUsers	
	@publicUserIds varchar(max)
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_field_id AS id, public_user_id, field_id, field_value, is_field_option, [enabled], modified, created
	FROM public_user_field
	WHERE public_user_id IN 
		(
			SELECT [value] FROM dbo.global_Split(@publicUserIds, ',')
		)
		
END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserFieldsOfUsers TO VpWebApp 
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserFieldOptionsOfUserFields'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserFieldOptionsOfUserFields	
	@publicUserFieldIds varchar(max)
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT  public_user_field_to_field_option_id AS id, public_user_field_id, field_option_id, [enabled], modified, created
	FROM public_user_field_to_field_option
	WHERE public_user_field_id IN 
		(
			SELECT [value] FROM dbo.global_Split(@publicUserFieldIds, ',')
		)
		
END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserFieldOptionsOfUserFields TO VpWebApp 
GO
