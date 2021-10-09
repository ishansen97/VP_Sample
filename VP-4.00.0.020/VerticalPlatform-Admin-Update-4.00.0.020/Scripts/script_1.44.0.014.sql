
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


--===== adminProduct_RemoveArchivedProductandRelations

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


--====== adminProduct_GetArchivingProductIdsList

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
				AND ld.lead_state_type_id NOT IN (1,2,7) --duplicated,deleted,lead sent
			--related products
			LEFT JOIN dbo.product_to_product ptp ON ptp.parent_product_id = pro.product_id
			--start date parameter
			LEFT JOIN dbo.product_parameter pp ON pp.product_id = pro.product_id AND pp.parameter_type_id = 188 --ProductRunEndDate
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


--====== adminProduct_GetProductsBySiteIdLikeProductName


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductsBySiteIdLikeProductName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductsBySiteIdLikeProductName
	@siteId int,
	@value varchar(max),
	@isEnabled bit,
	@categoryId int,
	@selectLimit int,
	@status int,
	@excludeParent bit,
	@excludeParentChild bit,
	@vendorId int
	
AS
-- ==========================================================================
-- Author : Dulip
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF(@categoryId IS NULL)
		BEGIN
			SELECT DISTINCT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
				, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM product 
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id
			WHERE site_id = @siteId AND product_Name like @value+'%' AND (@isEnabled IS NULL OR product.enabled = @isEnabled)
				AND (@status IS NULL OR status = @status) AND (@vendorId IS NULL OR product_to_vendor.vendor_id = @vendorId)
				AND (@excludeParent IS NULL OR product.product_id NOT IN (SELECT parent_product_id FROM dbo.product_to_product))
				AND (@excludeParentChild IS NULL OR product.product_id NOT IN (SELECT parent_product_id FROM dbo.product_to_product UNION SELECT product_id FROM dbo.product_to_product))
		END
	ELSE
		BEGIN
			SELECT DISTINCT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
				, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM product 
					INNER JOIN product_to_category
						ON product.product_id = product_to_category.product_id AND product_to_category.category_id = @categoryId
					INNER JOIN product_to_vendor
						ON product.product_id = product_to_vendor.product_id
			WHERE site_id = @siteId AND product_Name like @value+'%' AND (@vendorId IS NULL OR product_to_vendor.vendor_id = @vendorId)
					AND (@isEnabled IS NULL OR product.enabled = @isEnabled) AND (@status IS NULL OR product.status = @status)
		END

END
GO

GRANT EXECUTE ON adminProduct_GetProductsBySiteIdLikeProductName TO VpWebApp
GO




