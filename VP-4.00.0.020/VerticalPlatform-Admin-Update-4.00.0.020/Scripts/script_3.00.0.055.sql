EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GettArticlesByArticleTypeAndSearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GettArticlesByArticleTypeAndSearchOptions
@numberOfItems int,
@articleId int,
@articleTypeIds VARCHAR(255),
@searchoptionIds VARCHAR(255),
@siteId int,
@allArticles BIT
	
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.[article_id] as article_id INTO #temp
	FROM [dbo].[article] a JOIN [dbo].[content_to_content] c ON c.content_id = a.article_id
	WHERE c.[content_type_id] = 4 
	AND c.[associated_content_type_id] = 32 
	AND a.site_id = @siteId
	AND a.article_type_id IN (SELECT [value] from global_split(@articleTypeIds, ','))
	AND [associated_content_id] IN (SELECT [value] from global_split(@searchoptionIds, ',')) 
	
	SELECT top (@numberOfItems) [article_id] as id,[article_type_id],[site_id],[article_title],[article_summary],[enabled],[modified],[created],[article_short_title]
      ,[is_article_template],[is_external],[featured_identifier],[thumbnail_image_code],[date_published],[external_url_id]
      ,[is_template],[article_template_id],[open_new_window],[end_date],[flag1],[flag2],[flag3],[flag4],[published],[start_date],[legacy_content_id]
      ,[search_content_modified],[deleted],[article_sub_title],[exclude_from_search]
	FROM [dbo].[article] 
	WHERE [article_id] IN (SELECT article_id FROM #temp where article_id not in (@articleId)  )
	AND (@allArticles = 1 OR [published] = 1)
	AND [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicArticle_GettArticlesByArticleTypeAndSearchOptions TO VpWebApp 