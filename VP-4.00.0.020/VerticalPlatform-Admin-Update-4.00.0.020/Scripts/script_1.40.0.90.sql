IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'send_to_matrix' AND Object_ID = Object_ID(N'category_to_search_group'))
BEGIN
    ALTER TABLE category_to_search_group
	ADD send_to_matrix BIT NOT NULL DEFAULT 0
END
GO

--------------------------------------------------------------------------------------------------------------------------------

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
	@displayName varchar(255),
	@displayOptions int,
	@cssWidth float,
	@sendToMatrix bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_to_search_group ([category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [enabled], [include_all_options], expand_on_load, [modified], 
		[created], [filter_search_options], [display_name], [display_options], [css_width], [send_to_matrix])
	VALUES (@categoryId, @searchGroupId, @sortOrder, @searchable,
		@matrixPrefix, @matrixSuffix, @enabled, @includeAllOptions, @expandOnLoad, @created, @created, 
		@filterSearchOptions, @displayName, @displayOptions, @cssWidth, @sendToMatrix)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchGroup TO VpWebApp 
Go

-------------------------------------------------------------------------------------------------------------------

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
	@displayName varchar(255),
	@displayOptions int,
	@cssWidth float,
	@sendToMatrix bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
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
		[filter_search_options] = @filterSearchOptions,
		[display_name] = @displayName,
		[display_options] = @displayOptions,
		[css_width] = @cssWidth,
		[send_to_matrix] = @sendToMatrix
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchGroup TO VpWebApp 
GO

--------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdDisplayOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdDisplayOption
	@categoryIds NVARCHAR(MAX),
	@displayOption int
AS
-- ==========================================================================
-- $ Author : Sahan Diasena $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ctsg.category_to_search_group_id AS [id], ctsg.category_id, ctsg.search_group_id,
		   ctsg.sort_order, ctsg.searchable, ctsg.[enabled], ctsg.created, ctsg.modified, 
		   ctsg.matrix_prefix, ctsg.matrix_suffix, ctsg.include_all_options, ctsg.expand_on_load,
		   ctsg.filter_search_options, ctsg.display_name, ctsg.display_options, ctsg.css_width, ctsg.send_to_matrix
	FROM category_to_search_group ctsg
		INNER JOIN dbo.global_Split(@categoryIds, ',') gs
		ON gs.[value] = ctsg.category_id
	WHERE ctsg.display_options  & @displayOption = @displayOption
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdDisplayOption TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], expand_on_load, [created], [enabled], [modified], [include_all_options],
		[filter_search_options], [display_name], [display_options], [css_width], [send_to_matrix]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------

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
-- $ Author : Sahan Diasena $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [include_all_options], expand_on_load, [created], [enabled], [modified],
		[filter_search_options], [display_name], [display_options], [css_width], [send_to_matrix]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'site_logo' AND Object_ID = Object_ID(N'client_token'))
BEGIN
    ALTER TABLE client_token
	ADD site_logo BIT NOT NULL DEFAULT 0
END
GO

----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddClientToken'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddClientToken
	@name varchar(50),
	@email varchar(50),
	@token varchar(50),
	@siteId int,
	@enabled bit,
	@siteLogo bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO client_token(name, email, token, site_id, created, enabled, modified, site_logo)
	VALUES (@name, @email, @token, @siteId, @created, @enabled, @created, @siteLogo)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddClientToken TO VpWebApp
GRANT EXECUTE ON dbo.adminPlatform_AddClientToken TO VpWebAPI

GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetClientTokenBySiteIdWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetClientTokenBySiteIdWithPaging
	@siteId INT,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH clientTokens AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY client_token_id) AS row, client_token_id AS id, name, email,
				token, site_id, created, enabled, modified, site_logo
		FROM client_token
		WHERE site_id = @siteId
	)

	SELECT id, name, email, token, site_id, created, enabled, modified, site_logo
	FROM clientTokens
	WHERE row BETWEEN @startIndex AND @endIndex
	
	SELECT @totalCount = count(client_token_id)
	FROM client_token
	WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenBySiteIdWithPaging TO VpWebApp
GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenBySiteIdWithPaging TO VpWebAPI
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetClientTokenByTokenSiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetClientTokenByTokenSiteId
	@siteId INT,
	@token varchar(50)
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT client_token_id AS id, name, email, token, site_id, created, enabled, modified, site_logo
	FROM client_token
	WHERE site_id = @siteId AND token = @token

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenByTokenSiteId TO VpWebApp
GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenByTokenSiteId TO VpWebAPI
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetClientTokenDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetClientTokenDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT client_token_id AS id, name, email, token, site_id, created, enabled, modified, site_logo
	FROM client_token
	WHERE client_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenDetail TO VpWebApp
GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenDetail TO VpWebAPI 
GO

----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateClientToken'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateClientToken
	@id int,
	@name varchar(50),
	@email varchar(50),
	@token varchar(50),
	@siteId int,
	@enabled bit,
	@siteLogo bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE client_token
	SET name = @name, 
	email = @email, 
	token = @token, 
	site_id = @siteId, 
	enabled = @enabled,
	modified = @modified,
	site_logo = @siteLogo
	WHERE client_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateClientToken TO VpWebApp
GRANT EXECUTE ON dbo.adminPlatform_UpdateClientToken TO VpWebAPI
GO
----------------------------------------------------------------------------------------------------------------------------


