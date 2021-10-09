
--==== adminProduct_UpdateProductStatusByVendorId

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
-- Author : Chinthaka
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
		modified = @modified,
		archived = ~@vendorStatus	
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
		modified = @modified,
		archived = ~@vendorStatus	
	FROM product pl 
	INNER JOIN 
	product_to_vendor ptv ON pl.product_id = ptv.product_id 
	WHERE ptv.vendor_id = @vendorId AND pl.enabled != @vendorStatus
END

END
GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductStatusByVendorId TO VpWebApp 
GO


--===== adminProduct_GetArchivingProductIdsList


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) pro.[product_id] AS [id]
	FROM	product pro
			LEFT JOIN lead ld on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
			LEFT JOIN dbo.product_to_product ptp ON ptp.parent_product_id = pro.product_id
	WHERE	pro.search_content_modified = 0 --elastic search processed
			AND pro.content_modified = 0 --content update synced
			AND pro.archived = 1 
			AND (ld.lead_id IS NULL OR ld.lead_status_id = 4) --lead sent
			AND (ptp.product_to_product_id IS NULL) --not parent product
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO
