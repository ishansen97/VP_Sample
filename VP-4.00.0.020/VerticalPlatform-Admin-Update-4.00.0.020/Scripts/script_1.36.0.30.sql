IF NOT EXISTS(select * from sys.columns where Name = N'expand_on_load' and Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
ALTER TABLE category_to_search_group ADD expand_on_load bit NOT NULL DEFAULT 1
END

---------------

GO
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
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_to_search_group ([category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [enabled], [include_all_options], expand_on_load, [modified], [created])
	VALUES (@categoryId, @searchGroupId, @sortOrder, @searchable,
		@matrixPrefix, @matrixSuffix, @enabled, @includeAllOptions, @expandOnLoad, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchGroup TO VpWebApp 
Go

-----------

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
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [include_all_options], expand_on_load, [created], [enabled], [modified]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp 
GO

---------

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
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
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
		expand_on_load = @expandOnLoad
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchGroup TO VpWebApp 
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], expand_on_load, [created], [enabled], [modified], [include_all_options]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetOrphanProductsBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetOrphanProductsBySiteIdPageList
    @siteId int,
    @startIndex int,
    @endIndex int,
    @productId int,
    @productName varchar(max),
    @totalCount int output        
AS
-- ==========================================================================
-- Yasodha Handehewa
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	CREATE TABLE #orphan (id int identity(1,1) not null, category_id int, orphan bit)
	CREATE TABLE #children (childid int, parentid int, [level] int)
	CREATE TABLE #parent (childid int, parentid int, [level] int, orphan bit)

	-- categories which don't have a parent and are not roots.
	INSERT INTO #orphan(category_id, orphan)
	SELECT category_id, 1
	FROM category c
	WHERE category_type_id <> 1 AND c.site_id = @siteId AND category_id NOT IN 
		(SELECT sub_category_id FROM category_to_category_branch);

	-- get the children hierarchy for the above categories.
	WITH cte(childId, parentId, [level]) AS
	(
		SELECT b.sub_category_id, b.category_id, [level] = 1
		FROM category_to_category_branch b
			INNER JOIN #orphan
				ON #orphan.category_id = b.category_id
			   
		UNION ALL
	   
		SELECT b.sub_category_id, b.category_id, ([level] + 1) AS [level]
		FROM cte
			INNER JOIN category_to_category_branch b
				ON cte.childId = b.category_id
	)

	-- orphan categories and all their children in children table.
	INSERT INTO #children (childid, parentid, [level])
	SELECT childid, parentid, [level] FROM cte

	-- imediate parents for the all categories in children table in parent table.
	-- this is because a category can have multiple parents and for a category to be orphan it's 
	-- all parents should be orphan.
	INSERT INTO #parent (childid, parentid, [level], orphan)
	SELECT sub_category_id, category_id, #children.[level], 0
	FROM #children
		INNER JOIN category_to_category_branch
			ON #children.childid = sub_category_id
	
	-- get the maximum number of child levels in children table.		
	DECLARE @highestlevel int
	SELECT @highestlevel = max([level]) FROM #children

	DECLARE @index int
	SET @index = 1
	
	-- starting frol level 1 do until maximum children level
	-- delete orphan categories from parent table.	
	WHILE (@index <= @highestlevel)
	BEGIN
		-- delete orphan categories from parent table.
		DELETE FROM #parent
		WHERE parentid IN (SELECT category_id FROM #orphan)
		
		-- check for categories in children table with no parents in parent table.
		INSERT INTO #orphan (category_id, orphan)
		SELECT #children.childid, 1
		FROM #children
		WHERE #children.childid NOT IN 
			(SELECT childid FROM #parent)
	   
		SET @index = @index + 1
	END
	
	-- delete duplicates
	DELETE FROM #orphan
	WHERE #orphan.id NOT IN
	(SELECT MAX(id) FROM #orphan GROUP BY category_id)
	
	CREATE TABLE #orphan_category_products (id int identity(1, 1), category_id int, product_id int)
	
	INSERT INTO #orphan_category_products (category_id, product_id)
	SELECT product_to_category.category_id, product_to_category.product_id
	FROM #orphan
		INNER JOIN product_to_category
			ON #orphan.category_id = product_to_category.category_id
			
	-- delete duplicates
	DELETE FROM #orphan_category_products
	WHERE #orphan_category_products.id NOT IN
	(SELECT MAX(id) FROM #orphan_category_products GROUP BY product_id)
			
	CREATE TABLE #orphan_product_categories (category_id int, product_id int)	
	
	INSERT INTO #orphan_product_categories (category_id, product_id)
	SELECT product_to_category.category_id, product_to_category.product_id
	FROM #orphan_category_products
			INNER JOIN product_to_category
				ON #orphan_category_products.product_id = product_to_category.product_id
				
	DELETE opc
	FROM #orphan_product_categories opc
		INNER JOIN #orphan
			ON opc.category_id = #orphan.category_id
		
	SELECT @totalCount = COUNT(*)
	FROM 
	(SELECT product_id FROM #orphan_category_products
	EXCEPT 
	SELECT product_id FROM #orphan_product_categories) product_id_table
		INNER JOIN product p
			ON product_id_table.product_id = p.product_id 
	WHERE (product_id_table.product_id = @productId OR @productId = 0) AND (p.product_name LIKE @productName OR @productName IS NULL OR @productName LIKE '') 
		
	SELECT id, site_id, parent_product_id, product_name, rank, has_image,
		catalog_number, enabled, modified, created, product_type, status, has_model, has_related,
		flag1, flag2, flag3, flag4, completeness, search_rank, search_content_modified, hidden,
		business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank,
		default_search_rank	
	FROM
		(
		SELECT ROW_NUMBER() OVER (ORDER BY product.product_id ASC) AS rowNumber, product.product_id AS id, site_id, parent_product_id, product_name, rank, has_image,
					catalog_number, enabled, modified, created, product_type, status, has_model, has_related,
					flag1, flag2, flag3, flag4, completeness, search_rank, search_content_modified, hidden,
					business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank,
					default_search_rank	
		FROM	
		(SELECT product_id FROM #orphan_category_products
		EXCEPT 
		SELECT product_id FROM #orphan_product_categories) product_id_table
			INNER JOIN product
				ON product_id_table.product_id = product.product_id
		WHERE (product_id_table.product_id = @productId OR @productId = 0) AND (product.product_name LIKE @productName OR @productName IS NULL OR @productName LIKE '')
		) temp_product
	WHERE rowNumber BETWEEN @startIndex AND @endIndex
	
		
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdPageList TO VpWebApp
GO


-------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure AdminProduct_GetOrphanedCategoryBySiteIdPageList

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AdminProduct_GetOrphanedCategoryBySiteIdPageList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@categoryId int,
	@categoryName varchar(max),
	@totalCount int output
AS
-- ==========================================================================
-- $Author Yasodha Handehewa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
		
		SELECT id, site_id, category_name, category_type_id,[description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
		FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY cat.category_id ASC) AS row, cat.category_id AS id, cat.site_id AS site_id
				, cat.category_name AS category_name
				, cat.category_type_id AS category_type_id, description AS description, short_name AS short_name
				, cat.specification AS specification
				, cat.is_search_category AS is_search_category, is_displayed AS is_displayed
				, cat.[enabled] AS [enabled], cat.modified AS modified, cat.created AS created, cat.matrix_type
				, cat.product_count AS product_count, cat.auto_generated AS auto_generated, cat.hidden AS hidden
				, cat.has_image AS has_image, cat.url_id AS url_id
			FROM category cat
				LEFT OUTER JOIN category_to_category_branch cb
					ON cat.category_id = cb.sub_category_id
			WHERE cat.category_type_id <> 1 AND
				cat.site_id = @siteId AND cb.category_id IS NULL AND (cat.category_id = @categoryId OR @categoryId = 0) AND (cat.category_name LIKE @categoryName OR @categoryName IS NULL OR @categoryName LIKE '')
		)AS OrphanCat
		WHERE row BETWEEN @startIndex AND @endIndex

		SELECT @totalCount = COUNT(*)
		FROM category cat
			LEFT OUTER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id 
		WHERE cat.category_type_id <> 1 AND
				cat.site_id = @siteId AND cb.category_id IS NULL AND (cat.category_id = @categoryId OR @categoryId = 0) AND (cat.category_name LIKE @categoryName OR @categoryName IS NULL OR @categoryName LIKE '')
			
			
END
GO

GRANT EXECUTE ON AdminProduct_GetOrphanedCategoryBySiteIdPageList TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------

	

		

