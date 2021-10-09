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
			AND product_to_category.category_id NOT IN (SELECT category_id FROM #connectedLeafs)
			AND category.category_type_id = 4 AND p.site_id = @siteId
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
		(SELECT category_id FROM #connectedLeafs) 
		AND product_to_category.category_id NOT IN (SELECT category_id FROM #connectedLeafs)
		AND category.category_type_id = 4 AND p.site_id = @siteId
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdPageList TO VpWebApp 
GO
