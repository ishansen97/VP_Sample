EXEC dbo.global_DropStoredProcedure 'dbo.publicBulkEmail_GetCampaignLogsByCampaignIdAndSeverityList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicBulkEmail_GetCampaignLogsByCampaignIdAndSeverityList
	@campaignId int,
	@severity varchar(20)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT campaign_log_id AS id, campaign_id, [event], [severity], provider_id, [status], [message], [timestamp],
		created, modified, [enabled] 
	FROM campaign_log
	WHERE campaign_id = @campaignId AND [severity] = @severity
	ORDER BY [timestamp] DESC

END
GO

GRANT EXECUTE ON dbo.publicBulkEmail_GetCampaignLogsByCampaignIdAndSeverityList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicBulkEmail_GetCampaignLogsByCampaignIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicBulkEmail_GetCampaignLogsByCampaignIdList
	@campaignId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT campaign_log_id AS id, campaign_id, [event], [severity], provider_id, [status], [message], [timestamp],
		created, modified, [enabled] 
	FROM campaign_log
	WHERE campaign_id = @campaignId
	ORDER BY timestamp DESC	

END
GO

GRANT EXECUTE ON dbo.publicBulkEmail_GetCampaignLogsByCampaignIdList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdList
	@id int,
	@productId int = null
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, product_type, status
			, has_related, has_model, completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, show_in_matrix, show_detail_page
			, pro.default_rank, pro.default_search_rank
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @id
		  AND (@productId IS NULL OR catPro.product_id = @productId)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_CategoryGetNextSortOrder'

GO

/****** Object:  StoredProcedure [dbo].[adminProduct_CategoryGetNextSortOrder]    Script Date: 11/28/2018 4:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_CategoryGetNextSortOrder]
	@site_id INT,
	@nextSortOrder int output
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT	@nextSortOrder = ISNULL(MAX(sort_order),0)+1
	FROM	dbo.category
	WHERE	site_id = @site_id
			AND	category_type_id = 1

END


GO
GRANT EXECUTE ON dbo.adminProduct_CategoryGetNextSortOrder TO VpWebApp
GO


