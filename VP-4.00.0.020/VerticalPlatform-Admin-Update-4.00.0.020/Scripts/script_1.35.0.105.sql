EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetOrphanProductsBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetOrphanProductsBySiteIdPageList
    @siteId int,
    @startIndex int,
    @endIndex int,
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
		) temp_product
	WHERE rowNumber BETWEEN @startIndex AND @endIndex
	
	
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdPageList TO VpWebApp
GO




	

		