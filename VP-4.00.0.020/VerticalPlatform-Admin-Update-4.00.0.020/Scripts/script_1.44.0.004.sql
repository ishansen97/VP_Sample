--======= temp_product_to_vendor_to_price

IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS  
                 WHERE CONSTRAINT_NAME ='FK_temp_product_to_vendor_to_price_product_to_vendor'))
BEGIN
    ALTER TABLE temp_product_to_vendor_to_price
	DROP CONSTRAINT FK_temp_product_to_vendor_to_price_product_to_vendor;
END


--====== archived_product

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'is_restore_error'
          AND Object_ID = Object_ID(N'archived_product'))
BEGIN
    ALTER TABLE archived_product
	ADD is_restore_error BIT NOT NULL DEFAULT 0;
END

GO

--===== archived_article.author_id

IF EXISTS (
  SELECT 1 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[archived_article]') 
         AND name = 'author_id'
)
BEGIN

	ALTER TABLE archived_article ALTER COLUMN author_id VARCHAR(MAX);
	EXEC sp_RENAME 'archived_article.author_id' , 'authors', 'COLUMN';

END


--====== archived_article.is_restore_error

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'is_restore_error'
          AND Object_ID = Object_ID(N'archived_article'))
BEGIN
    ALTER TABLE archived_article
	ADD is_restore_error BIT NOT NULL DEFAULT 0;
END

GO


--===== archived_product_to_category table

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='archived_product_to_category' AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[archived_product_to_category](
		[archived_product_to_category_id] [int] IDENTITY(1,1) NOT NULL,
		archived_product_id INT NOT NULL,
		category_id INT NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL
	 CONSTRAINT [archived_product_to_category_id] PRIMARY KEY CLUSTERED 
	(
		[archived_product_to_category_id] ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY];

	ALTER TABLE [dbo].[archived_product_to_category]  WITH CHECK ADD  CONSTRAINT [FK_archived_product_category_archived_product] FOREIGN KEY([archived_product_id])
	REFERENCES [dbo].archived_product ([archived_product_id]);

	ALTER TABLE [dbo].[archived_product_to_category]  WITH CHECK ADD  CONSTRAINT [FK_archived_product_category_category] FOREIGN KEY([category_id])
	REFERENCES [dbo].category (category_id);

	ALTER TABLE [dbo].archived_product_to_category CHECK CONSTRAINT [FK_archived_product_category_archived_product];
	ALTER TABLE [dbo].archived_product_to_category CHECK CONSTRAINT [FK_archived_product_category_category];

END
GO



--==== adminArchivedArticle_AddArchivedArticle

EXEC dbo.global_DropStoredProcedure 'adminArchivedArticle_AddArchivedArticle';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminArchivedArticle_AddArchivedArticle]
    @article_id INT,
    @siteId INT,
    @title VARCHAR(1000),
	@authors VARCHAR(MAX),
	@article_type_id int,
    @isRestore BIT,
	@isRestoreError BIT,
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()

    INSERT INTO archived_article
    (
        [article_id],
        site_id,
        [title],
		[authors],
		[article_type_id],
        created,
		[modified],
        is_restore,
		is_restore_error
    )
    VALUES
    (   
	@article_id,
	@siteId,
	@title,
	@authors,
	@article_type_id,
	@created,
	@created,
    @isRestore,
	@isRestoreError
	);

	SET @id = SCOPE_IDENTITY();

END;
GO


GRANT EXECUTE ON dbo.adminArchivedArticle_AddArchivedArticle TO VpWebApp;
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_SelectArchivedArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArchivedArticle_SelectArchivedArticle]
@id int
	
AS
-- ==========================================================================
-- $Author: Madushan Fernando $
-- ==========================================================================
BEGIN
	
		SET NOCOUNT ON;
		
		SELECT archived_article_id as id,
			   article_id,
			   site_id,
			   title,
			   authors,
			   article_type_id,
			   modified,
			   created,
			   is_restore,
			   is_restore_error
		FROM archived_article 
		WHERE archived_article_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminArchivedArticle_SelectArchivedArticle TO VpWebApp 

GO

--===== adminArchivedArticle_UpdateArchivedArticle

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_UpdateArchivedArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedArticle_UpdateArchivedArticle
	@id int,
    @article_id INT,
    @siteId INT,
    @title VARCHAR(1000),
	@authors VARCHAR(MAX),
	@article_type_id int,
    @isRestore BIT,	
	@isRestoreError BIT,	
	@modified smalldatetime output
	
AS
-- ==========================================================================
-- $Author: Madushan Fernando $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	
	UPDATE archived_article
		SET article_id = @article_id,
		    site_id = @siteId,
		    title = @title,
		    authors = @authors,
		    article_type_id = @article_type_id,
			is_restore = @isRestore,
			is_restore_error = @isRestoreError,
			modified = @modified
	WHERE archived_article_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArchivedArticle_UpdateArchivedArticle TO VpWebApp 
GO

--==== adminArchivedArticle_GetArchivedArticleByArticleId


EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_GetArchivedArticleByArticleId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminArchivedArticle_GetArchivedArticleByArticleId]
@articleId int
	
AS
-- ==========================================================================
-- $Author: Madushan Fernando $
-- ==========================================================================
BEGIN
	
		SET NOCOUNT ON;
		
		SELECT archived_article_id as id,
			   article_id,
			   site_id,
			   title,
			   authors,
			   article_type_id,
			   modified,
			   created,
			   is_restore,
			   is_restore_error
		FROM archived_article 
		WHERE article_id = @articleId
	
END
GO

GRANT EXECUTE ON dbo.adminArchivedArticle_GetArchivedArticleByArticleId TO VpWebApp 
GO


--===== adminArchivedArticle_GetArchivedArticlesFiltered

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_GetArchivedArticlesFiltered';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE dbo.adminArchivedArticle_GetArchivedArticlesFiltered
    @siteId INT = NULL,
    @articleTypeId INT = NULL,
    @title VARCHAR(1000) = NULL,
    @author VARCHAR(MAX) = NULL,
    @pageStart INT = NULL,
    @pageEnd INT = NULL,
    @totalCount INT OUTPUT
AS
-- ==========================================================================
-- $Author: Madushan Fernando $
-- ==========================================================================
BEGIN

    SELECT ROW_NUMBER() OVER (ORDER BY archived_article_id) AS row,
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


--===== adminArchivedArticle_GetRestoreArticleIds

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_GetRestoreArticleIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedArticle_GetRestoreArticleIds
@batchSize INT = 10
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	top(@batchSize) article_id AS [id]
	FROM	dbo.archived_article
	WHERE	is_restore = 1 
			AND is_restore_error = 0
	ORDER BY archived_article_id

END
GO

GRANT EXECUTE ON dbo.adminArchivedArticle_GetRestoreArticleIds TO VpWebApp
GO




--==== adminArticle_RestoreArchivedArticle



EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_RestoreArchivedArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_RestoreArchivedArticle
	@articleId int,
	@articleTypeId int,
	@siteId int,
	@articleTitle varchar(500),
	@articleSubTitle nvarchar(255),
	@articleSummary varchar(max),	
	@enabled bit,
	@articleShortTitle varchar(255),
	@isArticleTemplate bit,
	@isExternal bit,
	@openNewWindow bit,
	@featuredIdentifier varchar(3),
	@thumbnailImageCode varchar(255),
	@externalUrlId int,
	@articleTemplateId int,
	@datePublished smalldatetime,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@published bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint, 
	@searchContentModified bit,
	@deleted bit,
	@excludeFromSearch BIT,
	@created DATETIME
AS
-- ========================================================================== 
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET IDENTITY_INSERT [article] ON --manually add primary key


	DECLARE @modified AS DATETIME = GETDATE()

	INSERT INTO article (article_id,article_type_id, site_id, article_title, article_sub_title, article_summary, modified, created, [enabled],
	article_short_title,is_article_template,is_external,featured_identifier,thumbnail_image_code,external_url_id,date_published,article_template_id, open_new_window, start_date, end_date, published, 
	flag1, flag2, flag3, flag4, search_content_modified, deleted, exclude_from_search)
	VALUES (@articleId,@articleTypeId, @siteId, @articleTitle, @articleSubTitle, @articleSummary, @modified, @created, @enabled,
	@articleShortTitle,@isArticleTemplate,@isExternal,@featuredIdentifier,@thumbnailImageCode,@externalUrlId,@datePublished,@articleTemplateId, @openNewWindow, @startDate, @endDate, @published,
	@flag1, @flag2, @flag3, @flag4, @searchContentModified, @deleted, @excludeFromSearch)


	SET IDENTITY_INSERT [article] OFF
END
GO

GRANT EXECUTE ON dbo.adminArticle_RestoreArchivedArticle TO VpWebApp 
GO


--==== adminArchivedArticle_UpdateArchivedArticleRestoreErrorStatusByArticleId

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_UpdateArchivedArticleRestoreErrorStatusByArticleId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedArticle_UpdateArchivedArticleRestoreErrorStatusByArticleId
	@articleId INT,
	@isRestoreError BIT
AS
-- ========================================================================== 
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	UPDATE archived_article 
	SET is_restore_error = @isRestoreError
	WHERE article_id = @articleId

END
GO

GRANT EXECUTE ON dbo.adminArchivedArticle_UpdateArchivedArticleRestoreErrorStatusByArticleId TO VpWebApp 
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

	UPDATE	article
	SET		archived = 1
	FROM	article 
	WHERE	modified > @last_rundate
			AND enabled = 0
			AND archived = 0
			AND start_date IS NOT NULL 
			AND end_date IS NOT NULL
	
END
GO

GRANT EXECUTE ON adminArticle_UpdateArchivedByArtcle TO VpWebApp
GO



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
			AND  ( rt.review_type_id IS NOT NULL --review type
				OR art.is_article_template = 1	--default article
				OR	art.start_date > GETDATE() --future start date run date
				)   
			
END
GO

GRANT EXECUTE ON dbo.adminArticle_ResetNonArchivableArticles TO VpWebApp
GO




EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_ResetNonArchivableProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_ResetNonArchivableProducts
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE pro
	SET	pro.archived = 0
	FROM	product pro
			LEFT JOIN lead ld on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
			LEFT JOIN dbo.product_to_product ptp ON ptp.parent_product_id = pro.product_id
	WHERE	pro.archived = 1 
			AND (
				(ld.lead_id IS NOT NULL AND ld.lead_status_id <> 4) --lead not sent
				AND (ptp.product_to_product_id IS NOT NULL) --parent product
			)

END
GO

GRANT EXECUTE ON dbo.adminProduct_ResetNonArchivableProducts TO VpWebApp
GO


--==== adminArchivedArticle_RemoveRestoredArticle


EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedArticle_RemoveRestoredArticle'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedArticle_RemoveRestoredArticle
	@articleId int
AS
-- ========================================================================== 
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	DELETE FROM dbo.archived_article WHERE article_id = @articleId
END
GO


GRANT EXECUTE ON dbo.adminArchivedArticle_RemoveRestoredArticle TO VpWebApp 
GO


--======= adminProduct_RemoveArchivedProductandRelations

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_RemoveArchivedProductandRelations';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET XACT_ABORT ON;
GO
CREATE PROCEDURE dbo.adminProduct_RemoveArchivedProductandRelations @productId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

		DELETE ctcs
		FROM [dbo].[content_to_content_setting] ctcs
		INNER JOIN [dbo].[content_to_content] ctc ON ctc.content_to_content_id = ctcs.content_to_content_id
		WHERE (ctc.content_id = @productId 
		AND	ctc.content_type_id = 2) OR ( ctc.associated_content_id = @productId 
		AND	ctc.associated_content_type_id = 2)

		DELETE	
		FROM [dbo].[content_to_content]
		WHERE (content_id = @productId 
		AND	content_type_id = 2) OR ( associated_content_id = @productId 
		AND	associated_content_type_id = 2)


		DELETE FROM product_to_search_option
        WHERE product_id = @productId;
		
		DELETE FROM dbo.specification
		WHERE content_id = @productId AND content_type_id = 2

		DELETE lfu
		FROM [dbo].[legacy_fixed_url] lfu join
		[dbo].[fixed_url] fu on  fu.[fixed_url_id] = lfu.[fixed_url_id]
		where fu.[content_type_id] = 2 and fu.[content_id] =  @productId


		DELETE fus
		FROM [dbo].[fixed_url] fu join 
		[dbo].[fixed_url_setting] fus on  fus.[fixed_url_id] = fu.[fixed_url_id]
		where fu.[content_type_id] = 2 and fu.[content_id] =  @productId


		DELETE 
		FROM [dbo].[fixed_url]
		where [content_id] = @productId and [content_type_id] = 2

		DELETE	
		FROM [dbo].[action_url] 
		where [content_id] = @productId and [content_type_id] = 2

		DELETE propri
        FROM dbo.product pro
            INNER JOIN product_to_vendor proven
                ON proven.product_id = pro.product_id
            INNER JOIN dbo.product_to_vendor_to_price propri
                ON propri.product_to_vendor_id = proven.product_to_vendor_id
        WHERE pro.product_id = @productId;

		DELETE FROM product_to_vendor
        WHERE product_id = @productId;
		 
		DELETE FROM product_to_url
        WHERE product_id = @productId;

        DELETE FROM product_to_product
        WHERE product_id = @productId;
		
        DELETE FROM product_to_category
        WHERE product_id = @productId;

		DELETE FROM product_parameter
        WHERE product_id = @productId;

		DELETE pmis
		FROM  product_multimedia_item pmi 
		INNER JOIN product_multimedia_item_setting pmis on pmis.product_multimedia_item_id = pmi.product_multimedia_item_id
        WHERE pmi.product_id = @productId;

		DELETE FROM product_multimedia_item
        WHERE product_id = @productId;

		DELETE FROM product_display_status
        WHERE product_id = @productId;

		DELETE FROM product_compression_group_to_product
        WHERE product_id = @productId;
		
        DELETE FROM model
        WHERE product_id = @productId;

		DELETE FROM citation
        WHERE product_id = @productId;

		DELETE FROM dbo.product WHERE product_id = @productId --

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RETURN ERROR_MESSAGE();
    END CATCH;


END;
GO

GRANT EXECUTE
ON dbo.adminProduct_RemoveArchivedProductandRelations
TO  VpWebApp;
GO




--==== adminProduct_GetModifiedProductIdsForProductSync


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetModifiedProductIdsForProductSync'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetModifiedProductIdsForProductSync
	@limit int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	Select top(@limit) p.product_id as id
	from product p with(nolock)
	where  p.content_modified = 1
	ORDER BY p.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetModifiedProductIdsForProductSync TO VpWebApp 
GO


--==== adminArchivedProductCategory_AddArchivedProductCategory

EXEC dbo.global_DropStoredProcedure 'adminArchivedProductCategory_AddArchivedProductCategory';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminArchivedProductCategory_AddArchivedProductCategory]
    @archivedProductId INT,
    @categoryId INT,
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()


    INSERT INTO archived_product_to_category
    (
        archived_product_id,
        category_id,
        created,
		modified
    )
    VALUES
    (@archivedProductId, @categoryId, @created, @created);

    SET @id = SCOPE_IDENTITY();


END;
GO


GRANT EXECUTE ON dbo.adminArchivedProductCategory_AddArchivedProductCategory TO VpWebApp;
GO

--===== adminArchivedProduct_DeleteArchivedProducts

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_DeleteArchivedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_DeleteArchivedProducts
	@productId int
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE arpc
	FROM dbo.archived_product arp
	INNER JOIN dbo.archived_product_to_category arpc ON arpc.archived_product_id = arp.archived_product_id
	WHERE arp.product_id = @productId

	DELETE FROM archived_product
	WHERE [product_id] = @productId

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_DeleteArchivedProducts TO VpWebApp 
GO






--------- adminArchivedProduct_GetArchivedProductsDetail ---------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductsDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductsDetail
	@id int
AS
-- ==========================================================================
-- $Date: 2020-03-17 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [archived_product_id] as Id
	  ,[product_id]
	  ,[site_id]
	  ,[vendor_id]
	  ,[catalog_number]
	  ,[product_name]
	  ,[modified]
	  ,[created]
	  ,[is_restore]
	  ,CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product]
	WHERE archived_product_id = @id 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsDetail TO VpWebApp 
GO



--------- adminArchivedProduct_UpdateArchivedProduct ---------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_UpdateArchivedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_UpdateArchivedProduct
	@id int,
	@productId int,
	@siteId int,
	@vendorId int,
	@catalogNumber varchar(255),
	@productName varchar(500),
	@isRestore bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE [dbo].[archived_product]
	   SET [product_id] = @productId
		  ,[site_id] = @siteId
		  ,[vendor_id] = @vendorId
		  ,[catalog_number] = @catalogNumber
		  ,[product_name] = @productName
		  ,[modified] = @modified
		  ,[is_restore] = @isRestore
	WHERE archived_product_id = @id
 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_UpdateArchivedProduct TO VpWebApp 
GO


--========= adminArchivedProduct_GetArchivedProductsPageList

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
		AND (@categoryId = 0 OR arp.archived_product_id IS NULL OR (arp.category_id = @categoryId))
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
		  , CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product] as ap with(nolock) 
	INNER JOIN  #temp ON #temp.id = ap.archived_product_id
	WHERE #temp.row BETWEEN @startIndex AND @endIndex;
	
	SELECT @totalCount = COUNT(*) FROM #temp;
END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsPageList TO VpWebApp 
GO

--======= adminArchivedProduct_AddArchivedProduct

EXEC dbo.global_DropStoredProcedure 'adminArchivedProduct_AddArchivedProduct';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[adminArchivedProduct_AddArchivedProduct]
    @productId INT,
    @siteId INT,
	@vendorId INT,
    @catalogNumber VARCHAR(255),
    @productName VARCHAR(500),
    @isRestore BIT,
    @isRestoreError BIT,
	@id INT OUTPUT,
	@created smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;
	SET @created = GETDATE()


    INSERT INTO archived_product
    (
        product_id,
        site_id,
		vendor_id,
        catalog_number,
        product_name,
        created,
		modified,
        is_restore,
		is_restore_error
    )
    VALUES
    (@productId, @siteId, @vendorId, @catalogNumber, @productName, @created, @created, @isRestore, @isRestoreError);

    SET @id = SCOPE_IDENTITY();


END;
GO


GRANT EXECUTE ON dbo.adminArchivedProduct_AddArchivedProduct TO VpWebApp;
GO


-- ========= adminArchivedProduct_DeleteArchivedProducts

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_DeleteArchivedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_DeleteArchivedProducts
	@productId int
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE arpc
	FROM dbo.archived_product arp
	INNER JOIN dbo.archived_product_to_category arpc ON arpc.archived_product_id = arp.archived_product_id
	WHERE arp.product_id = @productId

	DELETE FROM archived_product
	WHERE [product_id] = @productId

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_DeleteArchivedProducts TO VpWebApp 
GO


--===== adminProduct_UpdateProductStatusByVendorId


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductStatusByVendorId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_UpdateProductStatusByVendorId]
	@vendorId int,
	@vendorStatus bit,
	@batchSize int = NULL	
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @modified smalldatetime 
	SET @modified = GETDATE() 	

IF(@batchSize IS NOT NULL)
BEGIN
	UPDATE TOP(@batchSize) product
	SET
		[enabled] = @vendorStatus,
		modified = @modified,
		archived = ~@vendorStatus	
	FROM product pl 
	INNER JOIN 
	product_to_vendor ptv ON pl.product_id = ptv.product_id 
	WHERE ptv.vendor_id = @vendorId AND pl.enabled != @vendorStatus

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE TOP(@batchSize) dbo.archived_product
		SET is_restore = 1
		WHERE vendor_id = @vendorId
	END
END
ELSE 
BEGIN
	UPDATE product
	SET
		[enabled] = @vendorStatus,
		modified = @modified,
		archived = ~@vendorStatus	
	FROM product pl 
	INNER JOIN 
	product_to_vendor ptv ON pl.product_id = ptv.product_id 
	WHERE ptv.vendor_id = @vendorId AND pl.enabled != @vendorStatus

	--set restore flag on re enabling vendor product
	IF @vendorStatus = 1
	BEGIN	
		UPDATE dbo.archived_product
		SET is_restore = 1
		WHERE vendor_id = @vendorId
	END
END

END
GO
GRANT EXECUTE ON dbo.adminProduct_UpdateProductStatusByVendorId TO VpWebApp 
GO


--===== adminProduct_GetArchivingProductIdsList


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetArchivingProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetArchivingProductIdsList
@limit INT = 10
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) pro.[product_id] AS [id]
	FROM	product pro
			LEFT JOIN lead ld on ld.content_id = pro.product_id and ld.content_type_id = 2 --product
			LEFT JOIN dbo.product_to_product ptp ON ptp.parent_product_id = pro.product_id
	WHERE	pro.search_content_modified = 0 --elastic search processed
			AND pro.content_modified = 0 --content update synced
			AND pro.archived = 1 
			AND (ld.lead_id IS NULL OR ld.lead_status_id = 4) --lead sent
			AND (ptp.product_to_product_id IS NULL) --not parent product
	ORDER BY pro.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetArchivingProductIdsList TO VpWebApp
GO

--===== adminArticle_UpdateArchivedByArtcle

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

	UPDATE	article
	SET		archived = 1
	FROM	article 
	WHERE	modified > @last_rundate
			AND enabled = 0
			AND published = 0
			AND archived = 0
	
END
GO

GRANT EXECUTE ON adminArticle_UpdateArchivedByArtcle TO VpWebApp
GO

--======= adminArticle_GetArchivingArticleIdsList

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
		    AND	art.start_date < GETDATE()   --future start date run date
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
	ORDER BY art.article_id

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO

--======= adminArticle_ResetNonArchivableArticles

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
				OR	art.start_date > GETDATE() --future start date run date
				OR art.enabled = 1
				OR	art.published = 1
				)   
			
END
GO

GRANT EXECUTE ON dbo.adminArticle_ResetNonArchivableArticles TO VpWebApp
GO

--======= adminArchivedArticle_GetArchivedArticlesFiltered

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
-- $Author: Madushan Fernando $
-- ==========================================================================
BEGIN

    SELECT ROW_NUMBER() OVER (ORDER BY archived_article_id) AS row,
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

--======= adminArchivedProduct_GetArchivedProductsPageList

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
		AND (@categoryId = 0 OR arp.archived_product_id IS NULL OR (arp.category_id = @categoryId))
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


--======== adminArchivedProduct_GetArchivedProductsDetail

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_GetArchivedProductsDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_GetArchivedProductsDetail
	@id int
AS
-- ==========================================================================
-- $Date: 2020-03-17 
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [archived_product_id] as Id
	  ,[product_id]
	  ,[site_id]
	  ,[vendor_id]
	  ,[catalog_number]
	  ,[product_name]
	  ,[modified]
	  ,[created]
	  ,[is_restore]
	  ,is_restore_error
	  ,CONVERT(bit, 1) as [enabled]
	FROM [dbo].[archived_product]
	WHERE archived_product_id = @id 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_GetArchivedProductsDetail TO VpWebApp 
GO


--========= adminArchivedProduct_UpdateArchivedProduct

EXEC dbo.global_DropStoredProcedure 'dbo.adminArchivedProduct_UpdateArchivedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArchivedProduct_UpdateArchivedProduct
	@id int,
	@productId int,
	@siteId int,
	@vendorId int,
	@catalogNumber varchar(255),
	@productName varchar(500),
	@isRestore bit,
	@isRestoreError BIT,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE [dbo].[archived_product]
	   SET [product_id] = @productId
		  ,[site_id] = @siteId
		  ,[vendor_id] = @vendorId
		  ,[catalog_number] = @catalogNumber
		  ,[product_name] = @productName
		  ,[modified] = @modified
		  ,[is_restore] = @isRestore
		  ,is_restore_error = @isRestoreError
	WHERE archived_product_id = @id
 

END
GO

GRANT EXECUTE ON dbo.adminArchivedProduct_UpdateArchivedProduct TO VpWebApp 
GO