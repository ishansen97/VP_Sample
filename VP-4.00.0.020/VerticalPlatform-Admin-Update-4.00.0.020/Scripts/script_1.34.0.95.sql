EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetAllChildCategoryByParentCategoryIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetAllChildCategoryByParentCategoryIdPageList
	@categoryId int,
	@startIndex int,
	@endIndex int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Yasoda Handehewa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

		SELECT id, site_id, category_name, category_type_id,[description], short_name, specification
		   , is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
		   , auto_generated, hidden, has_image, url_id
		FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category.category_id ASC) AS row, category.category_id AS id, site_id, category_name
				,category_type_id, description, short_name, specification
				, category.is_search_category, category.is_displayed, matrix_type, category.enabled, category.modified, category.created
				, category.product_count, category.auto_generated, category.hidden, category.has_image, category.url_id
			FROM category 
				INNER JOIN category_to_category_branch
					ON category.category_id = category_to_category_branch.sub_category_id
			WHERE category_to_category_branch.category_id = @categoryId
		)AS OrphanCat
		WHERE row BETWEEN @startIndex AND @endIndex
		
		SELECT @totalCount = COUNT(*)
		FROM category 
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId 
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetAllChildCategoryByParentCategoryIdPageList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------

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
-- Yasoda Handehewa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH categoryBranch AS (
		SELECT category_id, sub_category_id, enabled 
		FROM category_to_category_branch
		WHERE enabled = 1 AND category_branch_type_id = 1
		UNION ALL
		SELECT cb.category_id, cb.sub_category_id, cb.enabled 
		FROM category_to_category_branch cb
			INNER JOIN categoryBranch 
				ON categoryBranch.sub_category_id = cb.category_id AND cb.enabled = 1
	)

	SELECT category.category_id INTO #connectedLeafs
	FROM categoryBranch
		INNER JOIN category 
			ON sub_category_id = category.category_id
	WHERE category.category_type_id = 4 AND category.site_id = @siteId

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
			INNER JOIN product_to_category ON p.product_id  = product_to_category.product_id
			INNER JOIN category ON product_to_category.category_id = category.category_id
			WHERE category.category_id NOT IN (SELECT category_id FROM #connectedLeafs)
			AND category.category_type_id = 4
		)AS tempProduct
	) AS orphan
	WHERE row BETWEEN @startIndex AND @endIndex

	SELECT @totalCount = COUNT(DISTINCT p.product_id)
	FROM product p
		INNER JOIN product_to_category 
			ON p.product_id  = product_to_category.product_id
		INNER JOIN category 
			ON product_to_category.category_id = category.category_id
	WHERE category.category_id NOT IN 
		(SELECT category_id FROM #connectedLeafs) AND
		 category.category_type_id = 4
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdPageList TO VpWebApp 
GO

-------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure AdminProduct_GetOrphanedCategoryBySiteIdPageList

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AdminProduct_GetOrphanedCategoryBySiteIdPageList
	@siteId int,
	@startIndex int,
	@endIndex int,
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
				cat.site_id = @siteId AND cb.category_id IS NULL
		)AS OrphanCat
		WHERE row BETWEEN @startIndex AND @endIndex

		SELECT @totalCount = COUNT(*)
		FROM category cat
			LEFT OUTER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id
		WHERE cat.category_type_id <> 1 AND
			cat.site_id = @siteId AND cb.category_id IS NULL
END
GO

GRANT EXECUTE ON AdminProduct_GetOrphanedCategoryBySiteIdPageList TO VpWebApp 
GO

---------------------------------------------------------------------------------