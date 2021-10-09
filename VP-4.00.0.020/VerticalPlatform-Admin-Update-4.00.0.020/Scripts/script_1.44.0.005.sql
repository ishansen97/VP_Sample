--=========== publicArticle_GetArticlesByArticleIds

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticlesByArticleIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticlesByArticleIds
@articleIdList VARCHAR(MAX)
	
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_id] AS [Id],[article_type_id],[site_id],[article_title],[article_sub_title],[article_summary],[enabled],[modified],[created],[article_short_title]
      ,[is_article_template],[is_external],[featured_identifier],[thumbnail_image_code],[date_published],[external_url_id],[is_template]
      ,[article_template_id],[open_new_window],[end_date],[flag1],[flag2],[flag3],[flag4],[published],[start_date],[search_content_modified], [deleted], exclude_from_search
	FROM [article] a
		INNER JOIN global_split(@articleIdList, ',') AS articleIdList
			ON a.[article_id] = articleIdList.[value]

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticlesByArticleIds TO VpWebApp 

--=========== publicArticle_GetArticleByArticleIdList

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetArticleByArticleIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetArticleByArticleIdList
@articleIdList VARCHAR(MAX)
	
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [article_id] AS [Id],[article_type_id],[site_id],[article_title],[article_sub_title],[article_summary],[enabled],[modified],[created],[article_short_title]
      ,[is_article_template],[is_external],[featured_identifier],[thumbnail_image_code],[date_published],[external_url_id],[is_template]
      ,[article_template_id],[open_new_window],[end_date],[flag1],[flag2],[flag3],[flag4],[published],[start_date],[search_content_modified], [deleted], exclude_from_search
	FROM [article] a
		INNER JOIN global_split(@articleIdList, ',') AS articleIdList
			ON a.[article_id] = articleIdList.[value]
	WHERE a.[deleted] = 0

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetArticleByArticleIdList TO VpWebApp 


--===== adminArticle_GetArchivingArticleIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArchivingArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArchivingArticleIdsList
@limit INT = 10
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) art.article_id AS [id]
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	ISNULL(art.start_date,'1970-01-01') < GETDATE()   --future start date run date
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
	ORDER BY art.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO

--===== adminArticle_ResetNonArchivableArticles

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_ResetNonArchivableArticles'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_ResetNonArchivableArticles
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE art
	SET art.archived = 0
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
	WHERE	art.archived = 1 
			AND	art.search_content_modified = 0
			AND  ( rt.review_type_id IS NOT NULL --review type
				OR art.is_article_template = 1	--default article
				OR	ISNULL(art.start_date,'1970-01-01') > GETDATE() --future start date run date
				OR art.enabled = 1
				OR	art.published = 1
				)   
			
END
GO

GRANT EXECUTE ON dbo.adminArticle_ResetNonArchivableArticles TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArchivedByArtcle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArchivedByArtcle
	@last_rundate DATETIME
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE	art
	SET		art.archived = 1
	FROM	article art
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
												  AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
	WHERE	art.modified > @last_rundate
			AND art.enabled = 0
			AND art.published = 0
			AND cp.content_parameter_id IS NOT NULL
			AND art.archived = 0
	
END
GO

GRANT EXECUTE ON adminArticle_UpdateArchivedByArtcle TO VpWebApp
GO

--===== adminArticle_ResetNonArchivableArticles

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_ResetNonArchivableArticles'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_ResetNonArchivableArticles
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE art
	SET art.archived = 0
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
	WHERE	art.archived = 1 
			AND	art.search_content_modified = 0
			AND  ( rt.review_type_id IS NOT NULL --review type
				OR art.is_article_template = 1	--default article
				OR	(art.start_date IS NULL OR art.start_date > GETDATE())  --future start date run date
				OR art.enabled = 1
				OR	art.published = 1
				)   
			
END
GO

GRANT EXECUTE ON dbo.adminArticle_ResetNonArchivableArticles TO VpWebApp
GO


--===== adminArticle_GetArchivingArticleIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArchivingArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArchivingArticleIdsList
@limit INT = 10
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) art.article_id AS [id]
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
	ORDER BY art.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RestoreProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_RestoreProduct
	@productId int,
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@created DATETIME,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank float,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank float
	
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET IDENTITY_INSERT [product] ON
	DECLARE @modified AS DATETIME = GETDATE()
	INSERT INTO product(product_id, site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank) 
	VALUES (@productId,@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @modified, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue,@ignoreInRapid, @showInMatrix, @showDetailPage, @defaultRank, @defaultSearchRank) 

	SET IDENTITY_INSERT [product] OFF

END

GO

GRANT EXECUTE ON dbo.adminProduct_RestoreProduct TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetRestoreProductIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetRestoreProductIds
@limit INT = 10
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) [product_id] AS [id]
	FROM archived_product 
	WHERE is_restore = 1 AND is_restore_error = 0
	ORDER BY product_id

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetRestoreProductIds TO VpWebApp
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_ChangeIsErrorStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_ChangeIsErrorStatus
@productIds VARCHAR(MAX),
@errorStatus BIT
AS
-- ==========================================================================
-- Author : Chirath
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE p 
	SET p.is_restore_error = @errorStatus
	FROM [archived_product] p
	INNER JOIN dbo.global_Split(@productIds, ',') gs
		ON p.product_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_ChangeIsErrorStatus TO VpWebApp
GO

