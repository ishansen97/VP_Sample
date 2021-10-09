
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId
	@searchCategoryId int,
	@searchOptionsIds varchar(max),
	@optionCount int,
	@productExists bit output
AS
-- ==========================================================================
-- $ Author : Rifaz $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET @productExists = 0;
	
	IF EXISTS 
	(	
		SELECT pso.product_id
		FROM product_to_search_option pso
			INNER JOIN dbo.global_Split(@searchOptionsIds, ',') sids
				ON pso.search_option_id = sids.[value]
			INNER JOIN product_to_category pc
				ON pc.product_id = pso.product_id
		WHERE  pc.category_id = @searchCategoryId AND EXISTS(SELECT product_id FROM product WHERE product_id = pso.product_id and enabled = 1)
		GROUP BY pso.product_id
		HAVING COUNT(pso.product_id) = @optionCount
	)
	BEGIN 
		SET @productExists = 1
	END
	
END
GO

GRANT EXECUTE ON dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId TO VpWebApp 
GO
------------------------------------------------------------------------------------------------
