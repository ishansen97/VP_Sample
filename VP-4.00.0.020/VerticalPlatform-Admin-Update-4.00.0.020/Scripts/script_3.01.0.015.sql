EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNonPayingVendorByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNonPayingVendorByCategoryIdList
	@categoryId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Janindu $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

	CREATE TABLE #vendor_ids (vendor_id int)

	INSERT INTO #vendor_ids
	SELECT vendor.vendor_id
		FROM vendor
			INNER JOIN category_to_vendor
				ON vendor.vendor_id = category_to_vendor.vendor_id
		WHERE category_id = @categoryId AND category_to_vendor.[enabled] = 1 AND vendor.[enabled] = 1
		
--	IF EXISTS (SELECT * FROM #vendor_ids)
--	BEGIN
--		DELETE FROM #vendor_ids 
--		WHERE vendor_id IN
--		(
--			SELECT DISTINCT vendor.vendor_id
--			FROM vendor 
--				INNER JOIN product_to_vendor
--					ON vendor.vendor_id = product_to_vendor.vendor_id 
--				INNER JOIN product_to_category
--					ON product_to_vendor.product_id = product_to_category.product_id 
--				INNER JOIN product
--					ON product_to_category.product_id = product.product_id
--			WHERE product_to_category.category_id = @categoryId
--		)
--	END

	SELECT @totalRowCount = COUNT(*) FROM #vendor_ids

	;WITH cvendors (id, site_id, vendor_name, [rank], has_image, [enabled], modified, created,
		parent_vendor_id, vendor_keywords, internal_name, [description], vendorRow) AS
	(
		SELECT vendor.vendor_id AS id, site_id, vendor_name, [rank], has_image, [enabled], modified, created
			, parent_vendor_id, vendor_keywords, internal_name, [description]
			, ROW_NUMBER() OVER (ORDER BY vendor_name) AS vendorRow	
		FROM #vendor_ids
			INNER JOIN vendor
				ON #vendor_ids.vendor_id = vendor.vendor_id
	)
	
	SELECT id, site_id, vendor_name, [rank], has_image, [enabled], modified, created,
		parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM cvendors
	WHERE vendorRow BETWEEN @startRowIndex AND @endRowIndex
	ORDER BY vendorRow
	
DROP TABLE #vendor_ids

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNonPayingVendorByCategoryIdList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPostSearchInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPostSearchInformation
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@browseSearchOptions varchar(255)
AS
-- ==========================================================================
-- $Author: Deshapriya $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND guided_browse_search_options = @browseSearchOptions
	ORDER BY start_character

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPostSearchInformation TO VpWebApp
GO



IF NOT EXISTS (
  SELECT [parameter_type_id]
  FROM   [dbo].[parameter_type] 
  WHERE  [parameter_type] = 'ShowAskAQuestionLeadType'
)
BEGIN


INSERT INTO [dbo].[parameter_type]
           ([parameter_type_id]
           ,[parameter_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           (222
           ,'ShowAskAQuestionLeadType'
           ,1
           ,GETDATE()
           ,GETDATE()
		   )

END
GO

IF NOT EXISTS ( SELECT 1 FROM [dbo].[module] WHERE [module_name] = 'Questionnaire'  )
BEGIN
   INSERT INTO [dbo].[module]
           ([module_name]
           ,[usercontrol_name]
           ,[enabled]
           ,[modified]
           ,[created]
           ,[is_container])
     VALUES
           ('Questionnaire'
           ,'~/Modules/ProductDetail/Questionnaire.ascx'
           ,1
           ,GETDATE()
           ,GETDATE()
           ,0
		   )
END

GO


