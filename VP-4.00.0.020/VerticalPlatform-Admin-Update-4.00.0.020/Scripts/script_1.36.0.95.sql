IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[review_type]') AND name = 'review_tracking_emails')
BEGIN
	ALTER TABLE review_type
	 ADD review_tracking_emails varchar(max) null
END

------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_AddReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_AddReviewType]
	@id int output,
	@siteId int,
	@articleTypeTemplateId int,
	@sortOrder int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@hasImage bit,
	@created smalldatetime output,	
	@description varchar(MAX),
	@confirmationEmailTemplate varchar(MAX),
	@publishedEmailTemplate varchar(MAX),
	@reviewTrackingEmails varchar(max)
	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [review_type] (site_id, name, title, [enabled], modified, created, has_image, [description],[sort_order], article_type_template_id, confirmation_email_template, published_email_template, review_tracking_emails)
	VALUES (@siteId, @name, @title, @enabled, @created, @created, @hasImage, @description, @sortOrder, @articleTypeTemplateId, @confirmationEmailTemplate, @publishedEmailTemplate, @reviewTrackingEmails)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminReviewType_AddReviewType TO VpWebApp 
GO

-----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_UpdateReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_UpdateReviewType]
	@id int,
	@siteId int,
	@articleTypeTemplateId int,
	@sortOrder int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@hasImage bit,	
	@description varchar(MAX),
	@confirmationEmailTemplate varchar(MAX),
	@publishedEmailTemplate varchar(MAX),
	@reviewTrackingEmails varchar(max)
	 
AS
-- ==========================================================================
-- $Author: Eranga $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[review_type]
	SET site_id = @siteId,
		article_type_template_id = @articleTypeTemplateId,
		[name] = @name,
		title = @title,
		[enabled] = @enabled,		
		modified = @modified,
		has_image = @hasImage,
		[sort_order] = @sortOrder,
		[description] = @description,
		[confirmation_email_template] = @confirmationEmailTemplate,
		[published_email_template] = @publishedEmailTemplate,
		review_tracking_emails = @reviewTrackingEmails
	WHERE review_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminReviewType_UpdateReviewType TO VpWebApp 
GO

-----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicReviewType_GetReviewTypeDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_template_id, [name], title, enabled, created, modified, 
		[has_image], [description], [sort_order], [confirmation_email_template], [published_email_template], [review_tracking_emails]
	FROM [review_type]	
	WHERE review_type_id = @id 

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetail TO VpWebApp 
GO

-------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteId
@siteId int
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_template_id, [name], title, enabled, created, modified, 
		[has_image], [description], [sort_order], [confirmation_email_template], [published_email_template], review_tracking_emails
	FROM [review_type]	
	WHERE site_id = @siteId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteId TO VpWebApp 
GO

----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId
@siteId int,
@articleTypeId int
	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [review_type].review_type_id as id, [review_type].site_id, [review_type].article_type_template_id, [review_type].[name], 
		[review_type].title, [review_type].enabled, [review_type].created, [review_type].modified, [review_type].[has_image], [review_type].[description], 
		[review_type].[sort_order], [review_type].[confirmation_email_template], [review_type].[published_email_template], [review_type].[review_tracking_emails]
	FROM [review_type]	
		INNER JOIN article_type_template 
			ON review_type.article_type_template_id = article_type_template.article_type_template_id
	WHERE [review_type].site_id = @siteId AND article_type_template.article_type_id = @articleTypeId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId TO VpWebApp 
GO

---------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_GetReviewTypeBySiteIdPageList'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_GetReviewTypeBySiteIdPageList]
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM review_type
	WHERE site_id = @siteId;

	WITH temp_review_type (row, id, site_id, article_type_template_id, name, title, [enabled], created, modified, has_image, [description], [sort_order], [confirmation_email_template], [published_email_template], review_tracking_emails) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY sort_order ASC) AS row, review_type_id as id, site_id, article_type_template_id, name, title, [enabled]
			, created, modified, has_image, [description], [sort_order], [confirmation_email_template], [published_email_template], review_tracking_emails
		FROM review_type
		WHERE site_id = @siteId
	)

	SELECT id, site_id, article_type_template_id, name, title, [enabled], created, modified, has_image, [description], [sort_order]
		, [confirmation_email_template], [published_email_template], review_tracking_emails
	FROM temp_review_type
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO
GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypeBySiteIdPageList TO VpWebApp 
GO
-----------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_GetReviewTypesWithForms'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminReviewType_GetReviewTypesWithForms
	@siteId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky
-- ==========================================================================
BEGIN
	
	SELECT rt.review_type_id AS id, rt.has_image, rt.article_type_template_id, rt.name, rt.title, 
		rt.[description], rt.[enabled], rt.modified, rt.created, rt.site_id, rt.sort_order, 
		rt.[confirmation_email_template], rt.[published_email_template], rt.review_tracking_emails
	FROM review_type rt
		INNER JOIN form fm
			ON fm.content_id = rt.review_type_id
	WHERE  fm.site_id = @siteId AND fm.content_type_id = 37

END
GO

GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypesWithForms TO VpWebApp 
GO
------------------------------------------------------------------------
------- Removing Article Type Page_id Column(Clean up)             -----
------------------------------------------------------------------------

--IF EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[article_type]') AND name = 'page_id')
--BEGIN
--	ALTER TABLE article_type
--	 DROP page_id
--END

-----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticleType
	@id int output,
	@siteId int,
	@articleTypeName varchar(50),
	@created smalldatetime output, 
	@enabled bit,
	@contentBased bit
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO article_type (site_id, article_type, modified, created, [enabled], content_based)
	VALUES (@siteId, @articleTypeName, @created, @created, @enabled, @contentBased)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticleType TO VpWebApp
GO
-----------------------------------------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleType
	@id int,
	@siteId int,
	@articleTypeName varchar(50),
	@enabled bit,
	@modified smalldatetime output,
	@contentBased bit
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE article_type
	SET
		site_id = @siteId, 
		article_type = @articleTypeName,
		[enabled] = @enabled,
		modified = @modified,
		content_based = @contentBased
	WHERE article_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleType TO VpWebApp 
GO
--------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleTypeDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleTypeDetail
	@id int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_type_id as id, site_id, article_type, [enabled], modified, 
		created, content_based
	FROM article_type
	WHERE article_type_id = @id

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleTypeDetail TO VpWebApp 
GO
------------------------------------------------------------------------------

--

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleTypeBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleTypeBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_type_id as id, site_id, article_type, [enabled], modified, 
		created, content_based
	FROM article_type
	WHERE site_id = @siteId 
	ORDER BY article_type

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleTypeBySiteIdList TO VpWebApp 
GO
-------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeByPageId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeByPageId
	@pageId int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT at.article_type_id as id, at.site_id, at.article_type, at.[enabled], at.modified, 
		at.created, at.content_based
	FROM article_type at
		INNER JOIN article_type_template att ON at.article_type_id = att.article_type_id
	WHERE att.page_id = @pageId 
	ORDER BY article_type

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTypeByPageId TO VpWebApp 
GO
---------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleTypeCounts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleTypeCounts
	@productId int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT at.article_type_id as id, at.site_id, at.article_type, at.[enabled], at.modified, at.created, count(a.article_id) as article_count
			, content_based
	FROM article_type at
			INNER JOIN article a 
					ON at.article_type_id = a.article_type_id
			INNER JOIN content_to_content ca 
					ON a.article_id = ca.content_id AND ca.content_type_id = 4
					AND ca.associated_content_type_id = 2 AND ca.enabled = 1
	WHERE  ca.associated_content_id = @productId
			AND a.enabled = 1
	GROUP BY  at.article_type_id, at.site_id, at.article_type, at.[enabled], at.modified, at.created, content_based
	
END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleTypeCounts TO VpWebApp 
GO
------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeBySiteIdLikeTypeNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeBySiteIdLikeTypeNameList
	@siteId int,
	@search varchar(255),
	@limit int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@limit) article_type_id AS id, site_id, article_type, [enabled], modified, 
		created, content_based
	FROM article_type
	WHERE site_id = @siteId AND article_type LIKE @search + '%'

END
GO

GRANT EXECUTE ON adminArticle_GetArticleTypeBySiteIdLikeTypeNameList TO VpWebApp
GO
-----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeBySiteIdPageList
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1)
	SET @endIndex = @pageSize * @pageIndex

	SELECT @numberOfRows = COUNT(*)
	FROM article_type
	WHERE site_id = @siteId;

	WITH temp_article_type (row, id, site_id, article_type, [enabled], modified, 
		created, content_based) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY article_type) AS row, article_type_id AS id, site_id,
			article_type, [enabled], modified, created, content_based
		FROM article_type
		WHERE site_id = @siteId
	)

	SELECT id, site_id, article_type, [enabled], modified, created, content_based
	FROM temp_article_type
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON adminArticle_GetArticleTypeBySiteIdPageList TO VpWebApp
GO

-------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeByArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeByArticleIdsList
	@articleIds VARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_type_id AS id, site_id, article_type, [enabled], modified, 
		created, content_based
	FROM article_type
	WHERE article_type_id IN
	(
		SELECT article_type_id FROM article WHERE article_id IN (SELECT [value] FROM Global_Split(@articleIds, ','))
	)

END
GO

GRANT EXECUTE ON adminArticle_GetArticleTypeByArticleIdsList TO VpWebApp
GO
-----------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeListByArticleIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeListByArticleIds
	@articleIds VARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT arti_type.article_type_id AS id, arti_type.site_id, arti_type.article_type, arti_type.[enabled],
		 arti_type.modified, arti_type.created, arti_type.content_based, arti.article_id
	FROM article_type arti_type
		INNER JOIN article arti
			ON arti.article_type_id = arti_type.article_type_id
		INNER JOIN global_Split(@articleIds, ',') AS article_id_table
			ON arti.article_id = article_id_table.[value]

END
GO

GRANT EXECUTE ON adminArticle_GetArticleTypeListByArticleIds TO VpWebApp
GO
-------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetSegmentsBySiteAndTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetSegmentsBySiteAndTypeList
	@siteId int,
	@segmentType int,
	@campaignStatusIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT s.segment_id AS id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	FROM segment s 
		INNER JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		INNER JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE s.site_id = @siteId AND s.segment_type = @segmentType 
		  AND (@campaignStatusIds IS NULL OR c.status IN (select value from global_Split(@campaignStatusIds, ',')))
	ORDER BY s.[name] ASC


END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetSegmentsBySiteAndTypeList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

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
	@campaignStatus int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF @campaignStatus < 0
	BEGIN

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
	
	ELSE IF @campaignStatus = 1
	BEGIN	
	
	SELECT DISTINCT s.segment_id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	INTO #temp_campaign_status1
	FROM segment s 
		INNER JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		INNER JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE c.status = 1 OR c.status = 2 OR c.status = 3 OR c.status = 4 OR c.status = 5 OR c.status = 6 AND s.site_id = @siteId;
		
	WITH temp_segments1(idAsc, idDesc, nameAsc, nameDesc, typeAsc, typeDesc, createdAsc, createdDesc, modifiedAsc, modifiedDesc,
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
		FROM #temp_campaign_status1
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
	)

	SELECT segment_id AS id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
	FROM temp_segments1
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
		FROM segment s
			INNER JOIN #temp_campaign_status1
			ON #temp_campaign_status1.segment_id = s.segment_id
		WHERE s.site_id = @siteId 
			AND (@segmentTypeId IS NULL OR s.segment_type = @segmentTypeId)
			AND (@segmentName = '' OR (s.[name] like  '%' + @segmentName + '%'))
		
	END
	
	ELSE
	BEGIN
	
	SELECT DISTINCT s.segment_id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	INTO #temp_campaign_status2
		FROM segment s 
		INNER JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		INNER JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE c.status = 7 OR c.status = 8 OR c.status = 9 OR c.status = 10 AND s.site_id = @siteId;
	
	WITH temp_segments2(idAsc, idDesc, nameAsc, nameDesc, typeAsc, typeDesc, createdAsc, createdDesc, modifiedAsc, modifiedDesc,
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
		FROM #temp_campaign_status2
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
	)
	
	SELECT segment_id AS id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
	FROM temp_segments2
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
		FROM segment s
			INNER JOIN #temp_campaign_status2
			ON #temp_campaign_status2.segment_id = s.segment_id
		WHERE s.site_id = @siteId 
			AND (@segmentTypeId IS NULL OR s.segment_type = @segmentTypeId)
			AND (@segmentName = '' OR (s.[name] like  '%' + @segmentName + '%'))
		
	END
	
	
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'SearchHeader')
BEGIN
	INSERT INTO module ([module_name], [usercontrol_name], [enabled], [modified], [created], [is_container])
	VALUES('SearchHeader','~/Modules/Content Search/SearchHeader.ascx','1',GETDATE(),GETDATE(), 0)
END
GO