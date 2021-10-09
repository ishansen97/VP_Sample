
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductsCountByVendorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC dbo.adminProduct_GetProductsCountByVendorId
(
	@vendorId int,
	@productId int
)
AS
BEGIN
	--==========
	--Roshan
	--==========
	SELECT	COUNT(PV.product_to_vendor_id) as productCount
	FROM	product_to_vendor PV
	WHERE	PV.product_id = @ProductId
			AND
			PV.vendor_id = @VendorId
END
GO
GRANT EXECUTE ON dbo.adminProduct_GetProductsCountByVendorId TO VpWebApp
Go
---------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo    
    @fileName varchar(max),
    @vendorId int 
AS    
-- ==========================================================================    
-- Roshan    
-- ==========================================================================    
BEGIN        
 SET ANSI_WARNINGS OFF;      
       
 SET NOCOUNT ON;        
      
 CREATE TABLE #bulk_update_stats (        
  products_found int,        
  currently_featured int,        
  disabled_products int,        
  internal_duplicates int,        
  external_duplicates int        
 )     
      
 INSERT INTO #bulk_update_stats (products_found, currently_featured, disabled_products)        
 SELECT  SUM(products_found) AS products_found,         
   SUM(currently_featured) AS currently_featured,         
   SUM(disabled_products) AS disabled_products    
 FROM  (        
   SELECT COUNT(p.product_id) as products_found,        
     COALESCE(SUM(CASE WHEN (p.rank > 0 and p.enabled = 1) THEN 1 END),0) AS currently_featured,        
     COALESCE(SUM(CASE WHEN p.enabled = 0 THEN 1 END),0) AS disabled_products        
   FROM dbo.sponsored_product_bulk_update spbu         
     LEFT JOIN dbo.product p         
     ON spbu.product_id = p.product_id    
     INNER JOIN dbo.product_to_vendor ptv    
     ON p.product_id = ptv.product_id     
     AND ptv.vendor_id = spbu.vendorId    
   WHERE spbu.catalog_number IS NULL     
     AND spbu.source_file_name = @fileName    
   UNION        
   SELECT COUNT(p.product_id) AS products_found,        
     COALESCE(SUM(CASE WHEN p.rank > 1 THEN 1 END),0) AS currently_featured,        
     COALESCE(SUM(CASE WHEN p.enabled = 0 THEN 1 END),0) AS disabled_products        
   FROM dbo.sponsored_product_bulk_update spbu        
     LEFT JOIN dbo.product p         
     ON spbu.catalog_number = p.catalog_number    
     INNER JOIN dbo.product_to_vendor ptv    
     ON p.product_id = ptv.product_id     
     AND ptv.vendor_id = spbu.vendorId    
   WHERE spbu.product_id = 0 AND spbu.source_file_name = @fileName        
 ) all_products        
      
 UPDATE  #bulk_update_stats        
 SET  #bulk_update_stats.internal_duplicates = internal_duplicates.internal_duplicates        
 FROM  (        
    SELECT COALESCE(SUM(internal_duplicates),0) AS internal_duplicates        
    FROM (        
      SELECT COUNT(DISTINCT spbu.product_id) AS internal_duplicates        
      FROM dbo.sponsored_product_bulk_update spbu        
      WHERE spbu.catalog_number IS NULL        
        AND spbu.source_file_name = @fileName           
      GROUP BY spbu.product_id        
      HAVING COUNT(spbu.product_id) > 1        
      UNION ALL        
      SELECT COUNT(DISTINCT spbu.catalog_number) AS internal_duplicates        
      FROM dbo.sponsored_product_bulk_update spbu        
      WHERE spbu.product_id = 0     
        AND spbu.source_file_name = @fileName        
      GROUP BY spbu.catalog_number        
      HAVING COUNT(spbu.catalog_number) > 1        
     ) internal_duplicates        
  ) internal_duplicates        
      
 UPDATE		#bulk_update_stats        
 SET		#bulk_update_stats.external_duplicates = external_duplicates.external_duplicates        
 FROM		(    
				SELECT	COALESCE((SUM(ExternalDuplicates)),0) AS external_duplicates
				FROM(
						SELECT	((COUNT(P.product_id))-1) as ExternalDuplicates
						FROM	(
									SELECT	DISTINCT catalog_number 
									FROM	sponsored_product_bulk_update 
									WHERE	source_file_name = @fileName
											AND
											product_id = 0 
								) SPBU
								INNER JOIN
								product P
								ON SPBU.catalog_number = P.catalog_number
								INNER JOIN
								product_to_vendor PTV
								ON P.product_id = PTV.product_id
								AND
								PTV.vendor_id = @vendorId
						GROUP BY P.product_id
						HAVING COUNT(P.product_id)>1
					) AS External_duplicates    
			) AS external_duplicates        
      
 SELECT  products_found,       
   currently_featured,       
   disabled_products,       
   internal_duplicates,       
   external_duplicates        
 FROM  #bulk_update_stats bus    
    
 DROP TABLE #bulk_update_stats    
      
END  
GO
GRANT EXECUTE ON dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo TO VpWebApp
GO 
------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion      
    @fileName varchar(max)
AS      
-- ==========================================================================      
-- Roshan      
-- ==========================================================================      
BEGIN      
         
SET NOCOUNT ON;      
       
UPDATE  [sponsored_product_bulk_update]      
SET   process_status =      
CASE       
 WHEN (spbu.featured_status = p.rank) THEN ISNULL(process_status, '') + ' Same Featured Status.'      
 WHEN (spbu.featured_status > p.rank) THEN ISNULL(process_status, '') + ' Featured Status Promoted.'      
 WHEN (spbu.featured_status < p.rank) THEN ISNULL(process_status, '') + ' Featured Status Demoted.'      
END      
FROM [sponsored_product_bulk_update] spbu      
  INNER JOIN product p      
  ON p.product_id = spbu.product_id      
  INNER JOIN product_to_vendor PV    
  ON P.product_id = PV.product_id    
WHERE spbu.source_file_name = @fileName     
  AND      
  spbu.enabled = 1     
  AND    
  PV.vendor_id = spbu.vendorId   
  AND    
  P.enabled = 1    
       
UPDATE [sponsored_product_bulk_update]      
SET  process_status = ISNULL(process_status, '') + ' Disabled.'      
FROM [sponsored_product_bulk_update] spbu      
  INNER JOIN product p      
  ON p.product_id = spbu.product_id      
WHERE spbu.source_file_name = @fileName     
  and     
  p.enabled = 0     
  AND     
  spbu.enabled = 1      
  AND    
  spbu.vendorId = spbu.vendorId   
  AND    
  P.enabled = 1    
END 
GO
GRANT EXECUTE ON dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion TO VpWebApp
GO
----------------------------------------------------------------------------------------------------------

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
       
  SELECT Id as id,     
   [source_file_name],    
   [product_id],    
   [catalog_number],    
   [featured_status] ,    
   [search_rank],    
   [start_date],    
   [end_date],    
   [vendorId],    
   enabled,     
   created,     
   modified,     
   [process_status]      
  FROM sponsored_product_bulk_update  SPBU     
  WHERE source_file_name = @fileName  
  AND  
  enabled = 1      
END      
GO
GRANT EXECUTE ON dbo.AdminProduct_GetSponsoredProductListForFile TO VpWebApp
GO   
----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateConflictingDisplayStatuses'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AdminProduct_UpdateConflictingDisplayStatuses]    
    @fileName varchar(max)
AS    
-- ==========================================================================    
-- Roshan     
-- ==========================================================================    
BEGIN    
       
  SET NOCOUNT ON;  
  
     
  UPDATE	product_display_status     
  SET		end_date = CASE WHEN spbu.start_date = CONVERT(DATE, GETDATE()) 
							THEN DATEADD(DAY,-1, GETDATE()) 
							ELSE GETDATE()
					   END 
  FROM		[sponsored_product_bulk_update] spbu     
			INNER JOIN product_display_status pds    
			ON pds.product_id = spbu.product_id    
  WHERE		source_file_name = @fileName    
			AND spbu.enabled = 1  
			AND (
					pds.end_date > GETDATE()
				)
      
END 
GO
GRANT EXECUTE ON dbo.AdminProduct_UpdateConflictingDisplayStatuses TO VpWebApp
GO 
---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_SponsoredProductPopulateIgnoredProducts'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_SponsoredProductPopulateIgnoredProducts    
    @fileName varchar(max)    
AS    
-- ==========================================================================    
-- Roshan   
-- ==========================================================================    
BEGIN        
 SET ANSI_WARNINGS OFF;      
       
 SET NOCOUNT ON;        
      
 UPDATE spbu    
 SET spbu.enabled = 0,    
  spbu.process_status = spbu.process_status + 'Product not found.'    
 FROM dbo.sponsored_product_bulk_update spbu    
 WHERE spbu.Id NOT IN   
   (    
    SELECT spbu.Id    
    FROM dbo.sponsored_product_bulk_update spbu         
      INNER JOIN dbo.product p    
      ON spbu.product_id = p.product_id    
      INNER JOIN dbo.product_to_vendor ptv    
      ON p.product_id = ptv.product_id     
      AND   
      ptv.vendor_id = spbu.vendorId    
    WHERE spbu.source_file_name = @fileName    
   ) AND spbu.source_file_name = @fileName    
    
 UPDATE spbu    
 SET spbu.enabled = 0,    
  spbu.process_status = spbu.process_status + 'Product duplicted in source.'    
 FROM dbo.sponsored_product_bulk_update spbu    
 WHERE spbu.Id IN (    
  SELECT MIN(Id)    
  FROM dbo.sponsored_product_bulk_update spbu    
  WHERE spbu.catalog_number IS NULL    
    AND   
    spbu.source_file_name = @fileName    
  GROUP BY spbu.product_id    
  HAVING COUNT(spbu.product_id) > 1    
 )    
    
 --Ignore same date range records
 UPDATE spbu    
 SET	spbu.enabled = 0,    
		spbu.process_status = ISNULL(spbu.process_status,'') + 'Start date , end date conflict.'    
 FROM	dbo.sponsored_product_bulk_update spbu    
 WHERE	spbu.source_file_name = @fileName
		AND
		EXISTS
		(
			SELECT	1
			FROM	product_display_status PS
					INNER JOIN
					product_to_vendor PTV
					ON	PS.product_id = PTV.product_id
						AND
						PTV.vendor_id = spbu.vendorId
			WHERE	PS.[start_date] = spbu.[start_date]
					AND
					PS.[end_date] = spbu.[end_date]
					AND
					PS.[enabled] = 1
					AND
					PS.[product_id] = spbu.[product_id]
					
		)
END 
GO
GRANT EXECUTE ON adminProduct_SponsoredProductPopulateIgnoredProducts TO VpWebApp
GO 
-----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RemoveFutureDisplayStatuses'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RemoveFutureDisplayStatuses    
    @fileName varchar(max)
AS    
-- ==========================================================================    
-- Roshan   
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
  WHERE   
  ((CONVERT(DATE,pds.[start_date]) > CONVERT(DATE,GETDATE()))  
  OR  
  (spbu.[start_date] = CONVERT(DATE, spbu.[start_date]) AND (pds.[start_date]= CONVERT(DATE,GETDATE()))))  
    
   AND spbu.enabled = 1    
   AND spbu.source_file_name = @fileName AND ptv.vendor_id = spbu.vendorId    
 )    
END    
GO
GRANT EXECUTE ON dbo.adminProduct_RemoveFutureDisplayStatuses TO VpWebApp
GO
--------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateCatalogNumber'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_UpdateCatalogNumber  
    @fileName varchar(max)  
   
AS  
-- ==========================================================================  
-- Roshan  
-- ==========================================================================  
BEGIN  
     
    SET NOCOUNT ON;  
    
    UPDATE	SPBU 
    SET		catalog_number = (COALESCE(NULLIF(SPBU.[catalog_number],''), (	
														SELECT	catalog_number
														FROM	product P
																INNER JOIN
																product_to_vendor PV
																ON P.product_id = PV.product_id
														WHERE	P.product_id = SPBU.[product_id]
																AND
																PV.vendor_id = SPBU.[vendorId]
													)
												)
										)
													
    FROM    sponsored_product_bulk_update SPBU
    WHERE	source_file_name = @fileName
			AND
			[enabled] = 1
			AND
			([catalog_number] IS NULL OR [catalog_number] != '')
			
END  
GO
GRANT EXECUTE ON dbo.AdminProduct_UpdateCatalogNumber TO VpWebApp
GO
-------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_SponsoredProductUploadPopulateExternalDuplicates'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_SponsoredProductUploadPopulateExternalDuplicates]    
    @fileName varchar(max)
AS    
-- ==========================================================================    
-- Roshan    
-- ==========================================================================    
BEGIN        
 SET ANSI_WARNINGS OFF;      
       
 SET NOCOUNT ON;        
      
 SELECT id, spbu.source_file_name, p.product_id, p.catalog_number, spbu.featured_status, spbu.search_rank, spbu.start_date, spbu.end_date, spbu.vendorId    
 INTO #external_duplicates    
 FROM dbo.sponsored_product_bulk_update spbu    
 INNER JOIN dbo.product p    
  ON spbu.catalog_number = p.catalog_number    
 INNER JOIN dbo.product_to_vendor ptv   
  ON ptv.product_id = p.product_id  
 WHERE spbu.product_id = 0    
  AND spbu.source_file_name = @fileName    
  AND  ptv.vendor_id = spbu.vendorId  
    
 DELETE spbu    
 FROM dbo.sponsored_product_bulk_update spbu    
  INNER JOIN #external_duplicates ed    
   ON ed.id = spbu.Id    
    
 INSERT INTO dbo.sponsored_product_bulk_update (source_file_name, product_id, catalog_number, featured_status, search_rank, start_date, end_date, vendorId, enabled, modified, created, process_status)    
 SELECT ed.source_file_name, ed.product_id, ed.catalog_number, ed.featured_status, ed.search_rank, ed.start_date, ed.end_date, ed.vendorId, 1, GETDATE(), GETDATE(), 'Product duplicated in destination.'    
 FROM #external_duplicates ed    
    
 DROP TABLE #external_duplicates    
      
END
GO
GRANT EXECUTE ON dbo.adminProduct_SponsoredProductUploadPopulateExternalDuplicates TO VpWebApp
GO
-------------------------------------------------------------------------------------- 
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_AdditiveDataUpdate'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_AdditiveDataUpdate  
    @fileName varchar(max)
AS  
-- ==========================================================================  
-- Akila  
-- ==========================================================================  
BEGIN  
     
    SET NOCOUNT ON;  
   
 UPDATE [sponsored_product_bulk_update]  
 SET process_status =  
  
 CASE   
 WHEN (spbu.featured_status = pds.new_rank) THEN process_status + ', Same Featured Status'  
 WHEN (spbu.featured_status > pds.new_rank) THEN process_status + ', Featured Status Promoted'  
 WHEN (spbu.featured_status < pds.new_rank) THEN process_status + ', Featured Status Demoted'  
 WHEN (pds.product_display_status_id is null) THEN process_status + ', Featured Status Added'  
 END  
 from [sponsored_product_bulk_update] spbu  
 left join product_display_status pds  
   on pds.product_id = spbu.product_id  
   where spbu.source_file_name = @fileName and   
   spbu.start_date BETWEEN CONVERT(smalldatetime, pds.start_date) AND CONVERT(smalldatetime, pds.end_date)  
   
    
END 
GO
GRANT EXECUTE ON dbo.AdminProduct_AdditiveDataUpdate TO VpWebApp
GO 
-----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_InsertDisplayStatuses'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminProduct_InsertDisplayStatuses]  
    @fileName varchar(max)
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
 WHERE source_file_name = @fileName AND spbu.enabled = 1  
END 
GO
GRANT EXECUTE ON dbo.AdminProduct_InsertDisplayStatuses TO VpWebApp
GO  