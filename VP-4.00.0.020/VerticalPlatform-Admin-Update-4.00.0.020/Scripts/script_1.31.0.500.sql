---------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddPage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddPage
	@siteId int,
	@predefinedPageId int,
	@parentPageId int = null,
	@pageName varchar(50), 
	@pageTitle varchar(100),
	@pageTitlePrefix varchar(100),
	@pageTitleSuffix varchar(100),
	@descriptionPrefix varchar(100),
	@descriptionSuffix varchar(100),
	@keywords varchar(500), 
	@templateName varchar(100),
	@enabled bit,
	@logInToView bit,
	@id int output,
	@created smalldatetime output,
	@hidden bit,
	@navigable bit,
	@navigationTitle varchar(max),
	@sortOrder smallint,
	@defaultTitlePrefix varchar(100)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO page(site_id, predefined_page_id, parent_page_id, page_name, page_title
			, page_title_prefix, page_title_suffix, description_prefix, description_suffix, keywords 
			, template_name, sort_order, navigable, [hidden], log_in_to_view, [enabled], modified, created, navigation_title, default_title_prefix) 
	VALUES (@siteId, @predefinedPageId, @parentPageId, @pageName, @pageTitle
			, @pageTitlePrefix, @pageTitleSuffix, @descriptionPrefix, @descriptionSuffix, @keywords
			, @templateName, @sortOrder, @navigable, @hidden, @logInToView, @enabled, @created, @created,@navigationTitle, @defaultTitlePrefix) 

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddPage TO VpWebApp
GO


-------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetPageDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetPageDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT page_id AS id, predefined_page_id, site_id, parent_page_id, page_name
			, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
			, keywords, template_name, sort_order, navigable, hidden, log_in_to_view
			, [enabled], modified, created, navigation_title, default_title_prefix
	FROM page 
	WHERE page_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetPageDetail TO VpWebApp 
GO
-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdatePage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdatePage
	@id int,
	@predefinedPageId int,
	@siteId int,
	@parentPageId int,
	@pageName varchar(50),
	@pageTitle varchar(100),
	@pageTitlePrefix varchar(100),
	@pageTitleSuffix varchar(100),
	@descriptionPrefix varchar(100),
	@descriptionSuffix varchar(100),
	@keywords varchar(500), 
	@templateName varchar(100),
	@enabled bit,
	@modified smalldatetime output,
	@hidden bit,
	@logInToView bit,
	@navigable bit,
	@navigationTitle varchar(max),
	@sortOrder int,
	@defaultTitlePrefix varchar(100)
AS
-- ==========================================================================
-- $Author: Dimuhu $
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE page 
	SET
		site_id = @siteId,
		predefined_page_id = @predefinedPageId,
		parent_page_id = @parentPageId,
		page_name = @pageName ,
		page_title = @pageTitle,
		page_title_prefix = @pageTitlePrefix,
		page_title_suffix = @pageTitleSuffix,
		description_prefix = @descriptionPrefix,
		description_suffix = @descriptionSuffix,
		keywords = @keywords, 
		template_name = @templateName,
		[enabled] = @enabled,
		modified = @modified,
		[hidden] = @hidden,
		sort_order = @sortOrder,
		navigable = @navigable,
		log_in_to_view = @logInToView,
		navigation_title = @navigationTitle,
		default_title_prefix = @defaultTitlePrefix
	WHERE page_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdatePage TO VpWebApp 
GO
-------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetPagebySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetPagebySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT  page_id AS id, site_id, predefined_page_id, parent_page_id, page_name
		, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
		, keywords, template_name, sort_order, navigable, hidden,log_in_to_view
		, [enabled], modified, created, navigation_title, default_title_prefix
	FROM page
	WHERE site_id = @siteId
	ORDER BY parent_page_id, sort_order
END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetPagebySiteIdList TO VpWebApp 
GO

-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetPageBySiteIdParentPageIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetPageBySiteIdParentPageIdList
	@siteId int,
	@parentPageId int = NULL
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT page_id AS id, predefined_page_id, site_id, parent_page_id, page_name
		, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
		, keywords, template_name
		, sort_order, navigable, hidden,log_in_to_view,[enabled]
		, modified, created, navigation_title, default_title_prefix
	FROM page
	WHERE site_id = @siteId AND  ((@parentPageId IS NULL AND parent_page_id IS NULL) OR parent_page_id = @parentPageId)
	ORDER BY sort_order
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetPageBySiteIdParentPageIdList TO VpWebApp 
GO

-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetParentPageForSiteList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetParentPageForSiteList
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT page_id AS id, site_id, predefined_page_id, parent_page_id, page_name
		, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
		, keywords, template_name
		, sort_order, navigable, hidden, log_in_to_view, [enabled], modified, created, navigation_title, default_title_prefix
	FROM page
	WHERE site_id = @siteId
	ORDER BY predefined_page_id		

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetParentPageForSiteList TO VpWebApp 
GO
-------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetPageBySiteIdPageName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetPageBySiteIdPageName
	@siteId int,
	@pageName varchar(50)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT  page_id AS id, predefined_page_id, site_id, parent_page_id, page_name
			, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
			, keywords, template_name, sort_order, navigable, hidden, log_in_to_view
			, [enabled], modified, created, navigation_title, default_title_prefix
	FROM page
	WHERE site_id = @siteId AND page_name = @pageName

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetPageBySiteIdPageName TO VpWebApp 
Go


-------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetPageWithChildrenList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetPageWithChildrenList
	@pageId int
AS
-- ==========================================================================
-- $Author: Dimuthu$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_page (page_id, parent_page_id, depth)
	AS
	(
		SELECT page_id, parent_page_id, depth = 1
		FROM page
		WHERE page_id = @pageId
		
		UNION ALL

		SELECT page.page_id, page.parent_page_id, depth = depth + 1
		FROM page
			INNER JOIN temp_page
				ON temp_page.page_id = page.parent_page_id
	)

	SELECT page.page_id AS id, site_id, predefined_page_id, page.parent_page_id, page_name, page_title
		, keywords, template_name, sort_order, navigable, hidden, log_in_to_view, enabled, modified
		, created, page_title_prefix, page_title_suffix, description_prefix, description_suffix
		, navigation_title, default_title_prefix
	FROM page 
		INNER JOIN temp_page 
			ON page.page_id = temp_page.page_id 
	ORDER BY depth DESC

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetPageWithChildrenList TO VpWebApp 
GO
-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetPagesHavingModule'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetPagesHavingModule
	@siteId int,
	@moduleName varchar(255)
AS
-- ==========================================================================
-- $Author: Dimtuhu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT p.page_id AS id, p.predefined_page_id, p.site_id, p.parent_page_id, p.page_name
			, p.page_title, p.page_title_prefix, p.page_title_suffix, p.description_prefix, p.description_suffix
			, p.keywords, p.template_name, p.sort_order, p.navigable, p.hidden, p.log_in_to_view
			, p.[enabled], p.modified, p.created , p.navigation_title, p.default_title_prefix
	FROM page p
		INNER JOIN module_instance mi 
			ON mi.page_id = p.page_id
				INNER JOIN module m
					ON m.module_id = mi.module_id
	WHERE p.site_id = @siteId AND m.module_name = @moduleName

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetPagesHavingModule TO VpWebApp 
GO

-------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetPageBySiteIdPageIndexPageSizeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetPageBySiteIdPageIndexPageSizeList
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
		SELECT TOP (@pageSize) pa.page_id AS id, pa.predefined_page_id, pa.site_id, pa.parent_page_id, pa.page_name
		, pa.page_title, pa.page_title_prefix, pa.page_title_suffix, pa.description_prefix, pa.description_suffix
		, pa.keywords, pa.template_name
		, pa.sort_order, pa.navigable, pa.hidden,log_in_to_view,pa.[enabled]
		, pa.modified, pa.created, pa.navigation_title, pa.default_title_prefix
		FROM page AS pa
		WHERE @siteId = pa.site_id  AND (pa.page_id NOT IN ( SELECT TOP ((@pageIndex - 1) * @pageSize) pa.page_id 
										FROM page AS pa WHERE @siteId = pa.site_id ORDER BY pa.page_title ASC))
		ORDER BY pa.page_title ASC

		SELECT @totalCount = COUNT(*)
		FROM page AS pa
		WHERE @siteId = pa.site_id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetPageBySiteIdPageIndexPageSizeList TO VpWebApp 
GO
-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetPageBySiteIdLikePageTitleList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetPageBySiteIdLikePageTitleList
	@siteId int,
	@text varchar(max),
	@isEnabled bit,
	@selectLimit int
	
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT TOP (@selectLimit) pa.page_id AS id, pa.predefined_page_id, pa.site_id, pa.parent_page_id, pa.page_name
		, pa.page_title, pa.page_title_prefix, pa.page_title_suffix, pa.description_prefix, pa.description_suffix
		, pa.keywords, pa.template_name
		, pa.sort_order, pa.navigable, pa.hidden, pa.log_in_to_view, pa.[enabled]
		, pa.modified, pa.created, pa.navigation_title, pa.default_title_prefix
	FROM page AS pa
	WHERE pa.site_id = @siteId AND pa.page_title like @text+'%' AND (@isEnabled IS NULL OR pa.enabled = @isEnabled)

END
GO

GRANT EXECUTE ON adminPlatform_GetPageBySiteIdLikePageTitleList TO VpWebApp
GO
-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetPageByModuleInstanceId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetPageByModuleInstanceId
	@moduleInstanceId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT page.page_id AS id, page.site_id, predefined_page_id, parent_page_id, page_name, 
		page_title, keywords, template_name, page.sort_order, navigable, hidden, log_in_to_view, 
		page.[enabled], page.modified, page.created, page_title_prefix, page_title_suffix, 
		description_prefix, description_suffix, navigation_title, default_title_prefix
	FROM page
		INNER JOIN module_instance
			ON page.page_id = module_instance.page_id
	WHERE module_instance.module_instance_id = @moduleInstanceId
 
END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetPageByModuleInstanceId TO VpWebApp 
GO
-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_GetPageListbySiteIdPageCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_GetPageListbySiteIdPageCategoryId
	@siteId int,
	@pageCategoryId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT  page.page_id AS id, page.site_id, predefined_page_id, parent_page_id, page_name
		, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
		, keywords, template_name, sort_order, navigable, hidden,log_in_to_view
		, page.enabled, page.modified, page.created, navigation_title, default_title_prefix
	FROM page
	WHERE page_id IN
	(
		SELECT page_id
		FROM page_type
		WHERE page_type.page_category_id = @pageCategoryId AND page_type.site_id = @siteId
	)
	ORDER BY parent_page_id, sort_order
END
GO

GRANT EXECUTE ON dbo.adminPage_GetPageListbySiteIdPageCategoryId TO VpWebApp 
GO
---------------------------------------------------------------------------------------------

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
				AND p.site_id = @siteId AND fu.content_type_id = 7
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
---------------------------------------------------------------------------------------------
DECLARE @SQLString NVARCHAR(MAX)

DECLARE @table_name NVARCHAR(256)
DECLARE @col_name NVARCHAR(256)
DECLARE @constraintname NVARCHAR(256)
SET @table_name = N'Page'
SET @col_name = N'include_in_sitemap'


SELECT TOP 1 @constraintname = d.name
FROM sys.tables t
    JOIN
    sys.default_constraints d
        ON d.parent_object_id = t.object_id
    JOIN
    sys.columns c
        ON c.object_id = t.object_id
        AND c.column_id = d.parent_column_id
WHERE t.name = @table_name
AND c.name = @col_name



SET @SQLString = 'ALTER TABLE ' + @table_name + ' DROP '
SET @SQLString = @SQLString + 'CONSTRAINT ' + @constraintname 


EXECUTE sp_executesql @SQLString
GO
-----------------------------------------------------------------------


IF EXISTS(select * from sys.columns where Name = N'include_in_sitemap'  
                and Object_ID = Object_ID(N'page'))
BEGIN

	/* Migration script to move include in site map property from page table to fixed url */
	DECLARE @SQLString NVARCHAR(MAX)

	SET @SQLString = 'UPDATE fixed_url 
	SET include_in_sitemap = p.include_in_sitemap 
	FROM fixed_url fu 
	INNER JOIN page p ON fu.content_id = p.page_id and fu.content_type_id = 7'

	EXECUTE sp_executesql @SQLString
	
	/* Remove redundant column */
	ALTER TABLE page DROP COLUMN include_in_sitemap
	
END
GO