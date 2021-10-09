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

	SELECT category_id INTO #orphanedLeafs
	FROM
	(
		SELECT cat.category_id, cat.category_type_id
		FROM category cat
				LEFT OUTER JOIN category_to_category_branch cb
					ON cat.category_id = cb.sub_category_id
		WHERE cat.category_type_id <> 1 AND cat.site_id = @siteId AND cb.category_id IS NULL
	) AS orphanedCategories
	WHERE category_type_id = 4
	
	SELECT product_id INTO #orphanedProducts
	FROM
	(
		SELECT DISTINCT product_id
		FROM product_to_category
		WHERE category_id IN (SELECT category_id FROM #orphanedLeafs) AND
		product_id NOT IN
		(
			SELECT product_id
			FROM product_to_category
			WHERE category_id NOT IN (SELECT category_id FROM #orphanedLeafs)
		)
	) AS orphanedProducts
	
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
			WHERE p.product_id IN (SELECT product_id FROM #orphanedProducts)
		)AS tempProduct
	) AS orphan
	WHERE row BETWEEN @startIndex AND @endIndex

	SELECT @totalCount = COUNT(*)
	FROM #orphanedProducts

END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdPageList TO VpWebApp 
GO
