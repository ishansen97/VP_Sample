IF EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 194 AND parameter_type = 'ShowCategorySearchGroupsSearchOptions')
BEGIN
	DELETE FROM category_parameter WHERE parameter_type_id = 194
	DELETE FROM parameter_type WHERE parameter_type_id = 194 AND parameter_type = 'ShowCategorySearchGroupsSearchOptions'
END
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------
--RUN SEPARATELY. WILL CAUSE TIMEOUTS IF RUN IN THE UPDATER.
	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'display_options' AND Object_ID = Object_ID(N'product_to_search_option'))
BEGIN
    ALTER TABLE product_to_search_option
	ADD display_options INT
END
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'display_options' AND Object_ID = Object_ID(N'product_to_search_option'))
--BEGIN
--    Update product_to_search_option SET display_options = 0 WHERE display_options IS NULL
--END
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'display_options' AND Object_ID = Object_ID(N'product_to_search_option'))
--BEGIN
--    ALTER TABLE product_to_search_option
--	ALTER COLUMN display_options INT NOT NULL
--END
--GO
-------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetProductSearchOptionsByProductIdListDisplayOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetProductSearchOptionsByProductIdListDisplayOption
	@productIds NVARCHAR(MAX),
	@displayOption INT

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
		INNER JOIN search_group sg
			ON sg.search_group_id = so.search_group_id
	WHERE ptso.display_options & @displayOption = @displayOption AND so.[enabled] = 1 AND sg.[enabled] = 1
	ORDER BY ptso.product_id, so.search_group_id, so.sort_order, so.name

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetProductSearchOptionsByProductIdListDisplayOption TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------
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

	SELECT ps.product_to_search_option_id AS id, ps.search_option_id, ps.product_id, ps.locked, ps.created, ps.enabled, ps.modified, ps.display_options
	FROM product_to_search_option ps
	INNER JOIN search_option so
		ON so.search_option_id = ps.search_option_id AND so.search_group_id = @searchGroupId
	INNER JOIN product_to_category pc
		ON ps.product_id = pc.product_id AND pc.category_id = @categoryId
	

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionsByCategorySearchGroupIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------
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
		pso.[created], pso.[enabled], pso.[modified], pso.[display_options]
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
-------------------------------------------------------------------------------------------------------------------------------------------------------
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
	@modified smalldatetime output,
	@displayOption int
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
		[modified] = @modified,
		[display_options] = @displayOption
	WHERE [product_to_search_option_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateProductSearchOption TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------
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
	SELECT [product_to_search_option_id] AS id, [product_id], [search_option_id], locked, [created], [enabled], [modified], [display_options]
	FROM product_to_search_option
	WHERE [product_to_search_option_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionDetail TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------
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
	@created smalldatetime output,
	@displayOption int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO product_to_search_option ([product_id], [search_option_id], locked, [enabled], [modified], [created], [display_options])
	VALUES (@productId, @searchOptionId, @locked, @enabled, @created, @created, @displayOption)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddProductSearchOption TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchGroupsBySearchGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchGroupsBySearchGroupIdList
	@searchGroupIds NVARCHAR(MAX)
AS
-- ==========================================================================
-- $ Author : Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT sg.search_group_id AS [id], sg.site_id, sg.parent_search_group_id, sg.name,
	   sg.[description], sg.[enabled], sg.created, sg.modified,
	   sg.add_options_automatically, sg.prefix_text, sg.suffix_text,
	   sg.legacy_content_id, sg.search_enabled, sg.locked
	FROM [search_group] sg
		INNER JOIN dbo.global_Split(@searchGroupIds, ',') gs
		ON gs.[value] = sg.search_group_id
		
		
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupsBySearchGroupIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------