EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorsByArticleId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicArticle_GetAuthorsByArticleId]
	@articleId int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT aut.author_id as id, aut.site_id, aut.first_name, aut.last_name, aut.title, aut.organization
			, aut.position, aut.department, aut.profile_html, aut.enabled, aut.created, aut.modified
			, aut.has_image, aut.email, aut.country_id, ata.verified
	FROM author aut
		INNER JOIN article_to_author ata
			ON ata.author_id= aut.author_id 
	
	WHERE ata.article_id = @articleId
	ORDER BY ata.article_to_author_id 

END
GO
GRANT EXECUTE ON dbo.publicArticle_GetAuthorsByArticleId TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddArticleToAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArticle_AddArticleToAuthor]
	@articleId int,
	@authorId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@giftCardId varchar(255),
	@verified bit
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO article_to_author(article_id, author_id, [enabled], created, modified,gift_card_id, verified)
	VALUES (@articleId, @authorId, @enabled, @created, @created ,@giftCardId, @verified)

	SET @id = SCOPE_IDENTITY()

END
GO
GRANT EXECUTE ON dbo.adminArticle_AddArticleToAuthor TO VpWebApp 
GO

GO

---------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorByArticleIdAuthorId'
GO
CREATE PROCEDURE [adminArticle_GetAuthorByArticleIdAuthorId]
@articleId int,@authorId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

SELECT [article_to_author_id] as id
      ,[article_id]
      ,[author_id]
      ,[enabled]
      ,[created]
      ,[modified]
      ,[gift_card_id]
      ,[verified]
  FROM [article_to_author]
  WHERE article_id =@articleId AND author_id = @authorId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorByArticleIdAuthorId TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsByArticleId'
GO
CREATE PROCEDURE [adminArticle_GetAuthorsByArticleId]
@articleId int
	
AS
-- ==========================================================================
-- $Author: Eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

SELECT [article_to_author_id] as id
      ,[article_id]
      ,[author_id]
      ,[enabled]
      ,[created]
      ,[modified]
      ,[gift_card_id]
      ,[verified]
  FROM [article_to_author]
  WHERE article_id =@articleId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsByArticleId TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleToAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleToAuthor
	@id int,
	@articleId int,
	@authorId int,
	@enabled bit,	
	@modified smalldatetime output,
	@giftCardId varchar(255),
	@verified bit
	
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	
	UPDATE article_to_author
		SET article_id = @articleId,
			author_id = @authorId,
			enabled = @enabled,
			modified = @modified,
			gift_card_id = @giftCardId,
			verified = @verified
	WHERE article_to_author_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleToAuthor TO VpWebApp 
GO

--------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleToAuthorDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicArticle_GetArticleToAuthorDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT article_to_author_id as id, article_id, author_id, enabled, created, modified, gift_card_id, verified
	FROM article_to_author	
	WHERE article_to_author_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleToAuthorDetail TO VpWebApp 

--------------------------------------------------------------------------------------------------------