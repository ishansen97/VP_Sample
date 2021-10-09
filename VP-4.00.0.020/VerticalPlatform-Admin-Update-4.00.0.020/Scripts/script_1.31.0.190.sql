EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSearchContentModifiedProductsByChildProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSearchContentModifiedProductsByChildProduct
	@childProductId int,
	@batchSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	WITH product_search_content_modified(product_id, search_content_modified, modified) AS
	(
		SELECT p.product_id, p.search_content_modified, p.modified
		FROM product p
			INNER JOIN product_to_product pp
				ON pp.parent_product_id = p.product_id AND pp.product_id = @childProductId
		WHERE p.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) product_search_content_modified
	SET search_content_modified = 1, modified = getdate()
	
	SELECT @totalCount = COUNT(*)
	FROM product p
		INNER JOIN product_to_product pp
			ON pp.parent_product_id = p.product_id AND pp.product_id = @childProductId
	WHERE search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSearchContentModifiedProductsByChildProduct TO VpWebApp 
GO

--------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductToProductsByParentProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminProduct_GetProductToProductsByParentProductIdsList]
	@parentProductIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id as id, parent_product_id, product_id, enabled, created, modified
	FROM product_to_product	
		INNER JOIN global_Split(@parentProductIds, ',') AS product_id_table
			ON product_to_product.parent_product_id = product_id_table.[value]
	WHERE product_to_product.enabled = 1
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductToProductsByParentProductIdsList TO VpWebApp 
GO

------------

