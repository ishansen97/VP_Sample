IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'FeaturedVendors' 
	AND [usercontrol_name] = '~/Modules/VendorDetail/FeaturedVendors.ascx')
BEGIN
	INSERT INTO [module] ([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES ('FeaturedVendors','~/Modules/VendorDetail/FeaturedVendors.ascx',1,GETDATE(),GETDATE(),0)
END

--------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorsWithTabbedProfile'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetVendorsWithTabbedProfile
	@siteId int
AS
-- ========================================================================== 
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT v.vendor_id AS id, site_id AS site_id, vendor_name AS vendor_name, rank AS rank
		, has_image AS has_image, v.[enabled] AS [enabled], v.modified AS modified, v.created AS created
		, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM vendor v
	INNER JOIN vendor_parameter vp
		ON vp.vendor_id = v.vendor_id
	WHERE vp.parameter_type_id = 179
		AND v.site_id = @siteId
		AND v.[enabled] = 1
		AND vp.vendor_parameter_value <> ''
	ORDER BY v.vendor_name
	
END