IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'confirmation_email_template' AND Object_ID = OBJECT_ID(N'review_type')) 
BEGIN
    ALTER TABLE review_type ADD confirmation_email_template VARCHAR(MAX) NULL
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'published_email_template' AND Object_ID = OBJECT_ID(N'review_type')) 
BEGIN
    ALTER TABLE review_type ADD published_email_template VARCHAR(MAX) NULL
END
GO
--------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_AddReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_AddReviewType]
	@id int output,
	@siteId int,
	@articleTypeTemplateId int,
	@sortOrder int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@hasImage bit,
	@created smalldatetime output,	
	@description varchar(MAX),
	@confirmationEmailTemplate varchar(MAX),
	@publishedEmailTemplate varchar(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [review_type] (site_id, name, title, [enabled], modified, created, has_image, [description],[sort_order], article_type_template_id, confirmation_email_template, published_email_template)
	VALUES (@siteId, @name, @title, @enabled, @created, @created, @hasImage, @description, @sortOrder, @articleTypeTemplateId, @confirmationEmailTemplate, @publishedEmailTemplate)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminReviewType_AddReviewType TO VpWebApp 
GO
-------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_UpdateReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_UpdateReviewType]
	@id int,
	@siteId int,
	@articleTypeTemplateId int,
	@sortOrder int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@hasImage bit,	
	@description varchar(MAX),
	@confirmationEmailTemplate varchar(MAX),
	@publishedEmailTemplate varchar(MAX)
	 
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[review_type]
	SET site_id = @siteId,
		article_type_template_id = @articleTypeTemplateId,
		[name] = @name,
		title = @title,
		[enabled] = @enabled,		
		modified = @modified,
		has_image = @hasImage,
		[sort_order] = @sortOrder,
		[description] = @description,
		[confirmation_email_template] = @confirmationEmailTemplate,
		[published_email_template] = @publishedEmailTemplate
	WHERE review_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminReviewType_UpdateReviewType TO VpWebApp 
GO
----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicReviewType_GetReviewTypeDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_template_id, [name], title, enabled, created, modified, 
		[has_image], [description], [sort_order], [confirmation_email_template], [published_email_template]
	FROM [review_type]	
	WHERE review_type_id = @id 

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetail TO VpWebApp 
GO
---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteId
@siteId int
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_template_id, [name], title, enabled, created, modified, 
		[has_image], [description], [sort_order], [confirmation_email_template], [published_email_template]
	FROM [review_type]	
	WHERE site_id = @siteId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteId TO VpWebApp 
GO
-------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId
@siteId int,
@articleTypeId int
	
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [review_type].review_type_id as id, [review_type].site_id, [review_type].article_type_template_id, [review_type].[name], 
		[review_type].title, [review_type].enabled, [review_type].created, [review_type].modified, [review_type].[has_image], [review_type].[description], 
		[review_type].[sort_order], [review_type].[confirmation_email_template], [review_type].[published_email_template]
	FROM [review_type]	
		INNER JOIN article_type_template 
			ON review_type.article_type_template_id = article_type_template.article_type_template_id
	WHERE [review_type].site_id = @siteId AND article_type_template.article_type_id = @articleTypeId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId TO VpWebApp 
GO
------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_GetReviewTypesWithForms'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminReviewType_GetReviewTypesWithForms
	@siteId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky
-- ==========================================================================
BEGIN
	
	SELECT rt.review_type_id AS id, rt.has_image, rt.article_type_template_id, rt.name, rt.title, 
		rt.[description], rt.[enabled], rt.modified, rt.created, rt.site_id, rt.sort_order, 
		rt.[confirmation_email_template], rt.[published_email_template]
	FROM review_type rt
		INNER JOIN form fm
			ON fm.content_id = rt.review_type_id
	WHERE  fm.site_id = @siteId AND fm.content_type_id = 37

END
GO

GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypesWithForms TO VpWebApp 
GO
-------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_GetReviewTypeBySiteIdPageList'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_GetReviewTypeBySiteIdPageList]
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM review_type
	WHERE site_id = @siteId;

	WITH temp_review_type (row, id, site_id, article_type_template_id, name, title, [enabled], created, modified, has_image, [description], [sort_order], [confirmation_email_template], [published_email_template]) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY sort_order ASC) AS row, review_type_id as id, site_id, article_type_template_id, name, title, [enabled]
			, created, modified, has_image, [description], [sort_order], [confirmation_email_template], [published_email_template]
		FROM review_type
		WHERE site_id = @siteId
	)

	SELECT id, site_id, article_type_template_id, name, title, [enabled], created, modified, has_image, [description], [sort_order]
		, [confirmation_email_template], [published_email_template]
	FROM temp_review_type
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO
GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypeBySiteIdPageList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewCountNewList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminAnalytics_GetContentPageViewCountNewList]          
 @siteId int,          
 @batchSize int,          
 @summaryStartTime datetime
 WITH RECOMPILE             
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


EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_GetContentPageViewCountList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  

CREATE PROCEDURE [dbo].[adminAnalytics_GetContentPageViewCountList]      
 @siteId int,      
 @currentDate smalldatetime,      
 @summaryType int,      
 @startIndex int,      
 @endIndex int 
 WITH RECOMPILE    
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

