

-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
IF NOT EXISTS(SELECT * FROM [parameter_type] where [parameter_type]='ExternalSubstitutePageOpenInNewWindow')
  BEGIN
  
	INSERT INTO parameter_type([parameter_type_id],[parameter_type],[enabled],[modified],[created])
    VALUES(198,'ExternalSubstitutePageOpenInNewWindow',1,GETDATE(),GETDATE())	
  
  END

----------------------------------------------------------------------------------------------------

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
-- $Author: Akila$
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
				SELECT DISTINCT catToSpecType.spec_type_id
					FROM [category_to_specification_type] catToSpecType
						INNER JOIN [product_to_category] prodToCat1
							ON prodToCat1.category_id = catToSpecType.category_id
						INNER JOIN product_to_category prodToCat2
							ON prodToCat1.product_id = prodToCat2.product_id
						INNER JOIN product_to_vendor prodToVend
							ON prodToVend.product_id = prodToCat2.product_id
						INNER JOIN product prod
							ON prod.product_id = prodToCat2.product_id
						INNER JOIN vendor vend
							ON vend.vendor_id =  prodToVend.vendor_id
						INNER JOIN category cat
							ON cat.category_id = prodToCat2.category_id
					WHERE (prodToVend.vendor_id=@vendorId and prodToCat2.category_id=@categoryId AND prod.[enabled] = 1 AND vend.[enabled] = 1 AND prodToCat2.[enabled] = 1 AND 
						prodToVend.[enabled] = 1 AND cat.[enabled] = 1)
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
				SELECT DISTINCT catToSpecType.spec_type_id
					FROM [category_to_specification_type] catToSpecType
						INNER JOIN [product_to_category] prodToCat1
							ON prodToCat1.category_id = catToSpecType.category_id
						INNER JOIN product_to_category prodToCat2
							ON prodToCat1.product_id = prodToCat2.product_id
						INNER JOIN product_to_vendor
							ON product_to_vendor.product_id = prodToCat2.product_id
					WHERE product_to_vendor.vendor_id=@vendorId and prodToCat2.category_id=@categoryId 
			)
			ORDER BY specification_type.spec_type
		END
END
GO 	

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeListByVendorIdCategoryIdSiteId TO VpWebApp
GO