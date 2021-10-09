
IF NOT EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'article_type_template_id' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'review_type') AND type in (N'U'))
)
BEGIN
ALTER TABLE [review_type]
ADD [article_type_template_id] int NULL
END
GO

--- Populating column ---------------------------------
IF EXISTS( SELECT * FROM review_type WHERE article_type_template_id IS NULL)
BEGIN
	UPDATE review_type
	SET article_type_template_id = temp.article_type_template_id
	FROM (
		SELECT att.article_type_id, min(att.article_type_template_id) as article_type_template_id
		FROM review_type
		inner join article_type_template att ON review_type.article_type_id = att.article_type_Id
		group by review_type_id, att.article_type_id
		) temp
	INNER JOIN review_type ON temp.article_type_id = review_type.article_type_id
END
GO

--- Alter article type id to accept null (no longer in use) ----
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'article_type_id' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'review_type') AND type in (N'U'))
)
BEGIN
ALTER TABLE [review_type]
ALTER COLUMN [article_type_id] int NULL
END
GO

---------------------------------------------------------------------------
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
	@description varchar(MAX)
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [review_type] (site_id, name, title, [enabled], modified, created, has_image, [description],[sort_order], article_type_template_id)
	VALUES (@siteId, @name, @title, @enabled, @created, @created, @hasImage, @description, @sortOrder, @articleTypeTemplateId)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminReviewType_AddReviewType TO VpWebApp 
GO
----------------------------------------------------------------------------
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
	@description varchar(MAX)
	 
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
		[description] = @description
	WHERE review_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminReviewType_UpdateReviewType TO VpWebApp 
GO

----------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicReviewType_GetReviewTypeDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_template_id, [name], title, enabled, created, modified, [has_image], [description],[sort_order]
	FROM [review_type]	
	WHERE review_type_id = @id 

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetail TO VpWebApp 
GO
-------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteId
@siteId int
	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_template_id, [name], title, enabled, created, modified, [has_image], [description],[sort_order]
	FROM [review_type]	
	WHERE site_id = @siteId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteId TO VpWebApp 
GO
------------------------------------------------------------------------

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

	SELECT review_type_id as id, [review_type].site_id, [review_type].article_type_template_id, [name], title, [review_type].enabled, [review_type].created, [review_type].modified, [has_image], [description],[sort_order]
	FROM [review_type]	
		INNER JOIN article_type_template 
			ON review_type.article_type_template_id = article_type_template.article_type_template_id
	WHERE [review_type].site_id = @siteId AND article_type_template.article_type_id = @articleTypeId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId TO VpWebApp 
GO

------------------------------------------------------------------------------
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
-- $Author: Eranga
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

	WITH temp_review_type (row, id, site_id, article_type_template_id, name, title, [enabled], created, modified, has_image, [description],[sort_order]) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY sort_order ASC) AS row, review_type_id as id, site_id, article_type_template_id, name, title, [enabled], created, modified, has_image, [description],[sort_order]
		FROM review_type
		WHERE site_id = @siteId
	)

	SELECT id, site_id, article_type_template_id, name, title, [enabled], created, modified, has_image, [description],[sort_order]
	FROM temp_review_type
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO
GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypeBySiteIdPageList TO VpWebApp 
GO
---------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_GetReviewTypesWithForms'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminReviewType_GetReviewTypesWithForms
	@siteId int
AS
-- ==========================================================================
-- $Author: Eranga
-- ==========================================================================
BEGIN
	
	SELECT rt.review_type_id AS id, rt.has_image, rt.article_type_template_id, rt.name, rt.title, 
		rt.[description], rt.[enabled], rt.modified, rt.created, rt.site_id, rt.sort_order 
	FROM review_type rt
		INNER JOIN form fm
			ON fm.content_id = rt.review_type_id
	WHERE  fm.site_id = @siteId AND fm.content_type_id = 37

END
GO

GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypesWithForms TO VpWebApp 
GO

--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeTemplateBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeTemplateBySiteId
	@siteId int
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT article_type_template_id AS id, site_id, article_type_id, template_id
		, page_id, [enabled], modified, created
	FROM article_type_template
	WHERE site_id = @siteId
	
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTypeTemplateBySiteId TO VpWebApp 
GO

-----------------------------------------------------------------------
GRANT SELECT ON dbo.article_type_template TO VpWebApp 
GO

-----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleOverallRatingCustomPropertyList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleOverallRatingCustomPropertyList
	@siteId int 	
AS
-- ==========================================================================
-- $Author: Eranga
-- ==========================================================================
BEGIN

	--This query retrieves overall rating custom properties for
	--articles which are not included in the content rating table.
	
	SELECT artcp.article_custom_property_id AS id, artcp.article_id, artcp.custom_property_id,
		artcp.custom_property_value, artcp.modified, artcp.created, artcp.[enabled]
	FROM article_custom_property artcp
		INNER JOIN custom_property cp
			ON cp.custom_property_id = artcp.custom_property_id
		INNER JOIN article a
			ON artcp.article_id = a.article_id
		INNER JOIN (SELECT DISTINCT article_type_template.article_type_id FROM review_type
						INNER JOIN article_type_template ON review_type.article_type_template_id = article_type_template.article_type_template_id) rt 
			ON rt.article_type_id = a.article_type_id
		LEFT JOIN content_rating cr
			ON a.article_id = cr.content_id AND cr.content_type_id = 4
	WHERE cp.property_name = 'Overall' AND
		(@siteId IS NULL OR a.site_id = @siteId)  AND
		cr.content_rating_id IS NULL AND a.[enabled] = 1
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleOverallRatingCustomPropertyList TO VpWebApp
GO
--------------------------------------------------------------------------------------