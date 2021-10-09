-----------------Add new columns------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'prefix_text' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD prefix_text varchar(200) null 
END
GO
------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'suffix_text' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD suffix_text varchar(200) null 
END
GO

------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'naming_rule' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].fixed_guided_browse') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_guided_browse
	ADD naming_rule varchar(500) null 
END
GO
--------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddFixedGuidedBrowse
	@id int output,
	@categoryId int,
	@searchGroupId int,
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
	INSERT INTO fixed_guided_browse(category_id, search_group_id, [name], search_group_list_type, segment_size, [enabled],
	prefix_text, suffix_text, naming_rule, created, modified)
	VALUES (@categoryId, @searchGroupId, @name, @searchGroupListType, @segmentSize, @enabled,
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_id, search_group_list_type, segment_size, prefix_text, 
	suffix_text, naming_rule, [enabled], created, modified
	FROM fixed_guided_browse
	WHERE fixed_guided_browse_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowse TO VpWebApp 
GO
-------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateFixedGuidedBrowse'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateFixedGuidedBrowse
	@id int,
	@categoryId int,
	@searchGroupId int,
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
		search_group_id = @searchGroupId,
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
-----------------------------------------------------------------------------
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_id, search_group_list_type, segment_size, prefix_text, 
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

	SELECT fixed_guided_browse_id AS id, category_id, [name], search_group_id, search_group_list_type, segment_size, prefix_text, 
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
---------------------------------------------------------------------------------