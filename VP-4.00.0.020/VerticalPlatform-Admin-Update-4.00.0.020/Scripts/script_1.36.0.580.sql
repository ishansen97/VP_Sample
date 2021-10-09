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
	
	--Update completeness factor for specification types.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT #ordered_product.product_id, SUM(cf.completeness) score
			FROM #ordered_product
				INNER JOIN specification
					ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id 
						AND specification.specification <> ''
				INNER JOIN #completeness_factor cf
					ON cf.product_id = #ordered_product.product_id AND cf.content_type_id = 26 
						AND specification.spec_type_id = cf.content_id 
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
	DROP TABLE #product_to_category

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompleteness TO VpWebApp 
GO

----------

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
	DROP TABLE #product_to_category

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompletenessByModified TO VpWebApp 
GO
----------------------------------------------------------------------------------------
IF NOT EXISTS 
(SELECT [name] FROM syscolumns WHERE [name] = 'hide_when_empty' AND id = (SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'article_section') AND type in (N'U')))
	BEGIN
		ALTER TABLE article_section
		ADD hide_when_empty BIT NOT NULL DEFAULT(0)
	END
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleSection'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticleSection
	@id int output,
	@articleId int,
	@sectionTitle varchar(100),
	@pageNumber int,
	@isPopup bit,
	@sortOrder int,
	@created smalldatetime output, 
	@enabled bit,
	@previewImageTitle varchar(100),
	@previewImageCode varchar(255),
	@cssClass varchar(50),
	@templateSectionId int,
	@isTemplateSection bit,
	@toggleSection bit,
	@toggleText varchar(max),
	@sectionName varchar(max),
	@hideWhenEmpty bit
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO article_section (article_id, section_title, page_number,
		is_popup, sort_order, [enabled], modified, created, preview_image_title, 
		preview_image_code,css_class,template_section_id,is_template_section, 
		toggle_section, toggle_text, section_name, hide_when_empty)
	VALUES (@articleId, @sectionTitle, @pageNumber,	@isPopup, @sortOrder, @enabled, 
		@created, @created, @previewImageTitle, @previewImageCode,@cssClass,
		@templateSectionId,@isTemplateSection,@toggleSection,@toggleText, 
		@sectionName, @hideWhenEmpty)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticleSection TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleSectionDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleSectionDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_section_id as id, article_id, section_title, is_popup, page_number, sort_order, 
		preview_image_title, preview_image_code, css_class, template_section_id,is_template_section , 
		[enabled], modified, created, toggle_section, toggle_text, section_name, hide_when_empty
	FROM article_section
	WHERE article_section_id = @id

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleSectionDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleSection'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleSection
	@id int,
	@articleId int,
	@sectionTitle varchar(100),
	@pageNumber int,
	@isPopup bit,
	@sortOrder int,
	@enabled bit,
	@previewImageTitle varchar(100),
	@previewImageCode varchar(255),
	@cssClass varchar(50),
	@templateSectionId int,
	@isTemplateSection bit,
	@modified smalldatetime output,
	@toggleSection bit,
	@toggleText varchar(max),
	@sectionName varchar(max),
	@hideWhenEmpty bit
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE article_section
	SET
		article_id = @articleId,
		section_title = @sectionTitle,
		page_number = @pageNumber,
		is_popup = @isPopup,
		sort_order = @sortOrder,
		[enabled] = @enabled,
		preview_image_code = @previewImageCode,
		preview_image_title = @previewImageTitle,
		css_class = @cssClass,
		modified = @modified,
		template_section_id = @templateSectionId,
		is_template_section = @isTemplateSection,
		toggle_section = @toggleSection,
		toggle_text = @toggleText,
		section_name = @sectionName,
		hide_when_empty = @hideWhenEmpty
	WHERE article_section_id = @id

END
GO

GRANT EXECUTE ON adminArticle_UpdateArticleSection TO VpWebApp
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleSectionByArticleIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleSectionByArticleIdList
	@articleId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_section_id AS id, article_id, section_title, is_popup, page_number, sort_order, 
		preview_image_title, preview_image_code, css_class,template_section_id, is_template_section, 
		[enabled], modified, created, toggle_section, toggle_text, section_name, hide_when_empty
	FROM article_section
	WHERE article_id = @articleId
	ORDER BY page_number, sort_order

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleSectionByArticleIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleSectionsByArticleIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleSectionsByArticleIds
	@articleIds VARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_section_id AS id, article_id, section_title,	is_popup, page_number, sort_order, 
		preview_image_title, preview_image_code, css_class,template_section_id, is_template_section, 
		[enabled], modified, created, toggle_section, toggle_text, section_name, hide_when_empty
	FROM article_section arti_sec
		INNER JOIN global_Split(@articleIds, ',') AS article_id_table
			ON arti_sec.article_id = article_id_table.[value]
	ORDER BY page_number, sort_order

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleSectionsByArticleIds TO VpWebApp 
GO
----------------------------------------------------------------------------------------
----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds
	@articleTemplateId int,
	@searchOptionIds varchar(max),
	@showUnpublished bit,
	@categoryId int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @optionCount int
	
	SELECT id,value INTO #searchOption
	FROM dbo.global_Split(@searchOptionIds, ',') so
	
	SELECT @optionCount = COUNT(value)
	FROM #searchOption
	
	SELECT article_id INTO #articleId
	FROM article a 
		INNER JOIN content_to_content cso  
			ON a.article_id = cso.content_id AND cso.content_type_id = 4 AND cso.associated_content_type_id = 32
		INNER JOIN content_to_content ccat 
			ON a.article_id = ccat.content_id AND ccat.content_type_id = 4 AND ccat.associated_content_type_id = 1
		INNER JOIN #searchOption so 
			ON cso.associated_content_id = so.value
	WHERE a.article_template_id = @articleTemplateId 
		AND (@showUnpublished = 1 OR a.enabled = 1)
		AND ccat.associated_content_id = @categoryId
	GROUP BY article_id
	HAVING COUNT(cso.associated_content_id) = @optionCount
		
	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, external_url_id, date_published, start_date, end_date, published, article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE article_id IN (
		SELECT article_id
		FROM #articleId a
			INNER JOIN content_to_content ctc  
				ON a.article_id = ctc.content_id AND ctc.content_type_id = 4 AND ctc.associated_content_type_id = 32
		GROUP BY a.article_id
		HAVING COUNT(ctc.associated_content_id) = @optionCount
	)

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds TO VpWebApp 
GO
