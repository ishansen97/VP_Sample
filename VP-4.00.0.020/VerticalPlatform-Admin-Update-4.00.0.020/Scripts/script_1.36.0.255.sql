IF NOT EXISTS(SELECT [name] FROM sys.tables where [name] = 'SSIS_article_details')
BEGIN
CREATE TABLE [dbo].[SSIS_article_details](
	[SSIS_article_id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[article_type_id] [int] NULL,
	[site_id] [int] NULL,
	[article_title] [varchar](1000) NULL,
	[article_summary] [varchar](max) NULL,
	[article_short_title] [varchar](1000) NULL,
	[featured_identifier] [int] NULL,
	[article_template_id] [int] NULL,
	[date_published] [smalldatetime] NULL,
	[url] [varchar](max) NULL,
	[task_id] [int] NULL,
	[legacy_article_id] [int] NULL,
	[source_file_path] [varchar](max) NULL
);
END
GO

IF NOT EXISTS(SELECT [name] FROM sys.tables where [name] = 'SSIS_article_custom_property')
BEGIN
CREATE TABLE [dbo].[SSIS_article_custom_property](
	[SSIS_article_custom_property_id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SSIS_article_id] [int] NULL,
	[custom_property_id] [int] NULL,
	[custom_property_value] [varchar](max) NULL,
);
END
GO