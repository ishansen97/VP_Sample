EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetContentToContentByContentTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetContentToContentByContentTypeList
	@siteId int,
	@contentTypeId int,
	@associatedContentTypeId int,
	@contentId int,
	@associatedContentId int,
	@pageStart int,
	@pageEnd  int,
	@pageCount int out
AS
-- ==========================================================================
-- $URL: $
-- $Revision:  $
-- $Date:  $ 
-- $Author:  $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT (ROW_NUMBER() over (order by content_to_content_id))  AS row_num, content_to_content_id AS id
		, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id INTO #ContentToContent
	FROM content_to_content 
	WHERE site_id = @siteId AND (content_type_id = @contentTypeId) AND 
		(@associatedContentTypeId IS NULL OR associated_content_type_id = @associatedContentTypeId) AND
		(@contentId IS NULL OR content_id = @contentId) AND
		(@associatedContentId IS NULL OR associated_content_id = @associatedContentId)

	SELECT id, content_id, content_type_id, associated_content_id, associated_content_type_id, [enabled], modified
		, created, site_id, associated_site_id
	FROM #ContentToContent	
	WHERE row_num BETWEEN @pageStart AND @pageEnd	

	SELECT @pageCount = COUNT(id) FROM #ContentToContent	

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetContentToContentByContentTypeList TO VpWebApp 
GO

-----------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticles_SearchArticleContentList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticles_SearchArticleContentList
	@siteId int,
	@searchText varchar(200),
	@databaseResults int,
	@articleTypeIds varchar(200),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS

-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================

BEGIN	

	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, 
		flag3, flag4, search_content_modified
	FROM article
	WHERE  	(@articleTypeIds IS NULL OR article_type_id IN (SELECT [value] FROM Global_Split(@articleTypeIds, ','))) AND
			((flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR (flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0)) AND
			article_id IN
			(
				SELECT TOP(@databaseResults) content_id
				FROM FREETEXTTABLE(content_text, *, @searchText) RankedTable
					INNER JOIN content_text
						ON [KEY] = content_text.content_text_id AND content_text.site_id = @siteId
				WHERE content_text.enabled = 1 AND content_text.content_type_id = 4
				ORDER BY RankedTable.RANK DESC	
			)
	
END
GO

GRANT EXECUTE ON dbo.publicArticles_SearchArticleContentList TO VpWebApp 
GO

---------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductsArticleRelatedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductsArticleRelatedCategories
	@numberofProducts int,
	@articleId int,
	@siteId int,
	@addedProducts varchar(1000),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Sujith
-- ==========================================================================
BEGIN
	
	SELECT TOP (@numberofProducts) p.product_id as id, p.site_id, p.product_Name, p.[rank], p.has_image
		, p.catalog_number, p.[enabled], p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank
		, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
		, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
		, p.completeness, ROUND(RAND(CHECKSUM(NEWID())) * 10000, 0) as randomId
	FROM product p
	WHERE p.enabled = 1 AND p.product_id IN 
	(
		SELECT pc.product_id
		FROM product_to_category pc			
		WHERE pc.enabled = 1 AND pc.category_id IN 
		(

			SELECT associated_content_id
			FROM content_to_content
			WHERE content_id = @articleId AND content_type_id = 4 AND enabled = 1 
			AND associated_content_type_id = 1 AND site_id = @siteId 
		)
	) 
	AND
	(
		(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
		(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
	)
	AND p.product_id NOT IN  (Select [value] FROM global_Split(@addedProducts, ','))
	ORDER BY randomId 
	
END

GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductsArticleRelatedCategories TO VpWebApp 
GO
-------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetAllFixedGuidedBrowseBoundarySearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicSearchCategory_GetAllFixedGuidedBrowseBoundarySearchOptionsList]
	@categoryId int,
	@searchGroupId int,
	@numberOfResults int,
	@mainIndexSelection varchar(10),
	@selectedSearchOptionIds varchar(50),
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optCount int
	SELECT * INTO #options_table FROM dbo.global_Split(@selectedSearchOptionIds, ',') 
	SET @optCount = (SELECT COUNT([value]) FROM #options_table)
	
	-- Create temp table to store the search option ids ordered by their name.
	CREATE TABLE #ordered_search_option(ordered_search_option_id int identity(1,1) , search_option_id int, [name] varchar(500))

	-- Create temp table to store the boundary search option ids ordered by their name.
	CREATE TABLE #boundary_search_option(boundary_search_option_id int identity(1,1) , search_option_id int)

	CREATE TABLE #product_ids(prodct_index_id int identity(1,1) , product_id int)
	
	IF (@selectedSearchOptionIds <> '')
	BEGIN
		INSERT INTO #product_ids
		SELECT product_id
		FROM
			(
				--Select exactly matching category_ids based on option count.
				SELECT product_id, COUNT(product_id) AS option_count
				FROM product_to_search_option sso
					INNER JOIN #options_table ot
						ON sso.search_option_id = ot.[value]
				GROUP BY product_id
			) AS prod						
		WHERE prod.option_count = @optCount
	END				
	-- Insert data into ordered_search_option temp table
	IF (@mainIndexSelection = 'num')
	BEGIN
		INSERT INTO #ordered_search_option
		SELECT DISTINCT s.search_option_id, s.[name]
		FROM search_option s
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id AND s.enabled = 1 AND s.search_group_id = @searchGroupId AND s.[name] NOT LIKE '[abcdefghijklmnopqrstuvwxyz]%'
			INNER JOIN product_to_category pc
				ON pc.product_id = ps.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
			INNER JOIN product p
				ON p.product_id = pc.product_id AND p.enabled = 1 AND (@considerShowInMatrixSetting = 0 OR p.show_in_matrix = 1)
		WHERE 
			(
				@selectedSearchOptionIds = '' OR
					ps.product_id IN (
						SELECT product_id
						FROM #product_ids
						)
			)
		ORDER BY [name]
	END
	ELSE
	BEGIN
		INSERT INTO #ordered_search_option
		SELECT DISTINCT s.search_option_id, s.[name]
		FROM search_option s
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id AND s.enabled = 1 AND s.search_group_id = @searchGroupId AND s.[name] LIKE '' + @mainIndexSelection + '%'
			INNER JOIN product_to_category pc
				ON pc.product_id = ps.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
			INNER JOIN product p
				ON p.product_id = pc.product_id AND p.enabled = 1 AND (@considerShowInMatrixSetting = 0 OR p.show_in_matrix = 1)
		WHERE 
			(
				@selectedSearchOptionIds = '' OR
					ps.product_id IN (
						SELECT product_id
						FROM #product_ids
					)
			)
		ORDER BY [name]
	END
	
	-- Insert data into #boundary_search_option temp table
	INSERT INTO #boundary_search_option
	SELECT search_option_id
	FROM #ordered_search_option
	WHERE 
		(ordered_search_option_id % @numberOfResults = 1) OR
		(ordered_search_option_id % @numberOfResults = 0)
	ORDER BY ordered_search_option_id

	INSERT INTO #boundary_search_option
	SELECT TOP(1) search_option_id
	FROM #ordered_search_option
	WHERE (ordered_search_option_id % @numberOfResults <> 0) OR	(ordered_search_option_id % @numberOfResults <> 1)
	ORDER BY ordered_search_option_id DESC
	
	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(	
		SELECT search_option_id
		FROM #boundary_search_option
	)
	ORDER BY [name]

	-- Drop the temp tables
	DROP TABLE #options_table
	DROP TABLE #product_ids
	DROP TABLE #ordered_search_option
	DROP TABLE #boundary_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetAllFixedGuidedBrowseBoundarySearchOptionsList TO VpWebApp 
GO
-------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetFixedGuidedBrowseBoundarySearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicSearchCategory_GetFixedGuidedBrowseBoundarySearchOptionsList]
	@categoryId int,
	@guidedBrowseSearchGroupId int,
	@numberOfResults int,
	@mainIndexSelection varchar(10),
	@selectedSearchOptionIds varchar(50),
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optCount int
	SELECT * INTO #options_table FROM dbo.global_Split(@selectedSearchOptionIds, ',') 
	SET @optCount = (SELECT COUNT([value]) FROM #options_table)
	
	-- Create temp table to store the search option ids ordered by their name.
	CREATE TABLE #ordered_search_option(ordered_search_option_id int identity(1,1) , search_option_id int, [name] varchar(500))

	-- Create temp table to store the boundary search option ids ordered by their name.
	CREATE TABLE #boundary_search_option(boundary_search_option_id int identity(1,1) , search_option_id int)

	CREATE TABLE #product_ids(prodct_index_id int identity(1,1) , product_id int)
	
	IF (@selectedSearchOptionIds <> '')
	BEGIN
		INSERT INTO #product_ids
		SELECT product_id
		FROM
			(
				--Select exactly matching category_ids based on option count.
				SELECT product_id, COUNT(product_id) AS option_count
				FROM product_to_search_option sso
					INNER JOIN #options_table ot
						ON sso.search_option_id = ot.[value]
				GROUP BY product_id
			) AS prod						
		WHERE prod.option_count = @optCount
	END				
	-- Insert data into ordered_search_option temp table
	IF (@mainIndexSelection = 'num')
	BEGIN
		INSERT INTO #ordered_search_option
		SELECT DISTINCT s.search_option_id, s.[name]
		FROM search_option s
			INNER JOIN guided_browse_to_search_group_to_search_option gbso
				ON gbso.search_option_id = s.search_option_id AND gbso.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id AND s.enabled = 1 AND s.[name] NOT LIKE '[abcdefghijklmnopqrstuvwxyz]%'
			INNER JOIN product_to_category pc
				ON pc.product_id = ps.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
			INNER JOIN product p
				ON p.product_id = pc.product_id AND p.enabled = 1 AND (@considerShowInMatrixSetting = 0 OR p.show_in_matrix = 1)
		WHERE 
			(
				@selectedSearchOptionIds = '' OR
					ps.product_id IN (
						SELECT product_id
						FROM #product_ids
						)
			)
		ORDER BY [name]
	END
	ELSE
	BEGIN
		INSERT INTO #ordered_search_option
		SELECT DISTINCT s.search_option_id, s.[name]
		FROM search_option s
			INNER JOIN guided_browse_to_search_group_to_search_option gbso
				ON gbso.search_option_id = s.search_option_id AND gbso.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id AND s.enabled = 1 AND s.[name] LIKE '' + @mainIndexSelection + '%'
			INNER JOIN product_to_category pc
				ON pc.product_id = ps.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
			INNER JOIN product p
				ON p.product_id = pc.product_id AND p.enabled = 1 AND (@considerShowInMatrixSetting = 0 OR p.show_in_matrix = 1)
		WHERE 
			(
				@selectedSearchOptionIds = '' OR
					ps.product_id IN (
						SELECT product_id
						FROM #product_ids
					)
			)
		ORDER BY [name]
	END
	
	-- Insert data into #boundary_search_option temp table
	INSERT INTO #boundary_search_option
	SELECT search_option_id
	FROM #ordered_search_option
	WHERE 
		(ordered_search_option_id % @numberOfResults = 1) OR
		(ordered_search_option_id % @numberOfResults = 0)
	ORDER BY ordered_search_option_id

	INSERT INTO #boundary_search_option
	SELECT TOP(1) search_option_id
	FROM #ordered_search_option
	WHERE (ordered_search_option_id % @numberOfResults <> 0) OR	(ordered_search_option_id % @numberOfResults <> 1)
	ORDER BY ordered_search_option_id DESC
	
	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(	
		SELECT search_option_id
		FROM #boundary_search_option
	)
	ORDER BY [name]

	-- Drop the temp tables
	DROP TABLE #options_table
	DROP TABLE #product_ids
	DROP TABLE #ordered_search_option
	DROP TABLE #boundary_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetFixedGuidedBrowseBoundarySearchOptionsList TO VpWebApp 
GO