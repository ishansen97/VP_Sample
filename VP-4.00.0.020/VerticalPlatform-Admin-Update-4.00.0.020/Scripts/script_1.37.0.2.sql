IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'fixed_guided_browse_search_options' AND id = 
	(
		SELECT object_id 
		FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'prebuilt_guided_browse') AND type in (N'U')
	)
)
BEGIN
	ALTER TABLE prebuilt_guided_browse
	ADD fixed_guided_browse_search_options varchar(1000) NOT NULL DEFAULT ''
END

GO

--------------------

------------------ 
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddPrebuiltGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddPrebuiltGuidedBrowse
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@guidedBrowseSearchOptions varchar(1000),
	@fixedGuidedBrowseSearchOptions varchar(1000),
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

	INSERT INTO prebuilt_guided_browse(guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,		start_character, range_index,
		start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, [enabled], created, modified)
	VALUES (@guidedBrowseTypeId, @guidedBrowseId, @guidedBrowseSearchOptions, @fixedGuidedBrowseSearchOptions, @startCharacter, @rangeIndex,
		@startSearchOptionName, @endSearchOptionName, @startSearchOptionId, @endSearchOptionId, @allSearchOptionIds,
		@previousSearchOptions, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearch_AddPrebuiltGuidedBrowse TO VpWebApp 
GO

GO
------------------
------------------ 
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
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE prebuilt_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_GetPrebuiltGuidedBrowseDetail TO VpWebApp 
GO
------------------
------------------ 
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
	@fixedGuidedBrowseSearchOptions varchar(1000),
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
		fixed_guided_browse_search_options = @fixedGuidedBrowseSearchOptions, 
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
------------------
------------------ 
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
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND guided_browse_search_options = @browseSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPostSearchInformation TO VpWebApp 
GO
------------------
------------------ 
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
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND previous_search_options = @previousSearchOptions AND guided_browse_search_options = @browseSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreAndPostSearchInformation TO VpWebApp 
GO
------------------
------------------ 
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
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND previous_search_options = @previousSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetAllPrebuiltGuidedBrowseWithPreSearchInformation TO VpWebApp 
GO
------------------
------------------ 
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
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId 
		AND guided_browse_search_options = @browseSearchOptions AND start_character = @mainIndexSelection

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetPrebuiltGuidedBrowseSearchInformation TO VpWebApp 
GO
------------------
------------------ 
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetPrebuiltGuidedBrowseSegment'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetPrebuiltGuidedBrowseSegment
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@mainIndexSelection varchar(5),
	@browseSearchOptions varchar(255),
	@rangeIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId AND start_character = @mainIndexSelection AND
		range_index = @rangeIndex AND guided_browse_search_options = @browseSearchOptions

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetPrebuiltGuidedBrowseSegment TO VpWebApp 
GO
------------------
------------------ 
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetValidPrebuiltFixedGuidedBrowsesWithOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetValidPrebuiltFixedGuidedBrowsesWithOptions
	@guidedBrowseTypeId int,
	@guidedBrowseId int,
	@filter varchar(255)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse
	WHERE guided_browse_type_id = @guidedBrowseTypeId AND guided_browse_id = @guidedBrowseId
		AND fixed_guided_browse_search_options LIKE @filter AND all_search_option_ids <> ''

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetValidPrebuiltFixedGuidedBrowsesWithOptions TO VpWebApp 
GO
------------------


