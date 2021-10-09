EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchEnabledOptionsByArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchEnabledOptionsByArticleIdsList
	@articleIds varchar(max),
	@associatedContentType int,
	@contentType int

AS
-- ==========================================================================
-- $ Author : Ravindu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled,
		so.modified, ctc.content_id AS article_id
	FROM search_option so
		INNER JOIN search_group sg
			ON sg.search_group_id = so.search_group_id
		INNER JOIN content_to_content ctc
			ON so.search_option_id = ctc.associated_content_id AND 
			ctc.associated_content_type_id = @associatedContentType
		INNER JOIN global_Split(@articleIds, ',') a
			ON a.[value] = ctc.content_id AND
			ctc.content_type_id = @contentType
	WHERE so.enabled = 1 AND sg.search_enabled = 1

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchEnabledOptionsByArticleIdsList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetCommentCountByArticleIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetCommentCountByArticleIds
	@articleIds varchar(max)

AS
-- ==========================================================================
-- $ Author : Ravindu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT a.article_id, SUM(CASE WHEN ac.article_id IS NULL THEN 0 ELSE 1 END) as count
	FROM article a
		INNER JOIN global_Split(@articleIds, ',') splitIds ON splitIds.[value] = a.article_id
		LEFT OUTER JOIN article_comment ac ON a.article_id = ac.article_id AND ac.enabled = 1
		GROUP BY a.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetCommentCountByArticleIds TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedArticlesBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedArticlesBySiteIdWithPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Akila
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedArticle(id, row_id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted)
	AS
	(
		SELECT  id, ROW_NUMBER() OVER (ORDER BY id DESC) AS row_id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM
		(	
			SELECT article_id as id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM article
			WHERE enabled = 1 AND site_id = @siteId
		) AS orderedArticles
	)

	SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM selectedArticle
	WHERE row_id BETWEEN @startIndex AND @endIndex
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedArticlesBySiteIdWithPagingList TO VpWebApp
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticles_GetArticlesToIndexInSearchProviderList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticles_GetArticlesToIndexInSearchProviderList
	@siteId int,
	@batchSize int,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(@batchSize) 
			article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
			[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, 
			flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1
	ORDER BY article_id
	
	SELECT @totalCount = COUNT(*)
	FROM article
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1
	
END
GO

GRANT EXECUTE ON dbo.publicArticles_GetArticlesToIndexInSearchProviderList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentTagsOfContentIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentTagsOfContentIds
	@contentIds varchar(max),
	@contentType int

AS
-- ==========================================================================
-- $ Author : Ravindu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT tg.tag_id as id, ct.content_id, tg.tag, tg.content_tag_id, tg.user_id, tg.is_public_user,
		 tg.enabled, tg.modified, tg.created
	FROM tag tg
		INNER JOIN content_tag ct ON tg.content_tag_id = ct.content_tag_id
		INNER JOIN 	global_Split(@contentIds, ',') splitIds ON splitIds.[value] = ct.content_id AND ct.content_type_id = @contentType

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentTagsOfContentIds TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentViewsOfContentIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentViewsOfContentIds
	@contentIds varchar(max),
	@summaryType int,
	@contentType int

AS
-- ==========================================================================
-- $ Author : Ravindu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT cpvs.content_page_view_summary_id as id, cpvs.summary_type_id, cpvs.content_id, cpvs.views,
	cpvs.site_id, cpvs.content_type_id, cpvs.modified, cpvs.enabled, cpvs.created
	FROM content_page_view_summary cpvs
		INNER JOIN global_Split(@contentIds, ',') splitIds ON splitIds.[value] = cpvs.content_id
		AND cpvs.summary_type_id = @summaryType AND cpvs.content_type_id = @contentType

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentViewsOfContentIds TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedCrossPostedArticlesBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedCrossPostedArticlesBySiteIdWithPagingList
	@targetSiteId int,
	@startIndex int,
	@endIndex int
AS
-- ========================================================================
-- $ Author: Akila $
-- ========================================================================
BEGIN
	SET NOCOUNT ON;	

	SELECT associated_content_id INTO #articleType
	FROM content_to_content
	WHERE site_id = @targetSiteId AND content_type_id = 16 AND associated_content_type_id = 16;

	WITH articles (row, id, article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, is_template, 
		article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted) AS
	(
	SELECT (ROW_NUMBER() OVER (ORDER BY article_id)) AS row, article_id AS id, article.article_type_id, site_id, article_title, article_sub_title, 
		article_summary, article_short_title, is_article_template, is_external, featured_identifier, thumbnail_image_code, 
		date_published, start_date, end_date, published, external_url_id, is_template, article_template_id, open_new_window, enabled, created, modified,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
		INNER JOIN #articleType at
			ON article.article_type_id = at.associated_content_id
	WHERE article.enabled = 1 AND is_template = 0
	)

	SELECT DISTINCT id, article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, 
		is_template, article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM articles
	WHERE row BETWEEN @startIndex AND @endIndex
	
	DROP TABLE #articleType
	
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedCrossPostedArticlesBySiteIdWithPagingList TO VpWebApp 
GO
------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetCrossPostedArticlesToIndexBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetCrossPostedArticlesToIndexBySiteId
	@siteId int,
	@batchSize int,
	@lastIndexedTime smalldatetime,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN

	SELECT associated_content_id INTO #articleType
	FROM content_to_content
	WHERE site_id = @siteId AND content_type_id = 16 AND associated_content_type_id = 16
	
	-- Batchsize to be added
	SELECT DISTINCT article_id AS id, article.article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, 
		is_template, article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	INNER JOIN #articleType at
	ON article.article_type_id = at.associated_content_id
	WHERE article.enabled = 1 AND is_template = 0 AND article.modified > @lastIndexedTime
	
	SELECT @totalCount = COUNT(*)
	FROM article
	INNER JOIN #articleType at
	ON article.article_type_id = at.associated_content_id
	WHERE article.enabled = 1 AND is_template = 0 AND article.modified > @lastIndexedTime

	DROP TABLE #articleType
	
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetCrossPostedArticlesToIndexBySiteId TO VpWebApp 
GO
------------------------------------------------------------------------------------------------------------------------------------------

