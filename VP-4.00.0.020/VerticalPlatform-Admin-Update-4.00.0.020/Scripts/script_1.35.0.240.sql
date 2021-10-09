IF (NOT EXISTS(SELECT 1 from module where module_name = 'CategoryQuickLinks'))
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES('CategoryQuickLinks', '~/Modules/Category/CategoryQuickLinks.ascx', 1, GetDate(),GetDate(), 0)
END
GO

IF NOT EXISTS(SELECT 1 FROM parameter_type where parameter_type_id = 156)
BEGIN
	INSERT parameter_type(parameter_type_id, parameter_type, enabled, modified, created)
	VALUES (156, 'CategoryQuickLinks', 1, getdate(), getdate())
END
GO

IF NOT EXISTS (SELECT content_type_id FROM content_type WHERE content_type_id = 38)
BEGIN
	INSERT INTO content_type
     VALUES (38 ,'GuidedBrowse' ,1 ,getdate() ,getdate())
END

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@segmentName varchar(200),
	@segmentTypeId int,
	@sortBy varchar(20),
	@sortOrder varchar(20),
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_segments(idAsc, idDesc, nameAsc, nameDesc, typeAsc, typeDesc, createdAsc, createdDesc, modifiedAsc, modifiedDesc,
		segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable) AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY segment_id) AS idAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_id DESC) AS idDesc, 
			ROW_NUMBER() OVER (ORDER BY name) AS nameAsc, 
			ROW_NUMBER() OVER (ORDER BY name DESC) AS nameDesc,
			ROW_NUMBER() OVER (ORDER BY segment_type) AS typeAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_type DESC) AS typeDesc,
			ROW_NUMBER() OVER (ORDER BY created) AS createdAsc, 
			ROW_NUMBER() OVER (ORDER BY created DESC) AS createdDesc,
			ROW_NUMBER() OVER (ORDER BY modified) AS modifiedAsc, 
			ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedDesc,
			segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
		FROM segment
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
	)

	SELECT segment_id AS id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
	FROM temp_segments
	WHERE 
		(@sortBy = 'id' AND @sortOrder = 'asc' AND idAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'created' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'id' AND @sortOrder = 'desc' AND idDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex) OR
		(@sortBy = 'created' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
		CASE 
			WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idAsc 
			WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameAsc
			WHEN @sortBy = 'type' AND @sortOrder = 'asc' THEN typeAsc
			WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN createdAsc
			WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedAsc
			WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idDesc 
			WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameDesc
			WHEN @sortBy = 'type' AND @sortOrder = 'desc' THEN typeDesc
			WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN createdDesc
			WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedDesc
		END
	
	SELECT @totalCount = COUNT(*)
		FROM segment
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList TO VpWebApp 
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[content_parameter]') AND type in (N'U'))

BEGIN
CREATE TABLE [dbo].[content_parameter](
	[content_parameter_id] [int] IDENTITY(1,1) NOT NULL,
	[content_type_id] [int] NOT NULL,
	[content_id] [int] NOT NULL,
	[content_parameter_type] [varchar](200) NOT NULL,
	[content_parameter_value] [varchar](max) NOT NULL,
	[enabled] [bit] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_content_parameter] PRIMARY KEY CLUSTERED 
(
	[content_parameter_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_content_parameter_content_type') AND parent_object_id = OBJECT_ID(N'content_parameter'))
BEGIN
	ALTER TABLE [dbo].[content_parameter]  WITH CHECK ADD  CONSTRAINT [FK_content_parameter_content_type] FOREIGN KEY([content_type_id])
	REFERENCES [dbo].[content_type] ([content_type_id])
	ALTER TABLE [dbo].[content_parameter] CHECK CONSTRAINT [FK_content_parameter_content_type]
END
GO


-----------------------------------Stored Procedures-------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminContent_AddContentParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminContent_AddContentParameter
	@id int output,
	@created smalldatetime output, 
	@enabled bit,
	@contentTypeId int,
	@contentId int,
	@contentParameterType varchar(200),
	@contentParameterValue varchar(max)
	
AS
-- ==========================================================================
-- $Author: Dasun $
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;
	SET @created = GETDATE()
	INSERT INTO content_parameter(content_type_id,content_id,content_parameter_type,content_parameter_value,created,modified,[enabled]) 
	VALUES(@contentTypeId,@contentId,@contentParameterType,@contentParameterValue,@created,@created,@enabled)

SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminContent_AddContentParameter TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminContent_DeleteContentParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminContent_DeleteContentParameter
	@id int
AS
-- ==========================================================================
-- $Author: Dasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM content_parameter
	WHERE content_parameter_id = @id

	 

END
GO

GRANT EXECUTE ON dbo.adminContent_DeleteContentParameter TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminContent_UpdateContentParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminContent_UpdateContentParameter
    @id int output,
	@contentTypeId int,
	@modified smalldatetime output, 
	@enabled bit,
	@contentId int,
	@contentParameterType varchar(200),
	@contentParameterValue varchar(max)


AS
-- ==========================================================================
-- $Author: Dasun $
-- ==========================================================================

BEGIN
  SET NOCOUNT ON;
  SET @modified = GETDATE()
  UPDATE content_parameter
  SET
	content_type_id=@contentTypeId,
	content_id=@contentId,
	content_parameter_type=@contentParameterType,
	content_parameter_value=@contentParameterValue,
	modified=@modified,
	[enabled]=@enabled
 WHERE 
	content_parameter_id=@id;
	
END
GO

GRANT EXECUTE ON dbo.adminContent_UpdateContentParameter TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicContent_GetContentParameterDetails'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicContent_GetContentParameterDetails
	@id int
AS

-- ==========================================================================
-- $Author: Dasun $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;
	
	SELECT content_parameter_id As id,content_type_id,content_id,content_parameter_type,content_parameter_value,created,modified,[enabled]
	FROM content_parameter
	WHERE content_parameter_id=@id
	
END
GO

GRANT EXECUTE ON dbo.publicContent_GetContentParameterDetails TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicContent_GetContentParameterDetailsByContentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicContent_GetContentParameterDetailsByContentId
	@contentId int,
	@contentType int
AS

-- ==========================================================================
-- $Author: Dasun $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;
	
	SELECT content_parameter_id As id,content_type_id,content_id,content_parameter_type,content_parameter_value,created,modified,[enabled]
	FROM content_parameter
	WHERE content_id=@contentId AND content_type_id =@contentType
	
END
GO

GRANT EXECUTE ON dbo.publicContent_GetContentParameterDetailsByContentId TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicContent_GetContentParameterDetailsByContentIdContentParameterType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicContent_GetContentParameterDetailsByContentIdContentParameterType
	@contentId int,
	@contentParameterType varchar(200),
	@contentType int
AS
-- ==========================================================================
-- $Author: Dasun $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;
	
	SELECT content_parameter_id As id,content_type_id,content_id,content_parameter_type,content_parameter_value,created,modified,[enabled]
	FROM content_parameter
	WHERE content_id=@contentId AND content_parameter_type=@contentParameterType AND content_type_id =@contentType
	
END
GO

GRANT EXECUTE ON dbo.publicContent_GetContentParameterDetailsByContentIdContentParameterType TO VpWebApp 
GO

-- ==========================================================================
-- $Author$ Premuditha
-- ==========================================================================

IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 154)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(154,'CategoryDescriptionSingular','1',GETDATE(),GETDATE())
END

IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 155)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(155,'CategoryDescriptionPlural','1',GETDATE(),GETDATE())
END

------------------------------------------------------------------------------------------------------------------------
-- ==========================================================================
-- $Author Yasodha Hendahewa
-- ==========================================================================

IF NOT EXISTS(
  SELECT *
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE 
    [TABLE_NAME] = 'article'
    AND [COLUMN_NAME] = 'deleted')
BEGIN
  ALTER TABLE [article]
  ADD [deleted] bit NOT NULL DEFAULT 0 
END

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticle
	@id int output,
	@articleTypeId int,
	@siteId int,
	@articleTitle varchar(255),
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
-- $Author: Yasodha Hendahewa
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

----------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticle
	@id int,
	@articleTypeId int,
	@siteId int,
	@articleTitle varchar(255),
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
-- $Author: Yasodha Hendahewa
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

----------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleDetail
	@id int
AS
-- ==========================================================================
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id as id, article_type_id, site_id, article_title, article_summary,date_published,start_date,end_date,published,external_url_id,
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleDetail TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,external_url_id,date_published,start_date,end_date,published,article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE site_id = @siteId AND is_article_template = @isArticleTemplate AND deleted = 0

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id, 
			[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
			thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE site_id = @siteId AND article_type_id = @articleTypeId AND is_article_template = @isArticleTemplate AND deleted = 0
	ORDER BY article_title

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdTypeIdList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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
		WHERE [enabled] = '1' AND is_article_template = @isArticleTemplate AND ((@articleTypes = '' AND site_id = @siteId)  OR article_type_id IN (SELECT [value] FROM Global_Split(@articleTypes, ',')))
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
			WHERE (row BETWEEN @startIndex AND @endIndex) AND ((@featuredLevel & featured_identifier > 0) OR @featuredLevel = 0)
		END
	ELSE
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles
			WHERE ((@featuredLevel & featured_identifier > 0) OR @featuredLevel = 0)
		END

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleBySiteIdPageList TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT id, article_type_id, site_id, article_title, article_summary, date_published, start_date, end_date, 
			published, external_url_id,[enabled], modified, created,article_short_title,is_article_template,is_external,
			featured_identifier,thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM	
	(
		SELECT  ROW_NUMBER() OVER (ORDER BY article_id ASC) AS row, article_id AS id, article_type_id, site_id,
				 article_title, article_summary, date_published, start_date, end_date, published, external_url_id, 
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

-------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT distinct a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_summary, 
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

--------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT art.article_id as id, art.article_type_id, art.site_id, art.article_title, art.article_summary,art.date_published,art.start_date,art.end_date,art.published,art.external_url_id,
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

-----------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTemplateByTypeId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTemplateByTypeId
	@articleTypeId int
AS
-- ==========================================================================
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_id as id, article_type_id, site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_type_id = @articleTypeId
		AND is_article_template = 1 AND deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTemplateByTypeId TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
SET NOCOUNT ON;

SELECT TOP (@batchSize) article_id AS id, article.article_type_id, article.site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
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

------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

SELECT TOP (@batchSize) article.article_id as id, article.article_type_id, article.site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
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

-----------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) article_id AS id, article.article_type_id, article.site_id, article_title, article_summary, 
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

------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_summary, 
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

---------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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

------------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) article_id as id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
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

--------------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedArticle(id, row_id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted)
	AS
	(
		SELECT  id, ROW_NUMBER() OVER (ORDER BY id) AS row_id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM
		(	
			SELECT article_id as id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM article
			WHERE enabled = 1 AND site_id = @siteId
		) AS orderedArticles
	)

	SELECT id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM selectedArticle
	WHERE row_id BETWEEN @startIndex AND @endIndex
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedArticlesBySiteIdWithPagingList TO VpWebApp
GO

-----------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(@batchSize) 
			article.article_id AS id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
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

---------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_summary, 
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

----------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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

	WITH articles (row, id, article_type_id, site_id, article_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, is_template, 
		article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted) AS
	(
	SELECT (ROW_NUMBER() OVER (ORDER BY article_id)) AS row, article_id AS id, article.article_type_id, site_id, article_title, 
		article_summary, article_short_title, is_article_template, is_external, featured_identifier, thumbnail_image_code, 
		date_published, start_date, end_date, published, external_url_id, is_template, article_template_id, open_new_window, enabled, created, modified,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
		INNER JOIN @articleType at
			ON article.article_type_id = at.article_type_id
	WHERE article.enabled = 1 AND is_template = 0
	)

	SELECT id, article_type_id, site_id, article_title, article_summary, article_short_title, is_article_template, 
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

------------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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

------------------------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_id as id, article_type_id, site_id, article_title, article_summary,date_published,start_date, end_date, published, external_url_id,
		[enabled], modified, created,article_short_title,is_article_template,is_external,featured_identifier,
		thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE deleted = 0 AND article_id = @articleId AND ((flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR 
		(flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0))

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleLocalized TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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
		
		SELECT TOP(@numberOfArticles) article_id as id, article_type_id, site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
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
-----------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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
			article.article_id AS id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
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

----------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(@batchSize) 
			article_id AS id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
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

-------------------------------------------------------------------------------------------------------------

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
-- $Author: Yasodha Hendahewa
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

--------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleByArticleIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleByArticleIdList
@articleIdList VARCHAR(MAX)
	
AS
-- ==========================================================================
-- $Author: Yasodha Hendahewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_id] AS [Id],[article_type_id],[site_id],[article_title],[article_summary],[enabled],[modified],[created],[article_short_title]
      ,[is_article_template],[is_external],[featured_identifier],[thumbnail_image_code],[date_published],[external_url_id],[is_template]
      ,[article_template_id],[open_new_window],[end_date],[flag1],[flag2],[flag3],[flag4],[published],[start_date],[search_content_modified], [deleted]
	FROM [article] a
		INNER JOIN global_split(@articleIdList, ',') AS articleIdList
			ON a.[article_id] = articleIdList.[value]
	WHERE a.[deleted] = 0

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleByArticleIdList TO VpWebApp 

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging
	@groupId int,
	@blockedStatus int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@pageSize int,
	@pageIndex int,
	@totalCount int output,
	@ipaddress varchar(50),
	@ipnumeric bigint

AS
-- ==========================================================================
-- $Author: Yasodha Hendahewa $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (row, ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner])
	AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
				(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
				((@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate)) AND
				(((@ipaddress IS NULL OR ip_address LIKE @ipaddress)) AND ((@ipnumeric = 0 OR ip_numeric = @ipnumeric)))
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)			  

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
			(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
			((@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate)) AND
			(((@ipaddress IS NULL OR ip_address LIKE @ipaddress)) AND ((@ipnumeric = 0 OR ip_numeric = @ipnumeric)))

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetPagebySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetPagebySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Yasodha Hendahewa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT  page_id AS id, site_id, predefined_page_id, parent_page_id, page_name
		, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
		, keywords, template_name, sort_order, navigable, hidden,log_in_to_view
		, [enabled], modified, created, navigation_title, default_title_prefix
	FROM page
	WHERE site_id = @siteId
	ORDER BY page_name asc
END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetPagebySiteIdList TO VpWebApp 
GO

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name=N'sort_order' AND Object_ID = OBJECT_ID(N'content_to_content'))
BEGIN 
ALTER TABLE content_to_content
	ADD sort_order int not null default 0
	
END
GO	
	
----------------------------------------
EXEC dbo.global_DropStoredProcedure 'adminPlatform_AddContentToContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminPlatform_AddContentToContent
	@contentId int,
	@contentTypeId int,
	@associatedContentId int,
	@associatedContentTypeId int,
	@siteId int,
	@associatedSiteId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@sortOrder int
AS
-- ==========================================================================
-- $Date: 2013-08-07
-- $Author: Eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO content_to_content
		(content_id, content_type_id, associated_content_id, associated_content_type_id, site_id, associated_site_id
		, [enabled], modified, created, sort_order)
	Values
		(@contentId, @contentTypeId, @associatedContentId, @associatedContentTypeId, @siteId, @associatedSiteId
		, @enabled, @created, @created, @sortOrder)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON adminPlatform_AddContentToContent TO VpWebApp 
GO
------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentToContentDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentToContentDetail
	@id int 
AS
-- ==========================================================================
-- $Date: 2013-08-07 $
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id, content_type_id, associated_content_id, associated_content_type_id, site_id
		,associated_site_id, [enabled], modified, created, sort_order
	FROM content_to_content
	WHERE content_to_content_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentDetail TO VpWebApp 
GO
-----------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateContentToContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateContentToContent
	@id int, 
	@contentId int,
	@contentTypeId int,
	@associatedContentId int,
	@associatedContentTypeId int,
	@enabled bit,
	@siteId int,
	@associatedSiteId int,
	@sortOrder int,
	@modified smalldatetime output	
AS
-- ==========================================================================
-- $Date: 2013-08-07 $ 
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE content_to_content 
	SET
		content_id = @contentId,
		content_type_id = @contentTypeId,
		associated_content_id = @associatedContentId,
		associated_content_type_id = @associatedContentTypeId,
		site_id = @siteId,
		associated_site_id = @associatedSiteId,
		[enabled] = @enabled,
		modified = @modified,
		sort_order = @sortOrder
	WHERE content_to_content_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateContentToContent TO VpWebApp 
Go
----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentToContentByContentTypes'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentToContentByContentTypes
	@siteId int,
	@contentTypeId int,
	@associatedContentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Date:  2013-08-07 $ 
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id, content_type_id, associated_content_id
		, associated_content_type_id, [enabled], modified, created, site_id, associated_site_id, sort_order
	FROM content_to_content
	WHERE site_id = @siteId AND (content_type_id = @contentTypeId) AND 
		(@associatedContentTypeId IS NULL OR associated_content_type_id = @associatedContentTypeId) AND
		(@contentId IS NULL OR content_id = @contentId)
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByContentTypes TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------
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

	SELECT (ROW_NUMBER() over (order by content_to_content_id))  AS row_num, content_to_content_id AS id
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
	ORDER BY sort_order	

	SELECT @pageCount = COUNT(id) FROM #ContentToContent	

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByContentTypeList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------
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

	SELECT (ROW_NUMBER() over (order by content_to_content_id))  AS row_num, content_to_content_id AS id
		, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id, sort_order INTO #ContentToContentAssociation
	FROM content_to_content
	WHERE (content_type_id = @contentTypeId AND content_id = @contentId) OR 
			(associated_content_type_id = @contentTypeId AND associated_content_id = @contentId)
	
	SELECT id, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id, sort_order
	FROM #ContentToContentAssociation	
	WHERE row_num BETWEEN @pageStart AND @pageEnd	
	ORDER BY sort_order

	SELECT @pageCount = COUNT(id) FROM #ContentToContentAssociation	

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByContentIdOrAssociatedContentIdList TO VpWebApp 
GO
--------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'adminArticle_GetContentToContentByContentTypeIdContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminArticle_GetContentToContentByContentTypeIdContentIdList
	@associatedContentTypeId int,
	@contentTypeId int,
	@contentIds varchar(200),
	@siteId int
AS
-- ==========================================================================
-- $Date: 2013-08-07 $ 
-- $Author: Eranga $
-- ==========================================================================

BEGIN

	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id,content_type_id, associated_content_id,associated_content_type_id
		 , [enabled],created,modified,site_id, associated_site_id, sort_order
	FROM content_to_content
	WHERE content_type_id = @contentTypeId AND associated_content_type_id = @associatedContentTypeId 
			AND content_id IN (SELECT [value] FROM Global_Split(@contentIds, ',')) AND site_id = @siteId
	ORDER BY sort_order
END
GO

GRANT EXECUTE ON adminArticle_GetContentToContentByContentTypeIdContentIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetContentToContentByContentIdAssociatedContentIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetContentToContentByContentIdAssociatedContentIdsList
	@associatedContentTypeId int,
	@associatedContentIds varchar(200),
	@contentTypeId int,
	@contentId int,
	@siteId int
AS
-- ==========================================================================
-- $Date: 2013-08-07 $ 
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id, content_type_id, associated_content_id, associated_content_type_id
			, [enabled], created, modified, site_id, associated_site_id, sort_order
	FROM content_to_content
	WHERE content_type_id = @contentTypeId AND content_id = @contentId AND associated_content_type_id = @associatedContentTypeId 
			AND associated_content_id IN (SELECT [value] FROM Global_Split(@associatedContentIds, ',')) AND site_id = @siteId
	ORDER BY sort_order
END
GO

GRANT EXECUTE ON dbo.publicArticle_GetContentToContentByContentIdAssociatedContentIdsList TO VpWebApp 
GO
-------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'adminArticle_GetCrossSiteContentToContentByContentTypeIdContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminArticle_GetCrossSiteContentToContentByContentTypeIdContentIdList
	@associatedContentTypeId int,
	@contentTypeId int,
	@contentIds varchar(max)
AS
-- ==========================================================================
-- $Date: 2013-08-07 $ 
-- $Author: Eranga $
-- ==========================================================================

BEGIN

	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id,content_type_id, associated_content_id,associated_content_type_id
		 , [enabled],created,modified,site_id, associated_site_id, sort_order
	FROM content_to_content
	WHERE content_type_id = @contentTypeId AND associated_content_type_id = @associatedContentTypeId 
			AND content_id IN (SELECT [value] FROM Global_Split(@contentIds, ','))
	ORDER BY sort_order
END
GO

GRANT EXECUTE ON adminArticle_GetCrossSiteContentToContentByContentTypeIdContentIdList TO VpWebApp 
GO
------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetDefaultArticleToCategoryByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetDefaultArticleToCategoryByCategoryId
	@categoryId int 
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cc.content_to_content_id AS id, cc.content_id, cc.content_type_id, cc.associated_content_id, cc.associated_content_type_id, cc.site_id
		,cc.associated_site_id, cc.[enabled], cc.modified, cc.created, cc.sort_order
	FROM content_to_content cc
		INNER JOIN content_to_content_setting ccs ON cc.content_to_content_id = ccs.content_to_content_id AND ccs.setting_name = 'IsDefaultArticleForCategory' AND ccs.setting_value = 'True'
	WHERE cc.associated_content_id = @categoryId AND cc.content_type_id = 4 AND cc.associated_content_type_id = 1 AND cc.[enabled] = 1
	ORDER BY cc.sort_order

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetDefaultArticleToCategoryByCategoryId TO VpWebApp 
GO
------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'adminContent_GetContentToContentByVendorIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminContent_GetContentToContentByVendorIds
	@vendorIds varchar(MAX),
	@contentTypeId int,
	@siteId int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================

BEGIN

	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id,content_type_id, associated_content_id,associated_content_type_id
		 , [enabled],created,modified,site_id, associated_site_id, sort_order
	FROM content_to_content cc
		INNER JOIN (SELECT [value] FROM Global_Split(@vendorIds, ',')) AS ven
			ON ven.value = cc.content_id
	WHERE content_type_id = @contentTypeId 		 
		AND site_id = @siteId	
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON adminContent_GetContentToContentByVendorIds TO VpWebApp 
GO
---------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'adminContent_GetAssociatedContentToContentByVendorIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminContent_GetAssociatedContentToContentByVendorIds
	@vendorIds varchar(MAX),
	@associatedContentTypeId int,
	@siteId int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================

BEGIN

	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id,content_type_id, associated_content_id,associated_content_type_id
		 , [enabled],created,modified,site_id, associated_site_id, sort_order
	FROM content_to_content
	WHERE associated_content_type_id = @associatedContentTypeId 
		AND associated_content_id IN (SELECT [value] FROM Global_Split(@vendorIds, ',')) 
		AND associated_site_id = @siteId
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON adminContent_GetAssociatedContentToContentByVendorIds TO VpWebApp 
GO
----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentToContentByContentTypesAssociatedContentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentToContentByContentTypesAssociatedContentId
	@contentTypeId int,
	@associatedContentTypeId int,
	@associatedContentId int,
	@siteId int
AS
-- ==========================================================================
-- $Date: 2013-08-07 $ 
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_to_content_id AS id, content_id, content_type_id, associated_content_id
		, associated_content_type_id, [enabled], modified, created, site_id, associated_site_id, sort_order
	FROM content_to_content
	WHERE (@contentTypeId IS NULL OR content_type_id = @contentTypeId) AND 
		(associated_content_type_id = @associatedContentTypeId) AND
		(@associatedContentId IS NULL OR associated_content_id = @associatedContentId) AND 
		(@siteId IS NULL OR site_id = @siteId)
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByContentTypesAssociatedContentId TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentToContentByArticleIdGeoLocationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentToContentByArticleIdGeoLocationList
	@siteId int,
	@articleId int,
	@contentCount int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- $Author:  eranga
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@contentCount) content_to_content.content_to_content_id AS id, content_to_content.content_id, content_to_content.content_type_id, content_to_content.associated_content_id
		, content_to_content.associated_content_type_id, content_to_content.[enabled], content_to_content.modified, content_to_content.created,
		 content_to_content.site_id, content_to_content.associated_site_id, sort_order
	FROM content_to_content
	INNER JOIN product
	ON content_to_content.associated_content_id = product.product_id
	WHERE content_to_content.site_id = @siteId AND content_to_content.content_type_id = 4 AND content_to_content.associated_content_type_id = 2 AND
	content_to_content.content_id = @articleId AND
	(
		(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
		(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
	)
	
	AND content_to_content.[enabled] = 1
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByArticleIdGeoLocationList TO VpWebApp 
GO
------------------------------------------------------------------------------------
