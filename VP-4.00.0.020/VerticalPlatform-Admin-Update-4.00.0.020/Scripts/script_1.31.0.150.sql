EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList
	@categoryId int,
	@primaryOptions varchar(max),
	@secondaryOptions varchar(max),
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	-- Populate primary search option ids
	CREATE TABLE #PrimarySearchOption (search_option_id int)
	INSERT INTO #PrimarySearchOption
	SELECT [VALUE] FROM global_split(@primaryOptions, ',')

	-- Populate secondary search option ids
	CREATE TABLE #SecondarySearchOption (search_option_id int)
	INSERT INTO #SecondarySearchOption
	SELECT [VALUE] FROM global_split(@secondaryOptions, ',')

	-- Find number of rows in secondary option ids
	DECLARE @secondarySearchOptionCount int
	SELECT @secondarySearchOptionCount = COUNT(*) FROM #SecondarySearchOption

	-- Find products having at least one primary option and all secondary options
	CREATE TABLE #FilteredProduct (product_id int)
	INSERT INTO #FilteredProduct
	SELECT ps.product_id
	FROM product_to_search_option ps
		INNER JOIN product_to_category pc
			ON ps.product_id = pc.product_id AND pc.category_id = @categoryId
		INNER JOIN product p
			ON p.product_id = ps.product_id AND p.enabled = 1 AND (@considerShowInMatrixSetting = 0 OR p.show_in_matrix = 1)
	WHERE ps.product_id IN 
	(
		SELECT product_id
		FROM product_to_search_option so
			INNER JOIN #PrimarySearchOption
				ON so.search_option_id = #PrimarySearchOption.search_option_id
	)
	AND ps.search_option_id IN
	(
		SELECT search_option_id
		FROM #SecondarySearchOption
	)
	GROUP BY ps.product_id
	HAVING COUNT(ps.search_option_id) = @secondarySearchOptionCount

	-- Select search options in primary option list having products in filtered products list
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id
		FROM product_to_search_option ps
			INNER JOIN #FilteredProduct
				ON ps.product_id = #FilteredProduct.product_id
		WHERE search_option_id IN
		(
			SELECT search_option_id
			FROM #PrimarySearchOption
		)
	)
	ORDER BY [name]

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList TO VpWebApp 
GO
------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductToProductByProductIdCategoryList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductToProductByProductIdCategoryList
@productId int,
@categoryId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id as id, parent_product_id, ptp.product_id, ptp.enabled, ptp.created, ptp.modified
	FROM product_to_product	ptp
	INNER JOIN product_to_category ptc
		ON ptc.product_id = ptp.product_id
	WHERE ptp.parent_product_id = @productId AND
		(@categoryId IS NULL OR ptc.category_id = @categoryId)
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductToProductByProductIdCategoryList TO VpWebApp 
GO
