EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidJobQueueActionList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidJobQueueActionList
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT rjq.action 
	FROM RapidJobQueue rjq

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidJobQueueActionList TO VpWebApp 
GO
-------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidJobQueues'
-------------------------------------------------------------------------------------
GRANT SELECT ON dbo.RapidJobQueue TO VpWebApp
-------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNewSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNewSpecificationList
	@specTypeId INT,
	@timeStamp SMALLDATETIME,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT * FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY [modified], [content_id] ASC) AS row,
			[specification_id] AS id
			,[content_id]
			,[spec_type_id]
			,[specification]
			,[enabled]
			,[modified]
			,[created]
			,[content_type_id]
			,[display_options]
			,[sort_order]
		FROM specification
		WHERE content_type_id = 2 
			AND [enabled] = 1
			AND spec_type_id = @specTypeId
			AND modified >= @timeStamp
	) specification
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

	SELECT @totalCount = COUNT(*) 
	FROM specification
	WHERE content_type_id = 2 
		AND [enabled] = 1
		AND spec_type_id = @specTypeId
		AND modified >= @timeStamp
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebApp
GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebAPI
GO
