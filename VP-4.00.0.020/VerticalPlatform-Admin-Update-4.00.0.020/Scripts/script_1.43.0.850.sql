EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesForSiteWithPaging';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesForSiteWithPaging
    @siteId INT,
	@pageStart INT,
	@pageEnd INT,
    @totalCount INT OUTPUT
AS
-- ==========================================================================
-- $Date: 2019-12-05 $ 
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;

    SELECT (ROW_NUMBER() OVER (ORDER BY article_id)) AS row,
           [article].article_id AS id
    INTO #Articles
    FROM [article] WITH (NOLOCK)
    WHERE deleted = 0
          AND is_article_template = 0
          AND site_id = @siteId;


    SELECT art.article_id AS id,
           art.article_type_id,
           art.site_id,
           art.article_title,
           art.article_sub_title,
           art.article_summary,
           art.[enabled],
           art.modified,
           art.created,
           art.article_short_title,
           art.is_article_template,
           art.is_external,
           art.featured_identifier,
           art.thumbnail_image_code,
           art.external_url_id,
           art.date_published,
           art.start_date,
           art.end_date,
           art.published,
           art.article_template_id,
           art.open_new_window,
           art.flag1,
           art.flag2,
           art.flag3,
           art.flag4,
           art.search_content_modified,
           art.deleted,
		   art.exclude_from_search,
           tmp.row
    FROM #Articles tmp
        INNER JOIN article art WITH(NOLOCK)
            ON art.article_id = tmp.id
    WHERE tmp.row
    BETWEEN @pageStart AND @pageEnd;

	--output
    SELECT @totalCount = COUNT(1)
    FROM #Articles;

END;
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesForSiteWithPaging TO VpWebApp;
GO