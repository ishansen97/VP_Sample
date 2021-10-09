IF NOT EXISTS(SELECT * FROM [module] where module_name='ContentSharing' AND usercontrol_name='~/Modules/Page/ContentSharing.ascx' )
BEGIN
	INSERT INTO [module]
           ([module_name]
           ,[usercontrol_name]
           ,[enabled]
           ,[modified]
           ,[created]
           ,[is_container])
     VALUES
           ('ContentSharing'
           ,'~/Modules/Page/ContentSharing.ascx'
           ,1
           ,GETDATE()
           ,GETDATE()
           ,0) 
END