
--==== publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList
	@groupId int,
	@searchText varchar(500),
	@startIndex int,
	@endIndex int,
	@optionId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 
		ROW_NUMBER() OVER (ORDER BY search_group_id,sort_order,search_option_id) AS row, 
		search_option_id, 
		search_group_id, 
		[name], 
		sort_order, 
		created, 
		enabled, 
		modified
	into #temp_search_option
	FROM search_option
	WHERE (@groupId = 0 OR search_group_id = @groupId)
	AND [name] LIKE ('%' +@searchText + '%') 
	AND (@optionId = 0 OR search_option_id = @optionId)

	SELECT	search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM #temp_search_option
	WHERE (row BETWEEN @startIndex AND @endIndex)
	ORDER BY row

	SELECT @totalCount = COUNT(*)
	FROM #temp_search_option

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList TO VpWebApp 
GO

