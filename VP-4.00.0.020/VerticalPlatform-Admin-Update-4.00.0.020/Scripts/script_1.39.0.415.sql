-- REMOVING	display_options FROM product_to_search_option
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'display_options' AND Object_ID = Object_ID(N'product_to_search_option'))
BEGIN
    ALTER TABLE product_to_search_option
	DROP COLUMN display_options
END
GO
----------------------------------------------------------------------------------------------------------------------------------
-- ADDING display_options TO category_to_search_group
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'display_options' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    ALTER TABLE category_to_search_group
	ADD display_options INT
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'display_options' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    Update category_to_search_group SET display_options = 0 WHERE display_options IS NULL
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'display_options' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    ALTER TABLE category_to_search_group
	ALTER COLUMN display_options INT NOT NULL
END
GO
----------------------------------------------------------------------------------------------------------------------------------
-- ADDING css_width TO category_to_search_group
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'css_width' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    ALTER TABLE category_to_search_group
	ADD css_width FLOAT
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'css_width' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    Update category_to_search_group SET css_width = 0 WHERE css_width IS NULL
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'css_width' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    ALTER TABLE category_to_search_group
	ALTER COLUMN css_width FLOAT NOT NULL
END
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetProductSearchOptionsByProductIdListDisplayOption'
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetProductSearchOptionsByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetProductSearchOptionsByProductIdList
	@productId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT pso.[product_to_search_option_id] AS id, pso.[search_option_id], pso.[product_id], pso.locked, 
		pso.[created], pso.[enabled], pso.[modified]
	FROM product_to_search_option pso
		INNER JOIN search_option so
			ON so.search_option_id = pso.search_option_id
	WHERE product_id = @productId
	Order By so.search_group_id, so.search_option_id

	SELECT @totalCount = COUNT(*)
	FROM product_to_search_option
	WHERE product_id = @productId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionsByProductIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetProductSearchOptionsByCategorySearchGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetProductSearchOptionsByCategorySearchGroupIdList
	@searchGroupId int,
	@categoryId int
AS
-- ==========================================================================
-- $ Author : Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ps.product_to_search_option_id AS id, ps.search_option_id, ps.product_id, ps.locked, ps.created, ps.enabled, ps.modified
	FROM product_to_search_option ps
	INNER JOIN search_option so
		ON so.search_option_id = ps.search_option_id AND so.search_group_id = @searchGroupId
	INNER JOIN product_to_category pc
		ON ps.product_id = pc.product_id AND pc.category_id = @categoryId
	

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionsByCategorySearchGroupIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetProductSearchOptionDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetProductSearchOptionDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [product_to_search_option_id] AS id, [product_id], [search_option_id], locked, [created], [enabled], [modified]
	FROM product_to_search_option
	WHERE [product_to_search_option_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateProductSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateProductSearchOption
	@id int,
	@productId int,
	@searchOptionId int,
	@locked bit,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE [product_to_search_option]
	SET
		[product_id] = @productId,
		[search_option_id] = @searchOptionId,
		locked = @locked,
		[enabled] = @enabled,
		[modified] = @modified
	WHERE [product_to_search_option_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateProductSearchOption TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddProductSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddProductSearchOption
	@id int output,
	@productId int,
	@searchOptionId int,	
	@locked bit,
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO product_to_search_option ([product_id], [search_option_id], locked, [enabled], [modified], [created])
	VALUES (@productId, @searchOptionId, @locked, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddProductSearchOption TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
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
	@displayOptions int,
	@cssWidth float,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_to_search_group ([category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [enabled], [include_all_options], expand_on_load, [modified], 
		[created], [filter_search_options], [display_name], [display_options], [css_width])
	VALUES (@categoryId, @searchGroupId, @sortOrder, @searchable,
		@matrixPrefix, @matrixSuffix, @enabled, @includeAllOptions, @expandOnLoad, @created, @created, 
		@filterSearchOptions, @displayName, @displayOptions, @cssWidth)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchGroup TO VpWebApp 
Go
----------------------------------------------------------------------------------------------------------------------------------
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
		[filter_search_options], [display_name], [display_options], [css_width]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
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
	@displayOptions int,
	@cssWidth float,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
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
		[display_name] = @displayName,
		[display_options] = @displayOptions,
		[css_width] = @cssWidth
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchGroup TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
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
-- $ Author : Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [include_all_options], expand_on_load, [created], [enabled], [modified],
		[filter_search_options], [display_name], [display_options], [css_width]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdDisplayOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdDisplayOption
	@categoryIds NVARCHAR(MAX),
	@displayOption int
AS
-- ==========================================================================
-- $ Author : Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ctsg.category_to_search_group_id AS [id], ctsg.category_id, ctsg.search_group_id,
		   ctsg.sort_order, ctsg.searchable, ctsg.[enabled], ctsg.created, ctsg.modified, 
		   ctsg.matrix_prefix, ctsg.matrix_suffix, ctsg.include_all_options, ctsg.expand_on_load,
		   ctsg.filter_search_options, ctsg.display_name, ctsg.display_options, ctsg.css_width
	FROM category_to_search_group ctsg
		INNER JOIN dbo.global_Split(@categoryIds, ',') gs
		ON gs.[value] = ctsg.category_id
	WHERE ctsg.display_options  & @displayOption = @displayOption
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdDisplayOption TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetProductSearchOptionsByProductIdListSearchGroupList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetProductSearchOptionsByProductIdListSearchGroupList
	@productIds NVARCHAR(MAX),
	@searchGroupIds NVARCHAR(MAX)

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT so.search_option_id AS [id], so.search_group_id, so.name,
		   so.[enabled], so.created, so.modified, so.sort_order, ptso.product_id
	FROM search_option so
		INNER JOIN product_to_search_option ptso 
			ON ptso.search_option_id = so.search_option_id
		INNER JOIN dbo.global_Split(@productIds, ',') gs
			ON gs.[value] = ptso.product_id
		INNER JOIN dbo.global_Split(@searchGroupIds, ',') sg
			ON so.search_group_id = sg.[value]
	WHERE so.[enabled] = 1
	ORDER BY ptso.product_id, so.search_group_id, so.sort_order, so.name

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetProductSearchOptionsByProductIdListSearchGroupList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminActionUrl_AddActionUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminActionUrl_AddActionUrl
	@id int output,
	@actionId int,
	@actionUrl varchar(600),
	@contentTypeId int,
	@contentId int,
	@enabled bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@created smalldatetime output,
	@newWindow bit
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO action_url (action_id, action_url, content_type_id, content_id, enabled ,flag1, flag2, flag3, flag4,
		created, modified, new_window)
	VALUES (@actionId, @actionUrl, @contentTypeId, @contentId, @enabled, @flag1, @flag2, @flag3, @flag4, 
		@created, @created, @newWindow)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminActionUrl_AddActionUrl TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminActionUrl_UpdateActionUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminActionUrl_UpdateActionUrl
	@id int output,
	@actionId int,
	@actionUrl varchar(600),
	@contentTypeId int,
	@contentId int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@enabled bit,
	@modified smalldatetime output,
	@newWindow bit
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.action_url
	SET action_id = @actionId,
		action_url =  @actionUrl,
		content_type_id = @contentTypeId,
		content_id = @contentId,
		[enabled] = @enabled,		
		modified = @modified,
		new_window = @newWindow,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4
	WHERE action_url_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminActionUrl_UpdateActionUrl TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------