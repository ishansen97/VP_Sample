IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'restore_disabled'
          AND Object_ID = Object_ID(N'archived_product'))
BEGIN
    ALTER TABLE dbo.archived_product
    ADD restore_disabled BIT NOT NULL
	DEFAULT (0)
END

GO


--=== adminProduct_RestoreProduct

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RestoreProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RestoreProduct
	@productId int,
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@created DATETIME,
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
	@defaultSearchRank FLOAT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET IDENTITY_INSERT [product] ON

	DECLARE @modified AS DATETIME = GETDATE()

	INSERT INTO product(product_id, site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank, archived) 
	VALUES (@productId,@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @modified, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue,@ignoreInRapid, @showInMatrix, @showDetailPage, @defaultRank, @defaultSearchRank, ~@enabled) 

	SET IDENTITY_INSERT [product] OFF

END

GO

GRANT EXECUTE ON dbo.adminProduct_RestoreProduct TO VpWebApp 
GO

--=== adminArchivedProduct_AddArchivedProduct

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
    @isRestoreError BIT,
	@id INT OUTPUT,
	@created smalldatetime OUTPUT,
	@restoreDisabled BIT
AS
-- ==========================================================================
-- Author : Chinthaka
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
        is_restore,
		is_restore_error,
		restore_disabled
    )
    VALUES
    (@productId, @siteId, @vendorId, @catalogNumber, @productName, @created, @created, @isRestore, @isRestoreError,@restoreDisabled);

    SET @id = SCOPE_IDENTITY();


END;
GO


GRANT EXECUTE ON dbo.adminArchivedProduct_AddArchivedProduct TO VpWebApp;
GO


--==== adminArchivedProduct_GetArchivedProductsDetail

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductsDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductsDetail
	@id int
AS
-- ==========================================================================
-- $Date: 2020-03-17 
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [archived_product_id] as Id
	  ,[product_id]
	  ,[site_id]
	  ,[vendor_id]
	  ,[catalog_number]
	  ,[product_name]
	  ,[modified]
	  ,[created]
	  ,[is_restore]
	  ,is_restore_error
	  ,restore_disabled
	  ,CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product]
	WHERE archived_product_id = @id 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsDetail TO VpWebApp 
GO


--==== adminArchivedProduct_UpdateArchivedProduct

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_UpdateArchivedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_UpdateArchivedProduct
	@id int,
	@productId int,
	@siteId int,
	@vendorId int,
	@catalogNumber varchar(255),
	@productName varchar(500),
	@isRestore bit,
	@isRestoreError BIT,
	@restoreDisabled BIT,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE [dbo].[archived_product]
	   SET [product_id] = @productId
		  ,[site_id] = @siteId
		  ,[vendor_id] = @vendorId
		  ,[catalog_number] = @catalogNumber
		  ,[product_name] = @productName
		  ,[modified] = @modified
		  ,[is_restore] = @isRestore
		  ,is_restore_error = @isRestoreError
		  ,restore_disabled = @restoreDisabled
	WHERE archived_product_id = @id
 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_UpdateArchivedProduct TO VpWebApp 
GO


--==== adminArchivedProduct_GetArchivedProductsPageList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductsPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductsPageList
	@vendorId int = -1,
	@catalogNumber varchar(255) = '',
	@productName varchar(255) = '',
	@categoryId int = 0,
	@startIndex int,
	@endIndex int,
	@totalCount int OUTPUT

AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY Tmp.id) AS row , Tmp.id AS id
	INTO #temp
	FROM
	(
		SELECT DISTINCT ar.archived_product_id AS id
		FROM [dbo].[archived_product] ar WITH(NOLOCK) 
			 LEFT	JOIN dbo.archived_product_to_category arp ON arp.archived_product_id = ar.archived_product_id
		WHERE (@vendorId = -1 OR ar.vendor_id = @vendorId)
		AND (@catalogNumber = '' OR ar.catalog_number LIKE '%'+ @catalogNumber + '%')
		AND (@productName = '' OR ar.product_name LIKE '%'+ @productName +'%')
		AND (@categoryId = 0 OR (arp.category_id = @categoryId))
	)Tmp
	
	SELECT ap.[archived_product_id] as Id
		  ,ap.[product_id]
		  ,ap.[site_id]
		  ,ap.[vendor_id]
		  ,ap.[catalog_number]
		  ,ap.[product_name]
		  ,ap.[modified]
		  ,ap.[created]
		  ,ap.[is_restore]
		  ,ap.is_restore_error
		  ,ap.restore_disabled
		  , CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product] as ap with(nolock) 
	INNER JOIN  #temp ON #temp.id = ap.archived_product_id
	WHERE #temp.row BETWEEN @startIndex AND @endIndex;
	
	SELECT @totalCount = COUNT(*) FROM #temp;
END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsPageList TO VpWebApp 
GO

--===== adminArchivedProduct_GetArchivedProductByProductId

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductByProductId
	@productId int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [archived_product_id] as Id
	  ,[product_id]
	  ,[site_id]
	  ,[vendor_id]
	  ,[catalog_number]
	  ,[product_name]
	  ,[modified]
	  ,[created]
	  ,[is_restore]
	  ,is_restore_error
	  ,restore_disabled
	  ,CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product]
	WHERE product_id = @productId 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductByProductId TO VpWebApp 
GO


--===== adminProduct_ProductSyncPopulateData

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


--==== adminProduct_RemoveArchivedProductandRelations

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
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

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


		DELETE FROM product_to_search_option
        WHERE product_id = @productId;
		
		DELETE FROM dbo.specification
		WHERE content_id = @productId AND content_type_id = 2

		DELETE lfu
		FROM [dbo].[legacy_fixed_url] lfu join
		[dbo].[fixed_url] fu on  fu.[fixed_url_id] = lfu.[fixed_url_id]
		where fu.[content_type_id] = 2 and fu.[content_id] =  @productId


		DELETE fus
		FROM [dbo].[fixed_url] fu join 
		[dbo].[fixed_url_setting] fus on  fus.[fixed_url_id] = fu.[fixed_url_id]
		where fu.[content_type_id] = 2 and fu.[content_id] =  @productId


		DELETE 
		FROM [dbo].[fixed_url]
		where [content_id] = @productId and [content_type_id] = 2

		DELETE	
		FROM [dbo].[action_url] 
		where [content_id] = @productId and [content_type_id] = 2

		DELETE propri
        FROM dbo.product pro
            INNER JOIN product_to_vendor proven
                ON proven.product_id = pro.product_id
            INNER JOIN dbo.product_to_vendor_to_price propri
                ON propri.product_to_vendor_id = proven.product_to_vendor_id
        WHERE pro.product_id = @productId;

		DELETE FROM product_to_vendor
        WHERE product_id = @productId;
		 
		DELETE FROM product_to_url
        WHERE product_id = @productId;

        DELETE FROM product_to_product
        WHERE product_id = @productId;
		
        DELETE FROM product_to_category
        WHERE product_id = @productId;

		DELETE FROM product_parameter
        WHERE product_id = @productId;

		DELETE pmis
		FROM  product_multimedia_item pmi 
		INNER JOIN product_multimedia_item_setting pmis on pmis.product_multimedia_item_id = pmi.product_multimedia_item_id
        WHERE pmi.product_id = @productId;

		DELETE FROM product_multimedia_item
        WHERE product_id = @productId;

		DELETE FROM product_display_status
        WHERE product_id = @productId;

		DELETE FROM product_compression_group_to_product
        WHERE product_id = @productId;

		DELETE FROM citation
        WHERE product_id = @productId;

		DELETE FROM dbo.product WHERE product_id = @productId --

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


--==== removed FK_model_product constraint

IF EXISTS( 
	SELECT 1 
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_model_product'
	)
BEGIN
    ALTER TABLE model DROP CONSTRAINT FK_model_product
END


--===== adminProduct_GetArchivingProductIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10,
@lastProcessedProductId INT
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
			AND pro.product_id > @lastProcessedProductId
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO


--==== adminArticle_GetArchivingArticleIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArchivingArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArchivingArticleIdsList
@limit INT = 10,
@lastProcessedArticleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) art.article_id AS [id]
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
												  AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
			AND art.article_id > @lastProcessedArticleId
	ORDER BY art.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO




--==== adminArchivedProduct_GetArchivedProductsPageList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductsPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductsPageList
	@vendorId int = -1,
	@catalogNumber varchar(255) = '',
	@productName varchar(255) = '',
	@productId int = -1,
	@categoryId int = 0,
	@startIndex int,
	@endIndex int,
	@totalCount int OUTPUT

AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY Tmp.id) AS row , Tmp.id AS id
	INTO #temp
	FROM
	(
		SELECT DISTINCT ar.archived_product_id AS id
		FROM [dbo].[archived_product] ar WITH(NOLOCK) 
			 LEFT	JOIN dbo.archived_product_to_category arp ON arp.archived_product_id = ar.archived_product_id
		WHERE (@vendorId = -1 OR ar.vendor_id = @vendorId)
		AND (@productId = -1 OR ar.product_id = @productId)
		AND (@catalogNumber = '' OR ar.catalog_number LIKE '%'+ @catalogNumber + '%')
		AND (@productName = '' OR ar.product_name LIKE '%'+ @productName +'%')
		AND (@categoryId = 0 OR (arp.category_id = @categoryId))
	)Tmp
	
	SELECT ap.[archived_product_id] as Id
		  ,ap.[product_id]
		  ,ap.[site_id]
		  ,ap.[vendor_id]
		  ,ap.[catalog_number]
		  ,ap.[product_name]
		  ,ap.[modified]
		  ,ap.[created]
		  ,ap.[is_restore]
		  ,ap.is_restore_error
		  ,ap.restore_disabled
		  , CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product] as ap with(nolock) 
	INNER JOIN  #temp ON #temp.id = ap.archived_product_id
	WHERE #temp.row BETWEEN @startIndex AND @endIndex;
	
	SELECT @totalCount = COUNT(*) FROM #temp;
END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsPageList TO VpWebApp 
GO

--==== adminProduct_GetArchivingProductIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10,
@lastProcessedProductId INT
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
			AND pro.enabled = 0
			AND pro.archived = 1 
			AND (ld.lead_id IS NULL OR ld.lead_status_id = 4) --lead sent
			AND (ptp.product_to_product_id IS NULL) --not parent product
			AND pro.product_id > @lastProcessedProductId
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO


