EXEC dbo.global_DropStoredProcedure 'adminPlatform_AddContentToContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminPlatform_AddContentToContent
	@contentId int,
	@contentTypeId int,
	@associatedContentId int,
	@associatedContentTypeId int,
	@siteId int,
	@associatedSiteId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@sortOrder int
AS
-- ==========================================================================
-- $Date: 2013-08-07
-- $Author: Eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	
	--get last sort order if new content to content mappong added
	IF @sortOrder = -1
	BEGIN
		SELECT @sortOrder = (ISNULL(MAX(sort_order),0)+1)
		FROM content_to_content 
		WHERE content_id = @contentId 
		AND content_type_id = @contentTypeId
		AND associated_content_type_id = @associatedContentTypeId
	END

	
	INSERT INTO content_to_content
		(content_id, content_type_id, associated_content_id, associated_content_type_id, site_id, associated_site_id
		, [enabled], modified, created, sort_order)
	Values
		(@contentId, @contentTypeId, @associatedContentId, @associatedContentTypeId, @siteId, @associatedSiteId
		, @enabled, @created, @created, @sortOrder)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON adminPlatform_AddContentToContent TO VpWebApp 
GO