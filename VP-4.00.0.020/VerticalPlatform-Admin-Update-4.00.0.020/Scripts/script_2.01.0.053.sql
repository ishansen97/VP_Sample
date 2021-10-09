INSERT INTO [dbo].[master_data_sync_content_type]
           (
		   [master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (
		   'Region'
           ,1
           ,getdate()
           ,getdate()
		   )

INSERT INTO [dbo].[master_data_sync_content_type]
           (
		   [master_data_sync_content_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (
		   'Currency'
           ,1
           ,getdate()
           ,getdate()
		   )