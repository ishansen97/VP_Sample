

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[product_tracking]') 
         AND name = 'referring_url'
)
BEGIN

ALTER TABLE [dbo].[product_tracking]
ADD [referring_url] varchar(1000) NOT NULL DEFAULT('')

END
GO

------------

IF EXIStS(
	SELECT * 
	FROM sys.foreign_keys 
	WHERE object_id = OBJECT_ID(N'dbo.FK_product_tracking_product_id')
	AND parent_object_id = OBJECT_ID(N'dbo.product_tracking')
	)
BEGIN

ALTER TABLE [dbo].[product_tracking] DROP CONSTRAINT [FK_product_tracking_product_id]

END
GO
-------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProductTracking_AddProductTrackingInfo'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProductTracking_AddProductTrackingInfo
	@productId int,
	@categoryId int,
	@actionId int,
	@vendorId int,
	@countryCode varchar(100),
	@source varchar(500),
	@userId int,
	@userAgentName varchar(500),
	@ip varchar(39),
	@userLanguages varchar(500),
	@enabled bit,
	@referringUrl varchar(1000),
	@created smalldatetime output,
	@id int output
AS
-- ==========================================================================
-- $Date: 2021-03-02 $ 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

INSERT INTO [dbo].[product_tracking]
           ([product_id],[category_id],[action_id],[vendor_id],[enabled],[country_code],[source],[user_id]
           ,[useragent_name],[ip],[user_languages],[created],[modified],[referring_url])
     VALUES
           (@productId,@categoryId,@actionId,@vendorId,@enabled,@countryCode,@source, @userId
           ,@userAgentName,@ip,@userLanguages,@created,@created,@referringUrl)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.publicProductTracking_AddProductTrackingInfo TO VpWebApp 
GO
