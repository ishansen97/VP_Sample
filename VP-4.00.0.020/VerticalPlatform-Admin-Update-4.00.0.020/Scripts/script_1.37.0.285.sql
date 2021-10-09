EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_DeleteContentPageViewSummaryBySummaryTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_DeleteContentPageViewSummaryBySummaryTypeList
	@siteId INT,
	@summaryTypeId INT,
	@batchSize INT,
	@rowCount INT OUTPUT
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE TOP(@batchSize)
	FROM content_page_view_summary
	WHERE (site_id = @siteId) AND (summary_type_id = @summaryTypeId)
	
	SELECT @rowCount = @@ROWCOUNT

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_DeleteContentPageViewSummaryBySummaryTypeList TO VpWebApp 
GO