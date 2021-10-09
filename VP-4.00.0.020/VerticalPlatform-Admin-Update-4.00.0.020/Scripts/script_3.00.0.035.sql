
IF NOT EXISTS (SELECT * FROM subsystem WHERE name = 'Rapid')
BEGIN
	INSERT INTO subsystem (subsystem_id,[name],enabled,modified,created)
	VALUES (24, 'Rapid', 1, GETDATE(), GETDATE())
END
GO

IF NOT EXISTS (SELECT [subsystem_id],[operation_id] FROM subsystem_operation WHERE [subsystem_id] = 24 and [operation_id] = 1)
BEGIN
	INSERT INTO [subsystem_operation]
           ([subsystem_id],[operation_id],[enabled],[created],[modified])
     VALUES
           (24,1,1,GETDATE(),GETDATE());
END

IF NOT EXISTS (SELECT [subsystem_id],[operation_id] FROM subsystem_operation WHERE [subsystem_id] = 24 and [operation_id] = 2)
BEGIN
	INSERT INTO [subsystem_operation]
           ([subsystem_id],[operation_id],[enabled],[created],[modified])
     VALUES
           (24,2,1,GETDATE(),GETDATE());
END

IF NOT EXISTS (SELECT [subsystem_id],[operation_id] FROM subsystem_operation WHERE [subsystem_id] = 24 and [operation_id] = 3)
BEGIN
	INSERT INTO [subsystem_operation]
           ([subsystem_id],[operation_id],[enabled],[created],[modified])
     VALUES
           (24,3,1,GETDATE(),GETDATE());
END

IF NOT EXISTS (SELECT [subsystem_id],[operation_id] FROM subsystem_operation WHERE [subsystem_id] = 24 and [operation_id] = 4)
BEGIN
	INSERT INTO [subsystem_operation]
           ([subsystem_id],[operation_id],[enabled],[created],[modified])
     VALUES
           (24,4,1,GETDATE(),GETDATE());
END
