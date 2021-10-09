-----Insert default author profile settings-------
DECLARE @module_instance_id int
  
DECLARE authorDisplaySettings_cursor 
CURSOR FOR 
    
SELECT [module_instance_id]  
FROM [dbo].[module_instance]
where module_id = 5952   and  [module_instance_id] not in 
(select [module_instance_id] from [dbo].[module_instance_setting] where [name]='AuthorProfileAuthorDisplaySettings' )
order by [module_instance_id]  
  
OPEN authorDisplaySettings_cursor    
  
FETCH NEXT FROM authorDisplaySettings_cursor     
INTO  @module_instance_id
  
WHILE @@FETCH_STATUS = 0    
BEGIN    
    insert into [dbo].[module_instance_setting] 
      ([module_instance_id]
      ,[name]
      ,[value]
      ,[enabled]
      ,[modified]
      ,[created])
values (@module_instance_id, 'AuthorProfileAuthorDisplaySettings', '5|true|1,1|true|2,2|true|3,7|true|4', 1, GETDATE(), GETDATE()) 
      
FETCH NEXT FROM authorDisplaySettings_cursor     
INTO @module_instance_id    
   
END     
CLOSE authorDisplaySettings_cursor;    
DEALLOCATE authorDisplaySettings_cursor;