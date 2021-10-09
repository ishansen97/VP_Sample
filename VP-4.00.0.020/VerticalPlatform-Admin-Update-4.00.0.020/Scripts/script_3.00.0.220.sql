IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[user]') 
         AND name = 'two_factor_enabled'
)
BEGIN
ALTER TABLE [dbo].[user] 
ADD two_factor_enabled BIT  NOT NULL DEFAULT 0

END
GO

-----------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUserByAspNetUserIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUserByAspNetUserIdList
@id uniqueidentifier
AS
-- ==========================================================================
-- $URL: https://dbserver:8443/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetUserByAspNetUserIdList.sql $
-- $Revision: 1 $
-- $Date: 2008-05-28 15:39:43 +0530 (Wed, 28 May 2008) $ 
-- $Author: wathsala $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user_id]AS id, aspnet_user_id, first_name, last_name, salutation_id, email_html,
		is_supper_user, user_status_type_id, country_id, [enabled], modified, created, two_factor_enabled
	FROM [user]
	WHERE [aspnet_user_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUserByAspNetUserIdList TO VpWebApp 
GO

------------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_UpdateTwoFactorAuthOfUser'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_UpdateTwoFactorAuthOfUser
	@userId int,
	@isEnabled bit
AS
-- ==========================================================================
-- $Author: chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [user]
	SET 
		two_factor_enabled = @isEnabled,
		modified = GETDATE()
	WHERE [user_id] = @userId

END
GO

GRANT EXECUTE ON dbo.adminUser_UpdateTwoFactorAuthOfUser TO VpWebApp 
GO



-------------------------------------------------------

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'user_token')
BEGIN
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	
	CREATE TABLE [dbo].[user_token](
		[user_token_id] int IDENTITY(1,1),
		[user_id] int NOT NULL,
		[token] VARCHAR(100),
		[last_authenticated_timestamp] smalldatetime,
		[is_remember_me_enabled] bit NOT NULL,
		[enabled] bit NOT NULL,
		[created] smalldatetime,
		[modified] smalldatetime
	CONSTRAINT [PK_user_token] PRIMARY KEY CLUSTERED ([user_token_id] ASC)	
	CONSTRAINT FK_user FOREIGN KEY (user_id)
    REFERENCES [dbo].[user](user_id)
)END


---------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_user_id' AND object_id = OBJECT_ID('user_token'))
 BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_user_id
	ON [dbo].[user_token](user_id)
END

----------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUserToken_AddUserToken'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUserToken_AddUserToken
	@userId int,
	@token VARCHAR(100),
	@lastAuthenticatedTimestamp smalldatetime,
	@isRememberMeEnabled bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO user_token(user_id, token, last_authenticated_timestamp, is_remember_me_enabled, enabled, created, modified)
	VALUES(@userId, @token, @lastAuthenticatedTimestamp, @isRememberMeEnabled, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY() 

END
GO

GRANT EXECUTE ON dbo.adminUserToken_AddUserToken TO VpWebApp 
GO


---------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUserToken_GetUserTokenDetails'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUserToken_GetUserTokenDetails
	@id int
AS
-- ==========================================================================
-- $Author: chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT user_token_id AS id, user_id, token, last_authenticated_timestamp, is_remember_me_enabled, enabled, modified, created
	FROM user_token
	WHERE user_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminUserToken_GetUserTokenDetails TO VpWebApp 
GO

----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUserToken_UpdateUserToken'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUserToken_UpdateUserToken
	@id int,
	@userId int,
	@token VARCHAR(100),
	@lastAuthenticatedTimestamp smalldatetime,
	@isRememberMeEnabled bit,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @modified = GETDATE()

	UPDATE user_token
	SET user_id = @userId
		, token = @token
		, last_authenticated_timestamp = @lastAuthenticatedTimestamp
		, is_remember_me_enabled = @isRememberMeEnabled
		, [enabled] = @enabled
		, modified =  @modified
	WHERE user_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminUserToken_UpdateUserToken TO VpWebApp 
GO

-------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUserToken_DeleteUserToken'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUserToken_DeleteUserToken
	@id int
AS
-- ==========================================================================
-- $Author: chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM user_token
	WHERE user_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminUserToken_DeleteUserToken TO VpWebApp 
GO

-----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUserToken_GetAuthTokenForUserByUserId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUserToken_GetAuthTokenForUserByUserId
	@userId int
AS
-- ==========================================================================
-- $Author: chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT user_token_id AS id, user_id, token, last_authenticated_timestamp, is_remember_me_enabled, enabled, modified, created
	FROM user_token
	WHERE user_id = @userId

END
GO

GRANT EXECUTE ON dbo.adminUserToken_GetAuthTokenForUserByUserId TO VpWebApp 
GO

----------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_AddUser'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_AddUser
	@aspnetUserId uniqueidentifier,
	@firstName nvarchar(255),
	@lastName nvarchar(255),
	@salutationId tinyint = null,
	@emailHtml bit,
	@isSupperUser bit,
	@userStatusTypeId tinyint,
	@countryId smallint,
	@enabled bit,
	@twoFactorEnabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_AddUser.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [USER] (aspnet_user_id, first_name, last_name, salutation_id, email_html,is_supper_User,
		 user_status_type_id, country_id, [enabled], modified, created, two_factor_enabled)
	VALUES (@aspnetUserId, @firstName, @lastName, @salutationId, @emailHtml, @isSupperuser, @userStatusTypeId, 
		@countryId, @enabled, @created, @created, @twoFactorEnabled)

	SET @id = SCOPE_IDENTITY() 

END
GO

GRANT EXECUTE ON dbo.adminUser_AddUser TO VpWebApp 
GO

---------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetUserDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetUserDetail
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicUser_GetUserDetail.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user_id] AS id, aspnet_user_id, first_name, last_name, salutation_id, email_html
		, is_supper_user, user_status_type_id, country_id, [enabled], modified, created, two_factor_enabled
	FROM [user]
	WHERE [user_id]= @id

END
GO

GRANT EXECUTE ON dbo.publicUser_GetUserDetail TO VpWebApp 
GO

-----------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_UpdateUser'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_UpdateUser
	@id int,
	@aspnetUserId uniqueidentifier,
	@firstName nvarchar(255)= null,
	@lastName nvarchar(255)=null,
	@salutationId tinyint= null,
	@emailHtml bit,
	@isSupperUser bit,
	@userStatusTypeId tinyint,
	@countryId smallint,
	@enabled bit,
	@twoFactorEnabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_UpdateUser.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [user]
	SET 
		aspnet_user_id = @aspnetUserId,
		first_name = @firstName,
		last_name = @lastName,
		salutation_id = @salutationId,
		email_html = @emailHtml,
		is_supper_user = @isSupperUser,
		user_status_type_id = @userStatusTypeId,
		country_id = @countryId,
		[enabled] = @enabled,
		modified = @modified,
		two_factor_enabled = @twoFactorEnabled
	WHERE [user_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminUser_UpdateUser TO VpWebApp 
GO

--------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUserByAspNetUserIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUserByAspNetUserIdList
@id uniqueidentifier
AS
-- ==========================================================================
-- $URL: https://dbserver:8443/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetUserByAspNetUserIdList.sql $
-- $Revision: 1 $
-- $Date: 2008-05-28 15:39:43 +0530 (Wed, 28 May 2008) $ 
-- $Author: wathsala $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user_id]AS id, aspnet_user_id, first_name, last_name, salutation_id, email_html,
		is_supper_user, user_status_type_id, country_id, [enabled], modified, created, two_factor_enabled
	FROM [user]
	WHERE [aspnet_user_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUserByAspNetUserIdList TO VpWebApp 
GO

-----------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetSupperUsers'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetSupperUsers 
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetSupperUsers.sql $
-- $Revision: 4961 $
-- $Date $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user_id] AS id, aspnet_user_id, first_name, last_name
		, salutation_id, email_html, is_supper_user, user_status_type_id, country_id
		, [enabled], modified, created, two_factor_enabled
	FROM [user]
	WHERE is_supper_user = '1'

END
GO

GRANT EXECUTE ON dbo.adminUser_GetSupperUsers TO VpWebApp
GO
-------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUserBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUserBySiteId
	@siteId int 
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetUserBySiteId.sql $
-- $Revision $
-- $Date: 2010-11-12 15:37:24 +0530 (Fri, 12 Nov 2010) $ 
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user].[user_id] AS id, aspnet_user_id, first_name, last_name
	, salutation_id, email_html, is_supper_user, user_status_type_id, country_id
	, [user].enabled, [user].modified, [user].created, [user].two_factor_enabled
	FROM (SELECT DISTINCT user_to_role.[user_id]
		FROM user_to_role
		WHERE user_to_role.site_id = @siteId OR user_to_role.site_id IS NULL) temp_user
			INNER JOIN [user]
				ON temp_user.[user_id] = [user].[user_id]

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUserBySiteId TO VpWebApp
GO
-------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUserList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUserList
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetUserList.sql $
-- $Revision $
-- $Date: 2010-11-24 19:08:14 +0530 (Wed, 24 Nov 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user].[user_id] AS id, aspnet_user_id, first_name, last_name
			, salutation_id, email_html, is_supper_user, user_status_type_id, country_id
			, [user].enabled, [user].modified, [user].created, [user].two_factor_enabled
	FROM [user]
	WHERE is_supper_user = '0'

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUserList TO VpWebApp
GO
---------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUserBySiteIdStartRowIndexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUserBySiteIdStartRowIndexEndRowIndexList
	@siteId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalRecords int output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetUserBySiteIdStartRowIndexEndRowIndexList.sql $
-- $Revision $
-- $Date: 2010-12-02 15:15:28 +0530 (Thu, 02 Dec 2010) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH user_list (id, row_index, aspnet_user_id, first_name, last_name, salutation_id, email_html, is_supper_user
			, user_status_type_id, country_id, enabled, modified, created, two_factor_enabled) AS 
	(
		SELECT [user].[user_id] AS id, ROW_NUMBER() OVER(ORDER BY [user].[user_id]) AS row_index, aspnet_user_id, first_name, last_name
				, salutation_id, email_html, is_supper_user, user_status_type_id, country_id
				, [user].enabled, [user].modified, [user].created, [user].two_factor_enabled
		FROM (SELECT DISTINCT user_to_role.[user_id]
			FROM user_to_role
			WHERE user_to_role.site_id = @siteId OR user_to_role.site_id IS NULL) temp_user
				INNER JOIN [user]
					ON temp_user.[user_id] = [user].[user_id]
	)

	SELECT id, aspnet_user_id, first_name, last_name, salutation_id, email_html, is_supper_user
			, user_status_type_id, country_id, enabled, modified, created, two_factor_enabled
	FROM user_list
	WHERE row_index BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRecords = COUNT(*)
	FROM (SELECT DISTINCT user_to_role.[user_id]
			FROM user_to_role
			WHERE user_to_role.site_id = @siteId OR user_to_role.site_id IS NULL) temp_user
				INNER JOIN [user]
					ON temp_user.[user_id] = [user].[user_id]

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUserBySiteIdStartRowIndexEndRowIndexList TO VpWebApp
GO
----------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUserByStartRowIndexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUserByStartRowIndexEndRowIndexList
	@startRowIndex int,
	@endRowIndex int,
	@totalRecords int output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetUserByStartRowIndexEndRowIndexList.sql $
-- $Revision $
-- $Date: 2010-12-02 15:15:28 +0530 (Thu, 02 Dec 2010) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH user_list(id, row_index, aspnet_user_id, first_name, last_name, salutation_id, email_html, is_supper_user
			, user_status_type_id, country_id, enabled, modified, created, two_factor_enabled) AS
	(
		SELECT [user].[user_id] AS id, ROW_NUMBER() OVER(ORDER BY [user].[user_id]) AS row_index, aspnet_user_id, first_name, last_name
				, salutation_id, email_html, is_supper_user, user_status_type_id, country_id
				, [user].enabled, [user].modified, [user].created, [user].two_factor_enabled
		FROM [user]
		WHERE is_supper_user = '0'
	)

	SELECT id, aspnet_user_id, first_name, last_name, salutation_id, email_html, is_supper_user
			, user_status_type_id, country_id, enabled, modified, created, two_factor_enabled
	FROM user_list
	WHERE row_index BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRecords = COUNT(*)
	FROM [user]
	WHERE is_supper_user = '0'

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUserByStartRowIndexEndRowIndexList TO VpWebApp
GO
----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUserBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUserBySiteIdList
	@siteId int 
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminUser_GetUserBySiteIdList.sql $
-- $Revision $
-- $Date: 2011-01-04 13:50:45 +0530 (Tue, 04 Jan 2011) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [user_id] AS id, aspnet_user_id, first_name, last_name
	, salutation_id, email_html, is_supper_user, user_status_type_id, country_id
	, enabled, modified, created, two_factor_enabled
	FROM [user]
	WHERE is_supper_user = '1' OR [user_id] IN 
	(
		SELECT [user_id]
		FROM user_to_role
		WHERE site_id = @siteId
	)
		

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUserBySiteIdList TO VpWebApp
GO
------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetUsersForRolesList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetUsersForRolesList
	@siteId int,
	@roles varchar(255) 
AS
-- ==========================================================================
-- $Author: Nilushi Hikkaduwa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT u.[user_id] AS id, u.aspnet_user_id, u.first_name, u.last_name
			, u.salutation_id, u.email_html, u.is_supper_user, u.user_status_type_id, u.country_id
			, u.enabled, u.modified, u.created, u.two_factor_enabled
	FROM [user] u 
		INNER JOIN user_to_role ur 
			ON u.[user_id] = ur.[user_id] 
		INNER JOIN [role] r 
			ON r.role_id = ur.role_id 
--	WHERE r.[name] LIKE 'MediaCoordinator' OR r.[name] LIKE 'SalesPerson'
	WHERE r.[name] IN (SELECT [value] FROM Global_Split(@roles, ','))
	AND (ur.site_id = @siteId OR ur.site_id IS NULL)

END
GO

GRANT EXECUTE ON dbo.adminUser_GetUsersForRolesList TO VpWebApp
GO
-------------------------------------------------------------------------------

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
			, u.enabled, u.modified, u.created, u.two_factor_enabled
	FROM [user] u

END
GO

GRANT EXECUTE ON dbo.adminUser_GetAllUsers TO VpWebApp
GO
----------------------------------------------------------------------------------

