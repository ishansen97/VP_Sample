IF NOT EXISTS(SELECT * FROM predefined_page WHERE page_name = 'ReviewVerification')
BEGIN
	INSERT INTO predefined_page(page_name,enabled,modified,created)
	VALUES('ReviewVerification','1',GETDATE(),GETDATE())
END

-------

EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_DeleteContentRatingsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminContentRating_DeleteContentRatingsBySiteId
	@siteId int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM content_rating
	WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminContentRating_DeleteContentRatingsBySiteId TO VpWebApp 
GO
------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_DeleteContentRatingsWithoutContentIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminContentRating_DeleteContentRatingsWithoutContentIds
	@contentTypeId int,
	@contentIds varchar(max)
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM content_rating
	WHERE content_type_id = @contentTypeId AND 
		content_id NOT IN
		(
			SELECT [value]
			FROM global_split(@contentIds, ',')
		)

END
GO

GRANT EXECUTE ON dbo.adminContentRating_DeleteContentRatingsWithoutContentIds TO VpWebApp 
GO
------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleOverallRatingCustomPropertyList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleOverallRatingCustomPropertyList
	@siteId int 	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	--This query retrieves overall rating custom properties for
	--articles which are not included in the content rating table.
	
	SELECT artcp.article_custom_property_id AS id, artcp.article_id, artcp.custom_property_id,
		artcp.custom_property_value, artcp.modified, artcp.created, artcp.[enabled]
	FROM article_custom_property artcp
		INNER JOIN custom_property cp
			ON cp.custom_property_id = artcp.custom_property_id
		INNER JOIN article a
			ON artcp.article_id = a.article_id
		INNER JOIN (SELECT DISTINCT article_type_id FROM review_type) rt
			ON rt.article_type_id = a.article_type_id
		LEFT JOIN content_rating cr
			ON a.article_id = cr.content_id AND cr.content_type_id = 4
	WHERE cp.property_name = 'Overall' AND
		(@siteId IS NULL OR a.site_id = @siteId)  AND
		cr.content_rating_id IS NULL AND a.[enabled] = 1
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleOverallRatingCustomPropertyList TO VpWebApp
GO
--------------------------------------
IF NOT EXISTS(SELECT module_name FROM dbo.module WHERE module_name = 'ProductRating')
BEGIN
INSERT INTO dbo.module (module_name, usercontrol_name,enabled,is_container)
VALUES ('ProductRating','~/Modules/ProductDetail/ProductRating.ascx',1,0)
END
GO
-------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductContentRatingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductContentRatingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	
	WITH temp_rating(row, product_id, average_rating, rating_count) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY ctc.associated_content_id ASC) AS row, ctc.associated_content_id AS product_id, 
				CAST( AVG(rating) AS DECIMAL(3,2)) AS average_rating, COUNT(rating) AS rating_count
		FROM content_rating cr 
			INNER JOIN content_to_content ctc
				ON ctc.content_id = cr.content_id AND
					cr.content_type_id = 4 AND
					ctc.associated_content_type_id =2
			INNER JOIN article a
				ON a.article_id = cr.content_id AND
					cr.content_type_id = 4
		WHERE (@siteId IS NULL OR cr.site_id = @siteId) AND
			a.enabled = 1 AND a.published = 1
		GROUP BY ctc.associated_content_id
	)
	
	SELECT 	p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
			, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created
			, p.product_type, p.[status], p.has_related, p.has_model, p.completeness
			, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden
			, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page, p.default_rank
			, p.default_search_rank, temp.average_rating, temp.rating_count
	FROM temp_rating temp
		INNER JOIN product p
			ON p.product_id = temp.product_id
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductContentRatingList TO VpWebApp 
GO
------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductContentRatingCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductContentRatingCount
	@siteId int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT COUNT( DISTINCT ctc.associated_content_id)
	FROM content_rating cr 
		INNER JOIN content_to_content ctc
			ON ctc.content_id = cr.content_id AND
				cr.content_type_id = 4 AND
				ctc.associated_content_type_id =2
		INNER JOIN article a
			ON a.article_id = cr.content_id AND
				cr.content_type_id = 4
	WHERE (@siteId IS NULL OR cr.site_id = @siteId) AND
		a.enabled = 1 AND a.published = 1


END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductContentRatingCount TO VpWebApp 
GO
------------------------------------------------
IF NOT EXISTS(SELECT module_name FROM dbo.module WHERE module_name = 'ArticleReviewConfirmation')
BEGIN
	INSERT INTO dbo.module (module_name, usercontrol_name,enabled,is_container)
	VALUES ('ArticleReviewConfirmation','~/Modules/Article/ArticleReviewConfirmation.ascx',1,0)
END
GO