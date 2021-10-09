EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompletenessByModified'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompletenessByModified
	@siteId int,
	@modifiedSince smalldatetime,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	--Create temp table to store the product ids between start and end index
	CREATE TABLE #ordered_product(product_id int, completeness int)

	--Populate new product ids
	INSERT INTO #ordered_product
	SELECT product_id, completeness
	FROM
	( 
		SELECT product_id, 0 AS completeness, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id
		FROM product
		WHERE site_id = @siteId AND modified > @modifiedSince
	) AS filteredProducts
	WHERE row_id BETWEEN @startIndex AND @endIndex

	--Create temp table to store completeness factors used for calculation
	CREATE TABLE #completeness_factor(product_id int, content_type_id int, content_id int, completeness int, incompleteness int)

	--Populate completeness factors for products
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, MAX(completeness), MAX(incompleteness)
	FROM
	(
		SELECT op.product_id AS product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_to_category pc
				ON pc.product_id = op.product_id
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 1 AND pcf.content_id = pc.category_id
	) AS categoryFactors
	GROUP BY product_id, content_type_id, content_id
	
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, completeness, incompleteness
	FROM
	(
		SELECT op.product_id product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 5 AND pcf.content_id = @siteId
		WHERE op.product_id NOT IN
		(
			SELECT product_id FROM #completeness_factor
		)
	) AS siteFactors
	
	--Update completeness factor for specification types.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT #ordered_product.product_id, SUM(cf.completeness) score
			FROM #ordered_product
				INNER JOIN specification
					ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id AND specification.specification <> ''
				INNER JOIN #completeness_factor cf
					ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id 
			GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for empty specifications.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
		SELECT #ordered_product.product_id, SUM(cf.incompleteness) score
		FROM #ordered_product
			INNER JOIN specification
				ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id AND specification.specification = ''
			INNER JOIN #completeness_factor cf
					ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id
		GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for price.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN 
		(
			SELECT #ordered_product.product_id, MIN(cf.completeness) AS score
			FROM #ordered_product
				INNER JOIN product_to_vendor
					ON #ordered_product.product_id = product_to_vendor.product_id
				INNER JOIN product_to_vendor_to_price
					ON product_to_vendor_to_price.product_to_vendor_id = product_to_vendor.product_to_vendor_id
				INNER JOIN #completeness_factor cf
					ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 23 AND cf.content_id = 3
			GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id

	--Update completeness factor for article association in article types.	
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT product_id, SUM(score) score
			FROM
			(
			SELECT p.product_id, MIN(cf.completeness) score
			FROM #ordered_product p
				INNER JOIN content_to_content c
					ON c.associated_content_type_id = 2 AND c.associated_content_id = p.product_id AND  
						c.content_type_id = 4
				INNER JOIN article
					ON c.content_id = article.article_id
				INNER JOIN #completeness_factor cf
					ON cf.product_id = p.product_id AND cf.content_type_id = 16 AND article.article_type_id = cf.content_id
			GROUP BY p.product_id, article.article_type_id
			) t
			GROUP BY product_id
		) s
			ON p.product_id = s.product_id

	--Updates the product table
	UPDATE product
		SET product.completeness = #ordered_product.completeness, product.modified = GETDATE(), product.search_content_modified = 1
	FROM #ordered_product
	WHERE product.product_id = #ordered_product.product_id AND
		#ordered_product.completeness IS NOT NULL AND
		product.completeness <> #ordered_product.completeness
	
	DROP TABLE #ordered_product
	DROP TABLE #completeness_factor

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompletenessByModified TO VpWebApp 
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompleteness'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompleteness
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	--Create temp table to store the product ids between start and end index
	CREATE TABLE #ordered_product(product_id int, completeness int)
	
	--Populate product ids between start and end index
	INSERT INTO #ordered_product
	SELECT product_id, completeness
	FROM
	(
		SELECT product_id, 0 AS completeness, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id
		FROM product
		WHERE site_id = @siteId		
	) AS filteredProducts
	WHERE row_id BETWEEN @startIndex AND @endIndex
	
	--Create temp table to store completeness factors used for calculation
	CREATE TABLE #completeness_factor(product_id int, content_type_id int, content_id int, completeness int, incompleteness int)

	--Populate completeness factors for products
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, MAX(completeness), MAX(incompleteness)
	FROM
	(
		SELECT op.product_id AS product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_to_category pc
				ON pc.product_id = op.product_id
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 1 AND pcf.content_id = pc.category_id
	) AS categoryFactors
	GROUP BY product_id, content_type_id, content_id
	
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, completeness, incompleteness
	FROM
	(
		SELECT op.product_id product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 5 AND pcf.content_id = @siteId
		WHERE op.product_id NOT IN
		(
			SELECT product_id FROM #completeness_factor
		)
	) AS siteFactors
	
	--Update completeness factor for specification types.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT #ordered_product.product_id, SUM(cf.completeness) score
			FROM #ordered_product
				INNER JOIN specification
					ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id AND specification.specification <> ''
				INNER JOIN #completeness_factor cf
					ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id 
			GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for empty specifications.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
		SELECT #ordered_product.product_id, SUM(cf.incompleteness) score
		FROM #ordered_product
			INNER JOIN specification
				ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id AND specification.specification = ''
			INNER JOIN #completeness_factor cf
					ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id
		GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for price.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN 
		(
			SELECT #ordered_product.product_id, MIN(cf.completeness) AS score
			FROM #ordered_product
				INNER JOIN product_to_vendor
					ON #ordered_product.product_id = product_to_vendor.product_id
				INNER JOIN product_to_vendor_to_price
					ON product_to_vendor_to_price.product_to_vendor_id = product_to_vendor.product_to_vendor_id
				INNER JOIN #completeness_factor cf
					ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 23 AND cf.content_id = 3
			GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id

	--Update completeness factor for article association in article types.	
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT product_id, SUM(score) score
			FROM
			(
			SELECT p.product_id, MIN(cf.completeness) score
			FROM #ordered_product p
				INNER JOIN content_to_content c
					ON c.associated_content_type_id = 2 AND c.associated_content_id = p.product_id AND  
						c.content_type_id = 4
				INNER JOIN article
					ON c.content_id = article.article_id
				INNER JOIN #completeness_factor cf
					ON cf.product_id = p.product_id AND cf.content_type_id = 16 AND article.article_type_id = cf.content_id
			GROUP BY p.product_id, article.article_type_id
			) t
			GROUP BY product_id
		) s
			ON p.product_id = s.product_id

	--Updates the product table
	UPDATE product
		SET product.completeness = #ordered_product.completeness, product.modified = GETDATE(), product.search_content_modified = 1
	FROM #ordered_product
	WHERE product.product_id = #ordered_product.product_id AND
		#ordered_product.completeness IS NOT NULL AND
		product.completeness <> #ordered_product.completeness
	
	DROP TABLE #ordered_product
	DROP TABLE #completeness_factor

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompleteness TO VpWebApp 
GO

-------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductPriceCurrencyByContentTypeContentId'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductPriceCurrencyByContentTypeContentId
	@contentType int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	IF @contentType = 6
		BEGIN
			SELECT DISTINCT c.[currency_id] AS [id],c.[description],c.[local_symbol],c.[international_symbol]
				,c.[enabled],c.[created],c.[modified]
			FROM currency c
				INNER JOIN product_to_vendor_to_price pvp
					ON pvp.currency_id = c.currency_id
				INNER JOIN product_to_vendor ptv
					ON pvp.product_to_vendor_id = ptv.product_to_vendor_id
				INNER JOIN product p
					ON ptv.product_id = p.product_id
				INNER JOIN product_to_vendor ptv2
					ON p.product_id = ptv2.product_id
			WHERE ptv.is_manufacturer = 1 AND ptv2.vendor_id = @contentId
		END
	ELSE IF @contentType = 1
		BEGIN
			SELECT DISTINCT c.[currency_id] AS [id],c.[description],c.[local_symbol],c.[international_symbol]
				,c.[enabled],c.[created],c.[modified]
			FROM currency c
				INNER JOIN product_to_vendor_to_price pvp
					ON pvp.currency_id = c.currency_id
				INNER JOIN product_to_vendor ptv
					ON pvp.product_to_vendor_id = ptv.product_to_vendor_id
				INNER JOIN product p
					ON ptv.product_id = p.product_id
				INNER JOIN product_to_category ptc
					ON ptc.product_id = p.product_id
			WHERE ptc.category_id = @contentId
		END

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductPriceCurrencyByContentTypeContentId TO VpWebApp
GO
-------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId
	@contentType int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	IF @contentType = 1
		BEGIN
			SELECT DISTINCT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
				  ,sg.[enabled],sg.[created],sg.[modified],sg.[add_options_automatically],sg.[prefix_text]
				  ,sg.[suffix_text]
			FROM [search_group] sg
				INNER JOIN search_option so
					ON sg.search_group_id = so.search_group_id
				INNER JOIN product_to_search_option ptso
					ON so.search_option_id = ptso.search_option_id
				INNER JOIN product_to_category pc 
					ON pc.product_id = ptso.product_id
			WHERE pc.category_id =  @contentId
		END
	ELSE IF @contentType = 6
		BEGIN
			SELECT DISTINCT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
				  ,sg.[enabled],sg.[created],sg.[modified],sg.[add_options_automatically],sg.[prefix_text]
				  ,sg.[suffix_text]
			FROM [search_group] sg
				INNER JOIN search_option so
					ON sg.search_group_id = so.search_group_id
				INNER JOIN product_to_search_option ptso
					ON so.search_option_id = ptso.search_option_id
				INNER JOIN product_to_vendor ptv 
					ON ptv.product_id = ptso.product_id
			WHERE ptv.vendor_id =  @contentId
		END
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId TO VpWebApp
GO
-------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductVendorPriceByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductVendorPriceByProductIdList
	@productIds varchar(max)

AS
-- ==========================================================================
-- $ Author : Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ptvtp.[product_vendor_price_id] AS id, ptvtp.[product_to_vendor_id], ptvtp.[currency_id], ptvtp.[price]
		  , ptvtp.[country_flag1], ptvtp.[country_flag2], ptvtp.[country_flag3], ptvtp.[country_flag4], ptvtp.[enabled]
		  , ptvtp.[created], ptvtp.[modified], ptv.product_id
	FROM [product_to_vendor_to_price] ptvtp
		INNER JOIN [product_to_vendor] ptv
			ON ptv.[product_to_vendor_id] = ptvtp.[product_to_vendor_id]
		INNER JOIN global_Split(@productIds, ',') p
			ON p.[value] = ptv.product_id
	WHERE ptv.is_manufacturer = 1

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductVendorPriceByProductIdList TO VpWebApp 
GO
-------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetContentSpecificationsByContentTypeContentIdList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetContentSpecificationsByContentTypeContentIdList
	@contentType int,
	@categoryId int,
	@itemContentIdList varchar(max),
	@itemContentType int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	IF @contentType = 1
		BEGIN
			SELECT s.[specification_id] AS id,s.[content_id],s.[spec_type_id],s.[specification]
				  ,s.[enabled],s.[modified],s.[created],s.[content_type_id],s.[display_options]
				  ,s.[sort_order]
			FROM [specification] s
				INNER JOIN global_Split(@itemContentIdList, ',') p
					ON p.[value] = s.content_id
			WHERE s.content_type_id = @itemContentType AND s.spec_type_id IN
			(
				SELECT DISTINCT spec_type_id
				FROM category_to_specification_type
				WHERE category_id = @categoryId
			)
		END
	ELSE IF @contentType = 6
		BEGIN
			SELECT s.[specification_id] AS id,s.[content_id],s.[spec_type_id],s.[specification]
				  ,s.[enabled],s.[modified],s.[created],s.[content_type_id],s.[display_options]
				  ,s.[sort_order]
			FROM [specification] s
				INNER JOIN global_Split(@itemContentIdList, ',') p
					ON p.[value] = s.content_id
			WHERE s.content_type_id = @itemContentType
		END
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetContentSpecificationsByContentTypeContentIdList TO VpWebApp
GO
-------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetContentSpecificationTypesByContentTypeContentId'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetContentSpecificationTypesByContentTypeContentId
	@contentType int,
	@contentId int,
	@itemContentType int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	IF @contentType = 1
		BEGIN
			SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
				  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
				  ,st.[is_expanded_view],st.[display_empty]
			FROM [specification_type] st
				INNER JOIN category_to_specification_type cst
					ON cst.[spec_type_id] = st.[spec_type_id]
			WHERE cst.category_id = @contentId
		END
	ELSE IF @contentType = 6
		BEGIN
			SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
				  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
				  ,st.[is_expanded_view],st.[display_empty]
			FROM [specification_type] st
				INNER JOIN specification s
					ON s.spec_type_id = st.[spec_type_id]
				INNER JOIN product_to_vendor ptv
					ON ptv.product_id = s.content_id
			WHERE s.content_type_id = @itemContentType AND ptv.vendor_id = @contentId
		END
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetContentSpecificationTypesByContentTypeContentId TO VpWebApp
GO
-------