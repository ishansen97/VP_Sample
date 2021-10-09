IF NOT EXISTS(SELECT * FROM sys.columns WHERE name = N'deleted' AND Object_ID = Object_ID(N'campaign'))
BEGIN
    ALTER TABLE campaign
	ADD deleted bit NOT NULL
	CONSTRAINT deleted_default DEFAULT 0 WITH VALUES
END

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicBulkEmail_GetCampaignRecipientsForCampaignsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicBulkEmail_GetCampaignRecipientsForCampaignsList
	@campaignStatus int,
	@siteId int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT campaign_recipient_id AS id, campaign_id, site_id, email, recipient_name, status, [enabled], created, modified
	FROM  campaign_recipient
	WHERE email IN
	(
		SELECT email 
		FROM campaign_recipient cr
		INNER JOIN campaign c
			ON cr.campaign_id = c.campaign_id
		WHERE c.status = @campaignStatus AND c.site_id = @siteId
	)
	AND campaign_id IN
	(
		SELECT campaign_id
		FROM campaign 
		WHERE site_id = @siteId
		AND deleted = 0
	)

END
GO

GRANT EXECUTE ON dbo.publicBulkEmail_GetCampaignRecipientsForCampaignsList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicBulkEmail_GetCampaignBySiteIdStatusAndBulkEmailTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicBulkEmail_GetCampaignBySiteIdStatusAndBulkEmailTypeList
	@siteId int,
	@statusId int,
	@bulkEmailTypeId int,
	@isPrivate bit
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;
 
SELECT campaign_id  as id, c.site_id, c.campaign_type_id , c.[name], c.from_name, c.from_email,
			c.subject, private ,html_template_id ,status, c.enabled, c.created, c.modified,
			notified_status, sent_email_reminder, provider_campaign_id,campaign_scheduled_date,
			campaign_deployed_date, special_comments, text_template_id, campaign_rescheduled_date, c.recipients_capped,
			c.locked, c.locked_timestamp, c.error_state
FROM campaign c
	JOIN campaign_type ct
		ON c.campaign_type_id = ct.campaign_type_id
	JOIN bulk_email_type bt 
		ON ct.bulk_email_type_id = bt.bulk_email_type_id
WHERE bt.site_id = @siteId 
	AND c.status = @statusId
	AND c.private = @isPrivate 
	AND bt.bulk_email_type_id = @bulkEmailTypeId
	AND c.deleted = 0

END
GO

GRANT EXECUTE ON dbo.publicBulkEmail_GetCampaignBySiteIdStatusAndBulkEmailTypeList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetFilteredVendorRelatedCampaignsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetFilteredVendorRelatedCampaignsList
	@siteId int,	
	@vendorId int,
	@pageSize int,
	@pageIndex int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	CREATE TABLE #TempAssociatedContentList
	(
		contentId int,
		content_type_id int,
		siteId int
	)
	
	BEGIN
		INSERT INTO #TempAssociatedContentList
			SELECT DISTINCT content_id, content_type_id, @siteId
			FROM content_to_content
			WHERE associated_content_id = @vendorId AND content_type_id IN (2, 4) AND associated_content_type_id = 6
				AND site_id = @siteId AND associated_site_id = @siteId AND enabled = 1
	END

	BEGIN
		INSERT INTO #TempAssociatedContentList
			SELECT DISTINCT product_id, 2, @siteId
			FROM product_to_vendor
			WHERE vendor_id = @vendorId AND enabled = 1
	END
	
	CREATE TABLE #TempCampaigns
	(
		id int,
		[site_id] int,
		[campaign_type_id] int,
		[name] varchar(255),
		[from_name] varchar(255),
		[from_email] varchar(255),
		[subject] varchar(255),
		[private] bit,
		[html_template_id] int,		
		[text_template_id] int,
		[status] int,
		[enabled] bit,
		[created] smalldatetime,
		[modified] smalldatetime,
		[notified_status] int,
		[sent_email_reminder] bit,
		[provider_campaign_id] varchar(200),
		[campaign_scheduled_date] smalldatetime,
		[campaign_deployed_date] smalldatetime,
		[special_comments] varchar(255),
		[campaign_rescheduled_date] smalldatetime,
		[recipients_capped] int,
		[locked] bit,
		[locked_timestamp] smalldatetime,
		[error_state] bit
	)
	
	BEGIN
			INSERT INTO #TempCampaigns
		
				SELECT Distinct (c.campaign_id) AS id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
					   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
					   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
					   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
					   locked, locked_timestamp, error_state
				FROM campaign c
					INNER JOIN #TempAssociatedContentList t
						ON t.siteId = c.site_id
					INNER JOIN campaign_content_data ccd
						ON ccd.content_id = t.contentId
				WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1	
					AND (@startDate IS NULL OR c.campaign_rescheduled_date between @startDate AND DATEADD(day, 1,@endDate)) AND c.deleted = 0
			
			UNION
				SELECT Distinct (c.campaign_id) AS id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
					   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
					   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
					   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
					   locked, locked_timestamp, error_state
				FROM campaign c
					INNER JOIN content_to_content cc 
						ON c.campaign_id = cc.content_id AND cc.content_type_id = 18  
				WHERE cc.associated_content_id = @vendorId 
						AND cc.associated_content_type_id = 6 
						AND c.site_id = @siteId 		
						AND (@startDate IS NULL OR c.campaign_rescheduled_date between @startDate AND DATEADD(day, 1,@endDate))
						AND c.deleted = 0
			 
		END
		
		BEGIN
			WITH CampaignList AS
			(	
				SELECT Distinct id, site_id, campaign_type_id, [name], from_name, 
						   from_email, [subject], [private], html_template_id, text_template_id, [status],
						   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
						   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date,
						   ROW_NUMBER() OVER (ORDER BY campaign_rescheduled_date DESC) AS row_id, recipients_capped,
						   locked, locked_timestamp, error_state
				FROM #TempCampaigns
			)
			
			SELECT Distinct id, site_id, campaign_type_id, [name], from_name, 
				   from_email, [subject], [private], html_template_id, text_template_id, [status],
				   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
				   locked, locked_timestamp, error_state
			FROM CampaignList
			WHERE row_id BETWEEN @startIndex AND @endIndex
			ORDER BY campaign_rescheduled_date DESC

		END
		
		SELECT @totalCount = COUNT(*)
		FROM #TempCampaigns
	
END
GO

GRANT EXECUTE ON dbo.adminVendor_GetFilteredVendorRelatedCampaignsList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetCampaignWithVendorAssociatedContentsBySiteIdVendorIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetCampaignWithVendorAssociatedContentsBySiteIdVendorIdList
	@siteId int,	
	@vendorId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	CREATE TABLE #TempAssociatedContentList
	(
		contentId int,
		content_type_id int,
		siteId int
	)
	
	BEGIN
		INSERT INTO #TempAssociatedContentList
			SELECT DISTINCT content_id, content_type_id, @siteId
			FROM content_to_content
			WHERE associated_content_id = @vendorId AND content_type_id IN (2, 4) AND associated_content_type_id = 6
				AND site_id = @siteId AND associated_site_id = @siteId AND enabled = 1
	END

	BEGIN
		INSERT INTO #TempAssociatedContentList
			SELECT DISTINCT product_id, 2, @siteId
			FROM product_to_vendor
			WHERE vendor_id = @vendorId AND enabled = 1
	END
	
	CREATE TABLE #TempCampaigns
	(
		id int,
		[site_id] int,
		[campaign_type_id] int,
		[name] varchar(255),
		[from_name] varchar(255),
		[from_email] varchar(255),
		[subject] varchar(255),
		[private] bit,
		[html_template_id] int,		
		[text_template_id] int,
		[status] int,
		[enabled] bit,
		[created] smalldatetime,
		[modified] smalldatetime,
		[notified_status] int,
		[sent_email_reminder] bit,
		[provider_campaign_id] varchar(200),
		[campaign_scheduled_date] smalldatetime,
		[campaign_deployed_date] smalldatetime,
		[special_comments] varchar(255),
		[campaign_rescheduled_date] smalldatetime,
		[recipients_capped] int,
		[locked] bit,
		[locked_timestamp] smalldatetime,
		[error_state] bit
	)	
		
	INSERT INTO #TempCampaigns
		SELECT Distinct (c.campaign_id) AS id, c.site_id, c.campaign_type_id, 
			   c.[name], c.from_name, c.from_email, c.[subject], [private], html_template_id, text_template_id, 
			   [status], c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, 
			   provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, special_comments, 
			   campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state
		FROM campaign c
			INNER JOIN #TempAssociatedContentList t
				ON t.siteId = @siteId
			INNER JOIN campaign_content_data ccd
				ON ccd.content_id = t.contentId
		WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1  AND c.deleted = 0
	
	
	BEGIN
	
		WITH CampaignList AS
		(
			SELECT Distinct id, site_id, campaign_type_id, [name], from_name, 
						   from_email, [subject], [private], html_template_id, text_template_id, [status],
						   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
						   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date,
						   ROW_NUMBER() OVER (ORDER BY campaign_rescheduled_date DESC) AS row_id, recipients_capped, locked, locked_timestamp, error_state		
				FROM #TempCampaigns
		)
		
		SELECT Distinct id, site_id, campaign_type_id, [name], from_name, 
			   from_email, [subject], [private], html_template_id, text_template_id, [status],
			   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
			   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state
		FROM CampaignList
		WHERE row_id BETWEEN @startIndex AND @endIndex
		
	END
	BEGIN
		WITH CountCampaignList AS
		(
				SELECT Distinct (c.campaign_id)
				FROM campaign c
					INNER JOIN #TempAssociatedContentList tl
						ON tl.siteId = @siteId
					INNER JOIN campaign_content_data ccd
						ON ccd.content_id = tl.contentId
				WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0
		)
		
		SELECT @totalCount = COUNT(*)
		FROM #TempCampaigns

	END
	
END
GO

GRANT EXECUTE ON dbo.adminVendor_GetCampaignWithVendorAssociatedContentsBySiteIdVendorIdList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetCampaignsVendorSpecificByVendorIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetCampaignsVendorSpecificByVendorIdList
	@siteId int,	
	@vendorId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	CREATE TABLE #TempAssociatedContentList
	(
		contentId int,
		content_type_id int,
		siteId int
	)
	
	BEGIN
		WITH CampaignList AS
		(
			SELECT Distinct (c.campaign_id) AS id, ROW_NUMBER() OVER (ORDER BY c.campaign_id) AS row_id, c.site_id, c.campaign_type_id, 
				   c.[name], c.from_name, c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
				   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, c.recipients_capped,
				   locked, locked_timestamp, error_state
			FROM campaign c
				INNER JOIN content_to_content cc 
					ON c.campaign_id = cc.content_id AND cc.content_type_id = 18
			WHERE cc.associated_content_id = @vendorId 
					AND cc.associated_content_type_id = 6 
					AND c.site_id = @siteId
					AND c.deleted = 0
		)
		
		SELECT Distinct id, site_id, campaign_type_id, [name], from_name, 
			   from_email, [subject], [private], html_template_id, text_template_id, [status],
			   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
			   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
			   locked, locked_timestamp, error_state
		FROM CampaignList
		WHERE row_id BETWEEN @startIndex AND @endIndex
	END
	BEGIN
		WITH CountCampaignList AS
		(
				SELECT Distinct (c.campaign_id)
				FROM campaign c
				INNER JOIN content_to_content cc 
					ON c.campaign_id = cc.content_id AND cc.content_type_id = 18
				WHERE cc.associated_content_id = @vendorId 
					AND cc.associated_content_type_id = 6 
					AND c.site_id = @siteId
					AND c.deleted = 0
		)
		SELECT @totalCount = COUNT(*)
		FROM CountCampaignList

	END
	
END
GO

GRANT EXECUTE ON dbo.adminVendor_GetCampaignsVendorSpecificByVendorIdList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetCampaignOrderByScheduledDateList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetCampaignOrderByScheduledDateList
	@siteId int,	
	@vendorId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	CREATE TABLE #TempAssociatedContentList
	(
		contentId int,
		content_type_id int,
		siteId int
	)
	
	BEGIN
		INSERT INTO #TempAssociatedContentList
			SELECT DISTINCT content_id, content_type_id, @siteId
			FROM content_to_content
			WHERE associated_content_id = @vendorId AND content_type_id IN (2, 4) AND associated_content_type_id = 6
				AND site_id = @siteId AND associated_site_id = @siteId AND enabled = 1
	END

	BEGIN
		INSERT INTO #TempAssociatedContentList
			SELECT DISTINCT product_id, 2, @siteId
			FROM product_to_vendor
			WHERE vendor_id = @vendorId AND enabled = 1
	END
	
	CREATE TABLE #TempCampaigns
	(
		id int,
		[site_id] int,
		[campaign_type_id] int,
		[name] varchar(255),
		[from_name] varchar(255),
		[from_email] varchar(255),
		[subject] varchar(255),
		[private] bit,
		[html_template_id] int,		
		[text_template_id] int,
		[status] int,
		[enabled] bit,
		[created] smalldatetime,
		[modified] smalldatetime,
		[notified_status] int,
		[sent_email_reminder] bit,
		[provider_campaign_id] varchar(200),
		[campaign_scheduled_date] smalldatetime,
		[campaign_deployed_date] smalldatetime,
		[special_comments] varchar(255),
		[campaign_rescheduled_date] smalldatetime,
		[recipients_capped] int,
		[locked] bit,
		[locked_timestamp] smalldatetime,
		[error_state] bit
	)
	
	
		BEGIN
			INSERT INTO #TempCampaigns
		
				SELECT Distinct (c.campaign_id) AS id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
					   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
					   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
					   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
					   locked, locked_timestamp, error_state
				FROM campaign c
					INNER JOIN #TempAssociatedContentList t
						ON t.siteId = c.site_id
					INNER JOIN campaign_content_data ccd
						ON ccd.content_id = t.contentId
				WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0			
			
			UNION
				SELECT Distinct (c.campaign_id) AS id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
					   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
					   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
					   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
					   locked, locked_timestamp, error_state
				FROM campaign c
					INNER JOIN content_to_content cc 
						ON c.campaign_id = cc.content_id AND cc.content_type_id = 18  
				WHERE cc.associated_content_id = @vendorId 
						AND cc.associated_content_type_id = 6 
						AND c.site_id = @siteId
						AND c.deleted = 0
			 
		END
		
		BEGIN
			WITH CampaignList AS
			(	
				SELECT Distinct id, site_id, campaign_type_id, [name], from_name, 
						   from_email, [subject], [private], html_template_id, text_template_id, [status],
						   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
						   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date,
						   ROW_NUMBER() OVER (ORDER BY campaign_rescheduled_date DESC) AS row_id, recipients_capped,
						   locked, locked_timestamp, error_state
				FROM #TempCampaigns
			)
			
			SELECT Distinct id, site_id, campaign_type_id, [name], from_name, 
				   from_email, [subject], [private], html_template_id, text_template_id, [status],
				   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
				   locked, locked_timestamp, error_state
			FROM CampaignList
			WHERE row_id BETWEEN @startIndex AND @endIndex
			ORDER BY campaign_rescheduled_date DESC

		END
					
		SELECT @totalCount = COUNT(*)
		FROM #TempCampaigns
				
END
GO

GRANT EXECUTE ON dbo.adminVendor_GetCampaignOrderByScheduledDateList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCampaignsBySiteIdCampaignTypeLikeCampaignName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCampaignsBySiteIdCampaignTypeLikeCampaignName
	@siteId int,
	@value varchar(max),
	@isEnabled bit,
	@campaignTypeId int,
	@selectLimit int
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;


		SELECT TOP (@selectLimit) campaign.campaign_id AS id, campaign.site_id, campaign.campaign_type_id, campaign.[name], campaign.from_name, 
				campaign.from_email, campaign.[subject], campaign.[private], campaign.html_template_id, campaign.text_template_id, 
				campaign.[status], campaign.[enabled], campaign.created, campaign.modified, campaign.notified_status, 
				campaign.sent_email_reminder, campaign.provider_campaign_id, campaign.campaign_scheduled_date, 
				campaign.campaign_deployed_date, campaign.special_comments, campaign_rescheduled_date, recipients_capped,
				locked, locked_timestamp, error_state
		FROM campaign
		WHERE site_id = @siteId AND campaign.[name] like @value+'%' AND (@isEnabled IS NULL OR campaign.enabled = @isEnabled)
			AND (@campaignTypeId IS NULL OR campaign.campaign_type_id = @campaignTypeId) AND deleted = 0

END
GO

GRANT EXECUTE ON adminProduct_GetCampaignsBySiteIdCampaignTypeLikeCampaignName TO VpWebApp
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignStatisticsPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignStatisticsPageList
	@siteId int,
	@campaignTypeId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalCount int output,
	@sortBy varchar(14),
	@sortOrder varchar(5)
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_campaign_stats(row, nameRow, typeRow, deployDateRow, totalRow, bounceRow, openRow, clickRow, unsubscribeRow,
		rowDesc, nameRowDesc, typeRowDesc, deployDateRowDesc, totalRowDesc, bounceRowDesc, openRowDesc, clickRowDesc, unsubscribeRowDesc,
		campaign_id, site_id, campaign_type_id, hard_bounces, soft_bounces, unsubscribes, forwards, forwards_opens, 
		opens, clicks, unique_clicks, emails_sent, enabled, created, modified) 
	AS
	
	(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY c.campaign_id) AS row, 
			ROW_NUMBER() OVER (ORDER BY c.[name]) AS nameRow, 
			ROW_NUMBER() OVER (ORDER BY ct.[name]) AS typeRow, 
			ROW_NUMBER() OVER (ORDER BY c.campaign_rescheduled_date) AS deployDateRow, 
			ROW_NUMBER() OVER (ORDER BY cs.emails_sent) AS totalRow,
			ROW_NUMBER() OVER (ORDER BY (cs.soft_bounces+cs.hard_bounces)*100/cs.emails_sent) AS bounceRow,
			ROW_NUMBER() OVER (ORDER BY cs.opens*100/cs.emails_sent) AS openRow,
			ROW_NUMBER() OVER (ORDER BY CASE WHEN cs.opens > 0 THEN cs.clicks*100/cs.opens ELSE 0 END) AS clickRow,
			ROW_NUMBER() OVER (ORDER BY CASE WHEN cs.opens > 0 THEN cs.unsubscribes*100/cs.opens ELSE 0 END) AS unsubscribeRow,
			ROW_NUMBER() OVER (ORDER BY c.campaign_id DESC) AS rowDesc, 
			ROW_NUMBER() OVER (ORDER BY c.[name] DESC) AS nameRowDesc, 
			ROW_NUMBER() OVER (ORDER BY ct.[name] DESC) AS typeRowDesc,
			ROW_NUMBER() OVER (ORDER BY c.campaign_rescheduled_date DESC) AS deployDateRowDesc, 
			ROW_NUMBER() OVER (ORDER BY cs.emails_sent DESC) AS totalRowDesc,
			ROW_NUMBER() OVER (ORDER BY (cs.soft_bounces+cs.hard_bounces)*100/cs.emails_sent DESC) AS bounceRowDesc,
			ROW_NUMBER() OVER (ORDER BY cs.opens*100/cs.emails_sent DESC) AS openRowDesc,
			ROW_NUMBER() OVER (ORDER BY CASE WHEN cs.opens > 0 THEN cs.clicks*100/cs.opens ELSE 0 END DESC) AS clickRowDesc,
			ROW_NUMBER() OVER (ORDER BY CASE WHEN cs.opens > 0 THEN cs.unsubscribes*100/cs.opens ELSE 0 END DESC) AS unsubscribeRowDesc,
			c.campaign_id AS campaign_id, c.site_id AS site_id, c.campaign_type_id AS campaign_type_id,
			hard_bounces, soft_bounces, unsubscribes, forwards, forwards_opens, 
			opens, clicks, unique_clicks, emails_sent, c.[enabled] AS enabled, c.created AS created, c.modified AS modified
		FROM campaign c
			JOIN campaign_statistic cs
				ON cs.campaign_id = c.campaign_id
			JOIN campaign_type ct
				ON c.campaign_type_id = ct.campaign_type_id
		WHERE c.site_id = @siteId AND (@campaignTypeId IS NULL OR c.campaign_type_id = @campaignTypeId) AND cs.emails_sent > 0 AND c.deleted = 0
	)

	SELECT campaign_id AS id, site_id, campaign_id, hard_bounces, soft_bounces, unsubscribes, forwards, 
		forwards_opens, opens, clicks, unique_clicks, emails_sent, enabled, created, modified
	FROM temp_campaign_stats
	WHERE (@sortBy = 'id' AND @sortOrder = 'asc' AND row BETWEEN @startRowIndex AND @endRowIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'asc' AND nameRow BETWEEN @startRowIndex AND @endRowIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'asc' AND typeRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'deploy' AND @sortOrder = 'asc' AND deployDateRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'total' AND @sortOrder = 'asc' AND totalRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'bounces' AND @sortOrder = 'asc' AND bounceRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'opens' AND @sortOrder = 'asc' AND openRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'clicks' AND @sortOrder = 'asc' AND clickRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'unsubscribes' AND @sortOrder = 'asc' AND unsubscribeRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'id' AND @sortOrder = 'desc' AND rowDesc BETWEEN @startRowIndex AND @endRowIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'desc' AND nameRowDesc BETWEEN @startRowIndex AND @endRowIndex)OR 
		(@sortBy = 'type' AND @sortOrder = 'desc' AND typeRowDesc BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'deploy' AND @sortOrder = 'desc' AND deployDateRowDesc BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'total' AND @sortOrder = 'desc' AND totalRowDesc BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'bounces' AND @sortOrder = 'desc' AND bounceRowDesc BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'opens' AND @sortOrder = 'desc' AND openRowDesc BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'clicks' AND @sortOrder = 'desc' AND clickRowDesc BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'unsubscribes' AND @sortOrder = 'desc' AND unsubscribeRowDesc BETWEEN @startRowIndex AND @endRowIndex)
	ORDER BY
		CASE 
			WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN row 
			WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameRow 
			WHEN @sortBy = 'type' AND @sortOrder = 'asc' THEN typeRow
			WHEN @sortBy = 'deploy' AND @sortOrder = 'asc' THEN deployDateRow
			WHEN @sortBy = 'total' AND @sortOrder = 'asc' THEN totalRow
			WHEN @sortBy = 'bounces' AND @sortOrder = 'asc' THEN bounceRow
			WHEN @sortBy = 'opens' AND @sortOrder = 'asc' THEN openRow
			WHEN @sortBy = 'clicks' AND @sortOrder = 'asc' THEN clickRow
			WHEN @sortBy = 'unsubscribes' AND @sortOrder = 'asc' THEN unsubscribeRow
			WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN rowDesc
			WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameRowDesc
			WHEN @sortBy = 'type' AND @sortOrder = 'desc' THEN typeRowDesc
			WHEN @sortBy = 'deploy' AND @sortOrder = 'desc' THEN deployDateRowDesc
			WHEN @sortBy = 'total' AND @sortOrder = 'desc' THEN totalRowDesc
			WHEN @sortBy = 'bounces' AND @sortOrder = 'desc' THEN bounceRowDesc
			WHEN @sortBy = 'opens' AND @sortOrder = 'desc' THEN openRowDesc
			WHEN @sortBy = 'clicks' AND @sortOrder = 'desc' THEN clickRowDesc
			WHEN @sortBy = 'unsubscribes' AND @sortOrder = 'desc' THEN unsubscribeRowDesc
		END

	SELECT @totalCount = COUNT(*)
	FROM campaign c
		JOIN campaign_statistic cs
			ON cs.campaign_id = c.campaign_id
		JOIN campaign_type ct
			ON c.campaign_type_id = ct.campaign_type_id
	WHERE c.site_id = @siteId AND (@campaignTypeId IS NULL OR c.campaign_type_id = @campaignTypeId) AND cs.emails_sent > 0  AND c.deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignStatisticsPageList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignsByBulkEmailTypeUserIdPagingAndSortingFilteringParametersList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignsByBulkEmailTypeUserIdPagingAndSortingFilteringParametersList
	@bulkEmailTypeIds varchar(200),
	@sortBy int,
	@sortOrder int,
	@isUserSpecific bit,
	@startRowIndex int,
	@endRowIndex int,
	@userId int,
	@campaignTypeId int,
	@startDate varchar(20),
	@endDate varchar(20),
	@campaignName NVARCHAR(MAX),
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Sahan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @email varchar(500);
	SELECT @email = email FROM public_user WHERE public_user_id = @userId

	IF(@startDate = '')
	BEGIN
		SET @startDate = '2010-01-01';
	END;
	
	IF(@endDate = '')
	BEGIN
		SET @endDate = '2078-12-31';
	END;

	WITH temp_campaign(row, nameRow, deployedRow, rowDesc, nameRowDesc, deployedRowDesc, campaign_id, site_id, campaign_type_id, [name], 
		from_name, from_email, [subject], [private], html_template_id, text_template_id, [status], [enabled], created, modified, 
		notified_status, sent_email_reminder, provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, 
		special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state) AS
	
	(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY temp_campaign_union.campaign_id) AS row, 
			ROW_NUMBER() OVER (ORDER BY temp_campaign_union.[name]) AS nameRow, 
			ROW_NUMBER() OVER (ORDER BY temp_campaign_union.campaign_deployed_date) AS deployedRow,

			ROW_NUMBER() OVER (ORDER BY temp_campaign_union.campaign_id DESC) AS rowDesc, 
			ROW_NUMBER() OVER (ORDER BY temp_campaign_union.[name] DESC) AS nameRowDesc, 
			ROW_NUMBER() OVER (ORDER BY temp_campaign_union.campaign_deployed_date DESC) AS deployedRowDesc,

			temp_campaign_union.campaign_id AS campaign_Id, temp_campaign_union.site_id AS site_id, temp_campaign_union.campaign_type_id AS campaign_type_id,
			temp_campaign_union.[name], temp_campaign_union.from_name, temp_campaign_union.from_email, temp_campaign_union.[subject], [private], html_template_id, text_template_id, 
			temp_campaign_union.[status], temp_campaign_union.[enabled], temp_campaign_union.created, temp_campaign_union.modified, notified_status, 
			sent_email_reminder, provider_campaign_id, campaign_scheduled_date, 
			campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state
		FROM (
				SELECT temp_campaign.* FROM
				(
					(	SELECT campaign.*
						FROM campaign
							INNER JOIN (
											SELECT campaign_type.campaign_type_id
											FROM campaign_type 
											INNER JOIN bulk_email_type 
												ON bulk_email_type.bulk_email_type_id = campaign_type.bulk_email_type_id
												AND bulk_email_type.bulk_email_type_id 
													IN (SELECT [value] FROM Global_Split(@bulkEmailTypeIds, ','))
										 ) temp_campaign_type
							ON campaign.campaign_type_id = temp_campaign_type.campaign_type_id
							WHERE deleted = 0) temp_campaign
						LEFT OUTER JOIN campaign_recipient ON temp_campaign.campaign_id = campaign_recipient.campaign_id)
				WHERE (temp_campaign.[status] = 7 OR temp_campaign.[status] = 10)
					AND (@isUserSpecific = 0 AND temp_campaign.[private] = 1 
						AND campaign_recipient.email = @email) 
					OR (@isUserSpecific = 1 AND campaign_recipient.email = @email)
				UNION
				SELECT campaign.*
				FROM campaign
					INNER JOIN 
						(
							SELECT campaign_type.campaign_type_id
							FROM campaign_type 
							INNER JOIN bulk_email_type 
								ON bulk_email_type.bulk_email_type_id = campaign_type.bulk_email_type_id
								AND bulk_email_type.bulk_email_type_id IN (SELECT [value] FROM Global_Split(@bulkEmailTypeIds, ','))
						) temp_campaign_type
				ON campaign.campaign_type_id = temp_campaign_type.campaign_type_id
				WHERE (campaign.[status] = 7 OR campaign.[status] = 10)
				AND (@isUserSpecific = 0 AND campaign.[private] = 0)
				AND campaign.deleted = 0
		)AS temp_campaign_union
		WHERE temp_campaign_union.campaign_deployed_date BETWEEN @startDate AND @endDate
			AND (@campaignTypeId IS NULL OR temp_campaign_union.campaign_type_id = @campaignTypeId) 
			AND (@campaignName IS NULL OR temp_campaign_union.[name] LIKE '%' + @campaignName + '%')
	)
	
	SELECT temp_campaign.campaign_id AS id, site_id, campaign_type_id, [name], from_name, from_email, [subject], [private], html_template_id, 
				text_template_id, temp_campaign.[status], temp_campaign.[enabled], temp_campaign.created, temp_campaign.modified, notified_status, sent_email_reminder, provider_campaign_id, 
				campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state
		FROM temp_campaign
			WHERE ((@sortBy = 0 AND @sortOrder = 1 AND row BETWEEN @startRowIndex AND @endRowIndex) OR 
					(@sortBy = 2 AND @sortOrder = 1 AND nameRow BETWEEN @startRowIndex AND @endRowIndex)
					 OR (@sortBy = 1 AND @sortOrder = 1 AND deployedRow BETWEEN @startRowIndex AND @endRowIndex) OR
					(@sortBy = 0 AND @sortOrder = 2 AND rowDesc BETWEEN @startRowIndex AND @endRowIndex) OR 
					(@sortBy = 2 AND @sortOrder = 2 AND nameRowDesc BETWEEN @startRowIndex AND @endRowIndex)
					 OR (@sortBy = 1 AND @sortOrder = 2 AND deployedRowDesc BETWEEN @startRowIndex AND @endRowIndex))
			ORDER BY
				CASE 
					WHEN @sortBy = 0 AND @sortOrder = 1 THEN row 
					WHEN @sortBy = 2 AND @sortOrder = 1 THEN nameRow 
					WHEN @sortBy = 1 AND @sortOrder = 1 THEN deployedRow
					WHEN @sortBy = 0 AND @sortOrder = 2 THEN rowDesc
					WHEN @sortBy = 2 AND @sortOrder = 2 THEN nameRowDesc
					WHEN @sortBy = 1 AND @sortOrder = 2 THEN deployedRowDesc
				END

	SELECT @totalCount = COUNT(*)
	FROM (
				SELECT temp_campaign.* FROM
				(
					(	SELECT campaign.*
						FROM campaign
							INNER JOIN (
											SELECT campaign_type.campaign_type_id
											FROM campaign_type 
											INNER JOIN bulk_email_type 
												ON bulk_email_type.bulk_email_type_id = campaign_type.bulk_email_type_id
												AND bulk_email_type.bulk_email_type_id 
													IN (SELECT [value] FROM Global_Split(@bulkEmailTypeIds, ','))
										 ) temp_campaign_type
							ON campaign.campaign_type_id = temp_campaign_type.campaign_type_id) temp_campaign
						LEFT OUTER JOIN campaign_recipient ON temp_campaign.campaign_id = campaign_recipient.campaign_id)
				WHERE (temp_campaign.[status] = 7 OR temp_campaign.[status] = 10)
					AND (@isUserSpecific = 0 AND temp_campaign.[private] = 1 
						AND campaign_recipient.email = @email) 
					OR (@isUserSpecific = 1 AND campaign_recipient.email = @email)
				UNION
				SELECT campaign.*
				FROM campaign
					INNER JOIN 
						(
							SELECT campaign_type.campaign_type_id
							FROM campaign_type 
							INNER JOIN bulk_email_type 
								ON bulk_email_type.bulk_email_type_id = campaign_type.bulk_email_type_id
								AND bulk_email_type.bulk_email_type_id IN (SELECT [value] FROM Global_Split(@bulkEmailTypeIds, ','))
						) temp_campaign_type
				ON campaign.campaign_type_id = temp_campaign_type.campaign_type_id
				WHERE (campaign.[status] = 7 OR campaign.[status] = 10)
				AND (@isUserSpecific = 0 AND campaign.[private] = 0)
		) AS temp_campaign_union
		WHERE temp_campaign_union.campaign_deployed_date BETWEEN @startDate AND @endDate
			AND (@campaignTypeId IS NULL OR temp_campaign_union.campaign_type_id = @campaignTypeId)
			AND (@campaignName IS NULL OR temp_campaign_union.[name] LIKE '%' + @campaignName + '%')

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignsByBulkEmailTypeUserIdPagingAndSortingFilteringParametersList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignCreatedYearList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignCreatedYearList
	@siteId int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT YEAR(campaign.created) AS campaign_year
	FROM campaign		
	WHERE campaign.site_id = @siteId
	AND deleted = 0
	
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignCreatedYearList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdPageList
	@siteId int,
	@startRowIndex int,
	@endRowIndex int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_campaign (row, campaign_id, site_id, campaign_type_id, [name], from_name, from_email, [subject],
		[private], html_template_id, text_template_id, [status], [enabled], created, modified, 
		notified_status, sent_email_reminder, provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, special_comments, 
		campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY campaign_id) AS row, campaign_id, site_id, campaign_type_id, [name], 
			from_name, from_email, [subject], [private], html_template_id, text_template_id, [status], [enabled], created, 
			modified, notified_status, sent_email_reminder, provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, special_comments,
			campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state
		FROM campaign
		WHERE (site_id = @siteId OR @siteId IS NULL) AND deleted = 0
	)

	SELECT campaign_id AS id, site_id, campaign_type_id, [name], from_name, from_email, [subject], [private]
		, html_template_id, text_template_id, [status], [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id,
		campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
		error_state
	FROM temp_campaign
	WHERE row BETWEEN @startRowIndex AND @endRowIndex

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdPageList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

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
-- $Author: Sahan $
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
		 provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
		 locked, locked_timestamp, error_state) AS
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
					campaign.campaign_deployed_date, campaign.special_comments, campaign_rescheduled_date, recipients_capped,
					campaign.locked, campaign.locked_timestamp, campaign.error_state
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
			AND deleted = 0

	)

	SELECT campaign_id as id, site_id, campaign_type_id, [name], from_name, from_email, 
				[subject], [private], html_template_id, text_template_id, [status], [enabled], created, modified, 
				notified_status, sent_email_reminder, provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, 
				special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state
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
		AND deleted = 0
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdNameStatusTypeIsPrivateList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdPageList
	@siteId int,
	@campaignTypeId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalCount int output,
	@sortBy varchar(14),
	@sortOrder varchar(5)
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_campaign(row, nameRow, typeRow, rowDesc, nameRowDesc, typeRowDesc, campaign_id, site_id, campaign_type_id, [name], 
		from_name, from_email, [subject], [private], html_template_id, text_template_id, [status], [enabled], created, modified, 
		notified_status, sent_email_reminder, provider_campaign_id, campaign_scheduled_date, campaign_deployed_date, 
		special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp, error_state) AS
	
	(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY campaign.campaign_id) AS row, 
			ROW_NUMBER() OVER (ORDER BY campaign.[name]) AS nameRow, 
			ROW_NUMBER() OVER (ORDER BY campaign_type.[name]) AS typeRow, 
			ROW_NUMBER() OVER (ORDER BY campaign.campaign_id DESC) AS rowDesc, 
			ROW_NUMBER() OVER (ORDER BY campaign.[name] DESC) AS nameRowDesc, 
			ROW_NUMBER() OVER (ORDER BY campaign_type.[name] DESC) AS typeRowDesc, campaign.campaign_id AS campaign_Id, 
			campaign.site_id AS site_id, campaign.campaign_type_id AS campaign_type_id, campaign.[name], campaign.from_name, 
			campaign.from_email, campaign.[subject], campaign.[private], campaign.html_template_id, campaign.text_template_id, 
			campaign.[status], campaign.[enabled], campaign.created, campaign.modified, campaign.notified_status, 
			campaign.sent_email_reminder, campaign.provider_campaign_id, campaign.campaign_scheduled_date, 
			campaign.campaign_deployed_date, campaign.special_comments, campaign.campaign_rescheduled_date, campaign.recipients_capped,
			campaign.locked, campaign.locked_timestamp, campaign.error_state
		FROM campaign
			INNER JOIN campaign_type
				ON campaign.campaign_type_id = campaign_type.campaign_type_id
		WHERE campaign.site_id = @siteId AND (@campaignTypeId IS NULL OR campaign.campaign_type_id = @campaignTypeId) AND campaign.deleted = 0
	)

	SELECT campaign_id AS id, site_id, campaign_type_id, [name], from_name, from_email, [subject], [private], html_template_id, 
		text_template_id, [status], [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
		campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped,
		locked, locked_timestamp, error_state
	FROM temp_campaign
	WHERE (@sortBy = 'id' AND @sortOrder = 'asc' AND row BETWEEN @startRowIndex AND @endRowIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'asc' AND nameRow BETWEEN @startRowIndex AND @endRowIndex)
		 OR (@sortBy = 'type' AND @sortOrder = 'asc' AND typeRow BETWEEN @startRowIndex AND @endRowIndex) OR
		(@sortBy = 'id' AND @sortOrder = 'desc' AND rowDesc BETWEEN @startRowIndex AND @endRowIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'desc' AND nameRowDesc BETWEEN @startRowIndex AND @endRowIndex)
		 OR (@sortBy = 'type' AND @sortOrder = 'desc' AND typeRowDesc BETWEEN @startRowIndex AND @endRowIndex)
	ORDER BY
		CASE 
			WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN row 
			WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameRow 
			WHEN @sortBy = 'type' AND @sortOrder = 'asc' THEN typeRow
			WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN rowDesc
			WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameRowDesc
			WHEN @sortBy = 'type' AND @sortOrder = 'desc' THEN typeRowDesc
		END

	SELECT @totalCount = COUNT(*)
	FROM campaign
	WHERE site_id = @siteId AND (@campaignTypeId IS NULL OR campaign_type_id = @campaignTypeId) AND deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdPageList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdFilteredContentIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdFilteredContentIdPageList
	@siteId int,
	@campaignTypeId int,
	@contentId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output,
	@filterContentType varchar(14)
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	CREATE TABLE #TempList
	(
		contentId int,
		siteId int
	)

	IF @filterContentType = 'Article'
		BEGIN
			INSERT INTO #TempList
				SELECT DISTINCT content_id, @siteId
				FROM content_to_content
				WHERE associated_content_id = @contentId AND content_type_id = 4 AND associated_content_type_id = 6
					AND site_id = @siteId AND associated_site_id = @siteId AND enabled = 1
		END
	ELSE IF @filterContentType = 'Product'
		BEGIN
			INSERT INTO #TempList
				SELECT DISTINCT product_id, @siteId
				FROM product_to_vendor
				WHERE vendor_id = @contentId AND enabled = 1
		END

	IF @campaignTypeId > 0
		BEGIN
			WITH CampaignList AS
			(
			SELECT c.campaign_id AS id, ROW_NUMBER() OVER (ORDER BY c.campaign_id) AS row_id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
				   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
				   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM campaign c
				INNER JOIN #TempList tl
					ON tl.siteId = @siteId
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = tl.contentId
			WHERE c.site_id = @siteId AND c.campaign_type_id = @campaignTypeId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0
			)
			
			SELECT id, site_id, campaign_type_id, [name], from_name, 
				   from_email, [subject], [private], html_template_id, text_template_id, [status],
				   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM CampaignList
			WHERE row_id BETWEEN @startIndex AND @endIndex

			SELECT @totalCount = COUNT(*)
			FROM campaign c
				INNER JOIN #TempList tl
					ON tl.siteId = @siteId
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = tl.contentId
			WHERE c.site_id = @siteId AND c.campaign_type_id = @campaignTypeId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0

		END
	ELSE
		BEGIN
			WITH CampaignList AS
			(
			SELECT c.campaign_id AS id, ROW_NUMBER() OVER (ORDER BY c.campaign_id) AS row_id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
				   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
				   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM campaign c
				INNER JOIN #TempList tl
					ON tl.siteId = @siteId
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = tl.contentId
			WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0
			)

			SELECT id, site_id, campaign_type_id, [name], from_name, 
				   from_email, [subject], [private], html_template_id, text_template_id, [status],
				   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM CampaignList
			WHERE row_id BETWEEN @startIndex AND @endIndex

			SELECT @totalCount = COUNT(*)
			FROM campaign c
				INNER JOIN #TempList tl
					ON tl.siteId = @siteId
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = tl.contentId
			WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0
		END
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdFilteredContentIdPageList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdContentIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdContentIdPageList
	@siteId int,
	@campaignTypeId int,
	@contentId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	IF @campaignTypeId > 0
		BEGIN
			WITH CampaignList AS
			(
			SELECT c.campaign_id AS id, ROW_NUMBER() OVER (ORDER BY c.campaign_id) AS row_id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
				   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
				   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM campaign c
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = @contentId
			WHERE c.site_id = @siteId AND c.campaign_type_id = @campaignTypeId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0
			)
			
			SELECT id, site_id, campaign_type_id, [name], from_name, 
				   from_email, [subject], [private], html_template_id, text_template_id, [status],
				   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM CampaignList
			WHERE row_id BETWEEN @startIndex AND @endIndex

			SELECT @totalCount = COUNT(*)
			FROM campaign c
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = @contentId
			WHERE c.site_id = @siteId AND c.campaign_type_id = @campaignTypeId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0

		END
	ELSE
		BEGIN
			WITH CampaignList AS
			(
			SELECT c.campaign_id AS id, ROW_NUMBER() OVER (ORDER BY c.campaign_id) AS row_id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
				   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
				   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM campaign c
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = @contentId
			WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0
			)

			SELECT id, site_id, campaign_type_id, [name], from_name, 
				   from_email, [subject], [private], html_template_id, text_template_id, [status],
				   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
				   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
				   error_state
			FROM CampaignList
			WHERE row_id BETWEEN @startIndex AND @endIndex

			SELECT @totalCount = COUNT(*)
			FROM campaign c
				INNER JOIN campaign_content_data ccd
					ON ccd.content_id = @contentId
			WHERE c.site_id = @siteId AND c.campaign_id = ccd.campaign_id AND ccd.enabled = 1 AND c.deleted = 0
		END
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdContentIdPageList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdContentGroupIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdContentGroupIdPageList
	@siteId int,
	@campaignTypeId int,
	@contentGroupId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH CampaignList AS
	(
		SELECT c.campaign_id AS id, ROW_NUMBER() OVER (ORDER BY c.campaign_id) AS row_id, c.site_id, c.campaign_type_id, c.[name], c.from_name, 
			   c.from_email, c.[subject], [private], html_template_id, text_template_id, [status],
			   c.[enabled], c.created, c.modified, notified_status, sent_email_reminder, provider_campaign_id, 
			   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
			   error_state
		FROM campaign c
			INNER JOIN campaign_type_content_group ctcg
				ON ctcg.campaign_type_content_group_id = @contentGroupId
		WHERE c.site_id = @siteId AND c.campaign_type_id = @campaignTypeId AND c.deleted = 0 AND c.campaign_id IN (SELECT DISTINCT ccd.campaign_id FROM campaign_content_data ccd WHERE ccd.campaign_type_content_group_id = ctcg.campaign_type_content_group_id AND ccd.enabled = 1)
	)
	
	SELECT id, site_id, campaign_type_id, [name], from_name, 
		   from_email, [subject], [private], html_template_id, text_template_id, [status],
		   [enabled], created, modified, notified_status, sent_email_reminder, provider_campaign_id, 
		   campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped, locked, locked_timestamp,
		   error_state
	FROM CampaignList
	WHERE row_id BETWEEN @startIndex AND @endIndex

	SELECT @totalCount = COUNT(*)
	FROM campaign c
		INNER JOIN campaign_type_content_group ctcg
			ON ctcg.campaign_type_content_group_id = @contentGroupId
	WHERE c.site_id = @siteId AND c.campaign_type_id = @campaignTypeId AND c.deleted = 0 AND c.campaign_id IN (SELECT DISTINCT ccd.campaign_id FROM campaign_content_data ccd WHERE ccd.campaign_type_content_group_id = ctcg.campaign_type_content_group_id AND ccd.enabled = 1)

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdCampaignTypeIdContentGroupIdPageList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignBySiteIdAndStatusList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignBySiteIdAndStatusList
	@siteId int,
	@status int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;
 
SELECT campaign_id  as id, site_id, campaign_type_id , [name], from_name, from_email,
			subject, private ,html_template_id ,status, enabled, created, modified,
			notified_status, sent_email_reminder, provider_campaign_id,campaign_scheduled_date,
			campaign_deployed_date, special_comments, text_template_id, campaign_rescheduled_date, recipients_capped,
			locked, locked_timestamp, error_state
FROM campaign
WHERE site_id = @siteId AND status = @status and deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignBySiteIdAndStatusList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_ToggleCampaignDeleteStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_ToggleCampaignDeleteStatus
	@id int,
	@deleteStatus int
	
AS
-- ==========================================================================
-- $Author: Sahan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	UPDATE campaign
	SET
		deleted = @deleteStatus,
		modified = GETDATE()
	WHERE campaign_id = @id
 
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_ToggleCampaignDeleteStatus TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetSoftDeletedCampaigns'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetSoftDeletedCampaigns
	@siteId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Sahan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;
	
	WITH CampaignList AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY campaign_id) AS row_id, campaign_id  as id, site_id, campaign_type_id , [name], from_name, from_email,
			subject, private ,html_template_id ,status, enabled, created, modified,
			notified_status, sent_email_reminder, provider_campaign_id,campaign_scheduled_date,
			campaign_deployed_date, special_comments, text_template_id, campaign_rescheduled_date, recipients_capped,
			locked, locked_timestamp, error_state
		FROM campaign
		WHERE site_id = @siteId and deleted = 1
			
	)
	
	SELECT id, site_id, campaign_type_id , [name], from_name, from_email,
			subject, private ,html_template_id ,status, enabled, created, modified,
			notified_status, sent_email_reminder, provider_campaign_id,campaign_scheduled_date,
			campaign_deployed_date, special_comments, text_template_id, campaign_rescheduled_date, recipients_capped,
			locked, locked_timestamp, error_state
	FROM CampaignList
	WHERE row_id BETWEEN @startIndex AND @endIndex
	
	SELECT @totalCount = COUNT(*)
	FROM campaign
	WHERE site_id = @siteId and deleted = 1
	
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetSoftDeletedCampaigns TO VpWebApp 
GO