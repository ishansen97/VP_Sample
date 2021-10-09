EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteGuidedBrowseSearchGroupsBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteGuidedBrowseSearchGroupsBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM guided_browse_to_search_group
	WHERE guided_browse_id IN
	(
		SELECT guided_browse_id
		FROM guided_browse
			INNER JOIN category
				ON category.category_id = guided_browse.category_id
		WHERE category.site_id = @siteId
			UNION
		SELECT fixed_guided_browse_id
		FROM fixed_guided_browse
			INNER JOIN category
				ON category.category_id = fixed_guided_browse.category_id
		WHERE category.site_id = @siteId
	)

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteGuidedBrowseSearchGroupsBySiteIdList TO VpWebApp 
GO