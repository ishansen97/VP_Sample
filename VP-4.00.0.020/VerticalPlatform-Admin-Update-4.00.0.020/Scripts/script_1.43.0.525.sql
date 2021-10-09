EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorTrackingScriptsForModel'

GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetVendorTrackingScriptsForModel]    Script Date: 10/11/2018 11:16:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[publicProduct_GetVendorTrackingScriptsForModel]
	@modelId INT
AS
-- ==========================================================================
-- $URL:  $
-- $Revision:  $
-- $Date:  $ 
-- $Author: Chinthaka $
-- Modifications
-- ==========================================================================
BEGIN
	SELECT	DISTINCT vnd_prm.vendor_parameter_id AS id
			,vnd_prm.vendor_id
			,vnd_prm.parameter_type_id
			,vnd_prm.vendor_parameter_value
			,vnd_prm.enabled
			,vnd_prm.modified
			,vnd_prm.created 
	FROM	dbo.product_to_vendor prd_vnd
			INNER JOIN dbo.vendor vnd ON vnd.vendor_id = prd_vnd.vendor_id
			INNER JOIN dbo.model modl ON modl.product_id = prd_vnd.product_id
			INNER JOIN dbo.vendor_parameter vnd_prm ON vnd_prm.vendor_id = vnd.vendor_id
			INNER JOIN (
				SELECT	vnd_prm.vendor_id AS VendorID 
				FROM	dbo.vendor_parameter vnd_prm
				WHERE	vnd_prm.parameter_type_id = 201 --EnableRealTimeLeads
						AND vnd_prm.vendor_parameter_value = '1' --only realtime enabled vendors
			)enbled_vnds ON enbled_vnds.VendorID = prd_vnd.vendor_id

	WHERE	prd_vnd.is_manufacturer = 1
			AND	vnd_prm.parameter_type_id = 203 --tracking script
			AND modl.model_id = @modelId

END


GO
GRANT EXECUTE ON dbo.publicProduct_GetVendorTrackingScriptsForModel TO VpWebApp
GO

