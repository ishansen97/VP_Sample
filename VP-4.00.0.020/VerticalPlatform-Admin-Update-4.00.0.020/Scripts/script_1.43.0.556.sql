IF NOT EXISTS(SELECT * FROM [parameter_type] where [parameter_type]='ProductImageGallerySingleImageClass')
  BEGIN
  
	INSERT INTO parameter_type([parameter_type_id],[parameter_type],[enabled],[modified],[created])
    VALUES(204,'ProductImageGallerySingleImageClass',1,GETDATE(),GETDATE())	
  
  END
  
  
  
  -------------------------------------------
  
  
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetMultipleCategoriesParamters'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetMultipleCategoriesParamters
	@categoryIds varchar(MAX),
	@parameterTypeId int
AS
-- ==========================================================================
-- Author : Akila
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_parameter_id AS id, category_id, parameter_type_id, category_parameter_value, [enabled]
		, modified, created
	FROM category_parameter
		INNER JOIN global_Split(@categoryIds, ',') AS category_id_table 
			ON category_parameter.category_id = category_id_table.[value]
	WHERE parameter_type_id = @parameterTypeId

END
GO

GRANT EXECUTE ON dbo.adminCategory_GetMultipleCategoriesParamters TO VpWebApp 
GO


------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetParentLeafCategoriesByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetParentLeafCategoriesByProductId
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
		, is_displayed, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id
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