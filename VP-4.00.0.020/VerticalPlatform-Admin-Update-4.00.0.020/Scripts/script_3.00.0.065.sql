--adminProduct_AddProduct

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProduct
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank float,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank FLOAT,
	@contentModified BIT = 1 --default content modified flag  = 1 
	
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO product(site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank,content_modified) 
	VALUES (@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @created, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue,@ignoreInRapid, @showInMatrix, @showDetailPage, @defaultRank, @defaultSearchRank,@contentModified) 

	SET @id = SCOPE_IDENTITY() 

END

GO

GRANT EXECUTE ON dbo.adminProduct_AddProduct TO VpWebApp 
GO

--adminProduct_UpdateProduct

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProduct
	@id int, 
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank float,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank FLOAT,
	@contentModified BIT = 1 --default content modified flag  = 1 
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE product 
	SET
		site_id = @siteId,
		product_name = @productName,
		rank = @rank,
		has_image = @hasImage,
		catalog_number = @catalogNumber,
		[enabled] = @enabled,
		modified = @modified,
		product_type = @productType,
		status = @status,
		has_related = @hasRelated,
		has_model = @hasModel,
		completeness = @completeness,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		search_rank = @searchRank,
		search_content_modified = @searchContentModified,
		hidden = @hidden,
		business_value = @businessValue,
		ignore_in_rapid = @ignoreInRapid,
		show_in_matrix = @showInMatrix,
		show_detail_page = @showDetailPage,
		default_rank = @defaultRank,
		default_search_rank = @defaultSearchRank,
		content_modified = @contentModified, 
		archived = ~@enabled
		
		
	WHERE product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProduct TO VpWebApp 
GO
---------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCategoryByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCategoryByCategoryId
	@categoryId int
AS
-- ==========================================================================
-- $URL$
-- $Revision$
-- $Date$ 
-- $Author$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE p
	SET p.content_modified = 1,
		p.search_content_modified = 1
	FROM [product] p
	INNER JOIN product_to_category pc
		ON p.product_id = pc.product_id
	WHERE pc.category_id = @categoryId

	DELETE FROM product_to_category
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCategoryByCategoryId TO VpWebApp 
Go

------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCategory'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCategory
	@id int
AS
-- ==========================================================================
-- $URL$
-- $Revision$
-- $Date$ 
-- $Author$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE p
	SET p.content_modified = 1,
		p.search_content_modified = 1
	FROM [product] p
	INNER JOIN product_to_category pc
		ON p.product_id = pc.product_id
	WHERE pc.product_to_category_id = @id

	DELETE FROM product_to_category
	WHERE product_to_category_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCategory TO VpWebApp 
Go
------------------------------------------------------------------------------------------------

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
	DECLARE @lastUpdateDate DATETIME = GETDATE()

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
	WHERE   prc.category_id IN (@categoryId, @associateSearchCategoryId)
	AND	prc.modified >= @lastUpdateDate

	
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
			INNER JOIN product_to_category ptc
		        ON ptc.product_id = p.product_id
			WHERE ctso.category_id = @categoryId
				AND p.enabled = 1
				AND ptc.category_id = @associateSearchCategoryId
			GROUP BY p.product_id
			HAVING COUNT(ptso.product_id) = @optionsCount
		)

	DROP TABLE #tmpProducts



END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp 
GO
------------------------------------------------------------------------------------------------

