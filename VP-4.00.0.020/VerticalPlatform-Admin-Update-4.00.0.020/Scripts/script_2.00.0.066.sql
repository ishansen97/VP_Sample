
--==== adminProduct_RestoreProductVendorPrice

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RestoreProductVendorPrice'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RestoreProductVendorPrice
	@productVendorPriceId int,
	@productVendorId int,
	@currencyId int,
	@price money,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@enabled bit,
	@created DATETIME
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET IDENTITY_INSERT product_to_vendor_to_price ON

	INSERT INTO product_to_vendor_to_price (product_vendor_price_id,product_to_vendor_id, currency_id, price, 
		country_flag1, country_flag2, country_flag3, country_flag4, enabled, created, modified)
	VALUES (@productVendorPriceId,@productVendorId, @currencyId, @price, @countryFlag1, @countryFlag2, 
		@countryFlag3, @countryFlag4, @enabled, @created, @created)

	SET IDENTITY_INSERT product_to_vendor_to_price OFF

END
GO

GRANT EXECUTE ON dbo.adminProduct_RestoreProductVendorPrice TO VpWebApp 
GO


