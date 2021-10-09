/* creating page to content metadata table */


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name = 'content_metadata_to_page')
BEGIN

CREATE TABLE dbo.content_metadata_to_page
	(
	content_metadata_to_page_id int NOT NULL IDENTITY(1,1),
	page_id int NOT NULL,
	content_metadata_id int NOT NULL,
	displayed bit NOT NULL,
	created smalldatetime NOT NULL,
	modified smalldatetime NOT NULL,
	enabled bit NOT NULL,
	)  ON [PRIMARY]
	
	
	END
GO
IF NOT EXISTS (SELECT OBJECT_NAME(constid) FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_content_metadata_to_page_' )
BEGIN


ALTER TABLE dbo.content_metadata_to_page ADD CONSTRAINT
	PK_content_metadata_to_page_ PRIMARY KEY CLUSTERED 
	(
	content_metadata_to_page_id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

GO

IF NOT EXISTS (SELECT OBJECT_NAME(constid) FROM sysconstraints WHERE OBJECT_NAME(constid) = 'IX_content_metadata_to_page_pageid_contentmetadataid' )
BEGIN

ALTER TABLE content_metadata_to_page ADD CONSTRAINT IX_content_metadata_to_page_pageid_contentmetadataid UNIQUE(page_id, content_metadata_id)
END

GO


/* ALTER Content Metadata table */
if not exists(select * from sys.columns 
            where Name = N'noindex' and Object_ID = Object_ID(N'content_metadata'))
            BEGIN
ALTER TABLE content_metadata ADD noindex VARCHAR(255) NUlL

END
GO


/* 01) content metadata SP Changes  > ADD */

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddContentMetadata'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddContentMetadata
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@titleTag varchar(250),
	@keywords varchar(max),
	@description varchar(max),
	@enabled bit,	
	@created smalldatetime output,
	@noindex varchar(250)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO content_metadata (site_id, content_type_id, content_id, title_tag, keywords, description,
		[enabled], created, noindex)
	VALUES (@siteId, @contentTypeId, @contentId, @titleTag, @keywords, @description,
		@enabled, @created, @noindex)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddContentMetadata TO VpWebApp 
GO

/* 02) content metadata SP Changes  > EDIT */


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateContentMetadata'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminPlatform_UpdateContentMetadata]
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@titleTag varchar(250),
	@keywords varchar(max),
	@description varchar(max),
	@noindex varchar(250),
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE content_metadata
	SET
		site_id = @siteId,
		content_type_id = @contentTypeId,
		content_id = @contentId,
		title_tag = @titleTag,
		keywords = @keywords,
		description = @description,
		noindex = @noindex,
		[enabled] = @enabled,
		modified = @modified
	WHERE content_metadata_id = @id

END
GO

GRANT EXECUTE ON adminPlatform_UpdateContentMetadata TO VpWebApp
GO


/* 03) content metadata SP Changes  > GET */


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadata'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadata
	@id int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_metadata_id as id, site_id, content_type_id, content_id, title_tag, keywords, description, enabled, modified, created, noindex
	FROM content_metadata
	WHERE  content_metadata_id = @id
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadata TO VpWebApp 
GO


-- Get content metadata information
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadataInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadataInformation
	@siteId int,
	@contentTypeId int,
	@pageStart int,
	@pageEnd int,
	@recordCount int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT s.site_name, cm.content_metadata_id as id, cm.site_id, cm.content_type_id, cm.content_id, cm.title_tag, cm.keywords, cm.description, 
			CASE WHEN c.category_name IS NOT NULL THEN c.category_name END
			AS content_name, 
			CASE WHEN c.created IS NOT NULL THEN c.created END
			AS content_created,
			CASE WHEN c.modified IS NOT NULL THEN c.modified END
			AS content_modified,
			cm.enabled, cm.modified, cm.created, cm.noindex into #contentMetadata
	FROM content_metadata cm
			INNER JOIN site s 
			ON s.site_id = cm.site_id
			LEFT OUTER JOIN category c
			ON cm.content_id = c.category_id AND cm.content_type_id = 1
	WHERE  ((cm.content_type_id = @contentTypeId) OR (@contentTypeId IS NULL))
			AND ((cm.site_id = @siteId) OR (@siteId IS NULL))
	

	SELECT ROW_NUMBER() OVER(ORDER BY tcm.site_id, content_created) AS rowNum, 
			site_name, id, site_id, content_type_id, content_id, title_tag, keywords, description,
			content_name, content_created, content_modified, enabled, modified, created, noindex into #orderedContentMetadata
	FROM #contentMetadata tcm

	SELECT * 
	FROM #orderedContentMetadata
	WHERE rowNum BETWEEN @pageStart AND @pageEnd

	SELECT @recordCount = COUNT(id) 
	FROM #contentMetadata	

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadataInformation TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId
	@siteId int,
	@contentTypeId int,
	@pageStart int,
	@pageEnd int,
	@recordCount int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER(ORDER BY content_metadata_id) AS rowNum, content_metadata_id as id, site_id, content_type_id, content_id, title_tag, keywords, description, 
	noindex, enabled, modified, created into #contentMetadata
	FROM content_metadata
	WHERE  content_type_id = @contentTypeId
			AND site_id = @siteId 

	SELECT * 
	FROM #contentMetadata
	WHERE rowNum BETWEEN @pageStart AND @pageEnd

	SELECT @recordCount = COUNT(id) 
	FROM #contentMetadata	

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_AddContentMetadataPage'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_AddContentMetadataPage
	@id int output,
	@pageId int,
	@contentMetadataId int,
	@displayed bit,
	@created smalldatetime output,
	@enabled bit

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	 INSERT INTO content_metadata_to_page (page_id, content_metadata_id, displayed, created, modified, enabled)    
	 VALUES (@pageId, @contentMetadataId, @displayed, @created, @created, @enabled) 

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPage_AddContentMetadataPage TO VpWebApp 
GO

------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_GetContentMetadataPage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_GetContentMetadataPage
	@id int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT content_metadata_to_page_id AS id, page_id, content_metadata_id, displayed, created, modified, enabled
	FROM content_metadata_to_page
	WHERE content_metadata_to_page_id = @id
END
GO

GRANT EXECUTE ON dbo.adminPage_GetContentMetadataPage TO VpWebApp 
GO

------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_UpdateContentMetadataPage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_UpdateContentMetadataPage
	@id int output,
	@pageId int,
	@contentMetadataId int,
	@displayed bit,
	@modified smalldatetime output,
	@enabled bit

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE content_metadata_to_page
	SET
		page_id = @pageId,
		content_metadata_id = @contentMetadataId,
		displayed = @displayed,		
		modified = @modified,
		enabled = @enabled
	WHERE content_metadata_to_page_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPage_UpdateContentMetadataPage TO VpWebApp
GO

---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_DeleteContentMetadataPage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_DeleteContentMetadataPage
	@id int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM content_metadata_to_page
	WHERE content_metadata_to_page_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPage_DeleteContentMetadataPage TO VpWebApp

----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_GetContentMetadataPageByContentTypeAndContentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_GetContentMetadataPageByContentTypeAndContentId
	@contentTypeId int,
	@contentId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT content_metadata_to_page_id as id, page_id, content_metadata_id, displayed, created, modified, [enabled]
	FROM content_metadata_to_page
	WHERE content_metadata_id IN
	(
		SELECT content_metadata_id
		FROM content_metadata
		WHERE content_type_id = @contentTypeId AND content_id = @contentId
	)

END
GO

GRANT EXECUTE ON dbo.adminPage_GetContentMetadataPageByContentTypeAndContentId TO VpWebApp 
GO

---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPage_GetContentMetadataPageDisplayValue'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPage_GetContentMetadataPageDisplayValue
		@pageId int,
		@contentTypeId int,
		@contentId int
AS
-- ==========================================================================
-- Author : Yasodha $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT content_metadata_to_page_id AS id, content_metadata_to_page.page_id, content_metadata_to_page.content_metadata_id, displayed, content_metadata_to_page.created, content_metadata_to_page.modified, content_metadata_to_page.enabled
	FROM content_metadata_to_page
	INNER JOIN content_metadata
		ON content_metadata_to_page.content_metadata_id = content_metadata.content_metadata_id 
	WHERE content_metadata_to_page.page_id = @pageId AND content_metadata.content_type_id = @contentTypeId AND content_metadata.content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.publicPage_GetContentMetadataPageDisplayValue TO VpWebApp 
GO

--------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_GetPageListbySiteIdPageCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_GetPageListbySiteIdPageCategoryId
	@siteId int,
	@pageCategoryId int
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT  page.page_id AS id, page.site_id, predefined_page_id, parent_page_id, page_name
			,page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
			, keywords, template_name, sort_order, navigable, hidden,log_in_to_view
			, page.enabled, page.modified, page.created, include_in_sitemap, navigation_title, default_title_prefix
	FROM page
	WHERE page_id IN
	(
		SELECT page_id
		FROM page_type
		WHERE page_type.page_category_id = @pageCategoryId AND page_type.site_id = @siteId
	)
	ORDER BY parent_page_id, sort_order
END
GO

GRANT EXECUTE ON dbo.adminPage_GetPageListbySiteIdPageCategoryId TO VpWebApp 
GO



------------------------------------------------------------------------

-------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteContentMetadata'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteContentMetadata
	@id int
AS

-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM content_metadata
	WHERE content_metadata_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteContentMetadata TO VpWebApp 
GO

-------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentMetadataByContentTypeIdcontentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentMetadataByContentTypeIdcontentId
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_metadata_id as id, site_id, content_type_id, content_id, title_tag, keywords, description, enabled, modified, created, noindex
	FROM content_metadata
	WHERE  content_type_id = @contentTypeId
			AND content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentMetadataByContentTypeIdcontentId TO VpWebApp 
GO

--------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId
	@siteId int,
	@contentTypeId int,
	@pageStart int,
	@pageEnd int,
	@recordCount int output
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER(ORDER BY content_metadata_id) AS rowNum, content_metadata_id as id, site_id, content_type_id, content_id, title_tag, keywords, description, enabled, modified, created, noindex into #contentMetadata
	FROM content_metadata
	WHERE  content_type_id = @contentTypeId
			AND site_id = @siteId
			
	SELECT * 
	FROM #contentMetadata
	WHERE rowNum BETWEEN @pageStart AND @pageEnd

	SELECT @recordCount = COUNT(id) 
	FROM #contentMetadata	

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId TO VpWebApp 
GO

----migration script to add new page category - 

insert page_type (page_category_id, site_id,page_id,enabled,created,modified)
select 4, site_id,page_id,1,getdate(),getdate() from page
where page_name in ('VerticalMatrix', 'ProductDetail')


----- Category parameter type ---

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryParameterByParameterTypeParameterValueSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryParameterByParameterTypeParameterValueSiteIdList
	@parameterTypeId int,
	@siteId int,
	@parameterValue varchar(max)
AS
-- ==========================================================================
-- $Author Sujith
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cp.category_parameter_id AS id, cp.category_id, cp.parameter_type_id, cp.category_parameter_value, cp.[enabled],
			 cp.modified, cp.created
	FROM category_parameter cp
		INNER JOIN category c
			ON c.category_id = cp.category_id
	WHERE cp.parameter_type_id = @parameterTypeId AND cp.category_parameter_value = @parameterValue	AND c.site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryParameterByParameterTypeParameterValueSiteIdList TO VpWebApp 
GO

----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_DeleteContentMetadataPageBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_DeleteContentMetadataPageBySiteId
	@siteId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
		
		DELETE FROM content_metadata_to_page
		WHERE content_metadata_id IN
		(
			SELECT content_metadata_id
			FROM content_metadata
			WHERE site_id = @siteId
		)
	
END
GO

GRANT EXECUTE ON dbo.adminPage_DeleteContentMetadataPageBySiteId TO VpWebApp 
GO

---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_DeleteContentMetadataPageBySiteIdPageIdContentMetadataId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_DeleteContentMetadataPageBySiteIdPageIdContentMetadataId
	@siteId int,
	@pageId int,
	@contentMetadataId int


AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
		
		IF @siteId IS NOT NULL
		DELETE FROM content_metadata_to_page
		WHERE content_metadata_id IN
		(
			SELECT content_metadata_id
			FROM content_metadata
			WHERE site_id = @siteId
		)
		ELSE IF @pageId IS NOT NULL
		DELETE FROM content_metadata_to_page
		WHERE page_id in
		( 
			SELECT page_id
			FROM page
			WHERE page_id = @pageId
		) 
		ELSE IF @contentMetadataId IS NOT NULL
		DELETE FROM content_metadata_to_page
		WHERE content_metadata_id IN
		(
			SELECT content_metadata_id
			FROM content_metadata
			WHERE content_metadata_id = @contentMetadataId
		)

	
END
GO

GRANT EXECUTE ON dbo.adminPage_DeleteContentMetadataPageBySiteIdPageIdContentMetadataId TO VpWebApp 
GO

--------------------------------------------------------------------------------


