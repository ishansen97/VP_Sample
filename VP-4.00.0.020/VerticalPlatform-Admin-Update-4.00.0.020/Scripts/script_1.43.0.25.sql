

-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
IF NOT EXISTS(SELECT * FROM [parameter_type] where [parameter_type]='MatrixImageToSupplierPage')
  BEGIN
  
	INSERT INTO parameter_type([parameter_type_id],[parameter_type],[enabled],[modified],[created])
    VALUES(199,'MatrixImageToSupplierPage',1,GETDATE(),GETDATE())	
  
  END

----------------------------------------------------------------------------------------------------