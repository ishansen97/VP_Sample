IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE [parameter_type_id] = 193 AND [parameter_type] = 'ShowCitationsCountForProduct')
BEGIN
	INSERT INTO [parameter_type]
           ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
     VALUES
           (193,'ShowCitationsCountForProduct',1,GetDate(),GetDate())
END
GO
-------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationByProductId
	@productId INT
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified, authors
	FROM citation
	WHERE product_id = @productId

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductId TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductId TO VpWebAPI
GO
-------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'secondary_naming_rule' AND Object_ID = Object_ID(N'fixed_guided_browse'))
BEGIN
    ALTER TABLE fixed_guided_browse
	ADD secondary_naming_rule VARCHAR(500) NULL
END

-------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'exclude_primary_options' AND Object_ID = Object_ID(N'fixed_guided_browse'))
BEGIN
    ALTER TABLE fixed_guided_browse
	ADD exclude_primary_options BIT NOT NULL DEFAULT 0 WITH VALUES
END

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowse
	@id int

AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt, secondary_naming_rule, exclude_primary_options
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllFixedGuidedBrowses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllFixedGuidedBrowses
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt, secondary_naming_rule, exclude_primary_options
	FROM fixed_guided_browse
	WHERE [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllFixedGuidedBrowses TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowse
	@id int,
	@categoryId int,
	@name varchar(200),
	@enabled bit,	
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
	@buildOptionList bit,
	@isDynamic bit,
	@includeInSitemap bit,
	@isClean bit,
	@prebuilt bit,
	@secondaryNamingRule VARCHAR(500),
	@excludePrimaryOptions BIT,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE fixed_guided_browse
	SET
		category_id = @categoryId,
		[name] = @name,
		segment_size = @segmentSize,
		prefix_text = @prefixText,
		suffix_text = @suffixText,
		naming_rule = @namingRule,
		enabled = @enabled,
		modified = @modified,
		build_option_list = @buildOptionList, 
		is_dynamic = @isDynamic,
		include_in_sitemap = @includeInSitemap,
		is_clean = @isClean,
		prebuilt = @prebuilt,
		secondary_naming_rule = @secondaryNamingRule,
		exclude_primary_options = @excludePrimaryOptions
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowse TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowse
	@id int output,
	@categoryId int,
	@name varchar(200),
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
	@enabled bit,	
	@buildOptionList bit,
	@isDynamic bit,
	@includeInSitemap bit,
	@prebuilt bit,
	@isClean bit,
	@secondaryNamingRule VARCHAR(500),
	@excludePrimaryOptions BIT,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, [name],  segment_size, [enabled],
		prefix_text, suffix_text, naming_rule, created, modified, build_option_list, is_dynamic, include_in_sitemap, is_clean, prebuilt, secondary_naming_rule, exclude_primary_options)
	VALUES (@categoryId, @name, @segmentSize, @enabled,
		@prefixText, @suffixText, @namingRule, @created, @created, @buildOptionList, @isDynamic, @includeInSitemap, @isClean, @prebuilt, @secondaryNamingRule, @excludePrimaryOptions)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowse TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt, secondary_naming_rule, exclude_primary_options
	FROM fixed_guided_browse
	WHERE [enabled] = 1 AND category_id IN
	(
		SELECT category_id
		FROM category
		WHERE site_id = @siteId
	)

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList
	@categoryId int

AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt, secondary_naming_rule, exclude_primary_options
	FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowses
	@ids VARCHAR(MAX)

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt, secondary_naming_rule, exclude_primary_options
	FROM fixed_guided_browse fgb
	INNER JOIN dbo.global_Split(@ids, ',') gs
		ON fgb.fixed_guided_browse_id = gs.value

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowses TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsBySiteId
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) p.[product_id] AS [id],p.[site_id],p.[parent_product_id],p.[product_name],p.[rank],p.[has_image]
		,p.[catalog_number],p.[enabled],p.[modified],p.[created],p.[product_type],p.[status],p.[has_model]
		,p.[has_related],p.[flag1],p.[flag2],p.[flag3],p.[flag4],p.[completeness],p.[search_rank],p.[legacy_content_id]
		,p.[search_content_modified],p.[hidden],p.[business_value],p.[ignore_in_rapid],p.[show_in_matrix]
		,p.[show_detail_page],p.[default_rank],p.[default_search_rank]
	FROM product p
	LEFT JOIN search_content_status scs
		ON p.product_id = scs.content_id
			AND scs.site_id = p.site_id
			AND scs.content_type_id = 2
	WHERE p.site_id = @siteId
		AND p.[enabled] = 1
		AND p.hidden = 0
		AND scs.content_id IS NULL
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteId TO VpWebApp
GO

----------------------------------------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductBoundriesForSite'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].adminPlatform_GetUnindexedProductBoundriesForSite      
 @siteId int
AS
   
-- ==========================================================================      
-- $Author: Sahan $      
-- ==========================================================================
    
BEGIN      
       
	SET NOCOUNT ON;

	SELECT MIN(product_id) AS start_id, MAX(p.product_id) AS end_id
	FROM product p 
	WHERE p.site_id = @siteId 
       
END  
GO

----------------------------------------------------------------------------------------------------------------------------------------

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductBoundriesForSite TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsByProductIdBoundries'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsByProductIdBoundries
	@siteId int,
	@minProductId int,
	@maxProductId int
AS
-- ==========================================================================
-- Author : Sahan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;
	
	SELECT product_id AS id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status,
		has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
		show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product
	WHERE product_id BETWEEN @minProductId AND @maxProductId
		AND site_id = @siteId
		AND enabled = 1 
		AND hidden = 0
	
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsByProductIdBoundries TO VpWebApp
GO

--------------------------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorProductCountDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorProductCountDetail
	@vendorId int
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET ARITHABORT ON;
	
	SELECT vendor_id, [1] minimized, [2] standard, [3] featured, [0] [none]
	, (
		SELECT COUNT(DISTINCT p.product_id)
			FROM product_to_vendor pv
				INNER JOIN product p
					ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId
				AND p.enabled = 1
		) lpc
	FROM
	(
		SELECT vendor_id, product.product_id, product.rank
		FROM product_to_vendor
			INNER JOIN product
				ON product_to_vendor.product_id = product.product_id
		WHERE vendor_id = @vendorId
	) p
	PIVOT
	(
		COUNT(product_id) FOR rank IN ([1], [2], [3], [0])
	) pvt

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorProductCountDetail TO VpWebApp 
GO