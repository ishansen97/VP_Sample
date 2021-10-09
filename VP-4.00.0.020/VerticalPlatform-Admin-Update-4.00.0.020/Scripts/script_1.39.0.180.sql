IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'filter_search_options' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
	ALTER TABLE category_to_search_group
	ADD filter_search_options BIT
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'filter_search_options' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
	UPDATE category_to_search_group SET filter_search_options = 0 WHERE filter_search_options IS NULL
	
	ALTER TABLE category_to_search_group
	ALTER COLUMN filter_search_options BIT NOT NULL
END
GO
----------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddCategorySearchGroup
	@id int output,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@enabled bit,	
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@includeAllOptions bit,
	@expandOnLoad bit,
	@filterSearchOptions bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_to_search_group ([category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [enabled], [include_all_options], expand_on_load, [modified], [created], [filter_search_options])
	VALUES (@categoryId, @searchGroupId, @sortOrder, @searchable,
		@matrixPrefix, @matrixSuffix, @enabled, @includeAllOptions, @expandOnLoad, @created, @created, @filterSearchOptions)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchGroup TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], expand_on_load, [created], [enabled], [modified], [include_all_options],
		[filter_search_options]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateCategorySearchGroup
	@id int,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@enabled bit,	
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@includeAllOptions bit,
	@expandOnLoad bit,
	@filterSearchOptions bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE [category_to_search_group]
	SET
		[category_id] = @categoryId,
		[search_group_id] = @searchGroupId,
		[sort_order] = @sortOrder,
		[searchable] = @searchable,
		[matrix_prefix] = @matrixPrefix,
		[matrix_suffix] = @matrixSuffix,
		[enabled] = @enabled,
		[modified] = @modified,
		[include_all_options] = @includeAllOptions,
		expand_on_load = @expandOnLoad,	
		[filter_search_options] = @filterSearchOptions
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchGroup TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList
	@categoryId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [include_all_options], expand_on_load, [created], [enabled], [modified],
		[filter_search_options]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp 
GO

------------------------------------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[product_display_status]') 
         AND name = 'include')
BEGIN
	ALTER TABLE [dbo].product_display_status ADD include bit NOT NULL DEFAULT 1
END

------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int,
	@rowCount INT OUTPUT
	
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	UPDATE TOP(@batchSize) p
	SET p.[rank] = CASE WHEN pds.new_rank IS NULL THEN p.default_rank ELSE pds.new_rank END,
		p.search_rank = CASE WHEN pds.search_rank = 0 THEN p.default_search_rank ELSE pds.search_rank END,
		p.search_content_modified = 1,
		p.modified = GETDATE()
	FROM [product_display_status] pds
		INNER JOIN product p
			ON p.product_id = pds.product_id
	WHERE p.site_id = @siteId 
		AND pds.[include] = 1
		AND @today BETWEEN pds.start_date AND pds.end_date
		AND (
				( pds.new_rank IS NULL AND  p.search_rank <> pds.search_rank) 
				OR ( pds.new_rank IS NULL AND  p.[rank] <> p.default_rank) 
				OR ( pds.search_rank = 0  AND p.search_rank <> p.default_search_rank) 
				OR ( pds.search_rank = 0  AND  p.[rank] <> pds.new_rank ) 
				OR ( pds.new_rank IS NOT NULL AND pds.search_rank <> 0 AND ( p.rank <> pds.new_rank OR p.search_rank <> pds.search_rank))
			)

	SELECT @rowCount = @@ROWCOUNT
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateDisplayStatusProductsBySiteId TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId
	@siteId int,
	@batchSize int,
	@rowCount INT OUTPUT
	
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	UPDATE TOP(@batchSize) p
	SET p.rank = p.default_rank,
		p.search_rank = p.default_search_rank,
		p.search_content_modified = 1,
		p.modified = GETDATE()
	FROM product p
	WHERE p.product_id IN (
		SELECT DISTINCT p.product_id
		FROM product p
			INNER JOIN [product_display_status] pds
			ON pds.product_id = p.product_id
		WHERE p.site_id = @siteId
			AND pds.[include] = 1
			AND (NOT (@today BETWEEN pds.[start_date] AND pds.end_date))
			AND (p.rank <> p.default_rank OR p.search_rank <> p.default_search_rank)
	)
		
	SELECT @rowCount = @@ROWCOUNT
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductDisplayIncludeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductDisplayIncludeList
	@timeInterval int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime

	SET @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	UPDATE pds
	SET [include] = 0,
		modified = GETDATE()
	FROM product_display_status pds
	WHERE [include] = 1
		AND (end_date <= DATEADD(DAY, -@timeInterval, @today)
			OR end_date >= DATEADD(DAY, @timeInterval, @today))
		
	UPDATE pds
	SET [include] = 1,
		modified = GETDATE()
	FROM product_display_status pds
	WHERE [include] = 0
		AND ([start_date] BETWEEN DATEADD(DAY, -@timeInterval, @today) AND DATEADD(DAY, @timeInterval, @today)
			OR end_date BETWEEN DATEADD(DAY, -@timeInterval, @today) AND DATEADD(DAY, @timeInterval, @today))
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductDisplayIncludeList TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------