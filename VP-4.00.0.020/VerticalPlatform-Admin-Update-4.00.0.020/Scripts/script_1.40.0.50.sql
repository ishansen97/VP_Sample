
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_DeleteCampaignUserByUserId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_DeleteCampaignUserByUserId
	@userId int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM campaign_to_user
	WHERE user_id = @userId

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_DeleteCampaignUserByUserId TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUserApplicationMessages'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUserApplicationMessages
	@userId int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT am.application_message_id AS id, am.site_id, am.application_type, am.message_type, am.message_text, am.show, am.[created], am.[enabled], am.[modified], am.start_date,am.end_date
	FROM application_message am
		INNER JOIN user_to_application_message uam
			ON uam.application_message_id = am.application_message_id
	WHERE uam.user_id = @userId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUserApplicationMessages TO VpWebApp 
GO