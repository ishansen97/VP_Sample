
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdListWithPaging
	@siteId int,
	@vendorId INT,
	@pageSize int,
	@pageIndex INT,
	@enabled INT,
	@rank INT
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	SELECT id, site_id, parent_product_id, product_name, rank
		, has_image, catalog_number, [enabled], modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM (
		SELECT ROW_NUMBER() OVER (ORDER BY p.product_id DESC) AS row_id, p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
				, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
				, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified
				, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
		FROM product p
				INNER JOIN product_to_vendor pv
					ON pv.product_id = p.product_id
		WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId AND (@enabled IS NULL OR p.enabled = @enabled) AND (@rank IS NULL OR p.[rank] = @rank)
	)products
	WHERE row_id BETWEEN @startIndex AND @endIndex
	ORDER BY row_id
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdListWithSorting TO VpWebApp
GO
