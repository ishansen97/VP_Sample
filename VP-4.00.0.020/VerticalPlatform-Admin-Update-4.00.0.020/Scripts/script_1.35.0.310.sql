IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'confirmation_email_template' AND Object_ID = OBJECT_ID(N'review_type')) 
BEGIN
	UPDATE review_type SET confirmation_email_template = '{#VPX Language="Ruby"#}  <html>  <body vlink="#2782D1" ' + 
	'alink="#2782D1" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; color: #333333; background-color:#ffffff;">' +
	'  <div align="center">  <table width="600" border="0" cellspacing="0" cellpadding="0">  <tr>  <td style="border:1px' +
	' solid #cccccc;">  <table width="600" border="0" cellspacing="0" cellpadding="0">  <tr>  <td width="20">&nbsp;</td>  ' +
	'<td align="left" width="560" height="150" style="color:#503f34; border-bottom: 1px solid #cccccc;">  <img src="{=context.' +
	'EmailLogoUrl=}" width="252" height="98" alt="{=context.Site.Name=}" border="0"/>  </td>  <td width="20">&nbsp;</td>  </tr>  ' +
	'<tr>  <td>&nbsp;</td>  <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size: 14px; line-height:18px; ' +
	'color:#333333; padding-top: 25px;">  <div style="margin-bottom: 32px; font-family:Arial, Helvetica, sans-serif; font-size:20px;' +
	' color:#333333;">  <strong>We received your  review!</strong>  </div>  <div>  <p>  Hi {=context.AuthorName(0)=},  </p>  <br/>  ' +
	'<p>  Thank you for submitting a {=context.ReviewType.Name=} review on {=context.Site.Name=}.  To complete the {=context.ReviewType.Name=}' +
	' review submission please click on the link below so that we can verify your email address. This is important as we will be sending the' +
	' Amazon gift card via email (to those who submit an image with their review).  </p>  <p style="font-size:16px; font-weight:bold;">  ' +
	'Verification Link: {=context.ArticleVerificationUrl=}</p>  <p>We have included some details about your review below:<br/>  ' +
	'{=context.ReviewType.Name=}  Product Review Title: {=context.Article.Title=}  <br/>  Product: {=context.GetRelatedProducts()[0].Name=}' +
	'  <br/>  </p>  <p>If you have questions about any of this please email us at <a href="mailto:review_questions@biocompare.com">review_questions' +
	'@biocompare.com</a></p>  </div>  <br/>  <br/>  <br/>  <br/>  <br/>  <div>  Regards,  <br/>  <br/>  <strong>{=context.SiteSignature=}</strong>  ' +
	'</div>  </td>  <td>&nbsp;</td>  </tr>  <tr>  <td width="20" height="100">&nbsp;</td>  <td width="560" height="100">&nbsp;</td>  <td width="20"' + 
	' height="100">&nbsp;</td>  </tr>  </table>  </td>  </tr>  </table>  <table width="590" border="0" cellspacing="0" cellpadding="0">  <tr>  ' +
	'<td width="300" height="30" align="left" style="font-family: Arial, Helvetica, sans-serif; color:#666666; text-align:left; font-size:11px;">' +
	'  {=context.SiteCopyrightMessage=}  </td>  <td width="290" height="30" align="right" style="font-family: Arial, Helvetica, sans-serif;' +
	' color:#666666; text-align:right; font-size:11px;">  <a href="{=context.PublicSiteUrl=}" target="_blank" style="text-decoration: underline;' +
	' color:#2782D1" title="{=context.Site.Name=}.com">{=context.Site.Name=}.com</a>  </td>  </tr>  </table>  </div>  </body>  </html>' 
	WHERE confirmation_email_template IS NULL
    ALTER TABLE review_type ALTER COLUMN confirmation_email_template VARCHAR(MAX) NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'published_email_template' AND Object_ID = OBJECT_ID(N'review_type')) 
BEGIN
	UPDATE review_type SET published_email_template = '{#VPX Language="Ruby"#}  <html>  <body vlink="#2782D1" alink="#2782D1" style="font-family:Arial' +
	', Helvetica, sans-serif; font-size:14px; color: #333333; background-color:#ffffff;">  <div align="center">  <table width="600" border="0" ' +
	'cellspacing="0" cellpadding="0">  <tr>  <td style="border:1px solid #cccccc;">  <table width="600" border="0" cellspacing="0" cellpadding="0">  ' +
	'<tr>  <td width="20">&nbsp;</td>  <td align= "left" width= "560" height= "150" style= "color:#503f34; border-bottom: 1px solid #cccccc;">  ' +
	'<img src="{=context.EmailLogoUrl=}" width= "252" height= "98" alt="{=context.Site.Name=}" border= "0" />  </td>  <td width= "20">&nbsp;</td>' +
	'  </tr>  <tr>  <td>&nbsp;</td>  <td align="left" style= "font-family:Arial, Helvetica, sans-serif; font-size: 14px; line-height:18px; color:#333333;' +
	' padding-top: 25px;">  <div style= "margin-bottom: 32px; font-family:Arial, Helvetica, sans-serif; font-size:20px; color:#333333;">  <strong>Your' +
	' review has been published!</strong>  </div>  <div>  <p>  Hi {=context.AuthorName(0)=},  </p>  <br/>  <p>  Your review has been published on' +
	' {=context.Site.Name=}.  </p>  <br/>  <p>  We have included some details about you review below:  <br/>  Product Review Title:' +
	' {=context.Article.Title=}  <br/>  Product: {=context.GetRelatedProducts()[0].Name=}  <br/>  Gift Card Number: {=context.GiftCardId=}  <br/>  ' +
	'Preview Link: {=context.ArticlePreviewUrl=}  </p>  </div>  <br/>  <br/>  <br/>  <br/>  <br/>  <div>  Regards,  <br/>  <br/>  <strong>' +
	'{=context.SiteSignature=}</strong>  </div>  </td>  <td>&nbsp;</td>  </tr>  <tr>  <td width= "20" height= "100">&nbsp;</td>  <td width= "560" height= ' +
	'"100">&nbsp;</td>  <td width= "20" height= "100">&nbsp;</td>  </tr>  </table>  </td>  </tr>  </table>  <table width= "590" border= "0" cellspacing=' +
	' "0" cellpadding= "0">  <tr>  <td width= "300" height= "30" align= "left" style= "font-family: Arial, Helvetica, sans-serif; color:#666666; ' +
	'text-align:left; font-size:11px;">  {=context.SiteCopyrightMessage=}  </td>  <td width="290" height="30" align="right" style="font-family: Arial, ' +
	'Helvetica, sans-serif; color:#666666; text-align:right; font-size:11px;">  <a href="{=context.PublicSiteUrl=}" target="_blank" style="text-decoration: ' +
	'underline; color:#2782D1" title="{=context.Site.Name=}.com">{=context.Site.Name=}.com</a>  </td>  </tr>  </table>  </div>  </body>  </html>' 
	WHERE published_email_template IS NULL
    ALTER TABLE review_type ALTER COLUMN published_email_template VARCHAR(MAX) NOT NULL
END
GO
------------------------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList
	@siteId int,
	@sortBy varchar(20),
	@startIndex int,
	@endIndex int,
	@articleTypes varchar(200),
	@startDate smalldatetime,
	@endDate smalldatetime,
	@title varchar(max),
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH articles AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY article_title) AS titleRowNumber
			, ROW_NUMBER() OVER (ORDER BY created DESC) AS createdRowNumber
			, article_id AS id, article_type_id, site_id, article_title
			, article_summary, [enabled], modified, created, article_short_title
			, date_published, start_date, end_date, published, external_url_id, is_article_template, is_external
			, featured_identifier, thumbnail_image_code,article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM article
		WHERE is_article_template = 0 AND ((@articleTypes = '' AND site_id = @siteId)  OR article_type_id IN (SELECT [value] FROM Global_Split(@articleTypes, ',')))
			AND (article_title LIKE (@title + '%') OR @title IS NULL)
			AND (@startDate IS NULL OR created BETWEEN @startDate AND @endDate)
			AND deleted = 0
	)
	
	SELECT id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
		, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
		, flag1, flag2, flag3, flag4, search_content_modified, deleted
		, CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
		END AS row
	INTO #tempArticles
	FROM articles
	ORDER BY 
		CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
		END

	SELECT @numberOfRows = COUNT(*)
	FROM #tempArticles	

    IF((@startIndex IS NOT NULL) AND (@endIndex IS NOT NULL))
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code,article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles
			WHERE (row BETWEEN @startIndex AND @endIndex)
		END
	ELSE
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles			
		END

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList TO VpWebApp 
GO


--------------

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name = 'search_performance')
BEGIN
	CREATE TABLE search_performance(
		[search_performance_id] [int] IDENTITY(1,1) NOT NULL,
		[timestamp] [smalldatetime] NOT NULL,
		[all_products_query_time] [int] NOT NULL,
		[featured_products_query_time] [int],
		[all_products_request_time] [int] NOT NULL,
		[featured_products_request_time] [int],
		[all_products_query] [varchar](max) NOT NULL,
		[featured_products_query] [varchar](max),	
		[total_rendering_time] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_search_performance_id] PRIMARY KEY CLUSTERED 
	(
		[search_performance_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

---

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddSearchPerformance'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddSearchPerformance
	@timestamp smalldatetime,
	@allProductsQueryTime int,
	@featuredProductsQueryTime int,
	@allProductsRequestTime int,
	@featuredProductsRequestTime int,
	@allProductsQuery varchar(max),
	@featuredProductsQuery varchar(max),
	@totalRenderingTime int,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO search_performance(timestamp, all_products_query_time, featured_products_query_time, all_products_request_time, featured_products_request_time, all_products_query, featured_products_query, total_rendering_time, enabled, created, modified)
	VALUES (@timestamp, @allProductsQueryTime, @featuredProductsQueryTime, @allProductsRequestTime, @featuredProductsRequestTime, @allProductsQuery, @featuredProductsQuery, @totalRenderingTime, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearch_AddSearchPerformance TO VpWebApp 
GO

GO

----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateSearchPerformance'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateSearchPerformance
	@id int,
	@timestamp smalldatetime,
	@allProductsQueryTime int,
	@featuredProductsQueryTime int,
	@allProductsRequestTime int,
	@featuredProductsRequestTime int,
	@allProductsQuery varchar(max),
	@featuredProductsQuery varchar(max),
	@totalRenderingTime int,
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE search_performance
	SET timestamp = @timestamp, 
	all_products_query_time = @allProductsQueryTime, 
	featured_products_query_time = @featuredProductsQueryTime, 
	all_products_request_time = @allProductsRequestTime, 
	featured_products_request_time = @featuredProductsRequestTime, 
	all_products_query = @allProductsQuery, 
	featured_products_query = @featuredProductsQuery, 
	total_rendering_time = @totalRenderingTime, 
	enabled = @enabled,
	modified = @modified
	WHERE search_performance_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateSearchPerformance TO VpWebApp 
GO

--------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetSearchPerformanceDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetSearchPerformanceDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT search_performance_id AS id, timestamp, all_products_query_time, featured_products_query_time, all_products_request_time, featured_products_request_time, all_products_query, featured_products_query, total_rendering_time, created, enabled, modified
	FROM search_performance
	WHERE search_performance_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_GetSearchPerformanceDetail TO VpWebApp 
GO

-------

-- ==========================================================================
-- $Author: Premuditha $
-- ==========================================================================

IF NOT EXISTS (Select * FROM module WHERE module_name = 'ProductSharing')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
		VALUES('ProductSharing', '~/Modules/ProductDetail/ProductSharing.ascx', 1, GETDATE(), GETDATE(), 0)
END
GO

-------
