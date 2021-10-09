--archived_article table

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='archived_article' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[archived_article](
		[archived_article_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
		[article_id] INT UNIQUE NOT NULL,
		[site_id] [int] NOT NULL,

		[title] [varchar](1000) NULL,
		[author_id] [int] NULL,
		[article_type_id] INT NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		is_restore BIT DEFAULT 0 NOT NULL
	 CONSTRAINT [archived_article_id] PRIMARY KEY CLUSTERED 
	(
		[archived_article_id] ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY];

	ALTER TABLE [dbo].[archived_article]  WITH CHECK ADD  CONSTRAINT [FK_archived_article_site] FOREIGN KEY([site_id])
	REFERENCES [dbo].[site] ([site_id]);

	ALTER TABLE [dbo].[archived_article] CHECK CONSTRAINT [FK_archived_article_site];

END
GO




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
  SELECT exv.[exhibition_vendor_id]
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
  INNER JOIN [dbo].[exhibition] ex ON	ex.exhibition_id = exv.exhibition_id
  WHERE ex.article_id = @article_id 


  --exhibition_vendor_special
  SELECT evs.[exhibition_vendor_special_id]
      ,evs.[exhibition_vendor_id]
      ,evs.[title]
      ,evs.[description]
      ,evs.[image_name]
      ,evs.[enabled]
      ,evs.[modified]
      ,evs.[created]
  FROM [dbo].[exhibition_vendor_special] evs
  INNER JOIN [dbo].[exhibition_vendor] exv ON exv.exhibition_vendor_id = evs.exhibition_vendor_id
  INNER JOIN [dbo].[exhibition] ex ON	ex.exhibition_id = exv.exhibition_id
  WHERE ex.article_id = @article_id 


  --exhibition_category
  SELECT ec.[exhibition_category_id]
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
  SELECT ectev.[exhibition_category_to_exhibition_vendor_id]
      ,ectev.[exhibition_category_id]
      ,ectev.[exhibition_vendor_id]
      ,ectev.[enabled]
      ,ectev.[modified]
      ,ectev.[created]
      ,ectev.[sort_order]
  FROM [dbo].[exhibition_category_to_exhibition_vendor] ectev
  INNER JOIN [dbo].[exhibition_vendor] exv ON	exv.exhibition_vendor_id = ectev.exhibition_vendor_id
  INNER JOIN [dbo].[exhibition] ex ON	ex.exhibition_id = exv.exhibition_id
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





EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArchivedByArtcle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArchivedByArtcle
	@last_rundate DATETIME
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE	article
	SET		archived = 1
	FROM	article 
	WHERE	modified > @last_rundate
			AND enabled = 0
			AND archived = 0
	
END
GO

GRANT EXECUTE ON adminArticle_UpdateArchivedByArtcle TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArchivingArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArchivingArticleIdsList
@limit INT = 10
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) art.article_id AS [id]
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	art.start_date < GETDATE()   --future start date run date
			AND art.archived = 1 
	ORDER BY art.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'adminArchivedArticle_AddArchivedArticle';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminArchivedArticle_AddArchivedArticle]
    @article_id INT,
    @siteId INT,
    @title VARCHAR(1000),
	@author_id int,
	@article_type_id int,
    @isRestore BIT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;

    INSERT INTO archived_article
    (
        [article_id],
        site_id,
        [title],
		[author_id],
		[article_type_id],
        created,
        is_restore
    )
    VALUES
    (   
	@article_id,
	@siteId,
	@title,
	@author_id,
	@article_type_id,
	GETDATE(),
    @isRestore
	);

END;
GO


GRANT EXECUTE ON dbo.adminArchivedArticle_AddArchivedArticle TO VpWebApp;
GO



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


		--exhibition_vendor_special
		DELETE evs
		FROM exhibition_vendor_special evs 
		INNER JOIN dbo.exhibition_vendor exv ON	exv.exhibition_vendor_id = evs.exhibition_vendor_id
		INNER JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
		WHERE ex.article_id = @articleId


		--exhibition_vendor
		DELETE exv
		FROM dbo.exhibition_vendor exv
		INNER JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
		WHERE ex.article_id = @articleId


		--exhibition_category_to_exhibition_vendor
		DELETE evs
		FROM exhibition_category_to_exhibition_vendor evs 
		INNER JOIN dbo.exhibition_vendor exv ON	exv.exhibition_vendor_id = evs.exhibition_vendor_id
		INNER JOIN exhibition ex ON ex.exhibition_id = exv.exhibition_id
		WHERE ex.article_id = @articleId

		--Exhibition_Category
		DELETE evs
		FROM Exhibition_Category evs 
		INNER JOIN exhibition ex ON ex.exhibition_id = evs.exhibition_id
		WHERE ex.article_id = @articleId

		--exhibition
		DELETE ex
		FROM exhibition ex 
		WHERE ex.article_id = @articleId


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

        DELETE FROM product
        WHERE product_id = @productId;

        DELETE FROM model
        WHERE product_id = @productId;

        DELETE FROM product_to_product
        WHERE product_id = @productId;

        DELETE FROM product_to_url
        WHERE product_id = @productId;

        DELETE FROM product_compression_group_to_product
        WHERE product_id = @productId;

        DELETE FROM product_multimedia_item
        WHERE product_id = @productId;

        DELETE FROM product_parameter
        WHERE product_id = @productId;

        DELETE FROM product_to_article
        WHERE product_id = @productId;

		DELETE FROM dbo.specification
		WHERE content_id = @productId AND content_type_id = 2

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


EXEC dbo.global_DropStoredProcedure 'adminArchivedArticle_AddArchivedArticle';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminArchivedArticle_AddArchivedArticle]
    @article_id INT,
    @siteId INT,
    @title VARCHAR(1000),
	@author_id int,
	@article_type_id int,
    @isRestore BIT,
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()

    INSERT INTO archived_article
    (
        [article_id],
        site_id,
        [title],
		[author_id],
		[article_type_id],
        created,
		[modified],
        is_restore
    )
    VALUES
    (   
	@article_id,
	@siteId,
	@title,
	@author_id,
	@article_type_id,
	@created,
	@created,
    @isRestore
	);

	SET @id = SCOPE_IDENTITY();

END;
GO


GRANT EXECUTE ON dbo.adminArchivedArticle_AddArchivedArticle TO VpWebApp;
GO


