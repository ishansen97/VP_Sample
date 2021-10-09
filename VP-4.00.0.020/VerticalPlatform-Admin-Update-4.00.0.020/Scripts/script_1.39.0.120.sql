IF NOT EXISTS (SELECT * FROM module m WHERE m.module_name = 'Citations')
BEGIN
	INSERT INTO [module]
			([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES
			('Citations','~/Modules/Citations/Citations.ascx',1,GETDATE(),GETDATE(),0)
END
--------------------------------------------------------------------------------------------------
DELETE FROM [citation]
--------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT [name] FROM syscolumns where [name] = 'authors' AND id = (SELECT object_id FROM sys.objects WHERE object_id = OBJECT_ID(N'citation') AND type in (N'U')))
BEGIN
	ALTER TABLE [citation]
	ADD authors varchar(max) NOT NULL
END
GO
--------------------------------------------------------------------------------------------------
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
	@authors varchar(max),
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO citation(product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, enabled, created, modified, authors)
	VALUES (@productId, @title, @journalName, @publishedDate, @scrazzlUrl, @articleUrl, @doi, @enabled, @created, @created, @authors)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminCitation_AddCitation TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_AddCitation TO VpWebAPI
GO

GO
--------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified, authors
	FROM citation
	WHERE citation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationDetail TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationDetail TO VpWebAPI
GO
--------------------------------------------------------------------------------------------------
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
	@authors varchar(max),
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
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
	modified = @modified,
	authors = @authors
	WHERE citation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCitation_UpdateCitation TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_UpdateCitation TO VpWebAPI
GO
--------------------------------------------------------------------------------------------------
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
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified, authors
	FROM citation
	WHERE product_id = @productId
		AND doi = @doi

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDoi TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDoi TO VpWebAPI
GO
--------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationByProductIdDuration'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationByProductIdDuration
	@productId INT,
	@duration INT
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [citation_id] AS [id],[product_id],[title],[journal_name],[published_date]
			,[scrazzl_url],[article_url],[doi],[enabled],[created],[modified],[authors]
	FROM [citation]
	WHERE product_id = @productId AND created >= DATEADD(MONTH, (-1 * @duration), GETDATE())

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDuration TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDuration TO VpWebAPI
GO
--------------------------------------------------------------------------------------------------

INSERT INTO parameter_type
(
	parameter_type_id,
	parameter_type,
	[enabled],
	modified,
	created
)
VALUES
(
	191,
	'ShowSearchText',
	1,
	GETDATE(),
	GETDATE()
)