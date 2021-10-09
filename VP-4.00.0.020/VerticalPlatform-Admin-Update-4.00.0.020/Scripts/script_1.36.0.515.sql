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
			SELECT c.[currency_id] AS [id],c.[description],c.[local_symbol],c.[international_symbol]
				,c.[enabled],c.[created],c.[modified]
			FROM currency c
			WHERE c.[currency_id] IN (
				SELECT pvp.currency_id
				FROM product_to_vendor_to_price pvp
					INNER JOIN product_to_vendor ptv
						ON pvp.product_to_vendor_id = ptv.product_to_vendor_id
				WHERE ptv.is_manufacturer = 1 AND ptv.vendor_id = @contentId
			)
		END
	ELSE IF @contentType = 1
		BEGIN
			SELECT c.[currency_id] AS [id],c.[description],c.[local_symbol],c.[international_symbol]
				,c.[enabled],c.[created],c.[modified]
			FROM currency c
			WHERE c.[currency_id] IN (
				SELECT pvp.currency_id
				FROM product_to_vendor_to_price pvp
					INNER JOIN product_to_vendor ptv
						ON pvp.product_to_vendor_id = ptv.product_to_vendor_id
					INNER JOIN product p
						ON ptv.product_id = p.product_id
					INNER JOIN product_to_category ptc
						ON ptc.product_id = p.product_id
				WHERE ptc.category_id = @contentId
			)
		END

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductPriceCurrencyByContentTypeContentId TO VpWebApp
GO
-----------------------------------------------------------------------------------------------------------------
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
			SELECT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
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
			SELECT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
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