EXEC dbo.global_DropStoredProcedure 'dbo.adminForum_GetForumTopicBySearchTextPageSizeSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForum_GetForumTopicBySearchTextPageSizeSiteId
	@pageSize INT,
	@siteId INT,
	@searchText NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@pageSize) ft.forum_topic_id AS id, ft.site_id, ft.title, ft.[description],
		ft.[enabled], ft.modified, ft.created, ft.sort_order, ft.legacy_content_id
	FROM forum_topic ft
	WHERE ft.site_id = @siteId AND ft.title LIKE '%' + @searchText + '%'
	ORDER BY ft.title

END
GO

GRANT EXECUTE ON adminForum_GetForumTopicBySearchTextPageSizeSiteId TO VpWebApp
GO
-----------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminForum_GetForumThreadBySearchTextPageSizeSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForum_GetForumThreadBySearchTextPageSizeSiteId
	@pageSize INT,
	@siteId INT,
	@searchText NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@pageSize) ft.forum_thread_id AS id, ft.forum_topic_id, ft.[user_id],
		   ft.title, ft.[status], ft.[enabled], ft.modified, ft.created,
		   ft.is_public_user, ft.legacy_content_id
	FROM forum_thread ft
		INNER JOIN forum_topic ft2
			ON ft2.forum_topic_id = ft.forum_topic_id
	WHERE ft2.site_id = @siteId AND ft.title LIKE '%' + @searchText + '%'
	ORDER BY ft.title

END
GO

GRANT EXECUTE ON adminForum_GetForumThreadBySearchTextPageSizeSiteId TO VpWebApp
GO