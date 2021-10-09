IF NOT EXISTS (SELECT * FROM module WHERE module_name = 'UnsubscriptionReason')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES ('UnsubscriptionReason', '~/Modules/BulkEmail/UnsubscriptionReason.ascx', 1, getdate(), getdate(), 0)
END
GO

----------


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
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Naveen
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
		special_comments, campaign_rescheduled_date, recipients_capped) AS
	
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
			campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped
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
		)AS temp_campaign_union
		WHERE temp_campaign_union.campaign_deployed_date BETWEEN @startDate AND @endDate
			AND (@campaignTypeId IS NULL OR temp_campaign_union.campaign_type_id = @campaignTypeId)
	)
	
	SELECT temp_campaign.campaign_id AS id, site_id, campaign_type_id, [name], from_name, from_email, [subject], [private], html_template_id, 
				text_template_id, temp_campaign.[status], temp_campaign.[enabled], temp_campaign.created, temp_campaign.modified, notified_status, sent_email_reminder, provider_campaign_id, 
				campaign_scheduled_date, campaign_deployed_date, special_comments, campaign_rescheduled_date, recipients_capped
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

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignsByBulkEmailTypeUserIdPagingAndSortingFilteringParametersList TO VpWebApp 
GO

----------