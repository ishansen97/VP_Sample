EXEC dbo.global_DropStoredProcedure 'dbo.publicAction_GetQuestionaireTypeActionsBySite'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicAction_GetQuestionaireTypeActionsBySite
	@siteId INT
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.action_id as id, a.site_id,a.action_type,a.name,a.title,a.enabled,a.modified,a.created,
	a.landing_page_id,a.alternate_link_text
	from action a with(nolock) join lead_type_questionnaire q on q.action_id = a.action_id
	WHERE a.site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.publicAction_GetQuestionaireTypeActionsBySite TO VpWebApp 
GO