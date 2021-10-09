EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetVendorIdsBySpecificVendorParamter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetVendorIdsBySpecificVendorParamter
	@siteId int,
	@parameterTypeId int
	
AS
-- ==========================================================================
-- Author : Akila
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT vp.vendor_id as id
	FROM vendor_parameter vp
		inner join vendor v
		ON vp.vendor_id = v.vendor_id
	WHERE parameter_type_id = @parameterTypeId and v.site_id = @siteId and vp.vendor_parameter_value = 1
	
END

GO

GRANT EXECUTE ON dbo.adminVendor_GetVendorIdsBySpecificVendorParamter TO VpWebApp 
GO