IF NOT EXISTS(SELECT * FROM sys.columns WHERE [name] = N'include_in_sitemap' AND Object_ID = Object_ID(N'guided_browse'))
BEGIN
	ALTER TABLE guided_browse ADD include_in_sitemap bit NOT NULL DEFAULT 1
END

GO

----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_DeleteCampaignContentOfTemplateList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_DeleteCampaignContentOfTemplateList
	@templateId int,
	@contentType int
AS
-- ==========================================================================
-- Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM campaign_content
	WHERE content_type_id = @contentType AND email_template_id = @templateId

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_DeleteCampaignContentOfTemplateList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
IF NOT EXISTS 
(
SELECT [name] FROM syscolumns where [name] = 'display_name' AND id = 
(SELECT object_id FROM sys.objects 
WHERE object_id = OBJECT_ID(N'category_to_specification_type') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [category_to_specification_type]
	ADD [display_name] varchar(255) null
END
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddCategorySpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddCategorySpecificationType
	@categoryId int,
	@specificationTypeId int,
	@sortOrder int,
	@showInMatrix bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@specDisplayLength int,
	@displayName varchar(255)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO  category_to_specification_type (category_id, spec_type_id, sort_order,	[enabled], modified, created, show_in_matrix, spec_display_length, display_name) 
	VALUES (@categoryId, @specificationTypeId, @sortOrder, @enabled, @created, @created, @showInMatrix, @specDisplayLength, @displayName)
	
	SET @id = SCOPE_IDENTITY() 

END
GO
GRANT EXECUTE ON dbo.adminProduct_AddCategorySpecificationType TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategorySpecificationTypeDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategorySpecificationTypeDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

	SELECT category_to_specification_type_id AS id, category_id, spec_type_id
			, sort_order, show_in_matrix, [enabled], modified, created, spec_display_length, display_name
	FROM category_to_specification_type
	WHERE category_to_specification_type_id = @id

END
GO

GRANT EXECUTE ON publicProduct_GetCategorySpecificationTypeDetail TO VpWebApp
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateCategorySpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateCategorySpecificationType
	@id int,
	@categoryId int,
	@specificationTypeId int,
	@sortOrder int,
	@showInMatrix bit,
	@enabled bit,
	@modified smalldatetime output,
	@specDisplayLength int,
	@displayName varchar(255)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE category_to_specification_type
	SET
		category_id = @categoryId,
		spec_type_id = @specificationTypeId,
		sort_order = @sortOrder,
		show_in_matrix = @showInMatrix,
		[enabled] = @enabled,
		modified = @modified,
		spec_display_length = @specDisplayLength,
		display_name = @displayName
	WHERE category_to_specification_type_id = @id

END
GO

GRANT EXECUTE ON adminProduct_UpdateCategorySpecificationType TO VpWebApp
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategorySpecificationTypeByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategorySpecificationTypeByCategoryIdList
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
	SET NOCOUNT ON;
	
	SELECT category_to_specification_type_id AS id, category_id, spec_type_id, sort_order
			, [enabled], modified, created, show_in_matrix, spec_display_length, display_name
	FROM category_to_specification_type
	WHERE category_id = @id
	ORDER BY sort_order

END
GO
GRANT EXECUTE ON dbo.publicProduct_GetCategorySpecificationTypeByCategoryIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategorySpecificationTypeByCategoryIdSpecTypeId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategorySpecificationTypeByCategoryIdSpecTypeId
	@categoryId int,
	@specTypeId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_specification_type_id AS id, category_id AS category_id, spec_type_id AS spec_type_id,
			sort_order AS sort_order, [enabled] AS [enabled], modified AS modified, created AS created, show_in_matrix AS show_in_matrix,
			spec_display_length, display_name AS display_name
	FROM category_to_specification_type
	WHERE category_id = @categoryId AND spec_type_id = @specTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategorySpecificationTypeByCategoryIdSpecTypeId TO VpWebApp 
GO
----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddGuidedBrowse
	@id int output,
	@categoryId int,
	@name varchar(200),
	@prefix varchar(200),
	@suffix varchar(200),
	@namingRule varchar(500),
	@pageSize int,
	@sortOrder int,
	@startingMethod int,
	@includeInSitemap bit,
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO guided_browse(category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method, include_in_sitemap, [enabled], created, modified)
	VALUES (@categoryId, @name, @prefix, @suffix, @namingRule, @pageSize, @sortOrder, @startingMethod, @includeInSitemap, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddGuidedBrowse TO VpWebApp 
GO

------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowsesBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowsesBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT guided_browse_id AS id, category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method, include_in_sitemap, [enabled], created, modified
	FROM guided_browse
	WHERE category_id IN
	(
		SELECT category_id
		FROM category
		WHERE site_id = @siteId
	)
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowsesBySiteIdList TO VpWebApp 
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowsesByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowsesByCategoryIdList
	@categoryId int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT guided_browse_id AS id, category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method, include_in_sitemap, [enabled], created, modified
	FROM guided_browse
	WHERE category_id = @categoryId
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowsesByCategoryIdList TO VpWebApp 
GO

--------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateGuidedBrowse
	@id int,
	@categoryId int,
	@name varchar(200),
	@prefix varchar(200),
	@suffix varchar(200),
	@namingRule varchar(500),
	@pageSize int,
	@sortOrder int,
	@startingMethod int,
	@includeInSitemap bit,
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE guided_browse
	SET
		category_id = @categoryId,
		[name] = @name,
		prefix_text = @prefix,
		suffix_text = @suffix,
		naming_rule = @namingRule,
		page_size = @pageSize,
		sort_order = @sortOrder,
		starting_method = @startingMethod,
		include_in_sitemap = @includeInSitemap,
		enabled = @enabled,
		modified = @modified
	WHERE guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateGuidedBrowse TO VpWebApp 
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowse
	@id int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT guided_browse_id AS id, category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method, include_in_sitemap, [enabled], created, modified
	FROM guided_browse
	WHERE guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowse TO VpWebApp 
GO
--#########################end scripts from 1.31.0.440####################################
------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_fixed_guided_browse_to_search_option_fixed_guided_browse') AND parent_object_id = OBJECT_ID(N'fixed_guided_browse_to_search_option'))
BEGIN
	ALTER TABLE fixed_guided_browse_to_search_option
	DROP CONSTRAINT FK_fixed_guided_browse_to_search_option_fixed_guided_browse
END
GO
------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_fixed_guided_browse_search_group') AND parent_object_id = OBJECT_ID(N'fixed_guided_browse'))
BEGIN
	ALTER TABLE fixed_guided_browse
	DROP CONSTRAINT FK_fixed_guided_browse_search_group
END
GO

IF EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'search_group_id' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	DROP COLUMN search_group_id
END
GO

-------------------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'guided_browse_type' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].guided_browse_to_search_group') AND type in (N'U'))
)
BEGIN
	ALTER TABLE guided_browse_to_search_group
	ADD guided_browse_type int NOT NULL DEFAULT(1)
	ALTER TABLE guided_browse_to_search_group
	DROP CONSTRAINT FK_guided_browse_to_search_group_guided_browse
END
GO
---------------------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'navigation_level' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].guided_browse_to_search_group') AND type in (N'U'))
)
BEGIN
	ALTER TABLE guided_browse_to_search_group
	ADD navigation_level int NOT NULL DEFAULT(0)
END
GO
--------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddGuidedBrowseSearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddGuidedBrowseSearchGroup
	@id int output,
	@guidedBrowseId int,
	@searchGroupId int,
	@name varchar(200),
	@description varchar(500),
	@prefix varchar(200),
	@suffix varchar(200),
	@sortOrder int,
	@includeAllOptions bit,
	@enabled bit,	
	@guidedBrowseType int,
	@navigationLevel int,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO guided_browse_to_search_group(guided_browse_id, search_group_id, [name], description, prefix_text, suffix_text, sort_order, include_all_options, [enabled], created, modified, guided_browse_type, navigation_level)
	VALUES (@guidedBrowseId, @searchGroupId, @name, @description, @prefix, @suffix, @sortOrder, @includeAllOptions, @enabled, @created, @created, @guidedBrowseType, @navigationLevel)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddGuidedBrowseSearchGroup TO VpWebApp 
GO
------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowseSearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowseSearchGroup
	@id int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT guided_browse_to_search_group_id AS id, guided_browse_id, search_group_id, [name], description, prefix_text, suffix_text, sort_order, include_all_options, [enabled], created, modified, guided_browse_type, navigation_level
	FROM guided_browse_to_search_group
	WHERE guided_browse_to_search_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowseSearchGroup TO VpWebApp 
GO
-----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateGuidedBrowseSearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateGuidedBrowseSearchGroup
	@id int,
	@guidedBrowseId int,
	@searchGroupId int,
	@name varchar(200),
	@description varchar(500),
	@prefix varchar(200),
	@suffix varchar(200),
	@sortOrder int,
	@includeAllOptions bit,
	@enabled bit,	
	@guidedBrowseType int,
	@navigationLevel int,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE guided_browse_to_search_group
	SET
		guided_browse_id = @guidedBrowseId,
		search_group_id = @searchGroupId,
		[name] = @name,
		description = @description,
		prefix_text = @prefix,
		suffix_text = @suffix,
		sort_order = @sortOrder,
		include_all_options = @includeAllOptions,
		enabled = @enabled,
		modified = @modified,
		guided_browse_type = @guidedBrowseType,
		navigation_level = @navigationLevel
	WHERE guided_browse_to_search_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateGuidedBrowseSearchGroup TO VpWebApp 
GO
-----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowseSearchGroupsByGuidedBrowseIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowseSearchGroupsByGuidedBrowseIdList
	@guidedBrowseId int,
	@guidedBrowseType int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT guided_browse_to_search_group_id AS id, guided_browse_id, search_group_id, [name], description, prefix_text, suffix_text, sort_order, include_all_options, [enabled], created, modified, guided_browse_type, navigation_level
	FROM guided_browse_to_search_group
	WHERE guided_browse_id = @guidedBrowseId AND guided_browse_type = @guidedBrowseType
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowseSearchGroupsByGuidedBrowseIdList TO VpWebApp 
GO
--------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteGuidedBrowseSearchGroupsByGuidedBrowseIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteGuidedBrowseSearchGroupsByGuidedBrowseIdList
	@guidedBrowseId int,
	@guidedBrowseType int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM guided_browse_to_search_group
	WHERE guided_browse_id = @guidedBrowseId AND guided_browse_type = @guidedBrowseType

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteGuidedBrowseSearchGroupsByGuidedBrowseIdList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowse
	@id int output,
	@categoryId int,
	@name varchar(200),
	@searchGroupListType int,
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, [name], search_group_list_type, segment_size, [enabled],
	prefix_text, suffix_text, naming_rule, created, modified)
	VALUES (@categoryId, @name, @searchGroupListType, @segmentSize, @enabled,
	@prefixText, @suffixText, @namingRule, @created, @created)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowse TO VpWebApp 
GO
---------------------------------------------------------------------
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_list_type, segment_size, prefix_text, 
	suffix_text, naming_rule, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO
--------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowse
	@id int,
	@categoryId int,
	@name varchar(200),
	@searchGroupListType int,
	@enabled bit,	
	@segmentSize int,
	@prefixText varchar(200),
	@suffixText varchar(200),
	@namingRule varchar(500),
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
		search_group_list_type = @searchGroupListType,
		segment_size = @segmentSize,
		prefix_text = @prefixText,
		suffix_text = @suffixText,
		naming_rule = @namingRule,
		enabled = @enabled,
		modified = @modified
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowse TO VpWebApp 
GO
-----------------------------------------------------------------
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_list_type, segment_size, prefix_text, 
	suffix_text, naming_rule, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_list_type, segment_size, prefix_text, 
	suffix_text, naming_rule, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE category_id IN
	(
		SELECT category_id
		FROM category
		WHERE site_id = @siteId
	)

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList TO VpWebApp 
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

	SELECT @totalCount = COUNT(prods.product_id)
	FROM
	(
		SELECT ptso.product_id, COUNT(ptso.product_id) AS opt_count
		FROM product_to_search_option ptso				
			INNER JOIN global_Split(@searchOptionsIds, ',') pso
					ON	pso.[value] = ptso.search_option_id	
		GROUP BY ptso.product_id
	) prods
	INNER JOIN product_to_category pc
		ON pc.product_id = prods.product_id
	INNER JOIN product p
		ON p.product_id = prods.product_id
	WHERE prods.opt_count = @optionCount AND pc.category_id = @searchCategoryId AND p.enabled = 1
END
GO

GRANT EXECUTE ON dbo.publicSearch_GetProductCountBySearchOptionIdsAndCategoryId TO VpWebApp 
GO
---------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetAlphabeticalSearchOptionsIndex'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetAlphabeticalSearchOptionsIndex
	@guidedBrowseSearchGroupId int	
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @includeAll bit
	CREATE TABLE #search_options(ranking int, alpha varchar(1), option_name varchar(500))
		
	SELECT @includeAll = include_all_options 
	FROM guided_browse_to_search_group 
	WHERE guided_browse_to_search_group_id = @guidedBrowseSearchGroupId

	IF @includeAll = 1
		BEGIN
			INSERT INTO #search_options
			SELECT ROW_NUMBER() OVER (PARTITION BY opt.alpha ORDER BY opt.name ASC) AS ranking, opt.alpha, opt.name 
			FROM
			(
				SELECT  UPPER(SUBSTRING(s.[name],1,1)) AS alpha, s.[name] 
				FROM search_option s
					INNER JOIN guided_browse_to_search_group gbsg
						ON s.search_group_id = gbsg.search_group_id
				WHERE gbsg.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND s.[enabled] = 1 
					AND s.[name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 
			)opt
		END
	ELSE
		BEGIN
			INSERT INTO #search_options
			SELECT ROW_NUMBER() OVER (PARTITION BY opt.alpha ORDER BY opt.name ASC) AS ranking, opt.alpha, opt.name 
			FROM
			(
				SELECT  UPPER(SUBSTRING(s.[name],1,1)) AS alpha, s.[name] 
				FROM search_option s
					INNER JOIN guided_browse_to_search_group_to_search_option gbsg
						ON s.search_option_id = gbsg.search_option_id
				WHERE gbsg.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND s.[enabled] = 1 
					AND s.[name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 
			) opt
		END

	SELECT  so.alpha +' ('+ mi.option_name + ' - ' +  so.option_name + ')' AS option_index
	FROM #search_options so
		INNER JOIN 
			(
				SELECT MAX(ranking) AS max_rank, alpha
				FROM #search_options
				GROUP BY alpha
			) ma
			ON so.alpha = ma.alpha AND  so.ranking = ma.max_rank
		INNER JOIN
		(
			SELECT alpha,option_name 
			FROM #search_options
			WHERE ranking = 1
		) mi
			ON mi.alpha = ma.alpha 
		
		
	DROP TABLE #search_options

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetAlphabeticalSearchOptionsIndex TO VpWebApp 
GO
---------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSegmentBoundarySearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSegmentBoundarySearchOptions
	@guidedBrowseSearchGroupId int,
	@segmentSize int
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @includeAll bit
	CREATE TABLE #search_options(ranking int, option_id int, option_name varchar(500))
	CREATE TABLE #boundary_options(ranking int, option_id int, option_name varchar(500))
	
	SELECT @includeAll = include_all_options 
	FROM guided_browse_to_search_group 
	WHERE guided_browse_to_search_group_id = @guidedBrowseSearchGroupId
		
	IF @includeAll = 1
		BEGIN
			INSERT INTO #search_options
			SELECT ROW_NUMBER() OVER(ORDER BY s.[name] ASC), s.search_option_id, s.[name] 
			FROM search_option s
				INNER JOIN guided_browse_to_search_group gbsg
					ON s.search_group_id = gbsg.search_group_id
			WHERE gbsg.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND s.[enabled] = 1 
				AND s.[name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 
			
		END
	ELSE
		BEGIN
			INSERT INTO #search_options
			SELECT ROW_NUMBER() OVER(ORDER BY s.[name] ASC), s.search_option_id, s.[name] 
			FROM search_option s
				INNER JOIN guided_browse_to_search_group_to_search_option gbsg
					ON s.search_option_id = gbsg.search_option_id
			WHERE gbsg.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND s.[enabled] = 1 
				AND s.[name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 	
		END	

	INSERT INTO #boundary_options
	SELECT  ranking, option_id, option_name
	FROM #search_options 
	WHERE (ranking % @segmentSize = 1) OR (ranking % @segmentSize = 0)

	INSERT INTO #boundary_options
	SELECT  TOP(1) ranking, option_id, option_name
	FROM #search_options 
	ORDER BY ranking DESC

	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(	
		SELECT option_id
		FROM #boundary_options
	)
	ORDER BY [name]

	DROP TABLE #boundary_options
	DROP TABLE #search_options

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSegmentBoundarySearchOptions TO VpWebApp 
GO
--------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSegmentSearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSegmentSearchOptions
	@guidedBrowseSearchGroupId int,
	@segmentSize int,
	@pageIndex int
AS
-- ==========================================================================
-- $ Author : Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	DECLARE @startIndex int, @endIndex int, @includeAll bit
	
	SET @startIndex = (@segmentSize * @pageIndex) + 1
	SET @endIndex = @segmentSize * (@pageIndex + 1)
	
	CREATE TABLE #search_options(ranking int, option_id int, option_name varchar(500))
	
	SELECT @includeAll = include_all_options 
	FROM guided_browse_to_search_group 
	WHERE guided_browse_to_search_group_id = @guidedBrowseSearchGroupId
	
	IF @includeAll = 1
		BEGIN
			INSERT INTO #search_options
			SELECT ROW_NUMBER() OVER(ORDER BY s.[name] ASC), s.search_option_id, s.[name] 
			FROM search_option s
				INNER JOIN guided_browse_to_search_group gbsg
					ON s.search_group_id = gbsg.search_group_id
			WHERE gbsg.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND s.[enabled] = 1 
				AND s.[name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 
			
		END
	ELSE
		BEGIN
			INSERT INTO #search_options
			SELECT ROW_NUMBER() OVER(ORDER BY s.[name] ASC), s.search_option_id, s.[name] 
			FROM search_option s
				INNER JOIN guided_browse_to_search_group_to_search_option gbsg
					ON s.search_option_id = gbsg.search_option_id
			WHERE gbsg.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND s.[enabled] = 1 
				AND s.[name] LIKE '[abcdefghijklmnopqrstuvwxyz]%' 	
		END	

	-- Select search option data
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(	
		SELECT option_id
		FROM #search_options
		WHERE ranking BETWEEN @startIndex AND @endIndex
	)
	ORDER BY [name]

	DROP TABLE #search_options

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSegmentSearchOptions TO VpWebApp 
GO

--------------------------------------------------------------------------------------
-- Drop  sp's of excluded FixedGuidedBrowseSearchOption dao
EXEC dbo.global_DropStoredProcedure 'adminSearch_AddFixedGuidedBrowseSearchOption'
EXEC dbo.global_DropStoredProcedure 'publicSearch_GetFixedGuidedBrowseSearchOption'
EXEC dbo.global_DropStoredProcedure 'adminSearch_UpdateFixedGuidedBrowseSearchOption'
EXEC dbo.global_DropStoredProcedure 'adminSearch_DeleteFixedGuidedBrowseSearchOption'
EXEC dbo.global_DropStoredProcedure 'publicSearch_GetFixedGuidedBrowseSearchOptionsByFixedGuidedBrowseIdList'
EXEC dbo.global_DropStoredProcedure 'adminSearch_DeleteFixedGuidedBrowseSearchOptionByFixedGuidedBrowseId'
EXEC dbo.global_DropStoredProcedure 'adminSearch_DeleteFixedGuidedBrowseSearchOptionsBySiteId'


-------------------START scripts from 1.31.0.500------
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[guided_browse_url]') AND type in (N'U'))
BEGIN
	CREATE TABLE [guided_browse_url](
		[guided_browse_url_id] [int] IDENTITY(1,1) NOT NULL,
		[site_id] [int] NOT NULL,
		[fixed_url_id] [int] NOT NULL,
		[search_option_ids] [varchar](200) NOT NULL,
		[category_name] [varchar](500) NOT NULL,
		[search_option_names] [varchar](1000) NOT NULL,		
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	CONSTRAINT [PK_guided_browse_url] PRIMARY KEY CLUSTERED 
	(
		[guided_browse_url_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_guided_browse_url_site') AND parent_object_id = OBJECT_ID(N'guided_browse_url'))
BEGIN
	ALTER TABLE [guided_browse_url]  WITH CHECK ADD  CONSTRAINT [FK_guided_browse_url_site] FOREIGN KEY([site_id])
	REFERENCES [site] ([site_id])
	ALTER TABLE [guided_browse_url] CHECK CONSTRAINT [FK_guided_browse_url_site]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_guided_browse_url_fixed_url') AND parent_object_id = OBJECT_ID(N'guided_browse_url'))
BEGIN
	ALTER TABLE [guided_browse_url]  WITH CHECK ADD  CONSTRAINT [FK_guided_browse_url_fixed_url] FOREIGN KEY([fixed_url_id])
	REFERENCES [fixed_url] ([fixed_url_id])
	ALTER TABLE [guided_browse_url] CHECK CONSTRAINT [FK_guided_browse_url_fixed_url]
END
GO

-------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteGuidedBrowseUrlsBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteGuidedBrowseUrlsBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM guided_browse_url
	WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteGuidedBrowseUrlsBySiteIdList TO VpWebApp 
GO

------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddGuidedBrowseUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddGuidedBrowseUrl
	@id int output,
	@siteId int,
	@fixedUrlId int,
	@searchOptionIds varchar(200),
	@categoryName varchar(500),
	@searchOptionNames varchar(1000),
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO guided_browse_url(site_id, fixed_url_id, search_option_ids, category_name, search_option_names, [enabled], created, modified)
	VALUES (@siteId, @fixedUrlId, @searchOptionIds, @categoryName, @searchOptionNames, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddGuidedBrowseUrl TO VpWebApp 
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeleteGuidedBrowseUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeleteGuidedBrowseUrl
	@id int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM guided_browse_url
	WHERE guided_browse_url_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeleteGuidedBrowseUrl TO VpWebApp 
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowseUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowseUrl
	@id int

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT guided_browse_url_id AS id, site_id, fixed_url_id, search_option_ids, category_name, search_option_names, [enabled], created, modified
	FROM guided_browse_url
	WHERE guided_browse_url_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowseUrl TO VpWebApp 
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowseUrlBySiteIdFixedUrlIdSearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowseUrlBySiteIdFixedUrlIdSearchOptionsList
	@siteId int,
	@fixedUrlId int,
	@searchOptionIds varchar(200)

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT guided_browse_url_id AS id, site_id, fixed_url_id, search_option_ids, category_name, search_option_names, [enabled], created, modified
	FROM guided_browse_url
	WHERE site_id = @siteId AND fixed_url_id = @fixedUrlId AND search_option_ids = @searchOptionIds

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowseUrlBySiteIdFixedUrlIdSearchOptionsList TO VpWebApp 
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateGuidedBrowseUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateGuidedBrowseUrl
	@id int,
	@siteId int,
	@fixedUrlId int,
	@searchOptionIds varchar(200),
	@categoryName varchar(500),
	@searchOptionNames varchar(1000),
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET @modified = GETDATE()

	UPDATE guided_browse_url
	SET
		site_id = @siteId,
		fixed_url_id = @fixedUrlId,
		search_option_ids = @searchOptionIds,
		category_name = @categoryName,
		search_option_names = @searchOptionNames,
		enabled = @enabled,
		modified = @modified
	WHERE guided_browse_url_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateGuidedBrowseUrl TO VpWebApp 
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetGuidedBrowseUrlsBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetGuidedBrowseUrlsBySiteIdList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@totalCount int output

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_guided_browse_url(row, guided_browse_url_id, site_id, fixed_url_id, search_option_ids, category_name, search_option_names, [enabled], created, modified) 
	AS	
	(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY guided_browse_url_id) AS row, 
			guided_browse_url_id, site_id, fixed_url_id, search_option_ids, category_name, search_option_names, [enabled], created, modified
		FROM guided_browse_url
		WHERE site_id = @siteId
	)

	SELECT guided_browse_url_id AS id, site_id, fixed_url_id, search_option_ids, category_name, search_option_names, [enabled], created, modified
	FROM temp_guided_browse_url
	WHERE (row BETWEEN @startIndex AND @endIndex)
	ORDER BY row

	SELECT @totalCount = COUNT(*)
	FROM guided_browse_url
	WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowseUrlsBySiteIdList TO VpWebApp 
GO

----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserFieldsOfUsers'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserFieldsOfUsers   
 @publicUserIds varchar(max)  
AS  
-- ==========================================================================  
-- $Author : Dilshan $  
-- ==========================================================================  
BEGIN  
   
 SET NOCOUNT ON;  
  
 SELECT public_user_field_id AS id, public_user_id, field_id, field_value, is_field_option, [enabled], modified, created  
 FROM public_user_field  
 WHERE public_user_id IN   
  (  
   SELECT [value] FROM dbo.global_Split(@publicUserIds, ',')  
  )  
    
END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserFieldsOfUsers TO VpWebApp 
GO

