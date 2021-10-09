EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationUpdate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationUpdate
	@vendorId int,
	@newCountryFlag1 bigint,
	@newCountryFlag2 bigint,
	@newCountryFlag3 bigint,
	@newCountryFlag4 bigint,
	@currencyId int

AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	DECLARE @modified smalldatetime
	SET @modified = GETDATE()
	
	UPDATE product_to_vendor_to_price 
	SET country_flag1 = @newCountryFlag1,
		country_flag2 = @newCountryFlag2,
		country_flag3 = @newCountryFlag3,
		country_flag4 = @newCountryFlag4,
		modified = @modified
		
	WHERE product_to_vendor_id IN 
	(
		SELECT product_to_vendor_id
		FROM product_to_vendor
		WHERE vendor_id = @vendorId
	)
	AND currency_id = @currencyId


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationUpdate TO VpWebApp 
GO

----------------------------------------------------

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
	AND [location_type_id] = @locationTypeId AND [location_id] != @locationId
	


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationDelete TO VpWebApp 
GO

----------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationInsert'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationInsert
	@vendorId int,
	@currencyId int,
	@locationTypeId int,
	@locationId int,
	@siteId int
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	
	INSERT INTO content_location (content_type_id, content_id, location_type_id, location_id, exclude,
		modified, created, enabled, site_id)
	SELECT 23, product_vendor_price_id, @locationTypeId, @locationId, 0, GETDATE(), GETDATE(), 1, @siteId 
	FROM product_to_vendor_to_price pvp	
	INNER JOIN product_to_vendor pv
	ON pv.product_to_vendor_id = pvp.product_to_vendor_id	
	WHERE pv.vendor_id = @vendorId AND pvp.currency_id = @currencyId AND pvp.product_vendor_price_id NOT IN 
	(SELECT content_id From content_location WHERE content_type_id = 23 AND content_id = pvp.product_vendor_price_id AND location_type_id = @locationTypeId AND location_id = @locationId)
	

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCurrencyLocationByVendorCurrencyLocationInsert TO VpWebApp 
GO

