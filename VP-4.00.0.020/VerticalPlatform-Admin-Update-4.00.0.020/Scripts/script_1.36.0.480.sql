IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'EnableAutoPlayingVideoArticles' AND parameter_type_id = 166)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(166,'EnableAutoPlayingVideoArticles','1',GETDATE(),GETDATE())
END
GO