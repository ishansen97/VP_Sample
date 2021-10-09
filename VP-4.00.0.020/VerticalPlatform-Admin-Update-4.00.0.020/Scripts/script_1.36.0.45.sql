-- Get content metadata information
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadataInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadataInformation
	@siteId int,
	@contentTypeId int,
	@pageStart int,
	@pageEnd int,
	@recordCount int output
AS
-- ==========================================================================
-- $Author: Dasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT s.site_name, cm.content_metadata_id as id, cm.site_id, cm.content_type_id, cm.content_id, cm.title_tag, cm.keywords, cm.description, 
			CASE WHEN c.category_name IS NOT NULL THEN c.category_name 
				 WHEN a.article_title IS NOT NULL THEN a.article_title 
				 WHEN v.vendor_name IS NOT NULL THEN v.vendor_name 
				 WHEN p.product_name IS NOT NULL THEN p.product_name  
				 WHEN f.name IS NOT NULL THEN f.name  END
			AS content_name, 
			
			
			CASE WHEN c.created IS NOT NULL THEN c.created
				 WHEN a.created IS NOT NULL THEN a.created
				 WHEN v.created IS NOT NULL THEN v.created 
				 WHEN p.created IS NOT NULL THEN p.created 
				 WHEN f.created IS NOT NULL THEN f.created END
			AS content_created,
			
			CASE WHEN c.modified IS NOT NULL THEN c.modified
				 WHEN a.modified IS NOT NULL THEN a.modified 
				 WHEN v.modified IS NOT NULL THEN v.modified  	
				 WHEN p.modified IS NOT NULL THEN p.modified
				 WHEN f.modified IS NOT NULL THEN f.modified END
			AS content_modified,
			cm.enabled, cm.modified, cm.created, cm.noindex into #contentMetadata
	FROM content_metadata cm
	
			INNER JOIN site s 
			ON s.site_id = cm.site_id
			LEFT OUTER JOIN category c
			ON cm.content_id = c.category_id AND cm.content_type_id = 1
			LEFT OUTER JOIN vendor v
			ON cm.content_id = v.vendor_id AND cm.content_type_id = 6
			LEFT OUTER JOIN article a
			ON cm.content_id = a.article_id AND cm.content_type_id = 4
			LEFT OUTER JOIN product p
			ON cm.content_id = p.product_id AND cm.content_type_id = 2
			LEFT OUTER JOIN fixed_guided_browse f
			ON cm.content_id = f.fixed_guided_browse_id AND cm.content_type_id = 36
	WHERE  ((cm.content_type_id = @contentTypeId) OR (@contentTypeId IS NULL))
			AND ((cm.site_id = @siteId) OR (@siteId IS NULL))
	

	SELECT ROW_NUMBER() OVER(ORDER BY tcm.site_id, content_created) AS rowNum, 
			site_name, id, site_id, content_type_id, content_id, title_tag, keywords, description,
			content_name, content_created, content_modified, enabled, modified, created, noindex into #orderedContentMetadata
	FROM #contentMetadata tcm

	SELECT * 
	FROM #orderedContentMetadata
	WHERE rowNum BETWEEN @pageStart AND @pageEnd

	SELECT @recordCount = COUNT(id) 
	FROM #contentMetadata	

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadataInformation TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId
	@searchCategoryId int,
	@searchOptionsIds varchar(max),
	@optionCount int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Rifaz $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SELECT @totalCount = COUNT(pso.product_id)
	FROM product_to_search_option pso
		INNER JOIN dbo.global_Split(@searchOptionsIds, ',') sids
			ON pso.search_option_id = sids.[value]
		INNER JOIN product_to_category pc
			ON pc.product_id = pso.product_id
		INNER JOIN product p
			ON pso.product_id = p.product_id
	WHERE p.enabled = 1 AND pc.category_id = @searchCategoryId
	GROUP BY pso.product_id
	HAVING COUNT(pso.product_id) = @optionCount
	
END
GO

GRANT EXECUTE ON dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId TO VpWebApp 
GO
------------------------------------------------------------------------------------------------
