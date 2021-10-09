EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNewSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNewSpecificationList
	@specTypeIds VARCHAR(100),
	@timeStamp SMALLDATETIME,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- Author : Chinthaka Fernando
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT content_id
	INTO #ContentIds
	FROM (
		SELECT DISTINCT content_id, DENSE_RANK() OVER (ORDER BY [content_id] ASC) AS row
		FROM specification
		INNER JOIN dbo.global_Split(@specTypeIds, ',') gs
			ON specification.spec_type_id = gs.[value]
		WHERE content_type_id = 2 
			AND [enabled] = 1
			AND modified >= @timeStamp
	) specification
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

	SELECT [specification_id] AS id
		,s.[content_id]
		,[spec_type_id]
		,[specification]
		,[enabled]
		,[modified]
		,[created]
		,[content_type_id]
		,[display_options]
		,[sort_order]
	FROM specification s
	INNER JOIN #ContentIds cids
		ON s.content_id = cids.content_id
	INNER JOIN dbo.global_Split(@specTypeIds, ',') gs
		ON s.spec_type_id = gs.[value]
	WHERE content_type_id = 2 
	ORDER BY s.content_id
		
	DROP TABLE #ContentIds

	SELECT @totalCount = COUNT(DISTINCT content_id) 
	FROM specification
	INNER JOIN dbo.global_Split(@specTypeIds, ',') gs
			ON specification.spec_type_id = gs.[value]
	WHERE content_type_id = 2 
		AND [enabled] = 1
		AND modified >= @timeStamp
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebApp
GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebAPI
GO

