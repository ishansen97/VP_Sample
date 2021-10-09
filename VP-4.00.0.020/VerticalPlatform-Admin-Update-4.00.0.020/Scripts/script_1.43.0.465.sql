EXEC dbo.global_DropStoredProcedure 'adminProduct_SponsoredProductPopulateIgnoredProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_SponsoredProductPopulateIgnoredProducts]      
    @fileName varchar(max)      
AS      
-- ==========================================================================      
-- Akila     
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
       
 UPDATE [sponsored_product_bulk_update]        
 SET  enabled = 0    
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
    
END   
GO
GRANT EXECUTE ON dbo.adminProduct_SponsoredProductPopulateIgnoredProducts TO VpWebApp
Go
