
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationsNotInParent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationsNotInParent
    @parentProductId INT ,
    @contentTypeId INT,
    @productIds VARCHAR(MAX)
 AS 
-- ==========================================================================  
-- $Author: dimuthu $  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
  
     SELECT sc.specification_id AS id ,
                sc.content_id ,
                sc.spec_type_id ,
                sc.specification ,
                sc.display_options ,
                sc.enabled ,
                sc.modified ,
                sc.created ,
                sc.content_type_id
        FROM    specification sc
        LEFT JOIN specification sp ON sp.spec_type_id = sc.spec_type_id
        AND sp.content_id = @ParentProductId AND sp.content_type_id =sc.content_type_id
        AND sp.specification = sc.specification
        
        WHERE   sc.content_type_id = @contentTypeId
                AND sc.content_id IN (
                SELECT  product_id
                FROM    dbo.product_to_product
                WHERE   parent_product_id = @ParentProductId )           
        AND sp.specification IS NULL 
  
    END  
    
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationsNotInParent TO VpWebApp 
GO



--------------- 1.31.0.522 ---------

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

-------------- 1.31.0.523 -----------

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

------- 1.31.0.524 ------



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




