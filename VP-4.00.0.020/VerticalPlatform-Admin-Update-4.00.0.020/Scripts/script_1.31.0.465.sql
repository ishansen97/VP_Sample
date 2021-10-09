
EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewCountList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_GetContentPageViewCountList
	@siteId int,
	@currentDate smalldatetime,
	@summaryType int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startDate smalldatetime
	IF (@summaryType = 1)
	BEGIN
		SET @startDate = DATEADD(week, -1, @currentDate)
	END

	ELSE IF (@summaryType = 2)
	BEGIN
		SET @startDate = DATEADD(month, -1, @currentDate)
	END;

	WITH temp_content_view (row, site_id, content_type_id, content_id, [views]) AS 
	(
		SELECT ROW_NUMBER() OVER(ORDER BY content_type_id) row, site_id, content_type_id, content_id, [views]
		FROM
			(SELECT site_id, content_type_id, content_id, COUNT(content_id) AS [views]
			FROM content_page_views
			WHERE (site_id = @siteId OR @siteId IS NULL)
				AND created BETWEEN @startDate AND @currentDate
			GROUP BY site_id, content_type_id, content_id) AS content_view_count
	)

	SELECT site_id, content_type_id, content_id, [views]
	FROM temp_content_view
	WHERE row BETWEEN @startIndex AND @endIndex

 
END
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewCountList TO VpWebApp 
GO