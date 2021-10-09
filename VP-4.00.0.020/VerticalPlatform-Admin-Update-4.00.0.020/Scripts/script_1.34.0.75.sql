EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetOrphanProductsBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetOrphanProductsBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author$ Tharaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS category_id
	INTO #OrphanCat
	FROM category cat
		LEFT OUTER JOIN category_to_category_branch cb
			ON cat.category_id = cb.sub_category_id
	WHERE cat.category_type_id <> 1 AND cat.site_id = @siteId
	EXCEPT 
	SELECT cat.category_id AS category_id
	FROM category cat
		INNER JOIN category_to_category_branch cb
			ON cat.category_id = cb.sub_category_id
	WHERE cat.category_type_id <> 1 AND cat.site_id = @siteId
	
	SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.rank, p.has_image,
			p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.status, p.has_model, p.has_related, 
			p.flag1, p.flag2, p.flag3, p.flag4, p.completeness, p.search_rank, p.search_content_modified, p.hidden, 
			p.business_value, p.show_in_matrix, p.show_detail_page, p.ignore_in_rapid, p.default_rank, 
			p.default_search_rank
	FROM product p
		INNER JOIN product_to_category proCat
			ON proCat.product_id = p.product_id
		INNER JOIN #OrphanCat
			ON #OrphanCat.category_id = proCat.category_id
	EXCEPT 
	SELECT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.rank, p.has_image,
			p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.status, p.has_model, p.has_related, 
			p.flag1, p.flag2, p.flag3, p.flag4, p.completeness, p.search_rank, p.search_content_modified, p.hidden, 
			p.business_value, p.show_in_matrix, p.show_detail_page, p.ignore_in_rapid, p.default_rank, 
			p.default_search_rank
	FROM product p
		INNER JOIN product_to_category proCat
			ON proCat.product_id = p.product_id
		INNER JOIN category cat
			ON cat.category_id = proCat.category_id
		INNER JOIN category_to_category_branch cb
			ON cat.category_id = cb.sub_category_id
	WHERE cat.category_type_id <> 1 AND cat.site_id = @siteId
	
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdList TO VpWebApp 
GO

------------------------------------------------------------------------------------------