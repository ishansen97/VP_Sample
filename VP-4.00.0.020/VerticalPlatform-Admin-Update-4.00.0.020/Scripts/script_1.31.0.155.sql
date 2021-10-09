EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList
	@categoryId int,
	@primaryOptions varchar(max),
	@secondaryOptions varchar(max),
	@considerShowInMatrixSetting bit
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	-- Populate primary search option ids
	CREATE TABLE #PrimarySearchOption (search_option_id int)
	INSERT INTO #PrimarySearchOption
	SELECT [VALUE] FROM global_split(@primaryOptions, ',')

	-- Populate secondary search option ids
	CREATE TABLE #SecondarySearchOption (search_option_id int)
	INSERT INTO #SecondarySearchOption
	SELECT [VALUE] FROM global_split(@secondaryOptions, ',')

	-- Find number of rows in secondary option ids
	DECLARE @secondarySearchOptionCount int
	SELECT @secondarySearchOptionCount = COUNT(*) FROM #SecondarySearchOption

	-- Find products having at least one primary option and all secondary options
	CREATE TABLE #FilteredProduct (product_id int)
	INSERT INTO #FilteredProduct
	SELECT ps.product_id
	FROM product_to_search_option ps
		INNER JOIN product_to_category pc
			ON ps.product_id = pc.product_id AND pc.category_id = @categoryId AND pc.enabled = 1
		INNER JOIN product p
			ON p.product_id = ps.product_id AND p.enabled = 1 AND (@considerShowInMatrixSetting = 0 OR p.show_in_matrix = 1)
	WHERE ps.product_id IN 
	(
		SELECT product_id
		FROM product_to_search_option so
			INNER JOIN #PrimarySearchOption
				ON so.search_option_id = #PrimarySearchOption.search_option_id
	)
	AND ps.search_option_id IN
	(
		SELECT search_option_id
		FROM #SecondarySearchOption
	)
	GROUP BY ps.product_id
	HAVING COUNT(ps.search_option_id) = @secondarySearchOptionCount

	-- Select search options in primary option list having products in filtered products list
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id
		FROM product_to_search_option ps
			INNER JOIN #FilteredProduct
				ON ps.product_id = #FilteredProduct.product_id
		WHERE search_option_id IN
		(
			SELECT search_option_id
			FROM #PrimarySearchOption
		)
	)
	ORDER BY [name]

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList TO VpWebApp 
GO
-----------------------------------------------------------------------------------


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
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex

	SELECT @numberOfRows = COUNT(*)
	FROM
	(
		SELECT [tag]
		FROM tag
			INNER JOIN content_tag
				ON tag.content_tag_id = content_tag.content_tag_id
		WHERE content_tag.site_id = @siteId
		GROUP BY [tag]
	) AS a;
	
	With temp_tag(row_id, id, content_tag_id, tag, [user_id], is_public_user, [enabled], modified, created) AS
	(		
		SELECT ROW_NUMBER() OVER (ORDER BY tag ASC) AS row_id, id, content_tag_id, tag, [user_id], 
			is_public_user, [enabled], modified, created
		FROM
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY tag ORDER BY tag ASC) AS row, tag_id AS id, tag.content_tag_id,
				 tag, [user_id], is_public_user, tag.enabled, tag.modified, tag.created
					FROM tag
						INNER JOIN content_tag
							ON tag.content_tag_id = content_tag.content_tag_id
					WHERE content_tag.site_id = @siteId 
		) AS t
		WHERE  t.row = 1
	)
	
	SELECT id, content_tag_id, tag, [user_id], is_public_user, [enabled], modified, created
	FROM temp_tag
	WHERE row_id BETWEEN @startIndex AND @endIndex
	
END
GO

GRANT EXECUTE ON adminTag_GetTagsBySiteIdWithPaging TO VpWebApp 
GO
--------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminTag_GetDistinctTagBySiteIdLikeTagNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminTag_GetDistinctTagBySiteIdLikeTagNameList
	@siteId int,
	@term varchar(255),
	@selectLimit int
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@selectLimit) id, content_tag_id, tag, [user_id], is_public_user, [enabled], modified, created
		FROM
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY tag ORDER BY tag ASC) AS row, tag_id AS id, tag.content_tag_id,
				 tag, [user_id], is_public_user, tag.enabled, tag.modified, tag.created
					FROM tag
						INNER JOIN content_tag
							ON tag.content_tag_id = content_tag.content_tag_id
					WHERE content_tag.site_id = @siteId AND tag.tag LIKE @term + '%'
		) AS t
	WHERE  t.row = 1

END
GO

GRANT EXECUTE ON dbo.adminTag_GetDistinctTagBySiteIdLikeTagNameList TO VpWebApp 
GO
------------------------------------------------------------------------