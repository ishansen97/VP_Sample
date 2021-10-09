-------------------Rapid master data deleted table-----------

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'master_data_sync_content_type')
BEGIN

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[master_data_sync_content_type](
	[master_data_sync_content_type_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[master_data_sync_content_type] [varchar](50) NOT NULL,
	[enabled] [bit] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	[created] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_master_data_sync_content_type] PRIMARY KEY CLUSTERED 
(
	[master_data_sync_content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[master_data_sync_content_type] ADD  CONSTRAINT [DF_master_data_sync_content_type_enabled]  DEFAULT ((1)) FOR [enabled]

ALTER TABLE [dbo].[master_data_sync_content_type] ADD  CONSTRAINT [DF_master_data_sync_content_type_modified]  DEFAULT (getutcdate()) FOR [modified]

ALTER TABLE [dbo].[master_data_sync_content_type] ADD  CONSTRAINT [DF_master_data_sync_content_type_created]  DEFAULT (getutcdate()) FOR [created]

SET IDENTITY_INSERT [dbo].[master_data_sync_content_type] ON;

INSERT INTO [dbo].[master_data_sync_content_type]
           ([master_data_sync_content_type_id]
		   ,[master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (0
		   ,'None'
           ,1
           ,getdate()
           ,getdate()
		   )

INSERT INTO [dbo].[master_data_sync_content_type]
           ([master_data_sync_content_type_id]
		   ,[master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (1
		   ,'ContentLocation'
           ,1
           ,getdate()
           ,getdate()
		   )

INSERT INTO [dbo].[master_data_sync_content_type]
           ([master_data_sync_content_type_id]
		   ,[master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (2
		   ,'SearchGroup'
           ,1
           ,getdate()
           ,getdate()
		   )

INSERT INTO [dbo].[master_data_sync_content_type]
           ([master_data_sync_content_type_id]
		   ,[master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (3
		   ,'SearchOption'
           ,1
           ,getdate()
           ,getdate()
		   )

INSERT INTO [dbo].[master_data_sync_content_type]
           ([master_data_sync_content_type_id]
		   ,[master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (4
		   ,'VendorCurrencyLocation'
           ,1
           ,getdate()
           ,getdate()
		   )

INSERT INTO [dbo].[master_data_sync_content_type]
           ([master_data_sync_content_type_id]
		   ,[master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (5
		   ,'VendorSettingTemplate'
           ,1
           ,getdate()
           ,getdate()
		   )

SET IDENTITY_INSERT [dbo].[master_data_sync_content_type] OFF;
END



ALTER TABLE [dbo].rapid_deleted_master_data DROP CONSTRAINT [FK_rapid_deleted_master_data_to_content_type]
Go

ALTER TABLE [dbo].[rapid_deleted_master_data]  WITH NOCHECK ADD  CONSTRAINT [FK_rapid_deleted_master_data_to_content_type] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[master_data_sync_content_type]([master_data_sync_content_type_id])

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

SELECT TOP (@batchSize) [deleted_content_id] as id
      ,[content_type_id]
      ,[content_id]
      ,[enabled]
      ,[created]
      ,[modified]
  FROM [dbo].[rapid_deleted_master_data]

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
  FROM [dbo].[rapid_deleted_master_data]
  WHERE [deleted_content_id] in (SELECT [value] FROM Global_Split(@ids, ','))

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteRapidDeletedMasterDataBatch TO VpWebApp 
GO





