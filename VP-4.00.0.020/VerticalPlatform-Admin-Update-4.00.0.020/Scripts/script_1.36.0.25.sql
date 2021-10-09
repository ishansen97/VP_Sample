EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductVendorByVendorIdBatchSize'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductVendorByVendorIdBatchSize
	@vendorId int,
	@batchSize int,
	@enabledStatus bit
AS

-- ==========================================================================
-- Author : Dimuthu
-- ==========================================================================

BEGIN

SET NOCOUNT ON;

IF (@batchSize IS NULL)
BEGIN
	SELECT	product_to_vendor_id AS id, ptv.product_id, vendor_id, is_manufacturer, is_seller
			, show_get_quote, lead_enabled, ptv.[enabled], ptv.created, ptv.modified
	FROM product_to_vendor ptv
	INNER JOIN product p ON  p.product_id = ptv.product_id AND p.enabled  = @enabledStatus
	WHERE vendor_id = @vendorId
END
ELSE
BEGIN
	SELECT TOP(@batchSize) 
			product_to_vendor_id AS id, ptv.product_id, vendor_id, is_manufacturer, is_seller
			, show_get_quote, lead_enabled, ptv.[enabled], ptv.created, ptv.modified
	FROM product_to_vendor ptv
	INNER JOIN product p ON  p.product_id = ptv.product_id AND p.enabled  = @enabledStatus
	WHERE vendor_id = @vendorId
END


END
GO
GRANT EXECUTE ON dbo.adminProduct_GetProductVendorByVendorIdBatchSize TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductStatusByVendorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_UpdateProductStatusByVendorId]
	@vendorId int,
	@vendorStatus bit,
	@batchSize int = NULL	
AS
-- ==========================================================================
-- Author : Dimuthu
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @modified smalldatetime 
	SET @modified = GETDATE() 	

IF(@batchSize IS NOT NULL)
BEGIN
	UPDATE TOP(@batchSize) product
	SET
		[enabled] = @vendorStatus,
		modified = @modified	
	FROM product pl 
	INNER JOIN 
	product_to_vendor ptv ON pl.product_id = ptv.product_id 
	WHERE ptv.vendor_id = @vendorId AND pl.enabled != @vendorStatus
END
ELSE 
BEGIN
	UPDATE product
	SET
		[enabled] = @vendorStatus,
		modified = @modified	
	FROM product pl 
	INNER JOIN 
	product_to_vendor ptv ON pl.product_id = ptv.product_id 
	WHERE ptv.vendor_id = @vendorId AND pl.enabled != @vendorStatus
END

END
GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductStatusByVendorId TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCountByEnabledStatusVendorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCountByEnabledStatusVendorId
	@vendorId INT,
	@enabled INT
AS

-- ==========================================================================

-- $Author: Dimuthu $

-- ==========================================================================

BEGIN

	SET NOCOUNT ON;

	SELECT COUNT(*) [count]
	FROM product_to_vendor ptv
	INNER JOIN product p ON p.product_id = ptv.product_id
	WHERE ptv.vendor_id = @vendorId AND p.enabled = @enabled 

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCountByEnabledStatusVendorId TO VpWebApp 
GO