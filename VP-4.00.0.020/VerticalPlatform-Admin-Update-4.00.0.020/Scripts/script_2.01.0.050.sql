IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'rapid_deleted_master_data')
BEGIN
	SET ANSI_NULLS ON
	

	SET QUOTED_IDENTIFIER ON
	

	CREATE TABLE [dbo].[rapid_deleted_master_data](
		deleted_content_id int IDENTITY(1,1) NOT NULL,
		content_type_id int NOT NULL,
		content_id int NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL
	 CONSTRAINT [PK_rapid_deleted_master_data] PRIMARY KEY CLUSTERED 
	(
	deleted_content_id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY]
	


	ALTER TABLE [dbo].[rapid_deleted_master_data]  WITH NOCHECK ADD  CONSTRAINT [FK_rapid_deleted_master_data_to_content_type] FOREIGN KEY([content_type_id])
	REFERENCES [dbo].[content_type]([content_type_id])
	
END


-----------adminProduct_GetRapidDeletedMasterDataBatch--------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetRapidDeletedMasterDataBatch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetRapidDeletedMasterDataBatch
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

SELECT TOP (@batchSize) [deleted_content_id] as Id
      ,[content_type_id]
      ,[content_id]
      ,[enabled]
      ,[created]
      ,[modified]
  FROM [verticalplatform].[dbo].[rapid_deleted_master_data]

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetRapidDeletedMasterDataBatch TO VpWebApp 
GO



-----------'dbo.adminProduct_DeleteRapidDeletedMasterDataBatch'--------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteRapidDeletedMasterDataBatch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteRapidDeletedMasterDataBatch
	@ids varchar(max)
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

  DELETE
  FROM [verticalplatform].[dbo].[rapid_deleted_master_data]
  WHERE [deleted_content_id] in (SELECT [value] FROM Global_Split(@ids, ','))

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteRapidDeletedMasterDataBatch TO VpWebApp 
GO

-----------'dbo.adminLocation_AddRapidDeletedMasterData'--------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminLocation_AddRapidDeletedMasterData'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminLocation_AddRapidDeletedMasterData
	@contentId int,
	@contentTypeId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()
INSERT INTO [dbo].[rapid_deleted_master_data]
           ([content_type_id]
           ,[content_id]
           ,[enabled]
           ,[created]
           ,[modified])
	VALUES (@contentTypeId, @contentId, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminLocation_AddRapidDeletedMasterData TO VpWebApp 
GO
