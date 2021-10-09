
--===== adminArticle_GetArchivingArticleIdsList

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
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND atp.article_type_parameter_id IS NULL --non default articles
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


--===== adminArticle_UpdateArticleArchiveStatus

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
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
					AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
			LEFT JOIN dbo.article_type_parameter atp ON atp.article_type_id = art.article_type_id 
					AND atp.parameter_type_id = 63 --ArticleTypeDefaultArticleId
					AND CAST(atp.article_type_parameter_value AS int) = art.article_id 
	WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND rt.review_type_id IS NULL --non review type
			AND atp.article_type_parameter_id IS NULL --non default articles
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO


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
			LEFT JOIN dbo.product_parameter pp ON pp.product_id = pro.product_id AND pp.parameter_type_id = 187 --ProductRunStartDate
	WHERE	pro.search_content_modified = 0 --elastic search processed
			--AND pro.content_modified = 0 --content update synced --todo temporary removed 
			AND pro.enabled = 0
			AND pro.archived = 1 
			AND (ld.lead_id IS NULL OR ld.lead_state_type_id = 7) --lead sent
			AND (ptp.product_to_product_id IS NULL) --not parent product
			AND (pp.product_parameter_id IS NULL OR CAST(pp.product_parameter_value AS DATETIME) < GETDATE()) --no future enable date
			AND pro.product_id > @lastProcessedProductId
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO


--===== adminArchivedProduct_GetArchivedProductsPageList


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
		AND (@productId = -1 OR ar.product_id = @productId)
		AND (@catalogNumber = '' OR ar.catalog_number LIKE '%'+ @catalogNumber + '%')
		AND (@productName = '' OR ar.product_name LIKE '%'+ @productName +'%')
		AND (@categoryId = 0 OR (arp.category_id = @categoryId))
		AND (@siteId = 0 OR ar.site_id = @siteId)
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

--====== adminProduct_GetArchivingProductIdsList

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

--====== adminArticle_GetArchivingArticleIdsList

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
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND atp.article_type_parameter_id IS NULL --non default articles
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
			AND (ctcg.campaign_type_content_group_id IS NULL OR camp.status = 10) --only archived campaign content associations
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
			AND art.article_id > @lastProcessedArticleId
	ORDER BY art.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO


--===== adminArticle_UpdateArticleArchiveStatus

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
	WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND rt.review_type_id IS NULL --non review type
			AND atp.article_type_parameter_id IS NULL --non default articles
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
			AND (ctcg.campaign_type_content_group_id IS NULL OR camp.status = 10) --only archived campaign content associations

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO

