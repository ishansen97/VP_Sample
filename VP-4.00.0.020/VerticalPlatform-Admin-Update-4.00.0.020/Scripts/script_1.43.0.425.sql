
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_DeleteProductsByFileName'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_DeleteProductsByFileName     
@sourceFileName VARCHAR(200)      
AS    
--===================  
--    Roshan 
--===================      
BEGIN    
  SET NOCOUNT ON;    
  
  DELETE 
  FROM		dbo.sponsored_product_bulk_update
  WHERE		source_file_name = @sourceFileName
END

GO

GRANT EXECUTE ON dbo.AdminProduct_DeleteProductsByFileName TO VpWebApp
GO

---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_DeleteSponsoredProductById'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_DeleteSponsoredProductById      
@id INT      
AS        
BEGIN      
--===================    
--    Imoshika    
--===================       
  SET NOCOUNT ON;      
      
  DELETE FROM sponsored_product_bulk_update       
  WHERE   product_id = @id;      
      
END

GO

GRANT EXECUTE ON dbo.AdminProduct_DeleteSponsoredProductById TO VpWebApp
GO
---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_AddSponsoredProduct'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminProduct_AddSponsoredProduct]    
@sourceFileName VARCHAR(200),    
@productId INT,    
@catalogNumber VARCHAR(225) ,    
@featuredStatus INT,    
@searchRank FLOAT,    
@startDate DATE,    
@endDate DATE,    
@vendorId INT    
AS     
-- ===================     
-- Author : Roshan     
-- ===================    
BEGIN    
     
 IF(@productId IS NOT NULL AND @productId != '')    
 BEGIN    
  SET @catalogNumber = NULL;    
 END    
 INSERT INTO [dbo].[sponsored_product_bulk_update]    
           ([source_file_name]    
           ,[product_id]    
           ,[catalog_number]    
           ,[featured_status]    
           ,[search_rank]    
           ,[start_date]    
           ,[end_date]    
           ,[vendorId], enabled, created, modified, process_status)    
     VALUES    
           (@sourceFileName,    
   @productId,    
   @catalogNumber,    
   @featuredStatus,    
   @searchRank,    
   @startDate,    
   @endDate,    
   @vendorId, 1, GETDATE(), GETDATE(),null)    
END 

GO

GRANT EXECUTE ON dbo.AdminProduct_AddSponsoredProduct TO VpWebApp
GO
---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetSponsoredProductDetailByProductId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetSponsoredProductDetailByProductId      
@productId INT AS      
      
BEGIN 
--===================    
--    Imoshika    
--===================       
SET NOCOUNT ON;      
SELECT product_id AS id,       
  source_file_name,      
  catalog_number,      
  featured_status,      
  search_rank,      
  start_date,      
  end_date,      
  vendorId      
          
FROM sponsored_product_bulk_update      
WHERE product_id = @productId      
      
END

GO

GRANT EXECUTE ON dbo.AdminProduct_GetSponsoredProductDetailByProductId TO VpWebApp
GO
----------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateSponsoredProduct'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===================    
--    Imoshika    
--===================    
CREATE PROCEDURE dbo.AdminProduct_UpdateSponsoredProduct      
@sourceFileName VARCHAR(200),        
@productId INT,        
@catalogNumber VARCHAR(225) ,        
@featuredStatus INT,        
@searchRank FLOAT,        
@startDate DATE,        
@endDate DATE,        
@vendorId INT      
AS      
      
BEGIN      
  SET NOCOUNT ON;      
  UPDATE sponsored_product_bulk_update      
  SET      
   source_file_name = @sourceFileName,      
   product_id = @productId,      
   catalog_number = @catalogNumber,      
   featured_status = @featuredStatus,      
   search_rank = @searchRank,      
   start_date = @startDate,      
   end_date = @endDate,      
   vendorId = @vendorId      
      
WHERE  product_id = @productId      
      
END

GO

GRANT EXECUTE ON dbo.AdminProduct_UpdateSponsoredProduct TO VpWebApp
GO

-------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_CheckCatalogNumberStatus'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_CheckCatalogNumberStatus  
    @catalogNumber VARCHAR(255), 
    @vendorId INT
AS  
-- ==========================================================================  
-- Roshan  
-- ==========================================================================  
BEGIN 
	SELECT	COUNT(p.catalog_number) as CatalogNumber
	FROM	product p
			INNER JOIN
			product_to_vendor pv	ON P.product_id = pv.product_id
	WHERE	p.catalog_number = @catalogNumber
			AND
			pv.vendor_id = @vendorId	
END	

GO

GRANT EXECUTE ON dbo.adminProduct_CheckCatalogNumberStatus TO VpWebApp
GO
