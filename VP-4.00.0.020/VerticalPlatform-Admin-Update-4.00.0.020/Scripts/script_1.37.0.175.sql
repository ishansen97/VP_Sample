IF NOT EXISTS(SELECT * FROM sys.columns WHERE [name] = N'confirmation_email_template' AND [object_id] = OBJECT_ID(N'lead_form'))
BEGIN
	ALTER TABLE [lead_form] ADD confirmation_email_template VARCHAR(MAX)
END
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminLead_AddLeadForm'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminLead_AddLeadForm
	@siteId int,
	@contentId int, 
	@contentTypeId int,
	@actionId int,
	@definition varchar(MAX),
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@confirmationEmailBody varchar(MAX),
	@confirmationEmailSubject varchar(255),
	@thankyouMessage varchar(MAX),
	@userLogged bit,
	@title varchar(200),
	@confirmationEmailTemplate varchar(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO lead_form(site_id, content_id, content_type_id, action_id
		, definition, [enabled], modified, created, confirmation_email_body
		, confirmation_email_subject, thank_you_msg,user_logged, title, confirmation_email_template)
	VALUES (@siteId, @contentId, @contentTypeId, @actionId, @definition, @enabled, @created
		, @created, @confirmationEmailBody, @confirmationEmailSubject, @thankyouMessage,@userLogged
		, @title, @confirmationEmailTemplate)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminLead_AddLeadForm TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicLead_GetLeadFormDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicLead_GetLeadFormDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT lead_form_id AS id, site_id, content_id, content_type_id, action_id, definition
		, [enabled], modified, created, confirmation_email_body, confirmation_email_subject
		, thank_you_msg, user_logged, title, confirmation_email_template
	FROM lead_form
	WHERE lead_form_id = @id

END
GO

GRANT EXECUTE ON dbo.publicLead_GetLeadFormDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminLead_UpdateLeadForm'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminLead_UpdateLeadForm
	@id int,
	@siteId int,
	@contentId int, 
	@contentTypeId int,
	@actionId int,
	@definition varchar(MAX),
	@enabled bit,
	@modified smalldatetime output,
	@confirmationEmailBody varchar(MAX),
	@confirmationEmailSubject varchar(255),
	@thankyouMessage varchar(MAX),
	@userLogged bit,
	@title varchar(200),
	@confirmationEmailTemplate varchar(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE lead_form
	SET site_id = @siteId,
		content_id = @contentId,
		content_type_id = @contentTypeId,
		action_id = @actionId,
		definition = @definition,
		[enabled] = @enabled,
		modified = @modified,
		confirmation_email_body = @confirmationEmailBody,
		confirmation_email_subject = @confirmationEmailSubject,
		thank_you_msg = @thankyouMessage,
		user_logged = @userLogged,
		title = @title,
		confirmation_email_template = @confirmationEmailTemplate
	WHERE lead_form_id = @id

END
GO

GRANT EXECUTE ON dbo.adminLead_UpdateLeadForm TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminLead_GetLeadFormByContentTypeIdContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminLead_GetLeadFormByContentTypeIdContentIdList
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT lead_form_id AS id, site_id, content_id, content_type_id, action_id, definition
		, [enabled], modified, created, confirmation_email_body, confirmation_email_subject
		, thank_you_msg, user_logged, title, confirmation_email_template
	FROM lead_form
	WHERE content_type_id = @contentTypeId AND content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.adminLead_GetLeadFormByContentTypeIdContentIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicLead_GetLeadFormByActionIdContentTypeContentIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicLead_GetLeadFormByActionIdContentTypeContentIdDetail
	@actionId int,
	@contentTypeId int,
	@contentId int,
	@userLogged bit
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT lead_form_id AS id, site_id, content_id, content_type_id, action_id, definition
		, [enabled], modified, created, confirmation_email_body, confirmation_email_subject
		, thank_you_msg, user_logged, title, confirmation_email_template
	FROM lead_form
	WHERE action_id = @actionId AND content_type_id = @contentTypeId AND content_id = @contentId AND user_logged = @userLogged

END
GO

GRANT EXECUTE ON dbo.publicLead_GetLeadFormByActionIdContentTypeContentIdDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicLead_GetApplicationLeadForm'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicLead_GetApplicationLeadForm
	@userLogged bit
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT lead_form_id AS id, site_id, content_id, content_type_id, action_id, definition
		, [enabled], modified, created, confirmation_email_body, confirmation_email_subject
		, thank_you_msg, user_logged, title, confirmation_email_template
	FROM lead_form
	WHERE user_logged = @userLogged AND site_id IS NULL

END
GO

GRANT EXECUTE ON dbo.publicLead_GetApplicationLeadForm TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------