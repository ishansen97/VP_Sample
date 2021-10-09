EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductLocations'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductLocations
	@productId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- $Author: Chinthaka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE product 
	SET
		modified = GETDATE(),
		flag1 = @countryFlag1,
		flag2 = @countryFlag2,
		flag3 = @countryFlag3,
		flag4 = @countryFlag4
	WHERE product_id = @productId
END
GO 	

GRANT EXECUTE ON dbo.adminProduct_UpdateProductLocations TO VpWebApp
GO


