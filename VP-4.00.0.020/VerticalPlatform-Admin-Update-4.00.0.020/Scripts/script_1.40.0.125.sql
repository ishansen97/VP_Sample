
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductsArticleRelatedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductsArticleRelatedCategories
	@numberofProducts int,
	@articleId int,
	@siteId int,
	@addedProducts varchar(1000),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	
	SELECT pc.product_id, ROUND(RAND(CHECKSUM(NEWID())) * 10000, 0) as randomId
	INTO #productIds
	FROM product_to_category pc			
	WHERE pc.enabled = 1 AND pc.category_id IN 
	(

		SELECT associated_content_id
		FROM content_to_content
		WHERE content_id = @articleId AND content_type_id = 4 AND enabled = 1 
		AND associated_content_type_id = 1 AND site_id = @siteId 
	)

	SELECT TOP(@numberofProducts) p.product_id as id, p.site_id, p.product_Name, p.[rank], p.has_image
			, p.catalog_number, p.[enabled], p.modified, p.created, p.product_type, p.status
			, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank
			, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
			, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
			, p.completeness
	FROM product p
	INNER JOIN #productIds pids
		ON p.product_id = pids.product_id 
	WHERE p.enabled = 1
	AND
	(
		(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
		(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
	)
	AND p.product_id NOT IN  (Select [value] FROM global_Split(@addedProducts, ','))
	ORDER BY pids.randomId

	DROP TABLE #productIds
	
END

GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductsArticleRelatedCategories TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------

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
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
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
		
	SELECT article_id AS id, article_type_id, site_id, article_title, article_sub_title, article_summary, 
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