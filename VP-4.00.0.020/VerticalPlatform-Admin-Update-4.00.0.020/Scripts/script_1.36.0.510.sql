IF NOT EXISTS(SELECT * FROM [dbo].[module] WHERE module_name = 'ArticleTypeAssociatedCategoryList')
BEGIN
	INSERT INTO	[dbo].[module]
				([module_name]
				,[usercontrol_name]
				,[enabled]
				,[modified]
				,[created]
				,[is_container])
			VALUES
				('ArticleTypeAssociatedCategoryList'
				,'~/Modules/Article/ArticleTypeAssociatedCategoryList.ascx'
				,1
				,GetDate()
				,GetDate()
				,0)
END
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicCategory_GetCategoryByArticleTypeIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicCategory_GetCategoryByArticleTypeIdList
	@siteId INT, 
	@articleTypeIds VARCHAR(MAX),
	@startIndex int,
	@endIndex int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	;WITH article_type_associated_category_list AS (
		SELECT		ROW_NUMBER() OVER (ORDER BY category_id) AS row, 
					category_id AS id, site_id, category_name, category_type_id, [description], short_name
					, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
					, auto_generated, hidden, has_image, url_id
		FROM category WHERE EXISTS (
			SELECT associated_content_id
				 , [enabled],created,modified,site_id, associated_site_id, sort_order
			FROM content_to_content
			WHERE content_type_id =4 AND enabled = 1 AND  associated_content_id = category.category_id AND site_id = @siteId AND  associated_content_type_id = 1 
					AND content_id IN (
						SELECT article_id FROM article WHERE site_id = @siteid AND article_type_id IN (
							SELECT [value] FROM Global_Split(@articleTypeIds, ','))
					)

		)
		AND enabled = 1)


		SELECT * 
		FROM article_type_associated_category_list
		WHERE (row BETWEEN @startIndex AND @endIndex) OR (@startIndex = 0)
		ORDER BY row

		SELECT @totalCount = COUNT(*)
		FROM category WHERE EXISTS (
			SELECT associated_content_id
				 , [enabled],created,modified,site_id, associated_site_id, sort_order
			FROM content_to_content
			WHERE content_type_id =4 AND enabled = 1 AND  associated_content_id = category.category_id AND site_id = @siteId AND  associated_content_type_id = 1 
					AND content_id IN (
						SELECT article_id FROM article WHERE site_id = @siteid AND article_type_id IN (
							SELECT [value] FROM Global_Split(@articleTypeIds, ','))
					)

		)
		AND enabled = 1
END
GO

GRANT EXECUTE ON dbo.publicCategory_GetCategoryByArticleTypeIdList TO VpWebApp 

----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedProduct(id, row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, 
		created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden,
		business_value,ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
)
	AS
	(
		SELECT  product_id, ROW_NUMBER() OVER (ORDER BY product_id DESC) AS row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified,
			created, product_type, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4, search_rank, search_content_modified
			, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product
		WHERE enabled = 1 AND site_id = @siteId
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status,
		has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
		show_in_matrix, show_detail_page, default_rank, default_search_rank

	FROM selectedProduct
	WHERE row_id BETWEEN @startIndex AND @endIndex
	ORDER BY row_id
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList TO VpWebApp
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedArticlesBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedArticlesBySiteIdWithPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedArticle(id, row_id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted)
	AS
	(
		SELECT  id, ROW_NUMBER() OVER (ORDER BY id DESC) AS row_id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM
		(	
			SELECT article_id as id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM article
			WHERE enabled = 1 AND site_id = @siteId
		) AS orderedArticles
	)

	SELECT id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
				[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
				thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM selectedArticle
	WHERE row_id BETWEEN @startIndex AND @endIndex
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedArticlesBySiteIdWithPagingList TO VpWebApp
GO

--------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId
	@contentType int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;

	IF @contentType = 1
		BEGIN
			SELECT DISTINCT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
				  ,sg.[enabled],sg.[created],sg.[modified],sg.[add_options_automatically],sg.[prefix_text]
				  ,sg.[suffix_text]
			FROM [search_group] sg
			WHERE sg.search_group_id IN (
				SELECT so.search_group_id
				FROM search_option so
					INNER JOIN product_to_search_option ptso
						ON so.search_option_id = ptso.search_option_id
					INNER JOIN product_to_category pc 
						ON ptso.product_id = pc.product_id
				WHERE pc.category_id =  @contentId
			)
		END
	ELSE IF @contentType = 6
		BEGIN
			SELECT DISTINCT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
				  ,sg.[enabled],sg.[created],sg.[modified],sg.[add_options_automatically],sg.[prefix_text]
				  ,sg.[suffix_text]
			FROM [search_group] sg
			WHERE sg.search_group_id IN (
				SELECT so.search_group_id
				FROM search_option so
					INNER JOIN product_to_search_option ptso
						ON ptso.search_option_id = so.search_option_id
					INNER JOIN product_to_vendor ptv
						ON ptv.product_id = ptso.product_id
					WHERE ptv.vendor_id = @contentId
			)
		END
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId TO VpWebApp
GO
---------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductPriceCurrencyByContentTypeContentId'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductPriceCurrencyByContentTypeContentId
	@contentType int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;

	IF @contentType = 6
		BEGIN
			SELECT DISTINCT c.[currency_id] AS [id],c.[description],c.[local_symbol],c.[international_symbol]
				,c.[enabled],c.[created],c.[modified]
			FROM currency c
				INNER JOIN product_to_vendor_to_price pvp
					ON c.currency_id = pvp.currency_id
				INNER JOIN product_to_vendor ptv
					ON pvp.product_to_vendor_id = ptv.product_to_vendor_id
			WHERE ptv.is_manufacturer = 1 AND ptv.vendor_id = @contentId
		END
	ELSE IF @contentType = 1
		BEGIN
			SELECT DISTINCT c.[currency_id] AS [id],c.[description],c.[local_symbol],c.[international_symbol]
				,c.[enabled],c.[created],c.[modified]
			FROM currency c
				INNER JOIN product_to_vendor_to_price pvp
					ON c.currency_id = pvp.currency_id
				INNER JOIN product_to_vendor ptv
					ON pvp.product_to_vendor_id = ptv.product_to_vendor_id
				INNER JOIN product p
					ON ptv.product_id = p.product_id
				INNER JOIN product_to_category ptc
					ON ptc.product_id = p.product_id
			WHERE ptc.category_id = @contentId
		END

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductPriceCurrencyByContentTypeContentId TO VpWebApp
GO
-----------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetContentSpecificationTypesByContentTypeContentId'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetContentSpecificationTypesByContentTypeContentId
	@contentType int,
	@contentId int,
	@itemContentType int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	IF @contentType = 1
		BEGIN
			SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
				  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
				  ,st.[is_expanded_view],st.[display_empty]
			FROM [specification_type] st
				INNER JOIN category_to_specification_type cst
					ON cst.[spec_type_id] = st.[spec_type_id]
			WHERE cst.category_id = @contentId
		END
	ELSE IF @contentType = 6
		IF @itemContentType = 21
			BEGIN
				SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
					  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
					  ,st.[is_expanded_view],st.[display_empty]
				FROM [specification_type] st
					INNER JOIN specification s
						ON s.spec_type_id = st.[spec_type_id]
					INNER JOIN model m
						ON m.model_id = s.content_id
					INNER JOIN product_to_vendor ptv
						ON ptv.product_id = m.product_id
				WHERE s.content_type_id = @itemContentType AND ptv.vendor_id = @contentId
			END
		ELSE
			BEGIN
				SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
					  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
					  ,st.[is_expanded_view],st.[display_empty]
				FROM [specification_type] st
					INNER JOIN specification s
						ON s.spec_type_id = st.[spec_type_id]
					INNER JOIN product_to_vendor ptv
						ON ptv.product_id = s.content_id
				WHERE s.content_type_id = @itemContentType AND ptv.vendor_id = @contentId
			END
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetContentSpecificationTypesByContentTypeContentId TO VpWebApp
GO
----------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminAction_GetVendorLevelActionContentByContentTypeIdProductModelIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAction_GetVendorLevelActionContentByContentTypeIdProductModelIdList
	@contentType int,
	@contentIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	IF @contentType = 2
		BEGIN
			SELECT ptv.product_id AS [item_id], atc.[action_to_content_id] AS [id],atc.[action_id],atc.[content_type_id],atc.[content_id],
					atc.[default_action],atc.[sort_order],atc.[enabled],atc.[created],atc.[modified]
			FROM [action_to_content] atc
				INNER JOIN product_to_vendor ptv
					ON atc.content_id = ptv.vendor_id
				INNER JOIN global_Split(@contentIds, ',') productIds
					ON productIds.value = ptv.product_id
			WHERE atc.content_type_id = 6 AND ptv.is_manufacturer = 1
		END
	ELSE IF @contentType = 21
		BEGIN
			SELECT m.model_id AS [item_id], atc.[action_to_content_id] AS [id],atc.[action_id],atc.[content_type_id],atc.[content_id],
					atc.[default_action],atc.[sort_order],atc.[enabled],atc.[created],atc.[modified]
			FROM [action_to_content] atc
				INNER JOIN product_to_vendor ptv
					ON atc.content_id = ptv.vendor_id
				INNER JOIN model m
					ON m.product_id = ptv.product_id
				INNER JOIN global_Split(@contentIds, ',') modelIds
					ON modelIds.value = m.model_id
			WHERE atc.content_type_id = 6 AND ptv.is_manufacturer = 1
		END

END
GO

GRANT EXECUTE ON dbo.adminAction_GetVendorLevelActionContentByContentTypeIdProductModelIdList TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminAction_GetCategoryLevelActionContentByContentTypeIdProductModelIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAction_GetCategoryLevelActionContentByContentTypeIdProductModelIdList
	@contentType int,
	@contentIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	WITH ItemActionContentCTE ([item_id],[id],[action_id],[content_type_id],[content_id],[default_action],[sort_order],[enabled],[created],[modified])
	AS
	(	
		SELECT ptc.product_id AS [item_id], atc.[action_to_content_id] AS [id],atc.[action_id],atc.[content_type_id],atc.[content_id],
				atc.[default_action],atc.[sort_order],atc.[enabled],atc.[created],atc.[modified]
		FROM [action_to_content] atc
			INNER JOIN product_to_category ptc
				ON ptc.category_id = atc.content_id
			INNER JOIN global_Split(@contentIds,',') contentIds
				ON contentIds.value = ptc.product_id
		WHERE @contentType = 2 AND atc.content_type_id = 1
		
		UNION ALL
		
		SELECT m.model_id AS [item_id], atc.[action_to_content_id] AS [id],atc.[action_id],atc.[content_type_id],atc.[content_id],
				atc.[default_action],atc.[sort_order],atc.[enabled],atc.[created],atc.[modified]
		FROM [action_to_content] atc
			INNER JOIN product_to_category ptc
				ON ptc.category_id = atc.content_id
			INNER JOIN model m
				ON m.product_id = ptc.product_id
			INNER JOIN global_Split(@contentIds,',') contentIds
				ON contentIds.value = m.model_id
		WHERE @contentType = 21 AND atc.content_type_id = 1
	)
	
	SELECT [item_id],[id],[action_id],[content_type_id],[content_id],[default_action],
			[sort_order],[enabled],[created],[modified]
	INTO #tempActionContent
	FROM ItemActionContentCTE

	SELECT item_id, MIN(content_id) AS [content_id]
	INTO #tempSimplifiedActionContent
	FROM #tempActionContent
	GROUP BY item_id

	SELECT #tempActionContent.[item_id],#tempActionContent.[id],#tempActionContent.[action_id],
			#tempActionContent.[content_type_id],#tempActionContent.[content_id],
			#tempActionContent.[default_action],#tempActionContent.[sort_order],#tempActionContent.[enabled],
			#tempActionContent.[created],#tempActionContent.[modified]
	FROM #tempActionContent
		INNER JOIN #tempSimplifiedActionContent
		ON #tempActionContent.item_id = #tempSimplifiedActionContent.item_id 
			AND #tempActionContent.content_id = #tempSimplifiedActionContent.content_id
		
	DROP TABLE #tempActionContent
	DROP TABLE #tempSimplifiedActionContent

END
GO

GRANT EXECUTE ON dbo.adminAction_GetCategoryLevelActionContentByContentTypeIdProductModelIdList TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicAction_GetActionContentByContentTypeIdContentIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicAction_GetActionContentByContentTypeIdContentIdsList
	@contentTypeId int,
	@contentIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT action_to_content_id AS id, action_id, content_type_id, content_id, [default_action], 
		sort_order, [enabled], created, modified
	FROM action_to_content
		INNER JOIN global_Split(@contentIds, ',') content_id_table
			ON action_to_content.content_type_id = @contentTypeId AND 
				action_to_content.content_id = content_id_table.[value]
	ORDER BY action_to_content.content_id, sort_order

END
GO

GRANT EXECUTE ON dbo.publicAction_GetActionContentByContentTypeIdContentIdsList TO VpWebApp 
GO