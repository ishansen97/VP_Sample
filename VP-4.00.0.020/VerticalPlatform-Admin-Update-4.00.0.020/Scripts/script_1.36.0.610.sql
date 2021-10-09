
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesBySiteIdLikeArticleName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesBySiteIdLikeArticleName
	@siteId int,
	@value varchar(max),
	@isEnabled bit,
	@selectLimit int,
	@isTemplate bit,
	@articleTypeId int,
	@publishedOnly bit,
	@vendorId int
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF(@vendorId IS NOT NULL)
	BEGIN
		SELECT TOP (@selectLimit) article_id as id, article_type_id, a.site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
			a.[enabled], a.modified, a.created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM  article a
		INNER JOIN content_to_content ct
			ON a.article_id = ct.content_id
		WHERE a.site_id = @siteId AND article_title like @value+'%' AND (@isEnabled IS NULL OR a.enabled = @isEnabled) AND (@isTemplate IS NULL OR is_article_template = @isTemplate)
			AND (@articleTypeId IS NULL OR article_type_id = @articleTypeId) AND (@publishedOnly IS NULL OR date_published < GETDATE()) AND deleted = 0
			AND ct.content_type_id = 4 AND ct.associated_content_type_id = 6 AND ct.associated_content_id = @vendorId
	END
	
	ELSE
	BEGIN
		SELECT TOP (@selectLimit) article_id as id, article_type_id, site_id, article_title, article_summary, date_published, start_date, end_date, published, external_url_id,
			[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
			thumbnail_image_code, article_template_id, open_new_window, flag1, flag2, flag3, flag4, search_content_modified, deleted
		FROM  article 
		WHERE site_id = @siteId AND article_title like @value+'%' AND (@isEnabled IS NULL OR enabled = @isEnabled) AND (@isTemplate IS NULL OR is_article_template = @isTemplate)
			AND (@articleTypeId IS NULL OR article_type_id = @articleTypeId) AND (@publishedOnly IS NULL OR date_published < GETDATE()) AND deleted = 0
	END

END
GO

GRANT EXECUTE ON adminArticle_GetArticlesBySiteIdLikeArticleName TO VpWebApp
GO

------------------------------------------------------------------------------------------------------------------

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
-- Author : Yasodha
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF(@categoryId IS NULL)
		BEGIN
			SELECT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
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
			SELECT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
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

--------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleByVendorIdSiteIdPagedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleByVendorIdSiteIdPagedList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@vendorId int,
	@rowCount int output
AS
-- ========================================================================
-- $ Author: Yasodha $
-- ========================================================================
BEGIN
	
	SET NOCOUNT ON;	

	
	WITH articles (row, id, article_type_id, site_id, article_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, is_template, 
		article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted) AS
	(
	SELECT (ROW_NUMBER() OVER (ORDER BY article_id)) AS row, article_id AS id, article.article_type_id, article.site_id, article_title, 
		article_summary, article_short_title, is_article_template, is_external, featured_identifier, thumbnail_image_code, 
		date_published, start_date, end_date, published, external_url_id, is_template, article_template_id, open_new_window, article.enabled, article.created, article.modified,
		flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM article
		INNER JOIN content_to_content at
			ON article.article_id = at.content_id
	WHERE article.is_template = 0 AND article.site_id = @siteId AND at.associated_content_id = @vendorId
			AND at.content_type_id = 4 AND at.associated_content_type_id = 6 AND article.deleted = 0
	)

	SELECT id, article_type_id, site_id, article_title, article_summary, article_short_title, is_article_template, 
		is_external, featured_identifier, thumbnail_image_code, date_published, start_date, end_date, published, external_url_id, 
		is_template, article_template_id, open_new_window, enabled, created, modified, flag1, flag2, flag3, flag4, search_content_modified, deleted
	FROM articles
	WHERE row BETWEEN @startIndex AND @endIndex

	SELECT @rowCount = COUNT(*) 
	FROM article
			INNER JOIN content_to_content at
			ON article.article_id = at.content_id
	WHERE article.is_template = 0 AND article.site_id = @siteId AND at.associated_content_id = @vendorId
			AND at.content_type_id = 4 AND at.associated_content_type_id = 6 AND article.deleted = 0

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleByVendorIdSiteIdPagedList TO VpWebApp 
GO

--------------------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO

CREATE PROCEDURE dbo.adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList
	@siteId int,
	@text varchar(max),
	@categoryTypes varchar(20),
	@matrixType int,
	@selectLimit int,
	@enabled bit,
	@vendorId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #category_ids (category_id int)
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			AND category_name like @text+'%'
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId
				AND category_name like @text+'%'  
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id
			AND category_name like @text+'%'
	END

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, auto_generated, matrix_type, enabled,
				modified,  created, has_image, url_id, hidden
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
				(@categoryTypes IS NULL OR category_type_id IN (SELECT [value] FROM global_Split(@categoryTypes, ','))) 
	END
	ELSE
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, has_image, url_id, hidden
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
	END

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList TO VpWebApp
GO

-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoriesByCategoryTypes'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoriesByCategoryTypes
	@siteId int,
	@categoryTypes varchar(100),
	@pageIndex int,
	@pageSize int,
	@matrixType int, --1=MatrixA, 2=MatrixB, 3=MatrixC, 4=MatrixD, null=all types
	@enabled bit,
	@vendorId int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1)
	SET @endIndex = @pageSize * @pageIndex
	
	CREATE TABLE #category_ids (category_id int)
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId  
				AND (@enabled IS NULL OR c.enabled = @enabled)
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id 
			AND (@enabled IS NULL OR enabled = @enabled)
	END
	
	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT @totalCount = COUNT(*)
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
			(@categoryTypes IS NULL OR category_type_id IN (SELECT [value] FROM global_Split(@categoryTypes, ','))) AND 
			@siteId = site_id AND (@enabled IS NULL OR enabled = @enabled)  ;
	
		WITH temp_category (row, id, site_id, category_name, category_type_id, description, short_name, specification, is_search_category, 
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated, hidden, has_image, url_id) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
			WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
				(@categoryTypes IS NULL OR category_type_id IN (SELECT [value] FROM global_Split(@categoryTypes, ',')))
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated, hidden, has_image, url_id
		FROM temp_category
		WHERE row BETWEEN @startIndex AND @endIndex
		ORDER BY row
	END

	ELSE
	BEGIN
		-- At this moment not clear about matrix b and matrix c. Since we are not sure about what category types to be returned
		-- returning all categories for the site.
		SELECT @totalCount = COUNT(*)
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE @siteId = site_id AND (@enabled IS NULL OR enabled = @enabled);

		WITH temp_category (row, id, site_id, category_name, category_type_id, description, short_name, specification, is_search_category, 
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated
		FROM temp_category
		WHERE row BETWEEN @startIndex AND @endIndex
		ORDER BY row
	END

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoriesByCategoryTypes TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList
	@siteId int,
	@text varchar(max),
	@categoryType int,
	@matrixType int,
	@selectLimit int,
	@vendorId int,
	@enabled bit
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #category_ids (category_id int)
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id
	END

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, 
				auto_generated, hidden, matrix_type, enabled,
				modified,  created, has_image, url_id
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType)
			AND (@categoryType IS NULL OR category_type_id = @categoryType)
			AND category_name like @text+'%'
	END
	ELSE
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE category_name like @text+'%' 
	END
	
	DROP TABLE #category_ids

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList TO VpWebApp
GO

------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdCategoryTypePageIndexPageSizeMatrixTypeIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO

CREATE PROCEDURE dbo.adminProduct_GetCategoryBySiteIdCategoryTypePageIndexPageSizeMatrixTypeIdsList
	@siteId int,
	@categoryType int,
	@pageIndex int,
	@pageSize int,
	@matrixType int, --1=MatrixA, 2=MatrixB, 3=MatrixC, 4=MatrixD, null=all types
	@enabled bit,
	@vendorId int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1)
	SET @endIndex = @pageSize * @pageIndex
	
	CREATE TABLE #category_ids (category_id int)
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId  
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id 
	END

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT @totalCount = COUNT(*)
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
			(@categoryType IS NULL OR category_type_id = @categoryType)
	
		;WITH temp_category (row, id, site_id, category_name, category_type_id, description, short_name, specification, is_search_category, 
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated, hidden, has_image, url_id) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
			WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
				(@categoryType IS NULL OR category_type_id = @categoryType)
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated, hidden, has_image, url_id
		FROM temp_category
		WHERE row BETWEEN @startIndex AND @endIndex
		ORDER BY row
	END

	ELSE
	BEGIN
		-- At this moment not clear about matrix b and matrix c. Since we are not sure about what category types to be returned
		-- returning all categories for the site.
		SELECT @totalCount = COUNT(*)
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id

		;WITH temp_category (row, id, site_id, category_name, category_type_id, description, short_name, specification, is_search_category, 
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated, hidden, has_image, url_id) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated, hidden, has_image, url_id
		FROM temp_category
		WHERE row BETWEEN @startIndex AND @endIndex
		ORDER BY row
	END
	
	DROP TABLE #category_ids

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdCategoryTypePageIndexPageSizeMatrixTypeIdsList TO VpWebApp 
GO