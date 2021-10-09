
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetProductFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetProductFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN product p ON fu.content_id = p.product_id AND p.enabled = 1 AND p.hidden=0
				AND p.site_id = @siteId AND fu.content_type_id = 2 
		WHERE fu.site_id = @siteId AND fu.enabled = 1 
	)


	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetProductFixedUrlBySiteIdPagingList TO VpWebApp 
GO
-------------------------------------------------------
