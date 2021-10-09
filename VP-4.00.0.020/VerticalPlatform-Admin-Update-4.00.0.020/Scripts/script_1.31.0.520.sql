-------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name = 'content_to_specification_type')
BEGIN
	CREATE TABLE [dbo].[content_to_specification_type](
	[content_to_specification_type_id] [int] IDENTITY(1,1) NOT NULL,
	[content_id] [int] NOT NULL,
	[content_type_id] [int] NOT NULL,
	[specification_type_id] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_content_to_specification_type] PRIMARY KEY CLUSTERED 
	(
		[content_to_specification_type_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
---------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_content_to_specification_type_content_type') AND parent_object_id = OBJECT_ID(N'content_to_specification_type'))
BEGIN
	ALTER TABLE [dbo].[content_to_specification_type]  WITH CHECK ADD  CONSTRAINT [FK_content_to_specification_type_content_type] FOREIGN KEY([content_type_id])
	REFERENCES [dbo].[content_type] ([content_type_id])

	ALTER TABLE [dbo].[content_to_specification_type] CHECK CONSTRAINT [FK_content_to_specification_type_content_type]
END
GO
--------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_content_to_specification_type_specification_type') AND parent_object_id = OBJECT_ID(N'content_to_specification_type'))
BEGIN
	ALTER TABLE [dbo].[content_to_specification_type]  WITH CHECK ADD  CONSTRAINT [FK_content_to_specification_type_specification_type] FOREIGN KEY([specification_type_id])
	REFERENCES [dbo].[specification_type] ([spec_type_id])
	ALTER TABLE [dbo].[content_to_specification_type] CHECK CONSTRAINT [FK_content_to_specification_type_specification_type]

END
GO
---------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteContentSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteContentSpecificationType
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM content_to_specification_type
	WHERE content_to_specification_type_id = @id;

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteContentSpecificationType TO VpWebApp 
GO
--------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateContentSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateContentSpecificationType
	@id int,
	@contentId int,
	@contentTypeId int,
	@specificationTypeId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE content_to_specification_type
	SET
		content_id = @contentId,
		content_type_id = @contentTypeId,
		specification_type_id = @specificationTypeId,
		[enabled] = @enabled,
		modified = @modified
	WHERE content_to_specification_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateContentSpecificationType TO VpWebApp 
GO

--------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddContentSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddContentSpecificationType
	@contentId int,
	@contentTypeId int,
	@specificationTypeId int,
	@enabled bit,
	@created smalldatetime output,
	@id int output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @created = GETDATE()
	INSERT INTO [dbo].[content_to_specification_type]
           (content_id, content_type_id, specification_type_id, enabled, created, modified)
     VALUES(@contentId, @contentTypeId, @specificationTypeId, @enabled, @created, @created)
	 
	 SET @id = SCOPE_IDENTITY() 

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddContentSpecificationType TO VpWebApp 
GO

---------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetContentSpecificationTypeDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetContentSpecificationTypeDetail
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SELECT content_to_specification_type_id as id, content_id, content_type_id, specification_type_id, [enabled], created, modified
	FROM content_to_specification_type
	WHERE content_to_specification_type_id = @id
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetContentSpecificationTypeDetail TO VpWebApp 
GO
-----------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetContentSpecificationsByContentTypeIdAndContentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetContentSpecificationsByContentTypeIdAndContentId
	@contentTypeId int,
	@contentId varchar(MAX)
	
AS
-- ==========================================================================
-- Author : Rifaz Rifky
-- ==========================================================================
BEGIN

	SELECT [content_to_specification_type_id] AS [id], [content_id], [content_type_id], [specification_type_id]
		  , [enabled], [created], [modified]
	FROM [content_to_specification_type]
	WHERE [content_type_id] = @contentTypeId AND [content_id] = @contentId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetContentSpecificationsByContentTypeIdAndContentId TO VpWebApp
GO
--------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationTypeInformationByContentTypeIdAndContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationTypeInformationByContentTypeIdAndContentIdList
	@contentTypeId int,
	@contentIdList varchar(MAX)
	
AS
-- ==========================================================================
-- Author : Rifaz
-- ==========================================================================
BEGIN

	SELECT cp.content_id , c.[spec_type_id] AS [id], c.[spec_type], c.[validation_expression], c.[site_id], c.[enabled], c.[modified]
		  , c.[created], c.[is_visible], c.[search_enabled], c.[is_expanded_view], c.[display_empty]
	FROM [specification_type] c
	INNER JOIN content_to_specification_type cp
		ON c.spec_type_id = cp.specification_type_id
	INNER JOIN global_Split(@contentIdList, ',') AS tempContentIds
		ON cp.[content_id] = tempContentIds.[value]
	WHERE cp.content_type_id = @contentTypeId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationTypeInformationByContentTypeIdAndContentIdList TO VpWebApp
------------------------------------


