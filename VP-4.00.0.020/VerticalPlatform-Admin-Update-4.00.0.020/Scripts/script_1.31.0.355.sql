
EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_DeleteContentMetadataPageBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_DeleteContentMetadataPageBySiteId
	@siteId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
		
		DELETE FROM content_metadata_to_page
		WHERE content_metadata_id IN
		(
			SELECT content_metadata_id
			FROM content_metadata
			WHERE site_id = @siteId
		)
	
END
GO

GRANT EXECUTE ON dbo.adminPage_DeleteContentMetadataPageBySiteId TO VpWebApp 
GO

---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_DeleteContentMetadataPageBySiteIdPageIdContentMetadataId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPage_DeleteContentMetadataPageBySiteIdPageIdContentMetadataId
	@siteId int,
	@pageId int,
	@contentMetadataId int


AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
		
		IF @siteId IS NOT NULL
		DELETE FROM content_metadata_to_page
		WHERE content_metadata_id IN
		(
			SELECT content_metadata_id
			FROM content_metadata
			WHERE site_id = @siteId
		)
		ELSE IF @pageId IS NOT NULL
		DELETE FROM content_metadata_to_page
		WHERE page_id in
		( 
			SELECT page_id
			FROM page
			WHERE page_id = @pageId
		) 
		ELSE IF @contentMetadataId IS NOT NULL
		DELETE FROM content_metadata_to_page
		WHERE content_metadata_id IN
		(
			SELECT content_metadata_id
			FROM content_metadata
			WHERE content_metadata_id = @contentMetadataId
		)

	
END
GO

GRANT EXECUTE ON dbo.adminPage_DeleteContentMetadataPageBySiteIdPageIdContentMetadataId TO VpWebApp 
GO

--------------------------------------------------------------------------------
