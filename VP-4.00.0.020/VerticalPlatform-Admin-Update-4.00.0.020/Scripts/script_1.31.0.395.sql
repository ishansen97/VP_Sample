EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	UPDATE p
		SET p.rank = p.default_rank,
			p.search_rank = p.default_search_rank,
			p.search_content_modified = 1,
			p.modified = GETDATE()
	FROM product p
	WHERE p.product_id IN
	(
		SELECT top (@batchSize) pro.product_id FROM product pro
			INNER JOIN [product_display_status] pds
				ON pro.product_id = pds.product_id
		WHERE pro.site_id = @siteId
			AND NOT(pds.start_date <= @today AND @today <= pds.end_date)
			AND 
			(pro.rank <> pro.default_rank OR pro.search_rank <> pro.default_search_rank)
			AND pro.product_id NOT IN 
			(
				SELECT p.product_id
				FROM [product_display_status] pds
					INNER JOIN product p
						ON p.product_id = pds.product_id
				WHERE p.site_id = @siteId
					AND 
					(
						pds.start_date <= @today AND @today <= pds.end_date
					)
					AND
					(
						(pds.new_rank IS NULL OR p.rank <> pds.new_rank) OR
						(pds.search_rank IS NULL OR p.search_rank <> pds.search_rank)
					)
			)
	)

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId TO VpWebApp 
GO
-------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	UPDATE p
	SET p.[rank] = CASE WHEN product_display.new_rank IS NULL THEN p.default_rank ELSE product_display.new_rank END,
		p.search_rank = CASE WHEN product_display.search_rank <= 0 THEN p.default_search_rank ELSE product_display.search_rank END,
		p.search_content_modified = 1,
		p.modified = GETDATE()
	FROM 
		(
		SELECT top (@batchSize) p.product_id, pds.new_rank, pds.search_rank
		FROM [product_display_status] pds
			INNER JOIN product p
				ON p.product_id = pds.product_id
		WHERE p.site_id = @siteId
			AND 
			(
				pds.start_date <= @today AND @today <= pds.end_date
			)
			AND
			(
				(pds.new_rank IS NULL OR p.rank <> pds.new_rank) OR
				(pds.search_rank IS NULL OR p.search_rank <> pds.search_rank)
			)
	)product_display
	INNER JOIN product p
		ON p.product_id = product_display.product_id


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateDisplayStatusProductsBySiteId TO VpWebApp 
GO

