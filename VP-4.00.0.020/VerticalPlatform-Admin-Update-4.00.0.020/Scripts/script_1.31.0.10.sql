EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductToProductBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductToProductBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM product_to_product
	WHERE parent_product_id IN
		(SELECT product_id
		FROM product
		WHERE product.site_id = @siteId)

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductToProductBySiteIdList TO VpWebApp 
GO
------------------------------------------------------------------------
IF NOT EXISTS(SELECT module_name FROM dbo.module WHERE module_name = 'PasswordProtected')
BEGIN
	INSERT INTO dbo.module (module_name, usercontrol_name,enabled,is_container)
	VALUES ('PasswordProtected','~/Modules/Login/PasswordProtected.ascx',1,0)
END
GO
---------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlSettingByFixedUrlIdAndSettingKey'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlSettingByFixedUrlIdAndSettingKey
	@fixedUrlId int,
	@settingKey varchar(255)
AS
-- ==========================================================================
-- $Date: 2012-10-26
-- $Author: Sujith $
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_setting_id AS id, fixed_url_id, fixed_url_setting_key, fixed_url_setting_value, enabled, created, modified
	FROM fixed_url_setting
	WHERE fixed_url_id = @fixedUrlId AND fixed_url_setting_key = @settingKey

END
GO

GRANT EXECUTE ON publicPlatform_GetFixedUrlSettingByFixedUrlIdAndSettingKey TO VpWebApp
GO
-----------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList
	@categoryId int,
	@name varchar(500),
	@vendorIds varchar(max),
	@numberOfResults int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@numberOfResults) p.product_id AS id, p.site_id, p.parent_product_id  
		, p.product_name, p.rank  
		, p.has_image, p.catalog_number  
		, p.[enabled], p.modified, p.created, p.product_type, p.status  
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank  
		, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page  
	FROM product p  
		INNER JOIN product_to_category pc  
			ON pc.product_id = p.product_id  
		INNER JOIN product_to_vendor pv  
			ON pv.product_id = p.product_id  
	WHERE pc.category_id = @categoryId  
		AND pv.vendor_id IN (SELECT [value] FROM global_Split(@vendorIds, ','))  
		AND p.product_name LIKE (@name + '%')  

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList TO VpWebApp 
GO

---------
IF NOT EXISTS (SELECT content_type_id FROM content_type WHERE content_type_id = 34)
BEGIN
	INSERT INTO content_type
     VALUES (34 ,'VendorSettingsTemplateCurrency' ,1 ,getdate() ,getdate())
END
--------------------------------------------


IF NOT EXISTS(SELECT * FROM predefined_page WHERE page_name = 'PasswordProtected')
BEGIN
	INSERT INTO predefined_page(page_name, enabled, modified, created)
	VALUES('PasswordProtected', '1', GETDATE(), GETDATE())
	
	DECLARE @predefinedPageId int
	SET @predefinedPageId = (SELECT TOP 1 predefined_page_id FROM predefined_page WHERE page_name = 'PasswordProtected')

	DECLARE @moduleId int
	SET @moduleId = (SELECT TOP 1 module_id FROM module WHERE module_name = 'PasswordProtected')

	DECLARE @siteId int	

	DECLARE site_cursor CURSOR FOR
	SELECT site_id FROM site

	OPEN site_cursor

	FETCH NEXT FROM site_cursor
	INTO @siteId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO page (site_id, predefined_page_id, parent_page_id, page_name, page_title, keywords
			, template_name, sort_order, navigable, hidden, log_in_to_view, enabled, modified, created
			, page_title_prefix, page_title_suffix, description_prefix, description_suffix)
		VALUES (@siteId, @predefinedPageId, NULL, 'PasswordProtected', 'PasswordProtected', ''
			, '~/Templates/TwoColumnLayout/TwoColumnLayout.ascx', 25, '0', '1', '0', '1'
			, GETDATE(), GETDATE(), '', '', '', '')

		DECLARE @pageId int
		SELECT @pageId = page_id
		FROM page
		WHERE site_id = @siteId AND predefined_page_id = @predefinedPageId

		INSERT INTO module_instance (page_id, module_id, title,	pane, sort_order
			, enabled, modified, created, custom_css_class, site_id)
		VALUES (@pageId, @moduleId, 'PasswordProtected', 'contentPane', 1, '1', GETDATE(), GETDATE(), '', @siteId)

		DECLARE @moduleInstanceId int
		SELECT @moduleInstanceId = module_instance_id
		FROM module_instance
		WHERE site_id = @siteId AND page_id = @pageId AND module_id = @moduleId

		INSERT INTO module_instance_setting (module_instance_id, [name], [value], enabled, modified, created)
		VALUES (@moduleInstanceId, 'PasswordProtectedTitle', 'Please enter the password to view this content', '1', GETDATE(), GETDATE())
		
		INSERT INTO module_instance_setting (module_instance_id, [name], [value], enabled, modified, created)
		VALUES (@moduleInstanceId, 'PasswordProtectedMessage', 'Please enter a valid password!', '1', GETDATE(), GETDATE())

		--Formating page name
		DECLARE @formatedPageName varchar(255)
		EXEC dbo.global_FormatUrl 'PasswordProtected', @formatedPageName output

		--Creating site page url
		DECLARE @url varchar(255)
		SET @url = '/' + CONVERT(varchar(10), @pageId) + '-' + @formatedPageName + '/'

		INSERT INTO fixed_url (fixed_url, site_id, page_id, content_type_id, content_id
			, enabled, created, modified)
		VALUES (@url, @siteId, @pageId, 7, @pageId, '1', GETDATE(), GETDATE())


		FETCH NEXT FROM site_cursor
		INTO @siteId
	END

	CLOSE site_cursor
	DEALLOCATE site_cursor
END
-----------------------------------------------
GO




EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddCategorySearchGroup
	@id int output,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@enabled bit,	
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@includeAllOptions bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_to_search_group ([category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [enabled], [include_all_options], [modified], [created])
	VALUES (@categoryId, @searchGroupId, @sortOrder, @searchable,
		@matrixPrefix, @matrixSuffix, @enabled, @includeAllOptions, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchGroup TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProduct
	@id int, 
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank int,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE product 
	SET
		site_id = @siteId,
		product_name = @productName,
		rank = @rank,
		has_image = @hasImage,
		catalog_number = @catalogNumber,
		[enabled] = @enabled,
		modified = @modified,
		product_type = @productType,
		status = @status,
		has_related = @hasRelated,
		has_model = @hasModel,
		completeness = @completeness,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		search_rank = @searchRank,
		search_content_modified = @searchContentModified,
		hidden = @hidden,
		business_value = @businessValue,
		ignore_in_rapid = @ignoreInRapid,
		show_in_matrix = @showInMatrix,
		show_detail_page = @showDetailPage
	WHERE product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProduct TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionRedirectBySource'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionRedirectBySource
	@sourceOptionId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [search_option_redirect_id] AS id, source_option_id, destination_option_id, created, enabled, modified
	FROM search_option_redirect
	WHERE source_option_id = @sourceOptionId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionRedirectBySource TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteId
	@siteId int,
	@totalCount int output
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id as id, site_id, product_Name, rank
			, has_image, catalog_number, [enabled], modified, created, product_type, status
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM product 
	WHERE site_id = @siteId
	
	SELECT @totalCount = COUNT(*) FROM product WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteId TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductContributionCountByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductContributionCountByCategoryId
	@categoryId int
AS

-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	WITH cte(id, category_id, sub_category_id, product_id, enabled, modified, created) AS
	(
		SELECT category_product_count_contribution_id AS id, category_id, sub_category_id, product_id
			, enabled, modified, created
		FROM category_product_count_contribution
		WHERE category_id = @categoryId

		UNION ALL 

		SELECT c.category_product_count_contribution_id AS id, c.category_id, c.sub_category_id, c.product_id
			, c.enabled, c.modified, c.created
		FROM category_product_count_contribution c
			INNER JOIN cte
				ON c.category_id = cte.sub_category_id
	)

	SELECT COUNT(DISTINCT product_id) AS [count]
	FROM cte
	WHERE product_id IS NOT NULL
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductContributionCountByCategoryId TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdNameStatusTypeIsPrivateList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdNameStatusTypeIsPrivateList  
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
   AND (@campaignName = '' OR campaign.[name] like '%' + @campaignName + '%')   
   AND (@campaignTypeId IS NULL OR campaign.campaign_type_id = @campaignTypeId)  
   AND YEAR(campaign.campaign_scheduled_date) =  
    CASE  
     WHEN @campaignYear IS NULL   
      THEN YEAR(campaign.campaign_scheduled_date)   
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
   ( @campaignStatusList IS NULL  
    OR  
    @campaignStatusList = ''  
    OR   
    campaign.[status] IN   
    (  
     SELECT [value]   
     FROM global_Split(@campaignStatusList, ',')  
    )  
   )    
  AND (@campaignName = '' OR campaign.[name] like '%' + @campaignName + '%')   
  AND (@campaignTypeId IS NULL OR campaign.campaign_type_id = @campaignTypeId)  
  AND YEAR(campaign.campaign_scheduled_date) =  
   CASE  
    WHEN @campaignYear IS NULL   
     THEN YEAR(campaign.campaign_scheduled_date)   
    ELSE   
     @campaignYear   
   END  
  AND (@isPrivate IS NULL OR campaign.[private] = @isPrivate)     
END  
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdNameStatusTypeIsPrivateList TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductVendorDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductVendorDetail
	@id int
AS
-- ==========================================================================
-- Author: Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_vendor_id AS id, product_id, vendor_id, is_manufacturer
			, is_seller, show_get_quote, lead_enabled, [enabled], modified, created
	FROM product_to_vendor
	WHERE product_to_vendor_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductVendorDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionRedirectBySource'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionRedirectBySource
	@sourceOptionId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [search_option_redirect_id] AS id, source_option_id, destination_option_id, created, enabled, modified
	FROM search_option_redirect
	WHERE source_option_id = @sourceOptionId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionRedirectBySource TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionRedirectBySource'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionRedirectBySource
	@sourceOptionId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [search_option_redirect_id] AS id, source_option_id, destination_option_id, created, enabled, modified
	FROM search_option_redirect
	WHERE source_option_id = @sourceOptionId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionRedirectBySource TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionRedirectBySource'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionRedirectBySource
	@sourceOptionId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [search_option_redirect_id] AS id, source_option_id, destination_option_id, created, enabled, modified
	FROM search_option_redirect
	WHERE source_option_id = @sourceOptionId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionRedirectBySource TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddSearchOptionRedirect'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddSearchOptionRedirect  
 @id int output,  
 @sourceOptionId int,  
 @destinationOptionId int,  
 @enabled bit,   
 @created smalldatetime output  
AS  
-- ==========================================================================  
-- $Author: Dilshan $  
-- ==========================================================================  
BEGIN  
   
 SET NOCOUNT ON;  
  
 SET @created = GETDATE()   
  
 INSERT INTO search_option_redirect (source_option_id,  destination_option_id, enabled, modified, created)  
 VALUES (@sourceOptionId, @destinationOptionId, @enabled, @created, @created)   
  
 SET @id = SCOPE_IDENTITY()  
  
END 

GO 

GRANT EXECUTE ON dbo.adminSearchCategory_AddSearchOptionRedirect TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsToIndexInSearchProviderList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsToIndexInSearchProviderList
	@siteId int,
	@batchSize int,
	@totalCount int output
	
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1
	ORDER BY product_id
	
	SELECT @totalCount = COUNT(*)
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1
	
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsToIndexInSearchProviderList TO VpWebApp 
GO

