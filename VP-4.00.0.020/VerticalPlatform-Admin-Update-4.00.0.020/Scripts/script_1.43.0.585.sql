EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetParentLeafCategoriesByProductId'

GO

/****** Object:  StoredProcedure [dbo].[adminProduct_GetParentLeafCategoriesByProductId]    Script Date: 12/19/2018 12:51:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetParentLeafCategoriesByProductId]
	@productId int,
	@siteId int
AS
-- ==========================================================================
-- $Author: Akila$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, category.site_id, category_name, category_type_id, [description], specification
		, category.[enabled], category.modified, category.created, is_search_category
		, is_displayed, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM 
	(
		SELECT DISTINCT product_to_category.category_id
		FROM product_to_category 
		WHERE product_to_category.product_id = @productId
	) c
		INNER JOIN category
			ON c.category_id = category.category_id
	WHERE category.site_id = @siteId AND category.category_type_id = 4

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetParentLeafCategoriesByProductId TO VpWebApp
GO

