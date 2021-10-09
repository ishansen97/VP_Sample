
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetArticleFixedUrlBySiteIdPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetArticleFixedUrlBySiteIdPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_fixed_url(id, fixed_url, site_id, page_id, content_type_id, content_id, 
		query_string, enabled, created, modified, row) AS
	(
		SELECT fixed_url_id AS id, fixed_url, fu.site_id, page_id, fu.content_type_id, content_id
			, query_string, fu.enabled, fu.created, fu.modified
			, ROW_NUMBER() OVER (ORDER BY fixed_url_id) AS row
		FROM fixed_url fu
			INNER JOIN article a ON fu.content_id = a.article_id AND a.enabled = 1 
				AND a.site_id = @siteId AND fu.content_type_id = 4 AND a.is_external = 0
		WHERE fu.site_id = @siteId AND fu.enabled = 1
	)

	SELECT id, fixed_url, site_id, page_id, content_type_id, content_id, query_string
		, enabled, created, modified
	FROM temp_fixed_url
	WHERE row BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetArticleFixedUrlBySiteIdPagingList TO VpWebApp 
GO
--------------------------------------------------------------------------------------
--public_user_profile table column data type update to nvarchar--
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'first_name' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [first_name] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'last_name' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [last_name] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'address_line1' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [address_line1] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'address_line2' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [address_line2] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'city' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [city] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'state' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [state] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'postal_code' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [postal_code] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------
IF EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'company' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'public_user_profile') AND type in (N'U'))
)
BEGIN
ALTER TABLE public_user_profile
	ALTER COLUMN [company] [nvarchar] (255) NULL 
END
GO
----------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_AddPublicUserProfile'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_AddPublicUserProfile
	@publicUserId int,
	@salutation int,
	@firstName nvarchar(255),
	@lastname nvarchar(255),
	@addressLine1 nvarchar(255),
	@addressLine2 nvarchar(255),
	@city nvarchar(255),
	@state nvarchar(255),
	@countryId varchar(255),
	@phoneNumber varchar(50),
	@postalCode nvarchar(255),
	@company nvarchar(255),
	@enabled bit,
	@created smalldatetime output,
	@id int output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO public_user_profile(public_user_id, salutation, first_name, last_name, address_line1
		, address_line2, city, [state], country_id, phone_number, postal_code, company
		, [enabled], modified, created)
	VALUES(@publicUserId, @salutation, @firstName, @lastname, @addressLine1
		, @addressLine2, @city, @state, @countryId, @phoneNumber, @postalCode, @company
		, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.publicUser_AddPublicUserProfile TO VpWebApp 
GO
----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_UpdatePublicUserProfile'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_UpdatePublicUserProfile
	@id int,
	@publicUserId int,
	@salutation int,
	@firstName nvarchar(255),
	@lastname nvarchar(255),
	@addressLine1 nvarchar(255),
	@addressLine2 nvarchar(255),
	@city nvarchar(255),
	@state nvarchar(255),
	@countryId varchar(255),
	@phoneNumber varchar(50),
	@company nvarchar(255),
	@enabled bit,
	@postalCode nvarchar(255),
	@modified smalldatetime output
	
AS
-- ==========================================================================
-- - $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE public_user_profile
	SET public_user_id = @publicUserId,
			salutation = @salutation,
			first_name = @firstName,
			last_name = @lastname,
			address_line1 = @addressLine1,
			address_line2 = @addressLine2,
			city = @city,
			[state] = @state,
			country_id = @countryId,
			phone_number = @phoneNumber,
			company = @company,
			[enabled] = @enabled,
			modified = @modified,
			postal_code = @postalCode
	WHERE public_user_profile_id = @id

END
GO

GRANT EXECUTE ON dbo.adminUser_UpdatePublicUserProfile TO VpWebApp 
GO
----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleCustomProperty'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddArticleCustomProperty
	@id int output,
	@articleId int,
	@customPropertyId int,
	@customPropertyValue varchar(max),
	@created smalldatetime output, 
	@enabled bit	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SET @created = GETDATE()

	INSERT INTO article_custom_property	(article_id, custom_property_id, custom_property_value, enabled, created, modified)
		VALUES (@articleId, @customPropertyId, @customPropertyValue, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON adminArticle_AddArticleCustomProperty TO VpWebApp
GO
------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleCustomProperty'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleCustomProperty
	@id int,
	@articleId int,
	@customPropertyId int,
	@customPropertyValue varchar(max),
	@modified smalldatetime output, 
	@enabled bit	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SET @modified = GETDATE();

	UPDATE article_custom_property
		SET article_id = @articleId,
			custom_property_id = @customPropertyId,
			custom_property_value = @customPropertyValue,
			enabled = @enabled,
			modified = @modified
	WHERE article_custom_property_id = @id

END
GO

GRANT EXECUTE ON adminArticle_UpdateArticleCustomProperty TO VpWebApp
GO

