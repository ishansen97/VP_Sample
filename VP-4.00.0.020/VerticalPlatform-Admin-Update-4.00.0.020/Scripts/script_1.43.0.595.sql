EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompletenessByModified'

GO
/****** Object:  StoredProcedure [dbo].[adminProduct_UpdateProductCompletenessByModified]    Script Date: 1/3/2019 3:11:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_UpdateProductCompletenessByModified]
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
	SET ARITHABORT ON;
	
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

	--Create temp table to store relevant product to category relationships
	CREATE TABLE #product_to_category(product_id int, category_id int)
	
	--Populates the product to category relationships
	INSERT INTO #product_to_category
	SELECT product_id, category_id
	FROM product_to_category
	WHERE product_to_category.product_id IN (select product_id from #ordered_product)
	
	--Populate completeness factors for products
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, MAX(completeness), MAX(incompleteness)
	FROM
	(
		SELECT pc.product_id AS product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #product_to_category pc
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
	
	--product specs,completeness common table
	SELECT #ordered_product.product_id AS product_id
			, cf.completeness AS completeness
			, cf.incompleteness AS incompleteness
			, specification.specification AS specification
	INTO	#ordered_product_to_specs
	FROM	#ordered_product
			INNER JOIN specification
				ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id 
			INNER JOIN #completeness_factor cf
				ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id 


	--Update completeness factor for specification types.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT tmp.product_id, SUM(tmp.completeness) score
			FROM #ordered_product_to_specs tmp
			where tmp.specification <> ''
			GROUP BY tmp.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for empty specifications.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
		SELECT tmp.product_id, SUM(tmp.incompleteness) score
		FROM #ordered_product_to_specs tmp
		where tmp.specification = ''
		GROUP BY tmp.product_id
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
	DROP TABLE #product_to_category

END

GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompletenessByModified TO VpWebApp
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompleteness'

GO
/****** Object:  StoredProcedure [dbo].[adminProduct_UpdateProductCompleteness]    Script Date: 1/2/2019 1:51:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_UpdateProductCompleteness]
	@siteId int,
	@startIndex int,
	@endIndex INT
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
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
	
	--Create temp table to store relevant product to category relationships
	CREATE TABLE #product_to_category(product_id int, category_id int)
	

	--Populates the product to category relationships
	INSERT INTO #product_to_category
	SELECT pr_cat.product_id, pr_cat.category_id
	FROM product_to_category pr_cat 
	INNER JOIN #ordered_product tmp ON tmp.product_id = pr_cat.product_id 



	--Populate completeness factors for products
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, MAX(completeness), MAX(incompleteness)
	FROM
	(
		SELECT pc.product_id AS product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #product_to_category pc
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
		WHERE  NOT EXISTS
		(
			SELECT 1 FROM #completeness_factor tmp
			WHERE tmp.product_id = op.product_id
		)
	) AS siteFactors
	
	
	--product specs,completeness common table
	SELECT #ordered_product.product_id AS product_id
			, cf.completeness AS completeness
			, cf.incompleteness AS incompleteness
			, specification.specification AS specification
	INTO	#ordered_product_to_specs
	FROM	#ordered_product
			INNER JOIN specification
				ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id 
			INNER JOIN #completeness_factor cf
				ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id 



	--Update completeness factor for specification types.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT tmp.product_id, SUM(tmp.completeness) score
			FROM #ordered_product_to_specs tmp
			where tmp.specification <> ''
			GROUP BY tmp.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for empty specifications.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
		SELECT tmp.product_id, SUM(tmp.incompleteness) score
		FROM #ordered_product_to_specs tmp
		where tmp.specification = ''
		GROUP BY tmp.product_id
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
	DROP TABLE #product_to_category

END


GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompleteness TO VpWebApp
GO


