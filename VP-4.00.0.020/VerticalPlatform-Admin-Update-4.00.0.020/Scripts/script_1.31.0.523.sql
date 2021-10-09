IF NOT EXISTS (SELECT name FROM sys.indexes
           WHERE name = N'IX_content_page_view_summary_contentid_siteid_contenttypeid')
BEGIN

CREATE NONCLUSTERED INDEX [IX_content_page_view_summary_contentid_siteid_contenttypeid] 
ON [dbo].[content_page_view_summary] 
(
	[site_id],
	[content_type_id],
	[content_id]
)
INCLUDE ( [summary_type_id]) 
WITH (
	STATISTICS_NORECOMPUTE  = OFF, 
	SORT_IN_TEMPDB = OFF, 
	IGNORE_DUP_KEY = OFF, 
	DROP_EXISTING = OFF, 
	ONLINE = OFF, 
	ALLOW_ROW_LOCKS  = ON, 
	ALLOW_PAGE_LOCKS  = ON
) 
ON [PRIMARY]

END
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewCountNoneTrackedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_GetContentPageViewCountNoneTrackedList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) v.site_id, v.content_type_id, v.content_id, COUNT(v.content_id) AS [views]
	FROM content_page_views AS v
	WHERE NOT EXISTS
		(SELECT s.content_page_view_summary_id
		FROM content_page_view_summary AS s
		WHERE s.content_type_id = v.content_type_id AND s.content_id = v.content_id AND summary_type_id = 3)
	GROUP BY v.site_id, v.content_type_id, v.content_id

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewCountNoneTrackedList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewCountNewList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_GetContentPageViewCountNewList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) v.site_id, v.content_type_id, v.content_id, COUNT(v.content_id) AS [views]
	FROM content_page_views AS v
		INNER JOIN content_page_view_summary AS s
			ON v.content_type_id = s.content_type_id AND v.content_id = s.content_id AND summary_type_id = 3
	WHERE (v.site_id = @siteId) AND (v.created > s.modified)
	GROUP BY v.site_id, v.content_type_id, v.content_id

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewCountNewList TO VpWebApp 
GO