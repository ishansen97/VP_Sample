IF NOT EXISTS (SELECT * FROM module WHERE module_name = 'PrebuiltGuidedBrowse')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES ('PrebuiltGuidedBrowse', '~/Modules/GuidedBrowse/PrebuiltGuidedBrowse.ascx', 1, getdate(), getdate(), 0)
END
GO

IF NOT EXISTS (SELECT * FROM module WHERE module_name = 'PrebuiltGuidedBrowseIndex')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES ('PrebuiltGuidedBrowseIndex', '~/Modules/GuidedBrowse/PrebuiltGuidedBrowseIndex.ascx', 1, getdate(), getdate(), 0)
END
GO

IF NOT EXISTS (SELECT * FROM module WHERE module_name = 'PrebuiltFixedGuidedBrowse')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES ('PrebuiltFixedGuidedBrowse', '~/Modules/GuidedBrowse/PrebuiltFixedGuidedBrowse.ascx', 1, getdate(), getdate(), 0)
END
GO

IF NOT EXISTS (SELECT * FROM module WHERE module_name = 'PrebuiltFixedGuidedBrowseIndex')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES ('PrebuiltFixedGuidedBrowseIndex', '~/Modules/GuidedBrowse/PrebuiltFixedGuidedBrowseIndex.ascx', 1, getdate(), getdate(), 0)
END
GO

------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'prebuilt' AND id = 
	(
		SELECT object_id 
		FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'guided_browse') AND type in (N'U')
	)
)
BEGIN
	ALTER TABLE guided_browse
	ADD prebuilt bit NOT NULL DEFAULT 0
END

GO

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'prebuilt' AND id = 
	(
		SELECT object_id 
		FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'fixed_guided_browse') AND type in (N'U')
	)
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD prebuilt bit NOT NULL DEFAULT 0
END

GO

----------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prebuilt_guided_browse]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[prebuilt_guided_browse](
	[prebuilt_guided_browse_id] [int] IDENTITY(1,1) NOT NULL,
	[guided_browse_type_id] [int] NOT NULL,
	[guided_browse_id] [int] NOT NULL,
	[guided_browse_search_options] [varchar](1000) NULL,
	[start_character] [varchar](5) NOT NULL,
	[range_index] [int] NOT NULL,
	[start_search_option_name] [varchar](255) NOT NULL,
	[end_search_option_name] [varchar](255) NOT NULL,
	[start_search_option_id] [int] NOT NULL,
	[end_search_option_id] [int] NOT NULL,
	[all_search_option_ids] [varchar](max) NOT NULL,
	[previous_search_options] [varchar](max) NOT NULL,
	[enabled] [bit] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_pre_built_guided_browse] PRIMARY KEY CLUSTERED 
(
	[prebuilt_guided_browse_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

GO

---------------

IF NOT EXISTS (SELECT * FROM module WHERE module_name = 'PrebuiltGuidedBrowse')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES ('PrebuiltGuidedBrowse', '~/Modules/GuidedBrowse/PrebuiltGuidedBrowse.ascx', 1, getdate(), getdate(), 0)
END
GO

IF NOT EXISTS (SELECT * FROM module WHERE module_name = 'PrebuiltFixedGuidedBrowse')
BEGIN
	INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
	VALUES ('PrebuiltFixedGuidedBrowse', '~/Modules/GuidedBrowse/PrebuiltFixedGuidedBrowse.ascx', 1, getdate(), getdate(), 0)
END
GO

------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'prebuilt' AND id = 
	(
		SELECT object_id 
		FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'guided_browse') AND type in (N'U')
	)
)
BEGIN
	ALTER TABLE guided_browse
	ADD prebuilt bit NOT NULL DEFAULT 0
END

GO

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'prebuilt' AND id = 
	(
		SELECT object_id 
		FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'fixed_guided_browse') AND type in (N'U')
	)
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD prebuilt bit NOT NULL DEFAULT 0
END

GO

----------------

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prebuilt_guided_browse]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[prebuilt_guided_browse](
	[prebuilt_guided_browse_id] [int] IDENTITY(1,1) NOT NULL,
	[guided_browse_type_id] [int] NOT NULL,
	[guided_browse_id] [int] NOT NULL,
	[guided_browse_search_options] [varchar](1000) NULL,
	[start_character] [varchar](5) NOT NULL,
	[range_index] [int] NOT NULL,
	[start_search_option_name] [varchar](255) NOT NULL,
	[end_search_option_name] [varchar](255) NOT NULL,
	[start_search_option_id] [int] NOT NULL,
	[end_search_option_id] [int] NOT NULL,
	[all_search_option_ids] [varchar](max) NOT NULL,
	[previous_search_options] [varchar](max) NOT NULL,
	[enabled] [bit] NOT NULL,
	[created] [smalldatetime] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_pre_built_guided_browse] PRIMARY KEY CLUSTERED 
(
	[prebuilt_guided_browse_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

GO

---------------

---------------

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
	@includeInSitemap bit,
	@prebuilt bit,
	@isClean bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, [name],  segment_size, [enabled],
		prefix_text, suffix_text, naming_rule, created, modified, build_option_list, is_dynamic, include_in_sitemap, is_clean, prebuilt)
	VALUES (@categoryId, @name, @segmentSize, @enabled,
		@prefixText, @suffixText, @namingRule, @created, @created, @buildOptionList, @isDynamic, @includeInSitemap, @isClean, @prebuilt)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddFixedGuidedBrowse TO VpWebApp 
GO

---------------
---------------

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
	@prebuilt bit,
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
	INSERT INTO guided_browse(category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method, include_in_sitemap, prebuilt, [enabled], created, modified)
	VALUES (@categoryId, @name, @prefix, @suffix, @namingRule, @pageSize, @sortOrder, @startingMethod, @includeInSitemap, @prebuilt, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()


END
GO

GRANT EXECUTE ON dbo.adminSearch_AddGuidedBrowse TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddPrebuiltGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddPrebuiltGuidedBrowse
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@guidedBrowseSearchOptions varchar(1000),
	@startCharacter varchar(5),
	@rangeIndex int,
	@startSearchOptionName varchar(255),
	@endSearchOptionName varchar(255),
	@startSearchOptionId int,
	@endSearchOptionId int,
	@allSearchOptionIds varchar(max),
	@previousSearchOptions varchar(max),
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

	INSERT INTO prebuilt_guided_browse(guided_browse_type_id, guided_browse_id, guided_browse_search_options, start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, [enabled], created, modified)
	VALUES (@guidedBrowseTypeId, @guidedBrowseId, @guidedBrowseSearchOptions, @startCharacter, @rangeIndex,
		@startSearchOptionName, @endSearchOptionName, @startSearchOptionId, @endSearchOptionId, @allSearchOptionIds,
		@previousSearchOptions, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearch_AddPrebuiltGuidedBrowse TO VpWebApp 
GO

GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeletePrebuiltGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeletePrebuiltGuidedBrowse
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM prebuilt_guided_browse
	WHERE prebuilt_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeletePrebuiltGuidedBrowse TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_DeletePrebuiltGuidedBrowseByGuideBrowseTypeIdGuidedBrowseId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_DeletePrebuiltGuidedBrowseByGuideBrowseTypeIdGuidedBrowseId
	@guidedBrowseTypeId int,
	@guidedBrowseId int
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId

END
GO

GRANT EXECUTE ON dbo.adminSearch_DeletePrebuiltGuidedBrowseByGuideBrowseTypeIdGuidedBrowseId TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetPrebuiltGuidedBrowseDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetPrebuiltGuidedBrowseDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE prebuilt_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_GetPrebuiltGuidedBrowseDetail TO VpWebApp 
GO

---------------
---------------

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
	@includeInSitemap bit,
	@isClean bit,
	@prebuilt bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
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
		include_in_sitemap = @includeInSitemap,
		is_clean = @isClean,
		prebuilt = @prebuilt
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateFixedGuidedBrowse TO VpWebApp 
GO

---------------
---------------

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
	@prebuilt bit,
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
		prebuilt = @prebuilt,
		enabled = @enabled,
		modified = @modified
	WHERE guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateGuidedBrowse TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdatePrebuiltGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdatePrebuiltGuidedBrowse
	@id int,
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@guidedBrowseSearchOptions varchar(1000),
	@startCharacter varchar(5),
	@rangeIndex int,
	@startSearchOptionName varchar(255),
	@endSearchOptionName varchar(255),
	@startSearchOptionId int,
	@endSearchOptionId int,
	@allSearchOptionIds varchar(max),
	@previousSearchOptions varchar(max),
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE prebuilt_guided_browse
	SET guided_browse_type_id = @guidedBrowseTypeId, 
		guided_browse_id = @guidedBrowseId, 
		guided_browse_search_options = @guidedBrowseSearchOptions, 
		start_character = @startCharacter, 
		range_index = @rangeIndex, 
		start_search_option_name = @startSearchOptionName, 
		end_search_option_name = @endSearchOptionName, 
		start_search_option_id = @startSearchOptionId, 
		end_search_option_id = @endSearchOptionId,
		all_search_option_ids = @allSearchOptionIds, 
		previous_search_options = @previousSearchOptions,
		enabled = @enabled,
		modified = @modified
	WHERE prebuilt_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdatePrebuiltGuidedBrowse TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllFixedGuidedBrowses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllFixedGuidedBrowses
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt
	FROM fixed_guided_browse
	WHERE [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllFixedGuidedBrowses TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPostSearchInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPostSearchInformation
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@browseSearchOptions varchar(255)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND guided_browse_search_options = @browseSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPostSearchInformation TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreAndPostSearchInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreAndPostSearchInformation
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@previousSearchOptions varchar(255),
	@browseSearchOptions varchar(255)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND previous_search_options = @previousSearchOptions AND guided_browse_search_options = @browseSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreAndPostSearchInformation TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreSearchInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreSearchInformation
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@previousSearchOptions varchar(255)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND previous_search_options = @previousSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreSearchInformation TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowse
	@id int

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList
	@categoryId int

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt
	FROM fixed_guided_browse
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowsesByCategoryIdList TO VpWebApp 
GO

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowsesBySiteIdList
	@siteId int

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt
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

---------------
---------------

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

	SELECT guided_browse_id AS id, category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method,
		include_in_sitemap, prebuilt, [enabled], created, modified
	FROM guided_browse
	WHERE guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowse TO VpWebApp 
GO

---------------
---------------

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

	SELECT guided_browse_id AS id, category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method, 
		include_in_sitemap, prebuilt, [enabled], created, modified
	FROM guided_browse
	WHERE category_id = @categoryId
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowsesByCategoryIdList TO VpWebApp 
GO

---------------
---------------

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

	SELECT guided_browse_id AS id, category_id, [name], prefix_text, suffix_text, naming_rule, page_size, sort_order, starting_method,
		include_in_sitemap, prebuilt, [enabled], created, modified
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

---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetPrebuiltGuidedBrowseSearchInformation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetPrebuiltGuidedBrowseSearchInformation
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@mainIndexSelection varchar(5),
	@browseSearchOptions varchar(255)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId 
		AND guided_browse_search_options = @browseSearchOptions AND start_character = @mainIndexSelection

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetPrebuiltGuidedBrowseSearchInformation TO VpWebApp 
GO


---------------
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetPrebuiltGuidedBrowseSegment'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetPrebuiltGuidedBrowseSegment
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@mainIndexSelection varchar(5),
	@previousSearchOptions varchar(255),
	@browseSearchOptions varchar(255),
	@rangeIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId AND start_character = @mainIndexSelection AND
		previous_search_options = @previousSearchOptions AND range_index = @rangeIndex AND guided_browse_search_options = @browseSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetPrebuiltGuidedBrowseSegment TO VpWebApp 
GO

---------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdatePrebuiltGuidedBrowseTempGuidedBrowseIdByRealGuidedBrowseId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdatePrebuiltGuidedBrowseTempGuidedBrowseIdByRealGuidedBrowseId
	@tempGuidedBrowseId int,
	@realGuidedBrowseId int
AS
-- ==========================================================================
-- $Author: Dhanushka $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @modified smalldatetime
	SET @modified = GETDATE()

	UPDATE prebuilt_guided_browse
	SET guided_browse_id = @realGuidedBrowseId,
		modified = @modified
	WHERE guided_browse_id = @tempGuidedBrowseId

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdatePrebuiltGuidedBrowseTempGuidedBrowseIdByRealGuidedBrowseId TO VpWebApp 
GO


-----------------------
