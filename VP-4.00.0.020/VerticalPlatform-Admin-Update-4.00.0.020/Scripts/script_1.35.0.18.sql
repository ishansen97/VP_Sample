IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[page]') AND type in (N'U'))
BEGIN
	UPDATE page SET hidden = 1 WHERE page_id IN (
		SELECT page_id
		FROM page
		WHERE page_name IN ('ReviewFormThankYou','ReviewTypeList','ReviewForm')
	)
END
GO
----------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminField_GetFeildByFieldTextFieldContentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminField_GetFeildByFieldTextFieldContentId
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@actionId int,
	@fieldContentTypeId int,
	@fieldText varchar(1000)
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminField_GetFeildByFieldTextFieldContentId.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT field_id AS id, site_id, content_type_id, content_id, action_id
		, field_content_type_id, field_type_id,	predefined_field_id, field_text
		, field_text_abbreviation, field_description, enabled, modified, created
	FROM

		(
		SELECT *
		FROM field
		WHERE field_text = @fieldText
		) temp_table

	WHERE (site_id IS NULL) 
	OR
	(site_id = @siteId AND @fieldContentTypeId = 9 AND field_content_type_id = @fieldContentTypeId)
	OR
	(site_id = @siteId AND @fieldContentTypeId = 37 AND field_content_type_id = @fieldContentTypeId)
	OR
	(site_id = @siteId AND @contentTypeId = 5 AND content_type_id = @contentTypeId AND content_id = @contentId
		AND action_id = @actionId)
	OR
	(site_id = @siteId AND @contentTypeId = 1 AND action_id = @actionId)

END
GO

GRANT EXECUTE ON dbo.adminField_GetFeildByFieldTextFieldContentId TO VpWebApp 
GO
--------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicField_GetFieldOptionByFieldOptionIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicField_GetFieldOptionByFieldOptionIdsList
	@fieldOptionIds varchar(max)
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT field_option_id AS id, field_id, predefined_option_id, option_value, [enabled], modified
		, created, sort_order
	FROM field_option
		INNER JOIN global_Split(@fieldOptionIds, ',') temp
			ON temp.[value] = field_option.field_option_id
	WHERE enabled = 1
	ORDER BY field_id, sort_order ASC

END
GO

GRANT EXECUTE ON dbo.publicField_GetFieldOptionByFieldOptionIdsList TO VpWebApp 
GO
-----------------------------------------------------

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
			a.enabled = 1
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
---------------------------------------------------------------
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
		a.enabled = 1


END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductContentRatingCount TO VpWebApp 
GO
---------------------------------------------------