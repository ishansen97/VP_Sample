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
-- $ Author : Sahan Diasena $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [include_all_options], expand_on_load, [created], [enabled], [modified],
		[filter_search_options], [display_name], [display_options], [css_width], [send_to_matrix]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp
GRANT EXECUTE ON publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebAPI
GO

----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], expand_on_load, [created], [enabled], [modified], [include_all_options],
		[filter_search_options], [display_name], [display_options], [css_width], [send_to_matrix]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp
GRANT EXECUTE ON publicSearchCategory_GetCategorySearchGroupDetail TO VpWebAPI
GO