IF NOT EXISTS
(
	SELECT * FROM sys.columns 
	WHERE [name] = N'include_in_sitemap' AND Object_ID = Object_ID(N'fixed_url')
)
BEGIN
	ALTER TABLE fixed_url ADD include_in_sitemap bit NOT NULL DEFAULT 1
END

GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddFixedUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddFixedUrl
	@id int output,
	@fixedUrl varchar(255),
	@siteId int,
	@pageId int,
	@contentTypeId int,
	@contentId int,
	@includeInSitemap bit,
	@queryString varchar(255),
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author: Dimuthu
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO fixed_url (fixed_url, site_id, page_id, content_type_id
		, content_id, query_string, [enabled],include_in_sitemap, created, modified)
	VALUES (@fixedUrl, @siteId, @pageId, @contentTypeId, @contentId
		, @queryString, @enabled,@includeInSitemap, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddFixedUrl TO VpWebApp 
GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateFixedUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateFixedUrl
	@id int,
	@fixedUrl varchar(255),
	@siteId int,
	@pageId int,
	@contentTypeId int,
	@contentId int,
	@queryString varchar(255),
	@enabled bit,
	@includeInSitemap bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE fixed_url 
	SET fixed_url = @fixedUrl
		, site_id = @siteId
		, page_id = @pageId
		, content_type_id = @contentTypeId
		, content_id = @contentId
		, query_string = @queryString
		, [enabled] = @enabled
		, include_in_sitemap = @includeInSitemap
		, modified = @modified
	WHERE fixed_url_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateFixedUrl TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlDetail
	@id int
AS
-- ==========================================================================
-- Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_id AS id, fixed_url, site_id, page_id, content_type_id
		, content_id, query_string, [enabled], include_in_sitemap, created, modified
	FROM fixed_url
	WHERE fixed_url_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetFixedUrlDetail TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlByUrlDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlByUrlDetail
	@fixedUrl varchar(255)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_id AS id, fixed_url, site_id, page_id, content_type_id
		, content_id, query_string, [enabled], include_in_sitemap, created, modified
	FROM fixed_url
	WHERE fixed_url = @fixedUrl

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetFixedUrlByUrlDetail TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetCategoryFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetCategoryFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled, include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled,fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN category c ON fu.content_id = c.category_id AND c.enabled = 1 
				AND c.site_id = @siteId AND fu.content_type_id = 1 
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND c.hidden = 0 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled,include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetCategoryFixedUrlBySiteIdPagingList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetPageFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetPageFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled,include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, fu.page_id, fu.content_type_id, content_id
			, query_string, fu.enabled,fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN page p ON fu.content_id = p.page_id AND p.enabled = 1 
				AND p.site_id = @siteId AND fu.content_type_id = 7 AND p.include_in_sitemap = 1
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled,include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetPageFixedUrlBySiteIdPagingList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetArticleFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetArticleFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled,include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled,fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN article a ON fu.content_id = a.article_id AND a.enabled = 1 
				AND a.site_id = @siteId AND fu.content_type_id = 4 AND a.is_external = 0
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled,include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetArticleFixedUrlBySiteIdPagingList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetAuthorFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetAuthorFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled,include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled,fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN author a ON fu.content_id = a.author_id AND a.enabled = 1 
				AND a.site_id = @siteId AND fu.content_type_id = 19
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled,include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetAuthorFixedUrlBySiteIdPagingList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetExhibitionVendorFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetExhibitionVendorFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled,include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled,fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN exhibition_vendor ev ON fu.content_id = ev.exhibition_vendor_id AND ev.enabled = 1 
				AND fu.content_type_id = 14
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetExhibitionVendorFixedUrlBySiteIdPagingList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetExhibitionFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetExhibitionFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled,include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled, fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN exhibition e ON fu.content_id = e.exhibition_id AND e.enabled = 1 
				AND e.site_id = @siteId AND fu.content_type_id = 12
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetExhibitionFixedUrlBySiteIdPagingList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlByContentTypeContentIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlByContentTypeContentIdsList
	@contentTypeId int,
	@contentIds varchar(max)
AS
-- ==========================================================================
-- $ Author : Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_id AS id, fixed_url, site_id, page_id, content_type_id
		, content_id, query_string, [enabled], include_in_sitemap, created, modified
	FROM fixed_url
	WHERE content_type_id = @contentTypeId AND content_id IN 
		(SELECT [value] FROM dbo.global_Split(@contentIds, ','))

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetFixedUrlByContentTypeContentIdsList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetExhibitionCategoryFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetExhibitionCategoryFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled, include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled, fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN exhibition_category ec ON fu.content_id = ec.exhibition_category_id AND ec.enabled = 1 
				AND fu.content_type_id = 13
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetExhibitionCategoryFixedUrlBySiteIdPagingList TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlByContentTypeContentIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlByContentTypeContentIdDetail
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_id AS id, fixed_url, site_id, page_id, content_type_id
		, content_id, query_string, [enabled], include_in_sitemap, created, modified
	FROM fixed_url
	WHERE content_type_id = @contentTypeId AND content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetFixedUrlByContentTypeContentIdDetail TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetProductFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetProductFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled, include_in_sitemap, created, modified, row) AS
	(
		SELECT fu.fixed_url_id AS id, fu.fixed_url, fu.site_id, fu.page_id, fu.content_type_id, fu.content_id
			, fu.query_string, fu.enabled, fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fu.fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN product p ON fu.content_id = p.product_id AND p.enabled = 1 AND p.hidden=0
				AND p.site_id = @siteId AND fu.content_type_id = 2
			
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1 
			AND	EXISTS( SELECT 1 FROM product_to_category ptc 
				INNER JOIN fixed_url fuc on fuc.content_id = ptc.category_id and fuc.content_type_id =1 and fuc.site_id = @siteId and fuc.include_in_sitemap = 1
				WHERE ptc.product_id = p.product_id	)
	)


	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetProductFixedUrlBySiteIdPagingList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetVendorFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetVendorFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled, include_in_sitemap, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled,fu.include_in_sitemap, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN vendor v ON fu.content_id = v.vendor_id AND v.enabled = 1 
				AND v.site_id = @siteId AND fu.content_type_id = 6
		WHERE fu.site_id = @siteId AND fu.enabled = 1 AND fu.include_in_sitemap = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, include_in_sitemap, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetVendorFixedUrlBySiteIdPagingList TO VpWebApp 
GO
-----------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_guided_browse_to_search_group_search_group') AND parent_object_id = OBJECT_ID(N'guided_browse_to_search_group'))
BEGIN
	ALTER TABLE guided_browse_to_search_group
	DROP CONSTRAINT FK_guided_browse_to_search_group_search_group
END
GO
--------------------------------------------------------------------------------