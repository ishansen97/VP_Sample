EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticle
	@id int output,
	@articleTypeId int,
	@siteId int,
	@articleTitle varchar(255),
	@articleSummary varchar(max),	
	@created smalldatetime output, 
	@enabled bit,
	@articleShortTitle varchar(255),
	@isArticleTemplate bit,
	@isExternal bit,
	@openNewWindow bit,
	@featuredIdentifier varchar(3),
	@thumbnailImageCode varchar(255),
	@externalUrlId int,
	@articleTemplateId int,
	@datePublished smalldatetime,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@published bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint, 
	@searchContentModified bit
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminArticle_AddArticle.sql $
-- $Revision: 7145 $
-- $Date: 2010-10-27 11:04:27 +0530 (Wed, 27 Oct 2010) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO article (article_type_id, site_id, article_title, article_summary, modified, created, [enabled],
	article_short_title,is_article_template,is_external,featured_identifier,thumbnail_image_code,external_url_id,date_published,article_template_id, open_new_window, start_date, end_date, published, 
	flag1, flag2, flag3, flag4, search_content_modified)
	VALUES (@articleTypeId, @siteId, @articleTitle, @articleSummary, @created, @created, @enabled,
	@articleShortTitle,@isArticleTemplate,@isExternal,@featuredIdentifier,@thumbnailImageCode,@externalUrlId,@datePublished,@articleTemplateId, @openNewWindow, @startDate, @endDate, @published,
	@flag1, @flag2, @flag3, @flag4, @searchContentModified)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticle TO VpWebApp 
GO
--------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticle
	@id int,
	@articleTypeId int,
	@siteId int,
	@articleTitle varchar(255),
	@articleSummary varchar(max),	
	@enabled bit,
	@articleShortTitle varchar(255),
	@isArticleTemplate bit,
	@isExternal bit,
	@openNewWindow bit,
	@featuredIdentifier varchar(3),
	@thumbnailImageCode varchar(255),
	@externalUrlId int,
	@datePublished smalldatetime,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@published bit,
	@articleTemplateId int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchContentModified bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminArticle_UpdateArticle.sql $
-- $Revision: 7145 $
-- $Date: 2010-10-27 11:04:27 +0530 (Wed, 27 Oct 2010) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE article
	SET
		article_type_id = @articleTypeId,
		site_id = @siteId,
		article_title = @articleTitle,
		article_summary = @articleSummary,		
		[enabled] = @enabled,
		modified = @modified,
		article_short_title =@articleShortTitle,
		is_article_template = @isArticleTemplate,
		is_external = @isExternal,
		featured_identifier = @featuredIdentifier,
		thumbnail_image_code = @thumbnailImageCode,
		external_url_id = @externalUrlId,
		date_published = @datePublished,
		start_date = @startDate,
		end_date = @endDate,
		published = @published,
		article_template_id = @articleTemplateId,
		open_new_window = @openNewWindow,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		search_content_modified = @searchContentModified
	WHERE article_id = @id
 

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticle TO VpWebApp 
GO
------------------------------------------------------------------------