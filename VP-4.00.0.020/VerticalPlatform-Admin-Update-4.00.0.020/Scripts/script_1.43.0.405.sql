EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetSponsoredProductListForFile'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetSponsoredProductListForFile
    @fileName varchar(max)
	
AS
-- ==========================================================================
-- Akila
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	SELECT Id as id, [source_file_name],[product_id],[catalog_number],[featured_status] ,[search_rank],[start_date],[end_date],[vendorId],enabled, created, modified
	FROM sponsored_product_bulk_update 
	WHERE source_file_name = @fileName
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetSponsoredProductListForFile TO VpWebApp
GO

--------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_CloseProductDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_CloseProductDisplayStatuses
	@vendorId int
	
AS
-- ==========================================================================
-- Sahah Diasena
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	UPDATE pds
	SET pds.end_date = GETDATE()
	FROM dbo.product_display_status pds
	INNER JOIN dbo.product_to_vendor ptv
		ON pds.product_id = ptv.product_id
	WHERE pds.end_date > GETDATE()
		AND ptv.vendor_id = @vendorId
	
END
GO

GRANT EXECUTE ON dbo.AdminProduct_CloseProductDisplayStatuses TO VpWebApp
GO