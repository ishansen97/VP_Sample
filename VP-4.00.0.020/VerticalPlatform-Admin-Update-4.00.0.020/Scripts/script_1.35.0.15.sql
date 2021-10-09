IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[form]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[form](
	[form_id] [int] IDENTITY(1,1) NOT NULL,
	[site_id] [int] NULL,
	[content_type_id] [int] NULL,
	[content_id] [int] NULL,
	[saved_as_xml] [bit] NOT NULL,
	[definition] [nvarchar](max) NOT NULL,
	[name] [varchar](100) NULL,
	[enabled] [bit] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	CONSTRAINT [PK_form] PRIMARY KEY CLUSTERED 
	(
		[form_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

END
GO
-------------------------------------------------------------------------
BEGIN TRY 
	BEGIN TRANSACTION 
		DECLARE @predefinedPageId int
		DECLARE @reviewFormListModuleId int
		DECLARE @pageContentTypeId int

		SET @predefinedPageId = NULL
		SET @reviewFormListModuleId = NULL
		SET @pageContentTypeId = (SELECT content_type_id FROM content_type WHERE content_type = 'Page')
		
		IF NOT EXISTS (SELECT * FROM [predefined_page] WHERE page_name = 'ReviewTypeList')
		BEGIN
			INSERT INTO [predefined_page] (page_name, enabled, modified, created)
			VALUES ('ReviewTypeList', 1, GETDATE(), GETDATE())

			SET @predefinedPageId = @@IDENTITY
		END

		IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'ReviewTypeList')
		BEGIN
			INSERT INTO module ([module_name], [usercontrol_name], [enabled], [modified], [created], [is_container])
			VALUES('ReviewTypeList','~/Modules/Reviews/ReviewTypeList.ascx','1',GETDATE(),GETDATE(), 0)

			SET @reviewFormListModuleId = @@IDENTITY
		END

		IF ((@predefinedPageId IS NOT NULL) AND (@reviewFormListModuleId IS NOT NULL))
		BEGIN
			INSERT INTO [predefined_page_module] ([predefined_page_id],[module_id],[enabled],[modified],[created])
			VALUES (@predefinedPageId, @reviewFormListModuleId, 1, GETDATE(), GETDATE())

			--Insert the page for each site and the related modules
			DECLARE @siteId int
			DECLARE @pageId int
			DECLARE @sortOrder int
			DECLARE @primaryContainerId int
			DECLARE @primaryContainerModuleInstanceId int

			IF NOT EXISTS(SELECT * FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1')
			BEGIN
				INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
				VALUES ('PrimaryContainer', '~/Containers/PrimaryContainer/PrimaryContainer.ascx',
						'1', GETDATE(), GETDATE(), '1')
				SET @primaryContainerId = SCOPE_IDENTITY();
			END
			ELSE
			BEGIN
				SELECT @primaryContainerId = module_id FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1'
			END
			
			DECLARE siteCursor CURSOR 
			FOR (SELECT site_id FROM site)
			OPEN siteCursor
			FETCH NEXT FROM siteCursor INTO @siteId
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT top(1) @sortOrder = [sort_order] 
					FROM [page]
					WHERE site_id = @siteId
					ORDER BY sort_order DESC
				
					--Insert the site pages
					INSERT INTO [page] ([site_id], [predefined_page_id], [parent_page_id], [page_name], [page_title], 
						[keywords], [template_name], [sort_order], [navigable], [hidden], [log_in_to_view], [enabled], 
						[modified], [created], [page_title_prefix], [page_title_suffix], [description_prefix], 
						[description_suffix], [navigation_title], [default_title_prefix])
					VALUES (@siteId, @predefinedPageId, NULL, 'ReviewTypeList', 'Review Type List', '', '~/Templates/TwoColumnLayout/TwoColumnLayout.ascx',
						(@sortOrder + 1), 0, 0, 0, 1, GETDATE(), GETDATE(), '', '', '', '', 'Review Type List', '')
					   
					SET @pageId = @@IDENTITY
					
					--Formating page name
					DECLARE @formatedPageName varchar(255)
					EXEC dbo.global_FormatUrl 'ReviewTypeList', @formatedPageName output

					--Creating site page url
					DECLARE @url varchar(255)
					SET @url = '/' + CONVERT(varchar(10), @pageId) + '-' + @formatedPageName + '/'

					INSERT INTO [fixed_url] ([fixed_url], [site_id], [page_id], [content_type_id], [content_id], 
						[query_string], [enabled], [created], [modified])
					VALUES (@url, @siteId, @pageId, @pageContentTypeId, @pageId, '', 1, GETDATE(), GETDATE())

					-- Insert the module instances
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @primaryContainerId, 'Primary Container', 'contentPane', 1, 1, GETDATE(), GETDATE(), NULL, @siteId, 
						NULL, NULL)
					
					SET @primaryContainerModuleInstanceId = @@IDENTITY
					
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @reviewFormListModuleId, 'Review Type List', 'contentPane', 1, 1, GETDATE(), GETDATE(), 
						NULL, @siteId, NULL, @primaryContainerModuleInstanceId)

					FETCH NEXT FROM siteCursor INTO @siteId			
				END
			CLOSE siteCursor
			DEALLOCATE siteCursor
		END
		
    COMMIT TRAN 
	
END TRY
BEGIN CATCH
    ROLLBACK TRAN
	
	IF (CURSOR_STATUS('global','siteCursor') > 0)
		BEGIN
			CLOSE siteCursor
			DEALLOCATE siteCursor			
		END
	PRINT ERROR_MESSAGE()
	
END CATCH

GO

---------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN TRY 
	BEGIN TRANSACTION 
		DECLARE @predefinedPageId int
		DECLARE @reviewFormModuleId int
		DECLARE @pageContentTypeId int

		SET @predefinedPageId = NULL
		SET @reviewFormModuleId = NULL
		SET @pageContentTypeId = (SELECT content_type_id FROM content_type WHERE content_type = 'Page')
		
		IF NOT EXISTS (SELECT * FROM [predefined_page] WHERE page_name = 'ReviewForm')
		BEGIN
			INSERT INTO [predefined_page] (page_name, enabled, modified, created)
			VALUES ('ReviewForm', 1, GETDATE(), GETDATE())

			SET @predefinedPageId = @@IDENTITY
		END

		IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'ReviewForm')
		BEGIN
			INSERT INTO module ([module_name], [usercontrol_name], [enabled], [modified], [created], [is_container])
			VALUES('ReviewForm','~/Modules/Reviews/ReviewForm.ascx','1',GETDATE(),GETDATE(), 0)

			SET @reviewFormModuleId = @@IDENTITY
		END

		IF ((@predefinedPageId IS NOT NULL) AND (@reviewFormModuleId IS NOT NULL))
		BEGIN
			INSERT INTO [predefined_page_module] ([predefined_page_id],[module_id],[enabled],[modified],[created])
			VALUES (@predefinedPageId, @reviewFormModuleId, 1, GETDATE(), GETDATE())

			--Insert the page for each site and the related modules
			DECLARE @siteId int
			DECLARE @pageId int
			DECLARE @sortOrder int
			DECLARE @primaryContainerId int
			DECLARE @primaryContainerModuleInstanceId int

			IF NOT EXISTS(SELECT * FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1')
			BEGIN
				INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
				VALUES ('PrimaryContainer', '~/Containers/PrimaryContainer/PrimaryContainer.ascx',
						'1', GETDATE(), GETDATE(), '1')
				SET @primaryContainerId = SCOPE_IDENTITY();
			END
			ELSE
			BEGIN
				SELECT @primaryContainerId = module_id FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1'
			END
			
			DECLARE siteCursor CURSOR 
			FOR (SELECT site_id FROM site)
			OPEN siteCursor
			FETCH NEXT FROM siteCursor INTO @siteId
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT top(1) @sortOrder = [sort_order] 
					FROM [page]
					WHERE site_id = @siteId
					ORDER BY sort_order DESC
				
					--Insert the site pages
					INSERT INTO [page] ([site_id], [predefined_page_id], [parent_page_id], [page_name], [page_title], 
						[keywords], [template_name], [sort_order], [navigable], [hidden], [log_in_to_view], [enabled], 
						[modified], [created], [page_title_prefix], [page_title_suffix], [description_prefix], 
						[description_suffix], [navigation_title], [default_title_prefix])
					VALUES (@siteId, @predefinedPageId, NULL, 'ReviewForm', 'Review Form', '', '~/Templates/TwoColumnLayout/TwoColumnLayout.ascx',
						(@sortOrder + 1), 0, 0, 0, 1, GETDATE(), GETDATE(), '', '', '', '', 'Review Form', '')
					   
					SET @pageId = @@IDENTITY
					
					--Formating page name
					DECLARE @formatedPageName varchar(255)
					EXEC dbo.global_FormatUrl 'ReviewForm', @formatedPageName output

					--Creating site page url
					DECLARE @url varchar(255)
					SET @url = '/' + CONVERT(varchar(10), @pageId) + '-' + @formatedPageName + '/'

					INSERT INTO [fixed_url] ([fixed_url], [site_id], [page_id], [content_type_id], [content_id], 
						[query_string], [enabled], [created], [modified])
					VALUES (@url, @siteId, @pageId, @pageContentTypeId, @pageId, '', 1, GETDATE(), GETDATE())

					-- Insert the module instances
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @primaryContainerId, 'Primary Container', 'contentPane', 1, 1, GETDATE(), GETDATE(), NULL, @siteId, 
						NULL, NULL)
					
					SET @primaryContainerModuleInstanceId = @@IDENTITY
					
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @reviewFormModuleId, 'Review Form', 'contentPane', 1, 1, GETDATE(), GETDATE(), 
						NULL, @siteId, NULL, @primaryContainerModuleInstanceId)

					FETCH NEXT FROM siteCursor INTO @siteId			
				END
			CLOSE siteCursor
			DEALLOCATE siteCursor
		END
		
    COMMIT TRAN 
	
END TRY
BEGIN CATCH
    ROLLBACK TRAN
	
	IF (CURSOR_STATUS('global','siteCursor') > 0)
		BEGIN
			CLOSE siteCursor
			DEALLOCATE siteCursor			
		END
	PRINT ERROR_MESSAGE()
	
END CATCH
GO
---------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM article_resource_type WHERE type_name = 'Rating')
BEGIN
	INSERT INTO article_resource_type
		VALUES(18, 'Rating', 1, GETDATE(), GETDATE())
END
GO
----------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM content_type WHERE content_type = 'ReviewType')
BEGIN
 INSERT INTO content_type (content_type_id, content_type, enabled, modified, created)
 VALUES (37, 'ReviewType', 1, GETDATE(), GETDATE())
END
GO
----------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM field_type WHERE [type] = 'FileUpload')
BEGIN
	INSERT INTO field_type (field_type_id, [type], [enabled], created, modified)
	VALUES (16, 'FileUpload', 1, GETDATE(), GETDATE())
END
GO

IF NOT EXISTS (SELECT * FROM field_type WHERE [type] = 'Rating')
BEGIN
	INSERT INTO field_type (field_type_id, [type], [enabled], created, modified)
	VALUES (17, 'Rating', 1, GETDATE(), GETDATE())
END
GO

IF NOT EXISTS (SELECT * FROM field_type WHERE [type] = 'ContentPicker')
BEGIN
	INSERT INTO field_type (field_type_id, [type], [enabled], created, modified)
	VALUES (18, 'ContentPicker', 1, GETDATE(), GETDATE())
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[review_type]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[review_type](
	[review_type_id] [int] IDENTITY(1,1) NOT NULL,
	[has_image] [bit] NOT NULL,
	[article_type_id] [int] NOT NULL,
	[name] [varchar](250) NOT NULL,
	[title] [varchar](250) NOT NULL,
	[description] [varchar](MAX) NOT NULL,
	[enabled] [bit] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[definition] [varchar] (MAX) NULL,
	[site_id] [int] NOT NULL,
 CONSTRAINT [PK_review_type] PRIMARY KEY CLUSTERED 
(
	[review_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT OBJECT_NAME(constid) FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_review_type_modified' )
BEGIN
ALTER TABLE [dbo].[review_type] ADD  CONSTRAINT [DF_review_type_modified]  DEFAULT (getutcdate()) FOR [modified]
END
GO

IF NOT EXISTS (SELECT OBJECT_NAME(constid) FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_review_type_created' )
BEGIN
ALTER TABLE [dbo].[review_type] ADD  CONSTRAINT [DF_review_type_created]  DEFAULT (getutcdate()) FOR [created]
END
GO
--ALTER TABLE [dbo].[review_type] ADD  CONSTRAINT [DF_review_type_definition]  DEFAULT '' FOR [definition]
--GO



---------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_DeleteReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_DeleteReviewType]
	 @id int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM [review_type]
	WHERE [review_type_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminReviewType_DeleteReviewType TO VpWebApp 
GO
------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_AddReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_AddReviewType]
	@id int output,
	@siteId int,
	@articleTypeId int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@hasImage bit,
	@created smalldatetime output,
	@definition varchar(MAX),
	@description varchar(MAX)
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [review_type] (site_id, article_type_id, name, title, [enabled], modified, created, has_image, [description],[definition])
	VALUES (@siteId, @articleTypeId, @name, @title, @enabled, @created, @created, @hasImage, @description,@definition)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminReviewType_AddReviewType TO VpWebApp 
GO
-----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_UpdateReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_UpdateReviewType]
	@id int,
	@siteId int,
	@articleTypeId int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@hasImage bit,
	@definition varchar(MAX),
	@description varchar(MAX)
	 
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[review_type]
	SET site_id = @siteId,
		article_type_id = @articleTypeId,
		[name] = @name,
		title = @title,
		[enabled] = @enabled,		
		modified = @modified,
		has_image = @hasImage,
		[definition] = @definition,
		[description] = @description
	WHERE review_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminReviewType_UpdateReviewType TO VpWebApp 
GO
--------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicReviewType_GetReviewTypeDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[definition]
	FROM [review_type]	
	WHERE review_type_id = @id 

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetail TO VpWebApp 
GO
-----------------------

--------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteId
@siteId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[definition]
	FROM [review_type]	
	WHERE site_id = @siteId 

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteId TO VpWebApp 
GO
-----------------------
--------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId
@siteId int,@articleTypeId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[definition]
	FROM [review_type]	
	WHERE site_id = @siteId AND article_type_id = @articleTypeId

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId TO VpWebApp 
GO
-----------------------

IF NOT EXISTS (SELECT * FROM content_type WHERE content_type_id = 36)
BEGIN
	INSERT INTO content_type (content_type_id, content_type, enabled, modified, created)
	VALUES (36, 'ReviewType', 1, GETDATE(), GETDATE())
END
GO
---------------------------
--------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailByReviewTypeId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailByReviewTypeId
@siteId int,@reviewTypeId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[definition]
	FROM [review_type]	
	WHERE site_id = @siteId AND review_type_id = @reviewTypeId

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailByReviewTypeId TO VpWebApp 
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[content_rating]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[content_rating](
	[content_rating_id] [int] IDENTITY(1,1) NOT NULL,
	[content_type_id] [int] NOT NULL,
	[content_id] [int] NOT NULL,
	[rating] [decimal](3,2) NOT NULL,
	[enabled] [bit] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[site_id] [int] NOT NULL,
 CONSTRAINT [PK_content_rating] PRIMARY KEY CLUSTERED 
(
	[content_rating_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT OBJECT_NAME(constid) FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_content_rating_created' )
BEGIN
ALTER TABLE [dbo].[content_rating] ADD  CONSTRAINT [DF_content_rating_created]  DEFAULT (getutcdate()) FOR [created]
END
GO

IF NOT EXISTS (SELECT OBJECT_NAME(constid) FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_content_rating_modified' )
BEGIN
ALTER TABLE [dbo].[content_rating] ADD  CONSTRAINT [DF_content_rating_modified]  DEFAULT (getutcdate()) FOR [modified]
END
GO


-- -- -- -- -- -- -- -- -- -- -- --

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'email' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[author]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [dbo].author
	ADD email varchar(255)
END
GO
----

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddAuthor'
GO
CREATE PROCEDURE [dbo].[adminArticle_AddAuthor]
	@siteId int,
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@organization varchar(250),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@email varchar(255)
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO author(site_id,first_name, last_name, title, organization, position, department, profile_html, [enabled], created, modified, has_image,email)
	VALUES (@siteId,@firstName, @lastName, @title, @organization,@position,@department, @profileHtml, @enabled, @created, @created, @hasImage,@email)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddAuthor TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateAuthor'
GO
CREATE PROCEDURE [dbo].[adminArticle_UpdateAuthor]
	@id int,
	@siteId int, 
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@organization varchar(250),	
	@modified smalldatetime output,
	@email varchar(255)
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.author
	SET site_id = @siteId,
		first_name =@firstName,
		last_name = @lastName,
		title = @title,
		position = @position,
		department = @department, 
		profile_html = @profileHtml, 
		enabled = @enabled,
		organization = @organization,
		modified = @modified,
		has_image = @hasImage,
		email = @email
	WHERE author_id = @id

END
GO
GRANT EXECUTE ON dbo.adminArticle_UpdateAuthor TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorDetail'
GO
CREATE PROCEDURE [dbo].[publicArticle_GetAuthorDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, department, profile_html, has_image, enabled, created, modified,email
	FROM author	
	WHERE author_id = @id 

END
GO
GRANT EXECUTE ON dbo.publicArticle_GetAuthorDetail TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteId'
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsBySiteId]
	@siteId int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, enabled, created, modified, has_image,email
	FROM author
	WHERE site_id = @siteId
	ORDER BY  first_name, last_name

END
GO
GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteId TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorsByArticleId'
GO
CREATE PROCEDURE [dbo].[publicArticle_GetAuthorsByArticleId]
	@articleId int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT aut.author_id as id, aut.site_id, aut.first_name, aut.last_name, aut.title, aut.organization
			, aut.position, aut.department, aut.profile_html, aut.enabled, aut.created, aut.modified, aut.has_image,aut.email
	FROM author aut
		INNER JOIN article_to_author ata
			ON ata.author_id= aut.author_id 
	
	WHERE ata.article_id = @articleId
	ORDER BY ata.article_to_author_id 

END
GO
GRANT EXECUTE ON dbo.publicArticle_GetAuthorsByArticleId TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList'
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList]  
 @siteId int,  
 @startRowIndex int,  
 @endRowIndex int,  
 @totalRowCount int output  
AS  
-- ==========================================================================  
-- $Author: Nilanka $  
-- ==========================================================================  
BEGIN  
   
 SET NOCOUNT ON;  
  
 WITH AuthorList AS  
 (  
  SELECT author_id as id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id, has_image,email  
  FROM author  
  WHERE site_id = @siteId   
 )  
  
 SELECT id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, has_image,email 
 FROM AuthorList  
 WHERE row_id BETWEEN @startRowIndex AND @endRowIndex  
  
 SELECT @totalRowCount = COUNT(*)  
 FROM author  
 WHERE site_id = @siteId   
  
END  
GO
GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList'
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList]
	@siteId int,
	@authorId int = NULL,
	@firstName varchar(100) = NULL,
	@lastName varchar(100)	= NULL,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH AuthorList AS
	(
		SELECT author_id as id, site_id, first_name, last_name, title, organization, position, has_image,email,
				department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id
		FROM author
		WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')
	)

	SELECT id, site_id, first_name, last_name, title, organization, position, department, profile_html, enabled, created, modified, has_image,email
	FROM AuthorList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(*)
	FROM author
	WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')

END
GO
GRANT EXECUTE ON dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorInformationsByArticleIdsList'
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorInformationsByArticleIdsList]
	@articleIds varchar(max)
AS
-- ==========================================================================
-- $Author: Nilanka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, a.enabled, a.created, a.modified, aa.article_id, a.has_image,a.email
	FROM author a
		INNER JOIN article_to_author aa ON  a.author_id = aa.author_id
	WHERE aa.article_id IN (SELECT [value] FROM Global_Split(@articleIds, ',') )

END
GO
GRANT EXECUTE ON dbo.adminArticle_GetAuthorInformationsByArticleIdsList TO VpWebApp 
GO

-- -- -- -- -- -- -- -- -- -- -- -- -- --
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'gift_card_id' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[article_to_author]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [dbo].article_to_author
	ADD gift_card_id varchar(255)
END
GO

---
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleToAuthorDetail'
GO
CREATE PROCEDURE [dbo].[publicArticle_GetArticleToAuthorDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_to_author_id as id, article_id, author_id, enabled, created, modified, gift_card_id
	FROM article_to_author	
	WHERE article_to_author_id = @id 

END
GO
GRANT EXECUTE ON dbo.publicArticle_GetArticleToAuthorDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleToAuthor'
GO
CREATE PROCEDURE [dbo].[adminArticle_AddArticleToAuthor]
	@articleId int,
	@authorId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@giftCardId varchar(255)
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO article_to_author(article_id, author_id, [enabled], created, modified,gift_card_id)
	VALUES (@articleId, @authorId, @enabled, @created, @created ,@giftCardId)

	SET @id = SCOPE_IDENTITY()

END
GO
GRANT EXECUTE ON dbo.adminArticle_AddArticleToAuthor TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorByArticleIdAuthorId'
GO
CREATE PROCEDURE [adminArticle_GetAuthorByArticleIdAuthorId]
@articleId int,@authorId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

SELECT [article_to_author_id] as id
      ,[article_id]
      ,[author_id]
      ,[enabled]
      ,[created]
      ,[modified]
      ,[gift_card_id]
  FROM [article_to_author]
  WHERE article_id =@articleId AND author_id = @authorId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorByArticleIdAuthorId TO VpWebApp 
GO

-------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleToAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleToAuthor
	@id int,
	@articleId int,
	@authorId int,
	@enabled bit,	
	@modified smalldatetime output,
	@giftCardId varchar(255)	
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	
	UPDATE article_to_author
		SET article_id = @articleId,
			author_id = @authorId,
			enabled = @enabled,
			modified = @modified,
			gift_card_id = @giftCardId
	WHERE article_to_author_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleToAuthor TO VpWebApp 
GO

---------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsByArticleId'
GO
CREATE PROCEDURE [adminArticle_GetAuthorsByArticleId]
@articleId int
	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

SELECT [article_to_author_id] as id
      ,[article_id]
      ,[author_id]
      ,[enabled]
      ,[created]
      ,[modified]
      ,[gift_card_id]
  FROM [article_to_author]
  WHERE article_id =@articleId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsByArticleId TO VpWebApp 
GO
--------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdSiteId
	@siteId int,
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT content_rating_id AS id, content_type_id, content_id, rating, enabled, modified, created, site_id
	FROM content_rating
	WHERE content_type_id = @contentTypeId 
		AND content_id = @contentId
		AND site_id = @siteId
		
END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdSiteId TO VpWebApp 
GO
------------------------------------------------

---------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_DeleteContentRating'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminContentRating_DeleteContentRating]
	 @id int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM content_rating
	WHERE [content_rating_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminContentRating_DeleteContentRating TO VpWebApp 
GO


------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_AddContentRating'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminContentRating_AddContentRating]
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@rating decimal(3, 2),
	@created smalldatetime output,
	@enabled bit
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()
	
INSERT INTO [dbo].[content_rating]
           ([content_type_id]
           ,[content_id]
           ,[rating]
           ,[enabled]
           ,[modified]
           ,[created]
           ,[site_id])
     VALUES
      (@contentTypeId, @contentId, @rating, @enabled, @created, @created,@siteId)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminContentRating_AddContentRating TO VpWebApp 
GO
-----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_UpdateContentRating'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminContentRating_UpdateContentRating]
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@rating decimal(3, 2),
	@modified smalldatetime output,
	@enabled bit
	 
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[content_rating]
	SET site_id = @siteId,
		[content_type_id] = @contentTypeId,
		[content_id] = @contentId,
		[rating] = @rating,
		[enabled] = @enabled,		
		modified = @modified
		
	WHERE content_rating_id = @id

END
GO

GRANT EXECUTE ON dbo.adminContentRating_UpdateContentRating TO VpWebApp 
GO
--------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicContentRating_GetContentRatingDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicContentRating_GetContentRatingDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [content_rating_id] as id
      ,[content_type_id]
      ,[content_id]
      ,[rating]
      ,[enabled]
      ,[modified]
      ,[created]
      ,[site_id]
  FROM [content_rating]	
	WHERE [content_rating_id] = @id 

END
GO
GRANT EXECUTE ON dbo.publicContentRating_GetContentRatingDetail TO VpWebApp 
GO

-- -- -- -- -- -- -- -- -- -- -- -- -- --
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'section_name' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[article_section]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [dbo].article_section
	ADD section_name varchar(max)
END
GO

-------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleSection'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticleSection
	@id int output,
	@articleId int,
	@sectionTitle varchar(100),
	@pageNumber int,
	@isPopup bit,
	@sortOrder int,
	@created smalldatetime output, 
	@enabled bit,
	@previewImageTitle varchar(100),
	@previewImageCode varchar(255),
	@cssClass varchar(50),
	@templateSectionId int,
	@isTemplateSection bit,
	@toggleSection bit,
	@toggleText varchar(max),
	@sectionName varchar(max)
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO article_section (article_id, section_title, page_number,
		is_popup, sort_order, [enabled], modified, created, preview_image_title, preview_image_code,css_class,template_section_id,is_template_section, toggle_section, toggle_text, section_name)
	VALUES (@articleId, @sectionTitle, @pageNumber,
	@isPopup, @sortOrder, @enabled, @created, @created, @previewImageTitle, @previewImageCode,@cssClass,@templateSectionId,@isTemplateSection,@toggleSection,@toggleText, @sectionName)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticleSection TO VpWebApp 
GO

-------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleSectionDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleSectionDetail
	@id int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_section_id as id, article_id, section_title,
				is_popup, page_number, sort_order, preview_image_title, preview_image_code, css_class, 
				template_section_id,is_template_section , [enabled], modified, created, toggle_section, toggle_text, section_name
	FROM article_section
	WHERE article_section_id = @id

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleSectionDetail TO VpWebApp 
GO

--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleSection'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleSection
	@id int,
	@articleId int,
	@sectionTitle varchar(100),
	@pageNumber int,
	@isPopup bit,
	@sortOrder int,
	@enabled bit,
	@previewImageTitle varchar(100),
	@previewImageCode varchar(255),
	@cssClass varchar(50),
	@templateSectionId int,
	@isTemplateSection bit,
	@modified smalldatetime output,
	@toggleSection bit,
	@toggleText varchar(max),
	@sectionName varchar(max)
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE article_section
	SET
		article_id = @articleId,
		section_title = @sectionTitle,
		page_number = @pageNumber,
		is_popup = @isPopup,
		sort_order = @sortOrder,
		[enabled] = @enabled,
		preview_image_code = @previewImageCode,
		preview_image_title = @previewImageTitle,
		css_class = @cssClass,
		modified = @modified,
		template_section_id = @templateSectionId,
		is_template_section = @isTemplateSection,
		toggle_section = @toggleSection,
		toggle_text = @toggleText,
		section_name = @sectionName
	WHERE article_section_id = @id

END
GO

GRANT EXECUTE ON adminArticle_UpdateArticleSection TO VpWebApp
GO

-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleSectionByArticleIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleSectionByArticleIdList
	@articleId int
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_section_id AS id, article_id, section_title,
				is_popup, page_number, sort_order, preview_image_title, preview_image_code, css_class,template_section_id, is_template_section, 
				[enabled], modified, created, toggle_section, toggle_text, section_name
	FROM article_section
	WHERE article_id = @articleId
	ORDER BY page_number, sort_order

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleSectionByArticleIdList TO VpWebApp 
GO
--------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleSectionsByArticleIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleSectionsByArticleIds
	@articleIds VARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT article_section_id AS id, article_id, section_title,	is_popup, page_number, sort_order, preview_image_title,
		preview_image_code, css_class,template_section_id, is_template_section, [enabled], modified, created, toggle_section, toggle_text, section_name
	FROM article_section arti_sec
		INNER JOIN global_Split(@articleIds, ',') AS article_id_table
			ON arti_sec.article_id = article_id_table.[value]
	ORDER BY page_number, sort_order

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleSectionsByArticleIds TO VpWebApp 
GO
-------------------------------------------------------------------------

BEGIN TRY 
	BEGIN TRANSACTION 
		DECLARE @predefinedPageId int
		DECLARE @staticHTMLModuleId int
		DECLARE @pageContentTypeId int

		SET @predefinedPageId = NULL
		SET @pageContentTypeId = (SELECT content_type_id FROM content_type WHERE content_type = 'Page')
		SET @staticHTMLModuleId = (SELECT [module_id] FROM [module] WHERE [module_name] = 'StaticHtml')
		
		IF NOT EXISTS (SELECT * FROM [predefined_page] WHERE page_name = 'ReviewFormThankYou')
		BEGIN
			INSERT INTO [predefined_page] (page_name, enabled, modified, created)
			VALUES ('ReviewFormThankYou', 1, GETDATE(), GETDATE())

			SET @predefinedPageId = @@IDENTITY
		END

		IF ((@predefinedPageId IS NOT NULL) AND (@staticHTMLModuleId IS NOT NULL))
		BEGIN
			INSERT INTO [predefined_page_module] ([predefined_page_id],[module_id],[enabled],[modified],[created])
			VALUES (@predefinedPageId, @staticHTMLModuleId, 1, GETDATE(), GETDATE())
			
			--Insert the page for each site and the related modules
			DECLARE @siteId int
			DECLARE @pageId int
			DECLARE @sortOrder int
			DECLARE @primaryContainerId int
			DECLARE @primaryContainerModuleInstanceId int

			IF NOT EXISTS(SELECT * FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1')
			BEGIN
				INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
				VALUES ('PrimaryContainer', '~/Containers/PrimaryContainer/PrimaryContainer.ascx',
						'1', GETDATE(), GETDATE(), '1')
				SET @primaryContainerId = SCOPE_IDENTITY();
			END
			ELSE
			BEGIN
				SELECT @primaryContainerId = module_id FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1'
			END
			
			DECLARE siteCursor CURSOR 
			FOR (SELECT site_id FROM site)
			OPEN siteCursor
			FETCH NEXT FROM siteCursor INTO @siteId
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT top(1) @sortOrder = [sort_order] 
					FROM [page]
					WHERE site_id = @siteId
					ORDER BY sort_order DESC
				
					--Insert the site pages
					INSERT INTO [page] ([site_id], [predefined_page_id], [parent_page_id], [page_name], [page_title], 
						[keywords], [template_name], [sort_order], [navigable], [hidden], [log_in_to_view], [enabled], 
						[modified], [created], [page_title_prefix], [page_title_suffix], [description_prefix], 
						[description_suffix], [navigation_title], [default_title_prefix])
					VALUES (@siteId, @predefinedPageId, NULL, 'ReviewFormThankYou', 'Review Form Thank You', '', '~/Templates/TwoColumnLayout/TwoColumnLayout.ascx',
						(@sortOrder + 1), 0, 0, 0, 1, GETDATE(), GETDATE(), '', '', '', '', 'Review Form Thank You', '')
					   
					SET @pageId = @@IDENTITY
					
					--Formating page name
					DECLARE @formatedPageName varchar(255)
					EXEC dbo.global_FormatUrl 'ReviewFormThankYou', @formatedPageName output

					--Creating site page url
					DECLARE @url varchar(255)
					SET @url = '/' + CONVERT(varchar(10), @pageId) + '-' + @formatedPageName + '/'

					INSERT INTO [fixed_url] ([fixed_url], [site_id], [page_id], [content_type_id], [content_id], 
						[query_string], [enabled], [created], [modified])
					VALUES (@url, @siteId, @pageId, @pageContentTypeId, @pageId, '', 1, GETDATE(), GETDATE())

					-- Insert the module instances
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @primaryContainerId, 'Primary Container', 'contentPane', 1, 1, GETDATE(), GETDATE(), NULL, @siteId, 
						NULL, NULL)
						
					SET @primaryContainerModuleInstanceId = @@IDENTITY
					
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @staticHTMLModuleId, 'Static HTML', 'contentPane', 1, 1, GETDATE(), GETDATE(), 
						NULL, @siteId, NULL, @primaryContainerModuleInstanceId)

					FETCH NEXT FROM siteCursor INTO @siteId			
				END
			CLOSE siteCursor
			DEALLOCATE siteCursor
		END
		
    COMMIT TRAN 
	
END TRY
BEGIN CATCH
    ROLLBACK TRAN
	
	IF (CURSOR_STATUS('global','siteCursor') > 0)
		BEGIN
			CLOSE siteCursor
			DEALLOCATE siteCursor			
		END
	PRINT ERROR_MESSAGE()
	
END CATCH
-------------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'ReviewList')
BEGIN
	INSERT INTO module ([module_name], [usercontrol_name], [enabled], [modified], [created], [is_container])
	VALUES('ReviewList','~/Modules/Reviews/ReviewList.ascx','1',GETDATE(),GETDATE(), 0)
END
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------
GRANT SELECT ON dbo.review_type TO VpWebApp 
-------------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleByArticleIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleByArticleIdList
@articleIdList VARCHAR(MAX)
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_id] AS [Id],[article_type_id],[site_id],[article_title],[article_summary],[enabled],[modified],[created],[article_short_title]
      ,[is_article_template],[is_external],[featured_identifier],[thumbnail_image_code],[date_published],[external_url_id],[is_template]
      ,[article_template_id],[open_new_window],[end_date],[flag1],[flag2],[flag3],[flag4],[published],[start_date],[search_content_modified]
	FROM [article] a
		INNER JOIN global_split(@articleIdList, ',') AS articleIdList
			ON a.[article_id] = articleIdList.[value]

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleByArticleIdList TO VpWebApp 
------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductContentRatingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductContentRatingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	
	WITH temp_rating(row, product_id, average_rating) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY ctc.associated_content_id ASC) AS row, ctc.associated_content_id AS product_id, 
				CAST( AVG(rating) AS DECIMAL(3,2)) AS average_rating
		FROM content_rating cr 
		INNER JOIN content_to_content ctc
			ON ctc.content_id = cr.content_id AND
				cr.content_type_id = 4 AND
				ctc.associated_content_type_id =2
		WHERE @siteId IS NULL OR cr.site_id = @siteId
		GROUP BY ctc.associated_content_id
	)
	
	SELECT product_id, average_rating
	FROM temp_rating
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductContentRatingList TO VpWebApp 
GO

-------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductContentRatingCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductContentRatingCount
	@siteId int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT COUNT( DISTINCT ctc.associated_content_id)
	FROM content_rating cr 
	INNER JOIN content_to_content ctc
		ON ctc.content_id = cr.content_id AND
			cr.content_type_id = 4 AND
			ctc.associated_content_type_id =2
	WHERE @siteId IS NULL OR cr.site_id = @siteId


END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductContentRatingCount TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleCustomPropertyByNameArticleIdList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleCustomPropertyByNameArticleIdList
	@articleIdList varchar(MAX),
	@customPropertyName varchar(100) 	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SELECT article_custom_property_id as id, article_id, article_custom_property.custom_property_id, custom_property_value, 
		article_custom_property.modified, article_custom_property.created, article_custom_property.[enabled]
	FROM article_custom_property 
		INNER JOIN custom_property 
			ON article_custom_property.custom_property_id = custom_property.custom_property_id AND custom_property.enabled = 1
		INNER JOIN global_split(@articleIdList, ',') AS articleIdList
			ON article_id = articleIdList.[value]
	WHERE property_name = @customPropertyName

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleCustomPropertyByNameArticleIdList TO VpWebApp
GO
----------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdsSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdsSiteIdList
	@siteId int,
	@contentTypeId int,
	@contentIds varchar(max)
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT content_rating_id AS id, content_type_id, content_id, rating, enabled, modified, created, site_id
	FROM content_rating 
		INNER JOIN global_Split(@contentIds, ',') AS temp_ids
			ON content_rating.content_id = temp_ids.[value]
	WHERE content_type_id = @contentTypeId 
		AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdsSiteIdList TO VpWebApp 
GO
----------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteId
@siteId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[definition]
	FROM [review_type]	
	WHERE site_id = @siteId
	ORDER BY modified desc

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteId TO VpWebApp 
GO
--------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'country_id' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].author') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [author]
	ADD country_id int NULL
END
GO

-------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_AddAuthor]
	@siteId int,
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@organization varchar(250),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@email varchar(255),
	@countryId int
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO author(site_id, first_name, last_name, title, organization, position, department, profile_html, [enabled],
		created, modified, has_image, email, country_id)
	VALUES(@siteId, @firstName, @lastName, @title, @organization, @position, @department, @profileHtml, @enabled,
		@created, @created, @hasImage, @email, @countryId)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddAuthor TO VpWebApp 
GO

GO
----------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_UpdateAuthor]
	@id int,
	@siteId int, 
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@organization varchar(250),	
	@modified smalldatetime output,
	@email varchar(255),
	@countryId int
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.author
	SET site_id = @siteId,
		first_name =@firstName,
		last_name = @lastName,
		title = @title,
		position = @position,
		department = @department, 
		profile_html = @profileHtml, 
		enabled = @enabled,
		organization = @organization,
		modified = @modified,
		has_image = @hasImage,
		email = @email,
		country_id = @countryId
	WHERE author_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateAuthor TO VpWebApp 
GO

------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicArticle_GetAuthorDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, department, profile_html, has_image,
		enabled, created, modified, email, country_id
	FROM author	
	WHERE author_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetAuthorDetail TO VpWebApp 
GO
-----------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsBySiteId]
	@siteId int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, enabled, created, modified, has_image, email, country_id
	FROM author
	WHERE site_id = @siteId
	ORDER BY  first_name, last_name

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteId TO VpWebApp 
GO
----------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorsByArticleId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicArticle_GetAuthorsByArticleId]
	@articleId int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT aut.author_id as id, aut.site_id, aut.first_name, aut.last_name, aut.title, aut.organization
			, aut.position, aut.department, aut.profile_html, aut.enabled, aut.created, aut.modified
			, aut.has_image, aut.email, aut.country_id
	FROM author aut
		INNER JOIN article_to_author ata
			ON ata.author_id= aut.author_id 
	
	WHERE ata.article_id = @articleId
	ORDER BY ata.article_to_author_id 

END
GO
GRANT EXECUTE ON dbo.publicArticle_GetAuthorsByArticleId TO VpWebApp 
GO
---------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList]  
 @siteId int,  
 @startRowIndex int,  
 @endRowIndex int,  
 @totalRowCount int output  
AS  
-- ==========================================================================  
-- $Author: Nilanka $  
-- ==========================================================================  
BEGIN  
   
 SET NOCOUNT ON;  
  
 WITH AuthorList AS  
 (  
  SELECT author_id as id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id,
	has_image, email, country_id
  FROM author  
  WHERE site_id = @siteId   
 )  
  
 SELECT id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, has_image, email, country_id
 FROM AuthorList  
 WHERE row_id BETWEEN @startRowIndex AND @endRowIndex  
  
 SELECT @totalRowCount = COUNT(*)  
 FROM author  
 WHERE site_id = @siteId   
  
END  
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList TO VpWebApp 
GO

-------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList]
	@siteId int,
	@authorId int = NULL,
	@firstName varchar(100) = NULL,
	@lastName varchar(100)	= NULL,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH AuthorList AS
	(
		SELECT author_id as id, site_id, first_name, last_name, title, organization, position, has_image, email, country_id,
				department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id
		FROM author
		WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')
	)

	SELECT id, site_id, first_name, last_name, title, organization, position, department, profile_html,
		enabled, created, modified, has_image, email, country_id
	FROM AuthorList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(*)
	FROM author
	WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList TO VpWebApp 
GO
-----------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorInformationsByArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorInformationsByArticleIdsList]
	@articleIds varchar(max)
AS
-- ==========================================================================
-- $Author: Nilanka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, a.enabled, a.created, a.modified, aa.article_id,
			a.has_image, a.email, a.country_id
	FROM author a
		INNER JOIN article_to_author aa ON  a.author_id = aa.author_id
	WHERE aa.article_id IN (SELECT [value] FROM Global_Split(@articleIds, ',') )

END
GO
GRANT EXECUTE ON dbo.adminArticle_GetAuthorInformationsByArticleIdsList TO VpWebApp 
GO
--------------------------------------GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_GetReviewTypeBySiteIdPageList'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_GetReviewTypeBySiteIdPageList]
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Nilanka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM review_type
	WHERE site_id = @siteId;

	WITH temp_review_type (row, id, site_id, article_type_id, name, title, [enabled], created, modified, has_image, [description],[definition]) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row, review_type_id as id, site_id, article_type_id, name, title, [enabled], created, modified, has_image, [description],[definition]
		FROM review_type
		WHERE site_id = @siteId
	)

	SELECT id, site_id, article_type_id, name, title, [enabled], created, modified, has_image, [description],[definition]
	FROM temp_review_type
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO
GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypeBySiteIdPageList TO VpWebApp 
GO
----------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorByEmail'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetAuthorByEmail
	@authorEmail varchar(MAX)	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SELECT [author_id] AS [id], [site_id], [first_name], [last_name], [title], [organization], [position], [department]
      , [enabled], [created], [modified], [profile_html], [has_image], [email]
	FROM [author]
	WHERE [email] = @authorEmail AND [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorByEmail TO VpWebApp
GO
----------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'rating_count' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].content_rating') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [content_rating]
	ADD rating_count int NOT NULL DEFAULT '1'
END
GO
------------------------------------
------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_AddContentRating'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminContentRating_AddContentRating]
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@rating decimal(3, 2),
	@ratingCount int,
	@created smalldatetime output,
	@enabled bit
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()
	
INSERT INTO [dbo].[content_rating]
           ([content_type_id]
           ,[content_id]
           ,[rating]
           ,[enabled]
           ,[modified]
           ,[created]
           ,[site_id]
		   ,[rating_count])
     VALUES
      (@contentTypeId, @contentId, @rating, @enabled, @created, @created,@siteId, @ratingCount)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminContentRating_AddContentRating TO VpWebApp 
GO
----------------------------------

-----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_UpdateContentRating'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminContentRating_UpdateContentRating]
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@rating decimal(3, 2),
	@ratingCount int,
	@modified smalldatetime output,
	@enabled bit
	 
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[content_rating]
	SET site_id = @siteId,
		[content_type_id] = @contentTypeId,
		[content_id] = @contentId,
		[rating] = @rating,
		[enabled] = @enabled,		
		modified = @modified,
		rating_count = @ratingCount
		
	WHERE content_rating_id = @id

END
GO

GRANT EXECUTE ON dbo.adminContentRating_UpdateContentRating TO VpWebApp 
GO

------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicContentRating_GetContentRatingDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicContentRating_GetContentRatingDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [content_rating_id] as id
      ,[content_type_id]
      ,[content_id]
      ,[rating]
      ,[enabled]
      ,[modified]
      ,[created]
      ,[site_id]
	  ,[rating_count]
  FROM [content_rating]	
	WHERE [content_rating_id] = @id 

END
GO
GRANT EXECUTE ON dbo.publicContentRating_GetContentRatingDetail TO VpWebApp 
GO

--------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdSiteId
	@siteId int,
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT content_rating_id AS id, content_type_id, content_id, rating, enabled, modified, created, site_id, rating_count
	FROM content_rating
	WHERE content_type_id = @contentTypeId 
		AND content_id = @contentId
		AND site_id = @siteId
		
END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdSiteId TO VpWebApp 
GO

-----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductContentRatingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductContentRatingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	
	WITH temp_rating(row, product_id, average_rating, rating_count) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY ctc.associated_content_id ASC) AS row, ctc.associated_content_id AS product_id, 
				CAST( AVG(rating) AS DECIMAL(3,2)) AS average_rating, COUNT(rating) AS rating_count
		FROM content_rating cr 
		INNER JOIN content_to_content ctc
			ON ctc.content_id = cr.content_id AND
				cr.content_type_id = 4 AND
				ctc.associated_content_type_id =2
		WHERE @siteId IS NULL OR cr.site_id = @siteId
		GROUP BY ctc.associated_content_id
	)
	
	SELECT 	p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
			, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created
			, p.product_type, p.[status], p.has_related, p.has_model, p.completeness
			, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden
			, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page, p.default_rank
			, p.default_search_rank, temp.average_rating, temp.rating_count
	FROM temp_rating temp
		INNER JOIN product p
			ON p.product_id = temp.product_id
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductContentRatingList TO VpWebApp 
GO

--------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleOverallRatingCustomPropertyList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleOverallRatingCustomPropertyList
	@siteId int 	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	--This query retrieves overall rating custom properties for
	--articles which are not included in the content rating table.
	
	SELECT artcp.article_custom_property_id AS id, artcp.article_id, artcp.custom_property_id,
		artcp.custom_property_value, artcp.modified, artcp.created, artcp.[enabled]
	FROM article_custom_property artcp
		INNER JOIN custom_property cp
			ON cp.custom_property_id = artcp.custom_property_id
		INNER JOIN article a
			ON artcp.article_id = a.article_id
		INNER JOIN (SELECT DISTINCT article_type_id FROM review_type) rt
			ON rt.article_type_id = a.article_type_id
		LEFT JOIN content_rating cr
			ON a.article_id = cr.content_id AND cr.content_type_id = 4
	WHERE cp.property_name = 'Overall' AND
		(@siteId IS NULL OR a.site_id = @siteId)  AND
		cr.content_rating_id IS NULL
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleOverallRatingCustomPropertyList TO VpWebApp
GO
-----------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdsSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdsSiteIdList
	@siteId int,
	@contentTypeId int,
	@contentIds varchar(max)
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT content_rating_id AS id, content_type_id, content_id, rating, enabled, modified, created, site_id, rating_count
	FROM content_rating 
		INNER JOIN global_Split(@contentIds, ',') AS temp_ids
			ON content_rating.content_id = temp_ids.[value]
	WHERE content_type_id = @contentTypeId 
		AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentRatingByContentTypeIdContentIdsSiteIdList TO VpWebApp 
GO
----------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetContentRatingByContentIdListContentTypeId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetContentRatingByContentIdListContentTypeId
@contentIdList VARCHAR(MAX),
@contentTypeId INT
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [content_rating_id] AS [id],[content_type_id],[content_id],[rating],[enabled],[modified]
      ,[created],[site_id],[rating_count]
	FROM [content_rating] cr
		INNER JOIN global_split(@contentIdList, ',') contentIds
		ON cr.[content_id] = contentIds.[value] AND cr.[content_type_id] = @contentTypeId
		
END
GO

GRANT EXECUTE ON dbo.publicArticle_GetContentRatingByContentIdListContentTypeId TO VpWebApp 
--------------------------------------------------
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminForm_AddForm'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForm_AddForm
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@savedAsXml bit,
	@definition nvarchar(MAX),
	@name varchar(100),
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO form (site_id, content_type_id, content_id, saved_as_xml, [definition], name, [enabled], created, modified)
	VALUES (@siteId, @contentTypeId, @contentId, @savedAsXml, @definition, @name, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminForm_AddForm TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminField_GetFieldBySiteIdFieldContentTypeIdFieldTypeIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminField_GetFieldBySiteIdFieldContentTypeIdFieldTypeIdList
	@siteId int,
	@fieldContentTypeId int,
	@fieldTypeId int
AS
-- ==========================================================================
-- $Author$ : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT field_id AS id, site_id, content_type_id, content_id, action_id, field_content_type_id, field_type_id,
		predefined_field_id, field_text, field_text_abbreviation, field_description, [enabled], modified, created
	FROM field
	WHERE site_id = @siteId AND field_content_type_id = @fieldContentTypeId AND field_type_id = @fieldTypeId
	ORDER BY field_text ASC

END
GO

GRANT EXECUTE ON dbo.adminField_GetFieldBySiteIdFieldContentTypeIdFieldTypeIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminField_GetFieldBySiteIdFieldContentTypeIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminField_GetFieldBySiteIdFieldContentTypeIdList
	@siteId int,
	@fieldContentTypeId int
AS
-- ==========================================================================
-- $Author$ : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT field_id AS id, site_id, content_type_id, content_id, action_id, field_content_type_id, field_type_id,
		predefined_field_id, field_text, field_text_abbreviation, field_description, [enabled], modified, created
	FROM field
	WHERE site_id = @siteId AND field_content_type_id = @fieldContentTypeId
	ORDER BY field_text ASC

END
GO

GRANT EXECUTE ON dbo.adminField_GetFieldBySiteIdFieldContentTypeIdList TO VpWebApp 

GO
-----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicForm_SelectFormDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicForm_SelectFormDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT form_id AS id, site_id, content_type_id, content_id, saved_as_xml, [definition], name, [enabled], created, modified
	FROM form
	WHERE form_id = @id

END
GO

GRANT EXECUTE ON dbo.publicForm_SelectFormDetail TO VpWebApp 
GO
---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminForm_UpdateForm'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForm_UpdateForm
	@id int,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@savedAsXml bit,
	@definition nvarchar(MAX),
	@name varchar(100),
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	
	UPDATE form
	SET site_id = @siteId,
		content_type_id = @contentTypeId,
		content_id = @contentId,
		saved_as_xml = @savedAsXml,
		[definition] = @definition,
		name = @name,
		[enabled] = @enabled,
		modified = @modified
	WHERE form_id = @id

END
GO

GRANT EXECUTE ON dbo.adminForm_UpdateForm TO VpWebApp 
GO
----------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminForm_DeleteForm'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForm_DeleteForm
	@id int
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM form
	WHERE form_id = @id

END
GO

GRANT EXECUTE ON dbo.adminForm_DeleteForm TO VpWebApp 
GO
---------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminForm_DeleteFormBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForm_DeleteFormBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM form
	WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminForm_DeleteFormBySiteIdList TO VpWebApp 
GO
--------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicForm_GetFormByContentTypeIdConentIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicForm_GetFormByContentTypeIdConentIdDetail
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT form_id AS id, site_id, content_type_id, content_id, saved_as_xml, [definition], name, [enabled], created, modified
	FROM form
	WHERE content_type_id = @contentTypeId AND content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.publicForm_GetFormByContentTypeIdConentIdDetail TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------------
