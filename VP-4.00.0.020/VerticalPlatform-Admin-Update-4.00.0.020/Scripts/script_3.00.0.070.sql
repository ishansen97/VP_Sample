
--adminProduct_UpdateProductContentModifiedStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductContentModifiedStatus
	@productList VARCHAR(max),
	@contentModofied BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE p
	SET   p.content_modified = @contentModofied,
		p.search_content_modified = CASE WHEN @contentModofied = 1 THEN  1 ELSE p.search_content_modified end
	FROM [product] p
		INNER JOIN dbo.global_Split(@productList, ',') gs
		ON p.product_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductContentModifiedStatus TO VpWebApp 
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductContentModifiedStatus TO VpAPIUser 
GO


--adminProduct_UpdateProductStatusByVendorId
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
		content_modified = 1,
		search_content_modified = 1,
		archived = ~@vendorStatus	
	FROM product pl 
	INNER JOIN 
	product_to_vendor ptv ON pl.product_id = ptv.product_id 
	WHERE ptv.vendor_id = @vendorId AND pl.enabled != @vendorStatus

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE TOP(@batchSize) ap
		set ap.is_restore = 1
		FROM archived_product ap
			LEFT JOIN dbo.archived_product_to_vendor aptv on aptv.archived_product_id = ap.archived_product_id 
		WHERE aptv.vendor_id = @vendorId 
			OR ap.vendor_id = @vendorId
	END
	
END
ELSE 
BEGIN
	UPDATE product
	SET
		[enabled] = @vendorStatus,
		modified = @modified,
		content_modified = 1,
		search_content_modified = 1,
		archived = ~@vendorStatus	
	FROM product pl 
	INNER JOIN 
	product_to_vendor ptv ON pl.product_id = ptv.product_id 
	WHERE ptv.vendor_id = @vendorId AND pl.enabled != @vendorStatus

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE ap
		set ap.is_restore = 1
		FROM archived_product ap
			LEFT JOIN dbo.archived_product_to_vendor aptv on aptv.archived_product_id = ap.archived_product_id 
		WHERE aptv.vendor_id = @vendorId 
			OR ap.vendor_id = @vendorId
	END
END

END
GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductStatusByVendorId TO VpWebApp 
GO


--adminProduct_ChangeProductUpdateStatuses

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_ChangeProductUpdateStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_ChangeProductUpdateStatuses
	@productId INT,
	@searchContentmodified BIT,
	@contentModified BIT,
	@enabled BIT,
	@archived BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE product
	SET search_content_modified = @searchContentmodified, content_modified = @contentModified, enabled = @enabled, archived = @archived
	WHERE product_id = @productId 

END
GO

GRANT EXECUTE ON dbo.adminProduct_ChangeProductUpdateStatuses TO VpWebApp 
GO
