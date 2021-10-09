
--===== adminSearch_UpdateSearchContentStatusUnIndexedDisabledArticles

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledArticles'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminSearch_UpdateSearchContentStatusUnIndexedDisabledArticles]
	@siteId int,
	@batchSize int,
	@totalCount int OUTPUT
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON
	
	UPDATE TOP(@batchSize) art 
	SET art.search_content_modified = 0
		,art.modified = GETDATE()
	FROM	dbo.article art WITH(NOLOCK)
	LEFT JOIN search_content_status scs WITH(NOLOCK) ON scs.content_id = art.article_id AND scs.content_type_id = 4
	WHERE scs.search_content_status_id IS NULL
	AND art.site_id = @siteId
	AND	art.published = 0
	AND art.search_content_modified = 1

	SET @totalCount = @@ROWCOUNT

END

GO

GRANT EXECUTE ON dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledArticles TO VpWebApp 
GO



--===== archived_product_to_vendor table

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='archived_product_to_vendor' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[archived_product_to_vendor](
		[archived_product_to_vendor_id] [int] IDENTITY(1,1) NOT NULL,
		archived_product_id INT NOT NULL,
		vendor_id INT NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	 CONSTRAINT [archived_product_to_vendor_id] PRIMARY KEY CLUSTERED 
	(
		[archived_product_to_vendor_id] ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY];

	ALTER TABLE [dbo].[archived_product_to_vendor]  WITH CHECK ADD  CONSTRAINT [FK_archived_product_vendor_archived_product] FOREIGN KEY([archived_product_id])
	REFERENCES [dbo].archived_product ([archived_product_id]);

	ALTER TABLE [dbo].[archived_product_to_vendor]  WITH CHECK ADD  CONSTRAINT [FK_archived_product_vendor_vendor] FOREIGN KEY([vendor_id])
	REFERENCES [dbo].vendor (vendor_id);

	ALTER TABLE [dbo].archived_product_to_vendor CHECK CONSTRAINT [FK_archived_product_vendor_archived_product];
	ALTER TABLE [dbo].archived_product_to_vendor CHECK CONSTRAINT [FK_archived_product_vendor_vendor];

END
GO

--===== adminArchivedProductVendor_AddArchivedProductVendor

EXEC dbo.global_DropStoredProcedure 'adminArchivedProductVendor_AddArchivedProductVendor';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminArchivedProductVendor_AddArchivedProductVendor]
    @archivedProductId INT,
    @vendorId INT,
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()


    INSERT INTO archived_product_to_vendor
    (
        archived_product_id,
        vendor_id,
        created,
		modified
    )
    VALUES
    (@archivedProductId, @vendorId, @created, @created);

    SET @id = SCOPE_IDENTITY();


END;
GO


GRANT EXECUTE ON dbo.adminArchivedProductVendor_AddArchivedProductVendor TO VpWebApp;
GO


--===== adminProduct_UpdateProductStatusByVendorId


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

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE TOP(@batchSize)   ap
		set is_restore = 1
		FROM archived_product ap
		INNER JOIN dbo.archived_product_to_vendor aptv on aptv.archived_product_id = ap.archived_product_id
		WHERE aptv.vendor_id = @vendorId
	END
	
	--todo
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

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE ap
		set is_restore = 1
		FROM archived_product ap
		INNER JOIN dbo.archived_product_to_vendor aptv on aptv.archived_product_id = ap.archived_product_id
		WHERE aptv.vendor_id = @vendorId
	END
END

END
GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductStatusByVendorId TO VpWebApp 
GO


--===== adminProduct_UpdateProductStatusByVendorId

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

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE TOP(@batchSize)   ap
		set ap.is_restore = 1
		FROM archived_product ap
		INNER JOIN dbo.archived_product_to_vendor aptv on aptv.archived_product_id = ap.archived_product_id
		WHERE aptv.vendor_id = @vendorId
	END
	
	--todo
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

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE ap
		set ap.is_restore = 1
		FROM archived_product ap
		INNER JOIN dbo.archived_product_to_vendor aptv on aptv.archived_product_id = ap.archived_product_id
		WHERE aptv.vendor_id = @vendorId
	END
END

END
GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductStatusByVendorId TO VpWebApp 
GO


--===== adminProduct_UpdateProductStatusByVendorId


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
	
	--todo
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


--===== adminProduct_GetArchivingProductIdsList



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10,
@lastProcessedProductId INT,
@vendorsWithMasterLeadTargets VARCHAR(MAX)
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
			LEFT JOIN dbo.product_parameter pp ON pp.product_id = pro.product_id AND pp.parameter_type_id = 187 --ProductRunStartDate
			--campaign content data
			LEFT JOIN campaign_content_data ccd ON ccd.content_id = pro.product_id
			LEFT JOIN campaign_type_content_group ctcg ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 2 --product
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id
	WHERE	pro.search_content_modified = 0 --elastic search processed
			--AND pro.content_modified = 0 --content update synced --todo temporary removed 
			AND pro.enabled = 0
			AND pro.archived = 1 
			AND pro.product_id > @lastProcessedProductId
			AND (ld.lead_id IS NULL OR ld.lead_state_type_id = 7) --lead sent
			AND (ptp.product_to_product_id IS NULL) --not parent product
			AND (pp.product_parameter_id IS NULL OR CAST(pp.product_parameter_value AS DATETIME) < GETDATE()) --no future enable date
			AND (ctcg.campaign_type_content_group_id IS NULL OR camp.status = 10) --only archived campaign content associations
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO
