EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RemoveFutureDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RemoveFutureDisplayStatuses
    @fileName varchar(max),
	@vendorId int
	
AS
-- ==========================================================================
-- Akila
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	DELETE FROM product_display_status
	WHERE product_display_status_id IN
	(
		SELECT pds.product_display_status_id
		FROM  product_display_status pds
		INNER JOIN [sponsored_product_bulk_update] spbu 
			ON pds.product_id = spbu.product_id
			INNER JOIN dbo.product_to_vendor ptv
		ON pds.product_id = ptv.product_id
		WHERE pds.start_date > CONVERT(DATE, spbu.end_date)
			AND spbu.enabled = 1
			AND spbu.source_file_name = @fileName AND ptv.vendor_id = @vendorId
	)
END
GO

GRANT EXECUTE ON dbo.adminProduct_RemoveFutureDisplayStatuses TO VpWebApp
GO

--------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateConflictingDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_UpdateConflictingDisplayStatuses
    @fileName varchar(max),
	@vendorId int
	
AS
-- ==========================================================================
-- Akila
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	UPDATE product_display_status 
	SET end_date = GETDATE()
	FROM [sponsored_product_bulk_update] spbu 
	INNER JOIN product_display_status pds
		ON pds.product_id = spbu.product_id
		INNER JOIN dbo.product_to_vendor ptv
		ON pds.product_id = ptv.product_id
	WHERE source_file_name = @fileName
		AND (spbu.start_date >= CONVERT(DATE, pds.start_date)) 
		AND (spbu.start_date <= CONVERT(DATE, pds.end_date))
		AND spbu.enabled = 1 AND ptv.vendor_id = @vendorId
		
END
GO

GRANT EXECUTE ON dbo.AdminProduct_UpdateConflictingDisplayStatuses TO VpWebApp
GO

-------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_InsertDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_InsertDisplayStatuses
    @fileName varchar(max),
	@vendorId int
	
AS
-- ==========================================================================
-- Akila
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	INSERT INTO [product_display_status]([product_id]
      ,[start_date]
      ,[end_date]
      ,[new_rank]
      ,[enabled]
      ,[modified]
      ,[created]
      ,[search_rank]
      ,[include])
	SELECT spbu.product_id, spbu.start_date, spbu.end_date, spbu.featured_status, 1, GETDATE(), GETDATE(), spbu.search_rank, 0
	FROM [sponsored_product_bulk_update] spbu
	INNER JOIN product p
		ON spbu.product_id = p.product_id
		INNER JOIN dbo.product_to_vendor ptv
		ON spbu.product_id = ptv.product_id
	WHERE source_file_name = @fileName AND ptv.vendor_id = @vendorId
END
GO

GRANT EXECUTE ON dbo.AdminProduct_InsertDisplayStatuses TO VpWebApp
GO


-----------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion
    @fileName varchar(max),
	@vendorId int
	
AS
-- ==========================================================================
-- Akila
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	UPDATE [sponsored_product_bulk_update]
		SET process_status =

		CASE 
		WHEN (spbu.featured_status = p.rank) THEN ISNULL(process_status, '') + ' Same Featured Status.'
		WHEN (spbu.featured_status > p.rank) THEN ISNULL(process_status, '') + ' Featured Status Promoted.'
		WHEN (spbu.featured_status < p.rank) THEN ISNULL(process_status, '') + ' Featured Status Demoted.'
		END
	FROM [sponsored_product_bulk_update] spbu
	INNER JOIN product p
	  ON p.product_id = spbu.product_id
	  INNER JOIN dbo.product_to_vendor ptv
		ON spbu.product_id = ptv.product_id
	  WHERE spbu.source_file_name = @fileName AND ptv.vendor_id = @vendorId	 
	  
	UPDATE [sponsored_product_bulk_update]
		SET process_status = ISNULL(process_status, '') + ' Disabled.'
	FROM [sponsored_product_bulk_update] spbu
	INNER JOIN product p
	  ON p.product_id = spbu.product_id
	  INNER JOIN dbo.product_to_vendor ptv
		ON spbu.product_id = ptv.product_id
	  WHERE spbu.source_file_name = @fileName and p.enabled = 0	 AND ptv.vendor_id = @vendorId
END
GO

GRANT EXECUTE ON dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion TO VpWebApp
GO

--------------------------------




