--===== adminArticle_GetArchivingArticleIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArchivingArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArchivingArticleIdsList
@limit INT = 10
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) art.article_id AS [id]
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
												  AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
	ORDER BY art.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO


--==== adminArticle_UpdateArchivedByArtcle

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArchivedByArtcle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArchivedByArtcle
	@last_rundate DATETIME
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE	art
	SET		art.archived = 1
	FROM	article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
												  AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
	WHERE	art.modified > @last_rundate
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
END
GO

GRANT EXECUTE ON adminArticle_UpdateArchivedByArtcle TO VpWebApp
GO



