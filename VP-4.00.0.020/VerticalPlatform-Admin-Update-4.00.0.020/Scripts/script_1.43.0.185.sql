
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories
	@categoryId int
AS
-- ==========================================================================
-- $ Author : Akila Tharuka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT

	SELECT @optionsCount = COUNT(*)
	FROM category_to_search_option ctso
	WHERE ctso.category_id = @categoryId

	SELECT p.product_id
	INTO #tmpProducts
	FROM product p
	INNER JOIN product_to_search_option ptso
		ON ptso.product_id = p.product_id
	INNER JOIN category_to_search_option ctso
		ON ctso.search_option_id = ptso.search_option_id
	WHERE ctso.category_id = @categoryId
		AND p.enabled = 1
	GROUP BY p.product_id
	HAVING COUNT(ptso.product_id) = @optionsCount

	INSERT INTO product_to_category (category_id, product_id, [enabled], modified, created)
	SELECT @categoryId, product_id, 1, GETDATE(), GETDATE()
	FROM #tmpProducts
	WHERE product_id NOT IN (
		SELECT product_id
		FROM product_to_category ptc
		WHERE ptc.category_id = @categoryId
		)

	DELETE
	FROM product_to_category
	WHERE category_id = @categoryId
		AND product_id NOT IN (
			SELECT p.product_id
			FROM product p
			INNER JOIN product_to_search_option ptso
				ON ptso.product_id = p.product_id
			INNER JOIN category_to_search_option ctso
				ON ctso.search_option_id = ptso.search_option_id
			WHERE ctso.category_id = @categoryId
				AND p.enabled = 1
			GROUP BY p.product_id
			HAVING COUNT(ptso.product_id) = @optionsCount
		)
		
	DROP TABLE #tmpProducts
END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp 
GO
------------------------------------------------------------------------------------------------
