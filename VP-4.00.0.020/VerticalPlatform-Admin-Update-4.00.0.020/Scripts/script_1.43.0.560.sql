
IF EXISTS (
  SELECT 1 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[category]') 
         AND name = 'sort_order_index'
)
BEGIN
	ALTER TABLE category
	DROP COLUMN [sort_order_index]
END	

GO

-- sort_order column

IF NOT EXISTS (
  SELECT 1 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[category]') 
         AND name = 'sort_order'
)
BEGIN
	ALTER TABLE category
	ADD [sort_order] INT NOT NULL DEFAULT (0)
END	

GO


--updating default sorting orders
WITH temp_category(r_no, category_id, category_name, site_id) AS
	(
		-- default sorting orders
		SELECT	ROW_NUMBER() OVER(PARTITION BY site_id ORDER BY category_name ASC) AS r_no
				,category_id
				,category_name 
				,site_id
		FROM	dbo.category
		WHERE	category_type_id = 1 --trunk category

	)
UPDATE cat
SET cat.sort_order = CASE WHEN tmp.category_id IS NULL THEN 0 ELSE tmp.r_no END
--SELECT cat.category_id,cat.site_id,cat.[sort_order],CASE WHEN tmp.category_id IS NULL THEN 0 ELSE tmp.r_no END AS newIndex
FROM dbo.category cat
	LEFT JOIN temp_category tmp ON tmp.category_id = cat.category_id

GO	




GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetCategoryByCategoryIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminCategory_GetCategoryByCategoryIdsList]    Script Date: 12/3/2018 11:53:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminCategory_GetCategoryByCategoryIdsList]
	@categoryIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
			, cat.description, cat.short_name, cat.specification, cat.is_search_category 
			, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count
			, auto_generated, cat.hidden, has_image, url_id,cat.sort_order
	FROM category AS cat 
		INNER JOIN global_Split(@categoryIds, ',') AS category_id_table
			ON cat.category_id = category_id_table.[value]
		INNER JOIN category_to_category_branch cat_cat 
			ON cat_cat.sub_category_id = cat.category_id
	WHERE (cat_cat.enabled = 1 AND cat.enabled = 1 AND cat.hidden = 0)
END

GO
GRANT EXECUTE ON dbo.adminCategory_GetCategoryByCategoryIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetCategoryByRangeDisabledList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminCategory_GetCategoryByRangeDisabledList]    Script Date: 12/3/2018 11:54:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminCategory_GetCategoryByRangeDisabledList]
	@categoryId int,
	@leafCategoryIds varchar(250)
AS
-- ==========================================================================
-- Author: Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	-- Contains the category ids from the specified to leaves
	DECLARE @tb TABLE (category_id int);

	-- Contains the catgory ids from the leaves to top
	DECLARE @bt TABLE (category_id int);

	WITH tb (category_id) AS
	(
		SELECT category_id
		FROM category 
		WHERE category_id = @categoryId

		UNION ALL

		SELECT c.category_id
		FROM category c
			INNER JOIN category_to_category_branch b
				ON c.category_id = b.sub_category_id
			INNER JOIN tb
				ON b.category_id = tb.category_id
	)

	INSERT INTO @tb
	SELECT category_id 
	FROM tb;

	WITH bt (category_id) AS
	(
		SELECT category_id
		FROM category
			INNER JOIN global_Split(@leafCategoryIds, ',') l
				ON category.category_id = l.[value] 

		UNION ALL

		SELECT c.category_id
		FROM category c
			INNER JOIN category_to_category_branch b
				ON c.category_id = b.category_id
			INNER JOIN bt
				ON b.sub_category_id = bt.category_id
	)

	INSERT INTO @bt
	SELECT category_id 
	FROM bt

	SELECT category.category_id AS id, site_id, category_name, category_type_id, description, specification, enabled, 
		modified, created, is_search_category, is_displayed, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM 
		(
			SELECT * FROM @tb
			INTERSECT 
			SELECT * FROM @bt
		) tc
			INNER JOIN category
				ON tc.category_id = category.category_id
	WHERE category.enabled = 0
	END

GO
GRANT EXECUTE ON dbo.adminCategory_GetCategoryByRangeDisabledList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetGeneratedCategories'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminCategory_GetGeneratedCategories]    Script Date: 12/3/2018 12:05:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_GetGeneratedCategories]
	@siteId INT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT c.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category 
			, is_displayed, c.[enabled], c.modified, c.created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,c.sort_order
	FROM category c
	WHERE c.site_id = @siteId
		AND c.auto_generated = 1
	
END

GO
GRANT EXECUTE ON dbo.adminCategory_GetGeneratedCategories TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetSearchCategories'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminCategory_GetSearchCategories]    Script Date: 12/3/2018 12:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_GetSearchCategories]
	@siteId INT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT c.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category 
			, is_displayed, c.[enabled], c.modified, c.created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,c.sort_order
	FROM category c
	WHERE c.site_id = @siteId
		AND c.is_search_category = 1
	
END

GO
GRANT EXECUTE ON dbo.adminCategory_GetSearchCategories TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetCategoryBySiteIdSearchList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminPlatform_GetCategoryBySiteIdSearchList]    Script Date: 12/3/2018 11:33:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminPlatform_GetCategoryBySiteIdSearchList]
	@siteId int,
	@search varchar(255),
	@numberOfItems int 
AS
-- =========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/branches/VPDocumentManagement/db/VerticalPlatformDB/adminPlatform_GetFileBySiteIdSearchList.sql $
-- $Revision: 5776 $
-- $Date: 2010-07-15 13:20:53 +0530 (Thu, 15 Jul 2010) $ 
-- $Author: dhanushka $
-- =========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@numberOfItems) category_id AS id, site_id, category_name, category_type_id, description, specification
			, is_search_category, is_displayed, short_name, matrix_type, enabled, created, modified, product_count
			, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
	WHERE site_id = @siteId AND category_name LIKE '%' + @search + '%'

END

GO
GRANT EXECUTE ON dbo.adminPlatform_GetCategoryBySiteIdSearchList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedCategoriesBySiteId'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminPlatform_GetUnindexedCategoriesBySiteId]    Script Date: 12/3/2018 11:52:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminPlatform_GetUnindexedCategoriesBySiteId]
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: umesha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) category_id AS id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
		, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
	WHERE enabled = 1 AND site_id = @siteId AND category_id NOT IN 
		(	SELECT content_id 
			FROM search_content_status
			WHERE site_id=@siteId AND content_type_id = 1
		)
	AND category_id IN
		(
			SELECT content_id 
			FROM fixed_url
			WHERE site_id=@siteId AND content_type_id = 1 AND enabled = 1
		)
END

GO
GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedCategoriesBySiteId TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddCategory'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_AddCategory]    Script Date: 12/3/2018 10:38:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_AddCategory]
	@siteId int,
	@categoryName varchar(255),
	@categoryTypeId int,
	@description varchar(max),
	@shortName varchar(50),
	@specification varchar(200),
	@isSearchCategory bit,
	@isDisplayed bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@matrixType int,
	@productCount int,
	@autoGenerated bit,
	@hidden bit,
	@hasImage bit,
	@urlId INT,
	@sort_order INT
AS
-- ==========================================================================
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @created = GETDATE()
	INSERT INTO category(site_id, category_name, category_type_id, [description], short_name, specification
			, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
			,sort_order) 
	VALUES (@siteId, @categoryName, @categoryTypeId, @description, @shortName, @specification, @isSearchCategory
			, @isDisplayed, @enabled, @created, @created, @matrixType, @productCount, @autoGenerated, @hidden, @hasImage, @urlId
			,@sort_order) 

	SET @id = SCOPE_IDENTITY() 

END

GO
GRANT EXECUTE ON dbo.adminProduct_AddCategory TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetAllCategoryByParentCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetAllCategoryByParentCategoryIdList]    Script Date: 12/3/2018 11:03:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetAllCategoryByParentCategoryIdList]
	@categoryId int
AS
-- ==========================================================================
-- $Author: Nilushi Hikkaduwa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, description, short_name, specification
			, category.is_search_category, category.is_displayed, matrix_type, category.enabled, category.modified, category.created
			, category.product_count, category.auto_generated, category.hidden, category.has_image, category.url_id,category.sort_order
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetAllCategoryByParentCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetAllCategoryByParentCategoryIdPageList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetAllCategoryByParentCategoryIdPageList]    Script Date: 12/3/2018 11:04:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetAllCategoryByParentCategoryIdPageList]
	@categoryId int,
	@pageSize int,
	@pageIndex int,
	@sortOrder varchar(50),
	@sortBy varchar(50),	
	@totalCount int out
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;
	
	WITH temp_category(row, rowDesc, modifiedRow, modifiedRowDesc, idRow, idRowDesc, nameRow, nameRowDesc, id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order) AS
	(
	
		SELECT ROW_NUMBER() OVER (ORDER BY category.created) AS row, 
			ROW_NUMBER() OVER (ORDER BY category.created DESC) AS rowDesc,
			ROW_NUMBER() OVER (ORDER BY category.modified) AS modifiedRow, 
			ROW_NUMBER() OVER (ORDER BY category.modified DESC) AS modifiedRowDesc,
			ROW_NUMBER() OVER (ORDER BY category.category_id) AS idRow, 
			ROW_NUMBER() OVER (ORDER BY category.category_id DESC) AS idRowDesc,
			ROW_NUMBER() OVER (ORDER BY category.[category_name]) AS nameRow, 
			ROW_NUMBER() OVER (ORDER BY category.[category_name] DESC) AS nameRowDesc,
			category.category_id AS id, category.site_id, category.category_name, category.category_type_id, category.[description], category.short_name, category.specification, category.is_search_category
			, category.is_displayed, category.[enabled], category.modified, category.created, category.matrix_type, category.product_count, category.auto_generated, category.hidden, category.has_image, category.url_id,category.sort_order
		FROM category 
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId
	)

	SELECT id, site_id, category_name, category_type_id, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM temp_category
	WHERE (@sortBy = 'created' AND @sortOrder = 'asc' AND row BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'created' AND @sortOrder = 'desc' AND rowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'id' AND @sortOrder = 'asc' AND idRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'name' AND @sortOrder = 'asc' AND nameRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'name' AND @sortOrder = 'desc' AND nameRowDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
			CASE 
				WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN row 
				WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN rowDesc
				WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedRow 
				WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedRowDesc
				WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idRow 
				WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idRowDesc
				WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameRow 
				WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameRowDesc
			END
			
	SELECT @totalCount = COUNT(*)
	FROM category 
		INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId
	
END

GO
GRANT EXECUTE ON dbo.adminProduct_GetAllCategoryByParentCategoryIdPageList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetAllChildCategoriesByParentCategoryID'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetAllChildCategoriesByParentCategoryID]    Script Date: 12/3/2018 10:59:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetAllChildCategoriesByParentCategoryID]
	@categoryId int,
	@pageSize int,
	@pageIndex int,
	@sortOrder varchar(50),
	@sortBy varchar(50),	
	@totalCount int out
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
		
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;
	
	WITH temp_category(row, rowDesc, modifiedRow, modifiedRowDesc, idRow, idRowDesc, nameRow, nameRowDesc, id, site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY category.created) AS row, 
			ROW_NUMBER() OVER (ORDER BY category.created DESC) AS rowDesc,
			ROW_NUMBER() OVER (ORDER BY category.modified) AS modifiedRow, 
			ROW_NUMBER() OVER (ORDER BY category.modified DESC) AS modifiedRowDesc,
			ROW_NUMBER() OVER (ORDER BY category.category_id) AS idRow, 
			ROW_NUMBER() OVER (ORDER BY category.category_id DESC) AS idRowDesc,
			ROW_NUMBER() OVER (ORDER BY [category_name]) AS nameRow, 
			ROW_NUMBER() OVER (ORDER BY [category_name] DESC) AS nameRowDesc,
			category.category_id AS id, site_id, category_name, category_type_id, description, short_name, specification
			, category.is_search_category, category.is_displayed, category.enabled, category.modified, category.created, matrix_type
			, category.product_count, category.auto_generated, category.hidden, category.has_image, url_id,category.sort_order
		FROM category 
			INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId
	)
	
	SELECT id, site_id, category_name, category_type_id, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM temp_category
	WHERE (@sortBy = 'created' AND @sortOrder = 'asc' AND row BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'created' AND @sortOrder = 'desc' AND rowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'id' AND @sortOrder = 'asc' AND idRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'name' AND @sortOrder = 'asc' AND nameRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'name' AND @sortOrder = 'desc' AND nameRowDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
			CASE 
				WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN row 
				WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN rowDesc
				WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedRow 
				WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedRowDesc
				WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idRow 
				WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idRowDesc
				WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameRow 
				WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameRowDesc
			END
			
	SELECT @totalCount = COUNT(*)
	FROM category 
		INNER JOIN category_to_category_branch
		ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId	
	
END

GO
GRANT EXECUTE ON dbo.adminProduct_GetAllChildCategoriesByParentCategoryID TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetAllChildCategoryByParentCategoryIdPageList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetAllChildCategoryByParentCategoryIdPageList]    Script Date: 12/3/2018 12:02:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetAllChildCategoryByParentCategoryIdPageList]
	@categoryId int,
	@startIndex int,
	@endIndex int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Yasoda Handehewa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

		SELECT id, site_id, category_name, category_type_id,[description], short_name, specification
		   , is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
		   , auto_generated, hidden, has_image, url_id,sort_order
		FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category.category_id ASC) AS row, category.category_id AS id, site_id, category_name
				,category_type_id, description, short_name, specification
				, category.is_search_category, category.is_displayed, matrix_type, category.enabled, category.modified, category.created
				, category.product_count, category.auto_generated, category.hidden, category.has_image, category.url_id,category.sort_order
			FROM category 
				INNER JOIN category_to_category_branch
					ON category.category_id = category_to_category_branch.sub_category_id
			WHERE category_to_category_branch.category_id = @categoryId
		)AS OrphanCat
		WHERE row BETWEEN @startIndex AND @endIndex
		
		SELECT @totalCount = COUNT(*)
		FROM category 
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId 
		
END

GO
GRANT EXECUTE ON dbo.adminProduct_GetAllChildCategoryByParentCategoryIdPageList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoriesByCategoryTypes'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoriesByCategoryTypes]    Script Date: 12/3/2018 11:38:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoriesByCategoryTypes]
	@siteId int,
	@categoryTypes varchar(100),
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
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId  
				AND (@enabled IS NULL OR c.enabled = @enabled)
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id 
			AND (@enabled IS NULL OR enabled = @enabled)
	END
	
	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT @totalCount = COUNT(*)
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
			(@categoryTypes IS NULL OR category_type_id IN (SELECT [value] FROM global_Split(@categoryTypes, ','))) AND 
			@siteId = site_id AND (@enabled IS NULL OR enabled = @enabled)  ;
	
		WITH temp_category (row, id, site_id, category_name, category_type_id, description, short_name, specification, is_search_category, 
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated, hidden, has_image, url_id,sort_order) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id,c.sort_order
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
			WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
				(@categoryTypes IS NULL OR category_type_id IN (SELECT [value] FROM global_Split(@categoryTypes, ',')))
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated, hidden, has_image, url_id,sort_order
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
		WHERE @siteId = site_id AND (@enabled IS NULL OR enabled = @enabled);

		WITH temp_category (row, id, site_id, category_name, category_type_id, description, short_name, specification, is_search_category, 
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated
		FROM temp_category
		WHERE row BETWEEN @startIndex AND @endIndex
		ORDER BY row
	END

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoriesByCategoryTypes TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoriesByProductIds'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoriesByProductIds]    Script Date: 12/3/2018 12:05:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoriesByProductIds]	
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author : Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id, product_id,cat.sort_order
	FROM category AS cat
		INNER JOIN product_to_category
			ON cat.category_id = product_to_category.category_id
	WHERE (product_to_category.product_id IN 
		(SELECT [value] FROM dbo.global_Split(@productIds, ','))) AND (cat.[enabled] = 1)

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoriesByProductIds TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoriesBySiteIdBatchSizeStartIndexList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoriesBySiteIdBatchSizeStartIndexList]    Script Date: 12/3/2018 11:33:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoriesBySiteIdBatchSizeStartIndexList]
	@siteId int,
	@startIndex int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @endIndex int
	SET @endIndex = @startIndex + @batchSize - 1;

	WITH temp_category(row, id, site_id, category_name, category_type_id, [description], 
		specification, enabled, modified, created, is_search_category, is_displayed, short_name, 
		matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY category_id) row, category_id AS id, site_id, 
			category_name, category_type_id, [description], 
			specification, enabled, modified, created, is_search_category, is_displayed, short_name, 
			matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE site_id = @siteId 
	)

	SELECT id, site_id, category_name, category_type_id, [description], 
		specification, enabled, modified, created, is_search_category, is_displayed, short_name, 
		matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM temp_category
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoriesBySiteIdBatchSizeStartIndexList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoriesBySiteIdLikeCategoryName'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoriesBySiteIdLikeCategoryName]    Script Date: 12/3/2018 11:24:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoriesBySiteIdLikeCategoryName]
	@siteId int,
	@value varchar(max),
	@isEnabled bit
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetCategoriesBySiteIdLikeCategoryName.sql $
-- $Revision: 6351 $
-- $Date: 2010-08-18 11:12:41 +0530 (Wed, 18 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, site_id, category_name, category_type_id, description, short_name
			 , specification, cat.is_search_category, is_displayed, matrix_type, cat.enabled, cat.modified
			 , cat.created, cat.product_count, cat.auto_generated, cat.hidden, cat.has_image, url_id,cat.sort_order
	FROM category AS cat 
	WHERE cat.site_id = @siteId AND cat.category_name like @value+'%' AND (@isEnabled IS NULL OR cat.enabled = @isEnabled)

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoriesBySiteIdLikeCategoryName TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByChildCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryByChildCategoryIdList]    Script Date: 12/3/2018 11:18:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryByChildCategoryIdList]
	@childCategoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetCategoryByChildCategoryIdList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification , category.is_search_category
			, category.is_displayed, category.enabled, category.modified, category.created, matrix_type, product_count
			, auto_generated, category.hidden, has_image, url_id,category.sort_order
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.category_id
	WHERE category_to_category_branch.sub_category_id = @childCategoryId

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryByChildCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByParentCategoryIdListWithSorting'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryByParentCategoryIdListWithSorting]    Script Date: 12/3/2018 11:06:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryByParentCategoryIdListWithSorting]
	@categoryId int,
	@sortBy varchar(10),
	@sortOrder varchar(5)
AS
-- ==========================================================================
-- $Author : Nilushi Hikkaduwa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY cat.category_id) AS idRow, cat.category_id AS id, cat.site_id AS site_id
			, ROW_NUMBER() OVER (ORDER BY cat.category_name) AS nameRow, cat.category_name AS category_name
			, cat.category_type_id AS category_type_id, cat.description AS description, short_name AS short_name
			, cat.specification AS specification
			, cat.is_search_category AS is_search_category, cat.is_displayed AS is_displayed, cat.auto_generated AS auto_generated
			, cat.hidden AS hidden, cat.has_image, cat.url_id,cat.sort_order
			, cat.[enabled] AS [enabled], ROW_NUMBER() OVER (ORDER BY cat.modified) AS modifiedRow, cat.modified AS modified
			, ROW_NUMBER() OVER (ORDER BY cat.created) AS createdRow, cat.created AS created, matrix_type
			, ROW_NUMBER() OVER (ORDER BY matrix_type) AS matrixTypeRow
			, product_count INTO #tmpCategories
	FROM category cat
			INNER JOIN category_to_category_branch cb
					ON cat.category_id = cb.sub_category_id 
	WHERE cb.category_id = @categoryId

	IF @sortOrder = 'asc'
	BEGIN
		SELECT id, site_id, category_name, category_type_id, description, short_name, specification
				, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM #tmpCategories
		ORDER BY
			CASE @sortBy
				WHEN 'Id' THEN idRow
				WHEN 'Name' THEN nameRow 
				WHEN 'MatrixType' THEN matrixTypeRow
				WHEN 'Created' THEN createdRow
				WHEN 'Modified' THEN modifiedRow
			END
		ASC
	END
	ELSE
	BEGIN
		SELECT id, site_id, category_name, category_type_id, description, short_name, specification
				, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM #tmpCategories
		ORDER BY
			CASE @sortBy
				WHEN 'Id' THEN idRow
				WHEN 'Name' THEN nameRow 
				WHEN 'MatrixType' THEN matrixTypeRow
				WHEN 'Created' THEN createdRow
				WHEN 'Modified' THEN modifiedRow
			END
		DESC
	END	

	DROP TABLE #tmpCategories	

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryByParentCategoryIdListWithSorting TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryByProductIdList]    Script Date: 12/3/2018 11:10:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryByProductIdList]
	@productId int
AS
-- ==========================================================================
-- $Archive: /Documents/Templates/moduleName_StoredProcedureName.sql $
-- $Revision: 2 $
-- $Date: 3/14/08 3:43p $ 
-- $Author: Dherbst $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id,cat.sort_order
	FROM category AS cat 
		INNER JOIN product_to_category AS prodCat
			ON prodCat.product_id = @productId AND cat.category_id = prodCat.category_id

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryByProductIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryByProductIdsList]    Script Date: 12/3/2018 11:12:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryByProductIdsList]
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id,cat.sort_order
	FROM category AS cat
	WHERE category_id
		IN (SELECT DISTINCT category_id FROM product_to_category prodCat
				WHERE prodCat.product_id IN (SELECT [value] FROM Global_Split(@productIds, ',')))

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryByProductIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdBatchSizeModifiedCategoryVendorList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdBatchSizeModifiedCategoryVendorList]    Script Date: 12/3/2018 11:27:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdBatchSizeModifiedCategoryVendorList]
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) category.category_id AS id, category.site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category, is_displayed
		, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id,sort_order
	FROM category
		INNER JOIN category_to_vendor
			ON category.category_id = category_to_vendor.category_id
		INNER JOIN content_text
			ON category.category_id = content_text.content_id AND content_text.content_type_id = 1
	WHERE category.site_id = @siteId
		AND category.enabled = 1 AND category_type_id = 4 AND category.hidden = 0
		AND	category_to_vendor.modified > content_text.modified

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdBatchSizeModifiedCategoryVendorList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdBatchSizeModifiedList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdBatchSizeModifiedList]    Script Date: 12/3/2018 11:25:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdBatchSizeModifiedList]
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) category_id AS id, category.site_id, category_name, category_type_id
		, description, short_name, specification, is_search_category, is_displayed
		, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
			LEFT JOIN content_text
				ON category_id = content_text.content_id AND content_text.content_type_id = 1
	WHERE category.site_id = @siteId 
		AND category.enabled = 1 AND category_type_id = 4 AND category.hidden = 0
		AND	(content_text.modified IS NULL OR category.modified > content_text.modified)

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdBatchSizeModifiedList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdBatchSizeModifiedTagList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdBatchSizeModifiedTagList]    Script Date: 12/3/2018 11:28:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdBatchSizeModifiedTagList]
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT TOP (@batchSize) category.category_id AS id, category.site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category, is_displayed
		, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id,sort_order
	FROM category
		INNER JOIN content_tag
			ON content_tag.content_type_id = 1 AND category.category_id = content_tag.content_id
		INNER JOIN content_text
			ON content_text.content_type_id = 1 AND content_text.content_id = category.category_id
	WHERE category.site_id = @siteId AND category.enabled = 1 AND category.hidden = 0 AND 
		content_tag.modified > content_text.modified
END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdBatchSizeModifiedTagList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList]    Script Date: 12/3/2018 11:34:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList]
	@siteId int,
	@text varchar(max),
	@categoryType int,
	@matrixType int,
	@selectLimit int,
	@vendorId int,
	@enabled bit
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #category_ids (category_id int)
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id
	END

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, 
				auto_generated, hidden, matrix_type, enabled,
				modified,  created, has_image, url_id,c.sort_order
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType)
			AND (@categoryType IS NULL OR category_type_id = @categoryType)
			AND category_name like @text+'%'
	END
	ELSE
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id,c.sort_order
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE category_name like @text+'%' 
	END
	
	DROP TABLE #category_ids

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdCategoryTypeMatrixTypeIdsLikeCategoryNameList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdCategoryTypePageIndexPageSizeMatrixTypeIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdCategoryTypePageIndexPageSizeMatrixTypeIdsList]    Script Date: 12/3/2018 11:36:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdCategoryTypePageIndexPageSizeMatrixTypeIdsList]
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
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId  
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id 
	END

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT @totalCount = COUNT(*)
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
		WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
			(@categoryType IS NULL OR category_type_id = @categoryType)
	
		;WITH temp_category (row, id, site_id, category_name, category_type_id, description, short_name, specification, is_search_category, 
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated, hidden, has_image, url_id,sort_order) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id,sort_order
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
			WHERE (@matrixType IS NULL OR matrix_type = @matrixType) AND 
				(@categoryType IS NULL OR category_type_id = @categoryType)
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated, hidden, has_image, url_id,sort_order
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
			is_displayed, product_count, matrix_type, enabled, modified,  created, auto_generated, hidden, has_image, url_id,sort_order) AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY category_name) AS row, c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, matrix_type, enabled,
				modified,  created, auto_generated, hidden, has_image, url_id,c.sort_order
			FROM category c
				INNER JOIN #category_ids
					ON c.category_id = #category_ids.category_id
		)

		SELECT id, site_id, category_name, category_type_id, description, short_name
				, specification, is_search_category, is_displayed, product_count, matrix_type, enabled
				, modified, created, auto_generated, hidden, has_image, url_id,sort_order
		FROM temp_category
		WHERE row BETWEEN @startIndex AND @endIndex
		ORDER BY row
	END
	
	DROP TABLE #category_ids

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdCategoryTypePageIndexPageSizeMatrixTypeIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList]    Script Date: 12/3/2018 11:35:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList]
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
	
	IF(@vendorId IS NOT NULL)
	BEGIN
	
		INSERT INTO #category_ids (category_id)
		SELECT DISTINCT c.category_id
		FROM product_to_vendor pv
			INNER JOIN product_to_category pc
				  ON pv.product_id = pc.product_id
			INNER JOIN category c
				  ON pc.category_id = c.category_id
			INNER JOIN product p 
				  ON pc.product_id = p.product_id
		WHERE @siteId = c.site_id 
			AND (@enabled IS NULL OR c.enabled = @enabled) 
			AND pv.vendor_id = @vendorId
			AND category_name like @text+'%'
			
		INSERT INTO #category_ids (category_id)
		SELECT category_id 
		FROM
		(
			SELECT c.category_id    
			FROM category c
				INNER JOIN category_to_vendor cv
					ON c.category_id = cv.category_id
			WHERE @siteId = c.site_id 
				AND cv.vendor_id = @vendorId
				AND category_name like @text+'%'  
		) category_ids
		WHERE category_id NOT IN (SELECT category_id FROM #category_ids)
	END
	ELSE
	BEGIN
		INSERT INTO #category_ids (category_id)
		SELECT category_id    
		FROM category
		WHERE @siteId = site_id
			AND category_name like @text+'%'
	END

	IF (@matrixType = 1 OR @matrixType = 4 OR @matrixType IS NULL)
	BEGIN
		SELECT TOP(@selectLimit) c.category_id AS id, site_id, category_name, category_type_id, 
				description, short_name, specification, is_search_category, is_displayed, product_count, auto_generated, matrix_type, enabled,
				modified,  created, has_image, url_id, hidden,c.sort_order
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
				modified,  created, auto_generated, has_image, url_id, hidden,c.sort_order
		FROM category c
			INNER JOIN #category_ids
				ON c.category_id = #category_ids.category_id
	END

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdCategoryTypesLikeCategoryNameList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdList]    Script Date: 12/3/2018 11:12:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdList]
	@siteId int
AS
-- ==========================================================================
-- $Archive: /Documents/Templates/adminProduct_GetCategoryBySiteIdList.sql $
-- $Revision: 2 $
-- $Date: 3/14/08 3:43p $ 
-- $Author: Dherbst $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, site_id, category_name, category_type_id, description, short_name
		, specification, cat.is_search_category, is_displayed, cat.enabled, cat.modified, cat.created, cat.auto_generated
		, matrix_type, product_count, cat.hidden,cat.has_image, cat.url_id,cat.sort_order
	FROM category AS cat 
	WHERE cat.site_id = @siteId

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdStartIndexEndIndexList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdStartIndexEndIndexList]    Script Date: 12/3/2018 11:25:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdStartIndexEndIndexList]
	@siteId int,
	@startRowIndex int,
	@endRowIndex int
AS
-- ==========================================================================
--$Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH selectedCategory(id, row_id, site_id, category_name, category_type_id
				, [description], short_name, specification, is_search_category, is_displayed
				, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order)
	AS
	(
		SELECT category_id AS id, ROW_NUMBER() OVER (ORDER BY category_id) AS row_id, site_id, category_name, category_type_id
				, [description], short_name, specification, is_search_category, is_displayed
				, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE site_id = @siteId AND [enabled] = 1 AND category_type_id = 4 AND hidden = 0
	)

	SELECT id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category, is_displayed
			, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM selectedCategory
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdStartIndexEndIndexList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySiteIdTrunkListWithSorting'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySiteIdTrunkListWithSorting]    Script Date: 12/3/2018 11:00:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySiteIdTrunkListWithSorting]
	@siteId int,
	@sortBy varchar(10),
	@sortOrder varchar(5)
AS
-- ==========================================================================
-- $URL$
-- $Revision$
-- $Date$ 
-- $Author$
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY category_id) AS idRow, category_id AS id, site_id AS site_id
			, ROW_NUMBER() OVER (ORDER BY category_name) AS nameRow, category_name AS category_name
			, category_type_id AS category_type_id, [description] AS [description], short_name AS short_name
			, specification AS specification
			, is_search_category AS is_search_category, is_displayed AS is_displayed, auto_generated AS auto_generated
			, hidden AS hidden, has_image AS has_image, url_id AS url_id , sort_order AS sort_order
			, [enabled] AS [enabled], ROW_NUMBER() OVER (ORDER BY modified) AS modifiedRow, modified AS modified
			, ROW_NUMBER() OVER (ORDER BY created) AS createdRow, created AS created, ROW_NUMBER() OVER (ORDER BY matrix_type) AS matrixTypeRow
			, matrix_type, product_count INTO #tmpCategories
	FROM category 
	WHERE site_id = @siteId AND category_type_id = 1

	IF @sortOrder = 'asc'
	BEGIN

		SELECT id, site_id, category_name, category_type_id, [description], short_name, specification
				, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM #tmpCategories
		ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow
					WHEN 'Name' THEN nameRow 
					WHEN 'MatrixType' THEN matrixTypeRow
					WHEN 'Created' THEN createdRow
					WHEN 'Modified' THEN modifiedRow
				END	
		ASC
	END
	ELSE
	BEGIN

		SELECT id, site_id, category_name, category_type_id, [description], short_name, specification
				, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM #tmpCategories
		ORDER BY
				CASE @sortBy
					WHEN 'Id' THEN idRow
					WHEN 'Name' THEN nameRow 
					WHEN 'MatrixType' THEN matrixTypeRow
					WHEN 'Created' THEN createdRow
					WHEN 'Modified' THEN modifiedRow
				END	
		DESC
	END

	DROP TABLE #tmpCategories

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySiteIdTrunkListWithSorting TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySubCategoryIdBranchEnabledList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryBySubCategoryIdBranchEnabledList]    Script Date: 12/3/2018 11:45:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryBySubCategoryIdBranchEnabledList]
	@subCategoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetCategoryBySubCategoryIdBranchEnabledList.sql $
-- $Revision: 8895 $
-- $Date: 2011-02-03 18:36:24 +0530 (Thu, 03 Feb 2011) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id
		, [description], short_name, specification , category.is_search_category
		, category.is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id,category.sort_order
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.category_id
	WHERE category_to_category_branch.sub_category_id = @subCategoryId 
		AND category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0'

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySubCategoryIdBranchEnabledList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByVendorIdSiteIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetCategoryByVendorIdSiteIdList]    Script Date: 12/3/2018 11:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetCategoryByVendorIdSiteIdList]
	@vendorId int,
	@siteId int
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, category.site_id, category_name, category_type_id, [description], specification
		, category.[enabled], category.modified, category.created, is_search_category
		, is_displayed, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM 
	(
		SELECT DISTINCT product_to_category.category_id
		FROM product_to_category 
			INNER JOIN product_to_vendor 
				ON product_to_category.product_id = product_to_vendor.product_id
		WHERE product_to_vendor.vendor_id = @vendorId
	) c
		INNER JOIN category
			ON c.category_id = category.category_id
	WHERE category.site_id = @siteId
	ORDER BY category.category_name

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetCategoryByVendorIdSiteIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdList]    Script Date: 12/3/2018 11:13:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdList]
	@siteId int
AS
-- ==========================================================================
-- $URL:  $
-- $Revision:  $
-- $Date:  $ 
-- $Author:  $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT cat.category_id AS id, cat.site_id AS site_id, cat.category_name AS category_name
		, cat.category_type_id AS category_type_id, cat.description AS [description], cat.short_name AS short_name
		, cat.specification AS specification, cat.is_search_category AS is_search_category
		, cat.is_displayed AS is_displayed, cat.[enabled] AS [enabled], cat.modified AS modified
		, cat.created AS created, cat.matrix_type AS matrix_type, cat.product_count AS product_count
		, cat.auto_generated AS auto_generated, cat.hidden AS hidden, cat.has_image AS has_image, cat.url_id AS url_id,cat.sort_order AS sort_order
	FROM category cat
			INNER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id
			INNER JOIN category catParent
				ON catParent.category_id = cb.category_id
	WHERE cat.site_id = @siteId AND cat.category_type_id = 4 AND catParent.matrix_type <> 2
	ORDER BY cat.category_name

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdList]    Script Date: 12/3/2018 11:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdList]
	@siteId int,
	@matrixTypeId varchar(MAX)
AS
-- ==========================================================================
-- $URL:  $
-- $Revision:  $
-- $Date:  $ 
-- $Author:  $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT cat.category_id AS id, cat.site_id AS site_id, cat.category_name AS category_name
		, cat.category_type_id AS category_type_id, cat.description AS description, cat.short_name AS short_name
		, cat.specification AS specification, cat.is_search_category AS is_search_category
		, cat.is_displayed AS is_displayed, cat.[enabled] AS [enabled], cat.modified AS modified
		, cat.created AS created, cat.matrix_type AS matrix_type, cat.product_count AS product_count
		, cat.auto_generated AS auto_generated, cat.hidden AS hidden, cat.has_image AS has_image, cat.url_id AS url_id
		,cat.sort_order AS sort_order
	FROM category cat
			INNER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id
			INNER JOIN category catParent
				ON catParent.category_id = cb.category_id
	WHERE cat.site_id = @siteId AND cat.category_type_id = 4 AND catParent.matrix_type <> 2
		AND  cat.matrix_type IN (SELECT [value]
			FROM global_Split(@MatrixTypeId, ','))
	ORDER BY cat.category_name

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdListSearch'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdListSearch]    Script Date: 12/3/2018 11:15:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdListSearch]
	@siteId int,
	@value varchar(max),
	@matrixTypeId varchar(MAX)
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetLeafCategoryLikeWithoutMatrixBParentBySiteIdMatrixTypeIdList.sql $
-- $Revision: 7520 $
-- $Date: 2010-11-12 15:37:24 +0530 (Fri, 12 Nov 2010) $ 
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT cat.category_id AS id, cat.site_id AS site_id, cat.category_name AS category_name
		, cat.category_type_id AS category_type_id, cat.description AS description, cat.short_name AS short_name
		, cat.specification AS specification, cat.is_search_category AS is_search_category
		, cat.is_displayed AS is_displayed, cat.[enabled] AS [enabled], cat.modified AS modified
		, cat.created AS created, cat.matrix_type AS matrix_type, cat.product_count, cat.auto_generated, cat.has_image, cat.url_id,cat.sort_order
	FROM category cat
			INNER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id
			INNER JOIN category catParent
				ON catParent.category_id = cb.category_id
	WHERE cat.site_id = @siteId AND cat.category_type_id = 4 AND catParent.matrix_type <> 2
		AND  cat.matrix_type IN (SELECT [value]
			FROM global_Split(@MatrixTypeId, ',')) AND cat.category_name like @value+'%'
	ORDER BY cat.category_name

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetLeafCategoryWithoutMatrixBParentBySiteIdMatrixTypeIdListSearch TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetNonHiddenCategoryBySiteIdStartIndexEndIndexList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetNonHiddenCategoryBySiteIdStartIndexEndIndexList]    Script Date: 12/3/2018 11:58:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetNonHiddenCategoryBySiteIdStartIndexEndIndexList]
	@siteId int,
	@startRowIndex int,
	@endRowIndex int
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH selectedCategory(id, row_id, site_id, category_name, category_type_id
				, [description], short_name, specification, is_search_category, is_displayed
				, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order)
	AS
	(
		SELECT category_id AS id, ROW_NUMBER() OVER (ORDER BY category_id) AS row_id, site_id, category_name, category_type_id
				, [description], short_name, specification, is_search_category, is_displayed
				, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE (@siteId IS NULL OR site_id = @siteId) 
				AND [enabled] = '1' AND hidden = '0' AND category_type_id = 4
	)

	SELECT id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category, is_displayed
			, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM selectedCategory
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetNonHiddenCategoryBySiteIdStartIndexEndIndexList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetNonSearchCategoriesBySiteIdBatchSizeStartIndexList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetNonSearchCategoriesBySiteIdBatchSizeStartIndexList]    Script Date: 12/3/2018 11:57:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetNonSearchCategoriesBySiteIdBatchSizeStartIndexList]
	@siteId int,
	@startIndex int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DECLARE @endIndex int
	SET @endIndex = @startIndex + @batchSize - 1;

	WITH temp_category(row, id, site_id, category_name, category_type_id, [description], 
		specification, enabled, modified, created, is_search_category, is_displayed, short_name, 
		matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY category_id) row, category_id AS id, site_id, 
			category_name, category_type_id, [description], 
			specification, enabled, modified, created, is_search_category, is_displayed, short_name, 
			matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE site_id = @siteId AND is_search_category = 0
	)

	SELECT id, site_id, category_name, category_type_id, [description], 
		specification, enabled, modified, created, is_search_category, is_displayed, short_name, 
		matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM temp_category
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetNonSearchCategoriesBySiteIdBatchSizeStartIndexList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetNonSearchCategoryBySiteIdStartIndexEndIndexList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetNonSearchCategoryBySiteIdStartIndexEndIndexList]    Script Date: 12/3/2018 11:56:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetNonSearchCategoryBySiteIdStartIndexEndIndexList]
	@siteId int,
	@startRowIndex int,
	@endRowIndex int
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH selectedCategory(id, row_id, site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category, is_displayed
		, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order)
	AS
	(
		SELECT category_id AS id, ROW_NUMBER() OVER (ORDER BY category_id) AS row_id, site_id, category_name
				, category_type_id, [description], short_name, specification, is_search_category, is_displayed
				, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE site_id = @siteId AND [enabled] = 1 AND category_type_id = 4 AND is_search_category = 0 AND hidden = 0
	)

	SELECT id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category, is_displayed
			, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM selectedCategory
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetNonSearchCategoryBySiteIdStartIndexEndIndexList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetOrphanedCategoryBySiteIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[AdminProduct_GetOrphanedCategoryBySiteIdList]    Script Date: 12/3/2018 11:17:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminProduct_GetOrphanedCategoryBySiteIdList]
	@siteId int
AS
-- ==========================================================================
-- $URL$
-- $Revision$
-- $Date$ 
-- $Author$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id AS site_id, cat.category_name AS category_name
			, cat.category_type_id AS category_type_id, description AS description, short_name AS short_name
			, cat.specification AS specification
			, cat.is_search_category AS is_search_category, is_displayed AS is_displayed
			, cat.[enabled] AS [enabled], cat.modified AS modified, cat.created AS created, cat.matrix_type, cat.product_count AS product_count 
			, cat.auto_generated AS auto_generated, cat.hidden AS hidden, cat.has_image AS has_image, cat.url_id AS url_id,cat.sort_order AS sort_order
	FROM category cat
			LEFT OUTER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id
	WHERE cat.category_type_id <> 1 AND cat.site_id = @siteId
	EXCEPT 
	SELECT cat.category_id AS id, cat.site_id AS site_id, cat.category_name AS category_name
			, cat.category_type_id AS category_type_id, [description] AS [description], short_name AS short_name
			, cat.specification AS specification
			, cat.is_search_category AS is_search_category, is_displayed AS is_displayed
			, cat.[enabled] AS [enabled], cat.modified AS modified, cat.created AS created, cat.matrix_type, cat.product_count AS product_count
			, cat.auto_generated AS auto_generated, cat.hidden AS hidden, cat.has_image AS has_image, cat.url_id AS url_id,cat.sort_order AS sort_order
	FROM category cat
			INNER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id
	WHERE cat.category_type_id <> 1 AND cat.site_id = @siteId

END

GO
GRANT EXECUTE ON dbo.AdminProduct_GetOrphanedCategoryBySiteIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.AdminProduct_GetOrphanedCategoryBySiteIdPageList'
GO


GO
/****** Object:  StoredProcedure [dbo].[AdminProduct_GetOrphanedCategoryBySiteIdPageList]    Script Date: 12/3/2018 12:01:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminProduct_GetOrphanedCategoryBySiteIdPageList]
	@siteId int,
	@startIndex int,
	@endIndex int,
	@categoryId int,
	@categoryName varchar(max),
	@totalCount int output
AS
-- ==========================================================================
-- $Author Yasodha Handehewa $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
		
		SELECT id, site_id, category_name, category_type_id,[description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY cat.category_id ASC) AS row, cat.category_id AS id, cat.site_id AS site_id
				, cat.category_name AS category_name
				, cat.category_type_id AS category_type_id, description AS description, short_name AS short_name
				, cat.specification AS specification
				, cat.is_search_category AS is_search_category, is_displayed AS is_displayed
				, cat.[enabled] AS [enabled], cat.modified AS modified, cat.created AS created, cat.matrix_type
				, cat.product_count AS product_count, cat.auto_generated AS auto_generated, cat.hidden AS hidden
				, cat.has_image AS has_image, cat.url_id AS url_id,cat.sort_order AS sort_order
			FROM category cat
				LEFT OUTER JOIN category_to_category_branch cb
					ON cat.category_id = cb.sub_category_id
			WHERE cat.category_type_id <> 1 AND
				cat.site_id = @siteId AND cb.category_id IS NULL AND (cat.category_id = @categoryId OR @categoryId = 0) AND (cat.category_name LIKE @categoryName OR @categoryName IS NULL OR @categoryName LIKE '')
		)AS OrphanCat
		WHERE row BETWEEN @startIndex AND @endIndex

		SELECT @totalCount = COUNT(*)
		FROM category cat
			LEFT OUTER JOIN category_to_category_branch cb
				ON cat.category_id = cb.sub_category_id 
		WHERE cat.category_type_id <> 1 AND
				cat.site_id = @siteId AND cb.category_id IS NULL AND (cat.category_id = @categoryId OR @categoryId = 0) AND (cat.category_name LIKE @categoryName OR @categoryName IS NULL OR @categoryName LIKE '')
			
			
END

GO
GRANT EXECUTE ON dbo.AdminProduct_GetOrphanedCategoryBySiteIdPageList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetParentCategoryHierarchyByLeafCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetParentCategoryHierarchyByLeafCategoryIdList]    Script Date: 12/3/2018 11:32:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetParentCategoryHierarchyByLeafCategoryIdList]
	@leafCategoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetParentCategoryHierarchyByLeafCategoryIdList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH topCategory_hierarchy(category_id, sub_category_id)AS
	(
		SELECT category_id, sub_category_id
		FROM category_to_category_branch
		WHERE sub_category_id = @leafCategoryId AND [enabled] = '1'

		UNION ALL

		SELECT cb.category_id, cb.sub_category_id
		FROM category_to_category_branch cb
				INNER JOIN topCategory_hierarchy ch
					ON cb.sub_category_id = ch.category_id
		WHERE cb.[enabled] = '1'
	)

	SELECT category_id AS id, site_id, category_name, category_type_id, [description], specification
		, enabled, modified, created, is_search_category
		, is_displayed, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
	WHERE category_id IN
	(
		SELECT category_id
		FROM topCategory_hierarchy
	)

END

GO
GRANT EXECUTE ON dbo.adminProduct_GetParentCategoryHierarchyByLeafCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetRecentlyModifiedIndexedCategories'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_GetRecentlyModifiedIndexedCategories]    Script Date: 12/3/2018 11:52:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_GetRecentlyModifiedIndexedCategories]
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) c.category_id AS id, ROW_NUMBER() OVER (ORDER BY category_id) AS row_id
		, c.site_id, c.category_name, c.category_type_id
		, c.[description], c.short_name, c.specification , c.is_search_category
		, c.is_displayed, c.enabled, c.modified, c.created
		, c.matrix_type, c.product_count, c.auto_generated, c.hidden, c.has_image, c.url_id,c.sort_order
	FROM category AS c
 		INNER JOIN search_content_status AS escs
			ON c.category_id = escs.content_id AND c.site_id = escs.site_id
	WHERE escs.modified < c.modified AND c.enabled = 1 AND escs.content_type_id = 1
	
END

GO
GRANT EXECUTE ON dbo.adminProduct_GetRecentlyModifiedIndexedCategories TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateCategory'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_UpdateCategory]    Script Date: 12/3/2018 10:41:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_UpdateCategory]
	@id int, 
	@siteId int,
	@categoryName varchar(255),
	@categoryTypeId int,
	@description varchar(max),
	@shortName varchar(50),
	@specification varchar(200),
	@isSearchCategory bit,
	@isDisplayed bit,
	@enabled bit,
	@modified smalldatetime output,
	@matrixType int,
	@productCount int,
	@autoGenerated bit,
	@hidden bit,
	@hasImage bit,
	@urlId INT,
	@sort_order INT
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_UpdateCategory.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE category 
	SET
		site_id = @siteId,
		category_name = @categoryName,
		category_type_id = @categoryTypeId,
		description = @description,
		short_name = @shortName,
		specification = @specification,
		is_search_category = @isSearchCategory,
		is_displayed = @isDisplayed,
		[enabled] = @enabled,
		modified = @modified,
		matrix_type = @matrixType,
		product_count = @productCount,
		auto_generated = @autoGenerated,
		hidden = @hidden,
		has_image = @hasImage,
		url_id = @urlId,
		sort_order = @sort_order
	WHERE category_id = @id

END

GO
GRANT EXECUTE ON dbo.adminProduct_UpdateCategory TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicCategory_GetCategoriesByProductIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicCategory_GetCategoriesByProductIdsList]    Script Date: 12/3/2018 11:57:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicCategory_GetCategoriesByProductIdsList]
	@productIds varchar(MAX)
AS
-- ==========================================================================
-- Author : Nilushi Hikkaduwa
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category 
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM category 
	WHERE [enabled] = 1 AND hidden = 0 AND category_id IN (
		SELECT DISTINCT category_id
		FROM product_to_category
		WHERE product_id IN (select value from global_Split(@productIds, ',')) AND [enabled] = 1
		GROUP BY category_id
		HAVING COUNT(product_id) = (select MAX(id) from global_Split(@productIds, ','))
	)
	
END

GO
GRANT EXECUTE ON dbo.publicCategory_GetCategoriesByProductIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicCategory_GetCategoryByArticleTypeIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicCategory_GetCategoryByArticleTypeIdList]    Script Date: 12/3/2018 11:22:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicCategory_GetCategoryByArticleTypeIdList]
	@siteId INT ,
	@articleTypeIds VARCHAR(MAX) ,
	@childCategoryIds VARCHAR(MAX) = '' ,
	@startIndex INT ,
	@endIndex INT ,
	@totalCount INT OUTPUT
AS -- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
	BEGIN
	
		SET NOCOUNT ON;
		DECLARE	@ChildCategoryFilterEnabled BIT
		SET @ChildCategoryFilterEnabled = 0

		IF ( LEN(@childCategoryIds) > 0 ) 
			BEGIN
				SET @ChildCategoryFilterEnabled = 1
			END;

		WITH	article_type_associated_category_list
				  AS ( SELECT	ROW_NUMBER() OVER ( ORDER BY category_id ) AS row ,
								category_id AS id ,
								site_id ,
								category_name ,
								category_type_id ,
								[description] ,
								short_name ,
								specification ,
								is_search_category ,
								is_displayed ,
								[enabled] ,
								modified ,
								created ,
								matrix_type ,
								product_count ,
								auto_generated ,
								hidden ,
								has_image ,
								url_id,
								sort_order
					   FROM		category
					   WHERE	EXISTS ( SELECT	associated_content_id ,
												[enabled] ,
												created ,
												modified ,
												site_id ,
												associated_site_id ,
												sort_order
										 FROM	content_to_content
										 WHERE	content_type_id = 4
												AND enabled = 1
												AND associated_content_id = category.category_id
												AND site_id = @siteId
												AND associated_content_type_id = 1
												AND content_id IN (
												SELECT	article_id
												FROM	article
												WHERE	site_id = @siteid
														AND enabled =  1
														AND published = 1
														AND article_type_id IN (
														SELECT
															  [value]
														FROM  Global_Split(@articleTypeIds,
															  ',') ) ) )
								AND enabled = 1
								AND ( @ChildCategoryFilterEnabled = 0
									  OR ( @ChildCategoryFilterEnabled = 1
										   AND category_id IN (
										   SELECT	[value]
										   FROM		Global_Split(@childCategoryIds,
															  ',') )
										 )
									)
					 )

			SELECT	*
			FROM	article_type_associated_category_list
			WHERE	( row BETWEEN @startIndex AND @endIndex )
					OR ( @startIndex = 0 )
			ORDER BY row

		SELECT	@totalCount = COUNT(*)
		FROM	category
		WHERE	EXISTS ( SELECT	associated_content_id ,
								[enabled] ,
								created ,
								modified ,
								site_id ,
								associated_site_id ,
								sort_order
						 FROM	content_to_content
						 WHERE	content_type_id = 4
								AND enabled = 1
								AND associated_content_id = category.category_id
								AND site_id = @siteId
								AND associated_content_type_id = 1
								AND content_id IN (
								SELECT	article_id
								FROM	article
								WHERE	site_id = @siteid
										AND enabled = 1
										AND published = 1
										AND article_type_id IN (
										SELECT	[value]
										FROM	Global_Split(@articleTypeIds,
												','))))
				AND enabled = 1
				AND ( @ChildCategoryFilterEnabled = 0
					  OR ( @ChildCategoryFilterEnabled = 1
						   AND category_id IN (
						   SELECT	[value]
						   FROM		Global_Split(@childCategoryIds, ',') )
						 )
					)
	END


GRANT EXECUTE ON dbo.publicCategory_GetCategoryByArticleTypeIdList TO VpWebApp 

GO
GRANT EXECUTE ON dbo.publicCategory_GetCategoryByArticleTypeIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicCategory_GetMaxCategoryByproductIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicCategory_GetMaxCategoryByproductIdsList]    Script Date: 12/3/2018 12:00:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[publicCategory_GetMaxCategoryByproductIdsList]
	@productIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	
	WITH product_category_ids (product_id, category_id) AS
	(
		SELECT proCat.product_id, MAX(proCat.category_id) AS category_id
		FROM  product_to_category proCat 
			INNER JOIN global_Split(@productIds, ',') AS product_id_table
				ON proCat.product_id = product_id_table.[value]
			INNER JOIN category cat
				ON cat.category_id = proCat.category_id
		WHERE cat.enabled = 1
		GROUP BY proCat.product_id
	)
		
	
	SELECT product_category_ids.product_id, cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
			, cat.description, cat.short_name, cat.specification, cat.is_search_category 
			, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id,cat.sort_order
	FROM category cat
	INNER JOIN product_category_ids
		ON product_category_ids.category_id = cat.category_id

END

GO
GRANT EXECUTE ON dbo.publicCategory_GetMaxCategoryByproductIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByCategoryIdsHavingProductsOrVendorsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryByCategoryIdsHavingProductsOrVendorsList]    Script Date: 12/3/2018 11:46:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryByCategoryIdsHavingProductsOrVendorsList]
	@categoryIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT temp_table.parent_category_id, category.category_id AS id, site_id, category_name, 
		category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM
	(
	SELECT category_id_table.[value] AS parent_category_id, category.category_id
	FROM category 
		INNER JOIN global_Split(@categoryIds, ',') category_id_table
			ON category.category_id = category_id_table.[value]	
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
		
	WHERE category.enabled = 1 AND category_to_category_branch.enabled = 1
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

	SELECT category_id_table.[value] AS parent_category_id, category.category_id
	FROM category
		INNER JOIN global_Split(@categoryIds, ',') category_id_table
			ON category.category_id = category_id_table.[value]	
		INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
		INNER JOIN category_to_vendor
			ON category.category_id = category_to_vendor.category_id
		INNER JOIN vendor
			ON category_to_vendor.vendor_id = vendor.vendor_id
	WHERE
		category.enabled = 1
		AND 
		category_to_category_branch.enabled = 1
		AND
		category.category_type_id = 4
		AND
		vendor.[enabled] = '1' AND category_to_vendor.[enabled] = '1'
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	ORDER BY category_name
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryByCategoryIdsHavingProductsOrVendorsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByParentCategoryIdIsSelectedList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryByParentCategoryIdIsSelectedList]    Script Date: 12/3/2018 11:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryByParentCategoryIdIsSelectedList]
	@categoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed
		, enabled, modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,category_sort_order AS sort_order
	FROM
	(
		SELECT category.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, 
			category.hidden, has_image, url_id,category.sort_order AS category_sort_order, category_to_category_branch.sort_order
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



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByParentCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryByParentCategoryIdList]    Script Date: 12/3/2018 11:02:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryByParentCategoryIdList]
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryByParentCategoryIdList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, description, short_name, specification
			, category.is_search_category, category.is_displayed, matrix_type, category.enabled, category.modified, category.created
			, category.product_count, category.auto_generated, category.hidden, category.has_image, category.url_id,category.sort_order
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category.hidden = 0

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryByParentCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBySiteIdCategoryTypeIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryBySiteIdCategoryTypeIdList]    Script Date: 12/3/2018 11:13:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryBySiteIdCategoryTypeIdList]
	@siteId int,
	@categoryTypeId int
AS
-- ==========================================================================
-- $URL$
-- $Revision$
-- $Date$ 
-- $Author$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_id AS id, site_id AS site_id, category_name AS category_name, category_type_id AS category_type_id
			, [description] AS [description], short_name AS short_name, specification AS specification
			, is_search_category AS is_search_category, is_displayed AS is_displayed, [enabled] AS enabled, modified AS modified
			, created AS created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
	WHERE site_id = @siteId AND category_type_id = @categoryTypeId
	ORDER BY category_name

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryBySiteIdCategoryTypeIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBySiteIdCategoryTypeIdPagingList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryBySiteIdCategoryTypeIdPagingList]    Script Date: 12/3/2018 11:55:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryBySiteIdCategoryTypeIdPagingList]
	@siteId int,
	@categoryTypeId int,
	@startIndex int,
	@endIndex int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_category(row, category_id, site_id, category_name, category_type_id, [description], short_name
		 , specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type
		 , product_count, auto_generated, hidden, has_image, url_id,sort_order) 
	AS	
	(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY category_name) AS row, 
			category_id, site_id, category_name, category_type_id, [description], short_name
			, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type
			, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE site_id = @siteId AND category_type_id = @categoryTypeId AND hidden = 0
	)

	SELECT category_id AS id, site_id AS site_id, category_name AS category_name, category_type_id AS category_type_id
			, [description] AS [description], short_name AS short_name, specification AS specification
			, is_search_category AS is_search_category, is_displayed AS is_displayed, [enabled] AS enabled, modified AS modified
			,created AS created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM temp_category
	WHERE (row BETWEEN @startIndex AND @endIndex)
	ORDER BY row

	SELECT @totalCount = COUNT(*)
	FROM category
	WHERE site_id = @siteId AND category_type_id = @categoryTypeId AND hidden = 0

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryBySiteIdCategoryTypeIdPagingList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBySiteIdTrunkList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryBySiteIdTrunkList]    Script Date: 12/3/2018 10:52:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryBySiteIdTrunkList]
	@siteId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryBySiteIdTrunkList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT id, site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
		, sort_order
	FROM
	(
		SELECT category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
			, CASE
				WHEN short_name IS NULL THEN category_name
				WHEN short_name = '' THEN category_name
				ELSE short_name
			END sort_name
		FROM category 
		WHERE site_id = @siteId AND category_type_id = 1
	) temp_table

	ORDER BY sort_name

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryBySiteIdTrunkList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBySiteIdTrunkPageList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryBySiteIdTrunkPageList]    Script Date: 12/3/2018 10:56:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryBySiteIdTrunkPageList]
	@siteId int,
	@pageSize int,
	@pageIndex int,
	@sortOrder varchar(50),
	@sortBy varchar(50),	
	@totalCount int out
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
		
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	
	WITH temp_category(row, rowDesc, modifiedRow, modifiedRowDesc, idRow, idRowDesc, nameRow, nameRowDesc, id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order) AS
	(
	
		SELECT ROW_NUMBER() OVER (ORDER BY created) AS row, 
			ROW_NUMBER() OVER (ORDER BY created DESC) AS rowDesc,
			ROW_NUMBER() OVER (ORDER BY modified) AS modifiedRow, 
			ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedRowDesc,
			ROW_NUMBER() OVER (ORDER BY category_id) AS idRow, 
			ROW_NUMBER() OVER (ORDER BY category_id DESC) AS idRowDesc,
			ROW_NUMBER() OVER (ORDER BY [category_name]) AS nameRow, 
			ROW_NUMBER() OVER (ORDER BY [category_name] DESC) AS nameRowDesc,
			category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category 
		WHERE site_id = @siteId AND category_type_id = 1
	)

	
	SELECT id, site_id, category_name, category_type_id, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM temp_category
	WHERE (@sortBy = 'created' AND @sortOrder = 'asc' AND row BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'created' AND @sortOrder = 'desc' AND rowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'id' AND @sortOrder = 'asc' AND idRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR
	  (@sortBy = 'name' AND @sortOrder = 'asc' AND nameRow BETWEEN @startIndex AND @endIndex) OR 
	  (@sortBy = 'name' AND @sortOrder = 'desc' AND nameRowDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
			CASE 
				WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN row 
				WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN rowDesc
				WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedRow 
				WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedRowDesc
				WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idRow 
				WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idRowDesc
				WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameRow 
				WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameRowDesc
			END
			
	SELECT @totalCount = COUNT(*)
	FROM category 
	WHERE site_id = @siteId AND category_type_id = 1

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryBySiteIdTrunkPageList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBySiteIdTypeList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryBySiteIdTypeList]    Script Date: 12/3/2018 11:22:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryBySiteIdTypeList]
	@siteId int,
	@categoryTypeId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryBySiteIdTypeList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_id AS id, site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
	WHERE site_id = @siteId AND category_type_id = @categoryTypeId
	ORDER BY category_name

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryBySiteIdTypeList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBySiteIdTypeWithManualCategoryIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryBySiteIdTypeWithManualCategoryIdsList]    Script Date: 12/3/2018 11:49:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryBySiteIdTypeWithManualCategoryIdsList]
	@siteId int,
	@categoryTypeId int,
	@manualCategoryIds varchar(max)
	
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- $Changes : 2018-11-28	Chinthaka	"Added Sorting Index"
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_id AS id, site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id, sort_order
	FROM
	(
		SELECT category_id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id, sort_order
		FROM category
		WHERE site_id = @siteId AND category_type_id = @categoryTypeId
		
		UNION
		
		SELECT category_id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id, sort_order
		FROM category 
		WHERE category.category_id IN (SELECT [value] FROM global_Split(@manualCategoryIds, '|')) AND  category.[enabled] = 1
	) AS category_union
	WHERE hidden = 0
	ORDER BY sort_order,category_name
	
	

END



GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryBySiteIdTypeWithManualCategoryIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByVendorIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryByVendorIdList]    Script Date: 12/3/2018 11:21:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryByVendorIdList]
    @vendorId int
	WITH RECOMPILE
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
      
	SET NOCOUNT ON;

	CREATE TABLE #category_ids (category_id int)

	INSERT INTO #category_ids (category_id)
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

      INSERT INTO #category_ids (category_id)
      SELECT category_id 
      FROM
      (
          SELECT c.category_id    
		  FROM category c
				INNER JOIN category_to_vendor cv
					  ON c.category_id = cv.category_id
		  WHERE cv.vendor_id = @vendorId 
				AND c.[enabled] = 1
				AND cv.[enabled] = 1
				AND c.hidden = 0  
      ) category_ids
      WHERE category_id NOT IN (SELECT category_id FROM #category_ids)

      SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], specification
                  , [enabled], modified, created, is_search_category, is_displayed
                  , short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
      FROM #category_ids
            INNER JOIN category
                  ON #category_ids.category_id = category.category_id
      ORDER BY category_name

      DROP TABLE #category_ids

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryByVendorIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByVendorIdProductExistanceList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryByVendorIdProductExistanceList]    Script Date: 12/3/2018 11:31:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryByVendorIdProductExistanceList]
	@vendorId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryByVendorIdProductExistanceList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT category.category_id AS id, category.site_id, category_name, category_type_id, [description], specification
		, category.enabled, category.modified, category.created, is_search_category
		, is_displayed, short_name, matrix_type, product_count, auto_generated, category.hidden, category.has_image, category.url_id,category.sort_order
	FROM category
		INNER JOIN product_to_category
			ON category.category_id = product_to_category.category_id
		INNER JOIN product_to_vendor
			ON product_to_category.product_id = product_to_vendor.product_id
		INNER JOIN product
			ON product_to_category.product_id = product.product_id
	WHERE product_to_vendor.vendor_id = @vendorId AND product.enabled = '1' AND category.enabled = '1'
		AND product_to_category.enabled = 1 AND category.hidden = 0

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryByVendorIdProductExistanceList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryDetail'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryDetail]    Script Date: 12/3/2018 10:43:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryDetail]
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryDetail.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- $Changes : 2018-11-28	Chinthaka	"Added Sorting Order Index"
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_id AS id, site_id, category_name, category_type_id, [description], short_name
			, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id, sort_order
	FROM category
	WHERE category_id = @id

END


GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryDetail TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryHavingProductsList]    Script Date: 12/3/2018 11:07:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryHavingProductsList]
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryHavingProductsList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id,category.sort_order
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
		AND category.hidden = 0
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
	ORDER BY category_name
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsOrVendorsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryHavingProductsOrVendorsList]    Script Date: 12/3/2018 11:08:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryHavingProductsOrVendorsList]
	@categoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id,category.sort_order AS sort_order
	FROM
	(
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category 
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = 1
			AND category_to_category_branch.hidden = 0 AND category.hidden = 0
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
			category_to_category_branch.enabled = 1 AND category_to_category_branch.hidden = 0 AND
			category.category_type_id = 4 AND category.hidden = 0 AND
			vendor.[enabled] = 1 AND category_to_vendor.[enabled] = 1
			
		UNION
		
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN fixed_guided_browse
				ON category.category_id = fixed_guided_browse.category_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = 1 AND category_to_category_branch.hidden = 0 AND
			category.category_type_id = 4 AND category.hidden = 0 AND fixed_guided_browse.[enabled] = 1
			
		UNION
		
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN category_parameter
				ON category.category_id = category_parameter.category_id AND category_parameter.parameter_type_id = 143
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = 1 AND category_to_category_branch.hidden = 0 AND
			category.category_type_id = 4 AND category.hidden = 0 AND category_parameter.category_parameter_value IS NOT NULL
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	ORDER BY temp_table.sort_order ASC, category_name ASC
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsOrVendorsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsSortedByDisplayNameList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetCategoryHavingProductsSortedByDisplayNameList]    Script Date: 12/3/2018 11:09:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetCategoryHavingProductsSortedByDisplayNameList]
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryHavingProductsSortedByDisplayNameList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;


	SELECT id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed, [enabled]
		, modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM
	(
		SELECT category.category_id AS id, site_id, category_name, category_type_id, [description]
			, short_name, specification, is_search_category, is_displayed
			, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id,category.sort_order
			, CASE
					WHEN category_to_category_branch.display_name IS NULL THEN category_name
					WHEN category_to_category_branch.display_name = '' THEN category_name
					ELSE category_to_category_branch.display_name
				END sort_name
		FROM category 
	 		INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
			AND category.hidden = 0
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
	) temp_table
	ORDER BY sort_name
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsSortedByDisplayNameList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildCategoriesByCategoryIdProductExistenceSortedByDisplayNameWithManualCategoryIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetChildCategoriesByCategoryIdProductExistenceSortedByDisplayNameWithManualCategoryIdsList]    Script Date: 12/3/2018 11:50:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetChildCategoriesByCategoryIdProductExistenceSortedByDisplayNameWithManualCategoryIdsList]
	@categoryId int,
	@manualCategoryIds varchar(max)
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;


	SELECT id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed, [enabled]
		, modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM
	(
		SELECT category.category_id AS id, site_id, category_name, category_type_id, [description]
			, short_name, specification, is_search_category, is_displayed
			, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id,category.sort_order
			, CASE
					WHEN category_to_category_branch.display_name IS NULL THEN category_name
					WHEN category_to_category_branch.display_name = '' THEN category_name
					ELSE category_to_category_branch.display_name
				END sort_name
		FROM category 
	 		INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
			AND category_to_category_branch.hidden = '0'
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
		
		SELECT category.category_id AS id, site_id, category_name, category_type_id, [description]
			, short_name, specification, is_search_category, is_displayed
			, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id,category.sort_order
			, CASE
					WHEN category_to_category_branch.display_name IS NULL THEN category_name
					WHEN category_to_category_branch.display_name = '' THEN category_name
					ELSE category_to_category_branch.display_name
				END sort_name
		FROM category 
	 		LEFT OUTER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category.category_id IN (SELECT [value] FROM global_Split(@manualCategoryIds, '|')) AND  category.[enabled] = 1
	) temp_table
	WHERE hidden = 0
	ORDER BY sort_name
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetChildCategoriesByCategoryIdProductExistenceSortedByDisplayNameWithManualCategoryIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildCategoriesByCategoryIdProductOrVendorExistenceWithCategoryIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetChildCategoriesByCategoryIdProductOrVendorExistenceWithCategoryIdsList]    Script Date: 12/3/2018 11:51:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetChildCategoriesByCategoryIdProductOrVendorExistenceWithCategoryIdsList]
	@categoryId int,
	@manualCategoryIds varchar(max)
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM
	(
	SELECT category.category_id
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
		AND category_to_category_branch.hidden = '0'
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

	SELECT category.category_id
	FROM category
		INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
		INNER JOIN category_to_vendor
			ON category.category_id = category_to_vendor.category_id
		INNER JOIN vendor
			ON category_to_vendor.vendor_id = vendor.vendor_id
	WHERE 
		category_to_category_branch.category_id = @categoryId 
		AND 
		category_to_category_branch.enabled = '1'
		AND 
		category_to_category_branch.hidden = '0'
		AND
		category.category_type_id = 4
		AND
		vendor.[enabled] = '1' AND category_to_vendor.[enabled] = '1'

	UNION
	
	SELECT category_id
	FROM category 
	WHERE category.category_id IN (SELECT [value] FROM global_Split(@manualCategoryIds, '|')) AND category.[enabled] = 1
	
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	WHERE hidden = 0
	ORDER BY category_name
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetChildCategoriesByCategoryIdProductOrVendorExistenceWithCategoryIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetDisabledParentCategoryByCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetDisabledParentCategoryByCategoryIdList]    Script Date: 12/3/2018 11:42:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetDisabledParentCategoryByCategoryIdList] 
	@categoryId int  
AS  
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

SET NOCOUNT ON;

	WITH category_hierarchy (category_id, sub_category_id) AS
	(
		SELECT category_id, sub_category_id 
		FROM category_to_category_branch
		WHERE sub_category_id = @categoryId AND category_to_category_branch.enabled = 1

		UNION ALL 

		SELECT cb.category_id, cb.sub_category_id 
		FROM category_to_category_branch cb
			INNER JOIN category_hierarchy ch 
				ON cb.sub_category_id = ch.category_id
		WHERE cb.enabled = 1
	)

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name
			, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
			INNER JOIN category_hierarchy
				ON category.category_Id = category_hierarchy.category_Id
	WHERE [enabled] = 0
	
END  

GO
GRANT EXECUTE ON dbo.publicProduct_GetDisabledParentCategoryByCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetEnabledParentCategoryByCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetEnabledParentCategoryByCategoryIdList]    Script Date: 12/3/2018 11:44:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetEnabledParentCategoryByCategoryIdList]
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetEnabledParentCategoryByCategoryIdList.sql $
-- $Revision: 8243 $
-- $Date: 2011-01-04 13:50:45 +0530 (Tue, 04 Jan 2011) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN

SET NOCOUNT ON;

	WITH category_hierarchy (category_id, sub_category_id) AS
	(
		SELECT category_id, sub_category_id 
		FROM category_to_category_branch
		WHERE sub_category_id = @categoryId AND  category_to_category_branch.enabled = '1'

		UNION ALL 

		SELECT cb.category_id, cb.sub_category_id 
		FROM category_to_category_branch cb
			INNER JOIN category_hierarchy ch 
				ON cb.sub_category_id = ch.category_id
		WHERE cb.enabled = '1'
	)

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name
			, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
			INNER JOIN category_hierarchy
				ON category.category_Id = category_hierarchy.category_Id
	WHERE category.enabled = '1' AND category.hidden = 0
	
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetEnabledParentCategoryByCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetLeafCategoryByCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetLeafCategoryByCategoryIdList]    Script Date: 12/3/2018 11:43:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetLeafCategoryByCategoryIdList]
	@categoryId int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

SET NOCOUNT ON;

	WITH category_hierarchy (category_id, sub_category_id) AS
	(
		SELECT category_id, sub_category_id 
		FROM category_to_category_branch
		WHERE category_id = @categoryId AND category_to_category_branch.enabled = 1

		UNION ALL 

		SELECT cb.category_id, cb.sub_category_id 
		FROM category_to_category_branch cb
			INNER JOIN category_hierarchy ch 
				ON cb.category_id = ch.sub_category_id
		WHERE cb.enabled = 1
	)

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name
			, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
			INNER JOIN category_hierarchy
				ON category.category_Id = category_hierarchy.sub_category_id
	WHERE category_type_id = 4 AND hidden = 0
	
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetLeafCategoryByCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetParentCategoryByCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetParentCategoryByCategoryIdList]    Script Date: 12/3/2018 11:41:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetParentCategoryByCategoryIdList]
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetParentCategoryByCategoryIdList.sql $
-- $Revision: 8243 $
-- $Date: 2011-01-04 13:50:45 +0530 (Tue, 04 Jan 2011) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN

SET NOCOUNT ON;

	WITH category_hierarchy (category_id, sub_category_id) AS
	(
		SELECT category_id, sub_category_id 
		FROM category_to_category_branch
		WHERE sub_category_id = @categoryId AND category_to_category_branch.enabled = '1'

		UNION ALL 

		SELECT cb.category_id, cb.sub_category_id 
		FROM category_to_category_branch cb
			INNER JOIN category_hierarchy ch 
				ON cb.sub_category_id = ch.category_id
		WHERE cb.enabled = '1'
	)

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name
			, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
			INNER JOIN category_hierarchy
				ON category.category_Id = category_hierarchy.category_Id 
	WHERE category.hidden = 0			
	
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetParentCategoryByCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetRandomizedCategoriesByParentCategoryId'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetRandomizedCategoriesByParentCategoryId]    Script Date: 12/3/2018 12:04:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetRandomizedCategoriesByParentCategoryId]
	@categoryId int,
	@noOfCategories int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@noOfCategories) category.category_id AS id, site_id, category_name, category_type_id, description, short_name, specification
			, category.is_search_category, category.is_displayed, matrix_type, category.enabled, category.modified, category.created
			, category.product_count, category.auto_generated, category.hidden, category.has_image, category.url_id,category.sort_order
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category.hidden = 0
	ORDER BY NEWID()

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetRandomizedCategoriesByParentCategoryId TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSubCategoryByCategoryIdList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetSubCategoryByCategoryIdList]    Script Date: 12/3/2018 11:43:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetSubCategoryByCategoryIdList]
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetSubCategoryByCategoryIdList.sql $
-- $Revision: 8243 $
-- $Date: 2011-01-04 13:50:45 +0530 (Tue, 04 Jan 2011) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN

SET NOCOUNT ON;

	WITH category_hierarchy (category_id, sub_category_id) AS
	(
		SELECT category_id, sub_category_id 
		FROM category_to_category_branch
		WHERE category_id = @categoryId AND category_to_category_branch.enabled = '1'

		UNION ALL 

		SELECT cb.category_id, cb.sub_category_id 
		FROM category_to_category_branch cb
			INNER JOIN category_hierarchy ch 
				ON cb.category_id = ch.sub_category_id
		WHERE cb.enabled = '1'
	)

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name
			, specification, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count
			, auto_generated, hidden, has_image, url_id,sort_order
	FROM category
			INNER JOIN category_hierarchy
				ON category.category_Id = category_hierarchy.sub_category_id
	AND category.hidden = 0
	
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetSubCategoryByCategoryIdList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetTrunkCategoriesBySiteIdManualCategoryIdsList'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetTrunkCategoriesBySiteIdManualCategoryIdsList]    Script Date: 12/3/2018 11:48:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetTrunkCategoriesBySiteIdManualCategoryIdsList]
	@siteId int,
	@manualCategoryIds varchar(max)
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT id, site_id, category_name, category_type_id
		, [description], short_name, specification, is_search_category
		, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
	FROM
	(
		SELECT category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
			, CASE
				WHEN short_name IS NULL THEN category_name
				WHEN short_name = '' THEN category_name
				ELSE short_name
			END sort_name
		FROM category 
		WHERE site_id = @siteId AND category_type_id = 1

		UNION
	
		SELECT category_id AS id, site_id, category_name, category_type_id, description
				, short_name, specification, is_search_category, is_displayed
				, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden,has_image,url_id,sort_order,
				CASE
					WHEN short_name IS NULL THEN category_name
					WHEN short_name = '' THEN category_name
					ELSE short_name
				END sort_name
		FROM category 
		WHERE category.category_id IN (SELECT [value] FROM global_Split(@manualCategoryIds, '|')) AND  category.[enabled] = 1
	) temp_table
	
	WHERE hidden = 0

	ORDER BY sort_name
	
	

END

GO
GRANT EXECUTE ON dbo.publicProduct_GetTrunkCategoriesBySiteIdManualCategoryIdsList TO VpWebApp
GO



GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetTrunkCategoryByCategoryIdDetail'
GO


GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetTrunkCategoryByCategoryIdDetail]    Script Date: 12/3/2018 11:20:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicProduct_GetTrunkCategoryByCategoryIdDetail]
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetTrunkCategoryByCategoryIdDetail.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF ((SELECT category_type_id
		FROM category
		WHERE category_id = @categoryId) = 1)
	BEGIN
		SELECT category_id AS id, site_id, category_name, category_type_id, [description]
			, specification, [enabled], modified, created, is_search_category
			, is_displayed, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE category_id = @categoryId
	END

	ELSE
	BEGIN

	WITH category_hierarchy (category_id, sub_category_id, category_type_id) AS
		(
			SELECT category_to_category_branch.category_id, category_to_category_branch.sub_category_id 
				, category.category_type_id
			FROM category_to_category_branch
				INNER JOIN category
					ON category_to_category_branch.category_id = category.category_id
			WHERE category_to_category_branch.sub_category_id = @categoryId

			UNION ALL 

			SELECT cb.category_id, cb.sub_category_id, category.category_type_id
			FROM category_to_category_branch cb
				INNER JOIN category_hierarchy ch
					ON cb.sub_category_id = ch.category_id
				INNER JOIN category
					ON category.category_id = cb.category_id
			WHERE category.enabled = '1'
		)

		SELECT category_id AS id, site_id, category_name, category_type_id, [description]
			, specification, [enabled], modified, created, is_search_category
			, is_displayed, short_name, matrix_type, product_count, auto_generated, hidden, has_image, url_id,sort_order
		FROM category
		WHERE category_id = 
			(SELECT TOP 1 category_id 
			FROM category_hierarchy
			WHERE category_type_id = 1) AND hidden = 0
	END
 
END

GO
GRANT EXECUTE ON dbo.publicProduct_GetTrunkCategoryByCategoryIdDetail TO VpWebApp
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_ReorderCategory'

GO

/****** Object:  StoredProcedure [dbo].[adminProduct_ReorderCategory]    Script Date: 11/28/2018 4:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_ReorderCategory]
	@categoryId int, 
	@sortOrder int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE	@siteId INT

		SELECT	@siteId = site_id
	FROM	dbo.category
	WHERE	category_id = @categoryId

	--if sort_order = 0 then asign last sort_order+1 
	IF (@sortOrder = 0)
	BEGIN	
		SELECT @sortOrder = ISNULL(MAX(sort_order),0)+1
		FROM	dbo.category
		WHERE	site_id = @siteId
		
		--updating last category index
		UPDATE dbo.category
		SET sort_order = @sortOrder
		WHERE category_id = @categoryId
	END	

	--shifting all greater indexes by +1
	UPDATE dbo.category
	SET	sort_order = (CASE WHEN category_id = @categoryId THEN @sortOrder ELSE sort_order+1 END)
	WHERE	category_type_id = 1 --only trunk level categories affected
			AND	[sort_order] >= @sortOrder
			AND	site_id = @siteId

END


GO
GRANT EXECUTE ON dbo.adminProduct_ReorderCategory TO VpWebApp
GO

--------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories
	@categoryId int,
	@associateSearchCategoryId int
AS
-- ==========================================================================
-- $ Author : Akila Tharuka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT

	SELECT @optionsCount = COUNT(*)
	FROM category_to_search_option ctso
	WHERE ctso.category_id = @categoryId

	SELECT p.product_id
	INTO #tmpProducts
	FROM product p
	INNER JOIN product_to_search_option ptso
		ON ptso.product_id = p.product_id
	INNER JOIN category_to_search_option ctso
		ON ctso.search_option_id = ptso.search_option_id
	INNER JOIN product_to_category ptc
		ON ptc.product_id = p.product_id
	WHERE ctso.category_id = @categoryId
		AND p.enabled = 1
		AND ptc.category_id = @associateSearchCategoryId
	GROUP BY p.product_id
	HAVING COUNT(ptso.product_id) = @optionsCount

	INSERT INTO product_to_category (category_id, product_id, [enabled], modified, created)
	SELECT @categoryId, product_id, 1, GETDATE(), GETDATE()
	FROM #tmpProducts
	WHERE product_id NOT IN (
		SELECT product_id
		FROM product_to_category ptc
		WHERE ptc.category_id = @categoryId
		)

	DELETE
	FROM product_to_category
	WHERE category_id = @categoryId
		AND product_id NOT IN (
			SELECT p.product_id
			FROM product p
			INNER JOIN product_to_search_option ptso
				ON ptso.product_id = p.product_id
			INNER JOIN category_to_search_option ctso
				ON ctso.search_option_id = ptso.search_option_id
			INNER JOIN product_to_category ptc
		        ON ptc.product_id = p.product_id
			WHERE ctso.category_id = @categoryId
				AND p.enabled = 1
				AND ptc.category_id = @associateSearchCategoryId
			GROUP BY p.product_id
			HAVING COUNT(ptso.product_id) = @optionsCount
		)
		
	DROP TABLE #tmpProducts
END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp 
GO
------------------------------------------------------------------------------------------------


