-- ===== Add new fields to Archived_product table

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'quantity' AND Object_ID = Object_ID(N'archived_product'))
BEGIN
    ALTER TABLE archived_product ADD quantity VARCHAR (2000) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'restore_hidden' AND Object_ID = Object_ID(N'archived_product'))
BEGIN
    ALTER TABLE archived_product ADD restore_hidden BIT NOT NULL DEFAULT 0
END
GO



--==== adminArchivedProduct_AddArchivedProduct

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_AddArchivedProduct'


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_AddArchivedProduct
@productId INT,
    @siteId INT,
	@vendorId INT,
    @catalogNumber VARCHAR(255),
    @productName VARCHAR(500),
    @isRestore BIT,
    @isRestoreError BIT,
	@id INT OUTPUT,
	@created smalldatetime OUTPUT,
	@restoreDisabled BIT,
	@quantity VARCHAR (2000),
	@restoreHidden BIT
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
		restore_disabled,
		quantity,
		restore_hidden
    )
    VALUES
    (@productId, @siteId, @vendorId, @catalogNumber, @productName, @created, @created, @isRestore, @isRestoreError,@restoreDisabled, @quantity, @restoreHidden);

    SET @id = SCOPE_IDENTITY();


END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_AddArchivedProduct TO VpWebApp
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
	@quantity VARCHAR (2000),
	@restoreHidden BIT,
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
		  ,quantity = @quantity
		  ,restore_hidden = @restoreHidden

	WHERE archived_product_id = @id
 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_UpdateArchivedProduct TO VpWebApp
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
	  ,quantity
	  ,restore_hidden
	  ,CONVERT(bit, 1) as [enabled]
	  
	FROM [dbo].[archived_product]
	WHERE archived_product_id = @id 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsDetail TO VpWebApp
GO







--==== adminArchivedProduct_GetArchivedProductByProductId

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
	  ,quantity
	  ,restore_hidden
	  ,CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product]
	WHERE product_id = @productId 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductByProductId TO VpWebApp
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
	@siteId int = 0,
	@startIndex int,
	@endIndex int,
	@totalCount int OUTPUT

AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY Tmp.id desc) AS row , Tmp.id AS id
	INTO #temp
	FROM
	(
		SELECT DISTINCT ar.archived_product_id AS id
		FROM [dbo].[archived_product] ar WITH(NOLOCK) 
			LEFT JOIN dbo.archived_product_to_category arp ON arp.archived_product_id = ar.archived_product_id 
		WHERE (@vendorId = -1 OR ar.vendor_id = @vendorId)
		AND (@productId = -1 OR ar.product_id = @productId)
		AND (@catalogNumber = '' OR ar.catalog_number LIKE '%'+ @catalogNumber + '%')
		AND (@productName = '' OR ar.product_name LIKE '%'+ @productName +'%')
		AND (@categoryId = 0 OR (arp.category_id = @categoryId))
		AND (@siteId = 0 OR ar.site_id = @siteId)
	)Tmp
	OPTION (RECOMPILE)
	
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
		  ,ap.quantity
		  ,ap.restore_hidden
		  , CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product] as ap with(nolock) 
	INNER JOIN  #temp ON #temp.id = ap.archived_product_id
	WHERE #temp.row BETWEEN @startIndex AND @endIndex;
	
	SELECT @totalCount = COUNT(*) FROM #temp;
END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsPageList TO VpWebApp
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
			LEFT JOIN dbo.article_type_parameter atp ON atp.article_type_id = art.article_type_id 
					AND atp.parameter_type_id = 63 --ArticleTypeDefaultArticleId
					AND CAST(atp.article_type_parameter_value AS int) = art.article_id 
			--campaign content data
			LEFT JOIN campaign_content_data ccd ON ccd.content_id = art.article_id
			LEFT JOIN campaign_type_content_group ctcg ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 4 --article
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id
			LEFT JOIN exhibition exb ON exb.article_id = art.article_id
			LEFT JOIN exhibition_vendor exbv ON exbv.article_id = art.article_id
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
			AND art.article_id > @lastProcessedArticleId
			AND	exb.exhibition_id IS NULL --non exhibition related articles
			AND	exbv.exhibition_vendor_id IS NULL --non exhibition related articles
			AND
			(
				art.deleted = 1 
				OR (
					rt.review_type_id IS NULL --non review type
					AND atp.article_type_parameter_id IS NULL --non default articles
					AND art.is_article_template = 0	--non default article
					AND ( art.end_date IS NULL OR art.end_date < GETDATE()) --no future end date
					AND (cp.content_parameter_id IS NOT NULL OR art.created < '2020-01-01') --disabled date parameter type
					AND	(camp.campaign_id IS NULL) --no campaignes
					AND art.article_type_id not in (267,273,280,309) --contextual articles
					AND	art.created < DATEADD(MONTH,-3,GETDATE()) --articles created before 3 months
				)
			)
	ORDER BY art.article_id


END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO


--==== adminArticle_UpdateArticleArchiveStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleArchiveStatus'


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleArchiveStatus
@articleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE dbo.article SET archived = 0 WHERE article_id = @articleId
	
	UPDATE	art
	SET		art.archived = 1
	FROM	article art
	WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO


--==== adminPlatform_GetUnindexedProductIdsBySiteId


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductIdsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET XACT_ABORT ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductIdsBySiteId
	@siteId int
AS
-- ==========================================================================
-- Author : Akila
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT p.[product_id] AS [id]
	FROM product p WITH(NOLOCK)
	WHERE p.site_id = @siteId
		AND p.[enabled] = 1
		AND p.hidden = 0
		AND p.product_id NOT IN (
			SELECT content_id
			FROM search_content_status scs WITH(NOLOCK)
			WHERE scs.site_id = @siteId
				AND scs.content_type_id = 2
		)
	OPTION (RECOMPILE)

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductIdsBySiteId TO VpWebApp
GO


