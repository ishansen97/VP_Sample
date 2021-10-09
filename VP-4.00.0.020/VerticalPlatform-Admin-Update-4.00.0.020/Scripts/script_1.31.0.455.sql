IF EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'search_group_list_type' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	DROP COLUMN search_group_list_type
END
GO
----------------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'list_type' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].guided_browse_to_search_group') AND type in (N'U'))
)
BEGIN
	ALTER TABLE guided_browse_to_search_group
	ADD list_type int NOT NULL DEFAULT(0)
END
GO
------------------------------------------------------------------------------------------
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
	@listType int,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO guided_browse_to_search_group(guided_browse_id, search_group_id, [name], description, prefix_text, suffix_text, sort_order, include_all_options, [enabled], created, modified, guided_browse_type, navigation_level, list_type)
	VALUES (@guidedBrowseId, @searchGroupId, @name, @description, @prefix, @suffix, @sortOrder, @includeAllOptions, @enabled, @created, @created, @guidedBrowseType, @navigationLevel, @listType)

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

	SELECT guided_browse_to_search_group_id AS id, guided_browse_id, search_group_id, [name], description, prefix_text, suffix_text, sort_order, include_all_options, [enabled], created, modified, guided_browse_type, navigation_level, list_type
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
	@listType int,
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
		navigation_level = @navigationLevel,
		list_type = @listType
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

	SELECT guided_browse_to_search_group_id AS id, guided_browse_id, search_group_id, [name], description, prefix_text, suffix_text, sort_order, include_all_options, [enabled], created, modified, guided_browse_type, navigation_level,list_type
	FROM guided_browse_to_search_group
	WHERE guided_browse_id = @guidedBrowseId AND guided_browse_type = @guidedBrowseType
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetGuidedBrowseSearchGroupsByGuidedBrowseIdList TO VpWebApp 
GO
--------------------------------------------------------------------------------------------
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
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO fixed_guided_browse(category_id, [name], segment_size, [enabled],
	prefix_text, suffix_text, naming_rule, created, modified)
	VALUES (@categoryId, @name, @segmentSize, @enabled,
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
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

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList
	@bulkEmailTypeId int,
	@siteId int,
	@pageSize int,
	@pageIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH UserList AS
	(
		SELECT pup.public_user_profile_id AS id, ROW_NUMBER() OVER (ORDER BY pup.public_user_id) AS row_id, pup.public_user_id, pup.salutation, pup.first_name, pup.last_name,
			pup.address_line1, pup.address_line2, pup.city, pup.[state], pup.country_id, pup.phone_number, pup.postal_code, pup.company, pu.email
		FROM public_user pu
			INNER JOIN public_user_profile pup
				ON pu.public_user_id = pup.public_user_id
		WHERE pu.site_id = @siteId AND pu.email_optout = 0 AND pu.enabled = 1 AND pu.public_user_id IN
		(
			SELECT DISTINCT puf.public_user_id
			FROM public_user_field puf
				INNER JOIN bulk_email_type_to_field btf
					ON btf.field_id = puf.field_id
				INNER JOIN field f
					ON btf.field_id = f.field_id
				INNER JOIN public_user_field_to_field_option pufo
					ON puf.public_user_field_id = pufo.public_user_field_id
			WHERE btf.bulk_email_type_id = @bulkEmailTypeId AND f.field_type_id = 3
		)
	)
	
	SELECT id, public_user_id, salutation, first_name, last_name
		, address_line1, address_line2, city, [state], country_id, phone_number, postal_code, company
		, email
	FROM UserList
	WHERE row_id BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList TO VpWebApp 
GO

--------
