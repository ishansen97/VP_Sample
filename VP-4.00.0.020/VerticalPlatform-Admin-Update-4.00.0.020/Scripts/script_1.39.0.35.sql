IF EXISTS (SELECT content_type_id FROM content_type WHERE content_type_id = 39 AND content_type = 'ActionContent')
BEGIN
	DELETE FROM content_location WHERE content_type_id = 39
	
	DELETE FROM content_type WHERE content_type_id = 39 AND content_type = 'ActionContent'
END
GO
-------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT content_type_id FROM content_type WHERE content_type_id = 39)
BEGIN
	INSERT INTO content_type
     VALUES (39 ,'ContentLeadAction' ,1 ,getdate() ,getdate())
END
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminAction_DeleteActionContentByVendorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAction_DeleteActionContentByVendorId
@vendorId int
AS
-- ==========================================================================
-- $Author: $ Sujith
-- ==========================================================================
BEGIN

SET NOCOUNT ON;

DELETE FROM action_to_content 
WHERE action_to_content_id IN
	(
		SELECT action_to_content_id 
		FROM action_to_content ac
			INNER JOIN product_to_vendor pv
				ON pv.product_id = ac.content_id AND ac.content_type_id = 2 
		WHERE pv.vendor_id = @vendorId AND pv.is_manufacturer = '1'
	)

END
GO

GRANT EXECUTE ON dbo.adminAction_DeleteActionContentByVendorId TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[content_lead_action_location]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[content_lead_action_location](
		[content_lead_action_location_id] [int] IDENTITY(1,1) NOT NULL,
		[content_type_id] [int] NOT NULL,
		[content_id] [int] NOT NULL,
		[action_id] [int] NOT NULL,
		[flag1] [bigint] NOT NULL,
		[flag2] [bigint] NOT NULL,
		[flag3] [bigint] NOT NULL,
		[flag4] [bigint] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[enabled] [bit] NOT NULL,
		CONSTRAINT [PK_content_lead_action_location] PRIMARY KEY CLUSTERED 
		(
			[content_lead_action_location_id] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[content_lead_action_location]  WITH CHECK ADD  CONSTRAINT [FK_content_lead_action_location_action] FOREIGN KEY([action_id])
	REFERENCES [dbo].[action] ([action_id])

	ALTER TABLE [dbo].[content_lead_action_location] CHECK CONSTRAINT [FK_content_lead_action_location_action]

	ALTER TABLE [dbo].[content_lead_action_location]  WITH CHECK ADD  CONSTRAINT [FK_content_lead_action_location_content_type] FOREIGN KEY([content_type_id])
	REFERENCES [dbo].[content_type] ([content_type_id])

	ALTER TABLE [dbo].[content_lead_action_location] CHECK CONSTRAINT [FK_content_lead_action_location_content_type]
END
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddContentLeadActionLocation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddContentLeadActionLocation
	@contentTypeId int,
	@contentId int,
	@actionId int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO content_lead_action_location(content_type_id, content_id, action_id, flag1, flag2, flag3, flag4, enabled, created, modified)
	VALUES (@contentTypeId, @contentId, @actionId, @flag1, @flag2, @flag3, @flag4, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddContentLeadActionLocation TO VpWebApp 
GO

GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateContentLeadActionLocation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateContentLeadActionLocation
	@id int,
	@contentTypeId int,
	@contentId int,
	@actionId int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE content_lead_action_location
	SET content_type_id = @contentTypeId, 
	content_id = @contentId, 
	action_id = @actionId,
	flag1 = @flag1, 
	flag2 = @flag2, 
	flag3 = @flag3, 
	flag4 = @flag4, 
	enabled = @enabled,
	modified = @modified
	WHERE content_lead_action_location_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateContentLeadActionLocation TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteContentLeadActionLocation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteContentLeadActionLocation
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM content_lead_action_location
	WHERE content_lead_action_location_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteContentLeadActionLocation TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentLeadActionLocationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentLeadActionLocationDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT content_lead_action_location_id AS id, content_type_id, content_id, action_id, flag1, flag2, flag3, flag4, created, enabled, modified
	FROM content_lead_action_location
	WHERE content_lead_action_location_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentLeadActionLocationDetail TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentLeadActionLocationByContentTypeContentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentLeadActionLocationByContentTypeContentId
	@contentId INT,
	@contentTypeId INT
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [content_lead_action_location_id] AS [id],[content_type_id],[content_id], [action_id],[flag1],[flag2]
		  ,[flag3],[flag4],[created],[modified],[enabled]
	FROM [content_lead_action_location]
	WHERE [content_type_id] = @contentTypeId AND [content_id] = @contentId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentLeadActionLocationByContentTypeContentId TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentLeadActionLocationByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentLeadActionLocationByProductIdList
	@productIds NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT clal.[content_lead_action_location_id] AS [id],clal.[content_type_id],clal.[content_id],clal.[action_id]
		  ,clal.[flag1],clal.[flag2],clal.[flag3],clal.[flag4],clal.[created],clal.[modified],clal.[enabled]
	FROM [content_lead_action_location] clal
		INNER JOIN dbo.global_Split(@productIds, ',') gs
			ON gs.[value] = clal.[content_id] AND clal.[content_type_id] = 2

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentLeadActionLocationByProductIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------