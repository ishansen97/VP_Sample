
EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewSummaryByLastModified'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].[adminAnalytics_GetContentPageViewSummaryByLastModified]      
 @siteId int,      
 @summaryTypeId int   
AS
   
-- ==========================================================================      
-- $Author: Dhanushka $      
-- ==========================================================================
    
BEGIN      
       
 SET NOCOUNT ON;
 
 SELECT TOP 1 content_page_view_summary_id AS id, summary_type_id, site_id, content_type_id, 
	content_id, [views], [enabled], modified, created
 FROM content_page_view_summary
 WHERE site_id = @siteId AND summary_type_id = @summaryTypeId
 ORDER BY modified DESC
       
END  
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewSummaryByLastModified TO VpWebApp 
GO


------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_UpdateContentPageViewSummaryList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].[adminAnalytics_UpdateContentPageViewSummaryList]      
 @siteId int,      
 @minContentPageViewId int,  
 @maxContentPageViewId int,   
 @summaryTypeId int, 
 @batchSize int,
 @lastProcessedContentPageViewId int output
AS
   
-- ==========================================================================      
-- $Author: Dhanushka $      
-- ==========================================================================
    
BEGIN      
       
SET NOCOUNT ON; 

DECLARE @records TABLE (id int)
DECLARE @created smalldatetime
SET @created = GETDATE();

MERGE content_page_view_summary AS [target]
USING 
(
	SELECT @siteId AS site_id, content_type_id, content_id, COUNT(content_id) [views], 
		MAX(content_page_view_id) AS content_page_view_id
	FROM 
	(
		SELECT TOP (@batchSize) content_page_view_id, content_type_id, content_id, site_id, created
		FROM content_page_views
		WHERE content_page_view_id >= @minContentPageViewId AND content_page_view_id <= @maxContentPageViewId
	) paged_content_page_view
	WHERE site_id = @siteId
	GROUP BY content_type_id, content_id
) AS [source] (site_id, content_type_id, content_id, [views], content_page_view_id)
ON ([target].content_type_id = [source].content_type_id AND 
	[target].content_id = [source].content_id AND [target].summary_type_id = @summaryTypeId)
WHEN MATCHED THEN
	UPDATE SET [views] = [target].[views] + [source].[views], modified = @created
WHEN NOT MATCHED THEN
	INSERT (summary_type_id, site_id, content_type_id, 
		content_id, [views], [enabled], modified, created)
	VALUES (@summaryTypeId, @siteId, [source].content_type_id, [source].content_id, [source].[views], 
		1, @created, @created)
OUTPUT [source].content_page_view_id INTO @records;

SELECT @lastProcessedContentPageViewId = MAX(id) 
FROM @records
       
END  
GO

GRANT EXECUTE ON dbo.adminAnalytics_UpdateContentPageViewSummaryList TO VpWebApp 
GO


--------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewBoundriesForSite'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].[adminAnalytics_GetContentPageViewBoundriesForSite]      
 @siteId int,      
 @startDate smalldatetime,      
 @endDate smalldatetime   
AS
   
-- ==========================================================================      
-- $Author: Dhanushka $      
-- ==========================================================================
    
BEGIN      
       
 SET NOCOUNT ON;
 
 SELECT 
	(
	SELECT TOP 1 content_page_view_id 
	FROM content_page_views
	WHERE site_id = @siteId AND created > @startDate
	ORDER BY created, content_page_view_id
	) AS start_id,
	(
	SELECT TOP 1 content_page_view_id AS end_id 
	FROM content_page_views
	WHERE site_id = @siteId AND created < @endDate
	ORDER BY created DESC, content_page_view_id DESC
	) AS end_id    
       
END  
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewBoundriesForSite TO VpWebApp 
GO


-----------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewCountAfterIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].[adminAnalytics_GetContentPageViewCountAfterIdList]      
 @siteId int,      
 @minContentPageViewId int,  
 @maxContentPageViewId int,    
 @batchSize int   
AS
   
-- ==========================================================================      
-- $Author: Dhanushka $      
-- ==========================================================================
    
BEGIN      
       
SET NOCOUNT ON;

 SELECT @siteId AS site_id, content_type_id, content_id, COUNT(content_id) [views], 
	MAX(content_page_view_id) content_page_view_id
 FROM 
 (
	SELECT TOP (@batchSize) content_page_view_id, content_type_id, content_id, site_id, created
	FROM content_page_views
	WHERE content_page_view_id > @minContentPageViewId AND content_page_view_id < @maxContentPageViewId
 ) paged_content_page_view
 WHERE site_id = @siteId
 GROUP BY content_type_id, content_id
       
END  
GO

GRANT EXECUTE ON dbo.adminAnalytics_GetContentPageViewCountAfterIdList TO VpWebApp 
GO


----------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_UpdateContentPageViewSummaryAllTimeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].[adminAnalytics_UpdateContentPageViewSummaryAllTimeList]      
 @siteId int,      
 @minContentPageViewId int,  
 @maxContentPageViewId int,
 @batchSize int,
 @lastProcessedContentPageViewId int output
AS
   
-- ==========================================================================      
-- $Author: Dhanushka $      
-- ==========================================================================
    
BEGIN      
       
SET NOCOUNT ON; 

DECLARE @records TABLE (id int);

MERGE content_page_view_summary AS [target]
USING 
(
	SELECT @siteId AS site_id, v.content_type_id, v.content_id, COUNT(v.content_id) [views], 
		MAX(content_page_view_id) AS content_page_view_id, MAX(v.created) AS created
	FROM
	(
		SELECT TOP (@batchSize) content_page_view_id, content_type_id, content_id, site_id, created
		FROM content_page_views
		WHERE content_page_view_id >= @minContentPageViewId AND content_page_view_id <= @maxContentPageViewId
	) v
		LEFT JOIN content_page_view_summary s
			ON v.content_id = s.content_id AND v.content_type_id = s.content_type_id 
				AND s.summary_type_id = 3
	WHERE (v.created > s.modified OR s.modified IS NULL)
	GROUP BY v.content_type_id, v.content_id 
) AS [source] (site_id, content_type_id, content_id, [views], content_page_view_id, created)
ON ([target].content_type_id = [source].content_type_id AND 
	[target].content_id = [source].content_id AND [target].summary_type_id = 3)
WHEN MATCHED THEN
	UPDATE SET [views] = [target].[views] + [source].[views], modified = [source].created
WHEN NOT MATCHED THEN
	INSERT (summary_type_id, site_id, content_type_id, 
		content_id, [views], [enabled], modified, created)
	VALUES (3, @siteId, [source].content_type_id, [source].content_id, [source].[views], 
		1, [source].created, [source].created)
OUTPUT [source].content_page_view_id INTO @records;

SELECT @lastProcessedContentPageViewId = MAX(id) 
FROM @records
       
END  
GO

GRANT EXECUTE ON dbo.adminAnalytics_UpdateContentPageViewSummaryAllTimeList TO VpWebApp 
GO


-----------------------------------------------



IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[content_page_view_summary]') AND name = N'IX_content_page_view_summary_contentid_contenttype_summarytype')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_content_page_view_summary_contentid_contenttype_summarytype] ON [dbo].[content_page_view_summary] 
	(
		[content_id] ASC,
		[content_type_id] ASC,
		[summary_type_id] ASC
	)
	INCLUDE ( [modified]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO


-------------------------------------------------


