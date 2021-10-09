IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssis_task_log]') AND type in (N'U'))
BEGIN
	CREATE TABLE dbo.[ssis_task_log](
		[ssis_task_log_id] [int] IDENTITY(1,1) NOT NULL,
		[task_id] [int] NOT NULL,
		[error_code] [int] NOT NULL,
		[error_description] [nvarchar](MAX) NOT NULL,
		[enabled] [bit] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[is_completed] [bit] NOT NULL,
	 CONSTRAINT [PK_ssis_task_log] PRIMARY KEY CLUSTERED 
	(
		[ssis_task_log_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO