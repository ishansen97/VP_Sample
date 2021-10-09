
EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetAllUsersBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetAllUsersBySiteId
	@siteId int 
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user_id] AS id, aspnet_user_id, first_name, last_name
	, salutation_id, email_html, is_supper_user, user_status_type_id, country_id
	, enabled, modified, created, two_factor_enabled
	FROM [user]
	WHERE is_supper_user = '1' OR [user_id] IN 
	(
		SELECT [user_id]
		FROM user_to_role
		WHERE (site_id = @siteId OR site_id IS NULL)
	)
		
END
GO

GRANT EXECUTE ON dbo.adminUser_GetAllUsersBySiteId TO VpWebApp
GO

