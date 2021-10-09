IF EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'new_rank' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product_display_status') AND type in (N'U'))
)
BEGIN
	  ALTER TABLE product_display_status
	  ALTER COLUMN new_rank INTEGER  NULL
END
GO

-----------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	UPDATE p
		SET p.rank = p.default_rank,
			p.search_rank = p.default_search_rank
	FROM product p
	WHERE p.product_id IN
	(
		SELECT top 100 pro.product_id FROM product pro
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
-----------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	SELECT count(pro.product_id) FROM product pro
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
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId TO VpWebApp 
GO
--------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateDisplayStatusProductsBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

		UPDATE p
		SET p.rank = CASE WHEN product_display.new_rank IS NULL THEN p.default_rank ELSE product_display.new_rank END,
			p.search_rank = CASE WHEN product_display.search_rank <= 0 THEN p.default_search_rank ELSE product_display.search_rank END
	
	FROM 
		(
		SELECT top 100 p.product_id, pds.new_rank, pds.search_rank
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
-----------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductDisplayStatusByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductDisplayStatusByProductId
	@productId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DELETE FROM product_display_status
	WHERE product_id = @productId

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductDisplayStatusByProductId TO VpWebApp 
GO
--------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetDisplayStatusProductCountBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetDisplayStatusProductCountBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	SELECT COUNT(*)
	FROM [product_display_status] pds
		INNER JOIN product p
			on p.product_id = pds.product_id
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
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetDisplayStatusProductCountBySiteId TO VpWebApp 
GO