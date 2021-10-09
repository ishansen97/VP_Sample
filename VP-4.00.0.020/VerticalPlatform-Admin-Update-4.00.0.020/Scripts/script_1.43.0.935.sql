---------- Create authour_type table ----------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[author_type](
	[author_type_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[author_type] [varchar](50) NOT NULL,
	[enabled] [bit] NOT NULL,
	[modified] [smalldatetime] NOT NULL,
	[created] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_author_types] PRIMARY KEY CLUSTERED 
(
	[author_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[author_type] ADD  CONSTRAINT [DF_author_types_enabled]  DEFAULT ((1)) FOR [enabled]
GO

ALTER TABLE [dbo].[author_type] ADD  CONSTRAINT [DF_author_types_modified]  DEFAULT (getutcdate()) FOR [modified]
GO

ALTER TABLE [dbo].[author_type] ADD  CONSTRAINT [DF_author_types_created]  DEFAULT (getutcdate()) FOR [created]
GO




---------- Populate authour_type table ----------
INSERT INTO [dbo].[author_type]
           ([author_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           ('None'
           ,1
           ,getdate()
           ,getdate()
		   )
GO
INSERT INTO [dbo].[author_type]
           ([author_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           ('Author'
           ,1
           ,getdate()
           ,getdate()
		   )
GO
INSERT INTO [dbo].[author_type]
           ([author_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           ('Speaker'
           ,1
           ,getdate()
           ,getdate()
		   )
GO
INSERT INTO [dbo].[author_type]
           ([author_type]
           ,[enabled]
           ,[modified]
           ,[created])
     VALUES
           ('Reviewer'
           ,1
           ,getdate()
           ,getdate()
		   )
GO




---------- Alter author table ----------
ALTER TABLE [dbo].[author]
ADD degree varchar(255);

ALTER TABLE [dbo].[author]
ADD speaker_title varchar(255);

ALTER TABLE [dbo].[author]
ADD author_type_id [int] NOT NULL 
DEFAULT (1);

ALTER TABLE [dbo].[author]  WITH NOCHECK ADD  CONSTRAINT [FK_author_author_type] FOREIGN KEY([author_type_id])
REFERENCES [dbo].[author_type] ([author_type_id])
GO

ALTER TABLE [dbo].[author] CHECK CONSTRAINT [FK_author_author_type]
GO





---------- adminArticle_AddAuthor ----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_AddAuthor]
	@siteId int,
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@organization varchar(250),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@email varchar(255),
	@countryId int,
	@degree varchar(255),
	@speakerTitle varchar(255),
	@authorType int
AS
-- ==========================================================================
-- $Author: Dulip $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO author(site_id, first_name, last_name, title, organization, position, department, profile_html, [enabled],
		created, modified, has_image, email, country_id, degree, speaker_title, author_type_id)
	VALUES(@siteId, @firstName, @lastName, @title, @organization, @position, @department, @profileHtml, @enabled,
		@created, @created, @hasImage, @email, @countryId, @degree, @speakerTitle, @authorType)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddAuthor TO VpWebApp 
GO

GO



---------- adminArticle_UpdateAuthor ----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_UpdateAuthor]
	@id int,
	@siteId int, 
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@organization varchar(250),	
	@modified smalldatetime output,
	@email varchar(255),
	@countryId int,
	@degree varchar(255),
	@speakerTitle varchar(255),
	@authorType int
AS
-- ==========================================================================
-- $Author: Dulip $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.author
	SET site_id = @siteId,
		first_name =@firstName,
		last_name = @lastName,
		title = @title,
		position = @position,
		department = @department, 
		profile_html = @profileHtml, 
		enabled = @enabled,
		organization = @organization,
		modified = @modified,
		has_image = @hasImage,
		email = @email,
		country_id = @countryId,
		degree = @degree,
		speaker_title = @speakerTitle,
		author_type_id = @authorType
	WHERE author_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateAuthor TO VpWebApp 
GO




---------- publicArticle_GetAuthorDetail ----------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicArticle_GetAuthorDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, department, profile_html, has_image,
		enabled, created, modified, email, country_id, degree, speaker_title, author_type_id
	FROM author	
	WHERE author_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetAuthorDetail TO VpWebApp 
GO




---------- adminArticle_GetAuthorsBySiteId ----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsBySiteId]
	@siteId int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, enabled, created, modified, has_image, email, country_id,
			degree, speaker_title, author_type_id
	FROM author
	WHERE site_id = @siteId
	ORDER BY  first_name, last_name

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteId TO VpWebApp 
GO




---------- adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList ----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList]
	@siteId int,
	@authorId int = NULL,
	@firstName varchar(100) = NULL,
	@lastName varchar(100)	= NULL,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH AuthorList AS
	(
		SELECT author_id as id, site_id, first_name, last_name, title, organization, position, has_image, email, country_id,
				department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id,
				degree, speaker_title, author_type_id
		FROM author
		WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')
	)

	SELECT id, site_id, first_name, last_name, title, organization, position, department, profile_html,
		enabled, created, modified, has_image, email, country_id, degree, speaker_title, author_type_id
	FROM AuthorList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(*)
	FROM author
	WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList TO VpWebApp 
GO




---------- adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList ----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList]  
 @siteId int,  
 @startRowIndex int,  
 @endRowIndex int,  
 @totalRowCount int output  
AS  
-- ==========================================================================  
-- $Author: Dulip $  
-- ==========================================================================  
BEGIN  
   
 SET NOCOUNT ON;  
  
 WITH AuthorList AS  
 (  
  SELECT author_id as id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id,
	has_image, email, country_id, degree, speaker_title, author_type_id
  FROM author  
  WHERE site_id = @siteId   
 )  
  
 SELECT id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, has_image, email, country_id, degree, speaker_title, author_type_id
 FROM AuthorList  
 WHERE row_id BETWEEN @startRowIndex AND @endRowIndex  
  
 SELECT @totalRowCount = COUNT(*)  
 FROM author  
 WHERE site_id = @siteId   
  
END  
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList TO VpWebApp 
GO




---------- adminArticle_GetAuthorByEmail ----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorByEmail'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetAuthorByEmail
	@authorEmail varchar(MAX)	
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SELECT [author_id] AS [id], [site_id], [first_name], [last_name], [title], [organization], [position], [department]
      , [enabled], [created], [modified], [profile_html], [has_image], [email], [country_id], degree, speaker_title, author_type_id
	FROM [author]
	WHERE [email] = @authorEmail AND [enabled] = 1

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorByEmail TO VpWebApp
GO




---------- publicArticle_GetAuthorsByArticleId ----------
EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorsByArticleId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicArticle_GetAuthorsByArticleId]
	@articleId int
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT aut.author_id as id, aut.site_id, aut.first_name, aut.last_name, aut.title, aut.organization
			, aut.position, aut.department, aut.profile_html, aut.enabled, aut.created, aut.modified
			, aut.has_image, aut.email, aut.country_id, aut.degree, aut.speaker_title, aut.author_type_id, ata.verified
	FROM author aut
		INNER JOIN article_to_author ata
			ON ata.author_id= aut.author_id 
	
	WHERE ata.article_id = @articleId
	ORDER BY ata.article_to_author_id 

END
GO
GRANT EXECUTE ON dbo.publicArticle_GetAuthorsByArticleId TO VpWebApp 
GO



---------- adminArticle_GetAuthorInformationsByArticleIdsList ----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorInformationsByArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_GetAuthorInformationsByArticleIdsList]
	@articleIds varchar(max)
AS
-- ==========================================================================
-- $Author: Dulip
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, a.enabled, a.created, a.modified, aa.article_id,
			a.has_image, a.email, a.country_id, a.degree, a.speaker_title, a.author_type_id
	FROM author a
		INNER JOIN article_to_author aa ON  a.author_id = aa.author_id
	WHERE aa.article_id IN (SELECT [value] FROM Global_Split(@articleIds, ',') )

END
GO
GRANT EXECUTE ON dbo.adminArticle_GetAuthorInformationsByArticleIdsList TO VpWebApp 
GO

