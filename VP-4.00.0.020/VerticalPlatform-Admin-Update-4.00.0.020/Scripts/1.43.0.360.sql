EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo
    @fileName varchar(max),
	@productsFound int output,
    @currentlyFeatured int output,
    @disabledProducts int output,
    @internalDuplicates int output,
    @externalDuplicates int output        
AS
-- ==========================================================================
-- Akila
-- ==========================================================================
BEGIN
   
    SET NOCOUNT ON;
	
	CREATE TABLE #bulk_update_stats (
	products_found int DEFAULT (0),
	currently_featured int DEFAULT (0),
	disabled_products int DEFAULT (0),
	internal_duplicates int DEFAULT (0),
	external_duplicates int DEFAULT (0)
	)

	INSERT INTO #bulk_update_stats (products_found, currently_featured, disabled_products)
	SELECT SUM(products_found) AS products_found, 
		SUM(currently_featured) AS currently_featured, 
		SUM(disabled_products) AS disabled_products
	FROM (
		SELECT COUNT(p.product_id) as products_found,
			SUM(CASE WHEN p.rank > 0 THEN 1 END) AS currently_featured,
			SUM(CASE WHEN p.enabled = 0 THEN 1 END) AS disabled_products
		FROM dbo.sponsored_product_bulk_update spbu 
		LEFT JOIN dbo.product p 
			ON spbu.product_id = p.product_id
		WHERE spbu.catalog_number IS NULL AND spbu.source_file_name = @fileName
		UNION
		SELECT COUNT(p.product_id) AS products_found,
			SUM(CASE WHEN p.rank > 1 THEN 1 END) AS currently_featured,
			SUM(CASE WHEN p.enabled = 0 THEN 1 END) AS disabled_products
		FROM dbo.sponsored_product_bulk_update spbu
		LEFT JOIN dbo.product p 
			ON spbu.catalog_number = p.catalog_number
		WHERE spbu.product_id IS NULL AND spbu.source_file_name = @fileName
	) all_products

	UPDATE #bulk_update_stats
	SET
		#bulk_update_stats.internal_duplicates = internal_duplicates.internal_duplicates
	FROM (
		SELECT SUM(internal_duplicates) AS internal_duplicates
		FROM (
			SELECT COUNT(DISTINCT spbu.product_id) AS internal_duplicates
			FROM dbo.sponsored_product_bulk_update spbu
			WHERE spbu.catalog_number IS NULL
			GROUP BY spbu.product_id
			HAVING COUNT(spbu.product_id) > 1
			UNION ALL
			SELECT COUNT(DISTINCT spbu.catalog_number) AS internal_duplicates
			FROM dbo.sponsored_product_bulk_update spbu
			WHERE spbu.product_id IS NULL AND spbu.source_file_name = @fileName
			GROUP BY spbu.catalog_number
			HAVING COUNT(spbu.catalog_number) > 1
		) internal_duplicates
	) internal_duplicates

	UPDATE #bulk_update_stats
	SET
		#bulk_update_stats.external_duplicates = external_duplicates.external_duplicates
	FROM (
		SELECT SUM(external_duplicates) AS external_duplicates
		FROM (
			SELECT COUNT(DISTINCT p.product_id) AS external_duplicates
			FROM dbo.sponsored_product_bulk_update spbu
			INNER JOIN dbo.product p
				ON spbu.product_id = p.product_id
			WHERE spbu.catalog_number IS NULL AND spbu.source_file_name = @fileName
			GROUP BY p.product_id
			HAVING COUNT(p.product_id) > 1
		) external_duplicates
	) external_duplicates

	SELECT @productsFound = products_found  , @currentlyFeatured  = currently_featured, @disabledProducts  = disabled_products, @internalDuplicates  = internal_duplicates, @externalDuplicates = external_duplicates
	FROM #bulk_update_stats bus

	DROP TABLE #bulk_update_stats
	
		
END
GO

GRANT EXECUTE ON dbo.AdminProduct_GetSponsoredBulkUpdateSummaryInfo TO VpWebApp
GO




	

		