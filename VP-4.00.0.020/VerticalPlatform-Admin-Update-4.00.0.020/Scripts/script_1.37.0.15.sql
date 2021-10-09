IF NOT EXISTS (SELECT * FROM parameter_type WHERE parameter_type = 'VendorProfileDisplayOptions' OR parameter_type_id = 179)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created]) 
	VALUES (179,'VendorProfileDisplayOptions',1,GETDATE(),GETDATE())
END
GO
-----------------------------------------------------------------------------------------------------------------------------------