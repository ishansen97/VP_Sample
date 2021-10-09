EXEC dbo.global_DropStoredProcedure 'dbo.publicContent_GetContentParametersByContentTypeParameterTypeContentIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicContent_GetContentParametersByContentTypeParameterTypeContentIds
	@contentIds varchar(max),
	@contentParameterType varchar(200),
	@contentType int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;
	
	SELECT content_parameter_id As id, content_type_id, content_id, content_parameter_type, content_parameter_value, created, modified, [enabled]
	FROM content_parameter
	WHERE content_parameter_type = @contentParameterType AND content_type_id = @contentType AND content_id IN (SELECT [value] FROM global_split(@contentIds, ','))
	
END
GO

GRANT EXECUTE ON dbo.publicContent_GetContentParametersByContentTypeParameterTypeContentIds TO VpWebApp 
GO

--------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO

CREATE PROCEDURE dbo.adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList
	@siteId int,
	@text varchar(max),
	@categoryType int,
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
	
	INSERT INTO #category_ids (category_id)
	SELECT DISTINCT c.category_id
	FROM category c
	LEFT JOIN product_to_category pc
		ON c.category_id = pc.category_id
	LEFT JOIN product_to_vendor ptv
		ON pc.product_id = ptv.product_id
	WHERE @siteId = c.site_id 
		AND (@enabled IS NULL OR c.enabled = @enabled) 
		AND (@vendorId IS NULL OR ptv.vendor_id = @vendorId)
		AND category_name like @text+'%'
	
	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, 
				auto_generated, hidden, matrix_type, enabled,
				modified,  created, has_image, url_id
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
				(@categoryType IS NULL OR category_type_id = @categoryType)
	END
	ELSE
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
	END
	
	DROP TABLE #category_ids

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList TO VpWebApp
GO

-------------------------------------------------------------------------------------------------------------


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
	
	INSERT INTO #category_ids (category_id)
	SELECT DISTINCT c.category_id
	FROM category c
	LEFT JOIN product_to_category pc
		ON c.category_id = pc.category_id
	LEFT JOIN product_to_vendor ptv
		ON pc.product_id = ptv.product_id
	WHERE @siteId = c.site_id 
		AND (@enabled IS NULL OR c.enabled = @enabled) 
		AND (@vendorId IS NULL OR ptv.vendor_id = @vendorId)
		AND category_name like @text+'%'

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, auto_generated, matrix_type, enabled,
				modified,  created, hidden, has_image, url_id
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
				modified,  created, auto_generated, hidden, has_image, url_id
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
	END
	
	DROP TABLE #category_ids

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList TO VpWebApp
GO

----------------------------------------------------------------------------------------------


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
	
	INSERT INTO #category_ids (category_id)
	SELECT DISTINCT c.category_id
	FROM category c
	LEFT JOIN product_to_category pc
		ON c.category_id = pc.category_id
	LEFT JOIN product_to_vendor ptv
		ON pc.product_id = ptv.product_id
	WHERE @siteId = c.site_id 
		AND (@enabled IS NULL OR c.enabled = @enabled) 
		AND (@vendorId IS NULL OR ptv.vendor_id = @vendorId)
		AND category_name like @text+'%'

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, auto_generated, matrix_type, enabled,
				modified,  created, has_image, url_id
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
				modified,  created, auto_generated, has_image, url_id
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
	END

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList TO VpWebApp
GO

------------------------------------------------------------------------------------------------------

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
	
	INSERT INTO #category_ids (category_id)
	SELECT DISTINCT c.category_id
	FROM category c
	LEFT JOIN product_to_category pc
		ON c.category_id = pc.category_id
	LEFT JOIN product_to_vendor ptv
		ON pc.product_id = ptv.product_id
	WHERE @siteId = c.site_id 
		AND (@enabled IS NULL OR c.enabled = @enabled) 
		AND (@vendorId IS NULL OR ptv.vendor_id = @vendorId)

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