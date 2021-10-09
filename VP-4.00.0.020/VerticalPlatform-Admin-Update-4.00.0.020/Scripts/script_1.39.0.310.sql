ALTER TABLE citation
ALTER COLUMN scrazzl_url VARCHAR(800) NULL

ALTER TABLE citation
ALTER COLUMN journal_name VARCHAR(MAX) NULL

ALTER TABLE citation
ALTER COLUMN doi VARCHAR(255) NULL

IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'pubmed_url' AND Object_ID = Object_ID(N'citation'))
BEGIN
    ALTER TABLE citation
    ADD pubmed_url VARCHAR(800) NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'pubmed_id' AND Object_ID = Object_ID(N'citation'))
BEGIN
    ALTER TABLE citation
    ADD pubmed_id VARCHAR(255) NULL
END

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
	@pubmedUrl varchar(800),
	@pubmedId VARCHAR(255),
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO citation(product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, enabled, created, modified, authors, pubmed_url, pubmed_id)
	VALUES (@productId, @title, @journalName, @publishedDate, @scrazzlUrl, @articleUrl, @doi, @enabled, @created, @created, @authors, @pubmedUrl, @pubmedId)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminCitation_AddCitation TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_AddCitation TO VpWebAPI
GO

--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationByProductId
	@productId INT
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified, authors, pubmed_url, pubmed_id
	FROM citation
	WHERE product_id = @productId

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductId TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductId TO VpWebAPI
GO

--------------------------------------------------------------------------------------------

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
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified, authors, pubmed_url, pubmed_id
	FROM citation
	WHERE product_id = @productId
		AND doi = @doi

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDoi TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDoi TO VpWebAPI
GO

-------------------------------------------------------------------------------------------

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
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified, authors, pubmed_url, pubmed_id
	FROM citation
	WHERE citation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationDetail TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationDetail TO VpWebAPI
GO



-------------------------------------------------------------------------------------------

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
	@pubmedUrl VARCHAR(800),
	@pubmedId VARCHAR(255),
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
	modified = @modified,
	authors = @authors,
	pubmed_url = @pubmedUrl,
	pubmed_id = @pubmedId
	WHERE citation_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCitation_UpdateCitation TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_UpdateCitation TO VpWebAPI
GO

----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetNewSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetNewSpecificationList
	@specTypeIds VARCHAR(100),
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
	
	SELECT content_id
	INTO #ContentIds
	FROM (
		SELECT DISTINCT content_id, DENSE_RANK() OVER (ORDER BY [modified], [content_id] ASC) AS row
		FROM specification
		INNER JOIN dbo.global_Split(@specTypeIds, ',') gs
			ON specification.spec_type_id = gs.[value]
		WHERE content_type_id = 2 
			AND [enabled] = 1
			AND modified >= @timeStamp
	) specification
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

	SELECT [specification_id] AS id
		,s.[content_id]
		,[spec_type_id]
		,[specification]
		,[enabled]
		,[modified]
		,[created]
		,[content_type_id]
		,[display_options]
		,[sort_order]
	FROM specification s
	INNER JOIN #ContentIds cids
		ON s.content_id = cids.content_id
	INNER JOIN dbo.global_Split(@specTypeIds, ',') gs
		ON s.spec_type_id = gs.[value]
	WHERE content_type_id = 2 
	ORDER BY s.content_id
		
	DROP TABLE #ContentIds

	SELECT @totalCount = COUNT(DISTINCT content_id) 
	FROM specification
	INNER JOIN dbo.global_Split(@specTypeIds, ',') gs
			ON specification.spec_type_id = gs.[value]
	WHERE content_type_id = 2 
		AND [enabled] = 1
		AND modified >= @timeStamp
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebApp
GRANT EXECUTE ON dbo.publicProduct_GetNewSpecificationList TO VpWebAPI
GO

-------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationByProductIdDoi'

EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationByProductIdDoiPubMedId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationByProductIdDoiPubMedId
	@productId INT,
	@doi VARCHAR(255),
	@pubMedId VARCHAR(255)
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT citation_id AS id, product_id, title, journal_name, published_date, scrazzl_url, article_url, doi, created, enabled, modified, authors, pubmed_url, pubmed_id
	FROM citation
	WHERE product_id = @productId
		AND (doi = @doi OR pubmed_id = @pubMedId)

END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDoiPubMedId TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDoiPubMedId TO VpWebAPI
GO
