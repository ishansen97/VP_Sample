
------------------------adminCategory_AssociateAndDeleteProductsForGeneratedCategories---------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_AssociateAndDeleteProductsForGeneratedCategories]
	@categoryId int,
	@associateSearchCategoryId int,
	@batchSize INT
AS
-- ==========================================================================
-- $ Author : Deshapriya $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT
	DECLARE @lastUpdateDate SMALLDATETIME = GETDATE()	
	DECLARE @startRowNo INT = 0
	DECLARE @tmpCount INT 

	SELECT @optionsCount = COUNT(*)
	FROM category_to_search_option ctso
	WHERE ctso.category_id = @categoryId

	SELECT p.product_id, ROW_NUMBER() OVER(ORDER BY p.product_id ASC) as row_no
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


	
	
	-- Insert into product_to_category	

	SELECT @tmpCount = COUNT(1) FROM #tmpProducts

	WHILE ( @startRowNo < @tmpCount )
	BEGIN
		
		-- Insert to product_to_category
		INSERT INTO product_to_category (category_id, product_id, [enabled], modified, created)
		SELECT @categoryId, tmpp.product_id, 1, GETDATE(), GETDATE()
		FROM #tmpProducts tmpp
		LEFT JOIN product_to_category ptc on ptc.product_id = tmpp.product_id and ptc.category_id = @categoryId
		WHERE ptc.product_id IS NULL AND (@startRowNo < row_no AND row_no <= (@startRowNo + @batchSize)) 		
		
		SET @startRowNo = (@startRowNo + @batchSize)
	END	
	DROP TABLE #tmpProducts	


	   	
	-- updating for elastic search index

	SELECT pro.product_id, ROW_NUMBER() OVER(ORDER BY pro.product_id ASC) as row_no
	INTO #tmpProductsES	
	FROM	product pro
			INNER JOIN product_to_category prc ON	prc.product_id = pro.product_id
	WHERE   (prc.category_id = @categoryId OR prc.category_id = @associateSearchCategoryId)
	AND	prc.modified >= @lastUpdateDate

	SELECT @tmpCount = COUNT(1) FROM #tmpProductsES
	SET @startRowNo = 0

	WHILE (@startRowNo < @tmpCount)
	BEGIN
		UPDATE  pro
		SET		pro.search_content_modified = 1 ,
				pro.content_modified = 1
		FROM	product pro
				INNER JOIN #tmpProductsES tmpp ON	pro.product_id = tmpp.product_id
		WHERE   @startRowNo < row_no AND row_no <= (@startRowNo + @batchSize)		

		SET @startRowNo = (@startRowNo + @batchSize)

	END

	DROP TABLE #tmpProductsES


	SELECT pro.product_id, ROW_NUMBER() OVER(ORDER BY pro.product_id ASC) as row_no
	INTO #tmpToDeleteProductToCategories	
	FROM product pro
	INNER JOIN dbo.product_to_category ptc ON ptc.product_id = pro.product_id
	LEFT JOIN 
	(
		SELECT p.product_id
		
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

	) A ON A.product_id = pro.product_id	
	WHERE ptc.category_id = @categoryId AND A.product_id IS NULL
	
		
	--Updating product contentMoified status of removed productTocategories	
	
	SELECT @tmpCount = COUNT(1) FROM #tmpToDeleteProductToCategories
	SET @startRowNo = 0

	WHILE (@startRowNo < @tmpCount)
	BEGIN
		UPDATE  pro
		SET		pro.search_content_modified = 1 ,
				pro.content_modified = 1
		FROM	product pro
		INNER JOIN #tmpToDeleteProductToCategories tmpp on tmpp.product_id = pro.product_id
		WHERE @startRowNo < row_no AND row_no <= (@startRowNo + @batchSize)
		
		SET @startRowNo = (@startRowNo + @batchSize)
	END

	SET @startRowNo = 0
	WHILE (@startRowNo < @tmpCount)
	BEGIN		

		DELETE ptc
		FROM product_to_category ptc
		INNER JOIN #tmpToDeleteProductToCategories tmpp on tmpp.product_id = ptc.product_id and ptc.category_id = @categoryId
		WHERE ptc.category_id = @categoryId AND @startRowNo < row_no AND row_no <= (@startRowNo + @batchSize)
		
		SET @startRowNo = (@startRowNo + @batchSize)
	END	  	 

	DROP TABLE #tmpToDeleteProductToCategories	   	  
	
END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp
GO
----------------------------------------------------------------------------------

