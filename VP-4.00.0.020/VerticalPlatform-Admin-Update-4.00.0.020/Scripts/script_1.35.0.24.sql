IF EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'definition' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].review_type') AND type in (N'U'))
)
BEGIN
	ALTER TABLE review_type
	DROP COLUMN definition
END
GO
-----------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'sort_order' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].review_type') AND type in (N'U'))
)
BEGIN
	ALTER TABLE review_type
	ADD sort_order int NOT NULL DEFAULT(0)
END
GO
-------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_AddReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_AddReviewType]
	@id int output,
	@siteId int,
	@articleTypeId int,
	@sortOrder int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@hasImage bit,
	@created smalldatetime output,	
	@description varchar(MAX)
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [review_type] (site_id, article_type_id, name, title, [enabled], modified, created, has_image, [description],[sort_order])
	VALUES (@siteId, @articleTypeId, @name, @title, @enabled, @created, @created, @hasImage, @description, @sortOrder)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminReviewType_AddReviewType TO VpWebApp 
GO
-----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_UpdateReviewType'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_UpdateReviewType]
	@id int,
	@siteId int,
	@articleTypeId int,
	@sortOrder int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@hasImage bit,	
	@description varchar(MAX)
	 
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[review_type]
	SET site_id = @siteId,
		article_type_id = @articleTypeId,
		[name] = @name,
		title = @title,
		[enabled] = @enabled,		
		modified = @modified,
		has_image = @hasImage,
		[sort_order] = @sortOrder,
		[description] = @description
	WHERE review_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminReviewType_UpdateReviewType TO VpWebApp 
GO
----------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicReviewType_GetReviewTypeDetail]
@id int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[sort_order]
	FROM [review_type]	
	WHERE review_type_id = @id 

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetail TO VpWebApp 
GO
-------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteId
@siteId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[sort_order]
	FROM [review_type]	
	WHERE site_id = @siteId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteId TO VpWebApp 
GO
---------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId
@siteId int,@articleTypeId int
	
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT review_type_id as id, site_id, article_type_id, [name], title, enabled, created, modified, [has_image], [description],[sort_order]
	FROM [review_type]	
	WHERE site_id = @siteId AND article_type_id = @articleTypeId
	ORDER BY sort_order ASC

END
GO
GRANT EXECUTE ON dbo.publicReviewType_GetReviewTypeDetailBySiteIdArticleTypeId TO VpWebApp 
GO
-----------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminReviewType_GetReviewTypeBySiteIdPageList'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminReviewType_GetReviewTypeBySiteIdPageList]
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Nilanka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM review_type
	WHERE site_id = @siteId;

	WITH temp_review_type (row, id, site_id, article_type_id, name, title, [enabled], created, modified, has_image, [description],[sort_order]) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY sort_order ASC) AS row, review_type_id as id, site_id, article_type_id, name, title, [enabled], created, modified, has_image, [description],[sort_order]
		FROM review_type
		WHERE site_id = @siteId
	)

	SELECT id, site_id, article_type_id, name, title, [enabled], created, modified, has_image, [description],[sort_order]
	FROM temp_review_type
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO
GRANT EXECUTE ON dbo.adminReviewType_GetReviewTypeBySiteIdPageList TO VpWebApp 
GO
--------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetSalutaionBySalutaionText'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetSalutaionBySalutaionText
	@salutaionText NVARCHAR(MAX)

AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [salutation_id] AS id,[salutation],[enabled],[modified],[created],[sort_order]
	FROM [salutation]
	WHERE [salutation] = @salutaionText

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetSalutaionBySalutaionText TO VpWebApp 
GO
--------------------------------------------------------------