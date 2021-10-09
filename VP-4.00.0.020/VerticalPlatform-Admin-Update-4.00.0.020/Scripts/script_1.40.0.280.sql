EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteSearchContentStatusesBatchWise'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteSearchContentStatusesBatchWise
	@siteId int,
	@batchSize int,
	@contentTypeId int,
	@remainingCount int output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE TOP(@batchSize) 
	FROM search_content_status
	WHERE site_id = @siteId
		AND content_type_id = @contentTypeId

	SELECT @remainingCount = COUNT(*)
	FROM search_content_status
	WHERE site_id = @siteId
		AND content_type_id = @contentTypeId
	
END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteSearchContentStatusesBatchWise TO VpWebApp 
GO