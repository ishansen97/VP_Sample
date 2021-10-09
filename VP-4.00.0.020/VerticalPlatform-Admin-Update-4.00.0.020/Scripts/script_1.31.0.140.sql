GRANT SELECT ON dbo.site TO VpWebApp

----

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetBoundarySearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetBoundarySearchOptionsList
	@categoryId int,
	@searchGroupId int,
	@numberOfResults int,
	@mainIndexSelection varchar(10),
	@selectedSearchOptionId int,
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	-- Create temp table to store the search option ids ordered by their name.
	CREATE TABLE #ordered_search_option(ordered_search_option_id int identity(1,1) , search_option_id int, [name] varchar(500))

	-- Create temp table to store the boundary search option ids ordered by their name.
	CREATE TABLE #boundary_search_option(boundary_search_option_id int identity(1,1) , search_option_id int)

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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
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
	DROP TABLE #ordered_search_option
	DROP TABLE #boundary_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetBoundarySearchOptionsList TO VpWebApp 
GO

-------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetGuidedBrowseBoundarySearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetGuidedBrowseBoundarySearchOptionsList
	@categoryId int,
	@guidedBrowseSearchGroupId int,
	@numberOfResults int,
	@mainIndexSelection varchar(10),
	@selectedSearchOptionId int,
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	-- Create temp table to store the search option ids ordered by their name.
	CREATE TABLE #ordered_search_option(ordered_search_option_id int identity(1,1) , search_option_id int, [name] varchar(500))

	-- Create temp table to store the boundary search option ids ordered by their name.
	CREATE TABLE #boundary_search_option(boundary_search_option_id int identity(1,1) , search_option_id int)

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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
					)
			)
		ORDER BY s.[name]
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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
					)
			)
		ORDER BY s.[name]
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
	DROP TABLE #ordered_search_option
	DROP TABLE #boundary_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetGuidedBrowseBoundarySearchOptionsList TO VpWebApp 
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetGuidedBrowseSearchOptionsSegmentList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetGuidedBrowseSearchOptionsSegmentList
	@categoryId int,
	@guidedBrowseSearchGroupId int,
	@numberOfResults int,
	@mainIndexSelection varchar(10),
	@startIndex int,
	@endIndex int,
	@selectedSearchOptionId int,
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	-- Create temp table to store the search option ids ordered by their name.
	CREATE TABLE #ordered_search_option(ordered_search_option_id int identity(1,1) , search_option_id int, [name] varchar(500))

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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
					)
			)
		ORDER BY [name]
	END
	
	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id	
		FROM #ordered_search_option
		WHERE ordered_search_option_id BETWEEN @startIndex AND @endIndex
	)
	ORDER BY [name]

	-- Drop the temp tables
	DROP TABLE #ordered_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetGuidedBrowseSearchOptionsSegmentList TO VpWebApp 
GO

------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsSegmentList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsSegmentList
	@categoryId int,
	@searchGroupId int,
	@numberOfResults int,
	@mainIndexSelection varchar(10),
	@startIndex int,
	@endIndex int,
	@selectedSearchOptionId int,
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	-- Create temp table to store the search option ids ordered by their name.
	CREATE TABLE #ordered_search_option(ordered_search_option_id int identity(1,1) , search_option_id int, [name] varchar(500))

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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
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
				@selectedSearchOptionId = 0 OR
					ps.product_id IN (
						SELECT product_id
						FROM product_to_search_option
						WHERE search_option_id = @selectedSearchOptionId
					)
			)
		ORDER BY [name]
	END
	
	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id	
		FROM #ordered_search_option
		WHERE ordered_search_option_id BETWEEN @startIndex AND @endIndex
	)
	ORDER BY [name]

	-- Drop the temp tables
	DROP TABLE #ordered_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsSegmentList TO VpWebApp 
GO

---------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM article_resource_type WHERE type_name = 'MultimediaGallery')
BEGIN
	INSERT INTO article_resource_type 
([article_resource_type_id],[type_name],[enabled],[created],[modified])VALUES 
(17,'MultimediaGallery','true',getdate(),getdate())
END
GO
------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'adminTag_GetTagsBySiteIdWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminTag_GetTagsBySiteIdWithPaging
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1)
	SET @endIndex = @pageSize * @pageIndex

	SELECT @numberOfRows = COUNT(*)
	FROM article_type
	WHERE site_id = @siteId;
	
	With temp_tag(row_id, id, content_tag_id, tag, [user_id], is_public_user, [enabled], modified, created) AS
	(		
		SELECT ROW_NUMBER() OVER (ORDER BY tag ASC) AS row_id, tag_id AS id, tag.content_tag_id, tag, [user_id], 
			is_public_user, tag.enabled, tag.modified, tag.created
		FROM tag
			INNER JOIN content_tag
				ON tag.content_tag_id = content_tag.content_tag_id
		WHERE content_tag.site_id = @siteId 
	)
	
	SELECT id, content_tag_id, tag, [user_id], is_public_user, [enabled], modified, created
	FROM temp_tag
	WHERE row_id BETWEEN @startIndex AND @endIndex
	
END
GO

GRANT EXECUTE ON adminTag_GetTagsBySiteIdWithPaging TO VpWebApp 
GO
----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleTypeParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleTypeParameter
	@id int,
	@articleTypeId int,
	@parameterTypeId int,
	@articleTypeParameterValue varchar(max),
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

	UPDATE article_type_parameter	
	SET 
		article_type_id = @articleTypeId,
		parameter_type_id = @parameterTypeId,
		article_type_parameter_value = @articleTypeParameterValue,
		[enabled] = @enabled,
		modified = @modified
	WHERE article_type_parameter_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleTypeParameter TO VpWebApp 
GO
-------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleTypeParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticleTypeParameter
	@articleTypeId int,
	@parameterTypeId int,
	@articleTypeParameterValue varchar(max),
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO article_type_parameter(article_type_id, parameter_type_id, article_type_parameter_value,
		[enabled], modified, created)
	VALUES ( @articleTypeId, @parameterTypeId, @articleTypeParameterValue, @enabled, 
		@created, @created)

	SET @id = SCOPE_IDENTITY() 

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticleTypeParameter To VpWebApp
GO

