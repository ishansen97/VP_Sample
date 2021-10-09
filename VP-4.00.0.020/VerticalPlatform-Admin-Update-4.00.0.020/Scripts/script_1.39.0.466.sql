

-- ==========================================================================
-- $Author: Akila Tharuka $
-- ========================================================================== 
 
 IF NOT EXISTS(SELECT * FROM [parameter_type] where [parameter_type]='ArticleCaption')
  BEGIN
  
	INSERT INTO parameter_type([parameter_type_id],[parameter_type],[enabled],[modified],[created])
    VALUES(195,'ArticleCaption',1,GETDATE(),GETDATE())	
  
  END