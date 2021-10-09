IF NOT EXISTS
(
    SELECT [name]
    FROM sys.tables
    WHERE [name] = 'category_enabled_status_log'
)
BEGIN
    CREATE TABLE [dbo].[category_enabled_status_log]
    (
        [category_status_log_id] [INT] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
        [category_id] [INT] NOT NULL,
        [original_status] [BIT] NULL,
        [updated_status] [BIT] NULL,
		[user_updated] VARCHAR(100) NULL,
        [created] [SMALLDATETIME] NOT NULL
    );
END;
GO


IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE [name] = N'trg_categoty_enabled_update'
          AND [type] = 'TR'
)
BEGIN
    DROP TRIGGER [dbo].[trg_categoty_enabled_update];
END;
GO

CREATE TRIGGER [dbo].[trg_categoty_enabled_update]
ON [dbo].[category]
AFTER UPDATE
AS
IF (UPDATE([enabled]))
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for trigger here

    INSERT INTO dbo.category_enabled_status_log
    (
        category_id,
        original_status,
        updated_status,
		user_updated,
        created
    )
    SELECT ts.category_id,
           ts.enabled,
           ins.enabled,
		   USER_NAME(),
           GETDATE()
    FROM Inserted ins
        INNER JOIN Deleted ts
            ON ts.category_id = ins.category_id
    WHERE ins.category_id = ts.category_id;

END;

GO
