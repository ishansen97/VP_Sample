EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentSearchGroupSearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicSearchCategory_GetFixedGuidedBrowseAllSegmentSearchGroupSearchOptionsList]
	@categoryId int,
	@searchGroupId int,
	@selectedOptions varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	-- Populate primary search option ids
	CREATE TABLE #PrimarySearchOption (search_option_id int)
	INSERT INTO #PrimarySearchOption
	SELECT DISTINCT s.search_option_id
	FROM search_option s
		INNER JOIN product_to_search_option ps
			ON ps.search_option_id = s.search_option_id
		INNER JOIN product_to_category pc
			ON pc.product_id = ps.product_id
		INNER JOIN product p
			ON p.product_id = pc.product_id
	WHERE s.enabled = 1 AND s.search_group_id = @searchGroupId AND p.enabled = 1 AND pc.enabled = 1 AND p.show_in_matrix = 1

	-- Populate secondary search option ids
	CREATE TABLE #SecondarySearchOption (search_option_id int)
	INSERT INTO #SecondarySearchOption
	SELECT [VALUE] FROM global_split(@selectedOptions, ',')
	
	-- Find number of rows in secondary option ids
	DECLARE @secondarySearchOptionCount int
	SELECT @secondarySearchOptionCount = COUNT(*) FROM #SecondarySearchOption

	-- Find products having at least one primary option and all secondary options
	CREATE TABLE #FilteredProduct (product_id int)
	INSERT INTO #FilteredProduct
	SELECT ps.product_id
	FROM product_to_search_option ps
		INNER JOIN product_to_category pc
			ON ps.product_id = pc.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
		INNER JOIN product p
			ON p.product_id = ps.product_id AND p.enabled = 1 AND p.show_in_matrix = 1
	WHERE ps.product_id IN 
	(
		SELECT product_id
		FROM product_to_search_option so
			INNER JOIN #PrimarySearchOption
				ON so.search_option_id = #PrimarySearchOption.search_option_id
	)
	AND ps.search_option_id IN
	(
		SELECT search_option_id
		FROM #SecondarySearchOption
	)
	GROUP BY ps.product_id
	HAVING COUNT(ps.search_option_id) = @secondarySearchOptionCount

	-- Select search options in primary option list having products in filtered products list
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id
		FROM product_to_search_option ps
			INNER JOIN #FilteredProduct
				ON ps.product_id = #FilteredProduct.product_id
		WHERE search_option_id IN
		(
			SELECT search_option_id
			FROM #PrimarySearchOption
		)
	)
	ORDER BY [name]

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentSearchGroupSearchOptionsList TO VpWebApp 
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentGuidedBrowseSearchGroupSearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicSearchCategory_GetFixedGuidedBrowseAllSegmentGuidedBrowseSearchGroupSearchOptionsList]
	@categoryId int,
	@guidedBrowseSearchGroupId int,
	@selectedOptions varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	-- Populate primary search option ids
	CREATE TABLE #PrimarySearchOption (search_option_id int)
	INSERT INTO #PrimarySearchOption
	SELECT DISTINCT s.search_option_id
	FROM search_option s
		INNER JOIN guided_browse_to_search_group_to_search_option gbso
			ON gbso.search_option_id = s.search_option_id
		INNER JOIN product_to_search_option ps
			ON ps.search_option_id = s.search_option_id
		INNER JOIN product_to_category pc
			ON pc.product_id = ps.product_id
		INNER JOIN product p
			ON p.product_id = pc.product_id
	WHERE s.enabled = 1 AND gbso.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND p.enabled = 1 AND pc.enabled = 1 AND p.show_in_matrix = 1

	-- Populate secondary search option ids
	CREATE TABLE #SecondarySearchOption (search_option_id int)
	INSERT INTO #SecondarySearchOption
	SELECT [VALUE] FROM global_split(@selectedOptions, ',')
	
	-- Find number of rows in secondary option ids
	DECLARE @secondarySearchOptionCount int
	SELECT @secondarySearchOptionCount = COUNT(*) FROM #SecondarySearchOption

	-- Find products having at least one primary option and all secondary options
	CREATE TABLE #FilteredProduct (product_id int)
	INSERT INTO #FilteredProduct
	SELECT ps.product_id
	FROM product_to_search_option ps
		INNER JOIN product_to_category pc
			ON ps.product_id = pc.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
		INNER JOIN product p
			ON p.product_id = ps.product_id AND p.enabled = 1 AND p.show_in_matrix = 1
	WHERE ps.product_id IN 
	(
		SELECT product_id
		FROM product_to_search_option so
			INNER JOIN #PrimarySearchOption
				ON so.search_option_id = #PrimarySearchOption.search_option_id
	)
	AND ps.search_option_id IN
	(
		SELECT search_option_id
		FROM #SecondarySearchOption
	)
	GROUP BY ps.product_id
	HAVING COUNT(ps.search_option_id) = @secondarySearchOptionCount

	-- Select search options in primary option list having products in filtered products list
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id
		FROM product_to_search_option ps
			INNER JOIN #FilteredProduct
				ON ps.product_id = #FilteredProduct.product_id
		WHERE search_option_id IN
		(
			SELECT search_option_id
			FROM #PrimarySearchOption
		)
	)
	ORDER BY [name]

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentGuidedBrowseSearchGroupSearchOptionsList TO VpWebApp 
GO

------------------------------------------------------------------------------

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
	
	SELECT @optionCount = count(value)
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
	HAVING count(cso.associated_content_id) = @optionCount
		
	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, external_url_id, date_published, start_date, end_date, published, article_template_id, open_new_window,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article 
	WHERE article_id IN (SELECT article_id FROM #articleId)

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesByArticleTemplateIdAndSearchOptionIds TO VpWebApp 
GO
----------------------------------------------------------------------------------------