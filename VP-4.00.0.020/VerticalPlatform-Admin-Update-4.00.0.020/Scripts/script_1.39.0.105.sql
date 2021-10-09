IF NOT EXISTS (SELECT * FROM application_setting WHERE NAME = 'SchedularServiceSpawnTaskStatus')
BEGIN
	INSERT INTO [application_setting]
           ([name],[value],[enabled],[modified],[created])
     VALUES
           ('SchedularServiceSpawnTaskStatus','True',1,GETDATE(),GETDATE())
END
GO
---------------------------------------------------------------------------------------------------