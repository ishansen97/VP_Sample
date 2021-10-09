EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeByArticleTypeIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeByArticleTypeIdsList
	@articleTypeIds VARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_type_id AS id, site_id, article_type, [enabled], modified, 
		created, content_based
	FROM article_type
	WHERE article_type_id IN
	(
		SELECT [value] FROM Global_Split(@articleTypeIds, ',')
	)

END
GO

GRANT EXECUTE ON adminArticle_GetArticleTypeByArticleTypeIdsList TO VpWebApp
GO