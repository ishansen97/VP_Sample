EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetRandomizedCategoriesByParentCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetRandomizedCategoriesByParentCategoryId
	@categoryId int,
	@noOfCategories int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@noOfCategories) category.category_id AS id, site_id, category_name, category_type_id, description, short_name, specification
			, category.is_search_category, category.is_displayed, matrix_type, category.enabled, category.modified, category.created
			, category.product_count, category.auto_generated, category.hidden, category.has_image, category.url_id
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category.hidden = 0
	ORDER BY NEWID()

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetRandomizedCategoriesByParentCategoryId TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM parameter_type pt WHERE pt.parameter_type_id = 194 
		AND pt.parameter_type = 'SiteRegistrationConfirmationTemplate')
BEGIN
	INSERT INTO parameter_type
	(
		parameter_type_id,
		parameter_type,
		[enabled],
		modified,
		created
	)
	VALUES
	(
		194,
		'SiteRegistrationConfirmationTemplate',
		1,
		GETDATE(),
		GETDATE()
	)
END
GO
-------------------------------------------------------------------------------------------------------------


IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'article') AND name = 'article_sub_title')
	BEGIN
		ALTER TABLE [article]
		ADD [article_sub_title] nvarchar(255)
	END
	GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleBySiteIdList
	@siteId int,
	@isArticleTemplate bit
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,external_url_id,date_published,start_date,end_date,published,article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE site_id = @siteId AND is_article_template = @isArticleTemplate AND deleted = 0

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleBySiteIdTypeIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleBySiteIdTypeIdList
	@siteId int,
	@articleTypeId int,
	@isArticleTemplate bit
AS
-- ==========================================================================
-- $Author akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id, 
			[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
			thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE site_id = @siteId AND article_type_id = @articleTypeId AND is_article_template = @isArticleTemplate AND deleted = 0
	ORDER BY article_title

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdTypeIdList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleBySiteIdPageList
	@siteId int,
	@sortBy varchar(20),
	@startIndex int,
	@endIndex int,
	@isArticleTemplate bit,
	@featuredLevel int,
	@articleTypes varchar(200),
	@numberOfRows int output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicArticle_GetArticleBySiteIdPageList.sql $
-- $Revision: 8028 $
-- $Date: 2010-12-15 16:22:58 +0530 (Wed, 15 Dec 2010) $ 
-- $Author: akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH articles AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY article_title) AS titleRowNumber
			, ROW_NUMBER() OVER (ORDER BY created DESC) AS createdRowNumber
			, article_id AS id, article_type_id, site_id, article_title
			, article_summary, [enabled], modified, created, article_short_title, article_sub_title
			, date_published, start_date, end_date, published, external_url_id, is_article_template, is_external
			, featured_identifier, thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM article
		WHERE [enabled] = '1' AND is_article_template = @isArticleTemplate AND ((@articleTypes = '' AND site_id = @siteId)  OR article_type_id IN (SELECT [value] FROM Global_Split(@articleTypes, ',')))
	)
	
	SELECT id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created, article_short_title, article_sub_title, date_published, start_date, end_date, published, external_url_id
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
				[enabled], modified, created, article_short_title, article_sub_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code,article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles
			WHERE (row BETWEEN @startIndex AND @endIndex) AND ((@featuredLevel & featured_identifier > 0) OR @featuredLevel = 0)
		END
	ELSE
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, article_sub_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles
			WHERE ((@featuredLevel & featured_identifier > 0) OR @featuredLevel = 0)
		END

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdPageList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleBySiteIdTypeIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleBySiteIdTypeIdPageList
	@siteId int,
	@articleTypeId int,
	@startRowIndex int,
	@endRowIndex int
AS
-- ==========================================================================
-- $Author akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, 
			published, external_url_id,[enabled], modified, created,article_short_title,is_article_template,is_external,
			featured_identifier,thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM	
	(
		SELECT  ROW_NUMBER() OVER (ORDER BY article_id ASC) AS row, article_id AS id, article_type_id, site_id,
				 article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id, 
				[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
				thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM article
		WHERE site_id = @siteId AND article_type_id = @articleTypeId AND deleted = 0
	) AS arti
	WHERE row BETWEEN @startRowIndex AND @endRowIndex
END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdTypeIdPageList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetContentArticlesByContentIdsFeaturedLevelsArticleTypes'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetContentArticlesByContentIdsFeaturedLevelsArticleTypes
	@contentType int,
	@contentIds varchar(200),
	@articleTypes varchar(200),
	@isArticleTemplate bit,
	@featuredLevels int
AS
-- ==========================================================================
-- $Author: akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT distinct a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_sub_title, a.article_summary, 
			a.[enabled], a.modified, a.created, a.article_short_title, a.is_article_template, a.is_external, 
			a.featured_identifier, a.thumbnail_image_code, a.external_url_id, a.date_published, 
			a.start_date, a.end_date, a.published, a.article_template_id, a.open_new_window, a.flag1, flag2, a.flag3, a.flag4, a.search_content_modified, deleted
	FROM article a
	INNER JOIN content_to_content cc 
		ON cc.associated_content_type_id = @contentType AND cc.associated_content_id IN (SELECT [value] FROM Global_Split(@contentIds, ',')) AND cc.content_id = a.article_id AND a.is_article_template = @isArticleTemplate
	WHERE a.deleted = 0 AND (a.article_type_id IN (SELECT [value] FROM Global_Split(@articleTypes, ',')) OR @articleTypes = '') AND ((@featuredLevels & a.featured_identifier > 0) OR @featuredLevels = 0)
	
END
GO

GRANT EXECUTE ON dbo.publicArticle_GetContentArticlesByContentIdsFeaturedLevelsArticleTypes TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArtical_GetArticleByAuthorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArtical_GetArticleByAuthorId
	@isArticleTemplate bit,
	@authorIds varchar(200)
AS
-- ==========================================================================
-- $Author: akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT art.article_id as id, art.article_type_id, art.site_id, art.article_title, art.article_sub_title, art.article_summary,art.date_published,art.start_date,art.end_date,art.published,art.external_url_id,
		art.[enabled], art.modified, art.created,art.article_short_title,art.is_article_template,art.is_external,art.featured_identifier,
		art.thumbnail_image_code,art.article_template_id, open_new_window, art.flag1, art.flag2, art.flag3, art.flag4, art.search_content_modified, art.deleted
	FROM  article art
		INNER JOIN article_to_author ata
			ON art.article_id= ata.article_id AND art.is_article_template = @isArticleTemplate
	
	WHERE art.deleted = 0 AND ata.author_id in (SELECT [value] FROM Global_Split(@authorIds, ',')) 

END
GO

GRANT EXECUTE ON dbo.publicArtical_GetArticleByAuthorId TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

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
	@publishedOnly bit,
	@vendorId int
AS
-- ==========================================================================
-- $Author: akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF(@vendorId IS NOT NULL)
	BEGIN
		SELECT TOP (@selectLimit) article_id as id, article_type_id, a.site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id,
			a.[enabled], a.modified, a.created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM  article a
		INNER JOIN content_to_content ct
			ON a.article_id = ct.content_id
		WHERE a.site_id = @siteId AND article_title like @value+'%' AND (@isEnabled IS NULL OR a.enabled = @isEnabled) AND (@isTemplate IS NULL OR is_article_template = @isTemplate)
			AND (@articleTypeId IS NULL OR article_type_id = @articleTypeId) AND (@publishedOnly IS NULL OR date_published < GETDATE()) AND deleted = 0
			AND ct.content_type_id = 4 AND ct.associated_content_type_id = 6 AND ct.associated_content_id = @vendorId
	END
	
	ELSE
	BEGIN
		SELECT TOP (@selectLimit) article_id as id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id,
			[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM  article 
		WHERE site_id = @siteId AND article_title like @value+'%' AND (@isEnabled IS NULL OR enabled = @isEnabled) AND (@isTemplate IS NULL OR is_article_template = @isTemplate)
			AND (@articleTypeId IS NULL OR article_type_id = @articleTypeId) AND (@publishedOnly IS NULL OR date_published < GETDATE()) AND deleted = 0
	END

END
GO

GRANT EXECUTE ON adminArticle_GetArticlesBySiteIdLikeArticleName TO VpWebApp
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTemplateByTypeId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTemplateByTypeId
	@articleTypeId int
AS
-- ==========================================================================
-- $Author: akila $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_id as id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_type_id = @articleTypeId
		AND is_article_template = 1 AND deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTemplateByTypeId TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSize'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSize
	@siteId int,
	@batchSize int,
	@isTemplate bit
AS
-- ==========================================================================
-- $Author: Akila$
-- ==========================================================================
BEGIN
	
SET NOCOUNT ON;

SELECT TOP (@batchSize) article_id AS id, article.article_type_id, article.site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id,
		article.[enabled],article. modified, article.created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM (article
			INNER JOIN article_type
				ON article.article_type_id = article_type.article_type_id)
			LEFT OUTER JOIN content_text
				ON article_id = content_text.content_id AND content_text.content_type_id = 4			
	WHERE article.site_id = @siteId
		AND article.enabled = 1
		AND	(content_text.modified IS NULL OR article.modified > content_text.modified)
		AND (is_article_template = @isTemplate)
		AND (content_based = 0)

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSize TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSizeModifiedArticleSection'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSizeModifiedArticleSection
	@siteId int,
	@batchSize int,
	@isTemplate bit
AS
-- ==========================================================================
-- $Author: Akila$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

SELECT TOP (@batchSize) article.article_id as id, article.article_type_id, article.site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id,
		article.[enabled],article. modified, article.created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
			INNER JOIN article_type
				ON article.article_type_id = article_type.article_type_id
			INNER JOIN article_section
				ON article.article_id = article_section.article_id
			INNER JOIN content_text
				ON article.article_id = content_text.content_id AND content_text.content_type_id = 4
	WHERE (article.site_id = @siteId) 
		AND article.enabled = 1 AND article_section.enabled = 1 AND is_article_template = 0
		AND	(article_section.modified > content_text.modified)
		AND (article_section.is_template_section = @isTemplate)
		AND (content_based = 0)

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSizeModifiedArticleSection TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleBySiteIdBatchSizeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleBySiteIdBatchSizeList
	@siteId int,
	@isArticleTemplate bit,
	@startRowIndex int,
	@batchSize int,
	@contentBased bit
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) article_id AS id, article.article_type_id, article.site_id, article_title, article_sub_title, article_summary, 
		article.[enabled], article.modified, article.created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,external_url_id,date_published,start_date,end_date,published,article_template_id, open_new_window, 
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
			INNER JOIN article_type 
				ON article.article_type_id = article_type.article_type_id
	WHERE (@siteId IS NULL OR article.site_id = @siteId) AND (is_article_template = @isArticleTemplate)
			AND (article_Id NOT IN (SELECT TOP (@startRowIndex - 1) article_Id FROM article ORDER BY article_Id))
			AND article_type.content_based = @contentBased AND article.deleted = 0
	ORDER BY article_Id

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdBatchSizeList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticlesByContentTypeContentIdAndArticleTypeIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticlesByContentTypeContentIdAndArticleTypeIdList	
	@contentTypeId int,
	@contentId int,
	@articleTypeId int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_sub_title, a.article_summary, 
		a.[enabled], a.modified, a.created, a.article_short_title, a.is_article_template, a.is_external, a.featured_identifier,
		a.thumbnail_image_code, a.external_url_id, a.date_published, a.start_date, a.end_date, a.published, a.article_template_id, a.open_new_window,
		a.flag1, flag2, a.flag3, a.flag4, a.search_content_modified, a.deleted
	FROM article a
			INNER JOIN content_to_content ca 
					ON a.article_id = ca.content_id
					AND ca.content_type_id = 4 -- article
	WHERE a.is_article_template = 0
			AND a.[enabled] = 1
			AND ca.associated_content_type_id = @contentTypeId
			AND ca.associated_content_id = @contentId
			AND a.article_type_id = @articleTypeId
			

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticlesByContentTypeContentIdAndArticleTypeIdList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Akila $
-- ========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_id] as id, article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, 
	is_article_template, is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, 
	is_template, article_template_id, open_new_window,[enabled], created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM [article]
	WHERE site_id = @siteId AND [article_title] LIKE '%' + @search + '%' AND deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetArticleBySiteIdSearchList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedArticlesBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedArticlesBySiteId
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) article_id as id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE enabled = 1 AND site_id = @siteId AND deleted = 0 AND article_id NOT IN 
		(	SELECT content_id 
			FROM search_content_status
			WHERE site_id=@siteId AND content_type_id = 4
		) 

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedArticlesBySiteId TO VpWebApp 

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

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetRecentlyModifiedIndexedArticles'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetRecentlyModifiedIndexedArticles
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(@batchSize) 
			article.article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
			[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, 
			flag3, flag4, search_content_modified, deleted
	FROM
	(
		SELECT article_id 
		FROM article 
			INNER JOIN search_content_status
				ON search_content_status.content_type_id = 4 AND search_content_status.content_id = article.article_id
		WHERE article.modified > search_content_status.modified AND article.site_id = @siteId AND article.deleted = 0

		UNION

		SELECT article_id FROM
		(
			SELECT article_id, max(modified) as modified
			FROM article_section
			GROUP BY article_id
		)AS a_s
			INNER JOIN search_content_status
				ON search_content_status.content_type_id = 4 AND search_content_status.content_id = a_s.article_id
		WHERE a_s.modified > search_content_status.modified AND search_content_status.site_id = @siteId

		UNION

		SELECT DISTINCT article_id FROM 
		(
			SELECT article_section_id, max(modified) AS modified
			FROM article_resource
			GROUP BY article_section_id
		) AS a_r
			INNER JOIN article_section
				ON a_r.article_section_id = article_section.article_section_id
			INNER JOIN search_content_status
				ON search_content_status.content_type_id = 4 AND search_content_status.content_id = article_section.article_id
		WHERE a_r.modified > search_content_status.modified AND search_content_status.site_id = @siteId
	) AS a
	INNER JOIN article
		ON a.article_id = article.article_id
	
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetRecentlyModifiedIndexedArticles TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesByVendorIdArticleTypeIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesByVendorIdArticleTypeIdList	
	@vendorId int,
	@siteId int,
	@articleTypeId int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_sub_title, a.article_summary, 
			a.[enabled], a.modified, a.created, a.article_short_title, a.is_article_template, a.is_external, 
			a.featured_identifier, a.thumbnail_image_code, a.external_url_id, a.date_published, 
			a.start_date, a.end_date, a.published, a.article_template_id, a.open_new_window, a.flag1, flag2, a.flag3, a.flag4, a.search_content_modified, deleted
	FROM article a
			INNER JOIN content_to_content ca 
				ON a.article_id = ca.content_id
					AND ca.content_type_id = 4 -- article
	WHERE a.is_article_template = 0
			AND ca.associated_content_type_id = 6 -- vendor
			AND ca.associated_content_id = @vendorId AND a.article_type_id = @articleTypeId
			AND ca.site_id = @siteId AND ca.associated_site_id = @siteId 
			AND a.deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesByVendorIdArticleTypeIdList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleBySiteIdTargetSiteIdPagedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleBySiteIdTargetSiteIdPagedList
	@siteId int,
	@targetSiteId int,
	@startIndex int,
	@endIndex int,
	@rowCount int output
AS
-- ========================================================================
-- $ Author: Akila $
-- ========================================================================
BEGIN
	
	SET NOCOUNT ON;	

	DECLARE @articleType TABLE
	(
		article_type_id int
	)
	
	INSERT INTO	@articleType (article_type_id)
	SELECT associated_content_id 
	FROM content_to_content
	WHERE site_id = @siteId AND associated_site_id = @targetSiteId AND content_type_id = 16 AND associated_content_type_id = 16;

	WITH articles (row, id, article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, is_template, 
		article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted) AS
	(
	SELECT (ROW_NUMBER() OVER (ORDER BY article_id)) AS row, article_id AS id, article.article_type_id, site_id, article_title, article_sub_title, 
		article_summary, article_short_title, is_article_template, is_external, featured_identifier, thumbnail_image_code, 
		date_published, start_date, end_date, published, external_url_id, is_template, article_template_id, open_new_window, enabled, created, modified,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
		INNER JOIN @articleType at
			ON article.article_type_id = at.article_type_id
	WHERE article.enabled = 1 AND is_template = 0
	)

	SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, 
		is_template, article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM articles
	WHERE row BETWEEN @startIndex AND @endIndex

	SELECT @rowCount = COUNT(*) 
	FROM article
		INNER JOIN @articleType at
			ON article.article_type_id = at.article_type_id
	WHERE article.enabled = 1 AND is_template = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleBySiteIdTargetSiteIdPagedList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleByVendorIdSiteIdPagedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleByVendorIdSiteIdPagedList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@vendorId int,
	@rowCount int output
AS
-- ========================================================================
-- $ Author: Akila $
-- ========================================================================
BEGIN
	
	SET NOCOUNT ON;	

	
	WITH articles (row, id, article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, is_template, 
		article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted) AS
	(
	SELECT (ROW_NUMBER() OVER (ORDER BY article_id)) AS row, article_id AS id, article.article_type_id, article.site_id, article_title, article_sub_title, 
		article_summary, article_short_title, is_article_template, is_external, featured_identifier, thumbnail_image_code, 
		date_published, start_date, end_date, published, external_url_id, is_template, article_template_id, open_new_window, article.enabled, article.created, article.modified,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
		INNER JOIN content_to_content at
			ON article.article_id = at.content_id
	WHERE article.is_template = 0 AND article.site_id = @siteId AND at.associated_content_id = @vendorId
			AND at.content_type_id = 4 AND at.associated_content_type_id = 6 AND article.deleted = 0
	)

	SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, 
		is_template, article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM articles
	WHERE row BETWEEN @startIndex AND @endIndex

	SELECT @rowCount = COUNT(*) 
	FROM article
			INNER JOIN content_to_content at
			ON article.article_id = at.content_id
	WHERE article.is_template = 0 AND article.site_id = @siteId AND at.associated_content_id = @vendorId
			AND at.content_type_id = 4 AND at.associated_content_type_id = 6 AND article.deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleByVendorIdSiteIdPagedList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

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
-- $ Author: Akila $
-- ========================================================================
BEGIN
	
	SET NOCOUNT ON;	

	SELECT TOP (@numberOfArticles) article_id AS id, article.article_type_id, site_id, article_title, article_sub_title, article_summary, 
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

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleLocalized'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleLocalized
	@articleId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id as id, article_type_id, site_id, article_title, article_sub_title, article_summary,date_published,start_date, end_date, published, external_url_id,
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE deleted = 0 AND article_id = @articleId AND ((flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR 
		(flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0))

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleLocalized TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticles_GetRandomizedArticlesForArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticles_GetRandomizedArticlesForArticle
	@articleId int,
	@contentTypeId int,
	@associatedContentTypeId int,
	@maxRandom int,
	@minRandom int,
	@siteId int,
	@associatedSiteId int,
	@numberOfArticles int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE Table #tempRelatedArticles(
		content_to_content_auto_id int,
		associated_content_id int,
		sumNumber int DEFAULT 0
	)

	INSERT INTO #tempRelatedArticles (content_to_content_auto_id, associated_content_id, sumNumber)
		SELECT content_to_content_auto_id, associated_content_id, 
			(SELECT ABS(CAST(NEWID() AS binary(6)) %@maxRandom) + @minRandom) + score AS sumNumber	 	
		FROM content_to_content_auto
		WHERE content_type_id = @contentTypeId 
			AND associated_content_type_id = @associatedContentTypeId
			AND content_id = @articleId 
			AND site_id = @siteId	
			AND associated_site_id = @associatedSiteId	
			AND [enabled] = 1
		ORDER BY score DESC
		
		SELECT TOP(@numberOfArticles) article_id as id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, start_date, end_date, published, external_url_id,
			[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM  article a
			INNER JOIN #tempRelatedArticles t
				ON a. article_id = t.associated_content_id
		ORDER BY t.sumNumber DESC
		
		DROP TABLE #tempRelatedArticles
		
END
GO

GRANT EXECUTE ON publicArticles_GetRandomizedArticlesForArticle TO VpWebApp
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticles_GetIndexedArticlesWithModifiedVendorList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticles_GetIndexedArticlesWithModifiedVendorList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #article_vendor(article_id int, entity_date smalldatetime, status_date smalldatetime)
	CREATE TABLE #article_content(article_id int, entity_date smalldatetime, status_date smalldatetime)

	INSERT INTO #article_content
	SELECT article_id,  cc.modified, scs.modified
	FROM article a
		INNER JOIN content_to_content cc
			ON a.article_id = cc.content_id AND cc.content_type_id = 4
				AND cc.associated_content_type_id = 6 AND a.site_id = @siteId
		INNER JOIN search_content_status scs
			ON scs.content_type_id = 4 AND scs.content_id = a.article_id

	INSERT INTO #article_vendor
	SELECT article_id, v.modified, scs.modified
	FROM article a
		INNER JOIN content_to_content cc
			ON a.article_id = cc.content_id AND cc.content_type_id = 4
				AND cc.associated_content_type_id = 6 AND a.site_id = @siteId
		INNER JOIN vendor v
			ON v.vendor_id = cc.associated_content_id
		INNER JOIN search_content_status scs
			ON scs.content_type_id = 4 AND scs.content_id = a.article_id

	SELECT TOP(@batchSize) 
			article.article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
			[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, 
			flag3, flag4, search_content_modified, deleted
	FROM
	(
		SELECT article_id FROM #article_content WHERE entity_date > status_date
		UNION 
		SELECT article_id FROM #article_vendor WHERE entity_date > status_date
	) AS a
	INNER JOIN article
		ON a.article_id = article.article_id

	DROP TABLE #article_content
	DROP TABLE #article_vendor
	
END
GO

GRANT EXECUTE ON dbo.publicArticles_GetIndexedArticlesWithModifiedVendorList TO VpWebApp 
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

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticles_SearchArticleContentList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticles_SearchArticleContentList
	@siteIds varchar(200),
	@searchText varchar(200),
	@databaseResults int,
	@articleTypeIds varchar(200),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS

-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================

BEGIN	

	SELECT article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, date_published, external_url_id,
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
						ON [KEY] = content_text.content_text_id AND content_text.site_id IN (SELECT [value] FROM Global_Split(@siteIds, ','))
				WHERE content_text.enabled = 1 AND content_text.content_type_id = 4
				ORDER BY RankedTable.RANK DESC	
			)
	
END
GO

GRANT EXECUTE ON dbo.publicArticles_SearchArticleContentList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleByArticleIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleByArticleIdList
@articleIdList VARCHAR(MAX)
	
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_id] AS [Id],[article_type_id],[site_id],[article_title],[article_sub_title],[article_summary],[enabled],[modified],[created],[article_short_title]
      ,[is_article_template],[is_external],[featured_identifier],[thumbnail_image_code],[date_published],[external_url_id],[is_template]
      ,[article_template_id],[open_new_window],[end_date],[flag1],[flag2],[flag3],[flag4],[published],[start_date],[search_content_modified], [deleted]
	FROM [article] a
		INNER JOIN global_split(@articleIdList, ',') AS articleIdList
			ON a.[article_id] = articleIdList.[value]
	WHERE a.[deleted] = 0

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleByArticleIdList TO VpWebApp 

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesByArticleTemplateId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesByArticleTemplateId
	@articleTemplateId int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,external_url_id,date_published,start_date,end_date,published,article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_template_id = @articleTemplateId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesByArticleTemplateId TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
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

------------------------------------------------------------------------------------------------------------------------------------------

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
	@authorId int,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Akila $
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
	)
	
	SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
		[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
		, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
		, flag1, flag2, flag3, flag4, search_content_modified, deleted
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
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles
			WHERE (row BETWEEN @startIndex AND @endIndex)
		END
	ELSE
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles			
		END
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds
	@articleTypeIds NVARCHAR(MAX),
	@siteId INT,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH FeaturedVendorArticles AS
	(
		SELECT v.[vendor_id], a.[article_id] AS [id],a.[article_type_id],a.[site_id],a.[article_title],a.[article_sub_title],a.[article_summary],a.[enabled]
			,a.[modified],a.[created],a.[article_short_title],a.[is_article_template],a.[is_external],a.[featured_identifier]
			,a.[thumbnail_image_code],a.[date_published],a.[external_url_id],a.[is_template],a.[article_template_id]
			,a.[open_new_window],a.[end_date],a.[flag1],a.[flag2],a.[flag3],a.[flag4],a.[published],a.[start_date]
			,a.[legacy_content_id],a.[search_content_modified],a.[deleted], ROW_NUMBER() OVER (ORDER BY a.[article_title]) AS rowNumber
		FROM [article] a
			INNER JOIN vendor_parameter vp
				ON vp.[vendor_parameter_value] = a.[article_id] AND vp.[parameter_type_id] = 174
			INNER JOIN vendor_parameter vp2
				ON vp2.[vendor_id] = vp.[vendor_id] AND vp2.[parameter_type_id] = 179 AND (
						vp2.[vendor_parameter_value] LIKE '5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5' OR 
						vp2.[vendor_parameter_value] = '5')
			INNER JOIN vendor v 
				ON v.[vendor_id] = vp2.[vendor_id]
		WHERE v.[site_id] = @siteId AND v.[enabled] = 1 AND a.[enabled] = 1 AND a.[published] = 1 AND (
				@articleTypeIds IS NULL OR 
				a.[article_type_id] IN (
						SELECT gs.[value] 
						FROM dbo.global_Split(@articleTypeIds, ',') gs
					)
			)
	)
	
	SELECT [vendor_id], [id], [article_type_id], [site_id], [article_title], [article_sub_title], [article_summary], [enabled]
		, [modified], [created], [article_short_title], [is_article_template], [is_external], [featured_identifier]
		, [thumbnail_image_code], [date_published], [external_url_id], [is_template], [article_template_id]
		, [open_new_window], [end_date], [flag1], [flag2], [flag3], [flag4], [published], [start_date]
		, [legacy_content_id], [search_content_modified], [deleted]
	FROM FeaturedVendorArticles
	WHERE rowNumber BETWEEN @startIndex AND @endIndex
	
	SELECT @totalCount = COUNT(*)
	FROM [article] a
			INNER JOIN vendor_parameter vp
				ON vp.[vendor_parameter_value] = a.[article_id] AND vp.[parameter_type_id] = 174
			INNER JOIN vendor_parameter vp2
				ON vp2.[vendor_id] = vp.[vendor_id] AND vp2.[parameter_type_id] = 179 AND (
						vp2.[vendor_parameter_value] LIKE '5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5' OR 
						vp2.[vendor_parameter_value] = '5')
			INNER JOIN vendor v 
				ON v.[vendor_id] = vp2.[vendor_id]
		WHERE v.[site_id] = @siteId AND v.[enabled] = 1 AND a.[enabled] = 1 AND a.[published] = 1 AND (
				@articleTypeIds IS NULL OR 
				a.[article_type_id] IN (
						SELECT gs.[value] 
						FROM dbo.global_Split(@articleTypeIds, ',') gs
					)
			)

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

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
	@articleSubTitle nvarchar(255),
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
-- $Author: Akila $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO article (article_type_id, site_id, article_title, article_sub_title, article_summary, modified, created, [enabled],
	article_short_title,is_article_template,is_external,featured_identifier,thumbnail_image_code,external_url_id,date_published,article_template_id, open_new_window, start_date, end_date, published, 
	flag1, flag2, flag3, flag4, search_content_modified, deleted)
	VALUES (@articleTypeId, @siteId, @articleTitle, @articleSubTitle, @articleSummary, @created, @created, @enabled,
	@articleShortTitle,@isArticleTemplate,@isExternal,@featuredIdentifier,@thumbnailImageCode,@externalUrlId,@datePublished,@articleTemplateId, @openNewWindow, @startDate, @endDate, @published,
	@flag1, @flag2, @flag3, @flag4, @searchContentModified, @deleted)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticle TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------

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
	@articleSubTitle nvarchar(255),
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
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE article
	SET
		article_type_id = @articleTypeId,
		site_id = @siteId,
		article_title = @articleTitle,
		article_sub_title = @articleSubTitle,
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

------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleDetail
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicArticle_GetArticleDetail.sql $
-- $Revision: 7145 $
-- $Date: 2010-10-27 11:04:27 +0530 (Wed, 27 Oct 2010) $ 
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id as id, article_type_id, site_id, article_title, article_sub_title, article_summary,date_published,start_date,end_date,published,external_url_id,
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleDetail TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------


