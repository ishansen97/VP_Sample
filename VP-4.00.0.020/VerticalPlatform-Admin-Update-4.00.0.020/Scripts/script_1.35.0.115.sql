IF NOT EXISTS (SELECT [name] FROM sys.tables where [name] = 'article_type_template')
BEGIN
CREATE TABLE article_type_template
(
	article_type_template_id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	site_id int,
	article_type_id int,
	template_id int,
	page_id int,
	enabled bit,
	created smalldatetime,
    modified smalldatetime
);
END
GO

-- Migrate existing data to new table
IF NOT EXISTS (SELECT * FROM article_type_template)
BEGIN
	INSERT INTO article_type_template
	SELECT at.site_id, at.article_type_id, article_id as template_id, at.page_id, at.enabled, GETDATE(), GETDATE()
	FROM article_type at
	INNER JOIN article a
		ON at.article_type_id = a.article_type_id 
	WHERE is_article_template=1
END 
GO

------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeTemplateDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeTemplateDetail
	@id int
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_type_template_id AS id, site_id, article_type_id, template_id
		, page_id, [enabled], modified, created
	FROM article_type_template
	WHERE article_type_template_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTypeTemplateDetail TO VpWebApp 
GO

----------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleTypeTemplate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticleTypeTemplate
	@id int output,
	@siteId int,
	@articleTypeId int,
	@templateId int,
	@pageId int,
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	SET @created = GETDATE()
	
	INSERT INTO article_type_template (site_id, article_type_id, template_id, page_id, [enabled], modified, created)
	VALUES (@siteId, @articleTypeId, @templateId, @pageId, @enabled, @created, @created)
	
	SET @id = SCOPE_IDENTITY();
END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticleTypeTemplate TO VpWebApp 
GO
-------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleTypeTemplate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleTypeTemplate
	@id int,
	@siteId int,
	@articleTypeId int,
	@templateId int,
	@pageId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	SET @modified = GETDATE()
	
	UPDATE article_type_template 
	SET site_id = @siteId, 
		article_type_id = @articleTypeId, 
		template_id = @templateId, 
		page_id = @pageId,
		[enabled] = @enabled,
		modified = @modified
	WHERE article_type_template_id = @id
END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleTypeTemplate TO VpWebApp 
GO
-----------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_DeleteArticleTypeTemplate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_DeleteArticleTypeTemplate
	@id int
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DELETE FROM article_type_template 
	WHERE article_type_template_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminArticle_DeleteArticleTypeTemplate TO VpWebApp 
GO

----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeTemplateByArticleTypeIdTemplateId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeTemplateByArticleTypeIdTemplateId
	@articleTypeId int,
	@templateId int
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT article_type_template_id AS id, site_id, article_type_id, template_id
		, page_id, [enabled], modified, created
	FROM article_type_template
	WHERE article_type_id = @articleTypeId AND template_id = @templateId
	
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTypeTemplateByArticleTypeIdTemplateId TO VpWebApp 
GO

--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeTemplateByArticleTypeId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeTemplateByArticleTypeId
	@articleTypeId int
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT article_type_template_id AS id, site_id, article_type_id, template_id
		, page_id, [enabled], modified, created
	FROM article_type_template
	WHERE article_type_id = @articleTypeId
	
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTypeTemplateByArticleTypeId TO VpWebApp 
GO
------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleTypeTemplateByPageId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleTypeTemplateByPageId
	@pageId int
AS
-- ==========================================================================
-- $Author$ : Eranga
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT article_type_template_id AS id, site_id, article_type_id, template_id
		, page_id, [enabled], modified, created
	FROM article_type_template
	WHERE page_id = @pageId
	
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleTypeTemplateByPageId TO VpWebApp 
GO

-------------------------------------------------------------------------------------

--EXEC dbo.global_DropStoredProcedure 'dbo.adminField_ChangeArticleFixedUrlByPageIdSiteId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_ChangeArticleFixedUrlByPageIdSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_ChangeArticleFixedUrlByPageIdSiteId
	@templateId int,	
	@pageId int,
	@siteId int,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE fu
	SET fu.page_id = @pageId
		, fu.modified = @modified
	FROM fixed_url  AS fu
		INNER JOIN article  AS a  ON a.article_template_id = @templateId AND fu.content_type_id = 4 AND a.article_id = fu.content_id
	WHERE fu.site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_ChangeArticleFixedUrlByPageIdSiteId TO VpWebApp 
GO

