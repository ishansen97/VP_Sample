
---------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetDisabledProductsByBatch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetDisabledProductsByBatch
	@lastRun smalldatetime,
	@startIndex int,
	@endIndex int,
	@siteId int
AS
-- ==========================================================================
-- $Author: Akila$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON; 

	WITH temp_Products (row, id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY product_id) AS row, product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product
		WHERE (@lastRun is null OR modified > @lastRun) AND site_id = @siteId AND (([enabled] = 0) OR (hidden = 1)) AND 
		(
			search_content_modified = 0 OR	
			(search_content_modified = 1 AND product_id NOT IN
				(
					SELECT content_id
					FROM search_content_status
					WHERE content_type_id = 2 AND site_id = @siteId
				)	
			)	
		)
		
	)

	SELECT id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM temp_Products
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetDisabledProductsByBatch TO VpWebApp 
GO


------------------------------------------------------------------------


---------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetDisabledProductsCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetDisabledProductsCount
	@lastRun smalldatetime,
	@startIndex int,
	@endIndex int,
	@siteId int
AS
-- ==========================================================================
-- $Author: Akila$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON; 

	SELECT COUNT(*)
	FROM product
	WHERE (@lastRun is null OR modified > @lastRun) AND site_id = @siteId AND (([enabled] = 0) OR (hidden = 1)) AND 
		(
			search_content_modified = 0 OR	
			(search_content_modified = 1 AND product_id NOT IN
				(
					SELECT content_id
					FROM search_content_status
					WHERE content_type_id = 2 AND site_id = @siteId
				)	
			)	
		)
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetDisabledProductsCount TO VpWebApp 
GO







