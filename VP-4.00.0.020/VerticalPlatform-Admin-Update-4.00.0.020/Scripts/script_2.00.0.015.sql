EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_GetArchivedArticlesFiltered';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE dbo.adminArchivedArticle_GetArchivedArticlesFiltered
    @siteId INT = NULL,
    @articleTypeId INT = -1,
    @title VARCHAR(1000) = NULL,
    @author VARCHAR(MAX) = NULL,
    @pageStart INT = NULL,
    @pageEnd INT = NULL,
    @totalCount INT OUTPUT
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN

    SELECT ROW_NUMBER() OVER (ORDER BY archived_article_id desc) AS row,
           archived_article_id AS id
    INTO #temp_archived_article
    FROM archived_article WITH (NOLOCK)
    WHERE ( @siteId IS NULL OR site_id = @siteId)
          AND ( @articleTypeId = -1 OR article_type_id = @articleTypeId )
          AND ( @title IS NULL OR title LIKE '%' + @title + '%' )
          AND ( @author IS NULL OR authors LIKE '%' + @author + '%' );

    SELECT tmp.id,
           article_id,
           site_id,
           title,
           authors,
           article_type_id,
           modified,
           created,
           is_restore,
		   is_restore_error
    FROM archived_article aa
    INNER JOIN #temp_archived_article tmp ON aa.archived_article_id = tmp.id
    WHERE tmp.row BETWEEN @pageStart AND @pageEnd;

    SELECT @totalCount = COUNT(1)
    FROM #temp_archived_article;

END;
GO

GRANT EXECUTE
ON dbo.adminArchivedArticle_GetArchivedArticlesFiltered
TO  VpWebApp;
GO


------------------------adminArchivedProduct_GetArchivedProductsPageList--------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductsPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductsPageList
	@vendorId int = -1,
	@catalogNumber varchar(255) = '',
	@productName varchar(255) = '',
	@productId int = -1,
	@categoryId int = 0,
	@siteId int = 0,
	@startIndex int,
	@endIndex int,
	@totalCount int OUTPUT

AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY Tmp.id desc) AS row , Tmp.id AS id
	INTO #temp
	FROM
	(
		SELECT DISTINCT ar.archived_product_id AS id
		FROM [dbo].[archived_product] ar WITH(NOLOCK) 
			LEFT JOIN dbo.archived_product_to_category arp ON arp.archived_product_id = ar.archived_product_id 
		WHERE (@vendorId = -1 OR ar.vendor_id = @vendorId)
		AND (@productId = -1 OR ar.product_id = @productId)
		AND (@catalogNumber = '' OR ar.catalog_number LIKE '%'+ @catalogNumber + '%')
		AND (@productName = '' OR ar.product_name LIKE '%'+ @productName +'%')
		AND (@categoryId = 0 OR (arp.category_id = @categoryId))
		AND (@siteId = 0 OR ar.site_id = @siteId)
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
		  ,ap.restore_disabled
		  , CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product] as ap with(nolock) 
	INNER JOIN  #temp ON #temp.id = ap.archived_product_id
	WHERE #temp.row BETWEEN @startIndex AND @endIndex;
	
	SELECT @totalCount = COUNT(*) FROM #temp;
END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsPageList TO VpWebApp 
GO


--==== adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts]
	@siteId int,
	@batchSize int,
	@totalCount int OUTPUT
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON
	
	UPDATE TOP(@batchSize) pro 
	SET pro.search_content_modified = 0
		,pro.modified = GETDATE()
	FROM	dbo.product pro WITH(NOLOCK)
	LEFT JOIN search_content_status scs WITH(NOLOCK) ON scs.content_id = pro.product_id AND scs.content_type_id = 2
	WHERE scs.search_content_status_id IS NULL
	AND pro.site_id = @siteId
	AND	pro.enabled = 0
	AND pro.search_content_modified = 1

	SET @totalCount = @@ROWCOUNT

END

GO

GRANT EXECUTE ON dbo.adminSearch_UpdateSearchContentStatusUnIndexedDisabledProducts TO VpWebApp 
GO


