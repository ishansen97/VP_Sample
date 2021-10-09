IF(OBJECT_ID('product_completeness_factor', 'U') IS NULL)
BEGIN
	CREATE TABLE [dbo].[product_completeness_factor](
		[product_completeness_factor_id] [int] IDENTITY(1,1) NOT NULL,
		[content_type_id] [int] NOT NULL,
		[content_id] [int] NOT NULL,
		[factor_content_type_id] [int] NOT NULL,
		[factor_content_id] [int] NOT NULL,
		[factor_content_name] [varchar](250) NOT NULL,
		[completeness_score] [int] NOT NULL,
		[incompleteness_score] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_product_completeness_factor] PRIMARY KEY CLUSTERED 
	(
		[product_completeness_factor_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

SET ANSI_PADDING OFF
GO

---------------------------------------------------------------------------

INSERT INTO product_completeness_factor(content_type_id, content_id, factor_content_type_id, factor_content_id, 
	factor_content_name, completeness_score, incompleteness_score, created, enabled, modified)
SELECT 5, pc.site_id, pc.content_type_id, pc.content_property_id,
	pc.content_property_name, pc.completeness_score, pc.incompleteness_score, pc.created, 1, pc.modified
FROM product_completeness pc

GO

UPDATE product_completeness_factor
SET factor_content_type_id = 26
WHERE factor_content_type_id = 22

---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompletenessFactor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompletenessFactor
	@id int,
	@contentTypeId int,
	@contentId int,
	@factorContentTypeId int,
	@factorContentId int,
	@factorContentName varchar(250),
	@completenessScore int,
	@incompletenessScore int,
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE product_completeness_factor
	SET content_type_id = @contentTypeId, 
	content_id = @contentId, 
	factor_content_type_id = @factorContentTypeId, 
	factor_content_id = @factorContentId, 
	factor_content_name = @factorContentName, 
	completeness_score = @completenessScore, 
	incompleteness_score = @incompletenessScore, 
	enabled = @enabled,
	modified = @modified
	WHERE product_completeness_factor_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompletenessFactor TO VpWebApp 
GO

-------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompletenessFactor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompletenessFactor
	@contentTypeId int,
	@contentId int,
	@factorContentTypeId int,
	@factorContentId int,
	@factorContentName varchar(250),
	@completenessScore int,
	@incompletenessScore int,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO product_completeness_factor(content_type_id, content_id, factor_content_type_id, factor_content_id, factor_content_name, completeness_score, incompleteness_score, enabled, created, modified)
	VALUES (@contentTypeId, @contentId, @factorContentTypeId, @factorContentId, @factorContentName, @completenessScore, @incompletenessScore, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompletenessFactor TO VpWebApp 
GO

GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdFactorContentTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdFactorContentTypeList
	@contentTypeId int,
	@contentId int,
	@factorContentTypeId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT product_completeness_factor_id AS id, content_type_id, content_id, factor_content_type_id, factor_content_id, factor_content_name, completeness_score, incompleteness_score, created, enabled, modified
	FROM product_completeness_factor
	WHERE content_type_id = @contentTypeId AND content_id = @contentId AND factor_content_type_id = @factorContentTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdFactorContentTypeList TO VpWebApp 
GO

------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdList
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT product_completeness_factor_id AS id, content_type_id, content_id, factor_content_type_id, factor_content_id, factor_content_name, completeness_score, incompleteness_score, created, enabled, modified
	FROM product_completeness_factor
	WHERE content_type_id = @contentTypeId AND content_id = @contentId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdList TO VpWebApp 
GO


-------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompletenessFactorDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompletenessFactorDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT product_completeness_factor_id AS id, content_type_id, content_id, factor_content_type_id, factor_content_id, factor_content_name, completeness_score, incompleteness_score, created, enabled, modified
	FROM product_completeness_factor
	WHERE product_completeness_factor_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompletenessFactorDetail TO VpWebApp 
GO

-------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompletenessFactor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompletenessFactor
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM product_completeness_factor
	WHERE product_completeness_factor_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompletenessFactor TO VpWebApp 
Go

------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdFactorContentTypeFactorContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdFactorContentTypeFactorContentIdList
	@contentTypeId int,
	@contentId int,
	@factorContentTypeId int,
	@factorContentId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT product_completeness_factor_id AS id, content_type_id, content_id, factor_content_type_id, factor_content_id, factor_content_name, completeness_score, incompleteness_score, created, enabled, modified
	FROM product_completeness_factor
	WHERE content_type_id = @contentTypeId AND content_id = @contentId AND factor_content_type_id = @factorContentTypeId AND factor_content_id = @factorContentId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompletenessFactorByContentTypeContentIdFactorContentTypeFactorContentIdList TO VpWebApp 
GO

-------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompletenessByModified'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompletenessByModified
	@siteId int,
	@modifiedSince smalldatetime,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	--Create temp table to store the product ids between start and end index
	CREATE TABLE #ordered_product(product_id int, completeness int)

	--Populate new product ids
	INSERT INTO #ordered_product
	SELECT product_id, completeness
	FROM
	( 
		SELECT product_id, 0 AS completeness, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id
		FROM product
		WHERE site_id = @siteId AND modified > @modifiedSince
	) AS filteredProducts
	WHERE row_id BETWEEN @startIndex AND @endIndex

	--Create temp table to store completeness factors used for calculation
	CREATE TABLE #completeness_factor(product_id int, content_type_id int, content_id int, completeness int, incompleteness int)

	--Populate completeness factors for products
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, MAX(completeness), MAX(incompleteness)
	FROM
	(
		SELECT op.product_id AS product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_to_category pc
				ON pc.product_id = op.product_id
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 1 AND pcf.content_id = pc.category_id
		UNION ALL
		SELECT op.product_id product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 5 AND pcf.content_id = @siteId
	) AS allFactors
	GROUP BY product_id, content_type_id, content_id
	
	--Update completeness factor for specification types.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT #ordered_product.product_id, SUM(cf.completeness) score
			FROM #ordered_product
				INNER JOIN specification
					ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id
				INNER JOIN #completeness_factor cf
					ON cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id
			WHERE specification.specification <> ''
			GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for empty specifications.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
		SELECT #ordered_product.product_id, SUM(cf.incompleteness) score
		FROM #ordered_product
			INNER JOIN specification
				ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id
			INNER JOIN #completeness_factor cf
					ON cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id
		WHERE specification.specification = ''
		GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for price.
	DECLARE @priceFactor int
	SELECT @priceFactor = completeness FROM #completeness_factor WHERE content_type_id = 23 AND content_id = 3
	IF @priceFactor IS NOT NULL
	BEGIN
		UPDATE p
		SET completeness = completeness + @priceFactor
		FROM #ordered_product p
			INNER JOIN 
			(
				SELECT #ordered_product.product_id
				FROM #ordered_product
					INNER JOIN product_to_vendor
						ON #ordered_product.product_id = product_to_vendor.product_id
					INNER JOIN product_to_vendor_to_price
						ON product_to_vendor_to_price.product_to_vendor_id = product_to_vendor.product_to_vendor_id
				GROUP BY #ordered_product.product_id
			) s
				ON p.product_id = s.product_id
	END	

	--Update completeness factor for article association in article types.	
	IF EXISTS (SELECT * FROM #completeness_factor WHERE content_type_id = 16)
	BEGIN
		UPDATE op
		SET completeness = completeness + score
		FROM #ordered_product op
			INNER JOIN
			(
				SELECT product_id, SUM(score) score
				FROM
				(
				SELECT p.product_id, MIN(pcf.completeness) score
				FROM #ordered_product p
					INNER JOIN content_to_content c
						ON c.associated_content_type_id = 2 AND c.associated_content_id = p.product_id AND  
							c.content_type_id = 4
					INNER JOIN article
						ON c.content_id = article.article_id
					INNER JOIN #completeness_factor pcf
						ON pcf.content_type_id = 16 AND article.article_type_id = pcf.content_id
				GROUP BY p.product_id, article.article_type_id
				) t
				GROUP BY product_id
			) s
				ON op.product_id = s.product_id
	END

	--Updates the product table
	UPDATE product
		SET product.completeness = #ordered_product.completeness, product.modified = GETDATE(), product.search_content_modified = 1
	FROM #ordered_product
	WHERE product.product_id = #ordered_product.product_id AND
		#ordered_product.completeness IS NOT NULL AND
		product.completeness <> #ordered_product.completeness
	
	DROP TABLE #ordered_product
	DROP TABLE #completeness_factor

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompletenessByModified TO VpWebApp 
GO

----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompleteness'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompleteness
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: DIlshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	--Create temp table to store the product ids between start and end index
	CREATE TABLE #ordered_product(product_id int, completeness int)
	
	--Populate product ids between start and end index
	INSERT INTO #ordered_product
	SELECT product_id, completeness
	FROM
	(
		SELECT product_id, 0 AS completeness, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id
		FROM product
		WHERE site_id = @siteId		
	) AS filteredProducts
	WHERE row_id BETWEEN @startIndex AND @endIndex
	
	--Create temp table to store completeness factors used for calculation
	CREATE TABLE #completeness_factor(product_id int, content_type_id int, content_id int, completeness int, incompleteness int)

	--Populate completeness factors for products
	INSERT INTO #completeness_factor
	SELECT product_id, content_type_id, content_id, MAX(completeness), MAX(incompleteness)
	FROM
	(
		SELECT op.product_id AS product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_to_category pc
				ON pc.product_id = op.product_id
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 1 AND pcf.content_id = pc.category_id
		UNION ALL
		SELECT op.product_id product_id, pcf.factor_content_type_id AS content_type_id, pcf.factor_content_id AS content_id,
			pcf.completeness_score AS completeness, pcf.incompleteness_score AS incompleteness
		FROM #ordered_product op
			INNER JOIN product_completeness_factor pcf
				ON pcf.content_type_id = 5 AND pcf.content_id = @siteId
	) AS allFactors
	GROUP BY product_id, content_type_id, content_id
	
	--Update completeness factor for specification types.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
			SELECT #ordered_product.product_id, SUM(cf.completeness) score
			FROM #ordered_product
				INNER JOIN specification
					ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id
				INNER JOIN #completeness_factor cf
					ON cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id
			WHERE specification.specification <> ''
			GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for empty specifications.
	UPDATE p
	SET completeness = completeness + score
	FROM #ordered_product p
		INNER JOIN
		(
		SELECT #ordered_product.product_id, SUM(cf.incompleteness) score
		FROM #ordered_product
			INNER JOIN specification
				ON specification.content_type_id = 2 AND #ordered_product.product_id = specification.content_id
			INNER JOIN #completeness_factor cf
					ON cf.content_type_id = 26 AND specification.spec_type_id = cf.content_id
		WHERE specification.specification = ''
		GROUP BY #ordered_product.product_id
		) s
			ON p.product_id = s.product_id


	--Update completeness factor for price.
	DECLARE @priceFactor int
	SELECT @priceFactor = completeness FROM #completeness_factor WHERE content_type_id = 23 AND content_id = 3
	IF @priceFactor IS NOT NULL
	BEGIN
		UPDATE p
		SET completeness = completeness + @priceFactor
		FROM #ordered_product p
			INNER JOIN 
			(
				SELECT #ordered_product.product_id
				FROM #ordered_product
					INNER JOIN product_to_vendor
						ON #ordered_product.product_id = product_to_vendor.product_id
					INNER JOIN product_to_vendor_to_price
						ON product_to_vendor_to_price.product_to_vendor_id = product_to_vendor.product_to_vendor_id
				GROUP BY #ordered_product.product_id
			) s
				ON p.product_id = s.product_id
	END	

	--Update completeness factor for article association in article types.	
	IF EXISTS (SELECT * FROM #completeness_factor WHERE content_type_id = 16)
	BEGIN
		UPDATE op
		SET completeness = completeness + score
		FROM #ordered_product op
			INNER JOIN
			(
				SELECT product_id, SUM(score) score
				FROM
				(
				SELECT p.product_id, MIN(pcf.completeness) score
				FROM #ordered_product p
					INNER JOIN content_to_content c
						ON c.associated_content_type_id = 2 AND c.associated_content_id = p.product_id AND  
							c.content_type_id = 4
					INNER JOIN article
						ON c.content_id = article.article_id
					INNER JOIN #completeness_factor pcf
						ON pcf.content_type_id = 16 AND article.article_type_id = pcf.content_id
				GROUP BY p.product_id, article.article_type_id
				) t
				GROUP BY product_id
			) s
				ON op.product_id = s.product_id
	END

	--Updates the product table
	UPDATE product
		SET product.completeness = #ordered_product.completeness, product.modified = GETDATE(), product.search_content_modified = 1
	FROM #ordered_product
	WHERE product.product_id = #ordered_product.product_id AND
		#ordered_product.completeness IS NOT NULL AND
		product.completeness <> #ordered_product.completeness
	
	DROP TABLE #ordered_product
	DROP TABLE #completeness_factor

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompleteness TO VpWebApp 
GO

------------------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'sort_order' AND id = 
	(SELECT object_id FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'specification') AND type in (N'U'))
)
BEGIN
	ALTER TABLE dbo.specification ADD
	sort_order smallint NOT NULL DEFAULT(0)
END
GO
-------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddSpecification'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddSpecification
	@contentTypeId int,
	@contentId int,
	@specificationTypeId int,
	@specification varchar(max),
	@displayOptions int,
	@sortOrder smallint,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created=GETDATE()

	INSERT INTO specification
			(content_type_id ,content_id, spec_type_id, specification, display_Options, sort_order, [enabled], modified, created)
	VALUES(@contentTypeId, @contentId, @specificationTypeId, @specification, @displayOptions, @sortOrder, @enabled, @created, @created)

	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddSpecification TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationDetail
	@id int
AS
-- ========================================================================== 
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT	specification_id AS id, content_type_id, content_id, spec_type_id, specification, 
			display_options, sort_order, [enabled], modified, created
	FROM	specification
	WHERE	specification_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSpecification'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSpecification
	@id int,
	@contentTypeId int,
	@contentId int,
	@specificationTypeId int,
	@specification varchar(max),
	@displayOptions int,
	@sortOrder smallint,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified=GETDATE()
	UPDATE specification
	SET
		content_type_id = @contentTypeId
		, content_id = @contentId
		, spec_type_id = @specificationTypeId
		, specification = @specification
		, display_options = @displayOptions
		, sort_order = @sortOrder
		, [enabled] = @enabled
		, modified = @modified
				
	WHERE specification_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSpecification TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationByContentTypeIdContentIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetSpecificationByContentTypeIdContentIdList]
	@contentTypeId int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT specification_id AS id, content_type_id, content_id, spec_type_id, specification, display_options
			, sort_order, [enabled], modified, created
	FROM specification 
	WHERE content_type_id = @contentTypeId AND content_id = @contentId
	ORDER BY sort_order ASC

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationByContentTypeIdContentIdList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 
		'dbo.publicProduct_GetSpecificationByContentTypeIdContentIdSpecTypeIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationByContentTypeIdContentIdSpecTypeIdDetail
	@contentTypeId int,
	@contentId int,
	@specTypeId int
AS
-- ========================================================================== 
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT specification_id AS id, content_type_id, content_id, spec_type_id, specification, display_options
			, sort_order, [enabled], modified, created
	FROM specification 
	WHERE content_type_id = @contentTypeId AND content_id = @contentId AND spec_type_id = @specTypeId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationByContentTypeIdContentIdSpecTypeIdDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationByContentTypeIdContentIdSpecificationTypeDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationByContentTypeIdContentIdSpecificationTypeDetail
	@contentTypeId int,
	@contentId int,
	@specificationType varchar(255)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT specification_id AS id, content_id, specification.spec_type_id, specification, display_options
		, sort_order, specification.enabled, specification.modified, specification.created, content_type_id
	FROM specification
		INNER JOIN specification_type
			ON specification.spec_type_id = specification_type.spec_type_id
	WHERE content_type_id = @contentTypeId AND content_id = @contentId 
		AND specification_type.spec_type = @specificationType

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationByContentTypeIdContentIdSpecificationTypeDetail TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationByProductIdValuesSpecTypeIdValuesList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationByProductIdValuesSpecTypeIdValuesList
	@productIdValues varchar(1000),
	@specificationTypeIdValues varchar(1000)
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT specification_id AS id, content_id, specification.spec_type_id, specification, display_options
		, specification.sort_order, specification.enabled, specification.modified, specification.created, content_type_id
	FROM specification
		INNER JOIN global_Split(@specificationTypeIdValues, ',') specification_type_id_table
			ON specification.spec_type_id = specification_type_id_table.[value]	
		INNER JOIN global_Split(@productIdValues, ',') product_id_table 
			ON specification.content_type_id = 2 AND specification.content_id = product_id_table.[value]
	ORDER BY specification.sort_order ASC 

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationByProductIdValuesSpecTypeIdValuesList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationByContentTypeIdContentIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationByContentTypeIdContentIdsList
	@contentTypeId int,
	@contentIds varchar(max)
AS
-- ==========================================================================
-- $Author : Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT specification_id AS id, content_type_id, content_id, spec_type_id, specification, display_options
			, sort_order, [enabled], modified, created
	FROM specification 
	WHERE content_type_id = @contentTypeId AND content_id IN 
		(SELECT [value] FROM dbo.global_Split(@contentIds, ','))
	ORDER BY sort_order ASC

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationByContentTypeIdContentIdsList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationByProductIdsList
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author : Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT spec.specification_id AS id, spec.content_type_id, spec.content_id, spec.spec_type_id, spec.specification
			, spec.[enabled], spec.[modified], spec.[created], display_options, spec.sort_order
	FROM specification spec
	WHERE content_type_id = 2 AND content_id IN 
		(SELECT [value] FROM dbo.global_Split(@productIds, ','))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationByProductIdsList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT	0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options
			, CAST(1 AS bit) AS [enabled], GETDATE() AS modified, GETDATE() AS created, CAST(1 AS smallint) AS sort_order
	FROM specification 
	WHERE content_type_id = @contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT	specification_id AS id, content_type_id, content_id, spec_type_id, specification
			, sort_order, display_options, [enabled], modified, created
	FROM specification 		
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND spec_type_id = @selectedSpecTypeId
	ORDER BY sort_order ASC
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationsNotInParent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationsNotInParent
    @parentProductId INT ,
    @contentTypeId INT,
    @productIds VARCHAR(MAX)
 AS 
-- ==========================================================================  
-- $Author: Dimuthu $  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
  
     SELECT sc.specification_id AS id ,
                sc.content_id ,
                sc.spec_type_id ,
                sc.specification ,
                sc.display_options ,
				sc.sort_order,
                sc.enabled ,
                sc.modified ,
                sc.created ,
                sc.content_type_id
        FROM    specification sc
        LEFT JOIN specification sp ON sp.spec_type_id = sc.spec_type_id
        AND sp.content_id = @ParentProductId AND sp.content_type_id =sc.content_type_id
        AND sp.specification = sc.specification
        
        WHERE   sc.content_type_id = @contentTypeId
                AND sc.content_id IN (
                SELECT  product_id
                FROM    dbo.product_to_product
                WHERE   parent_product_id = @ParentProductId )           
        AND sp.specification IS NULL 
		ORDER BY sort_order ASC
  
    END  
    
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationsNotInParent TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSpecificationListByContentTypeIdContentIdValuesSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSpecificationListByContentTypeIdContentIdValuesSpecificationType
	@contentTypeId INT,
	@contentIdValues VARCHAR(8000),
	@specificationType VARCHAR(255),
	@siteId INT
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @specificationTypeId INT

	SELECT TOP 1 @specificationTypeId = spec_type_id 
	FROM specification_type 
	WHERE spec_type = @specificationType 
		AND site_id = @siteId

	SELECT specification_id AS id, content_id, specification.spec_type_id, specification, display_options
		, sort_order, specification.enabled, specification.modified, specification.created, content_type_id
	FROM specification
		INNER JOIN specification_type
			ON specification.spec_type_id = specification_type.spec_type_id
		INNER JOIN global_Split(@contentIdValues, ',') content_id_table
			ON content_id_table.value = specification.content_id 
	WHERE content_type_id = @contentTypeId 
		AND specification_type.spec_type_id = @specificationTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSpecificationListByContentTypeIdContentIdValuesSpecificationType TO VpWebApp 
GO

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'sort_order' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].category_to_category_branch') AND type in (N'U'))
)
	
BEGIN
	ALTER TABLE [category_to_category_branch]
	ADD sort_order int NOT NULL DEFAULT(0)
END


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBranchByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryBranchByCategoryIdList
	@categoryId int
AS

-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	WITH cte(id, category_id, sub_category_id, category_branch_type_id, display_name, display_in_digest_view
		, enabled, modified, created, hidden, sort_order) AS
	(
		SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
			, display_name, display_in_digest_view, enabled, modified, created, hidden, sort_order
		FROM category_to_category_branch
		WHERE sub_category_id = @categoryId AND enabled = '1'

		UNION ALL

		SELECT cb.category_to_category_branch_id AS id, cb.category_id, cb.sub_category_id, cb.category_branch_type_id
			, cb.display_name, cb.display_in_digest_view, cb.enabled, cb.modified, cb.created, cb.hidden, cb.sort_order
		FROM category_to_category_branch cb
				INNER JOIN cte
					ON cb.sub_category_id = cte.category_id
		WHERE cb.[enabled] = '1'
	)

	SELECT id, category_id, sub_category_id, category_branch_type_id, display_name, display_in_digest_view
		, enabled, modified, created, hidden, sort_order
	FROM cte

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoryBranchByCategoryIdList TO VpWebApp
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateCategoryBranch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateCategoryBranch
	@id int,
	@categoryId int,
	@subCategoryId int,
	@categoryBranchTypeId int,
	@displayName varchar(255),
	@displayInDigestView bit,
	@enabled bit,
	@hidden bit,
	@sortOrder int,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE category_to_category_branch
	SET category_id = @categoryId
		, sub_category_id = @subCategoryId
		, category_branch_type_id = @categoryBranchTypeId
		, enabled = @enabled
		, modified = @modified
		, display_name = @displayName
		, display_in_digest_view = @displayInDigestView
		, hidden = @hidden
		, sort_order = @sortOrder
	WHERE category_to_category_branch_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateCategoryBranch TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId
	@categoryId int,
	@subCategoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden, sort_order
	FROM category_to_category_branch
	WHERE category_id = @categoryId AND sub_category_id = @subCategoryId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBranchDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryBranchDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden, sort_order
	FROM category_to_category_branch
	WHERE category_to_category_branch_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryBranchDetail TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByParentCategoryIdIsSelectedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryByParentCategoryIdIsSelectedList
	@categoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed
		, enabled, modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
	FROM
	(
		SELECT category.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, 
			category.hidden, has_image, url_id, category_to_category_branch.sort_order
			, CASE
				WHEN (category_to_category_branch.display_name IS NOT NULL AND category_to_category_branch.display_name <> '')  THEN category_to_category_branch.display_name
				WHEN short_name IS NULL THEN category_name
				WHEN short_name = '' THEN category_name
				ELSE short_name
			END sort_name
		FROM category 
	 		INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId 
			AND category_to_category_branch.enabled = '1'
			AND category_to_category_branch.display_in_digest_view = '1'
			AND category.enabled = '1'
	) temp_table
	ORDER BY sort_order ASC, sort_name ASC
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryByParentCategoryIdIsSelectedList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsOrVendorsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryHavingProductsOrVendorsList
	@categoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
	FROM
	(
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category 
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
			AND category_to_category_branch.hidden = '0' AND category.hidden = 0
			AND
			(
				(category_type_id <> 4)
				OR 
				(
					(SELECT COUNT(product_id)
					FROM product_to_category
					WHERE product_to_category.category_id = category.category_id) > 0
				)
			)

		UNION

		SELECT category.category_id, category_to_category_branch.sort_order 
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN category_to_vendor
				ON category.category_id = category_to_vendor.category_id
			INNER JOIN vendor
				ON category_to_vendor.vendor_id = vendor.vendor_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0' AND
			category.category_type_id = 4 AND category.hidden = 0 AND
			vendor.[enabled] = '1' AND category_to_vendor.[enabled] = '1'
			
		UNION
		
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN fixed_guided_browse
				ON category.category_id = fixed_guided_browse.category_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0' AND
			category.category_type_id = 4 AND category.hidden = 0 AND fixed_guided_browse.[enabled] = 1
			
		UNION
		
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN category_parameter
				ON category.category_id = category_parameter.category_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0' AND
			category.category_type_id = 4 AND category.hidden = 0 AND category_parameter.category_parameter_value IS NOT NULL
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	ORDER BY sort_order ASC, category_name ASC
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsOrVendorsList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddCategoryBranch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddCategoryBranch
	@categoryId int,
	@subCategoryId int,
	@categoryBranchTypeId int,
	@displayName varchar(255),
	@displayInDigestView bit,
	@enabled bit,
	@hidden bit,
	@sortOrder int,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
--- $Author: Sahan Diasena  
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO category_to_category_branch (category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden, sort_order)
	VALUES (@categoryId, @subCategoryId, @categoryBranchTypeId, @enabled, @created
		, @created, @displayName, @displayInDigestView, @hidden, @sortOrder)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddCategoryBranch TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdCategoryIdsListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdCategoryIdsListWithPaging
	@categoryIds varchar(1000),
	@vendorId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Rifaz Rifky
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT id, site_id, product_Name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY p.product_id ASC) AS row, p.product_id as id, p.site_id, p.product_Name, p.rank
			, p.has_image, p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.[status]
			, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified
			, p.hidden, p.business_value,p.ignore_in_rapid,p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
		FROM product p
		WHERE p.product_id IN
		(
			SELECT ptv.product_id
			FROM product_to_vendor ptv
				INNER JOIN product_to_category ptc
					ON ptv.product_id = ptc.product_id
				INNER JOIN global_split(@categoryIds, ',') categoryId
					ON ptc.category_id = categoryId.[value]
			WHERE ptv.vendor_id = @vendorId AND ptv.is_manufacturer = 1
		)
	) AS tempPro
	WHERE row BETWEEN @startIndex AND @endIndex
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdCategoryIdsListWithPaging TO VpWebApp 
GO
