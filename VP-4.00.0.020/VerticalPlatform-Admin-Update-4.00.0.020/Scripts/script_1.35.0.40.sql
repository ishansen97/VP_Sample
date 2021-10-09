IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'description' AND id = 
		(SELECT [object_id] FROM sys.objects 
		WHERE [object_id] = OBJECT_ID(N'[dbo].vendor') AND [type] in (N'U'))
)
BEGIN
	ALTER TABLE [vendor]
	ADD [description] varchar(MAX)
END
GO

----------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetManufacturersByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetManufacturersByProductIdList
	@productIds VARCHAR(MAX)

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT [vendor].[vendor_id] AS [Id],[vendor].[site_id],[vendor].[vendor_name],[vendor].[rank],[vendor].[has_image],[vendor].[enabled]
		,[vendor].[modified],[vendor].[created],[vendor].[parent_vendor_id],[vendor].[vendor_keywords],[vendor].[internal_name], [vendor].[description]
	FROM [vendor]
		INNER JOIN [product_to_vendor]
			ON [vendor].[vendor_id] = [product_to_vendor].[vendor_id]
		INNER JOIN global_split(@productIds, ',') tempProduct
			ON tempProduct.[value] = [product_to_vendor].[product_id] AND [product_to_vendor].[enabled] = 1
	WHERE [product_to_vendor].[is_manufacturer] = 1 AND [vendor].[enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetManufacturersByProductIdList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'is_dynamic' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD is_dynamic BIT NOT NULL DEFAULT(0)
END
GO
------------------------------------------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'build_option_list' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD build_option_list BIT NOT NULL DEFAULT(1)
END
GO

-----------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fixed_guided_browse_permutation]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[fixed_guided_browse_permutation](
		[fixed_guided_browse_permutation_id] [int] IDENTITY(1,1) NOT NULL,
		[fixed_guided_browse_id] [int] NOT NULL,
		[search_option_permutation] [varchar](100) NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_fixed_guided_browse_permutation] PRIMARY KEY CLUSTERED 
	(
		[fixed_guided_browse_permutation_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetGuidedBrowseSearchOptionsSegmentListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetGuidedBrowseSearchOptionsSegmentListWithPaging
	@categoryId int,
	@guidedBrowseSearchGroupId int,
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
		SELECT product_id
		FROM
			(
				--Select exactly matching product_ids based on option count.
				SELECT pso.product_id, COUNT(pso.product_id) AS option_count
				FROM product_to_search_option pso
					INNER JOIN #search_options ot
						ON pso.search_option_id = ot.[value]
					INNER JOIN product_to_category pc
			ON pc.product_id = pso.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
				GROUP BY pso.product_id
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

GRANT EXECUTE ON dbo.publicSearchCategory_GetGuidedBrowseSearchOptionsSegmentListWithPaging TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
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
		SELECT product_id
		FROM
			(
				--Select exactly matching product_ids based on option count.
				SELECT pso.product_id, COUNT(pso.product_id) AS option_count
				FROM product_to_search_option pso
					INNER JOIN #search_options ot
						ON pso.search_option_id = ot.[value]
					INNER JOIN product_to_category pc
			ON pc.product_id = pso.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
				GROUP BY pso.product_id
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
-------------------------------------------------------------------------------------------------------------------------
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
	SELECT * INTO #search_options FROM dbo.global_Split(@selectedSearchOptionIds, ',') 
	SET @optCount = (SELECT COUNT([value]) FROM #search_options)
	
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
				--Select exactly matching product_ids based on option count.
				SELECT pso.product_id, COUNT(pso.product_id) AS option_count
				FROM product_to_search_option sso
					INNER JOIN #search_options ot
						ON sso.search_option_id = ot.[value]
					INNER JOIN product_to_category pc
				ON pc.product_id = pso.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
				GROUP BY pso.product_id
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
	DROP TABLE #product_ids
	DROP TABLE #search_options
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetFixedGuidedBrowseBoundarySearchOptionsList TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId
	@searchCategoryId int,
	@searchOptionsIds varchar(max),
	@optionCount int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT @totalCount = COUNT(prods.product_id)
	FROM
	(
		SELECT ptso.product_id, COUNT(ptso.product_id) AS opt_count
		FROM product_to_search_option ptso				
			INNER JOIN global_Split(@searchOptionsIds, ',') pso
				ON	pso.[value] = ptso.search_option_id	
			INNER JOIN product_to_category pc
				ON pc.product_id = ptso.product_id AND pc.category_id = @searchCategoryId				
		GROUP BY ptso.product_id
	) prods
	INNER JOIN product p
		ON p.product_id = prods.product_id
	WHERE prods.opt_count = @optionCount  AND p.enabled = 1
END
GO

GRANT EXECUTE ON dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowse
	@id int output,
	@categoryId int,
	@name varchar(200),
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
	@enabled bit,	
	@buildOptionList bit,
	@isDynamic bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, [name],  segment_size, [enabled],
	prefix_text, suffix_text, naming_rule, created, modified, build_option_list, is_dynamic)
	VALUES (@categoryId, @name, @segmentSize, @enabled,
	@prefixText, @suffixText, @namingRule, @created, @created, @buildOptionList, @isDynamic)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowse TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE [enabled] = 1 AND category_id IN
	(
		SELECT category_id
		FROM category
		WHERE site_id = @siteId
	)

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsePermutation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsePermutation
	@id int
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_permutation_id AS id, fixed_guided_browse_id, search_option_permutation, [enabled], created, modified
	FROM fixed_guided_browse_permutation
	WHERE fixed_guided_browse_permutation_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsePermutation TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowsePermutation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowsePermutation
	@id int output,
	@fixedGuidedBrowseId int,
	@searchOptionPermutation varchar(100),
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
	INSERT INTO fixed_guided_browse_permutation(fixed_guided_browse_id, search_option_permutation, [enabled], created, modified)
	VALUES (@fixedGuidedBrowseId, @searchOptionPermutation, @enabled, @created, @created)
	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowsePermutation TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowsePermutation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowsePermutation
	@id int,
	@fixedGuidedBrowseId int,
	@searchOptionPermutation varchar(100),
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

	UPDATE fixed_guided_browse_permutation
	SET
		fixed_guided_Browse_id = @fixedGuidedBrowseId,
		search_option_permutation = @searchOptionPermutation,
		enabled = @enabled,
		modified = @modified
	WHERE fixed_guided_browse_permutation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowsePermutation TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowsePermutation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowsePermutation
	@id int
AS
-- ==========================================================================
-- $Author: Sujith
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM fixed_guided_browse_permutation
	WHERE fixed_guided_browse_permutation_id = @id;

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowsePermutation TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowsePermutationByFixedGuidedBrowseId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowsePermutationByFixedGuidedBrowseId
	@fixedGuidedBrowseId int
AS
-- ==========================================================================
-- $Author: Sujith
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM fixed_guided_browse_permutation
	WHERE fixed_guided_browse_id = @fixedGuidedBrowseId

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowsePermutationByFixedGuidedBrowseId TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsePermutationByfixedGuidedBrowseId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsePermutationByfixedGuidedBrowseId
	@fixedGuidedBrowseId int
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_permutation_id AS id, fixed_guided_browse_id, search_option_permutation, [enabled], created, modified
	FROM fixed_guided_browse_permutation
	WHERE fixed_guided_browse_id = @fixedGuidedBrowseId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsePermutationByfixedGuidedBrowseId TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowse
	@id int,
	@categoryId int,
	@name varchar(200),
	@enabled bit,	
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
	@buildOptionList bit,
	@isDynamic bit,
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
		segment_size = @segmentSize,
		prefix_text = @prefixText,
		suffix_text = @suffixText,
		naming_rule = @namingRule,
		enabled = @enabled,
		modified = @modified,
		build_option_list = @buildOptionList, 
		is_dynamic = @isDynamic
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowse TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteFixedGuidedBrowsePermutationBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteFixedGuidedBrowsePermutationBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM fixed_guided_browse_permutation
	WHERE fixed_guided_browse_id IN
	(
		SELECT fixed_guided_browse_id
		FROM fixed_guided_browse
		WHERE category_id IN
		(
			SELECT category_id
			FROM category
			WHERE site_id = @siteId
		)
	)

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteFixedGuidedBrowsePermutationBySiteIdList TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllFixedGuidedBrowses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllFixedGuidedBrowses
	
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllFixedGuidedBrowses TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'sort_order' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product_to_product') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [product_to_product]
	ADD sort_order int not null default 0
END
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductToProduct
	@id int output,
	@parentProductId int,
	@productId int,
	@sortOrder int,
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO product_to_product (parent_product_id, product_id, sort_order, [enabled], modified, created)
	VALUES (@parentProductId, @productId, @sortOrder, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductToProduct TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductToProduct
	@id int,
	@parentProductId int,
	@productId int,
	@sortOrder int,
	@enabled bit,
	@modified smalldatetime output
	 
AS
-- ==========================================================================
-- $Author: Dimuthu $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.product_to_product
	SET parent_product_id = @parentProductId,
		product_id = @productId,
		sort_order = @sortOrder,
		enabled = @enabled,		
		modified = @modified
	WHERE product_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductToProduct TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductToProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductToProductDetail
@id int
	
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id as id, parent_product_id, product_id, sort_order, enabled, created, modified
	FROM product_to_product	
	WHERE product_to_product_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductToProductDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductToProductByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductToProductByProductIdList
@productId int
	
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id as id, parent_product_id, product_id, sort_order, enabled, created, modified
	FROM product_to_product	
	WHERE product_to_product.parent_product_id = @productId
	ORDER BY sort_order ASC

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductToProductByProductIdList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductToProductsByParentProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminProduct_GetProductToProductsByParentProductIdsList]
	@parentProductIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id as id, parent_product_id, product_id, sort_order, enabled, created, modified
	FROM product_to_product	
		INNER JOIN global_Split(@parentProductIds, ',') AS product_id_table
			ON product_to_product.parent_product_id = product_id_table.[value]
	WHERE product_to_product.enabled = 1
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductToProductsByParentProductIdsList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductToProductByChildProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.publicProduct_GetProductToProductByChildProductIdList
	@productId int
AS
-- ==========================================================================
-- Author : Dimuthu
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id AS id, parent_product_id, product_id, sort_order, enabled, created, modified
	FROM product_to_product	
	WHERE product_to_product.product_id = @productId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductToProductByChildProductIdList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds
	@ParentProductId int,
	@productCompressionGroupId int,
	@searchOptionIds varchar(max),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dimuthu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

;WITH ChildProducts AS (
	SELECT DISTINCT product.product_id AS id, site_id, product.parent_product_id, product_name, [rank], has_image, catalog_number, product.enabled,
		product.modified, product.created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank, default_search_rank,
		pp.sort_order
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id AND pp.enabled = 1
	INNER JOIN product_to_category ptc
		ON 	ptc.product_id = pp.product_id  AND ptc.enabled = 1
	INNER JOIN product_compression_group_to_product proGro
		ON pp.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		) AND 
		pp.parent_product_id = @ParentProductId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ','))) AND
		product.enabled = 1)
		
	SELECT  id, site_id, parent_product_id, product_name, [rank], has_image, catalog_number, enabled,
			modified, created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
			search_content_modified, hidden, business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank, default_search_rank 
	FROM ChildProducts
	ORDER BY sort_order ASC

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddVendor
	@siteId int,
	@vendorName varchar(100),
	@enabled bit,
	@rank int,
	@hasImage bit,
	@parentVendorId int,
	@keywords varchar(MAX),
	@internalName varchar(255),
	@description varchar(MAX),
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @created=GETDATE()
	INSERT INTO vendor(site_id, vendor_name, rank, has_image, [enabled], modified, created, parent_vendor_id, vendor_keywords, internal_name, description)
	VALUES (@siteId, @vendorName, @rank, @hasImage, @enabled, @created, @created, @parentVendorId, @keywords, @internalName, @description)

	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddVendor TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ven.vendor_id as id, site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified,ven.created, ven.parent_vendor_id, ven.vendor_keywords, internal_name, ven.[description]
	FROM vendor ven
	WHERE ven.vendor_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetVendorDetail TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateVendor
	@id int,
	@siteId int,
	@vendorName varchar(100),
	@rank int,
	@hasImage bit,
	@enabled bit,
	@parentVendorId int,
	@internalName VARCHAR(255),
	@description varchar(MAX),
	@keywords varchar(MAX),
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE vendor
	SET 
		site_id = @siteId,
		vendor_name = @vendorName,
		rank = @rank,
		has_image = @hasImage,
		[enabled] = @enabled,
		modified = @modified,
		parent_vendor_id = @parentVendorId,
		vendor_keywords = @keywords,
		internal_name = @internalName,
		[description] = @description
	WHERE vendor_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateVendor TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorByProductIdList
	@id int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ven.vendor_id as id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled],
			ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name, 
			ven.[description]
	FROM vendor ven
		INNER JOIN product_to_vendor
			ON ven.vendor_id = product_to_vendor.vendor_id
	WHERE product_to_vendor.product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetVendorByProductIdList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorByCategoryIdList
	@id int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT ven.vendor_id AS id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled], 
			ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name,
			ven.[description]
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




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorByCategoryIdListWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorByCategoryIdListWithSorting
	@id int,
	@sortBy varchar(6)
AS
-- ==========================================================================
-- $Author : Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH vendors AS
	(
		SELECT DISTINCT vendor_id, site_id, ROW_NUMBER() OVER (ORDER BY vendor_name) AS nameRow, vendor_name
				, ROW_NUMBER() OVER (ORDER BY rank DESC) AS rankRow, rank, has_image, [enabled]
				, modified, created, parent_vendor_id, vendor_keywords, internal_name, [description]
				
		FROM(
			SELECT DISTINCT ven.vendor_id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
				, ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, internal_name, ven.[description]
			FROM product_to_category catPro
				INNER JOIN product_to_vendor proVen
					ON catPro.product_id = proVen.product_id
				INNER JOIN vendor ven
					ON proVen.vendor_id = ven.vendor_id AND ven.enabled = 1
			WHERE catPro.category_id = @id
			) AS vendor
	)

	SELECT vendor_id AS id, site_id, vendor_name, rank, has_image, [enabled], modified, created
			, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM vendors
	ORDER BY 
		CASE @sortBy
			WHEN 'Name' THEN nameRow
			WHEN 'Rank' THEN rankRow 
		END

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetVendorByCategoryIdListWithSorting TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorList
	@siteId int,
	@sortBy VARCHAR(7)
AS
-- ========================================================================== 
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF(@sortBy = 'id')
	BEGIN
		SELECT vendor_id AS id, site_id AS site_id, vendor_name AS vendor_name, rank AS rank
				, has_image AS has_image, [enabled] AS [enabled], modified AS modified, created AS created
				, parent_vendor_id, vendor_keywords, internal_name, [description]
		FROM vendor
		WHERE site_id = @siteId
		ORDER BY vendor_id
	END
	ELSE
	BEGIN
		SELECT vendor_id AS id, site_id AS site_id, vendor_name AS vendor_name, rank AS rank
				, has_image AS has_image, [enabled] AS [enabled], modified AS modified, created AS created
				, parent_vendor_id, vendor_keywords, internal_name, [description]
		FROM vendor
		WHERE site_id = @siteId
		ORDER BY vendor_name
	END


END
GO

GRANT EXECUTE ON dbo.publicProduct_GetVendorList TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNonPayingVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNonPayingVendorByCategoryIdList
	@categoryId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

SELECT vendor_id, site_id, ROW_NUMBER() OVER(ORDER BY vendor_name) AS vendorRow
		, vendor_name, [rank], has_image, [enabled], modified, created, parent_vendor_id, vendor_keywords, internal_name, [description]
INTO #temp_vendor
FROM vendor
WHERE vendor.vendor_id IN
(
	SELECT vendor.vendor_id
	FROM vendor
		INNER JOIN category_to_vendor
			ON vendor.vendor_id = category_to_vendor.vendor_id
	WHERE category_id = @categoryId AND category_to_vendor.enabled = '1' AND vendor.enabled = '1'

	EXCEPT

	SELECT vendor.vendor_id
	FROM vendor 
			INNER JOIN product_to_vendor
				ON vendor.vendor_id = product_to_vendor.vendor_id AND vendor.enabled = '1' AND product_to_vendor.enabled = '1'
			INNER JOIN product_to_category
				ON product_to_vendor.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
			INNER JOIN product
				ON product_to_category.product_id = product.product_id AND product.enabled = '1'
	WHERE product_to_category.category_id = @categoryId
)

SELECT @totalRowCount = COUNT(*) FROM #temp_vendor

SELECT vendor_id AS id, site_id, vendor_name, [rank], has_image, [enabled], modified, created
		, parent_vendor_id, vendor_keywords, internal_name, [description]
FROM #temp_vendor
WHERE vendorRow BETWEEN @startRowIndex AND @endRowIndex

DROP TABLE #temp_vendor

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNonPayingVendorByCategoryIdList TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetAllNonPayingVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetAllNonPayingVendorByCategoryIdList
	@categoryId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

SELECT vendor_id as id, site_id, vendor_name, [rank], has_image, [enabled], modified, created, parent_vendor_id, vendor_keywords, internal_name, [description]
FROM vendor
WHERE vendor.vendor_id IN
(
	SELECT vendor.vendor_id
	FROM vendor
		INNER JOIN category_to_vendor
			ON vendor.vendor_id = category_to_vendor.vendor_id
	WHERE category_id = @categoryId AND category_to_vendor.enabled = '1' AND vendor.enabled = '1'

	EXCEPT

	SELECT vendor.vendor_id
	FROM vendor 
			INNER JOIN product_to_vendor
				ON vendor.vendor_id = product_to_vendor.vendor_id AND vendor.enabled = '1' AND product_to_vendor.enabled = '1'
			INNER JOIN product_to_category
				ON product_to_vendor.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
			INNER JOIN product
				ON product_to_category.product_id = product.product_id AND product.enabled = '1'
	WHERE product_to_category.category_id = @categoryId
)
ORDER BY vendor_name

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetAllNonPayingVendorByCategoryIdList TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorByProductIdManufacturerDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorByProductIdManufacturerDetail
	@productId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT vendor.vendor_id AS id, site_id, vendor_name, [rank], has_image, vendor.[enabled]
		, vendor.created, vendor.modified, vendor.parent_vendor_id, vendor.vendor_keywords,internal_name, [description]
	FROM product_to_vendor
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id
	WHERE product_to_vendor.product_id = @productId
		AND product_to_vendor.is_manufacturer = '1'

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetVendorByProductIdManufacturerDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorsBySiteIdLikeVendorName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorsBySiteIdLikeVendorName
	@siteId int,
	@value varchar(max),
	@isEnabled bit,
	@selectLimit int
	
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT TOP (@selectLimit) ven.vendor_id as id, site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, internal_name, ven.[description]
	FROM vendor ven
	WHERE ven.site_id = @siteId AND ven.vendor_name like @value+'%' AND (@isEnabled IS NULL OR ven.enabled = @isEnabled)

END
GO

GRANT EXECUTE ON adminProduct_GetVendorsBySiteIdLikeVendorName TO VpWebApp
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetParentVendorsBySiteIdLikeVendorName'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetParentVendorsBySiteIdLikeVendorName]
	@siteId int,
	@value varchar(MAX),
	@isEnabled bit,
	@selectLimit int,
	@parentVendorIdOnly bit
	
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT DISTINCT TOP (@selectLimit) ven.vendor_id as id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name, ven.[description]
	FROM vendor ven
		LEFT OUTER JOIN vendor pv ON ven.vendor_id = pv.parent_vendor_id
	WHERE ven.site_id = @siteId AND ven.vendor_name like @value+'%' AND (@isEnabled IS NULL OR ven.enabled = @isEnabled)
	AND ven.parent_vendor_id is NULL AND 
	(
		(
			@parentVendorIdOnly = 1 
			AND 
			ven.vendor_id NOT IN (SELECT distinct parent_vendor_id from vendor where site_id=@siteId AND parent_vendor_id IS NOT NULL )
		)
		OR
			@parentVendorIdOnly = 0
	)
	

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetParentVendorsBySiteIdLikeVendorName TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorBySiteIdSortedPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorBySiteIdSortedPageList
	@siteId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@startIndex int,
	@endIndex int,
	@search varchar(50) = NULL,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #temp_vendor (vendor_id int, site_id int, vendor_name varchar(100), vendor_rank int
	, has_image bit, enabled bit, modified smalldatetime, created smalldatetime, parent_vendor_id int
	, vendor_keywords varchar(MAX), internal_name varchar(255), [description] varchar(MAX), product_featured int
	, product_standard int, product_minimized int, product_total int, product_live_total int
	, vendor_id_row_asc int, vendor_id_row_desc int, vendor_name_row_asc int, vendor_name_row_desc int
	, vendor_rank_row_asc int, vendor_rank_row_desc int, product_featured_row_asc int
	, product_featured_row_desc int, product_standard_row_asc int, product_standard_row_desc int
	, product_minimized_row_asc int, product_minimized_row_desc int
	, product_total_row_asc int, product_total_row_desc int
	, product_live_total_row_asc int, product_live_total_row_desc int
	, vendor_enabled_row_asc int, vendor_enabled_row_desc int)

	CREATE TABLE #temp_sorted_vendor (vendor_id int, site_id int, vendor_name varchar(100), vendor_rank int
		, has_image bit, enabled bit, modified smalldatetime, created smalldatetime, parent_vendor_id int, vendor_keywords varchar(MAX), internal_name varchar(225), [description] varchar(MAX), row int)

	INSERT INTO #temp_vendor (vendor_id, site_id, vendor_name, vendor_rank, has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name, [description]
		, created, product_featured, product_standard, product_minimized, product_total, product_live_total
		, vendor_id_row_asc, vendor_id_row_desc, vendor_name_row_asc, vendor_name_row_desc, vendor_rank_row_asc
		, vendor_rank_row_desc, product_featured_row_asc, product_featured_row_desc
		, product_standard_row_asc, product_standard_row_desc, product_minimized_row_asc
		, product_minimized_row_desc, product_total_row_asc, product_total_row_desc
		, product_live_total_row_asc, product_live_total_row_desc
		, vendor_enabled_row_asc, vendor_enabled_row_desc)
	SELECT vendor_id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name, [description]
		, created,[3] AS product_featured, [2] AS product_standard, [1] AS product_minimized
		, product_total, product_live_total
		, ROW_NUMBER() OVER (ORDER BY vendor_id ASC) AS vendor_id_row_asc
		, ROW_NUMBER() OVER (ORDER BY vendor_id DESC) AS vendor_id_row_desc
		, ROW_NUMBER() OVER (ORDER BY vendor_name ASC) AS vendor_name_row_asc
		, ROW_NUMBER() OVER (ORDER BY vendor_name DESC) AS vendor_name_row_desc
		, ROW_NUMBER() OVER (ORDER BY vendor_rank ASC) AS vendor_rank_row_asc
		, ROW_NUMBER() OVER (ORDER BY vendor_rank DESC) AS vendor_rank_row_desc
		, ROW_NUMBER() OVER (ORDER BY [3] ASC) AS product_featured_row_asc
		, ROW_NUMBER() OVER (ORDER BY [3] DESC) AS product_featured_row_desc
		, ROW_NUMBER() OVER (ORDER BY [2] ASC) AS product_standard_row_asc
		, ROW_NUMBER() OVER (ORDER BY [2] DESC) AS product_standard_row_desc
		, ROW_NUMBER() OVER (ORDER BY [1] ASC) AS product_minimized_row_asc
		, ROW_NUMBER() OVER (ORDER BY [1] DESC) AS product_minimized_row_desc
		, ROW_NUMBER() OVER (ORDER BY product_total ASC) AS product_total_row_asc
		, ROW_NUMBER() OVER (ORDER BY product_total DESC) AS product_total_row_desc
		, ROW_NUMBER() OVER (ORDER BY product_live_total ASC) AS product_live_total_row_asc
		, ROW_NUMBER() OVER (ORDER BY product_live_total DESC) AS product_live_total_row_desc
		, ROW_NUMBER() OVER (ORDER BY enabled ASC) AS vendor_enabled_row_asc
		, ROW_NUMBER() OVER (ORDER BY enabled DESC) AS vendor_enabled_row_desc
	FROM 
		(
		SELECT vendor.vendor_id, vendor.site_id, vendor.vendor_name, vendor.[rank] AS vendor_rank
			, vendor.has_image, vendor.enabled, vendor.modified, vendor.created, vendor.parent_vendor_id
			, vendor.vendor_keywords, internal_name, [description],  product.product_id, product.[rank] AS product_rank
			, (SELECT COUNT(product_id) 
			FROM product_to_vendor pv
			WHERE pv.vendor_id = vendor.vendor_id) AS product_total
			, (SELECT COUNT (DISTINCT p.product_id)
				FROM product p
				INNER JOIN product_to_category pc
					ON pc.product_id = p.product_id
				INNER JOIN category c
					ON c.category_id = pc.category_id
				INNER JOIN product_to_vendor pv
					ON pv.product_id = p.product_id
				WHERE pv.vendor_id = vendor.vendor_id
				AND p.enabled = '1' 
				AND pv.enabled = '1'
				AND pc.enabled = '1'
				AND c.enabled = '1'
				AND vendor.enabled = '1'
				AND c.site_id = @siteId
				) AS product_live_total
		FROM vendor 
			LEFT JOIN product_to_vendor
				ON vendor.vendor_id = product_to_vendor.vendor_id
			LEFT JOIN product
				ON product_to_vendor.product_id = product.product_id
		WHERE vendor.site_id = @siteId
			AND (@search IS NULL OR vendor.vendor_name like '%' + @search + '%')
		) AS temp_table

		PIVOT
		(
			COUNT(product_id)
			FOR product_rank IN
			([1], [2], [3])
			
		)AS pvt

	INSERT INTO #temp_sorted_vendor (vendor_id, site_id, vendor_name, vendor_rank, has_image, enabled
		, modified, created, parent_vendor_id, vendor_keywords, internal_name, [description], row)
	SELECT vendor_id, site_id, vendor_name, vendor_rank , has_image, enabled
		, modified, created, parent_vendor_id, vendor_keywords, internal_name, [description]
		, CASE 
			WHEN @sortBy = '' AND @sortOrder = '' THEN vendor_name_row_asc
			WHEN @sortBy = 'Id' AND @sortOrder = 'asc' THEN vendor_id_row_asc
			WHEN @sortBy = 'Id' AND @sortOrder = 'desc' THEN vendor_id_row_desc
			WHEN @sortBy = 'Name'AND @sortOrder = 'asc' THEN vendor_name_row_asc
			WHEN @sortBy = 'Name'AND @sortOrder = 'desc' THEN vendor_name_row_desc
			WHEN @sortBy = 'Rank' AND @sortOrder = 'asc' THEN vendor_rank_row_asc
			WHEN @sortBy = 'Rank' AND @sortOrder = 'desc' THEN vendor_rank_row_desc
			WHEN @sortBy = 'F' AND @sortOrder = 'asc' THEN product_featured_row_asc
			WHEN @sortBy = 'F' AND @sortOrder = 'desc' THEN product_featured_row_desc
			WHEN @sortBy = 'S' AND @sortOrder = 'asc' THEN product_standard_row_asc
			WHEN @sortBy = 'S' AND @sortOrder = 'desc' THEN product_standard_row_desc
			WHEN @sortBy = 'M' AND @sortOrder = 'asc' THEN product_minimized_row_asc
			WHEN @sortBy = 'M' AND @sortOrder = 'desc' THEN product_minimized_row_desc
			WHEN @sortBy = 'T' AND @sortOrder = 'asc' THEN product_total_row_asc
			WHEN @sortBy = 'T' AND @sortOrder = 'desc' THEN product_total_row_desc
			WHEN @sortBy = 'TLP' AND @sortOrder = 'asc' THEN product_live_total_row_asc
			WHEN @sortBy = 'TLP' AND @sortOrder = 'desc' THEN product_live_total_row_desc
			WHEN @sortBy = 'Enabled' AND @sortOrder = 'asc' THEN vendor_enabled_row_asc
			WHEN @sortBy = 'Enabled' AND @sortOrder = 'desc' THEN vendor_enabled_row_desc
		END AS row
	FROM #temp_vendor

	SELECT @numberOfRows = COUNT(*) 
	FROM #temp_sorted_vendor

	SELECT vendor_id AS id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled
		, modified, created, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM #temp_sorted_vendor
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
 
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorBySiteIdSortedPageList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorsBySiteIdSearchList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorsBySiteIdSearchList
	@siteId int,
	@search varchar(255),
	@numberOfItems int 
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT TOP (@numberOfItems) ven.vendor_id as id, site_id, ven.vendor_name, ven.rank, ven.has_image
			, ven.[enabled], ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name, ven.[description]
	FROM vendor ven
	WHERE ven.site_id = @siteId AND ven.vendor_name LIKE '%' + @search + '%'

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorsBySiteIdSearchList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetChildVendorsByParentVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetChildVendorsByParentVendor
	@siteId int,
	@parentVendorId int
AS
-- ==========================================================================
-- $Author:  Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT vendor_id AS id, site_id AS site_id, vendor_name, rank, has_image, [enabled], modified,
		   created, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM vendor
	WHERE site_id = @siteId AND  parent_vendor_id = @parentVendorId
	
END
GO

GRANT EXECUTE ON dbo.adminVendor_GetChildVendorsByParentVendor TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorDetailByVendorIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorDetailByVendorIds
	@vendorIds varchar(max)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ven.vendor_id as id, site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified,ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name, ven.[description]
	FROM vendor ven
	WHERE ven.vendor_id IN (SELECT [value] FROM Global_Split(@vendorIds, ','))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetVendorDetailByVendorIds TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorsByProductIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorsByProductIds	
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author : Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ven.vendor_id as id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified,ven.created, ven.parent_vendor_id, ven.vendor_keywords, product_id, ven.internal_name, ven.[description]
	FROM vendor ven
		INNER JOIN product_to_vendor
			ON ven.vendor_id = product_to_vendor.vendor_id
	WHERE (product_to_vendor.product_id IN 
		(SELECT [value] FROM dbo.global_Split(@productIds, ','))) AND (ven.[enabled] = 1)

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorsByProductIds TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetParentVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetParentVendorByCategoryIdList
	@categoryId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT vendor_id AS id, site_id, vendor_name, rank, has_image, [enabled], modified, created
		, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM vendor
		INNER JOIN	
		(
			SELECT DISTINCT ISNULL(v.parent_vendor_id, v.vendor_id) AS vid
			FROM vendor v
				INNER JOIN product_to_vendor ptv
					ON v.vendor_id = ptv.vendor_id
				INNER JOIN product p
					ON p.product_id = ptv.product_id
				INNER JOIN product_to_category ptc
					ON p.product_id = ptc.product_id
			WHERE ptc.category_id  = @categoryId
			AND	(
					(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
					(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
				)
			AND p.enabled = 1
			AND v.enabled = 1
			AND ptv.enabled = 1
			AND ptc.enabled = 1
			AND ptv.is_manufacturer = 1
		) cv
			ON vendor.vendor_id = cv.vid

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetParentVendorByCategoryIdList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetOfficeSetupVendorsByActionId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetOfficeSetupVendorsByActionId
	@actionId int,
	@siteId int
AS
-- ==========================================================================
-- Author : Dimuthu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ven.vendor_id as id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name, ven.[description]
	FROM vendor ven
		INNER JOIN vendor_office_setup vos
			ON ven.vendor_id = vos.vendor_id AND
			ven.site_id = vos.site_id AND
			vos.action_id = @actionId 
	WHERE ven.site_id = @siteId AND
		ven.enabled = 1

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetOfficeSetupVendorsByActionId TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList
	@siteId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@startIndex int,
	@endIndex int,
	@search varchar(50) = NULL,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #temp_vendor (vendor_id int, site_id int, vendor_name varchar(100), vendor_rank int
	, has_image bit, enabled bit, modified smalldatetime, created smalldatetime, parent_vendor_id int
	, vendor_keywords varchar(MAX), internal_name varchar(255), [description] varchar(MAX), row int)

	DECLARE @query nvarchar(max)

	SET @query ='INSERT INTO #temp_vendor (vendor_id, site_id, vendor_name, vendor_rank, has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name, [description],
		, created, row)
		SELECT vendor_id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name, [description],
		, created'
		
	IF(@sortBy = ' ')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_id ' + @sortOrder + ' ) AS row'
	IF(@sortBy = 'id')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_id ' + @sortOrder + ' ) AS row'
	ELSE IF(@sortBy = 'Name')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_name ' + @sortOrder + ' ) AS row'
	
	SET @query = @query + ' FROM 
		(
		SELECT vendor.vendor_id, vendor.site_id, vendor.vendor_name, vendor.[rank] AS vendor_rank
			, vendor.has_image, vendor.enabled, vendor.modified, vendor.created, vendor.parent_vendor_id
			, vendor.vendor_keywords, internal_name, [description]
		FROM vendor WHERE '
	
	SET @query = @query + ' vendor.site_id =' + CAST(@siteId AS varchar(10))
	
	IF (@search IS NOT NULL) 
		SET @query = @query + ' AND  (vendor.vendor_name like ''%' + @search + '%'')'
	
	
	SET @query = @query + ' ) AS temp_table'

	
	EXECUTE sp_executesql @query

	SELECT @numberOfRows = COUNT(*) 
	FROM #temp_vendor

	SELECT vendor_id AS id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled
		, modified, created, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM #temp_vendor
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
 
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorByCategoryIdList
	@id int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT ven.vendor_id AS id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled], 
			ven.modified, ven.created, ven.parent_vendor_id, ven.vendor_keywords, ven.internal_name, ven.[description]
	FROM product_to_category catPro
		INNER JOIN product_to_vendor proVen
			ON catPro.product_id = proVen.product_id
		INNER JOIN vendor ven
			ON proVen.vendor_id = ven.vendor_id
	WHERE catPro.category_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorByCategoryIdList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetCategoryVendorsByCategoryIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetCategoryVendorsByCategoryIds	
	@categoryIds varchar(max)
AS
-- ==========================================================================
-- $Author : Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ven.vendor_id as id, ven.site_id, ven.vendor_name, ven.rank, ven.has_image, ven.[enabled]
			, ven.modified,ven.created, ven.parent_vendor_id, ven.vendor_keywords, cat_ven.category_id, ven.internal_name, ven.[description]
	FROM vendor ven
		INNER JOIN category_to_vendor cat_ven
			ON cat_ven.vendor_id = ven.vendor_id	
	WHERE (cat_ven.category_id IN (SELECT [value] FROM dbo.global_Split(@categoryIds, ','))) 
		AND (ven.[enabled] = 1)
END
GO

GRANT EXECUTE ON dbo.adminCategory_GetCategoryVendorsByCategoryIds TO VpWebApp 
GO

