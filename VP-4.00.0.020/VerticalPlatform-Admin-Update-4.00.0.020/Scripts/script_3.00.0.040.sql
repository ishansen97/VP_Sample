EXEC dbo.global_DropStoredProcedure 'dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId
	@productId INT,
	@categoryId INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_category_id AS id, product_id, category_id, enabled, modified, created
	FROM product_to_category with(nolock)
	WHERE product_id = @productId AND category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId TO VpWebApp 
GO


------------------------------------------------------------------------------------------------------------

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
	FROM product_to_search_option with(nolock)
	WHERE product_id = @productId AND search_option_id = @searchOptionId

END
GO

GRANT EXECUTE ON dbo.adminProductSearchOption_GetProductSearchOptionByProductIdAndSearchOptionId TO VpWebApp 
GO

--------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchOption_GetSearchOptionBySearchOptionNameAndGroupId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchOption_GetSearchOptionBySearchOptionNameAndGroupId
	@searchOptionName varchar(150),
	@searchGroupId int
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(1) [search_option_id] as id,[search_group_id],[name],[enabled],[created],[modified],[sort_order]
	FROM search_option with(nolock) WHERE name = @searchOptionName AND search_group_id=@searchGroupId

	END
GO

GRANT EXECUTE ON dbo.adminSearchOption_GetSearchOptionBySearchOptionNameAndGroupId TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetSyncedJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetSyncedJobs
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT rapid_product_update_job_id as id, enabled, created, modified, is_synced, rapid_job_id
	FROM rapid_product_update_job with(nolock)
	WHERE is_synced = 1

	END
GO

GRANT EXECUTE ON dbo.adminRapid_GetSyncedJobs TO VpWebApp 
GO

