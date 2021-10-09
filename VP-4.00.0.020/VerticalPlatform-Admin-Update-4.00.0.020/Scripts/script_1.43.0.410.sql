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
	
	SELECT Id as id, [source_file_name],[product_id],[catalog_number],[featured_status] ,[search_rank],[start_date],[end_date],[vendorId],enabled, created, modified, [process_status]
	FROM sponsored_product_bulk_update 
	WHERE source_file_name = @fileName
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetSponsoredProductListForFile TO VpWebApp
GO


-----------------------------

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
	
	SELECT Id as id, [source_file_name],[product_id],[catalog_number],[featured_status] ,[search_rank],[start_date],[end_date],[vendorId],enabled, created, modified, [process_status]
	FROM sponsored_product_bulk_update 
	WHERE source_file_name = @fileName
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetSponsoredProductListForFile TO VpWebApp
GO

-----------------------------------

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
	  WHERE spbu.source_file_name = @fileName 	 
	  
	UPDATE [sponsored_product_bulk_update]
		SET process_status = ISNULL(process_status, '') + ' Disabled.'
	FROM [sponsored_product_bulk_update] spbu
	INNER JOIN product p
	  ON p.product_id = spbu.product_id
	  WHERE spbu.source_file_name = @fileName and p.enabled = 0	
END
GO

GRANT EXECUTE ON dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion TO VpWebApp
GO

--------------------------------

