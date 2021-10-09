IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[public_user_score]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[public_user_score](
		[public_user_score_id] [int] IDENTITY(1,1) NOT NULL,
		[public_user_id] [int] NOT NULL,
		[public_user_score] float NOT NULL,
		[depreciated_timestamp] [smalldatetime] NULL,
		[enabled] [bit] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL,
	CONSTRAINT [PK_public_user_score] PRIMARY KEY CLUSTERED 
	(
		[public_user_score_id] ASC
	)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY],
	 CONSTRAINT [IX_public_user_id] UNIQUE NONCLUSTERED 
	(
		[public_user_id] ASC
	)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[public_user_score]  WITH CHECK ADD CONSTRAINT [FK_public_user_id] FOREIGN KEY([public_user_id])
	REFERENCES [dbo].[public_user] ([public_user_id])

END
GO

---------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_AddPublicUserScore'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_AddPublicUserScore
	@publicUserId int,
	@publicUserScore float,
	@depreciatedTimestamp smalldatetime,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO public_user_score(public_user_id, public_user_score, depreciated_timestamp, created, enabled, modified)
	VALUES (@publicUserId, @publicUserScore, @depreciatedTimestamp, @created, @enabled, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_AddPublicUserScore TO VpWebApp 
GO

GO

--------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_UpdatePublicUserScore'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_UpdatePublicUserScore
	@id int,
	@publicUserId int,
	@publicUserScore float,
	@depreciatedTimestamp smalldatetime,
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE public_user_score
	SET public_user_id = @publicUserId, 
	public_user_score = @publicUserScore, 
	depreciated_timestamp = @depreciatedTimestamp, 
	enabled = @enabled,
	modified = @modified
	WHERE public_user_score_id = @id

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_UpdatePublicUserScore TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_DeletePublicUserScore'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_DeletePublicUserScore
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM public_user_score
	WHERE public_user_score_id = @id

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_DeletePublicUserScore TO VpWebApp 
Go

------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetPublicUserScoreDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_GetPublicUserScoreDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT public_user_score_id AS id, public_user_id, public_user_score, depreciated_timestamp, created, enabled, modified
	FROM public_user_score
	WHERE public_user_score_id = @id

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetPublicUserScoreDetail TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetPublicUserScoreByPublicUserId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_GetPublicUserScoreByPublicUserId
	@publicUserId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT public_user_score_id AS id, public_user_id, public_user_score, depreciated_timestamp, created, enabled, modified
	FROM public_user_score
	WHERE public_user_id = @publicUserId

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetPublicUserScoreByPublicUserId TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicBulkEmail_GetCampaignRecipientsByEmailCampaignId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicBulkEmail_GetCampaignRecipientsByEmailCampaignId
	@email varchar(200),
	@campaignId int
	
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT  campaign_recipient_id AS id, campaign_id, site_id, email, recipient_name, status, [enabled], created, modified
	FROM campaign_recipient
	WHERE email = @email
		AND campaign_id = @campaignId

END
GO

GRANT EXECUTE ON dbo.publicBulkEmail_GetCampaignRecipientsByEmailCampaignId TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds
	@articleTypeIds NVARCHAR(MAX),
	@siteId INT,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH FeaturedVendorArticles AS
	(
		SELECT v.[vendor_id], a.[article_id] AS [id],a.[article_type_id],a.[site_id],a.[article_title],a.[article_summary],a.[enabled]
			,a.[modified],a.[created],a.[article_short_title],a.[is_article_template],a.[is_external],a.[featured_identifier]
			,a.[thumbnail_image_code],a.[date_published],a.[external_url_id],a.[is_template],a.[article_template_id]
			,a.[open_new_window],a.[end_date],a.[flag1],a.[flag2],a.[flag3],a.[flag4],a.[published],a.[start_date]
			,a.[legacy_content_id],a.[search_content_modified],a.[deleted], ROW_NUMBER() OVER (ORDER BY a.[modified] DESC) AS rowNumber
		FROM [article] a
			INNER JOIN vendor_parameter vp
				ON vp.[vendor_parameter_value] = a.[article_id] AND vp.[parameter_type_id] = 174
			INNER JOIN vendor_parameter vp2
				ON vp2.[vendor_id] = vp.[vendor_id] AND vp2.[parameter_type_id] = 179 AND (
						vp2.[vendor_parameter_value] LIKE '5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5' OR 
						vp2.[vendor_parameter_value] = '5')
			INNER JOIN vendor v 
				ON v.[vendor_id] = vp2.[vendor_id]
		WHERE v.[site_id] = @siteId AND v.[enabled] = 1 AND a.[enabled] = 1 AND a.[published] = 1 AND (
				@articleTypeIds IS NULL OR 
				a.[article_type_id] IN (
						SELECT gs.[value] 
						FROM dbo.global_Split(@articleTypeIds, ',') gs
					)
			)
	)
	
	SELECT [vendor_id], [id], [article_type_id], [site_id], [article_title], [article_summary], [enabled]
		, [modified], [created], [article_short_title], [is_article_template], [is_external], [featured_identifier]
		, [thumbnail_image_code], [date_published], [external_url_id], [is_template], [article_template_id]
		, [open_new_window], [end_date], [flag1], [flag2], [flag3], [flag4], [published], [start_date]
		, [legacy_content_id], [search_content_modified], [deleted]
	FROM FeaturedVendorArticles
	WHERE rowNumber BETWEEN @startIndex AND @endIndex
	
	SELECT @totalCount = COUNT(*)
	FROM [article] a
			INNER JOIN vendor_parameter vp
				ON vp.[vendor_parameter_value] = a.[article_id] AND vp.[parameter_type_id] = 174
			INNER JOIN vendor_parameter vp2
				ON vp2.[vendor_id] = vp.[vendor_id] AND vp2.[parameter_type_id] = 179 AND (
						vp2.[vendor_parameter_value] LIKE '5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5,%' OR 
						vp2.[vendor_parameter_value] LIKE '%,5' OR 
						vp2.[vendor_parameter_value] = '5')
			INNER JOIN vendor v 
				ON v.[vendor_id] = vp2.[vendor_id]
		WHERE v.[site_id] = @siteId AND v.[enabled] = 1 AND a.[enabled] = 1 AND a.[published] = 1 AND (
				@articleTypeIds IS NULL OR 
				a.[article_type_id] IN (
						SELECT gs.[value] 
						FROM dbo.global_Split(@articleTypeIds, ',') gs
					)
			)

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetFeaturedVendorArticleBySiteIdArticleTypeIds TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_DepreciatePublicUserScore'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_DepreciatePublicUserScore
	@depreciationRate float,
	@window int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE pus
	SET pus.public_user_score = (pus.public_user_score - (pus.public_user_score * (@depreciationRate/100))),
		pus.depreciated_timestamp = GETDATE(),
		pus.modified = GETDATE()
	FROM public_user_score pus
	WHERE (GETDATE() > DATEADD(HOUR, @window, pus.depreciated_timestamp) OR pus.depreciated_timestamp IS NULL)
		AND pus.public_user_score > 0

END
GO

GRANT EXECUTE ON dbo.adminUser_DepreciatePublicUserScore TO VpWebApp 
GO

--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_UnsubscribeSubscribersListByScore'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_UnsubscribeSubscribersListByScore
	@optOutScore int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE pu
	SET pu.email_optout = 1,
		pu.modified = GETDATE()
	FROM public_user_score pus
	INNER JOIN public_user pu 
		ON pu.public_user_id = pus.public_user_id
	WHERE pu.email_optout = 0
		AND pus.public_user_score <= @optOutScore

END
GO

GRANT EXECUTE ON dbo.adminUser_UnsubscribeSubscribersListByScore TO VpWebApp 
GO
