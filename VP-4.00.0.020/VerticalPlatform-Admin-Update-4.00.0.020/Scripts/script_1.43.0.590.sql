EXEC dbo.global_DropStoredProcedure 'dbo.adminField_GetFieldByNameSiteIdFieldType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminField_GetFieldByNameSiteIdFieldType
	@fieldName VARCHAR(MAX),
	@siteId INT,
	@fieldTypeId INT
	
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT field_id AS id, site_id, content_type_id, content_id, action_id
		, field_content_type_id, field_type_id,	predefined_field_id, field_text
		, field_text_abbreviation, field_description, enabled, modified, created
	FROM field
	WHERE LTRIM(RTRIM(field_text)) = @fieldName AND site_id = @siteId AND field_type_id = @fieldTypeId

END
GO

GRANT EXECUTE ON dbo.adminField_GetFieldByNameSiteIdFieldType TO VpWebApp 
GO