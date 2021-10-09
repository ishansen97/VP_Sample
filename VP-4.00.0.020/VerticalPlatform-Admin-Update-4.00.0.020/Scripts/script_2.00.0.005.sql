

--===== adminArticle_ArticleArchivePopulateData

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
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id
			LEFT JOIN exhibition exb ON exb.article_id = art.article_id
			LEFT JOIN exhibition_vendor exbv ON exbv.article_id = art.article_id
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
					AND (cp.content_parameter_id IS NOT NULL OR art.created < '2020-01-01') --disabled date parameter type
					AND	(camp.campaign_id IS NULL) --no campaignes
					AND art.article_type_id <> 267 --contextual paraggraphs
					AND	exb.exhibition_id IS NULL --non exhibition related articles
					AND	exbv.exhibition_vendor_id IS NULL --non exhibition related articles
				)
			)
	ORDER BY art.article_id


END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO


--==== adminArticle_RemoveArchivedArticleAndRelations

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_RemoveArchivedArticleAndRelations';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET XACT_ABORT ON;
GO
CREATE PROCEDURE dbo.adminArticle_RemoveArchivedArticleAndRelations 
@articleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

		--content_to_content_setting
		DELETE cts
		FROM content_to_content_setting cts
		INNER JOIN content_to_content ct ON ct.content_to_content_id = cts.content_to_content_id
		WHERE ( ct.content_id = @articleId  AND	ct.content_type_id = 4)
		OR ( ct.associated_content_id = @articleId  AND	ct.associated_content_type_id = 4)

		--content_to_content
		DELETE FROM
		content_to_content
		WHERE ( content_id = @articleId  AND	content_type_id = 4)
		OR ( associated_content_id = @articleId  AND associated_content_type_id = 4)


		--legacy_fixed_url
		DELETE lfu
		FROM legacy_fixed_url lfu 
		INNER JOIN fixed_url fur ON fur.fixed_url_id = lfu.fixed_url_id
		WHERE fur.content_id = @articleId AND fur.content_type_id = 4 --article

		
		--fixed_url_setting
		DELETE lfu
		FROM fixed_url_setting lfu 
		INNER JOIN fixed_url fur ON fur.fixed_url_id = lfu.fixed_url_id
		WHERE fur.content_id = @articleId AND fur.content_type_id = 4 --article


		--fixed_url
		DELETE FROM dbo.fixed_url
		WHERE content_id = @articleId AND content_type_id = 4 --article


		----exhibition_vendor_special
		--DELETE evs
		--FROM exhibition_vendor_special evs 
		--INNER JOIN dbo.exhibition_vendor exv ON	exv.exhibition_vendor_id = evs.exhibition_vendor_id
		--LEFT JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
		--WHERE ex.article_id = @articleId
		--OR exv.article_id = @articleId

		
		----exhibition_category_to_exhibition_vendor
		--DELETE evs
		--FROM exhibition_category_to_exhibition_vendor evs 
		--INNER JOIN dbo.exhibition_vendor exv ON	exv.exhibition_vendor_id = evs.exhibition_vendor_id
		--LEFT JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
		--WHERE ex.article_id = @articleId
		--OR exv.article_id = @articleId

		--DELETE ectev
		--FROM [dbo].[exhibition_category_to_exhibition_vendor] ectev
		--INNER JOIN [dbo].[exhibition_category] ec ON ec.exhibition_category_id = ectev.exhibition_category_id
		--INNER JOIN [dbo].[exhibition] ex ON ex.exhibition_id = ec.exhibition_id
		--WHERE ex.article_id = @articleId 


		----exhibition_vendor
		--DELETE exv
		--FROM dbo.exhibition_vendor exv
		--LEFT JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
		--WHERE ex.article_id = @articleId
		--OR exv.article_id = @articleId


		----Exhibition_Category
		--DELETE evs
		--FROM Exhibition_Category evs 
		--INNER JOIN exhibition ex ON ex.exhibition_id = evs.exhibition_id
		--WHERE ex.article_id = @articleId

		----exhibition
		--DELETE ex
		--FROM exhibition ex 
		--WHERE ex.article_id = @articleId


		--article_resource_attribute
		DELETE ara
		FROM article_resource_attribute ara
		INNER JOIN article_resource ar ON ar.article_resource_id = ara.article_resource_id
		INNER JOIN article_section ase ON ase.article_section_id = ar.article_section_id
		WHERE ase.article_id = @articleId

		--article_resource
		DELETE ar
		FROM article_resource ar
		INNER JOIN article_section ase ON ase.article_section_id = ar.article_section_id
		WHERE ase.article_id = @articleId

		--article_section_parameter
		DELETE ara
		FROM article_section_parameter ara
		INNER JOIN article_section ase ON ase.article_section_id = ara.article_section_id
		WHERE ase.article_id = @articleId


		--article_section
		DELETE from article_section
		WHERE article_id = @articleId


		--article_comment
		DELETE FROM dbo.article_comment
		WHERE article_id = @articleId


		--vendor_to_article
		DELETE FROM dbo.vendor_to_article
		WHERE article_id = @articleId


		--content_location
		DELETE FROM dbo.content_location
		WHERE content_id = @articleId AND content_type_id = 4


		--product_to_article
		DELETE FROM dbo.product_to_article
		WHERE article_id = @articleId

		--category_to_article_branch
		DELETE FROM dbo.category_to_article_branch
		WHERE article_id = @articleId


		--article_to_vendor
		DELETE FROM dbo.article_to_vendor
		WHERE article_id = @articleId


		--article_to_author
		DELETE FROM dbo.article_to_author
		WHERE article_id = @articleId


		--article_rating
		DELETE FROM dbo.article_rating
		WHERE article_id = @articleId


		--article_parameter
		DELETE FROM dbo.article_parameter
		WHERE article_id = @articleId

		--article_custom_property
		DELETE FROM dbo.article_custom_property
		WHERE article_id = @articleId

		--article
		DELETE FROM dbo.article 
		WHERE article_id = @articleId 


        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RETURN ERROR_MESSAGE();
    END CATCH;


END;
GO

GRANT EXECUTE
ON dbo.adminArticle_RemoveArchivedArticleAndRelations
TO  VpWebApp;
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
			LEFT JOIN exhibition exb ON exb.article_id = art.article_id
			LEFT JOIN exhibition_vendor exbv ON exbv.article_id = art.article_id
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
					AND	exb.exhibition_id IS NULL --non exhibition related articles
					AND	exbv.exhibition_vendor_id IS NULL --non exhibition related articles
				)
			)

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO


--==== adminPlatform_RestoreContentToContent


EXEC dbo.global_DropStoredProcedure 'adminPlatform_RestoreContentToContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminPlatform_RestoreContentToContent
	@contentId int,
	@contentTypeId int,
	@associatedContentId int,
	@associatedContentTypeId int,
	@siteId int,
	@associatedSiteId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@sortOrder int
AS
-- ==========================================================================
-- $Date: 2013-08-07
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT @id = content_to_content_id
			,@created = created
	FROM content_to_content 
	WHERE content_id = @contentId 
	AND content_type_id = @contentTypeId
	AND associated_content_type_id = @associatedContentTypeId
	AND [associated_content_id] = @associatedContentId


	IF(@id IS NULL)
	BEGIN

		SET @created = GETDATE()

		--get last sort order if new content to content mappong added
		IF @sortOrder = -1
		BEGIN
			SELECT @sortOrder = (ISNULL(MAX(sort_order),0)+1)
			FROM content_to_content 
			WHERE content_id = @contentId 
			AND content_type_id = @contentTypeId
			AND associated_content_type_id = @associatedContentTypeId
		END
	
		INSERT INTO content_to_content
			(content_id, content_type_id, associated_content_id, associated_content_type_id, site_id, associated_site_id
			, [enabled], modified, created, sort_order)
		Values
			(@contentId, @contentTypeId, @associatedContentId, @associatedContentTypeId, @siteId, @associatedSiteId
			, @enabled, @created, @created, @sortOrder)

		SET @id = SCOPE_IDENTITY()

	END

END
GO

GRANT EXECUTE ON adminPlatform_RestoreContentToContent TO VpWebApp 
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
			LEFT JOIN dbo.product_to_product ptp WITH(NOLOCK) ON ptp.parent_product_id = pro.product_id OR ptp.product_id = pro.product_id
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
			AND (ptp.product_to_product_id IS NULL) --non product to product relationship
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

        --DELETE FROM product_to_product
        --WHERE product_id = @productId;
		
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

		DELETE FROM action_to_content
		WHERE content_id = @productId AND content_type_id = 2;

		DELETE FROM content_location
		WHERE content_id = @productId AND content_type_id = 2;

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

	SELECT ROW_NUMBER() OVER (ORDER BY Tmp.id desc) AS row , Tmp.id AS id
	INTO #temp
	FROM
	(
		SELECT DISTINCT ar.archived_product_id AS id
		FROM [dbo].[archived_product] ar WITH(NOLOCK) 
			INNER JOIN dbo.archived_product_to_category arp ON arp.archived_product_id = ar.archived_product_id AND (@categoryId = 0 OR (arp.category_id = @categoryId))
		WHERE (@vendorId = -1 OR ar.vendor_id = @vendorId)
		AND (@productId = -1 OR ar.product_id = @productId)
		AND (@catalogNumber = '' OR ar.catalog_number LIKE '%'+ @catalogNumber + '%')
		AND (@productName = '' OR ar.product_name LIKE '%'+ @productName +'%')
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

