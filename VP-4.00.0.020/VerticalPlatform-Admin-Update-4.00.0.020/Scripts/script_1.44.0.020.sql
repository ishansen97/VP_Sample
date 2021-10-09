--==== adminProduct_ProductSyncPopulateData


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_ProductSyncPopulateData'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_ProductSyncPopulateData
	@product_id int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [product_id],[site_id],[product_name],[rank],[has_image],[catalog_number],[enabled],[created],[product_type],[status],[has_model]
      ,[has_related],[flag1],[flag2],[flag3],[flag4],[completeness],[search_rank],[legacy_content_id],[search_content_modified],[hidden]
      ,[business_value],[ignore_in_rapid],[show_in_matrix],[show_detail_page],[default_rank],[default_search_rank],parent_product_id,legacy_content_id
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

	SELECT product_url_id,[product_id],[url_id],[country_flag1],[country_flag2],[country_flag3],[country_flag4],[enabled],[created]
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

  --action_to_content
  SELECT atc.[action_id],atc.[content_type_id],atc.[content_id],atc.[default_action],atc.[sort_order],atc.[enabled],atc.[created],atc.[modified]
  FROM [dbo].[action_to_content] atc WHERE atc.content_id = @product_id AND atc.content_type_id = 2 

  --content_location
  SELECT  cl.content_location_id,cl.[content_type_id],cl.[content_id],cl.[location_type_id],cl.[location_id],cl.[exclude],cl.[modified],cl.[created],cl.[enabled],cl.[site_id]
  FROM [dbo].[content_location] cl WHERE cl.content_id = @product_id AND cl.content_type_id = 2 


END
GO

GRANT EXECUTE ON dbo.adminProduct_ProductSyncPopulateData TO VpWebApp 
GO

--===== adminProduct_RestoreProduct

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
	@defaultSearchRank FLOAT,
	@parentProductId INT,
	@legacyContentId INT
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
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank,parent_product_id,legacy_content_id, archived) 
	VALUES (@productId,@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @modified, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue,@ignoreInRapid, @showInMatrix, @showDetailPage, @defaultRank, @defaultSearchRank,@parentProductId,@legacyContentId, ~@enabled) 

	SET IDENTITY_INSERT [product] OFF

END

GO

GRANT EXECUTE ON dbo.adminProduct_RestoreProduct TO VpWebApp 
GO


--======= adminProduct_RestoreProductDisplayStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RestoreProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RestoreProductDisplayStatus
	@productId int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@SearchRank float,
	@newRank int,
	@enabled bit,
	@include BIT,
	@created DATETIME
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO [product_display_status] (product_id, start_date, end_date, search_rank, new_rank, [enabled],[include], modified, created)
	VALUES (@productId, @startDate, @endDate, @SearchRank, @newRank, @enabled,@include, GETDATE(), @created)

END
GO

GRANT EXECUTE ON dbo.adminProduct_RestoreProductDisplayStatus TO VpWebApp 
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
					AND	(camp.campaign_id IS NULL) --no campaignes
					AND art.article_type_id <> 267 --contextual paraggraphs
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
					AND (camp.campaign_id IS NULL) --no campaignes
					AND art.article_type_id <> 267 --contextual paraggraphs
				)
			)

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO


--==== adminProduct_GetArchivingProductIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10,
@lastProcessedProductId INT,
@vendorsWithMasterLeadTargets VARCHAR(MAX),
@lastProductId int output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) pro.[product_id] AS [id]
	INTO #tmp_products
	FROM	product pro WITH(NOLOCK)
			--leads
			LEFT JOIN lead ld WITH(NOLOCK) on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
				AND ld.lead_state_type_id NOT IN (1,2,7) --duplicated,deleted,lead sent
			--related products
			LEFT JOIN dbo.product_to_product ptp WITH(NOLOCK) ON ptp.parent_product_id = pro.product_id
			--start date parameter
			LEFT JOIN dbo.product_parameter pp WITH(NOLOCK) ON pp.product_id = pro.product_id AND pp.parameter_type_id = 188 --ProductRunEndDate
				AND CAST(pp.product_parameter_value AS DATETIME) > GETDATE()
			--campaign content data
			LEFT JOIN campaign_content_data ccd WITH(NOLOCK) ON ccd.content_id = pro.product_id
			LEFT JOIN campaign_type_content_group ctcg WITH(NOLOCK) ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 2 --product
			LEFT JOIN dbo.campaign camp WITH(NOLOCK) ON camp.campaign_id = ccd.campaign_id
			--master lead target vendors
			LEFT JOIN dbo.product_to_vendor ptv WITH(NOLOCK) ON ptv.product_id = pro.product_id
			LEFT JOIN dbo.global_Split(@vendorsWithMasterLeadTargets, ',') master_lead_vendor ON ptv.vendor_id = master_lead_vendor.[value] 
			LEFT JOIN lead ld_master WITH(NOLOCK) ON master_lead_vendor.value = ld_master.vendor_id AND pro.product_id = ld_master.content_id 
				AND ld_master.content_type_id = 2 AND ld_master.is_included_to_master = 0
	WHERE	pro.search_content_modified = 0 --elastic search processed
			--AND pro.content_modified = 0 --content update synced --todo temporary removed 
			AND pro.enabled = 0
			AND pro.archived = 1 
			AND pro.product_id > @lastProcessedProductId

			AND (ld.lead_id IS NULL)  --all lead sent
			AND (ptp.product_to_product_id IS NULL) --non parent product
			AND (pp.product_parameter_id IS NULL) --no future enable date
			AND	(camp.campaign_id IS NULL) --no campaignes
			AND (ld_master.lead_id IS NULL) --master target included
	ORDER BY pro.product_id


	--model leads without sent
	SELECT id FROM	
	#tmp_products
	EXCEPT
	SELECT tmp_products.id FROM
	#tmp_products tmp_products 
	INNER JOIN dbo.model modl ON modl.product_id = tmp_products.id
	INNER JOIN lead ld ON ld.content_id = modl.model_id AND ld.content_type_id = 21 
	WHERE ld.lead_state_type_id NOT IN (1,2,7)


	--product count out
	SELECT @lastProductId = COALESCE(MAX(id), 0) FROM  #tmp_products

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO

