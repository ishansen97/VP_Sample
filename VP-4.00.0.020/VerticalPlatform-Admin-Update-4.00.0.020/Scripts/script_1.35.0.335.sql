IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'published_email_template' AND Object_ID = OBJECT_ID(N'review_type')) 
BEGIN
	UPDATE review_type SET published_email_template = '{#VPX Language="Ruby"#}  <html>  <body vlink="#2782D1" alink="#2782D1" style="font-family:Arial' +
	', Helvetica, sans-serif; font-size:14px; color: #333333; background-color:#ffffff;">  <div align="center">  <table width="600" border="0" ' +
	'cellspacing="0" cellpadding="0">  <tr>  <td style="border:1px solid #cccccc;">  <table width="600" border="0" cellspacing="0" cellpadding="0">  ' +
	'<tr>  <td width="20">&nbsp;</td>  <td align= "left" width= "560" height= "150" style= "color:#503f34; border-bottom: 1px solid #cccccc;">  ' +
	'<img src="{=context.EmailLogoUrl=}" width= "252" height= "98" alt="{=context.SiteDetail.Site.Name=}" border= "0" />  </td>  <td width= "20">&nbsp;</td>' +
	'  </tr>  <tr>  <td>&nbsp;</td>  <td align="left" style= "font-family:Arial, Helvetica, sans-serif; font-size: 14px; line-height:18px; color:#333333;' +
	' padding-top: 25px;">  <div style= "margin-bottom: 32px; font-family:Arial, Helvetica, sans-serif; font-size:20px; color:#333333;">  <strong>Your' +
	' review has been published!</strong>  </div>  <div>  <p>  Hi {=context.ArticleDetail.AuthorName(0)=},  </p>  <br/>  <p>  Your review has been published on' +
	' {=context.SiteDetail.Site.Name=}.  </p>  <br/>  <p>  We have included some details about you review below:  <br/>  Product Review Title:' +
	' {=context.ArticleDetail.Article.Title=}  <br/>  Product: {~if context.ArticleDetail.GetRelatedProducts().Count() > 0~}\s{=context.ArticleDetail' +
	'.GetRelatedProducts()[0].Product.Name=}\s{~end~}\s  <br/>  {~if context.GiftCardId == nil or context.GiftCardId.empty? ~}{~else~}Gift Card Number: {=context.GiftCardId=}  <br/>{~end~}  ' +
	'Preview Link: {=context.ArticlePreviewUrl=}  </p>  </div>  <br/>  <br/>  <br/>  <br/>  <br/>  <div>  Regards,  <br/>  <br/>  <strong>' +
	'{=context.SiteSignature=}</strong>  </div>  </td>  <td>&nbsp;</td>  </tr>  <tr>  <td width= "20" height= "100">&nbsp;</td>  <td width= "560" height= ' +
	'"100">&nbsp;</td>  <td width= "20" height= "100">&nbsp;</td>  </tr>  </table>  </td>  </tr>  </table>  <table width= "590" border= "0" cellspacing=' +
	' "0" cellpadding= "0">  <tr>  <td width= "300" height= "30" align= "left" style= "font-family: Arial, Helvetica, sans-serif; color:#666666; ' +
	'text-align:left; font-size:11px;">  {=context.SiteCopyrightMessage=}  </td>  <td width="290" height="30" align="right" style="font-family: Arial, ' +
	'Helvetica, sans-serif; color:#666666; text-align:right; font-size:11px;">  <a href="{=context.SiteDetail.NavigationUrl=}" target="_blank" style="text-decoration: ' +
	'underline; color:#2782D1" title="{=context.SiteDetail.Site.Name=}.com">{=context.SiteDetail.Site.Name=}.com</a>  </td>  </tr>  </table>  </div>  </body>  </html>' 
END
GO

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
			AND (@startDate IS NULL OR created BETWEEN @startDate AND (@endDate+1))
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