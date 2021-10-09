--adminProduct_UpdateProductContentModifiedStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductContentModifiedStatus
	@productList VARCHAR(max),
	@contentModofied BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE p
	SET   p.content_modified = @contentModofied,
		p.search_content_modified = CASE WHEN @contentModofied = 1 THEN  1 ELSE p.search_content_modified END,
		p.modified = GETDATE()
	FROM [product] p
		INNER JOIN dbo.global_Split(@productList, ',') gs
		ON p.product_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductContentModifiedStatus TO VpWebApp 
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductContentModifiedStatus TO VpAPIUser 
GO

-------default values updates to site paramters--------
DECLARE @SiteId INT
DECLARE @checkParam INT
DECLARE @checkParam2 INT

select distinct([site_id]) into #tempSiteId
FROM [dbo].[site_parameter]
order by [site_id]

WHILE(1 = 1)
BEGIN

    SET @SiteId = NULL
    SELECT TOP(1) @SiteId = [site_id]
    FROM #tempSiteId

    IF @SiteId IS NULL
        BREAK

	SET @checkParam = null
	SELECT @checkParam = [site_parameter_id] FROM [dbo].[site_parameter]  where [parameter_type_id] = 213 and [site_id] = @SiteId
	IF @checkParam IS NULL
    BEGIN
		insert into [dbo].[site_parameter]
		values(@SiteId, 213, 5, 1, GETDATE(), GETDATE())
	END

	SET @checkParam2 = null
	SELECT @checkParam2 = [site_parameter_id] FROM [dbo].[site_parameter]  where [parameter_type_id] = 214 and [site_id] = @SiteId
	IF @checkParam2 IS NULL
    BEGIN
		insert into [dbo].[site_parameter]
		values(@SiteId, 214, 15, 1, GETDATE(), GETDATE())
	END
	
    DELETE TOP(1) FROM #tempSiteId

END

drop table #tempSiteId

GO
---------end of updates to site paramters -------------


-- publicSearchCategory_GetSearchOptionsByGroupIdOptionIdNameWithPagingList

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
		ROW_NUMBER() OVER (ORDER BY sort_order,search_option_id) AS row, 
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


