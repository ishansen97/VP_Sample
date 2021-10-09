IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'EnableVendorCompression' AND parameter_type_id = 158)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(158,'EnableVendorCompression','1',GETDATE(),GETDATE())
END

GO

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'VendorCompressionExpandCount' AND parameter_type_id = 159)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(159,'VendorCompressionExpandCount','1',GETDATE(),GETDATE())
END

GO

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'VendorCompressionInitialCount' AND parameter_type_id = 160)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(160,'VendorCompressionInitialCount','1',GETDATE(),GETDATE())
END

GO

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'VendorCompressionPageSize' AND parameter_type_id = 161)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(161,'VendorCompressionPageSize','1',GETDATE(),GETDATE())
END

GO