-- VP-8689
IF NOT EXISTS (SELECT * FROM parameter_type WHERE parameter_type_id = 187 OR parameter_type = 'ProductRunStartDate')
BEGIN
	INSERT INTO [parameter_type]
			([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES
			(187,'ProductRunStartDate',1,GETDATE(),GETDATE())
END
GO

IF NOT EXISTS (SELECT * FROM parameter_type WHERE parameter_type_id = 188 OR parameter_type = 'ProductRunEndDate')
BEGIN
	INSERT INTO [parameter_type]
			([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES
			(188,'ProductRunEndDate',1,GETDATE(),GETDATE())
END
GO

IF NOT EXISTS (SELECT * FROM parameter_type WHERE parameter_type_id = 189 OR parameter_type = 'ProductRunDisabledDate')
BEGIN
	INSERT INTO [parameter_type]
			([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES
			(189,'ProductRunDisabledDate',1,GETDATE(),GETDATE())
END
GO

IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 190)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(190,'FixedGuidedBrowseEmbedInProductDirectory','1',GETDATE(),GETDATE())
END
GO
---------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductsToEnableByStartDate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductsToEnableByStartDate
	@batchSize INT,
	@currentTime SMALLDATETIME,
	@lastRun SMALLDATETIME,
	@siteId INT,
	@totalCount INT output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(@batchSize) p.[product_id] AS [id],p.[site_id],p.[parent_product_id],p.[product_name],p.[rank],p.[has_image]
			,p.[catalog_number],p.[enabled],p.[modified],p.[created],p.[product_type],p.[status],p.[has_model]
			,p.[has_related],p.[flag1],p.[flag2],p.[flag3],p.[flag4],p.[completeness],p.[search_rank],p.[legacy_content_id]
			,p.[search_content_modified],p.[hidden],p.[business_value],p.[ignore_in_rapid],p.[show_in_matrix]
			,p.[show_detail_page],p.[default_rank],p.[default_search_rank]
	FROM [product] p
		INNER JOIN product_parameter pp
			ON p.product_id = pp.product_id
	WHERE p.[site_id] = @siteId AND p.[enabled] = 0 AND  pp.[parameter_type_id] = 187 AND 
			pp.[product_parameter_value] IS NOT NULL AND pp.[product_parameter_value] <> '' AND 
			(@lastRun IS NULL OR @lastRun < pp.[product_parameter_value]) AND pp.[product_parameter_value] <= @currentTime

	SELECT @totalCount = COUNT(p.[product_id])
	FROM [product] p
		INNER JOIN product_parameter pp
			ON p.product_id = pp.product_id
	WHERE p.[site_id] = @siteId AND p.[enabled] = 0 AND  pp.[parameter_type_id] = 187 AND 
			pp.[product_parameter_value] IS NOT NULL AND pp.[product_parameter_value] <> '' AND 
			(@lastRun IS NULL OR @lastRun < pp.[product_parameter_value]) AND pp.[product_parameter_value] <= @currentTime
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductsToEnableByStartDate TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------------------------
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
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE p
	SET p.[enabled] = @status
		,p.[modified] = GETDATE()
		,p.[search_content_modified] = 1
	FROM [product] p
		INNER JOIN dbo.global_Split(@productIds, ',') gs
		ON p.product_id = gs.[value]
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductEnabledStatusByProductIdList TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductParamterValueByParameterTypeProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductParamterValueByParameterTypeProductIdList
	@paramterType INT,
	@productIds NVARCHAR(MAX),
	@newValue NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	UPDATE pp
		SET [product_parameter_value] = @newValue
		,[modified] = GETDATE()
	FROM product_parameter pp
		INNER JOIN dbo.global_Split(@productIds, ',') gs
		ON pp.product_id = gs.[value]
	WHERE pp.parameter_type_id = @paramterType

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductParamterValueByParameterTypeProductIdList TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductsToDisableByEndDate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductsToDisableByEndDate
	@batchSize INT,
	@currentTime SMALLDATETIME,
	@lastRun SMALLDATETIME,
	@siteId INT,
	@totalCount INT output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP(@batchSize) p.[product_id] AS [id],p.[site_id],p.[parent_product_id],p.[product_name],p.[rank],p.[has_image]
			,p.[catalog_number],p.[enabled],p.[modified],p.[created],p.[product_type],p.[status],p.[has_model]
			,p.[has_related],p.[flag1],p.[flag2],p.[flag3],p.[flag4],p.[completeness],p.[search_rank],p.[legacy_content_id]
			,p.[search_content_modified],p.[hidden],p.[business_value],p.[ignore_in_rapid],p.[show_in_matrix]
			,p.[show_detail_page],p.[default_rank],p.[default_search_rank]
	FROM [product] p
		INNER JOIN product_parameter pp
			ON p.product_id = pp.product_id
	WHERE p.[site_id] = @siteId AND p.[enabled] = 1 AND pp.[parameter_type_id] = 188 AND 
			pp.[product_parameter_value] IS NOT NULL AND pp.[product_parameter_value] <> '' AND 
			(@lastRun IS NULL OR @lastRun < pp.[product_parameter_value]) AND pp.[product_parameter_value] <= @currentTime

	SELECT @totalCount = COUNT(p.[product_id])
	FROM [product] p
		INNER JOIN product_parameter pp
			ON p.product_id = pp.product_id
	WHERE p.[site_id] = @siteId AND p.[enabled] = 1 AND pp.[parameter_type_id] = 188 AND 
			pp.[product_parameter_value] IS NOT NULL AND pp.[product_parameter_value] <> '' AND 
			(@lastRun IS NULL OR @lastRun < pp.[product_parameter_value]) AND pp.[product_parameter_value] <= @currentTime
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductsToDisableByEndDate TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------------------------