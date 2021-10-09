--==== adminArchivedProduct_GetArchivedProductsPageList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductsPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductsPageList
	@vendorId int = -1,
	@catalogNumber varchar(255) = '',
	@productName varchar(255) = '',
	@categoryId int = 0,
	@startIndex int,
	@endIndex int,
	@totalCount int OUTPUT

AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY Tmp.id) AS row , Tmp.id AS id
	INTO #temp
	FROM
	(
		SELECT DISTINCT ar.archived_product_id AS id
		FROM [dbo].[archived_product] ar WITH(NOLOCK) 
			 LEFT	JOIN dbo.archived_product_to_category arp ON arp.archived_product_id = ar.archived_product_id
		WHERE (@vendorId = -1 OR ar.vendor_id = @vendorId)
		AND (@catalogNumber = '' OR ar.catalog_number LIKE '%'+ @catalogNumber + '%')
		AND (@productName = '' OR ar.product_name LIKE '%'+ @productName +'%')
		AND (@categoryId = 0 OR (arp.category_id = @categoryId))
	)Tmp
	
	SELECT ap.[archived_product_id] as Id
		  ,ap.[product_id]
		  ,ap.[site_id]
		  ,ap.[vendor_id]
		  ,ap.[catalog_number]
		  ,ap.[product_name]
		  ,ap.[modified]
		  ,ap.[created]
		  ,ap.[is_restore]
		  ,ap.is_restore_error
		  , CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product] as ap with(nolock) 
	INNER JOIN  #temp ON #temp.id = ap.archived_product_id
	WHERE #temp.row BETWEEN @startIndex AND @endIndex;
	
	SELECT @totalCount = COUNT(*) FROM #temp;
END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsPageList TO VpWebApp 
GO


--==== adminArticle_UpdateArticleArchiveStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleArchiveStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleArchiveStatus
@articleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE	art
	SET		art.archived = 1
	FROM	article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
												  AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
	WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO

--===== adminArticle_UpdateArticleArchiveStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleArchiveStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleArchiveStatus
@articleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE dbo.article SET archived = 0 WHERE article_id = @articleId
	
	UPDATE	art
	SET		art.archived = 1
	FROM	article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
												  AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
	WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND rt.review_type_id IS NULL --non review type
			AND art.is_article_template = 0	--non default article
		    AND	(art.start_date IS NULL OR art.start_date < GETDATE()) --future start date run date
			AND cp.content_parameter_id IS NOT NULL --disabled date parameter type

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO



--===== adminProduct_UpdateProductContentModifiedStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductContentModifiedStatus
	@productList VARCHAR(max),
	@contentModofied BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE p
	SET   p.content_modified = @contentModofied,
		p.search_content_modified = @contentModofied
	FROM [product] p
		INNER JOIN dbo.global_Split(@productList, ',') gs
		ON p.product_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductContentModifiedStatus TO VpWebApp 
GO


