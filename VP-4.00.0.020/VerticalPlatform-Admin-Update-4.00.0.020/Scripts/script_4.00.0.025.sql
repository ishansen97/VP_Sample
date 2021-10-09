

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[campaign]') 
         AND name = 'preheader_text'
)
BEGIN

ALTER TABLE [dbo].[campaign]
ADD [preheader_text] varchar(500) NULL

END
GO


------------------adminBulkEmail_GetCampaignDetail-------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminBulkEmail_GetCampaignDetail]
	@id int
AS
-- ==========================================================================
-- $Author: deshapriya $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT campaign_id as id, site_id, campaign_type_id, [name], from_name, from_email, [subject], preheader_text, [private]
		, html_template_id, text_template_id, [status], [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id
		, campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped
		, locked, locked_timestamp, error_state
FROM campaign
	WHERE campaign_id = @id

END
GO

GRANT EXECUTE ON [dbo].[adminBulkEmail_GetCampaignDetail] TO [VpPublicWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_GetCampaignDetail] TO [VpAdminWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_GetCampaignDetail] TO [VpWindowsService] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_GetCampaignDetail] TO [VpTest] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_GetCampaignDetail] TO [VpAdminWeb] AS [dbo]




------------------adminBulkEmail_AddCampaign-------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_AddCampaign'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminBulkEmail_AddCampaign]
	@siteId int,
	@campaignTypeId int,
	@name varchar(255),
	@fromName varchar(255),
	@fromEmail varchar(255),
	@subject varchar(255),
	@preheaderText varchar(500),
	@private bit,
	@htmlTemplateId int,
	@textTemplateId int,
	@status int,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@notifiedStatus int,
	@sentEmailReminder bit,
	@providerCampaignId varchar(200),
	@campaignScheduledDate smalldatetime,
	@campaignDeployedDate smalldatetime,
	@specialComments varchar(255),
	@campaignReScheduledDate smalldatetime,
	@recipientsCapped int,
	@locked bit,
	@lockedTimestamp smalldatetime,
	@errorState bit
	
AS
-- ==========================================================================
-- $Author: deshapriya $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO campaign(site_id, campaign_type_id, [name], from_name, from_email, [subject], preheader_text, [private]
		, html_template_id, text_template_id, [status], [enabled], created, modified, notified_status, sent_email_reminder,provider_campaign_id
		, campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped
		, locked, locked_timestamp, error_state)
	VALUES (@siteId, @campaignTypeId, @name, @fromName, @fromEmail, @subject, @preheaderText, @private, @htmlTemplateId, @textTemplateId,
		@status, @enabled, @created, @created, @notifiedStatus, @sentEmailReminder, @providerCampaignId, @campaignScheduledDate,
		@campaignDeployedDate, @specialComments, @campaignRescheduledDate, @recipientsCapped, @locked, @lockedTimestamp, @errorState)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON [dbo].[adminBulkEmail_AddCampaign] TO [VpAdminWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_AddCampaign] TO [VpWindowsService] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_AddCampaign] TO [VpTest] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_AddCampaign] TO [VpAdminWeb] AS [dbo]




------------------adminBulkEmail_UpdateCampaign-------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_UpdateCampaign'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminBulkEmail_UpdateCampaign]
	@id int,
	@siteId int,
	@campaignTypeId int,
	@name varchar(255),
	@fromName varchar(255),
	@fromEmail varchar(255),
	@subject varchar(255),
	@preheaderText varchar(500),
	@private bit,
	@htmlTemplateId int,
	@textTemplateId int,
	@status int,
	@enabled bit,
	@modified smalldatetime output,
	@notifiedStatus int,
	@sentEmailReminder bit,
	@providerCampaignId varchar(200),
	@campaignScheduledDate smalldatetime,
	@campaignDeployedDate smalldatetime,
	@specialComments varchar(255),
	@campaignRescheduledDate smalldatetime,
	@recipientsCapped int,
	@locked bit,
	@lockedTimestamp smalldatetime,
	@errorState bit
	
AS
-- ==========================================================================
-- $Author: naveen
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE campaign
	SET
		site_id = @siteId,
		campaign_type_id = @campaignTypeId,
		[name] = @name,
		from_name = @fromName,
		from_email = @fromEmail,
		[subject] = @subject,
		preheader_text = @preheaderText,
		[private] = @private,
		html_template_id = @htmlTemplateId,
		text_template_id = @textTemplateId,
		[status] = @status,
		[enabled] = @enabled,
		modified = @modified,
		notified_status = @notifiedStatus,
		sent_email_reminder = @sentEmailReminder,
		provider_campaign_id = @providerCampaignId,
		campaign_scheduled_date = @campaignScheduledDate,
		campaign_deployed_date = @campaignDeployedDate,
		special_comments = @specialComments,
		campaign_rescheduled_date = @campaignRescheduledDate,
		recipients_capped = @recipientsCapped,
		locked = @locked,
		locked_timestamp = @lockedTimestamp,
		error_state = @errorState
	WHERE campaign_id = @id
 
END
GO

GRANT EXECUTE ON [dbo].[adminBulkEmail_UpdateCampaign] TO [VpAdminWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_UpdateCampaign] TO [VpWindowsService] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_UpdateCampaign] TO [VpTest] AS [dbo]

GRANT EXECUTE ON [dbo].[adminBulkEmail_UpdateCampaign] TO [VpAdminWeb] AS [dbo]

-- ==================================================================================================================================================
Go
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorProductCountDetail'
/****** Object:  StoredProcedure [dbo].[adminProduct_GetVendorProductCountDetail]    Script Date: 7/20/2021 1:02:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetVendorProductCountDetail]
	@vendorId int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET ARITHABORT ON;
	
	SELECT vendor_id, [1] minimized, [2] standard, [3] featured, [4] featured_plus, [0] [none]
	, (
		SELECT COUNT(DISTINCT p.product_id)
			FROM product_to_vendor pv WITH(NOLOCK)
				INNER JOIN product p WITH(NOLOCK)
					ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId
				AND p.enabled = 1
		) lpc
	FROM
	(
		SELECT vendor_id, product.product_id, product.rank
		FROM product_to_vendor WITH(NOLOCK)
			INNER JOIN product WITH(NOLOCK)
				ON product_to_vendor.product_id = product.product_id
		WHERE vendor_id = @vendorId
	) p
	PIVOT
	(
		COUNT(product_id) FOR rank IN ([1], [2], [3], [4], [0])
	) pvt

END
GO

GRANT EXECUTE ON [dbo].[adminProduct_GetVendorProductCountDetail] TO [VpAdminWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminProduct_GetVendorProductCountDetail] TO [VpTest] AS [dbo]

GRANT EXECUTE ON [dbo].[adminProduct_GetVendorProductCountDetail] TO [VpAdminWeb] AS [dbo]

GO

-- ==============================adminProduct_IsEnabledProductsAvailable===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_IsEnabledProductsAvailable'
/****** Object:  StoredProcedure [dbo].[adminProduct_IsEnabledProductsAvailable]    Script Date: 7/20/2021 1:02:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_IsEnabledProductsAvailable]
	@leafCategoryId int,
	@boolean_val int output  
AS
-- ==========================================================================
-- $URL$
-- $Revision$
-- $Date$ 
-- $Author$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF (EXISTS (SELECT TOP(1) pro.product_id 
				FROM product pro
					INNER JOIN product_to_category proCat
						ON pro.product_id = proCat.product_id
				WHERE proCat.category_id = @leafCategoryId AND pro.enabled = '1' AND proCat.enabled = '1'))
		BEGIN
			SELECT @boolean_val = 1
		END
	ELSE
		BEGIN
			SELECT @boolean_val = 0
		END	


		
END
GO

GRANT EXECUTE ON [dbo].[adminProduct_IsEnabledProductsAvailable] TO [VpAdminWeb] AS [dbo]

GRANT EXECUTE ON [dbo].[adminProduct_IsEnabledProductsAvailable] TO [VpTest] AS [dbo]

GRANT EXECUTE ON [dbo].[adminProduct_IsEnabledProductsAvailable] TO VpWindowsService AS [dbo]

GO

-- ==============================================================================================================================================================
