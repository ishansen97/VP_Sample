EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetCompletedRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_GetCompletedRapidJobs
 @startRowIndex int,  
 @endRowIndex int,  
 @totalRowCount int output  
AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row , rapid_job_id AS id
	INTO #temp_rapid_jobs FROM [dbo].[rapid_job] ar WITH(NOLOCK) 
		WHERE rapid_state_id = 3

	SELECT 
	rj.rapid_job_id as id,
	rj.vendor_id,
	rj.rapid_status_id,
	rj.rapid_state_id,
	rj.data_file_name,
	rj.rule_file,
	rj.order_by,
	rj.emails,
	rj.enabled,
	rj.is_error,
	rj.error_message,
	rj.modified,
	rj.created,
	rj.site_id
	FROM rapid_job rj
	INNER JOIN  #temp_rapid_jobs trj ON trj.id = rj.rapid_job_id 
	WHERE row BETWEEN @startRowIndex AND @endRowIndex  

	SELECT @totalRowCount = COUNT(*)  
	FROM #temp_rapid_jobs

END
GO

GRANT EXECUTE ON dbo.adminRapidJob_GetCompletedRapidJobs TO VpWebApp 
GO

-- ==========================================================================

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_GetRapidJobsByState'

-- ==========================================================================


---------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProductSearchOption_GetProductSearchOptionByProductIdAndSearchOptionId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProductSearchOption_GetProductSearchOptionByProductIdAndSearchOptionId
	@productId INT,
	@searchOptionId INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_search_option_id AS id, product_id, search_option_id,enabled, locked, created, modified
	FROM product_to_search_option 
	WHERE product_id = @productId AND search_option_id = @searchOptionId

END
GO

GRANT EXECUTE ON dbo.adminProductSearchOption_GetProductSearchOptionByProductIdAndSearchOptionId TO VpWebApp 
GO
