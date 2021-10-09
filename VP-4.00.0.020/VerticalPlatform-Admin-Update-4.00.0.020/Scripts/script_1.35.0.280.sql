
IF NOT EXISTS(SELECT * FROM module WHERE module_name = 'ContextualArticle')
BEGIN
INSERT INTO module (module_name, usercontrol_name, enabled, created, modified, is_container)
 VALUES('ContextualArticle', '~/Modules/Article/ContextualArticle.ascx', 1, GETDATE(), GETDATE(), 0)
END
GO
-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds
	@articleTemplateId int,
	@searchOptionIds varchar(max),
	@showUnpublished bit
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @optionCount int
	
	SELECT id,value INTO #searchOption
	FROM dbo.global_Split(@searchOptionIds, ',') so
	
	SELECT @optionCount = count(value)
	FROM #searchOption
	
	SELECT article_id INTO #articleId
	FROM article a 
		INNER JOIN content_to_content c  
			ON a.article_id = c.content_id AND c.content_type_id = 4 AND c.associated_content_type_id = 32
		LEFT OUTER JOIN #searchOption so 
			ON c.associated_content_id = so.value
	WHERE a.article_template_id = @articleTemplateId 
		AND (@showUnpublished = 1 OR a.enabled = 1)
	GROUP BY article_id
	HAVING count(associated_content_id) = @optionCount
		
	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, external_url_id, date_published, start_date, end_date, published, article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article 
	WHERE article_id IN (SELECT article_id FROM #articleId)

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds TO VpWebApp 
GO
