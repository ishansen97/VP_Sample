
--==== adminArticle_ArticleArchivePopulateData

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_ArticleArchivePopulateData'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_ArticleArchivePopulateData
	@article_id int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;


	--Article 
	SELECT [article_id]
      ,[article_type_id]
      ,[site_id]
      ,[article_title]
      ,[article_summary]
      ,[enabled]
      ,[modified]
      ,[created]
      ,[article_short_title]
      ,[is_article_template]
      ,[is_external]
      ,[featured_identifier]
      ,[thumbnail_image_code]
      ,[date_published]
      ,[external_url_id]
      ,[is_template]
      ,[article_template_id]
      ,[open_new_window]
      ,[end_date]
      ,[flag1]
      ,[flag2]
      ,[flag3]
      ,[flag4]
      ,[published]
      ,[start_date]
      ,[legacy_content_id]
      ,[search_content_modified]
      ,[deleted]
      ,[article_sub_title]
      ,[exclude_from_search]
      ,[archived]
  FROM [dbo].[article]
  WHERE article_id = @article_id


  --article_custom_property
  SELECT [article_custom_property_id]
      ,[article_id]
      ,[custom_property_id]
      ,[custom_property_value]
      ,[enabled]
      ,[created]
      ,[modified]
  FROM [dbo].[article_custom_property]
  WHERE article_id = @article_id


  --article_parameter
  SELECT [article_parameter_id]
      ,[article_id]
      ,[parameter_type_id]
      ,[article_parameter_value]
      ,[created]
      ,[modified]
      ,[enabled]
  FROM [dbo].[article_parameter]
  WHERE article_id = @article_id

  --article_rating
  SELECT [article_rating_id]
      ,[article_id]
      ,[article_section_id]
      ,[rating]
      ,[user_id]
      ,[nick_name]
      ,[email_address]
      ,[ip]
      ,[ip_numeric]
      ,[created]
      ,[modified]
      ,[enabled]
  FROM [dbo].[article_rating]
  WHERE article_id = @article_id

  --article_to_author
  SELECT [article_to_author_id]
      ,[article_id]
      ,[author_id]
      ,[enabled]
      ,[created]
      ,[modified]
      ,[gift_card_id]
      ,[verified]
  FROM [dbo].[article_to_author]
  WHERE article_id = @article_id


  --article_to_vendor
  SELECT [article_to_vendor]
      ,[article_id]
      ,[vendor_id]
      ,[enabled]
      ,[created]
      ,[modified]
  FROM [dbo].[article_to_vendor]
  WHERE article_id = @article_id


  --category_to_article_branch
  SELECT [category_to_article_branch_id]
      ,[category_id]
      ,[article_id]
      ,[category_branch_type_id]
      ,[enabled]
      ,[modified]
      ,[created]
  FROM [dbo].[category_to_article_branch]
  WHERE article_id = @article_id


  --product_to_article
  SELECT [product_to_article_id]
      ,[product_id]
      ,[article_id]
      ,[section_id]
      ,[enabled]
      ,[modified]
      ,[created]
  FROM [dbo].[product_to_article]
  WHERE article_id = @article_id


  --content_location
  SELECT [content_location_id]
      ,[content_type_id]
      ,[content_id]
      ,[location_type_id]
      ,[location_id]
      ,[exclude]
      ,[modified]
      ,[created]
      ,[enabled]
      ,[site_id]
  FROM [dbo].[content_location]
  WHERE content_id = @article_id
  AND content_type_id = 4


  --vendor_to_article
  SELECT [vendor_to_article_id]
      ,[vendor_id]
      ,[article_id]
      ,[article_section_id]
      ,[enabled]
      ,[modified]
      ,[created]
  FROM [dbo].[vendor_to_article]
  WHERE article_id = @article_id


  --article_section
  SELECT [article_section_id]
      ,[article_id]
      ,[section_title]
      ,[page_number]
      ,[sort_order]
      ,[enabled]
      ,[modified]
      ,[created]
      ,[has_image]
      ,[css_class]
      ,[is_popup]
      ,[preview_image_title]
      ,[preview_image_code]
      ,[is_template_section]
      ,[template_section_id]
      ,[toggle_section]
      ,[toggle_text]
      ,[section_name]
      ,[hide_when_empty]
  FROM [dbo].[article_section]
  WHERE article_id = @article_id


  --article_resource
  SELECT res.[article_resource_id]
      ,res.[article_resource_type_id]
      ,res.[article_section_id]
      ,res.[article_resource_code]
      ,res.[enabled]
      ,res.[parent_article_resource_id]
      ,res.[template_article_resource_id]
      ,res.[sort_order]
      ,res.[created]
      ,res.[modified]
  FROM [dbo].[article_resource] res
  INNER JOIN article_section sec ON sec.article_section_id = res.article_section_id
  WHERE sec.article_id = @article_id 


  --article_resource_attribute
  SELECT resatr.[article_resource_attribute_id]
      ,resatr.[article_resource_id]
      ,resatr.[article_resource_attribute_name]
      ,resatr.[article_resource_attribute_value]
      ,resatr.[enabled]
      ,resatr.[created]
      ,resatr.[modified]
  FROM [dbo].[article_resource_attribute] resatr
  INNER JOIN [dbo].[article_resource] res ON res.article_resource_id = resatr.article_resource_id
  INNER JOIN article_section sec ON sec.article_section_id = res.article_section_id
  WHERE sec.article_id = @article_id 


  --article_section_parameter
  SELECT asp.[article_section_parameter_id]
      ,asp.[article_section_id]
      ,asp.[parameter_type_id]
      ,asp.[article_section_parameter_value]
      ,asp.[created]
      ,asp.[modified]
      ,asp.[enabled]
  FROM [dbo].[article_section_parameter] asp
  INNER JOIN article_section sec ON sec.article_section_id = asp.article_section_id
  WHERE sec.article_id = @article_id 


  --article_comment
  SELECT [article_comment_id]
      ,[article_id]
      ,[article_section_id]
      ,[comment]
      ,[user_id]
      ,[nick_name]
      ,[email_address]
      ,[ip]
      ,[ip_numeric]
      ,[created]
      ,[modified]
      ,[enabled]
      ,[reply_to_comment_id]
      ,[status]
      ,[admin_note]
  FROM [dbo].[article_comment]
  WHERE article_id = @article_id 


  --exhibition
  SELECT [exhibition_id]
      ,[site_id]
      ,[name]
      ,[title]
      ,[description]
      ,[start_date]
      ,[end_date]
      ,[logo_name]
      ,[article_id]
      ,[enabled]
      ,[modified]
      ,[created]
  FROM [dbo].[exhibition]
  WHERE article_id = @article_id 

	
  --exhibition_vendor
  SELECT DISTINCT exv.[exhibition_vendor_id]
      ,exv.[vendor_id]
      ,exv.[booth]
      ,exv.[logo_name]
      ,exv.[description]
      ,exv.[article_id]
      ,exv.[enabled]
      ,exv.[modified]
      ,exv.[created]
      ,exv.[exhibition_id]
  FROM [dbo].[exhibition_vendor] exv
  LEFT JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
  WHERE ex.article_id = @article_id
  OR exv.article_id = @article_id



  --exhibition_vendor_special
  SELECT DISTINCT evs.[exhibition_vendor_special_id]
      ,evs.[exhibition_vendor_id]
      ,evs.[title]
      ,evs.[description]
      ,evs.[image_name]
      ,evs.[enabled]
      ,evs.[modified]
      ,evs.[created]
  FROM [dbo].[exhibition_vendor_special] evs
  INNER JOIN [dbo].[exhibition_vendor] exv ON exv.exhibition_vendor_id = evs.exhibition_vendor_id
  LEFT JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
  WHERE ex.article_id = @article_id
  OR exv.article_id = @article_id


  --exhibition_category
  SELECT DISTINCT ec.[exhibition_category_id]
      ,ec.[name]
      ,ec.[exhibition_id]
      ,ec.[image_name]
      ,ec.[description]
      ,ec.[enabled]
      ,ec.[modified]
      ,ec.[created]
      ,ec.[sort_order]
  FROM [dbo].[exhibition_category] ec
  INNER JOIN [dbo].[exhibition] ex ON ex.exhibition_id = ec.exhibition_id
  WHERE ex.article_id = @article_id 


  --exhibition_category_to_exhibition_vendor
  SELECT DISTINCT ectev.[exhibition_category_to_exhibition_vendor_id]
      ,ectev.[exhibition_category_id]
      ,ectev.[exhibition_vendor_id]
      ,ectev.[enabled]
      ,ectev.[modified]
      ,ectev.[created]
      ,ectev.[sort_order]
  FROM [dbo].[exhibition_category_to_exhibition_vendor] ectev
  INNER JOIN [dbo].[exhibition_vendor] exv ON	exv.exhibition_vendor_id = ectev.exhibition_vendor_id
  LEFT JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
  WHERE ex.article_id = @article_id
  OR exv.article_id = @article_id
  UNION
  SELECT DISTINCT ectev.[exhibition_category_to_exhibition_vendor_id]
    ,ectev.[exhibition_category_id]
    ,ectev.[exhibition_vendor_id]
    ,ectev.[enabled]
    ,ectev.[modified]
    ,ectev.[created]
    ,ectev.[sort_order]
  FROM [dbo].[exhibition_category_to_exhibition_vendor] ectev
  INNER JOIN [dbo].[exhibition_category] ec ON ec.exhibition_category_id = ectev.exhibition_category_id
  INNER JOIN [dbo].[exhibition] ex ON ex.exhibition_id = ec.exhibition_id
  WHERE ex.article_id = @article_id 


  --fixed_url
  SELECT [fixed_url_id]
      ,[fixed_url]
      ,[site_id]
      ,[page_id]
      ,[content_type_id]
      ,[content_id]
      ,[query_string]
      ,[enabled]
      ,[created]
      ,[modified]
      ,[include_in_sitemap]
  FROM [dbo].[fixed_url] 
  WHERE content_id = @article_id 
  AND	content_type_id = 4

  --legacy_fixed_url
  SELECT lfu.[legacy_fixed_url_id]
      ,lfu.[fixed_url_id]
      ,lfu.[legacy_fixed_url]
      ,lfu.[query_string]
      ,lfu.[enabled]
      ,lfu.[created]
      ,lfu.[modified]
  FROM [dbo].[legacy_fixed_url] lfu
  INNER JOIN [dbo].[fixed_url] fu ON fu.fixed_url_id = lfu.fixed_url_id
  WHERE fu.content_id = @article_id 
  AND	fu.content_type_id = 4


  --fixed_url_setting
  SELECT fus.[fixed_url_setting_id]
      ,fus.[fixed_url_id]
      ,fus.[fixed_url_setting_key]
      ,fus.[fixed_url_setting_value]
      ,fus.[enabled]
      ,fus.[modified]
      ,fus.[created]
      ,fus.[site_id]
  FROM [dbo].[fixed_url_setting] fus
  INNER JOIN [dbo].[fixed_url] fu ON fu.fixed_url_id = fus.fixed_url_id
  WHERE fu.content_id = @article_id 
  AND	fu.content_type_id = 4


  --content_to_content
  SELECT [content_to_content_id]
      ,[content_id]
      ,[content_type_id]
      ,[associated_content_id]
      ,[associated_content_type_id]
      ,[enabled]
      ,[created]
      ,[modified]
      ,[site_id]
      ,[associated_site_id]
      ,[sort_order]
  FROM [dbo].[content_to_content]
  WHERE ( content_id = @article_id  AND	content_type_id = 4)
	 OR ( associated_content_id = @article_id  AND	associated_content_type_id = 4)


  --content_to_content_setting
  SELECT ctcs.[content_to_content_setting_id]
      ,ctcs.[content_to_content_id]
      ,ctcs.[setting_name]
      ,ctcs.[setting_value]
      ,ctcs.[enabled]
      ,ctcs.[created]
      ,ctcs.[modified]
  FROM [dbo].[content_to_content_setting] ctcs
  INNER JOIN [dbo].[content_to_content] ctc ON ctc.content_to_content_id = ctcs.content_to_content_id
  WHERE ( ctc.content_id = @article_id  AND	ctc.content_type_id = 4)
	 OR ( ctc.associated_content_id = @article_id  AND	ctc.associated_content_type_id = 4)



END
GO

GRANT EXECUTE ON dbo.adminArticle_ArticleArchivePopulateData TO VpWebApp 
GO

--==== adminExhibition_RestoreExhibition

EXEC dbo.global_DropStoredProcedure 'dbo.adminExhibition_RestoreExhibition'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminExhibition_RestoreExhibition
	@exhibitionId int,
	@siteId int,
	@name varchar(200), 
	@title varchar(200),
	@description varchar(1000),
	@startDate smalldatetime,
	@endDate smalldatetime,
	@logoName varchar(255),
	@articleId int,
	@enabled BIT,
	@created DATETIME 
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET IDENTITY_INSERT [exhibition] ON

	DECLARE @modified AS DATETIME = GETDATE()

	INSERT INTO exhibition (exhibition_id,site_id, [name], title, description, start_date, end_date
		, logo_name, article_id, enabled, created, modified)
	VALUES (@exhibitionId,@siteId, @name, @title, @description, @startDate, @endDate, @logoName
		, @articleId, @enabled, @created, @modified)


	SET IDENTITY_INSERT [exhibition] OFF

END

GO

GRANT EXECUTE ON dbo.adminExhibition_RestoreExhibition TO VpWebApp 
GO

--==== adminExhibition_RestoreExhibitionVendor


EXEC dbo.global_DropStoredProcedure 'dbo.adminExhibition_RestoreExhibitionVendor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminExhibition_RestoreExhibitionVendor
	@exhibitionVendorId int,
	@articleId int,
	@vendorId int,
	@booth varchar(50),
	@logoName varchar(255),
	@description varchar(1000),
	@exhibitionId int,
	@enabled bit,
	@created DATETIME 
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET IDENTITY_INSERT exhibition_vendor ON

	INSERT INTO exhibition_vendor (exhibition_vendor_id,vendor_id, booth, logo_name, description, article_id, exhibition_id, created, modified, [enabled])
	VALUES (@exhibitionVendorId,@vendorId, @booth, @logoName, @description, @articleId, @exhibitionId, @created, GETDATE(), @enabled)

	SET IDENTITY_INSERT exhibition_vendor OFF

END
GO

GRANT EXECUTE ON dbo.adminExhibition_RestoreExhibitionVendor TO VpWebApp 
Go

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
					AND art.article_type_id <> 267 --contextual paraggraphs
				)
			)

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO


--==== adminActionUrl_RestoreActionUrl

EXEC dbo.global_DropStoredProcedure 'dbo.adminActionUrl_RestoreActionUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminActionUrl_RestoreActionUrl
	@actionUrlId int,
	@actionId int,
	@actionUrl varchar(2000),
	@contentTypeId int,
	@contentId int,
	@enabled bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@created DATETIME,
	@newWindow bit
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET IDENTITY_INSERT action_url ON

	INSERT INTO action_url (action_url_id,action_id, action_url, content_type_id, content_id, enabled ,flag1, flag2, flag3, flag4,
		created, modified, new_window)
	VALUES (@actionUrlId,@actionId, @actionUrl, @contentTypeId, @contentId, @enabled, @flag1, @flag2, @flag3, @flag4, 
		@created, GETDATE(), @newWindow)

	SET IDENTITY_INSERT action_url OFF

END
GO

GRANT EXECUTE ON dbo.adminActionUrl_RestoreActionUrl TO VpWebApp 
GO

--==== adminProduct_RestoreProductUrl


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RestoreProductUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RestoreProductUrl
	@productUrlId int,
	@productId int,
	@urlId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@enabled bit,
	@created DATETIME
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET IDENTITY_INSERT product_to_url ON

	INSERT INTO product_to_url (product_url_id,product_id, url_id, country_flag1, country_flag2, 
		country_flag3, country_flag4, enabled, created, modified)
	VALUES (@productUrlId,@productId, @urlId, @countryFlag1, @countryFlag2, 
		@countryFlag3, @countryFlag4, @enabled, @created, GETDATE())

	SET IDENTITY_INSERT product_to_url OFF

END
GO

GRANT EXECUTE ON dbo.adminProduct_RestoreProductUrl TO VpWebApp 
GO


---==== adminProduct_ProductSyncPopulateData


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


--==== adminArticle_AddArticleSectionWithIdentity

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleSectionWithIdentity'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticleSectionWithIdentity
	@article_section_id int,
	@articleId int,
	@sectionTitle varchar(100),
	@pageNumber int,
	@isPopup bit,
	@sortOrder int,
	@created smalldatetime, 
	@enabled bit,
	@previewImageTitle varchar(100),
	@previewImageCode varchar(255),
	@cssClass varchar(50),
	@templateSectionId int,
	@isTemplateSection bit,
	@toggleSection bit,
	@toggleText varchar(max),
	@sectionName varchar(max),
	@hideWhenEmpty bit
AS
-- ==========================================================================
-- $Author: Chirath
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	SET IDENTITY_INSERT [article_section] ON

	DECLARE @modified AS DATETIME = GETDATE()
	
	INSERT INTO article_section (article_section_id,article_id, section_title, page_number,
		is_popup, sort_order, [enabled], modified, created, preview_image_title, 
		preview_image_code,css_class,template_section_id,is_template_section, 
		toggle_section, toggle_text, section_name, hide_when_empty)
	VALUES (@article_section_id,@articleId, @sectionTitle, @pageNumber,	@isPopup, @sortOrder, @enabled, 
		@modified, @created, @previewImageTitle, @previewImageCode,@cssClass,
		@templateSectionId,@isTemplateSection,@toggleSection,@toggleText, 
		@sectionName, @hideWhenEmpty)

	SET IDENTITY_INSERT [article_section] OFF

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddArticleSectionWithIdentity TO VpWebApp 
GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductEnabledStatusByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductEnabledStatusByProductIdList
	@status BIT,
	@productIds NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Dulip $
-- $DATE: 2020-05-25
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @archived BIT = 0;
	IF (@status = 0) 
		SET @archived = 1
	
	UPDATE p
	SET p.[enabled] = @status
		,p.[modified] = GETDATE()
		,p.[search_content_modified] = 1
		,p.[archived] = @archived
	FROM [product] p
		INNER JOIN dbo.global_Split(@productIds, ',') gs
		ON p.product_id = gs.[value]
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductEnabledStatusByProductIdList TO VpWebApp 
GO
