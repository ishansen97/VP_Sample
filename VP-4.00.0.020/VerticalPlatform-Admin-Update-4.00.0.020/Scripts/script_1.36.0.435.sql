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