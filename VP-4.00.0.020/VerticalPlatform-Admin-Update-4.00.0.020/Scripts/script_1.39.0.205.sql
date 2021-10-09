IF NOT EXISTS (SELECT * FROM parameter_type WHERE parameter_type_id = 192 AND parameter_type = 'EnableFilteringVendorFilter')
BEGIN
	INSERT INTO parameter_type (parameter_type_id, parameter_type, [enabled], modified, created)
	VALUES (192, 'EnableFilteringVendorFilter', 1, GETDATE(), GETDATE())
END
----------------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'display_name' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    ALTER TABLE category_to_search_group
	ADD display_name VARCHAR(255)
END

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateCategorySearchGroup
	@id int,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@enabled bit,	
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@includeAllOptions bit,
	@expandOnLoad bit,
	@filterSearchOptions bit,
	@displayName varchar(255),
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE [category_to_search_group]
	SET
		[category_id] = @categoryId,
		[search_group_id] = @searchGroupId,
		[sort_order] = @sortOrder,
		[searchable] = @searchable,
		[matrix_prefix] = @matrixPrefix,
		[matrix_suffix] = @matrixSuffix,
		[enabled] = @enabled,
		[modified] = @modified,
		[include_all_options] = @includeAllOptions,
		expand_on_load = @expandOnLoad,	
		[filter_search_options] = @filterSearchOptions,
		[display_name] = @displayName
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchGroup TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], expand_on_load, [created], [enabled], [modified], [include_all_options],
		[filter_search_options], [display_name]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList
	@categoryId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Sahan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [include_all_options], expand_on_load, [created], [enabled], [modified],
		[filter_search_options], [display_name]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddCategorySearchGroup
	@id int output,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@enabled bit,	
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@includeAllOptions bit,
	@expandOnLoad bit,
	@filterSearchOptions bit,
	@displayName varchar(255),
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_to_search_group ([category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [enabled], [include_all_options], expand_on_load, [modified], [created], [filter_search_options], [display_name])
	VALUES (@categoryId, @searchGroupId, @sortOrder, @searchable,
		@matrixPrefix, @matrixSuffix, @enabled, @includeAllOptions, @expandOnLoad, @created, @created, @filterSearchOptions, @displayName)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchGroup TO VpWebApp 
Go
-------------------------------------------------------------------------------------------------------