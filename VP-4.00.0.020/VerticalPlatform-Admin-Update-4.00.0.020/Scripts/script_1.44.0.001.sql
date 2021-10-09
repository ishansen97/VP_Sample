-- ==========================================================================
-- $URL: l $
-- $Revision: VP archive solution $
-- $Date: 2020-02-19 22:27:33.430 $ 
-- $Author: roshan $
-- ==========================================================================

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'archived' AND Object_ID = Object_ID(N'product'))
BEGIN
    ALTER	TABLE product
	ADD		archived BIT NOT NULL DEFAULT 0,
		content_modified BIT NOT NULL DEFAULT 0;	
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'archived' AND Object_ID = Object_ID(N'article'))
BEGIN
	ALTER	TABLE article
	ADD		archived BIT NOT NULL DEFAULT 0;
END
GO



--archived_product table

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='archived_product' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[archived_product](
		[archived_product_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
		product_id INT UNIQUE NOT NULL,
		[site_id] [int] NOT NULL,
		[vendor_id] [int] NOT NULL,
		[catalog_number] [varchar](255) NULL,
		[product_name] [varchar](500) NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		is_restore BIT DEFAULT 0 NOT NULL
	 CONSTRAINT [archived_product_id] PRIMARY KEY CLUSTERED 
	(
		[archived_product_id] ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY];

	ALTER TABLE [dbo].[archived_product]  WITH CHECK ADD  CONSTRAINT [FK_archived_product_site] FOREIGN KEY([site_id])
	REFERENCES [dbo].[site] ([site_id]);

	ALTER TABLE [dbo].[archived_product]  WITH CHECK ADD  CONSTRAINT [FK_archived_product_vendor] FOREIGN KEY([vendor_id])
	REFERENCES [dbo].[vendor] ([vendor_id]);

	ALTER TABLE [dbo].[archived_product] CHECK CONSTRAINT [FK_archived_product_site];
	ALTER TABLE [dbo].[archived_product] CHECK CONSTRAINT [FK_archived_product_vendor];

END
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) pro.[product_id] AS [id]
	FROM	product pro
			left join lead ld on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
	WHERE	pro.search_content_modified = 0 --elastic search processed
			AND pro.content_modified = 0 --content update synced
			AND pro.archived = 1 
			AND (ld.lead_id IS NULL OR ld.lead_status_id = 4) --lead sent
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProduct
	@id int, 
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank float,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank float
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE product 
	SET
		site_id = @siteId,
		product_name = @productName,
		rank = @rank,
		has_image = @hasImage,
		catalog_number = @catalogNumber,
		[enabled] = @enabled,
		modified = @modified,
		product_type = @productType,
		status = @status,
		has_related = @hasRelated,
		has_model = @hasModel,
		completeness = @completeness,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		search_rank = @searchRank,
		search_content_modified = @searchContentModified,
		hidden = @hidden,
		business_value = @businessValue,
		ignore_in_rapid = @ignoreInRapid,
		show_in_matrix = @showInMatrix,
		show_detail_page = @showDetailPage,
		default_rank = @defaultRank,
		default_search_rank = @defaultSearchRank,
		content_modified = 1, --alwyas sets content modified flag  = 1
		archived = ~@enabled
		
		
	WHERE product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProduct TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'adminArchivedProduct_AddArchivedProduct';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminArchivedProduct_AddArchivedProduct]
    @productId INT,
    @siteId INT,
	@vendorId INT,
    @catalogNumber VARCHAR(255),
    @productName VARCHAR(500),
    @isRestore BIT,
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()


    INSERT INTO archived_product
    (
        product_id,
        site_id,
		vendor_id,
        catalog_number,
        product_name,
        created,
		modified,
        is_restore
    )
    VALUES
    (@productId, @siteId, @vendorId, @catalogNumber, @productName, @created, @created, @isRestore);

    SET @id = SCOPE_IDENTITY();


END;
GO


GRANT EXECUTE ON dbo.adminArchivedProduct_AddArchivedProduct TO VpWebApp;
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RemoveArchivedProductandRelations';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET XACT_ABORT ON;
GO
CREATE PROCEDURE dbo.adminProduct_RemoveArchivedProductandRelations @productId INT
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        DELETE propri
        FROM dbo.product pro
            INNER JOIN product_to_vendor proven
                ON proven.product_id = pro.product_id
            INNER JOIN dbo.product_to_vendor_to_price propri
                ON propri.product_to_vendor_id = proven.product_to_vendor_id
        WHERE pro.product_id = @productId;

        DELETE FROM product_to_vendor
        WHERE product_id = @productId;

        DELETE FROM product_to_search_option
        WHERE product_id = @productId;

        DELETE FROM product_to_category
        WHERE product_id = @productId;

        DELETE FROM product_display_status
        WHERE product_id = @productId;

        DELETE FROM citation
        WHERE product_id = @productId;

        DELETE FROM model
        WHERE product_id = @productId;

        DELETE FROM product_to_product
        WHERE product_id = @productId;

        DELETE FROM product_to_url
        WHERE product_id = @productId;

        DELETE FROM product_compression_group_to_product
        WHERE product_id = @productId;


		DELETE pmis
		FROM  product_multimedia_item pmi 
		INNER JOIN product_multimedia_item_setting pmis on pmis.product_multimedia_item_id = pmi.product_multimedia_item_id
        WHERE pmi.product_id = @productId;


        DELETE FROM product_multimedia_item
        WHERE product_id = @productId;

        DELETE FROM product_parameter
        WHERE product_id = @productId;

		DELETE FROM dbo.specification
		WHERE content_id = @productId AND content_type_id = 2

		DELETE ctcs
		FROM [dbo].[content_to_content_setting] ctcs
		INNER JOIN [dbo].[content_to_content] ctc ON ctc.content_to_content_id = ctcs.content_to_content_id
		WHERE (ctc.content_id = @productId 
		AND	ctc.content_type_id = 2) OR ( ctc.associated_content_id = @productId 
		AND	ctc.associated_content_type_id = 2)

		DELETE	
		FROM [dbo].[content_to_content]
		WHERE (content_id = @productId 
		AND	content_type_id = 2) OR ( associated_content_id = @productId 
		AND	associated_content_type_id = 2)

		DELETE FROM dbo.product WHERE product_id = @productId

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RETURN ERROR_MESSAGE();
    END CATCH;


END;
GO

GRANT EXECUTE
ON dbo.adminProduct_RemoveArchivedProductandRelations
TO  VpWebApp;
GO




EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedBySpecification'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedBySpecification]
                       
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN	

	UPDATE	pro
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product pro
			INNER JOIN specification spec 
	ON		spec.content_id = pro.product_id and spec.content_type_id = 2 

	WHERE	(@taskLastRunDate IS NULL OR spec.modified > @taskLastRunDate)
			AND pro.content_modified = 0
			AND pro.archived = 0
	
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedBySpecification TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProduct]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN

	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
	WHERE	(@taskLastRunDate IS NULL OR PRO.modified > @taskLastRunDate) 
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProduct TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductToVendorToPrice'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductToVendorToPrice]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	UPDATE	pro
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product pro
			INNER JOIN
			product_to_vendor AS PTV
			ON PRO.product_id = PTV.product_id
			INNER JOIN
			product_to_vendor_to_price AS PTVTP
			ON PTV.product_to_vendor_id = PTVTP.product_to_vendor_id
	WHERE	(@taskLastRunDate IS NULL OR PTVTP.modified > @taskLastRunDate)
			AND pro.content_modified = 0
			AND pro.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductToVendorToPrice TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByCitation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByCitation]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
		
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			citation C
			ON PRO.product_id = C.product_id
	WHERE	(@taskLastRunDate IS NULL OR C.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByCitation TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductToVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductToVendor]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	pro
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product pro
			INNER JOIN
			product_to_vendor AS ptv
			ON pro.product_id = ptv.product_id
	WHERE	(@taskLastRunDate IS NULL OR ptv.modified > @taskLastRunDate)
			AND pro.content_modified = 0
			AND pro.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductToVendor TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductToUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductToUrl]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_to_url PTU
			ON PRO.product_id = PTU.product_id
	WHERE	(@taskLastRunDate IS NULL OR PTU.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductToUrl TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductToProduct]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
		

	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_to_product PTP
			ON PRO.product_id = PTP.product_id
	WHERE	(@taskLastRunDate IS NULL OR PTP.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductToProduct TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductToSerachOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductToSerachOption]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN

	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
							
	FROM
	(
	SELECT DISTINCT PTSO.product_id
	FROM	
			product_to_search_option PTSO			
	WHERE	(@taskLastRunDate IS NULL OR PTSO.modified > @taskLastRunDate )
			
	) A
	
	LEFT JOIN 
	product PRO ON PRO.product_id = A.product_id
	WHERE PRO.content_modified = 0 AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductToSerachOption TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductParameter]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_parameter PP
			ON PRO.product_id = PP.product_id
	WHERE	(@taskLastRunDate IS NULL OR PP.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductParameter TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductDisplayStatus]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_display_status PDS
			ON PRO.product_id = PDS.product_id
	WHERE	(@taskLastRunDate IS NULL OR PDS.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductDisplayStatus TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductToCategory'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductToCategory]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_to_category PTC
			ON PRO.product_id = PTC.product_id
	WHERE	(@taskLastRunDate IS NULL OR PTC.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductToCategory TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductToArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductToArticle]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_to_article PA
			ON PRO.product_id = PA.product_id
	WHERE	(@taskLastRunDate IS NULL OR PA.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductToArticle TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByMultimediaItemSetting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByMultimediaItemSetting]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_multimedia_item PMI
			ON PRO.product_id = PMI.product_id
			INNER JOIN
			product_multimedia_item_setting PMIS
			ON PMI.product_multimedia_item_id = PMIS.product_multimedia_item_id
	WHERE	(@taskLastRunDate IS NULL OR PMIS.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByMultimediaItemSetting TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductMultimediaItem'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductMultimediaItem]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_multimedia_item PMI
			ON PRO.product_id = PMI.product_id
	WHERE	(@taskLastRunDate IS NULL OR PMI.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductMultimediaItem TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByModel'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByModel]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
	
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			model M
			ON PRO.product_id = M.product_id
	WHERE	(@taskLastRunDate IS NULL OR M.modified > @taskLastRunDate)
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByModel TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_UpdateProductContentModifiedByProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminScheduler_UpdateProductContentModifiedByProductCompressionGroup]
@taskLastRunDate DATETIME
AS
-- ==========================================================================
-- $Author: Suranga Deshapriya $
-- ==========================================================================
BEGIN
		
	UPDATE	PRO
	SET		PRO.content_modified = PRO.enabled,
			PRO.archived = 1 ^ PRO.enabled
	FROM	dbo.product PRO
			INNER JOIN
			product_compression_group_to_product PCGP
			ON PRO.product_id = PCGP.product_id
	WHERE	(@taskLastRunDate IS NULL OR PCGP.modified > @taskLastRunDate )
			AND PRO.content_modified = 0
			AND PRO.archived = 0
END

GO

GRANT EXECUTE ON dbo.adminScheduler_UpdateProductContentModifiedByProductCompressionGroup TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_ProductSyncPopulateData'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_ProductSyncPopulateData
	@product_id int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [product_id],[site_id],[product_name],[rank],[has_image],[catalog_number],[enabled],[created],[product_type],[status],[has_model]
      ,[has_related],[flag1],[flag2],[flag3],[flag4],[completeness],[search_rank],[legacy_content_id],[search_content_modified],[hidden]
      ,[business_value],[ignore_in_rapid],[show_in_matrix],[show_detail_page],[default_rank],[default_search_rank]
	FROM [dbo].[product] with (nolock)
	where [product_id] = @product_id

	SELECT [product_id],[title],[journal_name],[published_date],[scrazzl_url],[article_url],[doi],[enabled],[created],[authors],[pubmed_url],[pubmed_id]
	FROM [dbo].[citation] with (nolock)
	where [product_id] = @product_id

	SELECT [model_id],[name],[product_id],[enabled],[created],[display_order],[catalog_number]
	FROM [dbo].[model]  with (nolock)
	where [product_id] = @product_id

	SELECT [product_compression_group_id],[product_id],[enabled],[created]
	FROM [dbo].[product_compression_group_to_product]  with (nolock)
	where [product_id] = @product_id

	SELECT [product_id],[start_date],[end_date],[new_rank],[enabled],[created],[search_rank],[include]
	FROM [dbo].[product_display_status] with (nolock)
	where [product_id] = @product_id

	SELECT [product_multimedia_item_id],[product_id],[type],[title],[thumbnail_link],[sort_order],[enabled],[created]
	FROM [dbo].[product_multimedia_item]  with (nolock)
	where [product_id] = @product_id

	SELECT pmis.[product_multimedia_item_id],pmis.[name],pmis.[value],pmis.[enabled],pmis.[created]
	FROM [dbo].[product_multimedia_item_setting] pmis with (nolock) join 
	[dbo].[product_multimedia_item] pmi with (nolock) on pmi.[product_multimedia_item_id] = pmis.[product_multimedia_item_id]
	where pmi.[product_id] = @product_id

	SELECT [product_id],[parameter_type_id],[product_parameter_value],[enabled],[created]
	FROM [dbo].[product_parameter] with (nolock)
	where [product_id] = @product_id

  	SELECT pc.[category_id],cat.[category_name],pc.[product_id],pc.[enabled],pc.[created]
	FROM [dbo].[product_to_category] pc with (nolock) join 
	[dbo].[category] cat with (nolock) on cat.[category_id] = pc.[category_id]
	where [product_id] = @product_id

	SELECT [parent_product_id],[product_id],[enabled],[created],[sort_order]
	FROM [dbo].[product_to_product] with (nolock)
	where [product_id] = @product_id

	SELECT [product_id],[url_id],[country_flag1],[country_flag2],[country_flag3],[country_flag4],[enabled],[created]
	FROM [dbo].[product_to_url] with (nolock)
	where [product_id] = @product_id

	SELECT [product_to_vendor_id],[product_id],[vendor_id],[is_manufacturer],[is_seller],[show_get_quote],[enabled],[created],[lead_enabled]
	FROM [dbo].[product_to_vendor] with (nolock)
	where [product_id] = @product_id

	SELECT  pvp.[product_vendor_price_id],pvp.[product_to_vendor_id],pvp.[currency_id],pvp.[price],pvp.[country_flag1],
		pvp.[country_flag2],pvp.[country_flag3],pvp.[country_flag4],pvp.[enabled],pvp.[created]
	FROM [dbo].[product_to_vendor] pv with (nolock) join  
	[dbo].[product_to_vendor_to_price] pvp with (nolock) on pvp.[product_to_vendor_id] = pv.[product_to_vendor_id]
	where pv.[product_id] = @product_id

	SELECT [action_url_id],[action_id],[action_url],[content_type_id],[content_id],[enabled],[created],[modified],[new_window],[flag1],[flag2],[flag3],[flag4]
	FROM [dbo].[action_url] with (nolock)
	where [content_id] = @product_id and [content_type_id] = 2

	SELECT [fixed_url_id],[fixed_url],[site_id],[page_id],[content_type_id],[content_id],[query_string],[enabled],[created],[include_in_sitemap]
	FROM [dbo].[fixed_url] with (nolock)
	where [content_id] = @product_id and [content_type_id] = 2

	SELECT fus.[fixed_url_setting_id],fus.[fixed_url_id],fus.[fixed_url_setting_key],fus.[fixed_url_setting_value],fus.[enabled],fus.[created],fus.[site_id]
	FROM [dbo].[fixed_url] fu with (nolock) join 
	[dbo].[fixed_url_setting] fus with(nolock) on  fus.[fixed_url_id] = fu.[fixed_url_id]
	where fu.[content_type_id] = 2 and fu.[content_id] =  @product_id

	SELECT lfu.[legacy_fixed_url_id],lfu.[fixed_url_id],lfu.[legacy_fixed_url],lfu.[query_string],lfu.[enabled],lfu.[created]
	FROM [dbo].[legacy_fixed_url] lfu with(nolock) join
	[dbo].[fixed_url] fu with(nolock) on  fu.[fixed_url_id] = lfu.[fixed_url_id]
	where fu.[content_type_id] = 2 and fu.[content_id] =  @product_id

  	SELECT sp.[specification_id],sp.[content_id],sp.[spec_type_id],spt.[spec_type] as 'spec_type_name', sp.[specification],sp.[enabled],
		sp.[created],sp.[content_type_id],sp.[display_options],sp.[sort_order]
	FROM [dbo].[specification] sp with(nolock) join 
	[dbo].[specification_type] spt with(nolock) on  spt.[spec_type_id] = sp.[spec_type_id]
	where [content_id] =  @product_id and [content_type_id] = 2

	SELECT ptso.[product_id],ptso.[search_option_id],so.[name] as 'search_option_name',ptso.[enabled],ptso.[created],ptso.[locked]
	FROM [dbo].[product_to_search_option] ptso with(nolock) join
	[dbo].[search_option] so with(nolock) on so.[search_option_id] = ptso.[search_option_id]
	where [product_id] = @product_id
	
	--content_to_content
	SELECT [content_to_content_id],[content_id],[content_type_id],[associated_content_id],[associated_content_type_id],
		[enabled],[created],[modified],[site_id],[associated_site_id],[sort_order]
	FROM [dbo].[content_to_content]
	WHERE (content_id = @product_id 
	AND	content_type_id = 2) OR ( associated_content_id = @product_id 
	AND	associated_content_type_id = 2)


	--content_to_content_setting
	SELECT ctcs.[content_to_content_setting_id],ctcs.[content_to_content_id],ctcs.[setting_name],ctcs.[setting_value],
		ctcs.[enabled],ctcs.[created],ctcs.[modified]
	FROM [dbo].[content_to_content_setting] ctcs
	INNER JOIN [dbo].[content_to_content] ctc ON ctc.content_to_content_id = ctcs.content_to_content_id
	WHERE (ctc.content_id = @product_id 
	AND	ctc.content_type_id = 2) OR ( ctc.associated_content_id = @product_id 
	AND	ctc.associated_content_type_id = 2)
   

END
GO

GRANT EXECUTE ON dbo.adminProduct_ProductSyncPopulateData TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetModifiedProductIdsForProductSync'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetModifiedProductIdsForProductSync
	@limit int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	Select distinct top (@limit) p.product_id as id
	from product p with(nolock)
	where 
	--p.search_content_modified = 0 and 
	p.content_modified = 1

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetModifiedProductIdsForProductSync TO VpWebApp 
GO






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
	SET   p.content_modified = @contentModofied
	FROM [product] p
		INNER JOIN dbo.global_Split(@productList, ',') gs
		ON p.product_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductContentModifiedStatus TO VpWebApp 
GO





