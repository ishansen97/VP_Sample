
EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewCountNewList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_GetContentPageViewCountNewList
	@siteId int,
	@batchSize int,
	@summaryStartTime datetime
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) v.site_id, v.content_type_id, v.content_id, COUNT(v.content_id) AS [views]
	FROM content_page_views AS v
		LEFT JOIN content_page_view_summary AS s
			ON v.content_type_id = s.content_type_id AND v.content_id = s.content_id 
				AND summary_type_id = 3
	WHERE (v.site_id = @siteId) 
		AND ((s.modified IS NULL) OR (v.created > s.modified))
		AND (v.created < @summaryStartTime)
	GROUP BY v.site_id, v.content_type_id, v.content_id

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewCountNewList TO VpWebApp 
GO