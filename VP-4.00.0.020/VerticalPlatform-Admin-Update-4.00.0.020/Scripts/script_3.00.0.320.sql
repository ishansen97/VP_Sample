IF NOT EXISTS (
  SELECT [parameter_type_id]
  FROM   [dbo].[parameter_type] 
  WHERE  [parameter_type] = 'ResetPasswordEmailHeader'
)
BEGIN


INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (217
           ,'ResetPasswordEmailHeader'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )

END
GO

IF NOT EXISTS (
  SELECT [parameter_type_id]
  FROM   [dbo].[parameter_type] 
  WHERE  [parameter_type] = 'ResetPasswordEmailBody'
)
BEGIN


INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (218
           ,'ResetPasswordEmailBody'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )

END
GO


IF NOT EXISTS (
  SELECT [parameter_type_id]
  FROM   [dbo].[parameter_type] 
  WHERE  [parameter_type] = 'ResetPasswordEmailSubjectHeader'
)
BEGIN


INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (219
           ,'ResetPasswordEmailSubjectHeader'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )

END
GO