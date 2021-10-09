IF NOT EXISTS (
  SELECT [parameter_type_id]
  FROM   [dbo].[parameter_type] 
  WHERE  [parameter_type] = 'PageSpecificStyles'
)
BEGIN


INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (220
           ,'PageSpecificStyles'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )

END
GO

IF NOT EXISTS (
  SELECT [parameter_type_id]
  FROM   [dbo].[parameter_type] 
  WHERE  [parameter_type] = 'ApplyPageSpecificStylesOnly'
)
BEGIN


INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (221
           ,'ApplyPageSpecificStylesOnly'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )

END
GO

