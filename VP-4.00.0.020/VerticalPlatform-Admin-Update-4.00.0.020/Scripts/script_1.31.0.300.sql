EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSize'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSize
	@siteId int,
	@batchSize int,
	@isTemplate bit
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
SET NOCOUNT ON;

SELECT TOP (@batchSize) article_id AS id, article.article_type_id, article.site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
		article.[enabled],article. modified, article.created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified
	FROM (article
			INNER JOIN article_type
				ON article.article_type_id = article_type.article_type_id)
			LEFT OUTER JOIN content_text
				ON article_id = content_text.content_id AND content_text.content_type_id = 4			
	WHERE article.site_id = @siteId
		AND article.enabled = 1
		AND	(content_text.modified IS NULL OR article.modified > content_text.modified)
		AND (is_article_template = @isTemplate)
		AND (content_based = 0)

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetModifiedArticlesBySiteIdBatchSize TO VpWebApp 
GO


----------------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteContentTextForNonExistingArticleList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteContentTextForNonExistingArticleList
	@siteId int
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH temp_articles (article_id) AS 
	(
		SELECT article_id
		FROM article
		WHERE site_id = @siteId AND ([enabled] = 0 OR is_article_template = 1 OR is_external = 1)
	)
	
	DELETE FROM content_text
	WHERE content_type_id = 4 AND content_id IN
		(SELECT article_id FROM temp_articles)

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteContentTextForNonExistingArticleList TO VpWebApp 
GO


------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorByCategoryIdList
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT ven.vendor_id AS id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled], 
			ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name
	FROM product_to_category catPro
		INNER JOIN product p
			ON catPro.product_id = p.product_id
		INNER JOIN product_to_vendor proVen
			ON catPro.product_id = proVen.product_id
		INNER JOIN vendor ven
			ON proVen.vendor_id = ven.vendor_id
	WHERE catPro.category_id = @id AND p.enabled=1 AND catPro.enabled=1 AND ven.enabled=1
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetVendorByCategoryIdList TO VpWebApp 
GO
---------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorByCategoryIdList
	@id int
AS
-- ==========================================================================
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT ven.vendor_id AS id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled], 
			ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name
	FROM product_to_category catPro
		INNER JOIN product_to_vendor proVen
			ON catPro.product_id = proVen.product_id
		INNER JOIN vendor ven
			ON proVen.vendor_id = ven.vendor_id
	WHERE catPro.category_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorByCategoryIdList TO VpWebApp 
Go
--------------------------------------------------------------------




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fixed_guided_browse]') AND type in (N'U'))
BEGIN
	CREATE TABLE [fixed_guided_browse](
		[fixed_guided_browse_id] [int] IDENTITY(1,1) NOT NULL,
		[category_id] [int] NOT NULL,
		[search_group_id] [int] NOT NULL,
		[search_group_list_type] [int] NOT NULL,
		[name] [varchar](100) NOT NULL,
		[segment_size] [int] NULL,		
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	CONSTRAINT [PK_fixed_guided_browse] PRIMARY KEY CLUSTERED 
	(
		[fixed_guided_browse_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_fixed_guided_browse_category') AND parent_object_id = OBJECT_ID(N'fixed_guided_browse'))
BEGIN
	ALTER TABLE [fixed_guided_browse]  WITH CHECK ADD  CONSTRAINT [FK_fixed_guided_browse_category] FOREIGN KEY([category_id])
	REFERENCES [category] ([category_id])
	ALTER TABLE [fixed_guided_browse] CHECK CONSTRAINT [FK_fixed_guided_browse_category]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_fixed_guided_browse_search_group') AND parent_object_id = OBJECT_ID(N'fixed_guided_browse'))
BEGIN
	ALTER TABLE [fixed_guided_browse]  WITH CHECK ADD  CONSTRAINT [FK_fixed_guided_browse_search_group] FOREIGN KEY([search_group_id])
	REFERENCES [search_group] ([search_group_id])
	ALTER TABLE [fixed_guided_browse] CHECK CONSTRAINT [FK_fixed_guided_browse_search_group]
END
GO
----------------------------------------------------------------------------------
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fixed_guided_browse_to_search_option]') AND type in (N'U'))
BEGIN
	CREATE TABLE [fixed_guided_browse_to_search_option](
		[fixed_guided_browse_to_search_option_id] [int] IDENTITY(1,1) NOT NULL,
		[fixed_guided_browse_id] [int] NOT NULL,
		[search_group_id] [int] NOT NULL,
		[search_option_id] [int] NOT NULL,
		[sort_order] [int] NOT NULL,		
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	CONSTRAINT [PK_fixed_guided_browse_to_search_option] PRIMARY KEY CLUSTERED 
	(
		[fixed_guided_browse_to_search_option_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_fixed_guided_browse_to_search_option_fixed_guided_browse') AND parent_object_id = OBJECT_ID(N'fixed_guided_browse_to_search_option'))
BEGIN
	ALTER TABLE [fixed_guided_browse_to_search_option]  WITH CHECK ADD  CONSTRAINT [FK_fixed_guided_browse_to_search_option_fixed_guided_browse] FOREIGN KEY([fixed_guided_browse_id])
	REFERENCES [fixed_guided_browse] ([fixed_guided_browse_id])
	ALTER TABLE [fixed_guided_browse_to_search_option] CHECK CONSTRAINT [FK_fixed_guided_browse_to_search_option_fixed_guided_browse]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_fixed_guided_browse_to_search_option_search_group') AND parent_object_id = OBJECT_ID(N'fixed_guided_browse_to_search_option'))
BEGIN
	ALTER TABLE [fixed_guided_browse_to_search_option]  WITH CHECK ADD  CONSTRAINT [FK_fixed_guided_browse_to_search_option_search_group] FOREIGN KEY([search_group_id])
	REFERENCES [search_group] ([search_group_id])
	ALTER TABLE [fixed_guided_browse_to_search_option] CHECK CONSTRAINT [FK_fixed_guided_browse_to_search_option_search_group]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_fixed_guided_browse_to_search_option_search_option') AND parent_object_id = OBJECT_ID(N'fixed_guided_browse_to_search_option'))
BEGIN
	ALTER TABLE [fixed_guided_browse_to_search_option]  WITH CHECK ADD  CONSTRAINT [FK_fixed_guided_browse_to_search_option_search_option] FOREIGN KEY([search_option_id])
	REFERENCES [search_option] ([search_option_id])
	ALTER TABLE [fixed_guided_browse_to_search_option] CHECK CONSTRAINT [FK_fixed_guided_browse_to_search_option_search_option]
END
GO

----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowse
	@id int output,
	@categoryId int,
	@searchGroupId int,
	@name varchar(200),
	@searchGroupListType int,
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, search_group_id, [name], search_group_list_type, [enabled], created, modified)
	VALUES (@categoryId,@searchGroupId, @name, @searchGroupListType, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowse TO VpWebApp 
GO
---------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowse
	@id int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_id, search_group_list_type, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO
----------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowse
	@id int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowse TO VpWebApp 
GO
-------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowse
	@id int,
	@categoryId int,
	@searchGroupId int,
	@name varchar(200),
	@searchGroupListType int,
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE fixed_guided_browse
	SET
		category_id = @categoryId,
		[name] = @name,
		search_group_id = @searchGroupId,
		search_group_list_type = @searchGroupListType,
		enabled = @enabled,
		modified = @modified
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowse TO VpWebApp 
GO
------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList
	@categoryId int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_id, search_group_list_type, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList TO VpWebApp 
GO
---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowsesByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowsesByCategoryId
	@categoryId int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowsesByCategoryId TO VpWebApp 
GO
--------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowsesBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowsesBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM fixed_guided_browse
	WHERE category_id IN
	(
		SELECT category_id
		FROM category
		WHERE site_id = @siteId
	)

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowsesBySiteIdList TO VpWebApp 
GO
--------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowseSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowseSearchOption
	@id int output,
	@fixedGuidedBrowseId int,
	@searchGroupId int,
	@searchOptionId int,
	@sortOrder int,	
	@enabled bit,
	@created smalldatetime output
	
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse_to_search_option(fixed_guided_browse_id, search_group_id, search_option_id, sort_order, [enabled], created, modified)
	VALUES (@fixedGuidedBrowseId , @searchGroupId, @searchOptionId, @sortOrder, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowseSearchOption TO VpWebApp 
GO
--------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowseSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowseSearchOption
	@id int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_to_search_option_id AS id, fixed_guided_browse_id, search_group_id, search_option_id, sort_order, [enabled], created, modified
	FROM fixed_guided_browse_to_search_option
	WHERE fixed_guided_browse_to_search_option_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowseSearchOption TO VpWebApp 
GO
--------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowseSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowseSearchOption
	@id int,
	@fixedGuidedBrowseId int,
	@searchGroupId int,
	@searchOptionId int,
	@sortOrder int,
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE fixed_guided_browse_to_search_option
	SET
		fixed_guided_browse_id = @fixedGuidedBrowseId,
		search_group_id = @searchGroupId,
		search_option_id = @searchOptionId,
		sort_order = @sortOrder,
		enabled = @enabled,
		modified = @modified
	WHERE fixed_guided_browse_to_search_option_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowseSearchOption TO VpWebApp 
GO
--------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowseSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowseSearchOption
	@id int
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM fixed_guided_browse_to_search_option
	WHERE fixed_guided_browse_to_search_option_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowseSearchOption TO VpWebApp 
GO
------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowseSearchOptionsByFixedGuidedBrowseIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowseSearchOptionsByFixedGuidedBrowseIdList
	@fixedGuidedBrowseId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_to_search_option_id AS id, fixed_guided_browse_id, search_group_id, search_option_id, sort_order, [enabled], created, modified
	FROM fixed_guided_browse_to_search_option
	WHERE fixed_guided_browse_id = @fixedGuidedBrowseId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowseSearchOptionsByFixedGuidedBrowseIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowseSearchOptionByFixedGuidedBrowseId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowseSearchOptionByFixedGuidedBrowseId
	@fixedGuidedBrowseId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM fixed_guided_browse_to_search_option
	WHERE fixed_guided_browse_id = @fixedGuidedBrowseId

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowseSearchOptionByFixedGuidedBrowseId TO VpWebApp 
GO
-----------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowseSearchOptionsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowseSearchOptionsBySiteId
	@siteId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	
	DELETE FROM fixed_guided_browse_to_search_option
	WHERE fixed_guided_browse_id IN
	(
		SELECT fixed_guided_browse_id
		FROM fixed_guided_browse
			INNER JOIN category
				ON category.category_id = fixed_guided_browse.category_id
		WHERE category.site_id = @siteId
	)


END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowseSearchOptionsBySiteId TO VpWebApp 
GO
-----------------------------------------------------------------------------
IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 143)
BEGIN
	INSERT INTO parameter_type VALUES (143, 'FixedGuidedBrowseId', '1', GETDATE(), GETDATE())
END
GO
-----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSegmentBoundarySearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSegmentBoundarySearchOptions
	@searchGroupId int,
	@segmentSize int
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	CREATE TABLE #search_options(ranking int, option_id int, option_name varchar(500))
	CREATE TABLE #boundary_options(ranking int, option_id int, option_name varchar(500))

	INSERT INTO #search_options
	SELECT ROW_NUMBER() OVER(ORDER BY [name] ASC), search_option_id, [name] 
	FROM search_option
	WHERE search_group_id = @searchGroupId AND [enabled] = 1 AND [name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 


	INSERT INTO #boundary_options
	SELECT  ranking, option_id, option_name
	FROM #search_options 
	WHERE (ranking % @segmentSize = 1) OR (ranking % @segmentSize = 0)

	INSERT INTO #boundary_options
	SELECT  TOP(1) ranking, option_id, option_name
	FROM #search_options 
	ORDER BY ranking DESC

	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(	
		SELECT option_id
		FROM #boundary_options
	)
	ORDER BY [name]

	DROP TABLE #boundary_options
	DROP TABLE #search_options

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSegmentBoundarySearchOptions TO VpWebApp 
GO
--------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetAlphabeticalSearchOptionsIndex'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetAlphabeticalSearchOptionsIndex
	@searchGroupId int	
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	CREATE TABLE #search_options(ranking int, alpha varchar(1), option_name varchar(500))

	INSERT INTO #search_options
	SELECT ROW_NUMBER() OVER (PARTITION BY opt.alpha ORDER BY opt.name ASC) AS ranking, opt.alpha, opt.name 
	FROM
	(
		SELECT  UPPER(SUBSTRING([name],1,1)) AS alpha, [name] 
		FROM search_option
		WHERE search_group_id = @searchGroupId AND [enabled] = 1 AND [name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 
	) opt

	SELECT  so.alpha +' ('+ mi.option_name + ' - ' +  so.option_name + ')' AS option_index
	FROM #search_options so
		INNER JOIN 
			(
				SELECT MAX(ranking) AS max_rank, alpha
				FROM #search_options
				GROUP BY alpha
			) ma
			ON so.alpha = ma.alpha AND  so.ranking = ma.max_rank
		INNER JOIN
		(
			SELECT alpha,option_name 
			FROM #search_options
			WHERE ranking = 1
		) mi
			ON mi.alpha = ma.alpha 
		
		
	DROP TABLE #search_options

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetAlphabeticalSearchOptionsIndex TO VpWebApp 
GO
------------------------------------------------------------------------
IF NOT EXISTS(SELECT module_name FROM dbo.module WHERE module_name = 'FixedGuidedBrowseIndex')
BEGIN
	INSERT INTO dbo.module (module_name, usercontrol_name,enabled,is_container)
	VALUES ('FixedGuidedBrowseIndex','~/Modules/GuidedBrowse/FixedGuidedBrowseIndex.ascx',1,0)
END
GO
-------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT module_name FROM dbo.module WHERE module_name = 'FixedGuidedBrowse')
BEGIN
	INSERT INTO dbo.module (module_name, usercontrol_name,enabled,is_container)
	VALUES ('FixedGuidedBrowse','~/Modules/GuidedBrowse/FixedGuidedBrowse.ascx',1,0)
END
GO
---------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id as id, category_id, search_group_id, search_group_list_type, name, enabled, created, modified
	FROM fixed_guided_browse
	WHERE category_id IN
	(
		SELECT category_id
		FROM category
		WHERE site_id = @siteId
	)

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList TO VpWebApp 
GO
-----------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSegmentSearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSegmentSearchOptions
	@searchGroupId int,
	@segmentSize int,
	@pageIndex int
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	DECLARE @startIndex int, @endIndex int
	
	SET @startIndex = (@segmentSize * @pageIndex) + 1
	SET @endIndex = @segmentSize * (@pageIndex + 1)
	
	CREATE TABLE #search_options(ranking int, option_id int, option_name varchar(500))
	
	INSERT INTO #search_options
	SELECT ROW_NUMBER() OVER(ORDER BY [name] ASC), search_option_id, [name] 
	FROM search_option
	WHERE search_group_id = @searchGroupId AND [enabled] = 1 AND [name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 

	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(	
		SELECT option_id
		FROM #search_options
		WHERE ranking BETWEEN @startIndex AND @endIndex
	)
	ORDER BY [name]

	DROP TABLE #search_options

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSegmentSearchOptions TO VpWebApp 
GO
-------------------------------------------------------------------