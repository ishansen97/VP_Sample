IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'is_clean' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD is_clean BIT NOT NULL DEFAULT(0)
END
GO
---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId
	@searchCategoryId int,
	@searchOptionsIds varchar(max),
	@optionCount int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SELECT product_id,search_option_id
	INTO #product_options
	FROM product_to_search_option
	WHERE search_option_id IN (
		SELECT value 
		FROM dbo.global_Split(@searchOptionsIds, ',') 
	)
	GROUP BY product_id,search_option_id
	
	SELECT @totalCount = COUNT(prods.product_id)
	FROM
	(
		SELECT ptso.product_id, COUNT(ptso.product_id) AS opt_count
		FROM #product_options ptso				
			INNER JOIN product_to_category pc
				ON pc.product_id = ptso.product_id AND pc.category_id = @searchCategoryId				
		GROUP BY ptso.product_id
		HAVING  COUNT(ptso.product_id) = @optionCount
	) prods
	INNER JOIN product p
		ON p.product_id = prods.product_id AND p.enabled = 1
		
	DROP TABLE #product_options
END
GO

GRANT EXECUTE ON dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------

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
	@isClean bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, [name],  segment_size, [enabled],
	prefix_text, suffix_text, naming_rule, created, modified, build_option_list, is_dynamic, is_clean)
	VALUES (@categoryId, @name, @segmentSize, @enabled,
	@prefixText, @suffixText, @namingRule, @created, @created, @buildOptionList, @isDynamic, @isClean)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowse TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowse
	@id int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, is_clean
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList
	@categoryId int

AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, is_clean
	FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, is_clean
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
-----------------------------------------------------------------------
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
	@isClean bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
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
		is_clean = @isClean
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowse TO VpWebApp 
GO
----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllFixedGuidedBrowses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllFixedGuidedBrowses
	
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
	suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, is_clean
	FROM fixed_guided_browse
	WHERE [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllFixedGuidedBrowses TO VpWebApp 
GO
