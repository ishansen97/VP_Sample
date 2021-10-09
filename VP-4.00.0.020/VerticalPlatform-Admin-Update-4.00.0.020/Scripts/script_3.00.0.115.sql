-- publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList
	@groupId int,
	@searchText varchar(500),
	@startIndex int,
	@endIndex int,
	@optionId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 
		ROW_NUMBER() OVER (ORDER BY sort_order,search_option_id) AS row, 
		search_option_id, 
		search_group_id, 
		[name], 
		sort_order, 
		created, 
		enabled, 
		modified
	into #temp_search_option
	FROM search_option
	WHERE (@groupId = 0 OR search_group_id = @groupId)
	AND [name] LIKE (@searchText + '%') 
	AND (@optionId = 0 OR search_option_id = @optionId)

	SELECT	search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM #temp_search_option
	WHERE (row BETWEEN @startIndex AND @endIndex)
	ORDER BY row

	SELECT @totalCount = COUNT(*)
	FROM #temp_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList TO VpWebApp 
GO



-------------- VP security updates -----------------------

/*                --------USER ACCOUNT LOCKING  SCRIPT CHANGES-------         */
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[public_user_login]') 
         AND name = 'last_login_attempt_time'
)
BEGIN
ALTER TABLE [dbo].[public_user_login] 
ADD last_login_attempt_time SMALLDATETIME NULL

END
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[public_user_login]') 
         AND name = 'login_attempts'
)
BEGIN
ALTER TABLE [dbo].[public_user_login] 
ADD login_attempts INT NOT NULL DEFAULT 0

END
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[public_user_login]') 
         AND name = 'is_locked'
)
BEGIN
ALTER TABLE [dbo].[public_user_login] 
ADD is_locked BIT  NOT NULL DEFAULT 0

END
GO
------------- end ------------------

-----------add site parameters if not exists---------
IF NOT EXISTS (SELECT 1 FROM [dbo].[parameter_type] WHERE [parameter_type_id] = 213)
BEGIN
  INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (213
           ,'UserLoginMaxAttempts'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )
END
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[parameter_type] WHERE [parameter_type_id] = 214)
BEGIN
	INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (214
           ,'UserLoginTimeLimit'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )
END
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[parameter_type] WHERE [parameter_type_id] = 215)
BEGIN
	INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (215
           ,'UserLockedAdminContactEmail'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[parameter_type] WHERE [parameter_type_id] = 216)
BEGIN
	INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (216
           ,'PageXFrameOptions'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )
END
GO



------------- end ------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserLoginByPublicUserIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserLoginByPublicUserIdDetail
	@publicUserId varchar(255)
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_login_id AS id, site_id, public_user_id, email, [password], password_reset_key
			, password_reset_timestamp, [enabled], modified, created, last_login_attempt_time, login_attempts, is_locked
	FROM public_user_login
	WHERE public_user_id = @publicUserId

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserLoginByPublicUserIdDetail TO VpWebApp 
GO

------------- end ------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserLoginByUserIdSiteIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserLoginByUserIdSiteIdDetail
	@userId int,
	@siteId int
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_login_id AS id, site_id, public_user_id, email, password, password_reset_key, password_reset_timestamp
		, [enabled], modified, created, last_login_attempt_time, login_attempts, is_locked
	FROM public_user_login
	WHERE public_user_id = @userId AND site_id = @siteId
END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserLoginByUserIdSiteIdDetail TO VpWebApp 

Go
------------- end ------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserLoginByEmailDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserLoginByEmailDetail
	@email varchar(255)
AS
-- ========================================================================== 
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_login_id AS id, site_id, public_user_id, email, [password], password_reset_key
		, password_reset_timestamp, [enabled], modified, created,last_login_attempt_time, login_attempts, is_locked
	FROM public_user_login
	WHERE email = @email

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserLoginByEmailDetail TO VpWebApp 
GO
------------- end ------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_UpdatePublicUserLogin'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_UpdatePublicUserLogin
	@id int,
	@siteId int,
	@publicUserId int,
	@email varchar(255),
	@password varchar(255),
	@passwordResetKey varchar(255),
	@passwordResetTimestamp smalldatetime,
	@enabled bit,
	@attemptedTime smalldatetime,
	@loginAttempts int,
	@isLocked bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE public_user_login
	SET site_id = @siteId,
			public_user_id = @publicUserId,
			email = @email,
			[password] = @password,
			password_reset_key = @passwordResetKey,
			password_reset_timestamp = @passwordResetTimestamp,
			[enabled] = @enabled,
			modified = @modified,
			last_login_attempt_time = @attemptedTime, 
			login_attempts = @loginAttempts, 
			is_locked = @isLocked
	WHERE public_user_login_id = @id

END
GO

GRANT EXECUTE ON dbo.publicUser_UpdatePublicUserLogin TO VpWebApp 
GO
------------- end ------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserLoginDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserLoginDetail
	@id int
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_login_id as id, site_id, public_user_id, email, [password], password_reset_key, password_reset_timestamp, [enabled], modified, created,
		last_login_attempt_time, login_attempts, is_locked
	FROM public_user_login
	WHERE public_user_login_id = @id

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserLoginDetail TO VpWebApp 
GO

------------- end ------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_AddPublicUserLogin'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_AddPublicUserLogin
	@siteId int,
	@publicUserId int,
	@email varchar(255),
	@password varchar(255),
	@passwordResetKey varchar(255),
	@passwordResetTimestamp smalldatetime,
	@enabled bit,
	@attemptedTime smalldatetime,
	@loginAttempts int,
	@isLocked bit,
	@created smalldatetime output,
	@id int output
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO public_user_login(site_id, public_user_id, email, [password], password_reset_key, password_reset_timestamp, [enabled], modified, created, 
		last_login_attempt_time, login_attempts, is_locked)
	VALUES(@siteId, @publicUserId, @email, @password, @passwordResetKey, @passwordResetTimestamp, @enabled, @created, @created, @attemptedTime, @loginAttempts, @isLocked)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.publicUser_AddPublicUserLogin TO VpWebApp 
GO
------------- end ------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserLoginBySiteIdStartIndexEndIndexListWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserLoginBySiteIdStartIndexEndIndexListWithSorting
	@siteId int,
	@startIndex int,
	@endIndex int,
	@sortBy varchar(8),
	@sortOrder varchar(5),
	@search varchar(50) = NULL,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #publicUserLogins 
	(
		id int,
		idRowIndexAsc int,
		idRowIndexDesc int,
		site_id int,
		email varchar(255),
		emailRowIndexAsc int,
		emailRowIndexDesc int,
		[password] varchar(255),
		password_reset_key varchar(255),
		password_reset_timestamp smalldatetime,
		[enabled] bit,
		modified smalldatetime,
		created smalldatetime,
		public_user_id int,
		last_login_attempt_time smalldatetime,
		login_attempts int,
		is_locked bit
	)

	CREATE TABLE #sortedPublicUserLogins 
	(
		id int,
		site_id int,
		email varchar(255),
		[password] varchar(255),
		password_reset_key varchar(255),
		password_reset_timestamp smalldatetime,
		[enabled] bit,
		modified smalldatetime,
		created smalldatetime,
		public_user_id int,
		last_login_attempt_time smalldatetime,
		login_attempts int,
		is_locked bit,
		row int
	)

	INSERT INTO #publicUserLogins
	SELECT public_user_login_id AS id, ROW_NUMBER() OVER (ORDER BY public_user_login_id ASC) AS idRowIndexAsc
			, ROW_NUMBER() OVER (ORDER BY public_user_login_id DESC) AS idRowIndexDesc, site_id, email
			, ROW_NUMBER() OVER (ORDER BY email ASC) AS emailRowIndexAsc, ROW_NUMBER() OVER (ORDER BY email DESC) AS emailRowIndexDesc
			, [password], password_reset_key, password_reset_timestamp
			, [enabled], modified, created, public_user_id,last_login_attempt_time, login_attempts, is_locked
	FROM public_user_login
	WHERE site_id = @siteId
	AND (@search IS NULL OR email like '%' + @search + '%')

	INSERT INTO #sortedPublicUserLogins
	SELECT id, site_id, email, [password], password_reset_key, password_reset_timestamp, [enabled], modified
			, created, public_user_id, last_login_attempt_time, login_attempts, is_locked,
			CASE @sortBy
				WHEN 'id' THEN 
					CASE @sortOrder
					WHEN 'asc' THEN idRowIndexAsc
					ELSE idRowIndexDesc
					END
				WHEN 'email' THEN 
					CASE @sortOrder
					WHEN 'asc' THEN emailRowIndexAsc
					ELSE emailRowIndexDesc
					END
				ELSE
					idRowIndexAsc
			END AS row
	FROM #publicUserLogins

	SELECT @numberOfRows = COUNT(*) FROM #publicUserLogins

	SELECT id, site_id, email, [password], password_reset_key, password_reset_timestamp, [enabled], modified
			, created, public_user_id, last_login_attempt_time, login_attempts, is_locked
	FROM #sortedPublicUserLogins
	WHERE row BETWEEN @startIndex AND @endIndex 
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserLoginBySiteIdStartIndexEndIndexListWithSorting TO VpWebApp 
Go


------------- end ------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserLoginByEmailSiteDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserLoginByEmailSiteDetail
	@email varchar(255),
	@siteId int
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_login_id AS id, site_id, public_user_id, email, [password], password_reset_key
		, password_reset_timestamp, [enabled], modified, created, last_login_attempt_time, login_attempts, is_locked
	FROM public_user_login
	WHERE email = @email and site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserLoginByEmailSiteDetail TO VpWebApp 
GO



------------- end ------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserLoginByPublicUserIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserLoginByPublicUserIdDetail
	@publicUserId varchar(255)
AS
-- ==========================================================================
-- $Date: 2020-09-16 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_login_id AS id, site_id, public_user_id, email, [password], password_reset_key
			, password_reset_timestamp, [enabled], modified, created, last_login_attempt_time, login_attempts, is_locked
	FROM public_user_login
	WHERE public_user_id = @publicUserId

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserLoginByPublicUserIdDetail TO VpWebApp 
GO



/*                --------PASSWORD RESET REFERRER CHANGES-------         */


IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[content_metadata]') 
         AND name = 'referrer_policy_id'
)
BEGIN
ALTER TABLE [dbo].[content_metadata]
ADD referrer_policy_id INT NOT NULL DEFAULT 0

END
GO


------------- end ------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddContentMetadata'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddContentMetadata
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@titleTag varchar(250),
	@keywords varchar(max),
	@description varchar(max),
	@enabled bit,	
	@created smalldatetime output,
	@noindex varchar(250),
	@referrerPolicyTypeId varchar(250)
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO content_metadata (site_id, content_type_id, content_id, title_tag, keywords, description,
		[enabled], created, noindex, referrer_policy_id)
	VALUES (@siteId, @contentTypeId, @contentId, @titleTag, @keywords, @description,
		@enabled, @created, @noindex, @referrerPolicyTypeId)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddContentMetadata TO VpWebApp 
GO

------------- end ------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadata'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadata
	@id int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_metadata_id as id, site_id, content_type_id, content_id, title_tag, keywords, description, enabled, modified, created, noindex, referrer_policy_id
	FROM content_metadata
	WHERE  content_metadata_id = @id
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadata TO VpWebApp 
GO

------------- end ------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateContentMetadata'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminPlatform_UpdateContentMetadata]
	@id int output,
	@siteId int,
	@contentTypeId int,
	@contentId int,
	@titleTag varchar(250),
	@keywords varchar(max),
	@description varchar(max),
	@noindex varchar(250),
	@enabled bit,
	@referrerPolicyTypeId varchar(250),
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE content_metadata
	SET
		site_id = @siteId,
		content_type_id = @contentTypeId,
		content_id = @contentId,
		title_tag = @titleTag,
		keywords = @keywords,
		description = @description,
		noindex = @noindex,
		[enabled] = @enabled,
		modified = @modified,
		referrer_policy_id = @referrerPolicyTypeId
	WHERE content_metadata_id = @id

END
GO

GRANT EXECUTE ON adminPlatform_UpdateContentMetadata TO VpWebApp
GO

------------- end ------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentMetadataByContentTypeIdcontentId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentMetadataByContentTypeIdcontentId
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT content_metadata_id as id, site_id, content_type_id, content_id, title_tag, keywords, description, noindex, enabled, modified, created,referrer_policy_id
	FROM content_metadata
	WHERE  content_type_id = @contentTypeId
			AND content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentMetadataByContentTypeIdcontentId TO VpWebApp 
GO

------------- end ------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId
	@siteId int,
	@contentTypeId int,
	@pageStart int,
	@pageEnd int,
	@recordCount int output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER(ORDER BY content_metadata_id) AS rowNum, content_metadata_id as id, site_id, content_type_id, content_id, title_tag, keywords, description, 
	noindex, enabled, modified, created, referrer_policy_id into #contentMetadata
	FROM content_metadata
	WHERE  content_type_id = @contentTypeId
			AND site_id = @siteId 

	SELECT * 
	FROM #contentMetadata
	WHERE rowNum BETWEEN @pageStart AND @pageEnd

	SELECT @recordCount = COUNT(id) 
	FROM #contentMetadata	

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadataBySiteIdContentTypeId TO VpWebApp 
GO

------------- end ------------------


-- Get content metadata information
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadataInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadataInformation
	@siteId int,
	@contentTypeId int,
	@pageStart int,
	@pageEnd int,
	@recordCount int output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT s.site_name, cm.content_metadata_id as id, cm.site_id, cm.content_type_id, cm.content_id, cm.title_tag, cm.keywords, cm.description, 
			CASE WHEN c.category_name IS NOT NULL THEN c.category_name 
				 WHEN a.article_title IS NOT NULL THEN a.article_title 
				 WHEN v.vendor_name IS NOT NULL THEN v.vendor_name 
				 WHEN p.product_name IS NOT NULL THEN p.product_name  
				 WHEN f.name IS NOT NULL THEN f.name  END
			AS content_name, 
			
			
			CASE WHEN c.created IS NOT NULL THEN c.created
				 WHEN a.created IS NOT NULL THEN a.created
				 WHEN v.created IS NOT NULL THEN v.created 
				 WHEN p.created IS NOT NULL THEN p.created 
				 WHEN f.created IS NOT NULL THEN f.created END
			AS content_created,
			
			CASE WHEN c.modified IS NOT NULL THEN c.modified
				 WHEN a.modified IS NOT NULL THEN a.modified 
				 WHEN v.modified IS NOT NULL THEN v.modified  	
				 WHEN p.modified IS NOT NULL THEN p.modified
				 WHEN f.modified IS NOT NULL THEN f.modified END
			AS content_modified,
			cm.enabled, cm.modified, cm.created, cm.noindex, referrer_policy_id into #contentMetadata
	FROM content_metadata cm
	
			INNER JOIN site s 
			ON s.site_id = cm.site_id
			LEFT OUTER JOIN category c
			ON cm.content_id = c.category_id AND cm.content_type_id = 1
			LEFT OUTER JOIN vendor v
			ON cm.content_id = v.vendor_id AND cm.content_type_id = 6
			LEFT OUTER JOIN article a
			ON cm.content_id = a.article_id AND cm.content_type_id = 4
			LEFT OUTER JOIN product p
			ON cm.content_id = p.product_id AND cm.content_type_id = 2
			LEFT OUTER JOIN fixed_guided_browse f
			ON cm.content_id = f.fixed_guided_browse_id AND cm.content_type_id = 36
	WHERE  ((cm.content_type_id = @contentTypeId) OR (@contentTypeId IS NULL))
			AND ((cm.site_id = @siteId) OR (@siteId IS NULL))
	

	SELECT ROW_NUMBER() OVER(ORDER BY tcm.site_id, content_created) AS rowNum, 
			site_name, id, site_id, content_type_id, content_id, title_tag, keywords, description,
			content_name, content_created, content_modified, enabled, modified, created, noindex, referrer_policy_id into #orderedContentMetadata
	FROM #contentMetadata tcm

	SELECT * 
	FROM #orderedContentMetadata
	WHERE rowNum BETWEEN @pageStart AND @pageEnd

	SELECT @recordCount = COUNT(id) 
	FROM #contentMetadata	

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadataInformation TO VpWebApp 
GO

