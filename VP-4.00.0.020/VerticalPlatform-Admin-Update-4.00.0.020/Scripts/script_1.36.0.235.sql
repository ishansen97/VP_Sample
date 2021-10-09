EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationTypeListByVendorIdCategoryIdSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationTypeListByVendorIdCategoryIdSiteId
	@vendorId int,
	@categoryId int,
	@siteId int,
	@liveProductsOnly bit
AS
-- ==========================================================================
-- $Author: Dimuthu$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF @liveProductsOnly = 1
		BEGIN
			SELECT specification_type.spec_type_id AS id, spec_type, validation_expression , specification_type.site_id
				, specification_type.[enabled], specification_type.modified, specification_type.created
				, is_visible, search_enabled, is_expanded_view, display_empty
			FROM specification_type
			WHERE specification_type.site_id = @siteId AND specification_type.spec_type_id IN (
				SELECT specification.spec_type_id
					FROM product_to_category
						INNER JOIN product_to_vendor
							ON product_to_category.product_id = product_to_vendor.product_id
						INNER JOIN specification
							ON product_to_category.product_id = specification.content_id AND specification.content_type_id = 2
						INNER JOIN product
							ON product.product_id = product_to_category.product_id
						INNER JOIN vendor
							ON vendor.vendor_id =  product_to_vendor.vendor_id
						INNER JOIN category
							ON category.category_id = product_to_category.category_id
					WHERE (product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id = @vendorId AND product.[enabled] = 1 AND
						vendor.[enabled] = 1 AND product_to_category.[enabled] = 1 AND product_to_vendor.[enabled] = 1 AND category.[enabled] = 1)
			)
			ORDER BY specification_type.spec_type
		END	
	ELSE
		BEGIN
			SELECT specification_type.spec_type_id AS id, spec_type, validation_expression , specification_type.site_id
			, specification_type.[enabled], specification_type.modified, specification_type.created
			, is_visible, search_enabled, is_expanded_view, display_empty
			FROM specification_type
			WHERE specification_type.site_id = @siteId AND specification_type.spec_type_id IN (
				SELECT specification.spec_type_id
					FROM product_to_category
						INNER JOIN product_to_vendor
							ON product_to_category.product_id = product_to_vendor.product_id
						INNER JOIN specification
							ON product_to_category.product_id = specification.content_id AND specification.content_type_id = 2
					WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id = @vendorId 
			)
			ORDER BY specification_type.spec_type
		END
END
GO 	

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeListByVendorIdCategoryIdSiteId TO VpWebApp
GO
-----------------------------------------------------------------------------------------------------------
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
-- Author : Rifaz
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
            AND (COALESCE(ap.[enabled], av.[enabled], ac.[enabled], ast.[enabled]) = 1) AND
			  (
				(
				  SELECT MAX(leads_enabled) leads_enabled
				  FROM (
						SELECT 
							  CASE	WHEN (parameter_type_id = 101 AND vendor_parameter_value = 1) THEN 1
									WHEN parameter_type_id = 47 AND vendor_parameter_value = 1 THEN 0
									WHEN parameter_type_id = 47 AND vendor_parameter_value = 0 THEN 1
									ELSE 0 
							  END leads_enabled
						FROM vendor_parameter vp 
						WHERE vp.vendor_id = vendor.vendor_id
				  ) AS temp_leads_enabled
				) = 0
			  )
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
----------------------------------------------------------------------------------------------
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
-- Author : Rifaz
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
            AND (COALESCE(ap.[enabled], av.[enabled], ac.[enabled], ast.[enabled]) = 1) AND
			  (
				(
				  SELECT MAX(leads_enabled) leads_enabled
				  FROM (
						SELECT 
							  CASE	WHEN (parameter_type_id = 101 AND vendor_parameter_value = 1) THEN 1
									WHEN parameter_type_id = 47 AND vendor_parameter_value = 1 THEN 0
									WHEN parameter_type_id = 47 AND vendor_parameter_value = 0 THEN 1
									ELSE 0 
							  END leads_enabled
						FROM vendor_parameter vp 
						WHERE vp.vendor_id = vendor.vendor_id
				  ) AS temp_leads_enabled
				) = 0
			  )
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

---------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM parameter_type WHERE parameter_type = 'PersistUserLogin')
BEGIN
	INSERT INTO parameter_type (parameter_type_id, parameter_type, enabled, created, modified)
		VALUES(162, 'PersistUserLogin', 1, GETDATE(), GETDATE())
END
