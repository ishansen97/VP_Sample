
--creating index on content_page_views

IF NOT EXISTS (SELECT name FROM sys.indexes
           WHERE name = N'IX_content_page_views_siteid_created')
BEGIN
	CREATE NONCLUSTERED INDEX IX_content_page_views_siteid_created
		 ON content_page_views ([site_id],[created])
		 INCLUDE ([content_type_id], [content_id]);
END
GO 


EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_DeleteContentPageViewBySiteIdCreatedList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_DeleteContentPageViewBySiteIdCreatedList
	@siteId int,
	@createdDate smalldatetime
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON

	DELETE FROM content_page_views
	WHERE (site_id = @siteId)
		AND created < @createdDate

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_DeleteContentPageViewBySiteIdCreatedList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_DeleteContentPageViewSummaryBySummaryTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_DeleteContentPageViewSummaryBySummaryTypeList
	@siteId int,
	@summaryTypeId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM content_page_view_summary
	WHERE (site_id = @siteId) AND (summary_type_id = @summaryTypeId)

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_DeleteContentPageViewSummaryBySummaryTypeList TO VpWebApp 
GO

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
			WHERE (site_id = @siteId)
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
		LEFT JOIN content_page_view_summary AS s
			ON v.content_type_id = s.content_type_id AND v.content_id = s.content_id 
				AND v.site_id = s.site_id AND summary_type_id = 3
	WHERE (v.site_id = @siteId) 
		AND (s.modified IS NULL) OR (v.created > s.modified)
	GROUP BY v.site_id, v.content_type_id, v.content_id

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewCountNewList TO VpWebApp 
GO