

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationDelete'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationDelete
	@vendorId int,
	@currencyId int,
	@locationTypeId int,
	@locationId int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;

	Select product_vendor_price_id INTO #Temp
	FROM product_to_vendor_to_price pvp 
	INNER JOIN product_to_vendor pv
	ON pv.product_to_vendor_id = pvp.product_to_vendor_id	
	WHERE pv.vendor_id = @vendorId AND pvp.currency_id = @currencyId 
	
	DELETE FROM content_location 
	WHERE content_type_id = 23 AND content_id IN
	(	
		Select product_vendor_price_id 
		from #Temp
	)
	AND [location_id] != @locationId
	


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationDelete TO VpWebApp 
GO

