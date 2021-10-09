----------------Add module --------------------
IF NOT EXISTS ( SELECT 1 FROM [dbo].[module] WHERE [module_name] = 'ProductTracking'  )
BEGIN
   INSERT INTO [dbo].[module]
           ([module_name]
           ,[usercontrol_name]
           ,[enabled]
           ,[modified]
           ,[created]
           ,[is_container])
     VALUES
           ('ProductTracking'
           ,'~/Modules/Page/ProductTracking.ascx'
           ,1
           ,GETDATE()
           ,GETDATE()
           ,0
		   )
END

GO

----------------Add predifined page --------------------
IF NOT EXISTS ( SELECT 1 FROM [dbo].[predefined_page] WHERE [page_name] = 'ProductTracking'  )
BEGIN
INSERT INTO [dbo].[predefined_page]
           ([page_name]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           ('ProductTracking'
           ,1
           ,GETDATE()
           ,GETDATE())
END

GO

----------------Add product_tracking table --------------------
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'product_tracking')
BEGIN
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [dbo].[product_tracking](
		[product_tracking_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
		[product_id] [int] NOT NULL,
		[category_id] [int] NOT NULL,
		[action_id] [int] NOT NULL,
		[vendor_id] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[country_code] [varchar](100) NULL,
		[source] [varchar](500) NOT NULL,
		[user_id] [int] NOT NULL,
		[useragent_name] [varchar](500) NOT NULL,
		[ip] [varchar](39) NOT NULL,
		[user_languages] [varchar](500) NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL
	 CONSTRAINT [PK_product_tracking] PRIMARY KEY NONCLUSTERED 
	(
		[product_tracking_id] ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[product_tracking]  WITH CHECK ADD  CONSTRAINT [FK_product_tracking_product_id] FOREIGN KEY([product_id])
	REFERENCES [dbo].[product] ([product_id])
	ALTER TABLE [dbo].[product_tracking] CHECK CONSTRAINT [FK_product_tracking_product_id]

	ALTER TABLE [dbo].[product_tracking]  WITH CHECK ADD  CONSTRAINT [FK_product_tracking_category_id] FOREIGN KEY(category_id)
	REFERENCES [dbo].[category] (category_id)
	ALTER TABLE [dbo].[product_tracking] CHECK CONSTRAINT [FK_product_tracking_category_id]

	ALTER TABLE [dbo].[product_tracking]  WITH CHECK ADD  CONSTRAINT [FK_product_tracking_action_id] FOREIGN KEY(action_id)
	REFERENCES [dbo].[action] (action_id)
	ALTER TABLE [dbo].[product_tracking] CHECK CONSTRAINT [FK_product_tracking_action_id]

	ALTER TABLE [dbo].[product_tracking]  WITH CHECK ADD  CONSTRAINT [FK_product_tracking_vendor_id] FOREIGN KEY(vendor_id)
	REFERENCES [dbo].[vendor] (vendor_id)
	ALTER TABLE [dbo].[product_tracking] CHECK CONSTRAINT [FK_product_tracking_vendor_id]

END

---------Add SP ---------------



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
           ,[useragent_name],[ip],[user_languages],[created],[modified])
     VALUES
           (@productId,@categoryId,@actionId,@vendorId,@enabled,@countryCode,@source, @userId
           ,@userAgentName,@ip,@userLanguages,@created,@created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.publicProductTracking_AddProductTrackingInfo TO VpWebApp 
GO