
--===== adminArchivedProduct_DeleteArchivedProducts

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_DeleteArchivedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_DeleteArchivedProducts
	@productId int
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE arpc
	FROM dbo.archived_product arp
	INNER JOIN dbo.archived_product_to_category arpc ON arpc.archived_product_id = arp.archived_product_id
	WHERE arp.product_id = @productId

	DELETE arpv
	FROM dbo.archived_product arp
	INNER JOIN dbo.archived_product_to_vendor arpv ON arpv.archived_product_id = arp.archived_product_id
	WHERE arp.product_id = @productId

	DELETE FROM archived_product
	WHERE [product_id] = @productId

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_DeleteArchivedProducts TO VpWebApp 
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
			--leads
			LEFT JOIN lead ld on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
				AND ld.lead_state_type_id <> 7 --lead sent
			--related products
			LEFT JOIN dbo.product_to_product ptp ON ptp.parent_product_id = pro.product_id
			--start date parameter
			LEFT JOIN dbo.product_parameter pp ON pp.product_id = pro.product_id AND pp.parameter_type_id = 187 --ProductRunStartDate
				AND CAST(pp.product_parameter_value AS DATETIME) > GETDATE()
			--campaign content data
			LEFT JOIN campaign_content_data ccd ON ccd.content_id = pro.product_id
			LEFT JOIN campaign_type_content_group ctcg ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 2 --product
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id AND camp.status <> 10 --non archived campaignes
			--master lead target vendors
			LEFT JOIN dbo.product_to_vendor ptv ON ptv.product_id = pro.product_id
			LEFT JOIN dbo.global_Split(@vendorsWithMasterLeadTargets, ',') master_lead_vendor ON pro.product_id = master_lead_vendor.[value] 
			LEFT JOIN lead ld_master ON master_lead_vendor.value = ld_master.vendor_id AND pro.product_id = ld_master.content_id 
				AND ld_master.content_type_id = 2 AND ld_master.is_included_to_master = 0
	WHERE	pro.search_content_modified = 0 --elastic search processed
			--AND pro.content_modified = 0 --content update synced --todo temporary removed 
			AND pro.enabled = 0
			AND pro.archived = 1 
			AND pro.product_id > @lastProcessedProductId

			AND (ld.lead_id IS NULL)  --all lead sent
			AND (ptp.product_to_product_id IS NULL) --non parent product
			AND (pp.product_parameter_id IS NULL) --no future enable date
			AND	(camp.campaign_id IS NULL) --no non archived campaignes
			AND (ld_master.lead_id IS NULL) --master target included
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO


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
			--campaign content data
			LEFT JOIN campaign_content_data ccd ON ccd.content_id = art.article_id
			LEFT JOIN campaign_type_content_group ctcg ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 4 --article
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id AND camp.status <> 10 --non archived campaignes
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND atp.article_type_parameter_id IS NULL --non default articles
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
			AND	(camp.campaign_id IS NULL) --no non archived campaignes
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
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id AND camp.status <> 10 --non archived campaignes
	WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND rt.review_type_id IS NULL --non review type
			AND atp.article_type_parameter_id IS NULL --non default articles
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
			AND	(camp.campaign_id IS NULL) --no non archived campaignes

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
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
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id AND camp.status <> 10 --non archived campaignes
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
			AND art.article_id > @lastProcessedArticleId
			AND
			(
				art.deleted = 1 
				OR (
					rt.review_type_id IS NULL --non review type
					AND atp.article_type_parameter_id IS NULL --non default articles
					AND art.is_article_template = 0	--non default article
					AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
					AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
					AND	(camp.campaign_id IS NULL) --no non archived campaignes
				)
			)
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
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id AND camp.status <> 10 --non archived campaignes
	 WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND
			(
				art.deleted = 1
				OR
				(
					rt.review_type_id IS NULL --non review type
					AND atp.article_type_parameter_id IS NULL --non default articles
					AND art.is_article_template = 0 --non default article
					AND ( art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
					AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
					AND (camp.campaign_id IS NULL) --no non archived campaignes
				)
			)

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO

