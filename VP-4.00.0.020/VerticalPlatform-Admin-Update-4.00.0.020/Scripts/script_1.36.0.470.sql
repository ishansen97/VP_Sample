
EXEC dbo.global_DropStoredProcedure 'dbo.adminContentRating_DeleteContentRatingsWithoutContentIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminContentRating_DeleteContentRatingsWithoutContentIds
	@contentTypeId int,
	@contentIds varchar(max),
	@siteId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE FROM content_rating
	WHERE content_type_id = @contentTypeId AND (@siteId IS NULL OR @siteId = site_id) AND 
		content_id NOT IN
		(
			SELECT [value]
			FROM global_split(@contentIds, ',')
		)

END
GO

GRANT EXECUTE ON dbo.adminContentRating_DeleteContentRatingsWithoutContentIds TO VpWebApp 
GO
