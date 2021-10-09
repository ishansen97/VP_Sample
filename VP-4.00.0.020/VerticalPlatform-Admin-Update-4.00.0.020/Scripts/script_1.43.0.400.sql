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
	WHERE source_file_name = @fileName
END
GO

GRANT EXECUTE ON dbo.AdminProduct_InsertDisplayStatuses TO VpWebApp
GO

---------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo
    @fileName varchar(max)
AS
-- ==========================================================================
-- Sahan Diasena
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
	SELECT SUM(products_found) AS products_found,     
		SUM(currently_featured) AS currently_featured,     
		SUM(disabled_products) AS disabled_products
	FROM  (    
		SELECT COUNT(p.product_id) as products_found,    
			COALESCE(SUM(CASE WHEN p.rank > 0 THEN 1 END),0) AS currently_featured,    
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
	FROM (    
		SELECT COALESCE(SUM(internal_duplicates),0) AS internal_duplicates    
		FROM (    
				SELECT COUNT(DISTINCT spbu.product_id) AS internal_duplicates    
				FROM dbo.sponsored_product_bulk_update spbu    
				WHERE spbu.catalog_number IS NULL    
					AND	spbu.source_file_name = @fileName       
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
		
	UPDATE  #bulk_update_stats    
	SET  #bulk_update_stats.external_duplicates = external_duplicates.external_duplicates    
	FROM  (    
		SELECT COALESCE(SUM(external_duplicates),0) AS external_duplicates    
		FROM (    
			SELECT COUNT(p.product_id) AS external_duplicates    
			FROM dbo.sponsored_product_bulk_update spbu    
				INNER JOIN dbo.product p    
				ON spbu.catalog_number = p.catalog_number
			INNER JOIN dbo.product_to_vendor ptv
				ON p.product_id = ptv.product_id 
					AND ptv.vendor_id = spbu.vendorId
			WHERE spbu.product_id = 0 AND spbu.source_file_name = @fileName   
			GROUP BY p.catalog_number  
			) external_duplicates    
	) external_duplicates    
		
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

---------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_SponsoredProductUploadPopulateExternalDuplicates'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_SponsoredProductUploadPopulateExternalDuplicates
    @fileName varchar(max)
AS
-- ==========================================================================
-- Sahan Diasena
-- ==========================================================================
BEGIN    
	SET ANSI_WARNINGS OFF;  
	  
	SET NOCOUNT ON;    
	 
	SELECT id, spbu.source_file_name, p.product_id, p.catalog_number, spbu.featured_status, spbu.search_rank, spbu.start_date, spbu.end_date, spbu.vendorId
	INTO #external_duplicates
	FROM dbo.sponsored_product_bulk_update spbu
	INNER JOIN dbo.product p
		ON spbu.catalog_number = p.catalog_number
	WHERE spbu.product_id = 0
		AND spbu.source_file_name = @fileName

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

---------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_SponsoredProductPopulateIgnoredProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_SponsoredProductPopulateIgnoredProducts
    @fileName varchar(max)
AS
-- ==========================================================================
-- Sahan Diasena
-- ==========================================================================
BEGIN    
	SET ANSI_WARNINGS OFF;  
	  
	SET NOCOUNT ON;    
	 
	UPDATE spbu
	SET spbu.enabled = 0,
		spbu.process_status = spbu.process_status + 'Product not found.'
	FROM dbo.sponsored_product_bulk_update spbu
	WHERE spbu.Id NOT IN (
		SELECT spbu.Id
		FROM dbo.sponsored_product_bulk_update spbu     
			INNER JOIN dbo.product p
				ON spbu.product_id = p.product_id
			INNER JOIN dbo.product_to_vendor ptv
				ON p.product_id = ptv.product_id 
					AND ptv.vendor_id = spbu.vendorId
			WHERE spbu.source_file_name = @fileName
	) AND spbu.source_file_name = @fileName

	UPDATE  spbu
	SET spbu.enabled = 0,
		spbu.process_status = spbu.process_status + 'Product duplicted in source.'
	FROM dbo.sponsored_product_bulk_update spbu
	WHERE spbu.product_id IN (
		SELECT DISTINCT spbu.product_id
		FROM dbo.sponsored_product_bulk_update spbu
		WHERE spbu.catalog_number IS NULL
			AND spbu.source_file_name = @fileName
		GROUP BY spbu.product_id
		HAVING COUNT(spbu.product_id) > 1
	)

	UPDATE  spbu
	SET spbu.enabled = 1,
		spbu.process_status = REPLACE(spbu.process_status, 'Product duplicted in source.', '') 
	FROM dbo.sponsored_product_bulk_update spbu
	WHERE spbu.product_id IN (
		SELECT MAX(spbu.Id)
		FROM dbo.sponsored_product_bulk_update spbu
		WHERE spbu.catalog_number IS NULL
			AND spbu.source_file_name = @fileName
		GROUP BY spbu.product_id
		HAVING COUNT(spbu.product_id) > 1
	) 
	 
END
GO

GRANT EXECUTE ON dbo.adminProduct_SponsoredProductPopulateIgnoredProducts TO VpWebApp
GO

---------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RemoveFutureDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RemoveFutureDisplayStatuses
    @fileName varchar(max)
	
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
		WHERE pds.start_date > CONVERT(DATE, spbu.end_date)
			AND spbu.enabled = 1
			AND spbu.source_file_name = @fileName
	)
END
GO

GRANT EXECUTE ON dbo.adminProduct_RemoveFutureDisplayStatuses TO VpWebApp
GO

---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RemoveAllFutureDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RemoveAllFutureDisplayStatuses
	@vendorId int
	
AS
-- ==========================================================================
-- Sahan Diasena
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	DELETE FROM product_display_status
	WHERE product_display_status_id IN
	(
		SELECT pds.product_display_status_id
		FROM  product_display_status pds
		INNER JOIN dbo.product_to_vendor ptv
			ON pds.product_id = ptv.product_id
		WHERE ptv.vendor_id = @vendorId
			AND pds.start_date > CONVERT(DATE, GETDATE())
	)
END
GO

GRANT EXECUTE ON dbo.adminProduct_RemoveAllFutureDisplayStatuses TO VpWebApp
GO

---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateConflictingDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_UpdateConflictingDisplayStatuses
    @fileName varchar(max)
	
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
	WHERE source_file_name = @fileName
		AND (spbu.start_date >= CONVERT(DATE, pds.start_date)) 
		AND (spbu.start_date <= CONVERT(DATE, pds.end_date))
		AND spbu.enabled = 1
		
END
GO

GRANT EXECUTE ON dbo.AdminProduct_UpdateConflictingDisplayStatuses TO VpWebApp
GO

 -------------------------------------------------------------------------------
 
 
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_InsertDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_InsertDisplayStatuses
    @fileName varchar(max)
	
AS
-- ==========================================================================
-- Akila
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	INSERT INTO [product_display_status]([product_id] ,[start_date] ,[end_date] ,[new_rank] ,[enabled] ,[modified] ,[created] ,[search_rank] ,[include])
	SELECT spbu.product_id, spbu.start_date, spbu.end_date, spbu.featured_status, 1, GETDATE(), GETDATE(), spbu.search_rank, 0
	FROM [sponsored_product_bulk_update] spbu 
	WHERE source_file_name = @fileName
		AND spbu.enabled = 1
		
END
GO

GRANT EXECUTE ON dbo.AdminProduct_InsertDisplayStatuses TO VpWebApp
GO

--------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_CloseProductDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_CloseProductDisplayStatuses
    @fileName varchar(max),
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


-----------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sponsored_product_bulk_update]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[sponsored_product_bulk_update](
	[source_file_name] [varchar](200) NOT NULL,
	[product_id] [int] NULL,
	[catalog_number] [varchar](225) NULL,
	[featured_status] [int] NULL,
	[search_rank] [float] NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[vendorId] [int] NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[enabled] [bit] NULL,
	[created] [smalldatetime] NULL,
	[modified] [smalldatetime] NULL,
	[process_status] [varchar](255) NULL,
 CONSTRAINT [PK_sponsored_product_bulk_update] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
GO

-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.sponsoredBulkUpdate_AddProduct'
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sponsoredBulkUpdate_AddProduct]
@sourceFileName VARCHAR(200),
@productId INT,
@catalogNumber VARCHAR(225) ,
@featuredStatus INT,
@searchRank FLOAT,
@startDate DATE,
@endDate DATE,
@vendorId INT
AS

-- ==========================================================================  
-- Author : Roshan 
-- ========================================================================== 

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


---------------------------------------------------

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
		WHEN (spbu.featured_status = p.rank) THEN ISNULL(process_status, '') + ',Same Featured Status'
		WHEN (spbu.featured_status > p.rank) THEN ISNULL(process_status, '') + ',Featured Status Promoted'
		WHEN (spbu.featured_status < p.rank) THEN ISNULL(process_status, '') + ',Featured Status Demoted'
		END
	FROM [sponsored_product_bulk_update] spbu
	INNER JOIN product p
	  ON p.product_id = spbu.product_id
	  WHERE spbu.source_file_name = @fileName 	  			
		
END
GO

GRANT EXECUTE ON dbo.AdminProduct_UpdateFeaturedPromtionAndDemotion TO VpWebApp
GO




	

		



  

 









	

		