
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
			a.enabled = 1 AND a.published = 1 AND 
			EXISTS 
			(
				SELECT review_type_id 
				FROM review_type 
				WHERE article_type_id = a.article_type_id AND 
				enabled=1
			)
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
-------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetManufacturersByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetManufacturersByProductIdList
	@productIds VARCHAR(MAX)

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT [vendor].[vendor_id] AS [Id],[vendor].[site_id],[vendor].[vendor_name],[vendor].[rank],[vendor].[has_image],[vendor].[enabled]
		,[vendor].[modified],[vendor].[created],[vendor].[parent_vendor_id],[vendor].[vendor_keywords],[vendor].[internal_name]
	FROM [vendor]
		INNER JOIN [product_to_vendor]
			ON [vendor].[vendor_id] = [product_to_vendor].[vendor_id]
		INNER JOIN global_split(@productIds, ',') tempProduct
			ON tempProduct.[value] = [product_to_vendor].[product_id] AND [product_to_vendor].[enabled] = 1
	WHERE [product_to_vendor].[is_manufacturer] = 1 AND [vendor].[enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetManufacturersByProductIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------