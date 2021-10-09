EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList
    @parentProductId INT ,
    @categoryId INT,
    @compressionGroupId INT ,
    @countryFlag1 BIGINT ,
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS -- ==========================================================================
-- Author : Dimuthu
-- ==========================================================================
    BEGIN
	
        SET NOCOUNT ON;
	
        SELECT  product.product_id AS id ,
                site_id ,
                product_name ,
                [rank] ,
                has_image ,
                catalog_number ,
                product.enabled ,
                product.modified ,
                product.created ,
                product_type ,
                status ,
                has_model ,
                has_related ,
                flag1 ,
                flag2 ,
                flag3 ,
                flag4 ,
                completeness ,
                search_rank ,
                search_content_modified ,
                hidden ,
                business_value ,
                show_in_matrix ,
                show_detail_page ,
                ignore_in_rapid
        FROM    product
                INNER JOIN product_compression_group_to_product cp ON product.product_id = cp.product_id
                INNER JOIN product_to_product pp ON product.product_id = pp.product_id
				INNER JOIN dbo.product_to_category ptc ON pp.product_id = ptc.product_id
        WHERE   product.enabled = 1
				AND pp.enabled = 1
                AND ptc.enabled = 1
                AND cp.product_compression_group_id = @compressionGroupId
                AND pp.parent_product_id = @parentProductId
				AND ptc.category_id =  @categoryId
                AND ( ( product.flag1 & @countryFlag1 > 0 )
                      OR ( product.flag2 & @countryFlag2 > 0 )
                      OR ( product.flag3 & @countryFlag3 > 0 )
                      OR ( product.flag4 & @countryFlag4 > 0 )
                    )
		

    END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList TO VpWebApp 
GO
----------------------------------------------------
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
                  WHERE     ( product.flag1 & @countryFlag1 > 0 )
                            OR ( product.flag2 & @countryFlag2 > 0 )
                            OR ( product.flag3 & @countryFlag3 > 0 )
                            OR ( product.flag4 & @countryFlag4 > 0 )
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
------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateSearchContentModifiedArticlesByVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateSearchContentModifiedArticlesByVendor
	@vendorId int,
	@batchSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	WITH article_search_content_modified(article_id, search_content_modified, modified) AS
	(
		SELECT a.article_id, a.search_content_modified, a.modified
		FROM article a
			INNER JOIN content_to_content cc
				ON a.article_id = cc.content_id AND cc.associated_content_type_id = 6 AND cc.associated_content_id = @vendorId
		WHERE a.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) article_search_content_modified
	SET search_content_modified = 1, modified = getdate()
	
	SELECT @totalCount = COUNT(*)
	FROM article a
		INNER JOIN content_to_content cc
			ON a.article_id = cc.content_id AND cc.associated_content_type_id = 6 AND cc.associated_content_id = @vendorId
	WHERE a.search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateSearchContentModifiedArticlesByVendor TO VpWebApp 
GO

--------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSearchContentModifiedProductsByCategoryVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSearchContentModifiedProductsByCategoryVendor
	@vendorId int,
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
			INNER JOIN product_to_category pc
				ON pc.product_id = p.product_id
			INNER JOIN category_to_vendor cv
				ON cv.category_id = pc.category_id AND cv.vendor_id = @vendorId
		WHERE p.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) product_search_content_modified
	SET search_content_modified = 1, modified = getdate()
	
	SELECT @totalCount = COUNT(*)
	FROM product p
		INNER JOIN product_to_category pc
			ON pc.product_id = p.product_id
		INNER JOIN category_to_vendor cv
			ON cv.category_id = pc.category_id AND cv.vendor_id = @vendorId
	WHERE search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSearchContentModifiedProductsByCategoryVendor TO VpWebApp 
GO

------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSearchContentModifiedProductsBySearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSearchContentModifiedProductsBySearchOption
	@searchOptionId int,
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
			INNER JOIN product_to_search_option ps
				ON ps.product_id = p.product_id AND ps.search_option_id = @searchOptionId
		WHERE p.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) product_search_content_modified
	SET search_content_modified = 1, modified = getdate()
	
	SELECT @totalCount = COUNT(*)
	FROM product p
		INNER JOIN product_to_search_option ps
			ON ps.product_id = p.product_id AND ps.search_option_id = @searchOptionId
	WHERE search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSearchContentModifiedProductsBySearchOption TO VpWebApp 
GO

--------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSearchContentModifiedProductsByVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSearchContentModifiedProductsByVendor
	@vendorId int,
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
			INNER JOIN product_to_vendor pv
				ON pv.product_id = p.product_id AND pv.vendor_id = @vendorId
		WHERE p.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) product_search_content_modified
	SET search_content_modified = 1, modified = getdate()
	
	SELECT @totalCount = COUNT(*)
	FROM product p
		INNER JOIN product_to_vendor pv
			ON pv.product_id = p.product_id AND pv.vendor_id = @vendorId
	WHERE search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSearchContentModifiedProductsByVendor TO VpWebApp 
GO

-------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSearchContentModifiedProductsByCategory'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSearchContentModifiedProductsByCategory
	@categoryId int,
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
			INNER JOIN product_to_category pc
				ON pc.product_id = p.product_id AND pc.category_id = @categoryId
		WHERE p.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) product_search_content_modified
	SET search_content_modified = 1,  modified = getdate()
	
	SELECT @totalCount = COUNT(*)
	FROM product p
		INNER JOIN product_to_category pc
			ON pc.product_id = p.product_id AND pc.category_id = @categoryId
	WHERE search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSearchContentModifiedProductsByCategory TO VpWebApp 
GO

-----

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateSearchContentModifiedArticlesByProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateSearchContentModifiedArticlesByProduct
	@productId int,
	@batchSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	WITH article_search_content_modified(article_id, search_content_modified, modified) AS
	(
		SELECT a.article_id, a.search_content_modified, a.modified
		FROM article a
			INNER JOIN content_to_content cc
				ON a.article_id = cc.content_id AND cc.associated_content_type_id = 2 AND cc.associated_content_id = @productId
		WHERE a.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) article_search_content_modified
	SET search_content_modified = 1, modified = getdate()
	
	SELECT @totalCount = COUNT(*)
	FROM article a
		INNER JOIN content_to_content cc
			ON a.article_id = cc.content_id AND cc.associated_content_type_id = 2 AND cc.associated_content_id = @productId
	WHERE a.search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateSearchContentModifiedArticlesByProduct TO VpWebApp 
GO
