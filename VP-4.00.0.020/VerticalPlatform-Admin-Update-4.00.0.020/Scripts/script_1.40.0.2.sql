EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetProductReviewsByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetProductReviewsByProductId
	@siteId INT,
	@productId INT,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT article_id
	INTO #ArticleIds
	FROM (
		SELECT DISTINCT a.article_id, DENSE_RANK() OVER (ORDER BY a.date_published ASC) AS row
		FROM [article] a 
			INNER JOIN article_type_template att
				ON att.article_type_id = a.article_type_id
			INNER JOIN [review_type] rt
				ON rt.[article_type_template_id] = att.[article_type_template_id] 
			INNER JOIN [article_type] at
				ON at.[article_type_id] = a.[article_type_id] AND at.[enabled] = 1 
			INNER JOIN content_to_content ctc 
				ON a.article_id = ctc.content_id AND ctc.enabled = 1 AND ctc.content_type_id= 4 
		WHERE a.[enabled] = 1 
			AND rt.[enabled] = 1
			AND rt.[site_id] = @siteId
			AND (ctc.associated_content_id = @productId AND ctc.associated_content_type_id = 2)
	) article
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	SELECT a.article_id AS id, a.article_type_id, a.site_id, a.article_title, a.article_sub_title
	, a.article_summary, a.[enabled], a.modified, a.created, a.article_short_title
	, a.date_published, a.start_date, a.end_date, a.published, a.external_url_id, a.is_article_template, a.is_external
	, a.featured_identifier, a.thumbnail_image_code,a.article_template_id, a.open_new_window, a.flag1, a.flag2, a.flag3, a.flag4, a.search_content_modified, a.deleted
	FROM [article] a 
	INNER JOIN #ArticleIds aids
		ON a.article_id = aids.article_id
		
	DROP TABLE #ArticleIds
	
	SELECT @totalCount = COUNT(DISTINCT a.article_Id)
	FROM [article] a 
		INNER JOIN article_type_template att
			ON att.article_type_id = a.article_type_id
		INNER JOIN [review_type] rt
			ON rt.[article_type_template_id] = att.[article_type_template_id] 
		INNER JOIN [article_type] at
			ON at.[article_type_id] = a.[article_type_id] 
				AND at.[enabled] = 1 
		INNER JOIN content_to_content ctc 
			ON a.article_id = ctc.content_id 
				AND ctc.enabled = 1 
				AND ctc.content_type_id= 4 
	WHERE a.[enabled] = 1 
		AND rt.[enabled] = 1
		AND rt.[site_id] = @siteId
		AND (ctc.associated_content_id = @productId AND ctc.associated_content_type_id = 2)
	
END
GO

GRANT EXECUTE ON dbo.publicArticle_GetProductReviewsByProductId TO VpWebApp 
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------