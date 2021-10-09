-- auto_truncate_elastic_search column

IF NOT EXISTS (
  SELECT 1 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[specification_type]') 
         AND name = 'auto_truncate_elastic_search'
)
BEGIN
	ALTER TABLE specification_type
	ADD [auto_truncate_elastic_search] BIT NOT NULL DEFAULT (0)
END	

GO


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
-- $Author: Dulip Batagoda $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON;
	
	IF @contentType = 1
		BEGIN
			SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
				  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
				  ,st.[is_expanded_view],st.[display_empty],st.[auto_truncate_elastic_search]
			FROM [specification_type] st
				INNER JOIN category_to_specification_type cst
					ON cst.[spec_type_id] = st.[spec_type_id]
			WHERE st.[enabled] = 1 AND cst.category_id = @contentId
		END
	ELSE IF @contentType = 6
		IF @itemContentType = 21
			BEGIN
				SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
					  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
					  ,st.[is_expanded_view],st.[display_empty],st.[auto_truncate_elastic_search]
				FROM [specification_type] st
					INNER JOIN specification s
						ON s.spec_type_id = st.[spec_type_id]
					INNER JOIN model m
						ON m.model_id = s.content_id
					INNER JOIN product_to_vendor ptv
						ON ptv.product_id = m.product_id
				WHERE st.[enabled] = 1 AND s.content_type_id = @itemContentType AND ptv.vendor_id = @contentId
			END
		ELSE
			BEGIN
				SELECT DISTINCT st.[spec_type_id] AS [id],st.[spec_type],st.[validation_expression],st.[site_id]
					  ,st.[enabled],st.[modified],st.[created],st.[is_visible],st.[search_enabled]
					  ,st.[is_expanded_view],st.[display_empty],st.[auto_truncate_elastic_search]
				FROM [specification_type] st
					INNER JOIN specification s
						ON s.spec_type_id = st.[spec_type_id]
					INNER JOIN product_to_vendor ptv
						ON ptv.product_id = s.content_id
				WHERE st.[enabled] = 1 AND s.content_type_id = @itemContentType AND ptv.vendor_id = @contentId
			END
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetContentSpecificationTypesByContentTypeContentId TO VpWebApp
GO

/*****          END OF STORED PROCEDURE adminProduct_GetContentSpecificationTypesByContentTypeContentId            *****/

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationTypeInformationByContentTypeIdAndContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationTypeInformationByContentTypeIdAndContentIdList
	@contentTypeId int,
	@contentIdList varchar(MAX)
	
AS
-- ==========================================================================
-- Author : Dulip
-- ==========================================================================
BEGIN

	SELECT cp.content_id , c.[spec_type_id] AS [id], c.[spec_type], c.[validation_expression], c.[site_id], c.[enabled], c.[modified]
		  , c.[created], c.[is_visible], c.[search_enabled], c.[is_expanded_view], c.[display_empty],c.[auto_truncate_elastic_search]
	FROM [specification_type] c
	INNER JOIN content_to_specification_type cp
		ON c.spec_type_id = cp.specification_type_id
	INNER JOIN global_Split(@contentIdList, ',') AS tempContentIds
		ON cp.[content_id] = tempContentIds.[value]
	WHERE cp.content_type_id = @contentTypeId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationTypeInformationByContentTypeIdAndContentIdList TO VpWebApp

/*****          END OF STORED PROCEDURE publicProduct_GetSpecificationTypeInformationByContentTypeIdAndContentIdList            *****/

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationTypeList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeIds varchar(max)
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT specification_type.spec_type_id AS id, spec_type, validation_expression, specification_type.site_id, specification_type.[enabled], 
				specification_type.modified, specification_type.created, is_visible, search_enabled, is_expanded_view, display_empty, specification_type.[auto_truncate_elastic_search]
		FROM specification_type
	INNER JOIN specification 
		ON specification_type.spec_type_id = specification.spec_type_id
	WHERE specification.content_type_id=@contentTypeId 
		AND specification.content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND specification.spec_type_id NOT IN (SELECT [value] FROM dbo.global_split(@selectedSpecTypeIds, ','))

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationTypeList TO VpWebApp 
Go

/*****          END OF STORED PROCEDURE adminProduct_GetSKUSpecificationTypeList            *****/


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationTypeBySiteIdLikeNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationTypeBySiteIdLikeNameList
	@siteId int,
	@searchText varchar(100),
	@numberOfResults int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@numberOfResults) spec_type_id AS id, spec_type, validation_expression, site_id, 
			enabled, modified, created, search_enabled, is_visible, is_expanded_view, display_empty, auto_truncate_elastic_search
	FROM specification_type
	WHERE site_id = @siteId AND spec_type LIKE @searchText + '%'

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeBySiteIdLikeNameList TO VpWebApp 
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationTypeBySiteIdLikeNameList            *****/

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationTypeBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationTypeBySiteIdPageList
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1)
	SET @endIndex = @pageSize * @pageIndex

	SELECT @numberOfRows = COUNT(*)
	FROM specification_type
	WHERE site_id = @siteId;

	WITH temp_specification_type (row, id, spec_type, validation_expression, site_id, 
		enabled, modified, created, is_visible, search_enabled, is_expanded_view, display_empty,auto_truncate_elastic_search) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY spec_type_id) AS row, spec_type_id AS id, spec_type
			, validation_expression, site_id, enabled, modified, created, is_visible
			, search_enabled, is_expanded_view, display_empty, auto_truncate_elastic_search
		FROM specification_type
		WHERE site_id = @siteId
	)

	SELECT id, spec_type, validation_expression, site_id, enabled, modified, created, is_visible, search_enabled, is_expanded_view, display_empty, auto_truncate_elastic_search
	FROM temp_specification_type 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeBySiteIdPageList TO VpWebApp 
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationTypeBySiteIdPageList            *****/

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationNotHavingIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationNotHavingIdsList
	@specificationIds varchar(MAX),
	@siteId int
AS
-- ==========================================================================
-- $Author: Tishan $
-- ==========================================================================
BEGIN

SELECT spec_type_id AS id, spec_type, validation_expression, site_id, enabled, modified, created, is_visible
		, search_enabled, is_expanded_view, display_empty, auto_truncate_elastic_search
FROM  dbo.specification_type 
WHERE spec_type_id NOT IN 
	(SELECT [value] FROM global_Split(@specificationIds, ',')) AND site_id = @siteId
ORDER BY spec_type

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationNotHavingIdsList TO VpWebApp 
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationNotHavingIdsList            *****/

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetLiveSpecificationTypeListByProductIdSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetLiveSpecificationTypeListByProductIdSiteId
	@productId int,
	@siteId int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT specTyp.spec_type_id AS id, specTyp.spec_type, specTyp.validation_expression
			, specTyp.site_id, specTyp.[enabled], specTyp.modified, specTyp.created, specTyp.search_enabled
			, specTyp.is_visible, specTyp.is_expanded_view, specTyp.display_empty, specTyp.auto_truncate_elastic_search
FROM         specification_type AS specTyp INNER JOIN
                      specification AS spec ON specTyp.spec_type_id = spec.spec_type_id INNER JOIN
                      model ON spec.content_id = model.model_id
WHERE     (specTyp.site_id = @siteId) AND (model.product_id = @productId) 
			AND (model.[enabled] = 1)	AND (spec.content_type_id = 21)
ORDER BY specTyp.spec_type
	
END
GO 	

GRANT EXECUTE ON dbo.adminProduct_GetLiveSpecificationTypeListByProductIdSiteId TO VpWebApp
GO

/*****          END OF STORED PROCEDURE adminProduct_GetLiveSpecificationTypeListByProductIdSiteId            *****/

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationTypeListByProductIdSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationTypeListByProductIdSiteId
	@productId int,
	@siteId int
AS
-- ==========================================================================
-- $Author: dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT specTyp.spec_type_id AS id, specTyp.spec_type, specTyp.validation_expression
			, specTyp.site_id, specTyp.[enabled], specTyp.modified, specTyp.created, specTyp.is_visible
			, specTyp.search_enabled, specTyp.is_expanded_view, specTyp.display_empty, specTyp.auto_truncate_elastic_search
FROM         specification_type AS specTyp INNER JOIN
                      specification AS spec ON specTyp.spec_type_id = spec.spec_type_id INNER JOIN
                      model ON spec.content_id = model.model_id
WHERE     (specTyp.site_id = @siteId) AND (model.product_id = @productId) AND (spec.content_type_id = 21)
ORDER BY specTyp.spec_type
	
END
GO 	

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeListByProductIdSiteId TO VpWebApp
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationTypeListByProductIdSiteId            *****/

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
-- $Author: dulip$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF @liveProductsOnly = 1
		BEGIN
			SELECT specification_type.spec_type_id AS id, spec_type, validation_expression , specification_type.site_id
				, specification_type.[enabled], specification_type.modified, specification_type.created
				, is_visible, search_enabled, is_expanded_view, display_empty, specification_type.[auto_truncate_elastic_search]
			FROM specification_type WITH (NOLOCK)
			WHERE specification_type.site_id = @siteId AND specification_type.spec_type_id IN (
				SELECT --DISTINCT 
					catToSpecType.spec_type_id
					FROM [category_to_specification_type] catToSpecType WITH (NOLOCK)
						INNER JOIN [product_to_category] prodToCat1 WITH (NOLOCK)
							ON prodToCat1.category_id = catToSpecType.category_id
						INNER JOIN product_to_category prodToCat2 WITH (NOLOCK)
							ON prodToCat1.product_id = prodToCat2.product_id
						INNER JOIN product_to_vendor prodToVend WITH (NOLOCK)
							ON prodToVend.product_id = prodToCat2.product_id
						INNER JOIN product prod WITH (NOLOCK)
							ON prod.product_id = prodToCat2.product_id
						INNER JOIN vendor vend WITH (NOLOCK)
							ON vend.vendor_id =  prodToVend.vendor_id
						INNER JOIN category cat WITH (NOLOCK)
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
			, is_visible, search_enabled, is_expanded_view, display_empty, specification_type.[auto_truncate_elastic_search]
			FROM specification_type
			WHERE specification_type.site_id = @siteId AND specification_type.spec_type_id IN (
				SELECT --DISTINCT 
					catToSpecType.spec_type_id
					FROM [category_to_specification_type] catToSpecType WITH (NOLOCK)
						INNER JOIN [product_to_category] prodToCat1 WITH (NOLOCK)
							ON prodToCat1.category_id = catToSpecType.category_id
						INNER JOIN product_to_category prodToCat2 WITH (NOLOCK)
							ON prodToCat1.product_id = prodToCat2.product_id
						INNER JOIN product_to_vendor WITH (NOLOCK)
							ON product_to_vendor.product_id = prodToCat2.product_id
					WHERE product_to_vendor.vendor_id=@vendorId and prodToCat2.category_id=@categoryId 
			)
			ORDER BY specification_type.spec_type
	END
		
END
GO 	

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeListByVendorIdCategoryIdSiteId TO VpWebApp
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationTypeListByVendorIdCategoryIdSiteId            *****/

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationTypeBySiteIdPageIndexPageSizeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationTypeBySiteIdPageIndexPageSizeList
	@siteId int,
	@searchText varchar(30),
	@pageIndex int,
	@pageSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetSpecificationTypeBySiteIdPageIndexPageSizeList.sql $
-- $Revision: 7520 $
-- $Author: dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
		SELECT TOP (@pageSize)  proTyp.spec_type_id AS id, proTyp.spec_type, proTyp.validation_expression
			, proTyp.site_id, proTyp.[enabled], proTyp.modified, proTyp.created, proTyp.is_visible
			, proTyp.search_enabled, proTyp.is_expanded_view, proTyp.display_empty, proTyp.auto_truncate_elastic_search
		FROM specification_type proTyp		
		WHERE proTyp.site_id = @siteId AND (@searchText IS NULL OR proTyp.spec_type like '%' + @searchText + '%') AND (proTyp.spec_type_id NOT IN ( SELECT TOP ((@pageIndex - 1) * @pageSize) proTyp.spec_type_id
										FROM specification_type AS proTyp WHERE @siteId = proTyp.site_id AND (@searchText IS NULL OR proTyp.spec_type like '%' + @searchText + '%') ORDER BY proTyp.spec_type ASC))
		ORDER BY proTyp.spec_type ASC

		SELECT @totalCount = COUNT(*)
		FROM specification_type proTyp
		WHERE @siteId = proTyp.site_id AND (@searchText IS NULL OR proTyp.spec_type like '%' + @searchText + '%')

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeBySiteIdPageIndexPageSizeList TO VpWebApp 
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationTypeBySiteIdPageIndexPageSizeList            *****/


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationTypeBySpecificationTypeDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationTypeBySpecificationTypeDetail
	@siteId int,
	@specificationType varchar(255)
AS
-- ==========================================================================
-- $Author: dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT spec_type_id AS id, spec_type, validation_expression, site_id
		, [enabled], modified, created, is_visible, search_enabled, is_expanded_view, display_empty, auto_truncate_elastic_search
	FROM specification_type
	WHERE site_id = @siteId AND spec_type = @specificationType

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeBySpecificationTypeDetail TO VpWebApp 
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationTypeBySpecificationTypeDetail            *****/



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationTypeByContentTypeIdContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationTypeByContentTypeIdContentIdList
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetSpecificationTypeByContentTypeIdContentIdList.sql $
-- $Revision: 4918 $
-- $Author: dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT specification_type.spec_type_id AS id, spec_type, validation_expression, site_id
			, specification_type.[enabled], specification_type.modified, specification_type.created
			, specification_type.is_visible, specification_type.search_enabled, specification_type.is_expanded_view, specification_type.display_empty, specification_type.[auto_truncate_elastic_search]
	FROM specification
			INNER JOIN specification_type
				ON specification.spec_type_id = specification_type.spec_type_id
	WHERE content_type_id = @contentTypeId AND content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationTypeByContentTypeIdContentIdList TO VpWebApp 
Go

/*****          END OF STORED PROCEDURE publicProduct_GetSpecificationTypeByContentTypeIdContentIdList            *****/



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationTypeByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationTypeByCategoryIdList
	@categoryIdList varchar(1000)
AS
-- ==========================================================================
-- $Author: dulip $
-- ==========================================================================
BEGIN
	
	SELECT   DISTINCT  (proSpecType.spec_type_id) AS id, proSpecType.validation_expression AS validation_expression
					, proSpecType.spec_type AS spec_type, proSpecType.site_id AS site_id
					, proSpecType.enabled AS [enabled], proSpecType.modified AS[modified]
					, proSpecType.created AS created, proSpecType.is_visible AS is_visible
					, proSpecType.search_enabled AS search_enabled, proSpecType.is_expanded_view AS is_expanded_view, proSpecType.display_empty AS display_empty
					, proSpecType.auto_truncate_elastic_search AS auto_truncate_elastic_search
	FROM     dbo.category_to_specification_type catToProSpecType
				INNER JOIN
					dbo.specification_type proSpecType 
							ON catToProSpecType.spec_type_id = proSpecType.spec_type_id
	WHERE catToProSpecType.category_id IN (SELECT [value] FROM [global_Split](@categoryIdList, ','))


END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationTypeByCategoryIdList TO VpWebApp 
GO

/*****          END OF STORED PROCEDURE adminProduct_GetSpecificationTypeByCategoryIdList            *****/



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationTypeBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationTypeBySiteId
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetSpecificationTypeBySiteId.sql $
-- $Revision: 4918 $
-- $Author: dulip $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

	SELECT proTyp.spec_type_id AS id, proTyp.spec_type, proTyp.validation_expression
			, proTyp.site_id, proTyp.[enabled], proTyp.modified, proTyp.created, proTyp.is_visible
			, proTyp.search_enabled, proTyp.is_expanded_view, proTyp.display_empty, proTyp.auto_truncate_elastic_search
	FROM specification_type proTyp		
	WHERE proTyp.site_id = @id
	ORDER BY spec_type ASC
	
END
GO


GRANT EXECUTE ON dbo.publicProduct_GetSpecificationTypeBySiteId TO VpWebApp
GO

/*****          END OF STORED PROCEDURE publicProduct_GetSpecificationTypeBySiteId            *****/



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationTypeByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationTypeByCategoryId
	@id int,
	@showInMatrix bit = NULL
AS
-- ==========================================================================
-- $Author: dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT proTyp.spec_type_id AS id, proTyp.spec_type, proTyp.validation_expression
			, proTyp.site_id, proTyp.[enabled], proTyp.modified, proTyp.created, proTyp.search_enabled
			, proTyp.is_visible, proTyp.is_expanded_view, proTyp.display_empty, proTyp.auto_truncate_elastic_search
	FROM category_to_specification_type catProTyp
		INNER JOIN specification_type proTyp
			ON catProTyp.spec_type_id = proTyp.spec_type_id
			AND ((@showInMatrix IS NULL) OR (catProTyp.show_in_matrix = @showInMatrix))
	WHERE catProTyp.category_id = @id
	ORDER BY catProTyp.sort_order

END
GO 	

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationTypeByCategoryId TO VpWebApp
GO





EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddSpecificationType
	@specificationType varchar(255),
	@validationExpression varchar(100),
	@siteId int,
	@searchEnabled bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@isVisible bit,
	@isExpandedView bit,
	@displayEmpty bit,
	@autoTruncateElasticSearch bit
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_AddSpecificationType.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chinthaka $
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @created = GETDATE()

		INSERT INTO specification_type(spec_type, validation_expression
				, site_id, [enabled], modified, created, is_visible, search_enabled, is_expanded_view, display_empty
				, auto_truncate_elastic_search)
		VALUES (@specificationType, @validationExpression, @siteId, @enabled, @created, @created, @isVisible
				, @searchEnabled, @isExpandedView, @displayEmpty
				,@autoTruncateElasticSearch)

		SET @id = SCOPE_IDENTITY()
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_AddSpecificationType TO VpWebApp 
Go




EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSpecificationType
	@id int,
	@specificationType varchar(255),
	@validationExpression varchar(100),
	@siteId int,
	@searchEnabled bit,
	@enabled bit,
	@modified smalldatetime output,
	@isVisible bit,
	@isExpandedView bit,
	@displayEmpty BIT,
	@autoTruncateElasticSearch BIT
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_UpdateSpecificationType.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chinthaka $
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @modified=GETDATE()
	UPDATE specification_type
	SET
		spec_type = @specificationType,
		validation_expression = @validationExpression,
		site_id = @siteId,
		search_enabled = @searchEnabled,
		[enabled] = @enabled,
		modified = @modified,
		is_visible = @isVisible,
		is_expanded_view = @isExpandedView,
		display_empty = @displayEmpty,
		auto_truncate_elastic_search = @autoTruncateElasticSearch
	WHERE spec_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSpecificationType TO VpWebApp 
Go




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationTypeDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationTypeDetail
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetSpecificationTypeDetail.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT spec_type_id as id, spec_type, validation_expression, site_id, [enabled]
			, modified, created, is_visible, search_enabled, is_expanded_view, display_empty
			, auto_truncate_elastic_search
	FROM specification_type
	WHERE spec_type_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationTypeDetail TO VpWebApp 
Go




