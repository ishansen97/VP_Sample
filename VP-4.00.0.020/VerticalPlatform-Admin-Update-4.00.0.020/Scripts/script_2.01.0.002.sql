
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
	where [product_id] = @product_id OR parent_product_id = @product_id

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

--==== adminProduct_UpdateDisplayStatusProductsBySiteId

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET XACT_ABORT ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int,
	@rowCount INT OUTPUT
	
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	UPDATE TOP(@batchSize) p
	SET p.[rank] = CASE WHEN pds.new_rank IS NULL THEN p.default_rank ELSE pds.new_rank END,
		p.search_rank = CASE WHEN pds.search_rank = 0 THEN p.default_search_rank ELSE pds.search_rank END,
		p.search_content_modified = 1,
		p.modified = GETDATE(),
		p.content_modified = 1
	FROM [product_display_status] pds
		INNER JOIN product p
			ON p.product_id = pds.product_id
	WHERE p.site_id = @siteId 
		AND pds.[include] = 1
		AND @today BETWEEN pds.start_date AND pds.end_date
		AND (
				( pds.new_rank IS NULL AND  p.search_rank <> pds.search_rank) 
				OR ( pds.new_rank IS NULL AND  p.[rank] <> p.default_rank) 
				OR ( pds.search_rank = 0  AND p.search_rank <> p.default_search_rank) 
				OR ( pds.search_rank = 0  AND  p.[rank] <> pds.new_rank ) 
				OR ( pds.new_rank IS NOT NULL AND pds.search_rank <> 0 AND ( p.rank <> pds.new_rank OR p.search_rank <> pds.search_rank))
			)

	SELECT @rowCount = @@ROWCOUNT
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateDisplayStatusProductsBySiteId TO VpWebApp 
GO

--==== adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int,
	@rowCount INT OUTPUT
	
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	UPDATE TOP(@batchSize) p
	SET p.rank = p.default_rank,
		p.search_rank = p.default_search_rank,
		p.search_content_modified = 1,
		p.modified = GETDATE(),
		p.content_modified = 1
	FROM product p
	WHERE p.product_id IN (
		SELECT DISTINCT p.product_id
		FROM product p
			INNER JOIN [product_display_status] pds
			ON pds.product_id = p.product_id
		WHERE p.site_id = @siteId
			AND pds.[include] = 1
			AND (NOT (@today BETWEEN pds.[start_date] AND pds.end_date))
			AND (p.rank <> p.default_rank OR p.search_rank <> p.default_search_rank)
	)
		
	SELECT @rowCount = @@ROWCOUNT
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId TO VpWebApp 
GO

--==== adminProduct_UpdateProductDisplayIncludeList

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductDisplayIncludeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductDisplayIncludeList
	@timeInterval int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime

	SET @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	SELECT pds.product_display_status_id 
	,pds.product_id
	INTO #tmp_exclude_statuses
	FROM product_display_status pds
	WHERE [include] = 1
		AND (end_date <= DATEADD(DAY, -@timeInterval, @today)
			OR end_date >= DATEADD(DAY, @timeInterval, @today))

	UPDATE pds
	SET [include] = 0,
		modified = GETDATE()
	FROM product_display_status pds
	INNER JOIN #tmp_exclude_statuses tmp ON tmp.product_display_status_id = pds.product_display_status_id


	SELECT pds.product_display_status_id 
	,pds.product_id
	INTO #tmp_include_statuses
	FROM product_display_status pds
	WHERE [include] = 0
		AND ([start_date] BETWEEN DATEADD(DAY, -@timeInterval, @today) AND DATEADD(DAY, @timeInterval, @today)
			OR end_date BETWEEN DATEADD(DAY, -@timeInterval, @today) AND DATEADD(DAY, @timeInterval, @today))

	UPDATE pds
	SET [include] = 1,
		modified = GETDATE()
	FROM product_display_status pds
	INNER JOIN #tmp_include_statuses tmp ON tmp.product_display_status_id = pds.product_display_status_id


	--update product content modified status
	UPDATE pro
	SET pro.content_modified = 1
	FROM dbo.product pro
	INNER JOIN (
		SELECT product_id
		FROM #tmp_include_statuses
		UNION ALL
		SELECT product_id
		FROM #tmp_exclude_statuses
	)T  ON T.product_id = pro.product_id


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductDisplayIncludeList TO VpWebApp 
GO
