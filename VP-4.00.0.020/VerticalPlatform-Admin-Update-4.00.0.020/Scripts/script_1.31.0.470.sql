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
	SELECT * INTO #optionsTable FROM dbo.global_Split(@selectedSearchOptionIds, ',') 
	SET @optCount = (SELECT COUNT([value]) FROM #optionsTable)
	
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
					INNER JOIN #optionsTable ot
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
	DROP TABLE #ordered_search_option
	DROP TABLE #boundary_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetFixedGuidedBrowseBoundarySearchOptionsList TO VpWebApp 
GO
-----------------------------------------------------------------------------------
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
	SELECT * INTO #optionsTable FROM dbo.global_Split(@selectedSearchOptionIds, ',') 
	SET @optCount = (SELECT COUNT([value]) FROM #optionsTable)
	
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
					INNER JOIN #optionsTable ot
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
	DROP TABLE #ordered_search_option
	DROP TABLE #boundary_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetAllFixedGuidedBrowseBoundarySearchOptionsList TO VpWebApp 
GO