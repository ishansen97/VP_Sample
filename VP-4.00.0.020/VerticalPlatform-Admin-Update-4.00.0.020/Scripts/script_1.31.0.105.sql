
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdNameStatusTypeIsPrivateList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdNameStatusTypeIsPrivateList
	@campaignId int,
	@siteId int,
	@campaignStatusList varchar(100),
	@campaignName varchar(255),
	@campaignTypeId int,
	@campaignYear int,
	@isPrivate bit,
	@pageSize int,
	@pageIndex int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Nilushi Hikkaduwa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_campaign (row, rowDesc, modifiedRow, modifiedRowDesc, idRow, idRowDesc, nameRow, nameRowDesc, statusRow, statusRowDesc, scheduledDateRow, 
		 scheduledDateRowDesc, campaignNameRow, campaignNameRowDesc, campaign_id, site_id, campaign_type_id, [name], from_name, from_email, [subject], [private], 
		 html_template_id, text_template_id, [status], [enabled], created, modified, notified_status, sent_email_reminder, 
		 provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY campaign.created) AS row, 
					ROW_NUMBER() OVER (ORDER BY campaign.created DESC) AS rowDesc,
					ROW_NUMBER() OVER (ORDER BY campaign.modified) AS modifiedRow, 
					ROW_NUMBER() OVER (ORDER BY campaign.modified DESC) AS modifiedRowDesc,
					ROW_NUMBER() OVER (ORDER BY campaign.campaign_id) AS idRow, 
					ROW_NUMBER() OVER (ORDER BY campaign.campaign_id DESC) AS idRowDesc,
					ROW_NUMBER() OVER (ORDER BY campaign.[name]) AS nameRow, 
					ROW_NUMBER() OVER (ORDER BY campaign.[name] DESC) AS nameRowDesc,
					ROW_NUMBER() OVER (ORDER BY campaign.[status]) AS statusRow, 
					ROW_NUMBER() OVER (ORDER BY campaign.[status] DESC) AS statusRowDesc,
					ROW_NUMBER() OVER (ORDER BY campaign.campaign_rescheduled_date) AS scheduledDateRow, 
					ROW_NUMBER() OVER (ORDER BY campaign.campaign_rescheduled_date DESC) AS scheduledDateRowDesc,
					ROW_NUMBER() OVER (ORDER BY campaign_type.[name]) AS campaignNameRow, 
					ROW_NUMBER() OVER (ORDER BY campaign_type.[name] DESC) AS campaignNameRowDesc,
					campaign.campaign_id, campaign.site_id, campaign.campaign_type_id, campaign.[name], campaign.from_name, 
					campaign.from_email, campaign.[subject], campaign.[private], campaign.html_template_id, campaign.text_template_id, 
					campaign.[status], campaign.[enabled], campaign.created, campaign.modified, campaign.notified_status, 
					campaign.sent_email_reminder, campaign.provider_campaign_id, campaign.campaign_scheduled_date, 
					campaign.campaign_deployed_date, campaign.special_comments, campaign_rescheduled_date, recipients_capped
		FROM campaign
			INNER JOIN campaign_type
				ON campaign.campaign_type_id = campaign_type.campaign_type_id
		WHERE campaign.site_id = @siteId AND 
			(
				@campaignStatusList IS NULL 
				OR
				@campaignStatusList = ''
				OR 
				[status] IN 
				(
					SELECT [value] 
					FROM global_Split(@campaignStatusList, ',')
				)
			) 
			AND (@campaignId = 0 OR campaign.campaign_id = @campaignId) 
			AND (@campaignName = '' OR campaign.[name] like '%' + @campaignName + '%') 
			AND (@campaignTypeId IS NULL OR campaign.campaign_type_id = @campaignTypeId)
			AND YEAR(campaign.campaign_rescheduled_date) =
				CASE
					WHEN @campaignYear IS NULL 
						THEN YEAR(campaign.campaign_rescheduled_date) 
					ELSE 
						@campaignYear 
				END			
			AND (@isPrivate IS NULL OR campaign.[private] = @isPrivate)				

	)

	SELECT campaign_id as id, site_id, campaign_type_id, [name], from_name, from_email, 
				[subject], [private], html_template_id, text_template_id, [status], [enabled], created, modified, 
				notified_status, sent_email_reminder, provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, 
				special_comments, campaign_rescheduled_date, recipients_capped
	FROM temp_campaign
	WHERE (@sortBy = 'created' AND @sortOrder = 'asc' AND row BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'created' AND @sortOrder = 'desc' AND rowDesc BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'id' AND @sortOrder = 'asc' AND idRow BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'name' AND @sortOrder = 'asc' AND nameRow BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'name' AND @sortOrder = 'desc' AND nameRowDesc BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'status' AND @sortOrder = 'asc' AND statusRow BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'status' AND @sortOrder = 'desc' AND statusRowDesc BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'schedule' AND @sortOrder = 'asc' AND scheduledDateRow BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'schedule' AND @sortOrder = 'desc' AND scheduledDateRowDesc BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'campaignType' AND @sortOrder = 'asc' AND campaignNameRow BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'campaignType' AND @sortOrder = 'desc' AND campaignNameRowDesc BETWEEN @startIndex AND @endIndex)

		ORDER BY
			CASE 
				WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN row 
				WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN rowDesc
				WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedRow 
				WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedRowDesc
				WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idRow 
				WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idRowDesc
				WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameRow 
				WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameRowDesc
				WHEN @sortBy = 'status' AND @sortOrder = 'asc' THEN statusRow
				WHEN @sortBy = 'status' AND @sortOrder = 'desc' THEN statusRowDesc
				WHEN @sortBy = 'schedule' AND @sortOrder = 'asc' THEN scheduledDateRow
				WHEN @sortBy = 'schedule' AND @sortOrder = 'desc' THEN scheduledDateRowDesc
				WHEN @sortBy = 'campaignType' AND @sortOrder = 'asc' THEN campaignNameRow
				WHEN @sortBy = 'campaignType' AND @sortOrder = 'desc' THEN campaignNameRowDesc
			END	

	SELECT @totalCount = COUNT(*)
	FROM campaign
		INNER JOIN campaign_type
				ON campaign.campaign_type_id = campaign_type.campaign_type_id
	WHERE campaign.site_id = @siteId AND 
			(	@campaignStatusList IS NULL
				OR
				@campaignStatusList = ''
				OR 
				campaign.[status] IN 
				(
					SELECT [value] 
					FROM global_Split(@campaignStatusList, ',')
				)
			) 
		AND (@campaignId = 0 OR campaign.campaign_id = @campaignId) 
		AND (@campaignName = '' OR campaign.[name] like '%' + @campaignName + '%') 
		AND (@campaignTypeId IS NULL OR campaign.campaign_type_id = @campaignTypeId)
		AND YEAR(campaign.campaign_rescheduled_date) =
			CASE
				WHEN @campaignYear IS NULL 
					THEN YEAR(campaign.campaign_rescheduled_date) 
				ELSE 
					@campaignYear 
			END
		AND (@isPrivate IS NULL OR campaign.[private] = @isPrivate)			
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdNameStatusTypeIsPrivateList TO VpWebApp 
GO
------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList]
	@categoryId int,
	@vendorId int,
	@startRowIndex int,
	@endRowIndex int,
	@actionId int,
	@totalRowCount int output	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #TempProductList
	(
		id int NOT NULL,
		site_id int NOT NULL,
		product_name varchar(500) NOT NULL,
		row_id int NOT NULL,
		rank int NOT NULL,
		has_image bit NOT NULL,
		catalog_number varchar(255) NULL,
		enabled bit NOT NULL,
		modified smalldatetime NOT NULL,
		created smalldatetime NOT NULL,
		product_type int NOT NULL DEFAULT ((1)),
		status int NOT NULL DEFAULT ((0)),
		has_related bit NOT NULL,
		has_model bit NOT NULL,
		completeness int NOT NULL,
		flag1 bigint NOT NULL,
		flag2 bigint NOT NULL,
		flag3 bigint NOT NULL,
		flag4 bigint NOT NULL,
		search_rank int NOT NULL DEFAULT ((50)),
		search_content_modified bit,
		hidden bit,
		business_value int,
		ignore_in_rapid bit,
		show_in_matrix bit,
		show_detail_page bit

	)

	

	INSERT INTO #TempProductList
	
		SELECT DISTINCT p.product_id as id, p.site_id as site_id, p.product_name as product_name, ROW_NUMBER() OVER (ORDER BY v.rank DESC, product_Name) AS row_id
						, p.rank as rank 
						, p.has_image as has_image, p.catalog_number as catalog_number, p.enabled as enabled, p.modified as modified
						, p.created as created, p.product_type as product_type, p.status as status, p.has_related as has_related, p.has_model as has_model
						, p.completeness as completeness, p.flag1, p.flag2, p.flag3, p.flag4
						, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page

		FROM product p
		INNER JOIN product_to_vendor ptv
			ON p.product_id = ptv.product_id AND ptv.enabled = 1 AND ptv.is_manufacturer = 1 AND ptv.lead_enabled = 1
		INNER JOIN vendor v
			ON ptv.vendor_id = v.vendor_id AND v.enabled = 1
		INNER JOIN product_to_category ptc
			ON p.product_id = ptc.product_id AND ptc.enabled = 1
		LEFT OUTER JOIN vendor_parameter vpALL
			ON v.vendor_id = vpALL.vendor_id AND vpALL.parameter_type_id = 101
		LEFT OUTER JOIN vendor_parameter vpVENDOR
			ON v.vendor_id = vpVENDOR.vendor_id AND vpVENDOR.parameter_type_id = 47
		LEFT OUTER JOIN product_parameter vpPRODUCT
			ON p.product_id = vpPRODUCT.product_id AND vpPRODUCT.parameter_type_id = 104

		LEFT OUTER JOIN action_to_content atcp
			ON atcp.action_id = @actionId AND atcp.content_id = p.product_id AND atcp.content_type_id = 2
		LEFT OUTER JOIN action_to_content atcv
			ON atcv.action_id = @actionId AND atcv.content_id = ptv.vendor_id AND atcv.content_type_id = 6
		LEFT OUTER JOIN action_to_content atcc
			ON atcc.action_id = @actionId AND atcc.content_id = @categoryId AND atcc.content_type_id = 1
		LEFT OUTER JOIN action_to_content atcs
			ON atcs.action_id = @actionId AND atcs.content_id = p.site_id AND atcs.content_type_id = 5

		WHERE p.enabled = 1 AND ptc.category_id = @categoryId AND ptv.vendor_id <> @vendorId AND (COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) = 1 OR COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) IS NULL)
			  AND (vpVENDOR.vendor_parameter_value = 1 OR vpVENDOR.vendor_parameter_value IS NULL) AND (vpALL.vendor_parameter_value = 0 OR vpALL.vendor_parameter_value IS NULL)
			  AND (vpPRODUCT.product_parameter_value = 0 OR vpPRODUCT.product_parameter_value IS NULL)
		
		
		SELECT id, site_id, product_Name, [rank], has_image, catalog_number
			, [enabled], modified, created, product_type, status, has_related, has_model
			, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page

		FROM #TempProductList
		WHERE row_id BETWEEN @startRowIndex AND @endRowIndex
		ORDER BY row_id
		
		SELECT @totalRowCount = COUNT(*)
		FROM  #TempProductList

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList TO VpWebApp 
GO
-----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList
	@categoryId int,
	@manufacturerId int,
	@productId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH ProductList AS
	(
		SELECT product.product_id as id, product.site_id, product_Name, ROW_NUMBER() OVER (ORDER BY v.rank DESC, product_Name) AS row_id, product.[rank]
				, product.has_image, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page
		FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor ptv
					ON product.product_id = ptv.product_id AND ptv.enabled = '1' 
						AND ptv.is_manufacturer = 1
				INNER JOIN vendor v
					ON ptv.vendor_id = v.vendor_id 
		WHERE product_to_category.category_id = @categoryId AND ptv.vendor_id <> @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled],
		modified, created, product_type, status,has_related, has_model, 
		completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM ProductList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex
	ORDER BY row_id
	
	SELECT @totalRowCount = COUNT(*)
		FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id AND product_to_vendor.enabled = '1' 
						AND product_to_vendor.is_manufacturer = 1
		WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id <> @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList TO VpWebApp 
GO

-----------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildProductsByProductCompressionGroupIdCategoryIdSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetChildProductsByProductCompressionGroupIdCategoryIdSearchOptionIds
	@ParentProductId int,
	@productCompressionGroupId int,
	@searchOptionIds varchar(max),
	@categoryId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	
	SELECT DISTINCT product.product_id AS id, site_id, product.parent_product_id, product_name, [rank], has_image, catalog_number, product.enabled,
		product.modified, product.created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page, ignore_in_rapid
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id AND pp.enabled = 1
	INNER JOIN product_to_category ptc
		ON 	ptc.product_id = pp.product_id  AND ptc.enabled = 1
	INNER JOIN product_compression_group_to_product proGro
		ON pp.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		) AND 
		pp.parent_product_id = @ParentProductId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ','))) AND
		(@categoryId IS NULL OR ptc.category_id = @categoryId)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdCategoryIdSearchOptionIds TO VpWebApp 
GO
------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductToProductByProductIdCategoryList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductToProductByProductIdCategoryList
@productId int,
@categoryId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id as id, parent_product_id, ptp.product_id, ptp.enabled, ptp.created, ptp.modified
	FROM product_to_product	ptp
	INNER JOIN product_to_category ptc
		ON ptc.product_id = ptp.product_id AND ptc.enabled = 1
	WHERE ptp.parent_product_id = @productId AND
		(@categoryId IS NULL OR ptc.category_id = @categoryId)
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductToProductByProductIdCategoryList TO VpWebApp 
GO
---------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds'
----------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateSearchContentModifiedArticlesByProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateSearchContentModifiedArticlesByProduct
	@productId int,
	@batchSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	WITH article_search_content_modified(article_id, search_content_modified) AS
	(
		SELECT a.article_id, a.search_content_modified
		FROM article a
			INNER JOIN content_to_content cc
				ON a.article_id = cc.content_id AND cc.associated_content_type_id = 2 AND cc.associated_content_id = @productId
		WHERE a.search_content_modified = 0
	)
	
	UPDATE TOP(@batchSize) article_search_content_modified
	SET search_content_modified = 1
	
	SELECT @totalCount = COUNT(*)
	FROM article a
		INNER JOIN content_to_content cc
			ON a.article_id = cc.content_id AND cc.associated_content_type_id = 2 AND cc.associated_content_id = @productId
	WHERE a.search_content_modified = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateSearchContentModifiedArticlesByProduct TO VpWebApp 
GO
------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_GetTaskBySiteIdStartIndexEndIndexTaskTypeTaskNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_GetTaskBySiteIdStartIndexEndIndexTaskTypeTaskNameList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@taskTypeId int,
	@taskStatus  int,
	@taskName varchar(255),
	@totalCount int output
AS
-- ==========================================================================
-- $Author:  Tharaka Wanigasekera
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY task_id) AS row, task_id AS id, task_name, site_id, 
		last_run_time, [status], task_type, notification_emails, [enabled], modified, created
	INTO #temp_task
	FROM task
	WHERE  (@siteId IS NULL OR site_id = @siteId) AND (@taskTypeId IS NULL OR task_type = @taskTypeId) AND
			(@taskName = '' OR task_name LIKE '%' + @taskName + '%') 
			AND	(@taskStatus IS NULL OR @taskStatus = (SELECT top 1 status_code FROM task_history
				WHERE task_id=task.task_id
				ORDER BY start_time desc))

	SELECT id, task_name, site_id, last_run_time, [status], task_type, notification_emails, [enabled], 
		modified, created
	FROM #temp_task
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY created DESC

	SELECT @totalCount = COUNT(*)
	FROM #temp_task

END
GO

GRANT EXECUTE ON dbo.adminScheduler_GetTaskBySiteIdStartIndexEndIndexTaskTypeTaskNameList TO VpWebApp 
GO
-----------------------------------------------------------------------------