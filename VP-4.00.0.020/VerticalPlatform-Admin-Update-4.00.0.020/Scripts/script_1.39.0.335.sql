IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'jump_page_display_name' AND Object_ID = Object_ID(N'category_to_category_branch'))
BEGIN
	ALTER TABLE category_to_category_branch
	ADD jump_page_display_name VARCHAR(255) NULL
END 

------------------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId
	@categoryId int,
	@subCategoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden, sort_order, jump_page_display_name
	FROM category_to_category_branch
	WHERE category_id = @categoryId AND sub_category_id = @subCategoryId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId TO VpWebApp 
GO


---------------------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBranchByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryBranchByCategoryIdList
	@categoryId int
AS

-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	WITH cte(id, category_id, sub_category_id, category_branch_type_id, display_name, display_in_digest_view
		, enabled, modified, created, hidden, sort_order, jump_page_display_name) AS
	(
		SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
			, display_name, display_in_digest_view, enabled, modified, created, hidden, sort_order, jump_page_display_name
		FROM category_to_category_branch
		WHERE sub_category_id = @categoryId AND enabled = '1'

		UNION ALL

		SELECT cb.category_to_category_branch_id AS id, cb.category_id, cb.sub_category_id, cb.category_branch_type_id
			, cb.display_name, cb.display_in_digest_view, cb.enabled, cb.modified, cb.created, cb.hidden, cb.sort_order, cb.jump_page_display_name
		FROM category_to_category_branch cb
				INNER JOIN cte
					ON cb.sub_category_id = cte.category_id
		WHERE cb.[enabled] = '1'
	)

	SELECT id, category_id, sub_category_id, category_branch_type_id, display_name, display_in_digest_view
		, enabled, modified, created, hidden, sort_order, jump_page_display_name
	FROM cte

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoryBranchByCategoryIdList TO VpWebApp
GO

---------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddCategoryBranch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddCategoryBranch
	@categoryId int,
	@subCategoryId int,
	@categoryBranchTypeId int,
	@displayName varchar(255),
	@displayInDigestView bit,
	@enabled bit,
	@hidden bit,
	@sortOrder int,
	@jumpPageDisplayName VARCHAR(255),
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
--- $Author: Sahan Diasena  
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO category_to_category_branch (category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden, sort_order, jump_page_display_name)
	VALUES (@categoryId, @subCategoryId, @categoryBranchTypeId, @enabled, @created
		, @created, @displayName, @displayInDigestView, @hidden, @sortOrder, @jumpPageDisplayName)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddCategoryBranch TO VpWebApp 
GO


------------------------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateCategoryBranch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateCategoryBranch
	@id int,
	@categoryId int,
	@subCategoryId int,
	@categoryBranchTypeId int,
	@displayName varchar(255),
	@displayInDigestView bit,
	@enabled bit,
	@hidden bit,
	@sortOrder int,
	@jumpPageDisplayName VARCHAR(255),
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE category_to_category_branch
	SET category_id = @categoryId
		, sub_category_id = @subCategoryId
		, category_branch_type_id = @categoryBranchTypeId
		, enabled = @enabled
		, modified = @modified
		, display_name = @displayName
		, display_in_digest_view = @displayInDigestView
		, hidden = @hidden
		, sort_order = @sortOrder
		, jump_page_display_name = @jumpPageDisplayName
	WHERE category_to_category_branch_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateCategoryBranch TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBranchDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryBranchDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden, sort_order, jump_page_display_name
	FROM category_to_category_branch
	WHERE category_to_category_branch_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryBranchDetail TO VpWebApp 
GO
