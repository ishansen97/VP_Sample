EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_ProductCompletenessModified'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_ProductCompletenessModified
	@siteId int,
	@modifiedSince smalldatetime
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT * FROM product_completeness_factor WHERE content_type_id = 5 AND content_id = @siteId AND modified > @modifiedSince
	)
		SELECT CAST(1 AS bit) AS modified
	ELSE IF EXISTS (
		SELECT * FROM product_completeness_factor WHERE content_type_id = 1 AND content_id IN (SELECT category_id FROM category WHERE site_id = @siteId) AND modified > @modifiedSince
	)
		SELECT CAST(1 AS bit) AS modified
	ELSE
		SELECT CAST(0 AS bit) AS modified
END
GO

GRANT EXECUTE ON dbo.adminSearch_ProductCompletenessModified TO VpWebApp 
GO