EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorByEmail'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetAuthorByEmail
	@authorEmail varchar(MAX)	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SELECT [author_id] AS [id], [site_id], [first_name], [last_name], [title], [organization], [position], [department]
      , [enabled], [created], [modified], [profile_html], [has_image], [email], [country_id]
	FROM [author]
	WHERE [email] = @authorEmail AND [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorByEmail TO VpWebApp
GO