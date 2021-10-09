EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticle
	@id int output,
	@articleTypeId int,
	@siteId int,
	@articleTitle varchar(500),
	@articleSummary varchar(max),	
	@created smalldatetime output, 
	@enabled bit,
	@articleShortTitle varchar(255),
	@isArticleTemplate bit,
	@isExternal bit,
	@openNewWindow bit,
	@featuredIdentifier varchar(3),
	@thumbnailImageCode varchar(255),
	@externalUrlId int,
	@articleTemplateId int,
	@datePublished smalldatetime,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@published bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint, 
	@searchContentModified bit,
	@deleted bit
AS
-- ========================================================================== 
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO article (article_type_id, site_id, article_title, article_summary, modified, created, [enabled],
	article_short_title,is_article_template,is_external,featured_identifier,thumbnail_image_code,external_url_id,date_published,article_template_id, open_new_window, start_date, end_date, published, 
	flag1, flag2, flag3, flag4, search_content_modified, deleted)
	VALUES (@articleTypeId, @siteId, @articleTitle, @articleSummary, @created, @created, @enabled,
	@articleShortTitle,@isArticleTemplate,@isExternal,@featuredIdentifier,@thumbnailImageCode,@externalUrlId,@datePublished,@articleTemplateId, @openNewWindow, @startDate, @endDate, @published,
	@flag1, @flag2, @flag3, @flag4, @searchContentModified, @deleted)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticle TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList
	@siteId int,
	@sortBy varchar(20),
	@startIndex int,
	@endIndex int,
	@articleTypes varchar(200),
	@startDate smalldatetime,
	@endDate smalldatetime,
	@title varchar(max),
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH articles AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY article_title) AS titleRowNumber
			, ROW_NUMBER() OVER (ORDER BY created DESC) AS createdRowNumber
			, article_id AS id, article_type_id, site_id, article_title
			, article_summary, [enabled], modified, created, article_short_title
			, date_published, start_date, end_date, published, external_url_id, is_article_template, is_external
			, featured_identifier, thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM article
		WHERE is_article_template = 0 AND ((@articleTypes = '' AND site_id = @siteId)  OR article_type_id IN (SELECT [value] FROM Global_Split(@articleTypes, ',')))
			AND (article_title LIKE (@title + '%') OR @title IS NULL)
			AND (@startDate IS NULL OR created BETWEEN @startDate AND (@endDate+1))
			AND deleted = 0
	)
	
	SELECT id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
		, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
		, flag1, flag2, flag3, flag4, search_content_modified, deleted
		, CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
		END AS row
	INTO #tempArticles
	FROM articles
	ORDER BY 
		CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
		END

	SELECT @numberOfRows = COUNT(*)
	FROM #tempArticles	

	IF((@startIndex IS NOT NULL) AND (@endIndex IS NOT NULL))
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code,article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles
			WHERE (row BETWEEN @startIndex AND @endIndex)
		END
	ELSE
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles			
		END
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleBySiteIdTargetSiteIdTitleList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleBySiteIdTargetSiteIdTitleList
	@siteId int,
	@targetSiteId int,
	@searchText varchar(100),
	@numberOfArticles int
AS
-- ========================================================================
-- $ Author: Dimuthu $
-- ========================================================================
BEGIN
	
	SET NOCOUNT ON;	

	SELECT TOP (@numberOfArticles) article_id AS id, article.article_type_id, site_id, article_title, article_summary, 
		article_short_title, is_article_template, is_external, featured_identifier, thumbnail_image_code, date_published, 
		start_date, end_date, published, external_url_id, is_template, article_template_id, open_new_window, enabled, created, modified,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_type_id IN 
		(
			SELECT associated_content_id 
			FROM content_to_content
			WHERE site_id = @siteId AND associated_site_id = @targetSiteId AND content_type_id = 16 AND associated_content_type_id = 16
		)
		AND article.enabled = 1 AND is_template = 0 AND article_title LIKE @searchText + '%'

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleBySiteIdTargetSiteIdTitleList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesBySiteIdLikeArticleName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesBySiteIdLikeArticleName
	@siteId int,
	@value varchar(max),
	@isEnabled bit,
	@selectLimit int,
	@isTemplate bit,
	@articleTypeId int,
	@publishedOnly bit
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@selectLimit) article_id as id, article_type_id, site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM  article
	WHERE site_id = @siteId AND article_title like @value+'%' AND (@isEnabled IS NULL OR enabled = @isEnabled) AND (@isTemplate IS NULL OR is_article_template = @isTemplate)
		AND (@articleTypeId IS NULL OR article_type_id = @articleTypeId) AND (@publishedOnly IS NULL OR date_published < GETDATE()) AND deleted = 0

END
GO

GRANT EXECUTE ON adminArticle_GetArticlesBySiteIdLikeArticleName TO VpWebApp
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticle
	@id int,
	@articleTypeId int,
	@siteId int,
	@articleTitle varchar(500),
	@articleSummary varchar(max),	
	@enabled bit,
	@articleShortTitle varchar(255),
	@isArticleTemplate bit,
	@isExternal bit,
	@openNewWindow bit,
	@featuredIdentifier varchar(3),
	@thumbnailImageCode varchar(255),
	@externalUrlId int,
	@datePublished smalldatetime,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@published bit,
	@articleTemplateId int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchContentModified bit,
	@modified smalldatetime output,
	@deleted bit
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE article
	SET
		article_type_id = @articleTypeId,
		site_id = @siteId,
		article_title = @articleTitle,
		article_summary = @articleSummary,		
		[enabled] = @enabled,
		modified = @modified,
		article_short_title =@articleShortTitle,
		is_article_template = @isArticleTemplate,
		is_external = @isExternal,
		featured_identifier = @featuredIdentifier,
		thumbnail_image_code = @thumbnailImageCode,
		external_url_id = @externalUrlId,
		date_published = @datePublished,
		start_date = @startDate,
		end_date = @endDate,
		published = @published,
		article_template_id = @articleTemplateId,
		open_new_window = @openNewWindow,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		search_content_modified = @searchContentModified,
		deleted = @deleted
	WHERE article_id = @id
 

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticle TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetArticleBySiteIdSearchList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetArticleBySiteIdSearchList
	@siteId int,
	@search varchar(255),
	@numberOfItems int 
AS
-- ========================================================================
-- $Author: Dimuthu $
-- ========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_id] as id, article_type_id, site_id, article_title, article_summary, article_short_title, 
	is_article_template, is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, 
	is_template, article_template_id, open_new_window,[enabled], created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM [article]
	WHERE site_id = @siteId AND [article_title] LIKE '%' + @search + '%' AND deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetArticleBySiteIdSearchList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticles_SearchArticleContentList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticles_SearchArticleContentList
	@siteId int,
	@searchText varchar(200),
	@databaseResults int,
	@articleTypeIds varchar(200),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS

-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================

BEGIN	

	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, 
		flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE  	(@articleTypeIds IS NULL OR article_type_id IN (SELECT [value] FROM Global_Split(@articleTypeIds, ','))) AND
			((flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR (flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0)) AND
			article_id IN
			(
				SELECT TOP(@databaseResults) content_id
				FROM FREETEXTTABLE(content_text, *, @searchText) RankedTable
					INNER JOIN content_text
						ON [KEY] = content_text.content_text_id AND content_text.site_id = @siteId
				WHERE content_text.enabled = 1 AND content_text.content_type_id = 4
				ORDER BY RankedTable.RANK DESC	
			)
	
END
GO

GRANT EXECUTE ON dbo.publicArticles_SearchArticleContentList TO VpWebApp 
GO
