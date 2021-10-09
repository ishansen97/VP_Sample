EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList'
/****** Object:  StoredProcedure [dbo].[adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList]    Script Date: 7/20/2021 1:02:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList]
	@siteId int,
	@sortBy varchar(20),
	@startIndex int,
	@endIndex int,
	@articleTypes varchar(200),
	@startDate smalldatetime,
	@endDate smalldatetime,
	@title varchar(max),
	@authorId int,
	@numberOfRows int output,
	@articleId int
AS
-- ==========================================================================
-- $Author: Chinthaka Fernando$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;


	WITH articles AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY a.article_title) AS titleRowNumber
			, ROW_NUMBER() OVER (ORDER BY a.created DESC) AS createdRowNumber
			, ROW_NUMBER() OVER (ORDER BY (first_name + ' ' + last_name)) AS authorRowNumber
			, a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_sub_title
			, a.article_summary, a.[enabled], a.modified, a.created, a.article_short_title
			, a.date_published, a.start_date, a.end_date, a.published, a.external_url_id, a.is_article_template, a.is_external
			, a.featured_identifier, a.thumbnail_image_code,a.article_template_id, a.open_new_window, a.flag1, a.flag2, a.flag3, a.flag4, a.search_content_modified, a.deleted
			, a.exclude_from_search
		FROM article a
		LEFT JOIN article_to_author at
			ON at.article_id = a.article_id
		LEFT JOIN author aa
			ON aa.author_id = at.author_id
		WHERE a.is_article_template = 0 
			AND ((@articleTypes = '' AND a.site_id = @siteId) OR a.article_type_id IN (SELECT [value] FROM Global_Split(@articleTypes, ',')))
			AND (a.article_title LIKE (@title + '%') OR @title IS NULL)
			AND (@startDate IS NULL OR a.created BETWEEN @startDate AND (@endDate+1))
			AND a.deleted = 0 
			AND (@authorId IS NULL OR @authorId = aa.author_id)
			AND (@articleId IS NULL OR @articleId = a.article_id)
	)
	
	SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
		[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
		, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
		, flag1, flag2, flag3, flag4, search_content_modified, deleted, exclude_from_search
		, CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
			WHEN 'Author' THEN authorRowNumber
			
		END AS row
	INTO #tempArticles
	FROM articles
	ORDER BY 
		CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
			WHEN 'Author' THEN authorRowNumber
		END

	SELECT @numberOfRows = COUNT(*)
	FROM #tempArticles	

	IF((@startIndex IS NOT NULL) AND (@endIndex IS NOT NULL))
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code,article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted, exclude_from_search
			FROM #tempArticles
			WHERE (row BETWEEN @startIndex AND @endIndex)
			ORDER BY row
		END
	ELSE
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted, exclude_from_search
			FROM #tempArticles	
			ORDER BY row
		END
END
GO

GRANT EXECUTE ON [dbo].[adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList] TO [VpPublicWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList] TO [VpAdminWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList] TO [VpTest] AS [dbo]

GRANT EXECUTE ON [dbo].[adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList] TO [VpAdminWeb] AS [dbo]
