
--adminProduct_UpdateProductEnabledStatusByProductIdList

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductEnabledStatusByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductEnabledStatusByProductIdList
	@status BIT,
	@productIds NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Dulip $
-- $DATE: 2020-05-25
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @archived BIT = 0;
	IF (@status = 0) 
		SET @archived = 1
	
	UPDATE p
	SET p.[enabled] = @status
		,p.[modified] = GETDATE()
		,p.[search_content_modified] = 1
		,p.[archived] = @archived
		,p.[content_modified] = 1
	FROM [product] p
		INNER JOIN dbo.global_Split(@productIds, ',') gs
		ON p.product_id = gs.[value]
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductEnabledStatusByProductIdList TO VpWebApp 
GO


