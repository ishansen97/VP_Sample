
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_AssociateAndDeleteProductsForGeneratedCategories]
	@categoryId int,
	@associateSearchCategoryId int
AS
-- ==========================================================================
-- $ Author : Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT
	DECLARE @lastUpdateDate SMALLDATETIME = GETDATE()

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
	INNER JOIN product_to_category ptc
		ON ptc.product_id = p.product_id
	WHERE ctso.category_id = @categoryId
		AND p.enabled = 1
		AND ptc.category_id = @associateSearchCategoryId
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

	--updating for elastic search index (only on last updated products)
	UPDATE  pro
	SET		pro.search_content_modified = 1 ,
			pro.content_modified = 1
	FROM	product pro
			INNER JOIN product_to_category prc ON	prc.product_id = pro.product_id
	WHERE   (prc.category_id = @categoryId OR prc.category_id = @associateSearchCategoryId)
	AND	prc.modified >= @lastUpdateDate
	
	
	SELECT p.product_id
	INTO #tmpToDeleteProductToCategories
	FROM product p
	INNER JOIN product_to_search_option ptso
		ON ptso.product_id = p.product_id
	INNER JOIN category_to_search_option ctso
		ON ctso.search_option_id = ptso.search_option_id
	INNER JOIN product_to_category ptc
		ON ptc.product_id = p.product_id
	WHERE ctso.category_id = @categoryId
		AND p.enabled = 1
		AND ptc.category_id = @associateSearchCategoryId
	GROUP BY p.product_id
	HAVING COUNT(ptso.product_id) = @optionsCount
	
	--Updating product contentMoified status of removed productTocategories	
	UPDATE  pro
	SET		pro.search_content_modified = 1 ,
			pro.content_modified = 1
	FROM	product pro
	INNER JOIN dbo.product_to_category ptc ON   ptc.product_id = pro.product_id
	WHERE pro.product_id NOT IN (
		SELECT product_id
			FROM #tmpToDeleteProductToCategories
	)
	AND ptc.category_id = @categoryId
	
	DELETE
	FROM product_to_category
	WHERE category_id = @categoryId
		AND product_id NOT IN (
			SELECT product_id
			FROM #tmpToDeleteProductToCategories
		)

	DROP TABLE #tmpProducts
	DROP TABLE #tmpToDeleteProductToCategories


END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp 
GO
------------------------------------------------------------------------------------------------
