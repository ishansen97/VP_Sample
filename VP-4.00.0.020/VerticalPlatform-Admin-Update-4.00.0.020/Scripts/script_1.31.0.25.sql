
IF NOT EXISTS(SELECT * FROM sys.columns WHERE [name] = N'omit_norms' AND Object_ID = Object_ID(N'category_search_aspect_content'))
BEGIN
	ALTER TABLE category_search_aspect_content ADD omit_norms bit NOT NULL DEFAULT 0
END

GO

----


EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddCategorySearchAspectContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddCategorySearchAspectContent
	@id int output,
	@categorySearchAspectId int,
	@contentTypeId int,
	@contentId int,
	@contentName varchar(500),
	@omitNorms bit,
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_search_aspect_content
		(category_search_aspect_id, content_type_id, content_id, content_name, omit_norms, [enabled], modified, created)
	VALUES (@categorySearchAspectId, @contentTypeId, @contentId, @contentName, @omitNorms, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchAspectContent TO VpWebApp 
GO

----

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList
	@categorySearchAspectId int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT category_search_aspect_content_id AS id, category_search_aspect_id, content_type_id, content_id, content_name, omit_norms, created, [enabled], modified
	FROM category_search_aspect_content
	WHERE [category_search_aspect_id] = @categorySearchAspectId

	SELECT @totalCount = COUNT(*)
	FROM category_search_aspect_content
	WHERE [category_search_aspect_id] = @categorySearchAspectId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList TO VpWebApp 
GO

----

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchAspectContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchAspectContent
	@id int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT category_search_aspect_content_id AS id, category_search_aspect_id, content_type_id, content_id, content_name, omit_norms, created, [enabled], modified
	FROM category_search_aspect_content
	WHERE category_search_aspect_content_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchAspectContent TO VpWebApp 
GO

----


EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateCategorySearchAspectContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateCategorySearchAspectContent
	@id int,
	@categorySearchAspectId int,
	@contentTypeId int,
	@contentId int,
	@contentName varchar(500),
	@omitNorms bit,
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()	
	
	UPDATE category_search_aspect_content
	SET
		category_search_aspect_id = @categorySearchAspectId,
		content_type_id = @contentTypeId,
		content_id = @contentId,
		content_name = @contentName,
		omit_norms = @omitNorms,
		[enabled] = @enabled,
		modified = @modified
	WHERE category_search_aspect_content_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchAspectContent TO VpWebApp 
GO

----
