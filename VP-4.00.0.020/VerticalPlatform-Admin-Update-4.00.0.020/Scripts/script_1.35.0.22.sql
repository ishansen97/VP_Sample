IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 148)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(148,'DisplayRatings','1',GETDATE(),GETDATE())
END