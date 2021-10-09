EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds
	@articleTemplateId int,
	@searchOptionIds varchar(max),
	@showUnpublished bit,
	@categoryId int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	DECLARE @optionCount int
	
	SELECT id,value INTO #searchOption
	FROM dbo.global_Split(@searchOptionIds, ',') so
	
	SELECT @optionCount = COUNT(value)
	FROM #searchOption
	
	SELECT article_id INTO #articleId
	FROM article a 
		INNER JOIN content_to_content cso  
			ON a.article_id = cso.content_id AND cso.content_type_id = 4 AND cso.associated_content_type_id = 32
		INNER JOIN content_to_content ccat 
			ON a.article_id = ccat.content_id AND ccat.content_type_id = 4 AND ccat.associated_content_type_id = 1
		INNER JOIN #searchOption so 
			ON cso.associated_content_id = so.value
	WHERE a.article_template_id = @articleTemplateId 
		AND (@showUnpublished = 1 OR a.enabled = 1)
		AND ccat.associated_content_id = @categoryId
		AND	a.deleted = 0
	GROUP BY article_id
	HAVING COUNT(cso.associated_content_id) = @optionCount
		
	SELECT article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, external_url_id, date_published, start_date, end_date, published, article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_id IN (
		SELECT article_id
		FROM #articleId a
			INNER JOIN content_to_content ctc  
				ON a.article_id = ctc.content_id AND ctc.content_type_id = 4 AND ctc.associated_content_type_id = 32
		GROUP BY a.article_id
		HAVING COUNT(ctc.associated_content_id) = @optionCount
	)

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds TO VpWebApp 
GO
