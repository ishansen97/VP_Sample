GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByVendorIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryByVendorIdList]    Script Date: 12/3/2018 11:21:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryByVendorIdList]
    @vendorId int
	WITH RECOMPILE
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
      
	SET NOCOUNT ON;

		SELECT c.category_id 
		INTO #all_category_ids
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
					ON pv.product_id = pc.product_id
			INNER JOIN category c
					ON pc.category_id = c.category_id
			INNER JOIN product p 
					ON pc.product_id = p.product_id
		WHERE pv.vendor_id = @vendorId 
				AND pv.[enabled] = 1 
				AND pc.[enabled] = 1
				AND c.[enabled] = 1
				AND p.[enabled] = 1 
				AND c.hidden = 0

		INSERT INTO #all_category_ids
		SELECT c.category_id    
		FROM category c
			INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
		WHERE cv.vendor_id = @vendorId 
			AND c.[enabled] = 1
			AND cv.[enabled] = 1
			AND c.hidden = 0

		SELECT DISTINCT category_id
		INTO #category_ids
		FROM #all_category_ids

		SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], specification
			, [enabled], modified, created, is_search_category, is_displayed
			, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM #category_ids
			INNER JOIN category
				ON #category_ids.category_id = category.category_id
		ORDER BY category_name

		DROP TABLE #category_ids
		DROP TABLE #all_category_ids

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryByVendorIdList TO VpWebApp
GO
