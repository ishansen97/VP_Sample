
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsOrVendorsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryHavingProductsOrVendorsList
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryHavingProductsOrVendorsList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
	FROM
	(
		SELECT category.category_id
		FROM category 
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
			AND category_to_category_branch.hidden = '0' AND category.hidden = 0
			AND
			(
				(category_type_id <> 4)
				OR 
				(
					(SELECT COUNT(product_id)
					FROM product_to_category
					WHERE product_to_category.category_id = category.category_id) > 0
				)
			)

		UNION

		SELECT category.category_id
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN category_to_vendor
				ON category.category_id = category_to_vendor.category_id
			INNER JOIN vendor
				ON category_to_vendor.vendor_id = vendor.vendor_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0' AND
			category.category_type_id = 4 AND category.hidden = 0 AND
			vendor.[enabled] = '1' AND category_to_vendor.[enabled] = '1'
			
		UNION
		
		SELECT category.category_id
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN fixed_guided_browse
				ON category.category_id = fixed_guided_browse.category_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0' AND
			category.category_type_id = 4 AND category.hidden = 0 AND fixed_guided_browse.[enabled] = 1
			
		UNION
		
		SELECT category.category_id
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN category_parameter
				ON category.category_id = category_parameter.category_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0' AND
			category.category_type_id = 4 AND category.hidden = 0 AND category_parameter.category_parameter_value IS NOT NULL
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	ORDER BY category_name
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsOrVendorsList TO VpWebApp 
GO