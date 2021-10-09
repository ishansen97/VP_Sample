IF NOT EXISTS(SELECT * FROM [parameter_type] where [parameter_type]='FeaturedPlusWeightPercentage')
  BEGIN
  
	INSERT INTO parameter_type([parameter_type_id],[parameter_type],[enabled],[modified],[created])
    VALUES(200,'FeaturedPlusWeightPercentage',1,GETDATE(),GETDATE())	
  
  END