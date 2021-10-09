
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_DeleteCampaignContentOfTemplateList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_DeleteCampaignContentOfTemplateList
	@templateId int,
	@contentType int
AS
-- ==========================================================================
-- Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM campaign_content
	WHERE content_type_id = @contentType AND email_template_id = @templateId

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_DeleteCampaignContentOfTemplateList TO VpWebApp 
GO