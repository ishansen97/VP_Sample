IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[client_token]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[client_token](
		[client_token_id] [int] IDENTITY(1,1) NOT NULL,
		[name] [varchar](50) NOT NULL,
		[email] [varchar](50) NOT NULL,
		[token] [varchar](50) NOT NULL,
		[site_id] [int] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[enabled] [bit] NOT NULL,
	 CONSTRAINT [PK_client_token] PRIMARY KEY CLUSTERED 
	(
		[client_token_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[client_token]  WITH CHECK ADD  CONSTRAINT [FK_client_token_site] FOREIGN KEY([site_id])
	REFERENCES [dbo].[site] ([site_id])

	ALTER TABLE [dbo].[client_token] CHECK CONSTRAINT [FK_client_token_site]
END
GO
----------------------------------------------------------------------------------------------------------------------------------
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
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO client_token(name, email, token, site_id, created, enabled, modified)
	VALUES (@name, @email, @token, @siteId, @created, @enabled, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddClientToken TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
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
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
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
	modified = @modified
	WHERE client_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateClientToken TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_DeleteClientToken'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_DeleteClientToken
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM client_token
	WHERE client_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_DeleteClientToken TO VpWebApp 
Go
----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetClientTokenDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetClientTokenDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT client_token_id AS id, name, email, token, site_id, created, enabled, modified
	FROM client_token
	WHERE client_token_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
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
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	WITH clientTokens AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY client_token_id) AS row, client_token_id AS id, name, email, 
				token, site_id, created, enabled, modified
		FROM client_token
		WHERE site_id = @siteId
	)

	SELECT id, name, email, token, site_id, created, enabled, modified
	FROM clientTokens
	WHERE row BETWEEN @startIndex AND @endIndex
	
	SELECT @totalCount = COUNT(client_token_id)
	FROM client_token
	WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenBySiteIdWithPaging TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------------
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
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT client_token_id AS id, name, email, token, site_id, created, enabled, modified
	FROM client_token
	WHERE site_id = @siteId AND token = @token

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetClientTokenByTokenSiteId TO VpWebApp 
GO----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNewSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNewSpecificationList
	@specTypeId INT,
	@timeStamp SMALLDATETIME,
	@startIndex INT,
	@endIndex INT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT * FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY [modified] ASC) AS row, 
			[specification_id] AS id
			,[content_id]
			,[spec_type_id]
			,[specification]
			,[enabled]
			,[modified]
			,[created]
			,[content_type_id]
			,[display_options]
			,[sort_order]
		FROM specification
		WHERE content_type_id = 2 
			AND [enabled] = 1
			AND spec_type_id = @specTypeId
			AND modified >= @timeStamp
	) specification
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row 
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebApp 
GO

--------------------------------------------------------------------------------------------------------
--
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[citation]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[citation](
		citation_id INT IDENTITY(1,1) NOT NULL,
		product_id INT NOT NULL,
		title VARCHAR(1000) NOT NULL,
		journal_name VARCHAR(MAX) NOT NULL,
		published_date SMALLDATETIME NOT NULL,
		scrazzl_url VARCHAR(800) NOT NULL,
		article_url VARCHAR(800) NOT NULL,
		doi VARCHAR(255) NOT NULL,
		enabled BIT NOT NULL,
		created SMALLDATETIME NOT NULL,
		modified SMALLDATETIME NOT NULL
	 CONSTRAINT [PK_citation] PRIMARY KEY CLUSTERED 
	(
		[citation_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[citation]  WITH CHECK ADD CONSTRAINT [FK_citation_product] FOREIGN KEY([product_id])
	REFERENCES [dbo].[product] ([product_id])

	ALTER TABLE [dbo].[citation] CHECK CONSTRAINT [FK_citation_product]
END
GO


----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[specification]') AND name = N'IX_content_specification_enabled_modified')
DROP INDEX [IX_content_specification_enabled_modified] ON [dbo].[specification] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_content_specification_enabled_modified] ON [dbo].[specification] 
(
	[spec_type_id] ASC,
	[enabled] ASC,
	[content_type_id] ASC,
	[modified] ASC
)
INCLUDE ( [specification_id],
[content_id],
[specification],
[created],
[display_options],
[sort_order]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_AddCitation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_AddCitation
	@productId int,
	@title varchar(1000),
	@journalName varchar(max),
	@publishedDate smalldatetime,
	@scrazzlUrl varchar(800),
	@articleUrl varchar(800),
	@doi VARCHAR(255),
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO citation(product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, enabled, created, modified)
	VALUES (@productId, @title, @journalName, @publishedDate, @scrazzlUrl, @articleUrl, @doi, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminCitation_AddCitation TO VpWebApp 
GO

GO

------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_UpdateCitation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_UpdateCitation
	@id int,
	@productId int,
	@title varchar(1000),
	@journalName varchar(max),
	@publishedDate smalldatetime,
	@scrazzlUrl varchar(800),
	@articleUrl varchar(800),
	@doi VARCHAR(255),
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE citation
	SET product_id = @productId, 
	title = @title, 
	journal_name = @journalName, 
	published_date = @publishedDate, 
	scrazzl_url = @scrazzlUrl, 
	article_url = @articleUrl,
	doi = @doi,
	enabled = @enabled,
	modified = @modified
	WHERE citation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCitation_UpdateCitation TO VpWebApp 
GO

---------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified
	FROM citation
	WHERE citation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationDetail TO VpWebApp 
GO

--------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_DeleteCitation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_DeleteCitation
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM citation
	WHERE citation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCitation_DeleteCitation TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationByProductIdDoi'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationByProductIdDoi
	@productId INT,
	@doi VARCHAR(255)
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified
	FROM citation
	WHERE product_id = @productId
		AND doi = @doi

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDoi TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNewSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNewSpecificationList
	@specTypeId INT,
	@timeStamp SMALLDATETIME,
	@startIndex INT,
	@endIndex INT,
	@totalCount INT OUT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT * FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY [modified] ASC) AS row, 
			[specification_id] AS id
			,[content_id]
			,[spec_type_id]
			,[specification]
			,[enabled]
			,[modified]
			,[created]
			,[content_type_id]
			,[display_options]
			,[sort_order]
		FROM specification
		WHERE content_type_id = 2 
			AND [enabled] = 1
			AND spec_type_id = @specTypeId
			AND modified >= @timeStamp
	) specification
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

	SELECT @totalCount = COUNT(*) 
	FROM specification
	WHERE content_type_id = 2 
		AND [enabled] = 1
		AND spec_type_id = @specTypeId
		AND modified >= @timeStamp
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebApp 
GO
