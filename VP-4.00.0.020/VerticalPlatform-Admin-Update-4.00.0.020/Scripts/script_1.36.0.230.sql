IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'default_html_template' AND id = 
	(
		SELECT object_id 
		FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'campaign_type_email_template') AND type in (N'U')
	)
)
BEGIN
	ALTER TABLE campaign_type_email_template
	ADD default_html_template bit NOT NULL DEFAULT 0
END

GO

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'default_text_template' AND id = 
	(
		SELECT object_id 
		FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'campaign_type_email_template') AND type in (N'U')
	)
)
BEGIN
	ALTER TABLE campaign_type_email_template
	ADD default_text_template bit NOT NULL DEFAULT 0
END

GO

-------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_AddCampaignTypeEmailTemplate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_AddCampaignTypeEmailTemplate
	@campaignTypeId int,
	@emailTemplateId int,
	@defaultHtmlTemplate bit,
	@defaultTextTemplate bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output	
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;	

	SET @created = GETDATE()

	INSERT INTO campaign_type_email_template (campaign_type_id, email_template_id, default_html_template, default_text_template, [enabled], created, modified)
	VALUES (@campaignTypeId, @emailTemplateId, @defaultHtmlTemplate, @defaultTextTemplate, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_AddCampaignTypeEmailTemplate TO VpWebApp
GO

----------


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignTypeEmailTemplateDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignTypeEmailTemplateDetail
	@id int	
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;	

	SELECT campaign_type_email_template_id AS id, campaign_type_id, email_template_id, default_html_template, default_text_template, [enabled], created, modified
	FROM campaign_type_email_template
	WHERE campaign_type_email_template_id = @id

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignTypeEmailTemplateDetail TO VpWebApp
GO

----------


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_UpdateCampaignTypeEmailTemplate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_UpdateCampaignTypeEmailTemplate
	@id int,
	@campaignTypeId int,
	@emailTemplateId int,
	@defaultHtmlTemplate bit,
	@defaultTextTemplate bit,
	@enabled bit,
	@modified smalldatetime output	
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;	

	SET @modified = GETDATE()

	UPDATE campaign_type_email_template
	SET campaign_type_id = @campaignTypeId,
		email_template_id = @emailTemplateId,
		default_html_template = @defaultHtmlTemplate,
		default_text_template = @defaultTextTemplate,
		[enabled] = @enabled,
		modified = @modified
	WHERE campaign_type_email_template_id = @id

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_UpdateCampaignTypeEmailTemplate TO VpWebApp
GO

-------


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetCampaignTypeEmailTemplateByCampaignIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetCampaignTypeEmailTemplateByCampaignIdList
	@campaignTypeId int	
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;	

	SELECT campaign_type_email_template_id AS id, campaign_type_id, email_template_id, default_html_template, default_text_template, [enabled], created, modified
	FROM campaign_type_email_template
	WHERE campaign_type_id = @campaignTypeId

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetCampaignTypeEmailTemplateByCampaignIdList TO VpWebApp
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationListByContentTypeIdContentIdValuesSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationListByContentTypeIdContentIdValuesSpecificationType
	@contentTypeId INT,
	@contentIdValues VARCHAR(8000),
	@specificationType VARCHAR(255),
	@siteId INT
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @specificationTypeId INT

	SELECT TOP 1 @specificationTypeId = spec_type_id 
	FROM specification_type 
	WHERE spec_type = @specificationType 
		AND site_id = @siteId

	SELECT specification_id AS id, content_id, specification.spec_type_id, specification, display_options
		, specification.enabled, specification.modified, specification.created, content_type_id
	FROM specification
		INNER JOIN specification_type
			ON specification.spec_type_id = specification_type.spec_type_id
		INNER JOIN global_Split(@contentIdValues, ',') content_id_table
			ON content_id_table.value = specification.content_id 
	WHERE content_type_id = @contentTypeId 
		AND specification_type.spec_type_id = @specificationTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationListByContentTypeIdContentIdValuesSpecificationType TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleAuthorsByAuthorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleAuthorsByAuthorId
	@authorId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_to_author_id] AS id,[article_id],[author_id],[enabled],[created],[modified]
		,[gift_card_id],[verified]
	FROM [article_to_author]
	WHERE [author_id] = @authorId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleAuthorsByAuthorId TO VpWebApp 
GO