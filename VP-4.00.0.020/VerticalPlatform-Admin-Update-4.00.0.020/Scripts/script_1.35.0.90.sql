IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[application_message]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[application_message](
	[application_message_id] [int] IDENTITY(1,1) NOT NULL,
	[site_id] [int] NULL,
	[application_type] [int] NOT NULL,
	[message_type] [int] NOT NULL,
	[message_text] [varchar](5000) NOT NULL,
	[show] [bit] NOT NULL,
	[enabled] [bit] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	CONSTRAINT [PK_application_message] PRIMARY KEY CLUSTERED 
	(
		[application_message_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

---------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_to_application_message]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[user_to_application_message](
	[user_to_application_message_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[application_message_id] [int] NOT NULL,
	[show] [bit] NOT NULL,
	[enabled] [bit] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	CONSTRAINT [PK_user_to_application_message] PRIMARY KEY CLUSTERED 
	(
		[user_to_application_message_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

---------------------------------------

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_user_to_application_message_user') AND parent_object_id = OBJECT_ID(N'user_to_application_message'))
BEGIN
	ALTER TABLE [dbo].[user_to_application_message]  WITH CHECK ADD  CONSTRAINT [FK_user_to_application_message_user] FOREIGN KEY([user_id])
	REFERENCES [dbo].[user] ([user_id])
	ALTER TABLE [dbo].[user_to_application_message] CHECK CONSTRAINT [FK_user_to_application_message_user]
END
GO

---------------------------------------

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_user_to_application_message_message') AND parent_object_id = OBJECT_ID(N'user_to_application_message'))
BEGIN
	ALTER TABLE [dbo].[user_to_application_message]  WITH CHECK ADD  CONSTRAINT [FK_user_to_application_message_message] FOREIGN KEY([application_message_id])
	REFERENCES [dbo].[application_message] ([application_message_id])
	ALTER TABLE [dbo].[user_to_application_message] CHECK CONSTRAINT [FK_user_to_application_message_message]
END
GO

---------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteApplicationMessage
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM application_message
	WHERE application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteApplicationMessage TO VpWebApp 
Go

------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddApplicationMessage
	@siteId int,
	@applicationType int, 
	@messageType int, 
	@messageText varchar(5000),
	@show bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO application_message(site_id, application_type, message_type, message_text, show, [enabled], created, modified)
	VALUES (@siteId, @applicationType, @messageType, @messageText, @show, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddApplicationMessage TO VpWebApp 
GO

GO

-----------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteUserApplicationMessagesForSite'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteUserApplicationMessagesForSite
	@siteId int
AS
-- ==========================================================================
-- $Author:  Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM user_to_application_message
	WHERE application_message_id IN
	(
		SELECT application_message_id
		FROM application_message
		WHERE site_id = @siteId
	)
	
END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteUserApplicationMessagesForSite TO VpWebApp 
GO

----------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetApplicationMessages'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetApplicationMessages
	@siteId int,
	@applicationType int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT application_message_id AS id, site_id, application_type, message_type, message_text, show, [created], [enabled], [modified]
	FROM application_message
	WHERE (@siteId IS NULL OR site_id = @siteId) AND (@applicationType IS NULL OR @applicationType = application_type)

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetApplicationMessages TO VpWebApp 
GO

-------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteUserApplicationMessagesForUser'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteUserApplicationMessagesForUser
	@userId int
AS
-- ==========================================================================
-- $Author:  Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM user_to_application_message
	WHERE user_id = @userId
END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteUserApplicationMessagesForUser TO VpWebApp 
GO
--------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetUserApplicationMessageDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetUserApplicationMessageDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT user_to_application_message_id AS id, user_id, application_message_id, show, [created], [enabled], [modified]
	FROM user_to_application_message
	WHERE user_to_application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetUserApplicationMessageDetail TO VpWebApp 
GO

--------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateUserApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateUserApplicationMessage
	@id int,
	@userId int,
	@applicationMessageId int, 
	@show bit,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE user_to_application_message
	SET user_id = @userId,
		application_message_id = @applicationMessageId,
		show = @show,
		enabled = @enabled,
		modified = @modified
	WHERE user_to_application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateUserApplicationMessage TO VpWebApp 
GO

---------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteUserApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteUserApplicationMessage
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM user_to_application_message
	WHERE user_to_application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteUserApplicationMessage TO VpWebApp 
Go

-----------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddUserApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddUserApplicationMessage
	@userId int,
	@applicationMessageId int, 
	@show bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO user_to_application_message(user_id, application_message_id, show, [enabled], created, modified)
	VALUES (@userId, @applicationMessageId, @show, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddUserApplicationMessage TO VpWebApp 
GO

GO

---------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetApplicationMessageDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetApplicationMessageDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT application_message_id AS id, site_id, application_type, message_type, message_text, show, [created], [enabled], [modified]
	FROM application_message
	WHERE application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetApplicationMessageDetail TO VpWebApp 
GO

-----------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUserApplicationMessagesToBeShown'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUserApplicationMessagesToBeShown
	@userId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT am.application_message_id AS id, am.site_id, am.application_type, am.message_type, am.message_text, am.show, am.[created], am.[enabled], am.[modified]
	FROM application_message am
		INNER JOIN user_to_application_message uam
			ON uam.application_message_id = am.application_message_id
	WHERE uam.show = 1 AND uam.user_id = @userId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUserApplicationMessagesToBeShown TO VpWebApp 
GO

----------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateApplicationMessage
	@id int,
	@siteId int,
	@applicationType int, 
	@messageType int, 
	@messageText varchar(5000),
	@show bit,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE application_message
	SET site_id = @siteId,
		application_type = @applicationType,
		message_type = @messageType,
		message_text = @messageText,
		show = @show,
		enabled = @enabled,
		modified = @modified
	WHERE application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateApplicationMessage TO VpWebApp 
GO

------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteApplicationMessagesForSite'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteApplicationMessagesForSite
	@siteId int
AS
-- ==========================================================================
-- $Author:  Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM application_message
	WHERE site_id = @siteId
END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteApplicationMessagesForSite TO VpWebApp 
GO

---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteUserApplicationMessagesForMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteUserApplicationMessagesForMessage
	@applicationMessageId int
AS
-- ==========================================================================
-- $Author:  Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM user_to_application_message
	WHERE application_message_id = @applicationMessageId
END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteUserApplicationMessagesForMessage TO VpWebApp 
GO

------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetAllUsers'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetAllUsers
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT u.[user_id] AS id, u.aspnet_user_id, u.first_name, u.last_name
			, u.salutation_id, u.email_html, u.is_supper_user, u.user_status_type_id, u.country_id
			, u.enabled, u.modified, u.created
	FROM [user] u

END
GO

GRANT EXECUTE ON dbo.adminUser_GetAllUsers TO VpWebApp
GO

-------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUserApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUserApplicationMessage
	@userId int,
	@applicationMessageId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SELECT user_to_application_message_id AS id, user_id, application_message_id, show, [created], [enabled], [modified]
	FROM user_to_application_message
	WHERE user_id = @userId AND application_message_id = @applicationMessageId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUserApplicationMessage TO VpWebApp 
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_ClearApplicationMessagesForUser'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_ClearApplicationMessagesForUser
	@userId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE user_to_application_message
	SET show = 0
	WHERE [user_id] = @userId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_ClearApplicationMessagesForUser TO VpWebApp 
GO

---------------
IF NOT EXISTS 
(SELECT [name] FROM syscolumns where [name] = 'include_in_sitemap' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'fixed_guided_browse') AND type in (N'U')))
	BEGIN
		ALTER TABLE fixed_guided_browse
		ADD include_in_sitemap BIT not null DEFAULT 0
	END
GO
---------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowse
	@id int output,
	@categoryId int,
	@name varchar(200),
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
	@enabled bit,	
	@buildOptionList bit,
	@isDynamic bit,
	@includeInSitemap bit,
	@isClean bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, [name],  segment_size, [enabled],
	prefix_text, suffix_text, naming_rule, created, modified, build_option_list, is_dynamic, include_in_sitemap, is_clean)
	VALUES (@categoryId, @name, @segmentSize, @enabled,
	@prefixText, @suffixText, @namingRule, @created, @created, @buildOptionList, @isDynamic, @includeInSitemap, @isClean)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowse TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowse
	@id int,
	@categoryId int,
	@name varchar(200),
	@enabled bit,	
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
	@buildOptionList bit,
	@isDynamic bit,
	@includeInSitemap bit,
	@isClean bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE fixed_guided_browse
	SET
		category_id = @categoryId,
		[name] = @name,
		segment_size = @segmentSize,
		prefix_text = @prefixText,
		suffix_text = @suffixText,
		naming_rule = @namingRule,
		enabled = @enabled,
		modified = @modified,
		build_option_list = @buildOptionList, 
		is_dynamic = @isDynamic,
		include_in_sitemap = @includeInSitemap,
		is_clean = @isClean
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowse TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllFixedGuidedBrowses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllFixedGuidedBrowses
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean
	FROM fixed_guided_browse
	WHERE [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllFixedGuidedBrowses TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowse
	@id int

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList
	@categoryId int

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean
	FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean
	FROM fixed_guided_browse
	WHERE [enabled] = 1 AND category_id IN
	(
		SELECT category_id
		FROM category
		WHERE site_id = @siteId
	)

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList TO VpWebApp 
GO
------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetValidFixedUrlsByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetValidFixedUrlsByProductIdList
	@productIdList varchar(max),
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT fu.fixed_url_id AS id, fu.fixed_url, fu.site_id, fu.page_id, fu.content_type_id, fu.content_id
		, fu.query_string, fu.enabled, fu.include_in_sitemap, fu.created, fu.modified
	FROM fixed_url fu
		INNER JOIN global_Split(@productIdList, ',') tempProductIdList
			ON fu.content_id = tempProductIdList.[value] AND fu.content_type_id = 2
		INNER JOIN product p
			ON p.product_id = fu.content_id AND p.site_id = @siteId AND p.enabled = 1 AND p.hidden = 0
		INNER JOIN product_to_category ptc
			ON ptc.product_id = p.product_id
		INNER JOIN fixed_url fuc 
			ON fuc.content_id = ptc.category_id AND fuc.content_type_id = 1 AND fuc.include_in_sitemap = 1
			
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetValidFixedUrlsByProductIdList TO VpWebApp 
GO
------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetFixedUrlsByContentTypeSiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetFixedUrlsByContentTypeSiteIdPageList
	@contentType int,
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled, include_in_sitemap, created, modified, row) AS
	(
		SELECT fu.fixed_url_id AS id, fu.fixed_url, fu.site_id, fu.page_id, fu.content_type_id, fu.content_id
			, fu.query_string, fu.enabled, fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fu.fixed_url_id) AS row
		FROM fixed_url fu
		WHERE fu.content_type_id = @contentType AND fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1 
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetFixedUrlsByContentTypeSiteIdPageList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetOrphanProductsBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetOrphanProductsBySiteIdPageList
    @siteId int,
    @startIndex int,
    @endIndex int,
    @totalCount int output
AS
-- ==========================================================================
-- Yasodha Handehewa
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;

	CREATE TABLE #orphan (category_id int, orphan bit)
	CREATE TABLE #children (childid int, parentid int, [level] int)
	CREATE TABLE #parent (childid int, parentid int, [level] int, orphan bit)

	INSERT INTO #orphan(category_id, orphan)
	SELECT category_id, 1
	FROM category c
	WHERE category_type_id <> 1 AND
		category_id NOT IN (SELECT sub_category_id FROM category_to_category_branch );
   
	--select * from #orphan
	WITH cte(childId, parentId, [level]) AS
	(
		SELECT b.sub_category_id, b.category_id, [level] = 1
		FROM category_to_category_branch b
			INNER JOIN #orphan
				ON #orphan.category_id = b.category_id
	   
		UNION ALL
	   
		SELECT b.sub_category_id, b.category_id, ([level] + 1) AS [level]
		FROM cte
			INNER JOIN category_to_category_branch b
				ON cte.childId = b.category_id
	)

	INSERT INTO #children (childid, parentid, [level])
	SELECT childid, parentid, [level] FROM cte

	--select * from #children
	INSERT INTO #parent (childid, parentid, [level], orphan)
	SELECT sub_category_id, category_id, #children.[level], 0
	FROM #children
		INNER JOIN category_to_category_branch
			ON #children.childid = sub_category_id
	       
	--select * from #parent order by childid
	DECLARE @highestlevel int
	SELECT @highestlevel = max([level]) FROM #children

	DECLARE @index int
	SET @index = 1

	WHILE (@index <= @highestlevel)
	BEGIN
		DELETE FROM #parent
		WHERE [level] = @index AND parentid IN (SELECT category_id FROM #orphan)
	   
		INSERT INTO #orphan (category_id, orphan)
		SELECT #children.childid, 1
		FROM #children
		WHERE [level] = @index AND #children.childid NOT IN (SELECT childid FROM #parent WHERE [level] = 1)
		ORDER BY childid
	   
		SET @index = @index + 1
	END

	--The non-orphan category_id list--
	SELECT cat.category_id
	INTO #non_orphan_category_list
	FROM category cat
	WHERE cat.category_id NOT IN (SELECT category_id FROM #orphan)

	--The orphan product list-
	SELECT DISTINCT #orphan.category_id, pc.product_id
	INTO #orphan_productIds
	FROM product_to_category pc
		INNER JOIN #orphan
		ON #orphan.category_id = pc.category_id
	    
	--The non-orphan product list--
	SELECT DISTINCT pc.product_id, pc.category_id
	INTO #non_orphan_productIds
	FROM #non_orphan_category_list
		INNER JOIN product_to_category pc
		ON pc.category_id = #non_orphan_category_list.category_id
	   
	--The orphan product list--
	SELECT #orphan_productIds.product_id, #orphan_productIds.category_id
	INTO #orphan_products
	FROM #orphan_productIds
	WHERE #orphan_productIds.product_id NOT IN (SELECT product_id FROM #non_orphan_productIds)

	--The distinct orphan product list--
	SELECT DISTINCT #orphan_products.product_id
	INTO #orphan_productIdList
	FROM #orphan_products

	--The orphan product count--
	SELECT p.product_id
	INTO #orphan_productCount
	FROM product p
		INNER JOIN #orphan_productIdList
		ON #orphan_productIdList.product_id = p.product_id
	WHERE p.site_id = @siteId
	ORDER BY p.product_id

	SELECT id, site_id, parent_product_id, product_name, rank, has_image,
			catalog_number, enabled, modified, created, product_type, status, has_model, has_related,
			flag1, flag2, flag3, flag4, completeness, search_rank, search_content_modified, hidden,
			business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank,
			default_search_rank, row
		FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY product_id ASC) AS row, product_id AS id, site_id, parent_product_id, product_name, rank, has_image,
				catalog_number, enabled, modified, created, product_type, status, has_model, has_related,
				flag1, flag2, flag3, flag4, completeness, search_rank, search_content_modified, hidden,
				business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank,
				default_search_rank
			FROM
			(
				SELECT DISTINCT p.product_id, p.site_id, p.parent_product_id, p.product_name, p.rank, p.has_image,
							p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.status, p.has_model, p.has_related,
							p.flag1, p.flag2, p.flag3, p.flag4, p.completeness, p.search_rank, p.search_content_modified, p.hidden,
							p.business_value, p.show_in_matrix, p.show_detail_page, p.ignore_in_rapid, p.default_rank,
							p.default_search_rank
				FROM product p
					INNER JOIN #orphan_productIdList
					ON #orphan_productIdList.product_id = p.product_id
				WHERE p.site_id = @siteId
			)AS tempProduct
		) AS tempProductList
		WHERE row BETWEEN @startIndex AND @endIndex

		SELECT @totalCount = COUNT(*)
		FROM #orphan_productCount
 
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetOrphanProductsBySiteIdPageList TO VpWebApp
GO

