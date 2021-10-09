EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetSiteListSorted'

-- ================================publicPlatform_GetSiteListSorted===========
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetSiteListSorted
AS
-- ==========================================================================
-- $Author: Madushan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT site_id AS id, site_name, homepage_id, theme_name, media_url, code, header_image, site_type_id
		, [enabled], modified, created, is_https
	FROM [site]
	ORDER BY site_name

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetSiteListSorted TO VpWebApp 
GO

-- ==========================================================================
