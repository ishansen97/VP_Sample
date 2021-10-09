EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteContentToContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteContentToContent
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminPlatform_DeleteContentToContent.sql $
-- $Revision: 6351 $
-- $Date: 2010-08-18 11:12:41 +0530 (Wed, 18 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	--updating search modified flag if article-vendor association remove
	UPDATE art
	SET art.search_content_modified = 1,
		art.modified = GETDATE()
	FROM dbo.article art 
	INNER JOIN dbo.content_to_content con ON con.content_id = art.article_id
	WHERE con.content_to_content_id = @id 
	AND con.associated_content_type_id = 6 
	
	DELETE FROM content_to_content
	WHERE content_to_content_id= @id

END
GO

GRANT EXECUTE ON adminPlatform_DeleteContentToContent TO VpWebApp
GO
