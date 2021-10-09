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

	CREATE TABLE #orphan (category_id int, orphan bit)
	CREATE TABLE #children (childid int, parentid int, [level] int)
	CREATE TABLE #parent (childid int, parentid int, [level] int, orphan bit)

	INSERT INTO #orphan(category_id, orphan)
	SELECT category_id, 1
	FROM category c
	WHERE category_type_id <> 1 AND
		category_id NOT IN (SELECT sub_category_id FROM category_to_category_branch)
		AND c.site_id = @siteId;
   
	--select * from #orphan
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

	INSERT INTO #children (childid, parentid, [level])
	SELECT childid, parentid, [level] FROM cte

	--select * from #children
	INSERT INTO #parent (childid, parentid, [level], orphan)
	SELECT sub_category_id, category_id, #children.[level], 0
	FROM #children
		INNER JOIN category_to_category_branch
			ON #children.childid = sub_category_id
	       
	--select * from #parent order by childid
	DECLARE @highestlevel int
	SELECT @highestlevel = max([level]) FROM #children

	DECLARE @index int
	SET @index = 1

	WHILE (@index <= @highestlevel)
	BEGIN
		DELETE FROM #parent
		WHERE [level] = @index AND parentid IN (SELECT category_id FROM #orphan)
	   
		INSERT INTO #orphan (category_id, orphan)
		SELECT #children.childid, 1
		FROM #children
		WHERE [level] = @index AND #children.childid NOT IN (SELECT childid FROM #parent WHERE [level] = 1)
		ORDER BY childid
	   
		SET @index = @index + 1
	END

	--The non-orphan category_id list--
	SELECT cat.category_id
	INTO #non_orphan_category_list
	FROM category cat
	WHERE cat.category_id NOT IN (SELECT category_id FROM #orphan) AND cat.site_id = @siteId
	
	--The orphan product list-
	SELECT DISTINCT pc.product_id
	INTO #orphan_productIds
	FROM product_to_category pc
		INNER JOIN #orphan
		ON #orphan.category_id = pc.category_id
	where pc.product_id NOT IN (SELECT pc.product_id
								FROM #non_orphan_category_list
								INNER JOIN product_to_category pc
								ON pc.category_id = #non_orphan_category_list.category_id)
	 	

	SELECT id, site_id, parent_product_id, product_name, rank, has_image,
			catalog_number, enabled, modified, created, product_type, status, has_model, has_related,
			flag1, flag2, flag3, flag4, completeness, search_rank, search_content_modified, hidden,
			business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank,
			default_search_rank, row
		FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY product_id ASC) AS row, product_id AS id, site_id, parent_product_id, product_name, rank, has_image,
				catalog_number, enabled, modified, created, product_type, status, has_model, has_related,
				flag1, flag2, flag3, flag4, completeness, search_rank, search_content_modified, hidden,
				business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank,
				default_search_rank
			FROM
			(
				SELECT DISTINCT p.product_id, p.site_id, p.parent_product_id, p.product_name, p.rank, p.has_image,
							p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.status, p.has_model, p.has_related,
							p.flag1, p.flag2, p.flag3, p.flag4, p.completeness, p.search_rank, p.search_content_modified, p.hidden,
							p.business_value, p.show_in_matrix, p.show_detail_page, p.ignore_in_rapid, p.default_rank,
							p.default_search_rank
				FROM product p
					INNER JOIN #orphan_productIds
					ON #orphan_productIds.product_id = p.product_id
				WHERE p.site_id = @siteId
			)AS tempProduct
		) AS tempProductList
		WHERE row BETWEEN @startIndex AND @endIndex

		SELECT @totalCount = COUNT(*)
		FROM #orphan_productIds
 
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdPageList TO VpWebApp
GO

