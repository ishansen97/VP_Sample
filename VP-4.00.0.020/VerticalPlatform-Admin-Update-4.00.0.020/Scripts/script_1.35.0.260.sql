IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 157)
BEGIN
	INSERT INTO parameter_type VALUES (157, 'GuidedBrowseModuleTitleDefaultRule', '1', GETDATE(), GETDATE())
END

--------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentToContentByContentIdOrAssociatedContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentToContentByContentIdOrAssociatedContentIdList
	@contentTypeId int,
	@contentId int,
	@pageStart int,
	@pageEnd  int,
	@pageCount int out
AS
-- ==========================================================================
-- $Author:  Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT (ROW_NUMBER() over (order by content_type_id, associated_content_type_id, sort_order))  AS row_num, content_to_content_id AS id
		, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id, sort_order INTO #ContentToContentAssociation
	FROM content_to_content
	WHERE (content_type_id = @contentTypeId AND content_id = @contentId) OR 
			(associated_content_type_id = @contentTypeId AND associated_content_id = @contentId)
	
	SELECT id, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id, sort_order
	FROM #ContentToContentAssociation	
	WHERE row_num BETWEEN @pageStart AND @pageEnd	

	SELECT @pageCount = COUNT(id) FROM #ContentToContentAssociation	

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByContentIdOrAssociatedContentIdList TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentToContentByContentTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentToContentByContentTypeList
	@siteId int,
	@contentTypeId int,
	@associatedContentTypeId int,
	@contentId int,
	@associatedContentId int,
	@pageStart int,
	@pageEnd  int,
	@pageCount int out
AS
-- ==========================================================================
-- $Date:  2013-08-07 $ 
-- $Author:  Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT (ROW_NUMBER() over (order by content_type_id, associated_content_type_id, sort_order))  AS row_num, content_to_content_id AS id
		, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id, sort_order INTO #ContentToContent
	FROM content_to_content 
	WHERE site_id = @siteId AND (content_type_id = @contentTypeId) AND 
		(@associatedContentTypeId IS NULL OR associated_content_type_id = @associatedContentTypeId) AND
		(@contentId IS NULL OR content_id = @contentId) AND
		(@associatedContentId IS NULL OR associated_content_id = @associatedContentId)	

	SELECT id, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id, sort_order
	FROM #ContentToContent	
	WHERE row_num BETWEEN @pageStart AND @pageEnd

	SELECT @pageCount = COUNT(id) FROM #ContentToContent	

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByContentTypeList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesByArticleTemplateId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesByArticleTemplateId
	@articleTemplateId int
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,external_url_id,date_published,start_date,end_date,published,article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_template_id = @articleTemplateId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesByArticleTemplateId TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------
