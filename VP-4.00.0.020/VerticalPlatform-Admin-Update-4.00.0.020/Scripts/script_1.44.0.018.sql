EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10,
@lastProcessedProductId INT,
@vendorsWithMasterLeadTargets VARCHAR(MAX),
@lastProductId int output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) pro.[product_id] AS [id]
	INTO #tmp_products
	FROM	product pro WITH(NOLOCK)
			--leads
			LEFT JOIN lead ld WITH(NOLOCK) on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
				AND ld.lead_state_type_id NOT IN (1,2,7) --duplicated,deleted,lead sent
			--related products
			LEFT JOIN dbo.product_to_product ptp WITH(NOLOCK) ON ptp.parent_product_id = pro.product_id
			--start date parameter
			LEFT JOIN dbo.product_parameter pp WITH(NOLOCK) ON pp.product_id = pro.product_id AND pp.parameter_type_id = 188 --ProductRunEndDate
				AND CAST(pp.product_parameter_value AS DATETIME) > GETDATE()
			--campaign content data
			LEFT JOIN campaign_content_data ccd WITH(NOLOCK) ON ccd.content_id = pro.product_id
			LEFT JOIN campaign_type_content_group ctcg WITH(NOLOCK) ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 2 --product
			LEFT JOIN dbo.campaign camp WITH(NOLOCK) ON camp.campaign_id = ccd.campaign_id AND camp.status <> 10 --non archived campaignes
			--master lead target vendors
			LEFT JOIN dbo.product_to_vendor ptv WITH(NOLOCK) ON ptv.product_id = pro.product_id
			LEFT JOIN dbo.global_Split(@vendorsWithMasterLeadTargets, ',') master_lead_vendor ON ptv.vendor_id = master_lead_vendor.[value] 
			LEFT JOIN lead ld_master WITH(NOLOCK) ON master_lead_vendor.value = ld_master.vendor_id AND pro.product_id = ld_master.content_id 
				AND ld_master.content_type_id = 2 AND ld_master.is_included_to_master = 0
	WHERE	pro.search_content_modified = 0 --elastic search processed
			--AND pro.content_modified = 0 --content update synced --todo temporary removed 
			AND pro.enabled = 0
			AND pro.archived = 1 
			AND pro.product_id > @lastProcessedProductId

			AND (ld.lead_id IS NULL)  --all lead sent
			AND (ptp.product_to_product_id IS NULL) --non parent product
			AND (pp.product_parameter_id IS NULL) --no future enable date
			AND	(camp.campaign_id IS NULL) --no non archived campaignes
			AND (ld_master.lead_id IS NULL) --master target included
	ORDER BY pro.product_id


	--model leads without sent
	SELECT id FROM	
	#tmp_products
	EXCEPT
	SELECT tmp_products.id FROM
	#tmp_products tmp_products 
	INNER JOIN dbo.model modl ON modl.product_id = tmp_products.id
	INNER JOIN lead ld ON ld.content_id = modl.model_id AND ld.content_type_id = 21 
	WHERE ld.lead_state_type_id NOT IN (1,2,7)


	--product count out
	SELECT @lastProductId = COALESCE(MAX(id), 0) FROM  #tmp_products

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO

