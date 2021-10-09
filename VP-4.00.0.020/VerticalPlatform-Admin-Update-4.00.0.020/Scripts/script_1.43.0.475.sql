EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_UpdateConflictingDisplayStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminProduct_UpdateConflictingDisplayStatuses]        
    @fileName varchar(max)    
AS        
-- ==========================================================================        
-- Sahan         
-- ==========================================================================        
BEGIN        
           
  SET NOCOUNT ON;      
      
         
  UPDATE product_display_status           
	SET  end_date = CASE
						WHEN spbu.start_date = CONVERT(DATE, GETDATE())
							THEN DATEADD(DAY, -1, GETDATE())
						WHEN (pds.end_date >= spbu.start_date AND spbu.start_date > CONVERT(DATE, GETDATE()))
							THEN CONVERT(DATE, GETDATE())
					END
	FROM [sponsored_product_bulk_update] spbu           
		INNER JOIN product_display_status pds          
			ON pds.product_id = spbu.product_id          
	WHERE  source_file_name = @fileName          
		AND spbu.enabled = 1        
		AND (pds.end_date >= CONVERT(DATE, GETDATE()))
		AND spbu.[start_date] <= pds.end_date
          
END
GO
GRANT EXECUTE ON dbo.AdminProduct_UpdateConflictingDisplayStatuses TO VpWebApp
Go