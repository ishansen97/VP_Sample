GRANT INSERT ON dbo.ssis_task_log TO VpWebApp
GRANT DELETE ON dbo.ssis_task_log TO VpWebApp
GRANT SELECT ON dbo.ssis_task_log TO VpWebApp

----------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsSegmentListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsSegmentListWithPaging
	@categoryId int,
	@searchGroupId int,
	@numberOfResults int,
	@mainIndexSelection varchar(10),
	@startIndex int,
	@endIndex int,
	@searchOptionIds varchar(50),
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optCount int
	SELECT * INTO #search_options FROM dbo.global_Split(@searchOptionIds, ',') 
	SET @optCount = (SELECT COUNT([value]) FROM #search_options)
	
	-- Create temp table to store the search option ids ordered by their name.
	CREATE TABLE #ordered_search_option(ordered_search_option_id int identity(1,1) , search_option_id int, [name] varchar(500))
	
	CREATE TABLE #product_ids(prodct_index_id int identity(1,1) , product_id int)
		
	IF (@searchOptionIds <> '')
	BEGIN
		INSERT INTO #product_ids
		SELECT pso.product_id
		FROM product_to_search_option pso
			INNER JOIN #search_options ot
				ON pso.search_option_id = ot.[value]
			INNER JOIN product_to_category pc
				ON pc.product_id = pso.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
		GROUP BY pso.product_id
		HAVING COUNT(pso.product_id) = @optCount
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
				@searchOptionIds = '' OR
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
				@searchOptionIds = '' OR
					ps.product_id IN (
						SELECT product_id
						FROM #product_ids
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
	DROP TABLE #search_options
	DROP TABLE #product_ids
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsSegmentListWithPaging TO VpWebApp 
GO