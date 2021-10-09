ALTER TABLE forum_thread
ADD search_content_modified int NOT NULL DEFAULT(1)

------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedForumThreadsBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedForumThreadsBySiteIdWithPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedForumThread(id, row_id, forum_topic_id,[enabled],
		[user_id], title, [status], created, modified, is_public_user)
	AS
	(
		SELECT  forum_thread_id AS id, ROW_NUMBER() OVER (ORDER BY forum_thread_id DESC) AS row_id, fth.forum_topic_id,fth.[enabled],
		[user_id], fth.title, [status], fth.created, fth.modified, is_public_user
		FROM forum_thread fth
		INNER JOIN forum_topic ft
			ON fth.forum_topic_id = ft.forum_topic_id
		WHERE fth.enabled = 1 and ft.site_id = @siteId
	)

	SELECT id, forum_topic_id,[enabled],
				[user_id], title, [status], created, modified, is_public_user
	FROM selectedForumThread
	WHERE row_id BETWEEN @startIndex AND @endIndex
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedForumThreadsBySiteIdWithPagingList TO VpWebApp
GO

---------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetDeletedOrDisabledForumThreadSearchContentsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetDeletedOrDisabledForumThreadSearchContentsList
	@siteId int,
	@batchSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) search_content_status_id AS id, site_id, content_type_id, content_id, [enabled], created, modified
	FROM search_content_status
	WHERE content_type_id = 29 AND content_id NOT IN 
		(	SELECT forum_thread_id 
			FROM forum_thread
			WHERE enabled = 1
		)
		
	SELECT @totalCount = COUNT(*)
	FROM search_content_status
	WHERE content_type_id = 29 AND content_id NOT IN 
		(	SELECT forum_thread_id 
			FROM forum_thread
			WHERE enabled = 1
		)
END
GO

GRANT EXECUTE ON dbo.adminSearch_GetDeletedOrDisabledForumThreadSearchContentsList TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicForums_GetForumThreadsToIndexInSearchProviderList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicForums_GetForumThreadsToIndexInSearchProviderList
	@batchSize int,
	@forumTopicIds varchar(MAX),
	@totalCount int output
	
AS
-- ==========================================================================
-- $Author: Ravindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(@batchSize)
		forum_thread_id AS id, forum_topic_id,[enabled],
		[user_id], title, [status], created, modified, is_public_user
	FROM forum_thread
	WHERE enabled = 1 AND search_content_modified = 1 AND forum_topic_id IN 
		(SELECT [value] FROM dbo.global_Split(@forumTopicIds, ','))
	ORDER BY id
	
	SELECT @totalCount = COUNT(*)
	FROM forum_thread
	WHERE enabled = 1 AND search_content_modified = 1 AND forum_topic_id IN 
	(SELECT [value] FROM dbo.global_Split(@forumTopicIds, ','))
	
END
GO

GRANT EXECUTE ON dbo.publicForums_GetForumThreadsToIndexInSearchProviderList TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminForum_UpdateForumThreadSearchContentModified'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForum_UpdateForumThreadSearchContentModified
	@forumThreadId int,
	@searchContentModified bit
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	UPDATE forum_thread
	SET search_content_modified = @searchContentModified
	WHERE forum_thread_id = @forumThreadId

END
GO

GRANT EXECUTE ON dbo.adminForum_UpdateForumThreadSearchContentModified TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicForums_GetForumPosts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicForums_GetForumPosts
	@forumThreadId int
	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT forum_thread_post_id AS id, forum_thread_id,
		[user_id], subject, post, [status], is_public_user, 
		admin_note, created, modified, enabled
	FROM forum_thread_post
	WHERE forum_thread_id = @forumThreadId AND enabled = 1
END
GO

GRANT EXECUTE ON dbo.publicForums_GetForumPosts TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserNicknamesByUserIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserNicknamesByUserIds
	@publicUserIds varchar(max)
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT public_user_nickname_id AS id, public_user_id, nickname, [enabled], modified, created
	FROM public_user_nickname
	WHERE public_user_id IN ((SELECT [value] FROM global_Split(@publicUserIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserNicknamesByUserIds TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserProfileByUserIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserProfileByUserIds
	@publicUserIds varchar(max)
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT public_user_profile_id AS id, public_user_id, salutation, first_name, last_name
		, address_line1, address_line2, city, [state], country_id, phone_number, postal_code, company
		, [enabled], modified, created
	FROM public_user_profile
	WHERE public_user_id IN ((SELECT [value] FROM global_Split(@publicUserIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserProfileByUserIds TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------