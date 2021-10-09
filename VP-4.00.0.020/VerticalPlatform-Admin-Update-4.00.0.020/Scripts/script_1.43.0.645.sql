IF NOT EXISTS(SELECT 1 FROM parameter_type WHERE parameter_type_id = 205)
BEGIN	
	INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES(205
			,'DisableFeaturedStatusofProducts'
			,1
			,GETDATE()
			,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM parameter_type WHERE parameter_type_id = 206)
BEGIN	
	INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES(206
			,'DisableFeaturedPlusStatusofProducts'
			,1
			,GETDATE()
			,GETDATE())
END

GO

--------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_UpdateFeaturedStatusOfVendorProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_UpdateFeaturedStatusOfVendorProducts
	@vendorId int,
	@siteId int,
	@currentStatus int,
	@newStatus int

AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	DECLARE @modified smalldatetime
	SET @modified = GETDATE()
	
	UPDATE product
	SET rank = @newStatus,
		modified = @modified		
	where product_id IN
	(
		SELECT product_id
		FROM product_to_vendor
		WHERE vendor_id = @vendorId	
	)
	AND site_id = @siteId AND rank = @currentStatus


END
GO

GRANT EXECUTE ON dbo.adminVendor_UpdateFeaturedStatusOfVendorProducts TO VpWebApp 
GO

----------------------------------------------------

GO

IF NOT EXISTS(SELECT 1 FROM parameter_type WHERE parameter_type_id = 207)
BEGIN	
	INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES(207
			,'FeaturedDisplayText'
			,1
			,GETDATE()
			,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM parameter_type WHERE parameter_type_id = 208)
BEGIN	
	INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES(208
			,'FeaturedPlusDisplayText'
			,1
			,GETDATE()
			,GETDATE())
END

GO
