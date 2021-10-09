EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_AddIpAddress'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_AddIpAddress
	@id int output,
	@ipAddress varchar(50),
	@ipNumeric bigint,
	@requestIpGroupId int,
	@blocked int,
	@description varchar(1000),
	@accessCode varchar(1000),
	@country varchar(250),
	@owner varchar(500),
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO spider_ip_address(ip_address, ip_numeric,ip_group_id, blocked_status, description,access_code, enabled, modified, created, country, [owner])
	VALUES (@ipAddress, @ipNumeric, @requestIpGroupId, @blocked, @description, @accessCode, @enabled, @created, @created, @country, @owner)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_AddIpAddress TO VpWebApp 
GO
--------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCountByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCountByCategoryId
	@categoryId int, @productStatus int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF(@productStatus = 2)
		BEGIN
			SELECT COUNT(product_id)
			FROM product_to_category
			WHERE category_id = @categoryId
		END
	ELSE
		BEGIN
			SELECT COUNT(*) [count]
			FROM product_to_category ptc
			INNER JOIN product p
				ON p.product_id = ptc.product_id
			WHERE ptc.category_id = @categoryId
				AND p.[enabled] = @productStatus
		END	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCountByCategoryId TO VpWebApp 

---------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCountByVendorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCountByVendorId
	@vendorId int, @productStatus int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF(@productStatus = 2)
		BEGIN
			SELECT COUNT(*) [count]
			FROM product_to_vendor
			WHERE vendor_id = @vendorId
		END
	ELSE
		BEGIN
			SELECT COUNT(*) [count]
			FROM product_to_vendor ptv
			INNER JOIN product p
				ON p.product_id = ptv.product_id
			WHERE ptv.vendor_id = @vendorId
				AND p.[enabled] = @productStatus
		END	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCountByVendorId TO VpWebApp
GO