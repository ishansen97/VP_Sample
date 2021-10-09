EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsSegmentListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsSegmentListWithPaging
    @categoryId int,
    @searchGroupId int,
    @numberOfResults int,
    @mainIndexSelection varchar(10),
    @startIndex int,
    @endIndex int,
    @searchOptionIds varchar(50)
AS
-- ==========================================================================
-- $ Author : Dhanushka $
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
      
	CREATE TABLE #primary_search_option_ids (search_option_id int)
	CREATE TABLE #product_ids(product_id int)
	CREATE TABLE #search_option_ids(search_option_id int) 
      
	INSERT INTO #primary_search_option_ids (search_option_id)
	SELECT primary_ids.[value]
	FROM global_Split(@searchOptionIds, ',') primary_ids

	DECLARE @optCount int
	SELECT @optCount = COUNT(*) FROM #primary_search_option_ids

	INSERT INTO #product_ids
	SELECT pso.product_id
	FROM product_to_search_option pso
		INNER JOIN #primary_search_option_ids psoid
			ON pso.search_option_id = psoid.search_option_id
		INNER JOIN product_to_category pc
			ON pc.product_id = pso.product_id
		INNER JOIN product p
			ON pc.product_id = p.product_id
	WHERE pc.category_id = @categoryId AND pc.[enabled] = 1 AND p.[enabled] = 1 AND p.show_in_matrix = 1
	GROUP BY pso.product_id
	HAVING COUNT(pso.product_id) = @optCount

	IF (@mainIndexSelection = 'num')
	BEGIN
		INSERT INTO #search_option_ids
		SELECT DISTINCT s.search_option_id
		FROM search_option s
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id
			INNER JOIN #product_ids
				ON ps.product_id = #product_ids.product_id
		WHERE s.[enabled] = 1 AND s.search_group_id = @searchGroupId AND s.[name] NOT LIKE '[abcdefghijklmnopqrstuvwxyz]%'
	END
	ELSE
	BEGIN
		INSERT INTO #search_option_ids
		SELECT DISTINCT s.search_option_id
		FROM search_option s
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id
			INNER JOIN #product_ids
				ON ps.product_id = #product_ids.product_id
		WHERE s.[enabled] = 1 AND s.search_group_id = @searchGroupId AND s.[name] LIKE '' + @mainIndexSelection + '%'
	END

	;WITH ordered_search_options ([row], id, search_group_id, [name], sort_order, created, [enabled], modified) AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY [name]) AS [row], search_option.search_option_id AS id, 
			search_group_id, [name], sort_order, created, [enabled], modified
		FROM search_option
			INNER JOIN #search_option_ids
				ON search_option.search_option_id = #search_option_ids.search_option_id
	)

	SELECT id, search_group_id, [name], sort_order, created, [enabled], modified
	FROM ordered_search_options
	WHERE [row] BETWEEN @startIndex AND @endIndex
	ORDER BY [row]

	DROP TABLE #primary_search_option_ids
	DROP TABLE #product_ids
	DROP TABLE #search_option_ids
      
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsSegmentListWithPaging TO VpWebApp 
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsSegmentListWithoutPrimaryOptionsWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsSegmentListWithoutPrimaryOptionsWithPaging
    @categoryId int,
    @searchGroupId int,
    @numberOfResults int,
    @mainIndexSelection varchar(10),
    @startIndex int,
    @endIndex int
AS
-- ==========================================================================
-- $ Author : Dhanushka $
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
      
	CREATE TABLE #search_option_ids(search_option_id int)

	IF (@mainIndexSelection = 'num')
	BEGIN
		INSERT INTO #search_option_ids
		SELECT DISTINCT s.search_option_id
		FROM search_option s
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id
			INNER JOIN product_to_category pc
				ON pc.product_id = ps.product_id
			INNER JOIN product p
				ON pc.product_id = p.product_id
		WHERE pc.category_id = @categoryId AND pc.[enabled] = 1 AND p.[enabled] = 1 AND p.show_in_matrix = 1 AND
			s.[enabled] = 1 AND s.search_group_id = @searchGroupId AND s.[name] NOT LIKE '[abcdefghijklmnopqrstuvwxyz]%'
	END
	ELSE
	BEGIN
		INSERT INTO #search_option_ids
		SELECT DISTINCT s.search_option_id
		FROM search_option s
			INNER JOIN product_to_search_option ps
				ON ps.search_option_id = s.search_option_id
			INNER JOIN product_to_category pc
				ON pc.product_id = ps.product_id
			INNER JOIN product p
				ON pc.product_id = p.product_id
		WHERE pc.category_id = @categoryId AND pc.[enabled] = 1 AND p.[enabled] = 1 AND p.show_in_matrix = 1 AND
			s.[enabled] = 1 AND s.search_group_id = @searchGroupId AND s.[name] LIKE '' + @mainIndexSelection + '%'
	END

	;WITH ordered_search_options ([row], id, search_group_id, [name], sort_order, created, [enabled], modified) AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY [name]) AS [row], search_option.search_option_id AS id, 
			search_group_id, [name], sort_order, created, [enabled], modified
		FROM search_option
			INNER JOIN #search_option_ids
				ON search_option.search_option_id = #search_option_ids.search_option_id
	)

	SELECT id, search_group_id, [name], sort_order, created, [enabled], modified
	FROM ordered_search_options
	WHERE [row] BETWEEN @startIndex AND @endIndex
	ORDER BY [row]

	DROP TABLE #primary_search_option_ids
	DROP TABLE #product_ids
	DROP TABLE #search_option_ids
      
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsSegmentListWithoutPrimaryOptionsWithPaging TO VpWebApp 
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList
      @categoryId int,
      @manufacturerId int,
      @productId int,
      @startRowIndex int,
      @endRowIndex int,
      @partialLeadEnabled bit,
      @countryFlag1 bigint,
      @countryFlag2 bigint,
      @countryFlag3 bigint,
      @countryFlag4 bigint,
      @totalRowCount int output
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
      
      SET NOCOUNT ON;

      DECLARE @maxLimit int
      SET @maxLimit = 20

      CREATE TABLE #random_product_list (random_product_list_id int identity(1,1), product_id int)

      INSERT INTO #random_product_list (product_id)
      SELECT TOP(@maxLimit) p.product_id
      FROM product p
            INNER JOIN product_to_category pc
                  ON p.product_id = pc.product_id
            INNER JOIN product_to_vendor pv
                  ON p.product_id = pv.product_id                                   
      WHERE pc.category_id = @categoryId 
            AND pv.vendor_id = @manufacturerId 
            AND p.[enabled] = 1
            AND pc.[enabled] = 1
            AND pv.[enabled] = 1
            AND pv.is_manufacturer = 1 
            AND p.product_id <> @productId 
            AND
            (
                  (p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
                  (p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
            )
            --AND (@partialLeadEnabled IS NULL OR pv.lead_enabled = @partialLeadEnabled)
      ORDER BY NEWID()

      SELECT @totalRowCount = COUNT(*)
      FROM #random_product_list

      SELECT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, [enabled]
            , modified, created, product_type, [status], has_related, has_model, completeness
            , flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
            , show_in_matrix, show_detail_page, default_rank, default_search_rank
      FROM #random_product_list
            INNER JOIN product
                  ON #random_product_list.product_id = product.product_id
      WHERE random_product_list_id BETWEEN @startRowIndex AND @endRowIndex
      ORDER BY product_name

      DROP TABLE #random_product_list

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList TO VpWebApp 
GO

--------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByVendorIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryByVendorIdList
      @vendorId int
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
      
      SET NOCOUNT ON;
      
      CREATE TABLE #category_ids (category_id int)

      INSERT INTO #category_ids (category_id)
      SELECT c.category_id    
      FROM category c
            INNER JOIN category_to_vendor cv
                  ON c.category_id = cv.category_id
      WHERE cv.vendor_id = @vendorId 
            AND c.[enabled] = 1
            AND cv.[enabled] = 1
            AND c.hidden = 0

      INSERT INTO #category_ids (category_id)
      SELECT category_id 
      FROM
      (
            SELECT DISTINCT c.category_id
            FROM product_to_vendor pv
                        INNER JOIN product_to_category pc
                              ON pv.product_id = pc.product_id
                        INNER JOIN category c
                              ON pc.category_id = c.category_id
                        INNER JOIN product p 
                              ON pc.product_id = p.product_id
            WHERE pv.vendor_id = @vendorId 
                  AND pv.[enabled] = 1 
                  AND pc.[enabled] = 1
                  AND c.[enabled] = 1
                  AND p.[enabled] = 1 
                  AND c.hidden = 0
      ) unique_category_ids
      WHERE category_id NOT IN (SELECT category_id FROM #category_ids)

      SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], specification
                  , [enabled], modified, created, is_search_category, is_displayed
                  , short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id
      FROM #category_ids
            INNER JOIN category
                  ON #category_ids.category_id = category.category_id
      ORDER BY category_name

      DROP TABLE #category_ids

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryByVendorIdList TO VpWebApp 
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByOtherUserRequestedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByOtherUserRequestedList
      @siteId int,
      @userId int,
      @actionId int,
      @leadIds varchar(1000),
      @categoryId int,
      @rows int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
      
SET NOCOUNT ON;

      DECLARE @months int
      SET @months = -3

      DECLARE @maxProductLimit int
      SET @maxProductLimit = 50

      CREATE TABLE #public_user_ids (public_user_id int)
      CREATE TABLE #product_ids (product_id int, leads int)
      CREATE TABLE #action_enabled_product_ids (id int identity(1, 1), product_id int)

      -- Get users who have submited leads with in last specified months for the same products as the current user's lead request.
      INSERT INTO #public_user_ids (public_user_id)
      SELECT DISTINCT public_user_id
      FROM lead
      WHERE lead.created > DATEADD(m, @months, GETDATE()) 
            AND lead.site_id = @siteId 
            AND public_user_id <> @userId 
            AND content_type_id = 2 
            AND content_id IN 
            (
                  SELECT l.content_id 
                  FROM lead l
                        INNER JOIN global_Split(@leadIds, ',') lead_ids
                              ON l.lead_id = lead_ids.[value]
            )

      -- Get products that above user's have submited leads within last specified months for different categories.
      INSERT INTO #product_ids (product_id, leads)
      SELECT TOP (@maxProductLimit) lead.content_id, COUNT(*) leads
      FROM #public_user_ids
            INNER JOIN lead
                  ON #public_user_ids.public_user_id = lead.public_user_id
            INNER JOIN product_to_category
                  ON lead.content_id = product_to_category.product_id
      WHERE lead.content_type_id = 2
            AND product_to_category.category_id <> @categoryId
            AND lead.created > DATEADD(m, @months, GETDATE()) 
            AND lead.site_id = @siteId
            AND content_id NOT IN 
            (
                  SELECT l.content_id 
                  FROM lead l
                        INNER JOIN global_Split(@leadIds, ',') lead_ids
                              ON l.lead_id = lead_ids.[value]
            )
      GROUP BY lead.content_id
      ORDER BY COUNT(*) DESC

      -- Check if the actions are enabled for above products.
      INSERT INTO #action_enabled_product_ids (product_id)
      SELECT product_id
      FROM
      (
      SELECT DISTINCT product.product_id, #product_ids.leads
      FROM #product_ids
            INNER JOIN product 
                  ON #product_ids.product_id = product.product_id 
            INNER JOIN product_to_vendor 
                  ON product.product_id = product_to_vendor.product_id
            INNER JOIN vendor 
                  ON product_to_vendor.vendor_id = vendor.vendor_id
            INNER JOIN product_to_category 
                  ON product.product_id = product_to_category.product_id
            LEFT OUTER JOIN action_to_content ap
                  ON ap.action_id = @actionId AND ap.content_id = product.product_id AND ap.content_type_id = 2
            LEFT OUTER JOIN action_to_content av
                  ON av.action_id = @actionId AND av.content_id = vendor.vendor_id AND av.content_type_id = 6
            LEFT OUTER JOIN action_to_content ac
                  ON ac.action_id = @actionId AND ac.content_id = product_to_category.category_id AND ac.content_type_id = 1
            LEFT OUTER JOIN action_to_content ast
                  ON ast.action_id = @actionId AND ast.content_id = @siteId AND ast.content_type_id = 5
      WHERE product.[enabled] = 1 
            AND vendor.[enabled] = 1 
            AND (COALESCE(ap.[enabled], av.[enabled], ac.[enabled], ast.[enabled]) = 1)
      ) product_leads
      ORDER BY leads DESC


      -- Keep only one product from a vendor. Delete all the others.
      -- Delete strategy is to delete least number of lead submited products.
      DELETE FROM #action_enabled_product_ids
      WHERE id NOT IN 
      (
            SELECT MIN(aep.id) 
            FROM #action_enabled_product_ids aep
                  INNER JOIN product_to_vendor pv on aep.product_id = pv.product_id
            GROUP BY vendor_id
      )

      -- Select products that user have not submitted leads for the past month.
      SELECT TOP (@rows) product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, 
            [enabled], modified, created, product_type, [status], has_related, has_model, completeness, flag1, 
            flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, 
            show_in_matrix, show_detail_page, default_rank, default_search_rank
      FROM #action_enabled_product_ids aepd
            INNER JOIN product 
                  ON aepd.product_id = product.product_id
      WHERE product.product_id NOT IN 
      (
            SELECT content_id 
            FROM lead l 
            WHERE public_user_id = @userId 
                  AND created > DATEADD(m, -1, GETDATE()) 
                  AND site_id = @siteId
      )

      DROP TABLE #product_ids
      DROP TABLE #public_user_ids
      DROP TABLE #action_enabled_product_ids

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByOtherUserRequestedList TO VpWebApp 
GO

------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsByOtherUserRequestedListCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsByOtherUserRequestedListCategoryId
      @siteId int,
      @categoryId int,
      @actionId int,
      @productIds varchar(255),
      @rows int,
      @userId int,
      @leadIds varchar(255)
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
      
SET NOCOUNT ON;

      DECLARE @maxProductLimit int
      SET @maxProductLimit = 50

      CREATE TABLE #product_ids (product_id int, leads int)
      CREATE TABLE #action_enabled_product_ids (id int identity(1, 1), product_id int)

      -- Get products that have leads in the same category without current products.
      INSERT INTO #product_ids (product_id, leads)
      SELECT TOP (@maxProductLimit) lead.content_id, COUNT(*) leads
      FROM lead
            INNER JOIN product_to_category
                  ON lead.content_id = product_to_category.product_id
      WHERE lead.content_type_id = 2
            AND product_to_category.category_id = @categoryId
            AND lead.site_id = @siteId
            AND content_id NOT IN 
            (
                  SELECT l.content_id 
                  FROM lead l
                        INNER JOIN global_Split(@leadIds, ',') lead_ids
                              ON l.lead_id = lead_ids.[value]
            )
      GROUP BY lead.content_id
      ORDER BY COUNT(*) DESC
            
      -- Check if the actions are enabled for above products.
      INSERT INTO #action_enabled_product_ids (product_id)
      SELECT product_id
      FROM
      (
      SELECT DISTINCT product.product_id, #product_ids.leads
      FROM #product_ids
            INNER JOIN product 
                  ON #product_ids.product_id = product.product_id 
            INNER JOIN product_to_vendor 
                  ON product.product_id = product_to_vendor.product_id
            INNER JOIN vendor 
                  ON product_to_vendor.vendor_id = vendor.vendor_id
            INNER JOIN product_to_category 
                  ON product.product_id = product_to_category.product_id
            LEFT OUTER JOIN action_to_content ap
                  ON ap.action_id = @actionId AND ap.content_id = product.product_id AND ap.content_type_id = 2
            LEFT OUTER JOIN action_to_content av
                  ON av.action_id = @actionId AND av.content_id = vendor.vendor_id AND av.content_type_id = 6
            LEFT OUTER JOIN action_to_content ac
                  ON ac.action_id = @actionId AND ac.content_id = product_to_category.category_id AND ac.content_type_id = 1
            LEFT OUTER JOIN action_to_content ast
                  ON ast.action_id = @actionId AND ast.content_id = @siteId AND ast.content_type_id = 5
      WHERE product.[enabled] = 1 
            AND vendor.[enabled] = 1 
            AND (COALESCE(ap.[enabled], av.[enabled], ac.[enabled], ast.[enabled]) = 1)
      ) product_leads
      ORDER BY leads DESC
            
      -- Keep only one product from a vendor. Delete all the others.
      -- Delete strategy is to delete least number of lead submited products.
      DELETE FROM #action_enabled_product_ids
      WHERE id NOT IN 
      (
            SELECT MIN(aep.id) 
            FROM #action_enabled_product_ids aep
                  INNER JOIN product_to_vendor pv on aep.product_id = pv.product_id
            GROUP BY vendor_id
      )
            
      -- Select products that user have not submitted leads for the past month.
      SELECT TOP (@rows) product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, 
            [enabled], modified, created, product_type, [status], has_related, has_model, completeness, flag1, 
            flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, 
            show_in_matrix, show_detail_page, default_rank, default_search_rank
      FROM #action_enabled_product_ids aepd
            INNER JOIN product 
                  ON aepd.product_id = product.product_id
      WHERE product.product_id NOT IN 
      (
            SELECT content_id 
            FROM lead l 
            WHERE public_user_id = @userId 
                  AND created > DATEADD(m, -1, GETDATE()) 
                  AND site_id = @siteId
      )
            
      DROP TABLE #product_ids
      DROP TABLE #action_enabled_product_ids
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsByOtherUserRequestedListCategoryId TO VpWebApp 
GO

----------