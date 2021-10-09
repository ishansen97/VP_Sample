EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList
	@categoryId int,
	@productId int,
	@childProductIds varchar(500)
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_compression_group.product_compression_group_id AS id, product_compression_group.site_id, 
		product_compression_group.show_in_matrix, show_product_count, group_title,expand_products, 
		product_compression_group.[enabled], product_compression_group.created, product_compression_group.modified, 
		is_default, group_name, product_compression_group_to_product.product_id
	FROM product_to_product
		INNER JOIN product_to_category
			ON product_to_product.product_id = product_to_category.product_id
		INNER JOIN product_compression_group_to_product
			ON product_compression_group_to_product.product_id = product_to_product.product_id
		INNER JOIN product_compression_group
			ON product_compression_group_to_product.product_compression_group_id = product_compression_group.product_compression_group_id
		INNER JOIN Global_Split(@childProductIds, ',') children
			ON product_to_product.product_id = children.[value]
	WHERE product_to_product.parent_product_id = @productId AND product_to_category.category_id = @categoryId 
	ORDER BY product_compression_group.product_compression_group_ID

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList TO VpWebApp 
GO