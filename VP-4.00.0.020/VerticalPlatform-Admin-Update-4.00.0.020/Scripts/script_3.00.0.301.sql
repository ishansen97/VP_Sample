
--=== associate_to_generate_category_task_products

IF NOT EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name = 'associate_to_generate_category_task_products'
          AND xtype = 'U'
)
BEGIN
	CREATE TABLE [dbo].[associate_to_generate_category_task_products]
	(
		[product_id] [INT] NOT NULL PRIMARY KEY,
		[generated_category_id] INT NOT NULL,
		[associated_search_category_id] INT NOT NULL
	);
END

GO

--==== adminCategory_AssociateProductsForGeneratedCategories

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_AssociateProductsForGeneratedCategories]
	@categoryId int,
	@associateSearchCategoryId int,
	@batchSize INT,
	@lastProductId INT 
AS
-- ==========================================================================
-- $ Author : Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT
	DECLARE @lastUpdateDate SMALLDATETIME = GETDATE()	
	
	--populating associate_to_generate_category_task_products table with all the products in initial batch
	IF @lastProductId = 0
	BEGIN
		TRUNCATE TABLE associate_to_generate_category_task_products

		SELECT @optionsCount = COUNT(*)
		FROM category_to_search_option ctso
		WHERE ctso.category_id = @categoryId

		INSERT INTO associate_to_generate_category_task_products
			(product_id, generated_category_id, associated_search_category_id)
		SELECT p.product_id, @categoryId, @associateSearchCategoryId
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
	END


	SELECT TOP (@batchSize) p.product_id
	INTO #tmpProducts
	FROM associate_to_generate_category_task_products p
	WHERE p.product_id > @lastProductId
	ORDER BY p.product_id

	
	
	-- Insert into product_to_category		
	INSERT INTO product_to_category (category_id, product_id, [enabled], modified, created)
	SELECT @categoryId, tmpp.product_id, 1, GETDATE(), GETDATE()
	FROM #tmpProducts tmpp
	LEFT JOIN product_to_category ptc on ptc.product_id = tmpp.product_id and ptc.category_id = @categoryId
	WHERE ptc.product_id IS NULL
		
					   	
	-- updating for elastic search index
	SELECT prc.product_id 
	INTO #tmpProductsES	
	FROM	product_to_category prc
	WHERE   (prc.category_id = @categoryId OR prc.category_id = @associateSearchCategoryId)
	AND	prc.modified >= @lastUpdateDate
	 
	 	
	UPDATE  pro
	SET		pro.search_content_modified = 1 ,
			pro.content_modified = 1
	FROM	product pro
			INNER JOIN #tmpProductsES tmpp ON	pro.product_id = tmpp.product_id
				

	SELECT ISNULL(MAX(product_id), -1) AS maxProductId FROM #tmpProducts

	DROP TABLE #tmpProducts
	DROP TABLE #tmpProductsES
	    	  
	
END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateProductsForGeneratedCategories TO VpWebApp
GO


--=== adminCategory_DeleteProductsForGeneratedCategories

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_DeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_DeleteProductsForGeneratedCategories]
	@categoryId int,
	@associateSearchCategoryId int,
	@batchSize INT
AS
-- ==========================================================================
-- $ Author : Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT	
	
	SELECT @optionsCount = COUNT(*)
	FROM category_to_search_option ctso
	WHERE ctso.category_id = @categoryId

	SELECT TOP (@batchSize) pro.product_id 
	INTO #tmpToDeleteProductToCategories	
	FROM product pro
	INNER JOIN dbo.product_to_category ptc ON ptc.product_id = pro.product_id
	LEFT JOIN  associate_to_generate_category_task_products A ON A.product_id = pro.product_id	
	WHERE ptc.category_id = @categoryId AND A.product_id IS NULL	
		
	--Updating product contentMoified status of removed productTocategories	
		
	UPDATE  pro
	SET		pro.search_content_modified = 1 ,
			pro.content_modified = 1
	FROM	product pro
	INNER JOIN #tmpToDeleteProductToCategories tmpp on tmpp.product_id = pro.product_id
		
			
	DELETE ptc
	FROM product_to_category ptc
	INNER JOIN #tmpToDeleteProductToCategories tmpp on tmpp.product_id = ptc.product_id and ptc.category_id = @categoryId
	WHERE ptc.category_id = @categoryId 
		
	SELECT ISNULL(MAX(product_id),-1) as maxProductId FROM #tmpToDeleteProductToCategories

	DROP TABLE #tmpToDeleteProductToCategories	   	  
	
END
GO

GRANT EXECUTE ON dbo.adminCategory_DeleteProductsForGeneratedCategories TO VpWebApp
GO


