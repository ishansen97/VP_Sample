IF NOT EXISTS(SELECT * FROM [module] where module_name='ForumThreadList' AND usercontrol_name='~/Modules/Forum/ForumThreadList.ascx' )
BEGIN
	INSERT INTO [module]
		([module_name]
		,[usercontrol_name]
		,[enabled]
		,[modified]
		,[created]
		,[is_container])
	VALUES
		('ForumThreadList'
		,'~/Modules/Forum/ForumThreadList.ascx'
		,1
		,GETDATE()
		,GETDATE()
		,0)
END
------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminForum_GetForumThreadsByIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForum_GetForumThreadsByIds
	@ids NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT ft.forum_thread_id AS id, ft.forum_topic_id, ft.[user_id], 
		   ft.title, ft.[status], ft.[enabled], ft.modified, ft.created, 
		   ft.is_public_user, ft.legacy_content_id
	FROM forum_thread ft
		INNER JOIN global_split(@ids,',') gs
		ON ft.forum_thread_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminForum_GetForumThreadsByIds TO VpWebApp 
GO
------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminForum_GetForumTopicsByIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminForum_GetForumTopicsByIds
	@ids NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT ft.forum_topic_id AS id, ft.site_id, ft.title, ft.[description], ft.[enabled],
			ft.modified, ft.created, ft.sort_order, ft.legacy_content_id
	FROM forum_topic ft
		INNER JOIN global_split(@ids,',') gs
		ON ft.forum_topic_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminForum_GetForumTopicsByIds TO VpWebApp 
GO
------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM [module] where module_name='CategoryDescription' AND usercontrol_name='~/Modules/Category/CategoryDescription.ascx' )
BEGIN
	INSERT INTO module
	VALUES
	(
		'CategoryDescription',
		'~/Modules/Category/CategoryDescription.ascx',
		1,
		GETDATE(),
		GETDATE(),
		0
	)
END

IF NOT EXISTS(SELECT * FROM [module] where module_name='RelatedCategories' AND usercontrol_name='~/Modules/Category/RelatedCategories.ascx' )
BEGIN
	INSERT INTO module 
	VALUES
	(
		'RelatedCategories',
		'~/Modules/Category/RelatedCategories.ascx',
		1,
		GETDATE(),
		GETDATE(),
		0
	)
END