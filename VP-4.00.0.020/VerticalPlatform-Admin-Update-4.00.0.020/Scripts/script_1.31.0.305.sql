
EXEC dbo.global_DropStoredProcedure 'dbo.publicCategory_GetMaxCategoryByproductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.publicCategory_GetMaxCategoryByproductIdsList
	@productIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	
	WITH product_category_ids (product_id, category_id) AS
	(
		SELECT proCat.product_id, MAX(proCat.category_id) AS category_id
		FROM  product_to_category proCat 
			INNER JOIN global_Split(@productIds, ',') AS product_id_table
				ON proCat.product_id = product_id_table.[value]
			INNER JOIN category cat
				ON cat.category_id = proCat.category_id
		WHERE cat.enabled = 1
		GROUP BY proCat.product_id
	)
		
	
	SELECT product_category_ids.product_id, cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
			, cat.description, cat.short_name, cat.specification, cat.is_search_category 
			, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id
	FROM category cat
	INNER JOIN product_category_ids
		ON product_category_ids.category_id = cat.category_id

END
GO

GRANT EXECUTE ON dbo.publicCategory_GetMaxCategoryByproductIdsList TO VpWebApp 
GO
------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds
	@ParentProductId int,
	@productCompressionGroupId int,
	@searchOptionIds varchar(max),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	
	SELECT DISTINCT product.product_id AS id, site_id, product.parent_product_id, product_name, [rank], has_image, catalog_number, product.enabled,
		product.modified, product.created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page, ignore_in_rapid
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id AND pp.enabled = 1
	INNER JOIN product_to_category ptc
		ON 	ptc.product_id = pp.product_id  AND ptc.enabled = 1
	INNER JOIN product_compression_group_to_product proGro
		ON pp.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		) AND 
		pp.parent_product_id = @ParentProductId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ','))) AND
		product.enabled = 1

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO
--------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductToProductByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductToProductByProductIdList
@productId int
	
AS
-- ==========================================================================
-- $Author: umesha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id as id, parent_product_id, product_id, enabled, created, modified
	FROM product_to_product	
	WHERE product_to_product.parent_product_id = @productId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductToProductByProductIdList TO VpWebApp 
GO
--------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductToProductByProductIdCategoryList'

---------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildProductsByProductCompressionGroupIdCategoryIdSearchOptionIds'
-----------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList
    @productIds VARCHAR(4000),
    @categoryId INT,
    @countryFlag1 BIGINT ,	
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS
-- ==========================================================================  
-- Author : Dimuthu  
-- ==========================================================================  

    BEGIN  
  
        SET NOCOUNT ON;    
    
        SELECT  c.product_compression_group_id AS id ,
                site_id ,
                show_in_matrix ,
                show_product_count ,
                group_title ,
                expand_products ,
                enabled ,
                created ,
                modified ,
                is_default ,
                group_name ,
                product_id ,
                product_count
        FROM    ( SELECT    CAST(p.[value] AS INT) AS product_id ,
                            cp.product_compression_group_id ,
                            COUNT(*) product_count
                  FROM      product_to_product pp
                            INNER JOIN global_Split(@productIds, ',') AS p ON pp.parent_product_id = p.[value]
                            INNER JOIN product ON pp.product_id = product.product_id
                            INNER JOIN product_compression_group_to_product cp ON pp.product_id = cp.product_id
                            INNER JOIN dbo.product_to_category ptc ON pp.product_id = ptc.product_id
                  WHERE     (( product.flag1 & @countryFlag1 > 0 )
                            OR ( product.flag2 & @countryFlag2 > 0 )
                            OR ( product.flag3 & @countryFlag3 > 0 )
                            OR ( product.flag4 & @countryFlag4 > 0 ))
							AND product.enabled = 1
                            AND pp.enabled = 1
                            AND ptc.enabled = 1
                            AND ptc.category_id = @categoryId
                  GROUP BY  p.[value] ,
                            cp.product_compression_group_id
							
                ) g
                INNER JOIN product_compression_group c ON g.product_compression_group_id = c.product_compression_group_id   
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList TO VpWebApp 
GO



