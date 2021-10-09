EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdByBatch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdByBatch
	@vendorId int,
	@batchSize int,
	@batchNumber int,
	@totalCount int output
	
AS
-- ==========================================================================
-- Author : Rifaz Rifky
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @batchSize * (@batchNumber - 1) + 1;
	SET @endIndex = @batchSize * @batchNumber
	
	SELECT ROW_NUMBER() OVER (ORDER BY prd.[product_id]) AS rowNumber, prd.[product_id] AS [id], prd.[site_id], prd.[parent_product_id], prd.[product_name], prd.[rank]
		, prd.[has_image], prd.[catalog_number], prd.[enabled], prd.[modified], prd.[created], prd.[product_type], prd.[status], prd.[has_model], prd.[has_related]
		, prd.[flag1], prd.[flag2], prd.[flag3], prd.[flag4], prd.[completeness], prd.[search_rank], prd.[search_content_modified], prd.[hidden], prd.[business_value]
		, prd.[show_in_matrix], prd.[show_detail_page], prd.[ignore_in_rapid], prd.[default_rank], prd.[default_search_rank]
	INTO #tempVendorProductList
	FROM [product] prd
		INNER JOIN [product_to_vendor]
			ON prd.product_id = [product_to_vendor].product_id
	WHERE [product_to_vendor].vendor_id = @vendorId
	
	SELECT @totalCount = COUNT(id) FROM #tempVendorProductList
	
	SELECT [id], [site_id], [parent_product_id], [product_name], [rank], [has_image], [catalog_number]
		, [enabled], [modified], [created], [product_type], [status], [has_model], [has_related], [flag1], [flag2], [flag3], [flag4], [completeness]
		, [search_rank], [search_content_modified], [hidden], [business_value], [show_in_matrix], [show_detail_page], [ignore_in_rapid], [default_rank]
		, [default_search_rank]
	FROM #tempVendorProductList
	WHERE rowNumber BETWEEN @startIndex AND @endIndex
	
	DROP TABLE #tempVendorProductList
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdByBatch TO VpWebApp
GO
----------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByCategoryIdByBatch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByCategoryIdByBatch
	@categoryId int,
	@batchSize int,
	@batchNumber int,
	@totalCount int output
AS
-- ==========================================================================
-- Author : Rifaz Rifky
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @batchSize * (@batchNumber - 1) + 1;
	SET @endIndex = @batchSize * @batchNumber
	
	SELECT ROW_NUMBER() OVER (ORDER BY pro.[product_id]) AS rowNumber, pro.[product_id] AS [id], pro.[site_id], pro.[parent_product_id], pro.[product_name], pro.[rank]
		, pro.[has_image], pro.[catalog_number], pro.[enabled], pro.[modified], pro.[created], pro.[product_type], pro.[status], pro.[has_model], pro.[has_related]
		, pro.[flag1], pro.[flag2], pro.[flag3], pro.[flag4], pro.[completeness], pro.[search_rank], pro.[search_content_modified], pro.[hidden], pro.[business_value]
		, pro.[show_in_matrix], pro.[show_detail_page], pro.[ignore_in_rapid], pro.[default_rank], pro.[default_search_rank]
	INTO #tempVendorProductList
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @categoryId
	
	SELECT @totalCount = COUNT(id) FROM #tempVendorProductList
	
	SELECT [id], [site_id], [parent_product_id], [product_name], [rank], [has_image], [catalog_number]
		, [enabled], [modified], [created], [product_type], [status], [has_model], [has_related], [flag1], [flag2], [flag3], [flag4], [completeness]
		, [search_rank], [search_content_modified], [hidden], [business_value], [show_in_matrix], [show_detail_page], [ignore_in_rapid], [default_rank]
		, [default_search_rank]
	FROM #tempVendorProductList
	WHERE rowNumber BETWEEN @startIndex AND @endIndex
	
	DROP TABLE #tempVendorProductList

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByCategoryIdByBatch TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserProfileInfoBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserProfileInfoBySiteIdList
	@siteId int,
	@pageSize int,
	@pageIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH UserList AS
	(
		SELECT pup.public_user_profile_id AS id, ROW_NUMBER() OVER (ORDER BY pup.public_user_id) AS row_id, pup.public_user_id, pup.salutation, pup.first_name, pup.last_name,
			pup.address_line1, pup.address_line2, pup.city, pup.[state], pup.country_id, pup.phone_number, pup.postal_code, pup.company, pu.email
		FROM public_user pu
			INNER JOIN public_user_profile pup
				ON pu.public_user_id = pup.public_user_id
		WHERE pu.site_id = @siteId AND pu.enabled = 1 AND pu.email_optout = 0
	)
	
	SELECT id, public_user_id, salutation, first_name, last_name
		, address_line1, address_line2, city, [state], country_id, phone_number, postal_code, company
		, email
	FROM UserList
	WHERE row_id BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserProfileInfoBySiteIdList TO VpWebApp 
GO
-------------
----------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteContentSpecificationTypeBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteContentSpecificationTypeBySiteId
	@siteId int
AS
-- ==========================================================================
-- Author : Rifaz Rifky
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DELETE cst
	FROM [content_to_specification_type] cst
		INNER JOIN [specification_type] st
			ON st.spec_type_id = cst.specification_type_id
	WHERE st.site_id = @siteId
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteContentSpecificationTypeBySiteId TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

--new settings for content page view summary task
;WITH NewCVTaskSettings AS (
SELECT 
	task_id, 
	'ExcludeInternalIpAddresses' AS setting_name, 
	'false' AS setting_value, 1 AS enabled,
	getdate() as modified, 
	getdate() as created 
FROM task
WHERE task_type = 9
	UNION ALL 
SELECT 
	task_id, 
	'InternalIpAddresses', 
	'', 
	1, 
	getdate(),
	getdate() 
FROM task
WHERE task_type = 9) 

-- insert new settings if they are not already defined 
INSERT task_setting (
	task_id,
	setting_name,
	setting_value,
	enabled,
	modified,
	created
)
SELECT ncvs.task_id,
	ncvs.setting_name,
	ncvs.setting_value,
	ncvs.enabled,
	ncvs.modified,
	ncvs.created FROM NewCVTaskSettings ncvs
LEFT JOIN task_setting ts on ncvs.task_id = ts.task_id AND ncvs.setting_name = ts.setting_name 
WHERE ts.task_setting_id IS NULL

GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminAnalytics_DeleteInternalContentPageViews'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAnalytics_DeleteInternalContentPageViews
	@internalIpAddressList varchar(max)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM content_page_views
	WHERE  ip IN (SELECT value FROM dbo.global_split(@InternalIpAddressList,','))

END
GO

GRANT EXECUTE ON dbo.adminAnalytics_DeleteInternalContentPageViews TO VpWebApp 
GO
