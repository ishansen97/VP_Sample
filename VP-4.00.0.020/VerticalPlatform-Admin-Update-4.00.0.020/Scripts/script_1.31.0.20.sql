IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group]') AND name = N'AK_product_compression_group_group_title_site_id')
BEGIN
DROP INDEX [AK_product_compression_group_group_title_site_id] ON [dbo].[product_compression_group] WITH ( ONLINE = OFF )
END
----------------------------------------------------------------------------------------
IF NOT EXISTS 
(SELECT [name] FROM syscolumns where [name] = 'group_name' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'product_compression_group') AND type in (N'U')))
	BEGIN
		ALTER TABLE product_compression_group
		ADD group_name varchar(500) null 
	END
GO
----------------------------------------------------------------------------------------
IF EXISTS
(SELECT [name] FROM syscolumns where [name] = 'group_name' AND id = (SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product_compression_group') AND type in (N'U')))
		BEGIN
			UPDATE [dbo].product_compression_group SET group_name = group_title
		END
GO
----------------------------------------------------------------------------------------
IF EXISTS
(SELECT [name] FROM syscolumns where [name] = 'group_name' AND id = (SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product_compression_group') AND type in (N'U')))
		BEGIN
			ALTER TABLE [dbo].product_compression_group
			ALTER COLUMN group_name varchar(500) not null
		END
GO
----------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group]') AND name = N'AK_product_compression_group_group_name_site_id')
BEGIN
DROP INDEX [AK_product_compression_group_group_name_site_id] ON [dbo].[product_compression_group] WITH ( ONLINE = OFF )
END
GO

CREATE UNIQUE NONCLUSTERED INDEX [AK_product_compression_group_group_name_site_id] ON [dbo].[product_compression_group] 
(
	[site_id] ASC,
	[group_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
----------------------------------------------------------------------------------------------------------------
--Add Default Groups To Sites Without Default Groups
DECLARE @siteId int
DECLARE @showInMatrix bit
DECLARE @showProductCount bit
DECLARE @groupName varchar(500)
DECLARE @groupTitle varchar(500)
DECLARE @expandProducts bit
DECLARE @enabled bit
DECLARE @createdDate smalldatetime
DECLARE @isDefault bit

SET @showInMatrix = 1
SET @showProductCount = 1
SET @groupName = 'Default Group'
SET @groupTitle = 'Default Group'
SET @expandProducts = 1
SET @enabled = 1
SET @createdDate =	GETDATE()
SET @isDefault = 1

DECLARE sitesWithoutDefaultGroupCursor CURSOR FOR 
	SELECT site_id 
	FROM site 
	WHERE site_id NOT IN (
		SELECT DISTINCT site_id 
		FROM product_compression_group 
		WHERE is_default = 1)

OPEN sitesWithoutDefaultGroupCursor

FETCH NEXT FROM sitesWithoutDefaultGroupCursor
INTO @siteId

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO [product_compression_group]
			   ([site_id]
			   ,[show_in_matrix]
			   ,[show_product_count]
			   ,[group_title]
			   ,[expand_products]
			   ,[enabled]
			   ,[created]
			   ,[modified]
			   ,[is_default]
			   ,[group_name])
		 VALUES
			   (@siteId
			   ,@showInMatrix
			   ,@showProductCount
			   ,@groupTitle
			   ,@expandProducts
			   ,@enabled
			   ,@createdDate
			   ,@createdDate
			   ,@isDefault
			   ,@groupName)
		
	FETCH NEXT FROM sitesWithoutDefaultGroupCursor
	INTO @siteId

END
GO
CLOSE sitesWithoutDefaultGroupCursor
DEALLOCATE sitesWithoutDefaultGroupCursor

GO
-------------------------------------------------------------------------------------------------
--Add Related Products Groups To Sites Without Related Products
DECLARE @siteId int
DECLARE @showInMatrix bit
DECLARE @showProductCount bit
DECLARE @groupName varchar(500)
DECLARE @groupTitle varchar(500)
DECLARE @expandProducts bit
DECLARE @enabled bit
DECLARE @createdDate smalldatetime
DECLARE @isDefault bit

SET @showInMatrix = 0
SET @showProductCount = 1
SET @groupName = 'Related Products'
SET @groupTitle = 'Related Products'
SET @expandProducts = 1
SET @enabled = 1
SET @createdDate =	GETDATE()
SET @isDefault = 0

DECLARE sitesWithoutRelatedProductGroupCursor CURSOR FOR 
	SELECT site_id 
	FROM site 
	WHERE site_id NOT IN (
		SELECT DISTINCT site_id 
		FROM product_compression_group 
		WHERE group_name = 'Related Products')

OPEN sitesWithoutRelatedProductGroupCursor

FETCH NEXT FROM sitesWithoutRelatedProductGroupCursor
INTO @siteId

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO [product_compression_group]
			   ([site_id]
			   ,[show_in_matrix]
			   ,[show_product_count]
			   ,[group_title]
			   ,[expand_products]
			   ,[enabled]
			   ,[created]
			   ,[modified]
			   ,[is_default]
			   ,[group_name])
		 VALUES
			   (@siteId
			   ,@showInMatrix
			   ,@showProductCount
			   ,@groupTitle
			   ,@expandProducts
			   ,@enabled
			   ,@createdDate
			   ,@createdDate
			   ,@isDefault
			   ,@groupName)
		
	FETCH NEXT FROM sitesWithoutRelatedProductGroupCursor
	INTO @siteId

END
GO
CLOSE sitesWithoutRelatedProductGroupCursor
DEALLOCATE sitesWithoutRelatedProductGroupCursor

GO
-------------------------------------------------------------------------------------------------
--Add Groupless Products To Related Product Groups
DECLARE @relatedProductGroupID int
DECLARE @enabled bit
DECLARE @created smalldatetime
DECLARE @productID int

SET @enabled = 1
SET @created = GETDATE()

DECLARE productsWithoutGroupCursor CURSOR FOR
	SELECT product_id 
	FROM product_to_product 
	WHERE product_id NOT IN (
		SELECT DISTINCT product_id 
		FROM product_compression_group_to_product)
		
OPEN productsWithoutGroupCursor

FETCH NEXT FROM productsWithoutGroupCursor
INTO @productID

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @relatedProductGroupID = (SELECT product_compression_group_id 
									FROM product_compression_group 
									WHERE group_name = 'Related Products' and site_id = (
										SELECT site_id 
										FROM product 
										WHERE product_id = @productID))
	
	IF  @relatedProductGroupID IS NOT NULL
	BEGIN
		INSERT INTO [product_compression_group_to_product]
		   ([product_compression_group_id]
		   ,[product_id]
		   ,[enabled]
		   ,[created]
		   ,[modified])
		VALUES
		   (@relatedProductGroupID
		   ,@productID
		   ,@enabled
		   ,@created
		   ,@created)
	END
	FETCH NEXT FROM productsWithoutGroupCursor
	INTO @productID
	
END
GO

CLOSE productsWithoutGroupCursor
DEALLOCATE productsWithoutGroupCursor

GO
----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroup
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
	@groupName varchar(500),
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
	@isDefault bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group]
           ([show_in_matrix]
           ,[show_product_count]
		   ,[group_title]
		   ,[expand_products]
		   ,[site_id]
           ,[enabled]
           ,[created]
           ,[modified]
		   ,[is_default]
		   ,[group_name])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created, @isDefault, @groupName)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_id] AS id
      ,[site_id]
      ,[show_in_matrix]
      ,[show_product_count]
      ,[group_title]
      ,[expand_products]
      ,[enabled]
      ,[created]
      ,[modified]
	  ,[is_default]
	  ,[group_name]
	FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupDetail TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroup
	@id int,
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
	@groupName varchar(500),
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
	@isDefault bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group]
	SET [site_id] = @siteId
      ,[show_in_matrix] = @showInMatrix
      ,[show_product_count] = @showProductCount
      ,[group_title] = @groupTitle
      ,[expand_products] = @expandProducts
      ,[enabled] = @enabled
      ,[modified] = @modified
	  ,[is_default] = @isDefault
	  ,[group_name] = @groupName
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroup TO VpWebApp 
GO
--------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM product_compression_group
	WHERE site_id = @siteId;

	WITH temp_product_compression_group (row, id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled
		, created, modified, is_default, group_name) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY group_title) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified, is_default, group_name
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified, is_default, group_name
	FROM temp_product_compression_group 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsList
	@productIds varchar(4000),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT c.product_compression_group_id AS id, site_id, show_in_matrix, show_product_count 
		, group_title, expand_products, enabled, created, modified, is_default, group_name, product_id, product_count
	FROM
	(
		SELECT CAST(p.[value] AS int) AS product_id, cp.product_compression_group_id, COUNT(*) product_count 
		FROM product_to_product pp
			INNER JOIN global_Split(@productIds, ',') AS p
				ON pp.parent_product_id = p.[value]
			INNER JOIN product
				ON pp.product_id = product.product_id
			INNER JOIN product_compression_group_to_product cp
				ON pp.product_id = cp.product_id
		WHERE (product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		GROUP BY p.[value], cp.product_compression_group_id
	) g
	INNER JOIN product_compression_group c
		ON g.product_compression_group_id = c.product_compression_group_id	

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsList TO VpWebApp 
GO
------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList
	@siteId int,
	@searchText varchar(500),
	@limit int
	
AS
-- ==========================================================================
-- Author : tishan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT TOP(@limit) [product_compression_group_id] AS id
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified, is_default, group_name
	FROM [dbo].[product_compression_group]
	WHERE group_name like @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO
------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByParentProductIdSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByParentProductIdSiteIdList
	@parentProductId int,
	@siteId int

AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT proGro.product_compression_group_id AS id, proGro.show_in_matrix, show_product_count, group_title , expand_products,
		proGro.site_id, proGro.enabled, proGro.created, proGro.modified, proGro.is_default, proGro.group_name
	FROM product_compression_group proGro
		INNER JOIN product_compression_group_to_product groPro
			ON groPro.product_compression_group_id = progro.product_compression_group_id
		INNER JOIN product_to_product pp
			ON pp.product_id = groPro.product_id
	WHERE proGro.site_id = @siteId AND
		pp.parent_product_id = @parentProductId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByParentProductIdSiteIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompressionGroupsByProductID'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompressionGroupsByProductID
	@productID int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT gro.[product_compression_group_id] AS id
      ,gro.[site_id]
      ,gro.[show_in_matrix]
      ,gro.[show_product_count]
      ,gro.[group_title]
      ,gro.[expand_products]
      ,gro.[enabled]
      ,gro.[created]
      ,gro.[modified]
      ,gro.[is_default]
	  ,gro.[group_name]
	FROM [product_compression_group] gro
		INNER JOIN product_compression_group_to_product groPro
			ON gro.product_compression_group_id = groPro.product_compression_group_id
	WHERE groPro.product_id = @productID

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsByProductID TO VpWebApp 
GO
-------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompressionGroupsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompressionGroupsBySiteId @siteId INT
AS 
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
    BEGIN

      --SELECT DISTINCT
        SELECT  [product_compression_group_id] AS id ,
                site_id ,
                show_in_matrix ,
                show_product_count ,
                group_title ,
                expand_products ,
                [enabled] ,
                created ,
                modified ,
                is_default ,
				group_name
        FROM    dbo.product_compression_group
        WHERE   site_id = @siteId

    END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsBySiteId TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedSpecificationList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author: Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT TOP (@batchSize) p.product_id as id, p.site_id, p.product_name, p.rank
		, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
		, p.show_in_matrix, p.show_detail_page
	FROM product p
		INNER JOIN specification
			ON p.product_id = specification.content_id AND specification.content_type_id = 2
		INNER JOIN content_text
			ON p.product_id = content_text.content_id AND content_text.content_type_id = 3
	WHERE p.site_id = @siteId AND p.enabled = 1 AND p.hidden = 0 AND specification.modified > content_text.modified		

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedSpecificationList TO VpWebApp
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_AddCampaignRecipientClickUrl'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_AddCampaignRecipientClickUrl
	@campaignRecipientId int, 
	@clickUrl varchar(255),
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO campaign_recipient_click_url(
		campaign_recipient_id, click_url, [enabled], created, modified)
	VALUES (@campaignRecipientId, @clickUrl, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_AddCampaignRecipientClickUrl TO VpWebApp 
GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_UpdateCampaignRecipientClickUrl'

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_UpdateCampaignRecipientClickUrl
	@id int,
	@campaignRecipientId int,
	@clickUrl varchar(255),
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE campaign_recipient_click_url
	SET
		campaign_recipient_id = @campaignRecipientId,
		click_url = @clickUrl,
		modified = @modified,
		[enabled] = @enabled
	WHERE campaign_recipient_click_url_id = @id
 
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_UpdateCampaignRecipientClickUrl TO VpWebApp 
GO


--------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByOptionIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByOptionIdList
	@siteId int,
	@optionId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY pro.product_id) AS rowId, pro.product_id
			, pro.site_id, pro.parent_product_id, pro.product_name, pro.[rank]
			, pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.status 
			, pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page
 INTO #tmpProducts
	FROM product pro
			INNER JOIN product_to_category_group_option pcg
				ON pro.product_id = pcg.product_id
			INNER JOIN category_group_option cgo
				ON cgo.category_group_option_id = pcg.category_group_option_id 
	WHERE cgo.option_id = @optionId AND pro.site_id = @siteId
	
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model, completeness
			, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page

	FROM #tmpProducts
	WHERE rowId BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(product_id) 
	FROM #tmpProducts

	DROP TABLE #tmpProducts
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByOptionIdList TO VpWebApp
GO
-------



EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByOptionIdListWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByOptionIdListWithSorting
	@siteId int,
	@optionId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, id, site_id, parent_product_id, ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, product_name, rank
			, has_image, ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
		show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
		SELECT DISTINCT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name, pro.[rank]
				,pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created, product_type, status
				,pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid
				,pro.show_in_matrix, pro.show_detail_page

		FROM product pro
				INNER JOIN product_to_category_group_option pcg
					ON pro.product_id = pcg.product_id
				INNER JOIN category_group_option cgo
					ON cgo.category_group_option_id = pcg.category_group_option_id 
		WHERE cgo.option_id = @optionId AND pro.site_id = @siteId
		) AS tmp

	IF @sortOrder = 'asc'
	BEGIN
		SELECT id, site_id, parent_product_id, product_name, rank
				, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model, completeness
				, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		FROM #tmpProducts
		WHERE (@sortBy = 'Id' AND idRow BETWEEN @startRowIndex AND @endRowIndex) OR (@sortBy = 'Name' AND nameRow BETWEEN @startRowIndex AND @endRowIndex)
				OR (@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startRowIndex AND @endRowIndex)
		ORDER BY
			CASE @sortBy
				WHEN 'Id' THEN idRow 
				WHEN 'Name' THEN nameRow 
				WHEN 'CatalogNumber' THEN catalogNoRow
			END
		ASC
	END
	ELSE
	BEGIN
		SELECT id, site_id, parent_product_id, product_name, rank
				, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model
				, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		FROM #tmpProducts
		WHERE (@sortBy = 'Id' AND idRow BETWEEN @startRowIndex AND @endRowIndex) OR (@sortBy = 'Name' AND nameRow BETWEEN @startRowIndex AND @endRowIndex)
				OR (@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startRowIndex AND @endRowIndex)
		ORDER BY
			CASE @sortBy
				WHEN 'Id' THEN idRow
				WHEN 'Name' THEN nameRow 
				WHEN 'CatalogNumber' THEN catalogNoRow
			END
		DESC
	END	

	SELECT @totalRowCount = COUNT(id) 
	FROM #tmpProducts

	DROP TABLE #tmpProducts	
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByOptionIdListWithSorting TO VpWebApp
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedTagList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedTagList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT TOP (@batchSize) product.product_id as id, product.site_id, product_Name, product.rank
		, has_image, catalog_number, product.enabled, product.modified, product.created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page
	FROM product
		INNER JOIN content_tag
			ON product.product_id = content_tag.content_id AND content_tag.content_type_id = 2
		INNER JOIN content_text
				ON content_text.content_type_id = 2 AND content_text.content_id = product.product_id
	WHERE product.site_id = @siteId AND product.enabled = 1 AND product.hidden = 0 AND 
		content_tag.modified > content_text.modified

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedTagList TO VpWebApp 
GO
---------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetRecentlyModifiedIndexedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetRecentlyModifiedIndexedProducts
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) id
			 , site_id, product_name, [rank], has_image
			 , catalog_number, [enabled], modified, created, product_type, status
			 , has_model, has_related, completeness
			 , flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM (
			SELECT DISTINCT	p.product_id as id,site_id, product_name, [rank]
					, has_image, catalog_number, [enabled], modified
					, created, product_type, status, has_model, has_related, completeness
					, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
					, show_in_matrix, show_detail_page
			FROM
			(			
				SELECT product_id 
				FROM product 
					INNER JOIN search_content_status
						ON search_content_status.content_type_id = 2 AND search_content_status.content_id = product.product_id
				WHERE product.modified > search_content_status.modified AND product.site_id = @siteId

				UNION
					
				SELECT product_id 
				FROM  product_to_vendor  pv
					  INNER JOIN vendor  v
						 ON v.vendor_id = pv.vendor_id
					  INNER JOIN search_content_status
						 ON search_content_status.content_type_id = 2 AND search_content_status.content_id = pv.product_id
				WHERE (v.modified > search_content_status.modified OR pv.modified > search_content_status.modified)
					  AND search_content_status.site_id = @siteId	

				UNION
						
				SELECT product_id 
				FROM  product_to_category  pc
					  INNER JOIN category  c
						ON c.category_id = pc.category_id	
					  INNER JOIN category_to_category_branch cat_cat
						ON cat_cat.sub_category_id = c.category_id						 
					  INNER JOIN search_content_status
						 ON search_content_status.content_type_id = 2 AND search_content_status.content_id = pc.product_id
				WHERE (c.modified > search_content_status.modified OR cat_cat.modified > search_content_status.modified)
				      AND search_content_status.site_id = @siteId 		
				
				UNION

				SELECT product_id 
				FROM  product_to_category  pc
					  INNER JOIN category_to_vendor cv
						 ON cv.category_id = pc.category_id
					  INNER JOIN vendor AS v
						 ON v.vendor_id = cv.vendor_id
					  INNER JOIN search_content_status
						 ON search_content_status.content_type_id = 2 AND search_content_status.content_id = pc.product_id
				WHERE  (v.modified > search_content_status.modified OR cv.modified > search_content_status.modified) 
						AND search_content_status.site_id = @siteId		
				
				UNION

				SELECT  spec.content_id AS product_id 
				FROM  specification spec
					  INNER JOIN specification_type specType
						  ON specType.spec_type_id = spec.spec_type_id
					  INNER JOIN search_content_status
						  ON search_content_status.content_type_id = 2 AND search_content_status.content_id = spec.content_id
				WHERE (specType.modified > search_content_status.modified OR spec.modified > search_content_status.modified ) 
					  AND search_content_status.site_id = @siteId	
				
			) AS p
			INNER JOIN product 
				ON	p.product_id = product.product_id AND product.enabled = 1
		
				 
		) AS SortedProductList
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetRecentlyModifiedIndexedProducts TO VpWebApp 
GO

--------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList
	@categoryId int,
	@manufacturerId int,
	@productId int,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH ProductList AS
	(
		SELECT product.product_id as id, site_id, product_Name, ROW_NUMBER() OVER (ORDER BY product_Name) AS row_id, [rank]
				, has_image, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page
		FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id AND product_to_vendor.enabled = '1' 
						AND product_to_vendor.is_manufacturer = 1
		WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id <> @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled],
		modified, created, product_type, status,has_related, has_model, 
		completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM ProductList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(*)
		FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id AND product_to_vendor.enabled = '1' 
						AND product_to_vendor.is_manufacturer = 1
		WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id <> @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByOtherUserRequestedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByOtherUserRequestedList
	@siteId int,
	@userId int,
	@actionId int,
	@leadIds varchar(1000),
	@categoryId int,
	@rows int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
SET NOCOUNT ON;

CREATE TABLE #TempProductList
	(
		id int NOT NULL,
		site_id int NOT NULL,
		product_name varchar(500) NOT NULL,
		rank int NOT NULL,
		has_image bit NOT NULL,
		catalog_number varchar(255) NULL,
		enabled bit NOT NULL,
		modified smalldatetime NOT NULL,
		created smalldatetime NOT NULL,
		product_type int NOT NULL DEFAULT ((1)),
		status int NOT NULL DEFAULT ((0)),
		has_related bit NOT NULL,
		has_model bit NOT NULL,
		leads int,
		completeness int NOT NULL,
		flag1 bigint,
		flag2 bigint,
		flag3 bigint,
		flag4 bigint,
		search_rank int NOT NULL DEFAULT ((50)),
		search_content_modified bit,
		hidden bit,
		business_value int,
		ignore_in_rapid bit,
		show_in_matrix bit,
		show_detail_page bit

	)

DECLARE @months int
SET @months = -3

INSERT INTO #TempProductList

SELECT DISTINCT	product.product_id as id, product.site_id as site_id, product.product_name as product_name, product.rank as rank, 
				  product.has_image as has_image, product.catalog_number as catalog_number, product.enabled as enabled, 
				  product.modified as modified, product.created as created, product.product_type as product_type, product.status as status,
				  product.has_related as has_related, product.has_model as has_model, leads as leads, 
				  product.completeness as completeness, product.flag1, product.flag2, product.flag3, product.flag4,
				  product.search_rank, product.search_content_modified, product.hidden, product.business_value, product.ignore_in_rapid, product.show_in_matrix, product.show_detail_page

FROM product 
	INNER JOIN 
(
-- product ids for which leads submited by other users
SELECT lead.content_id, count(lead.content_id) AS leads
FROM lead 
	INNER JOIN
	(
	SELECT DISTINCT public_user_id 
	FROM lead
	WHERE lead.created > DATEADD(m, @months, GETDATE()) AND lead.site_id = @siteId AND
		public_user_id <> @userId AND content_type_id = 2 AND content_id IN 
		(SELECT DISTINCT l.content_id 
		FROM lead l
		WHERE l.lead_id IN (SELECT [value] FROM global_Split(@leadIds, ',')))
	) lead_user -- temp table containing users who submited leads for the same products 
				-- as the current user for the last specified months.
		ON lead.public_user_id = lead_user.public_user_id AND lead.content_type_id = 2
	INNER JOIN product 
		ON lead.content_id = product.product_id 
	INNER JOIN product_to_vendor 
		ON product.product_id = product_to_vendor.product_id
	INNER JOIN vendor 
		ON product_to_vendor.vendor_id = vendor.vendor_id
	INNER JOIN product_to_category 
		ON product.product_id = product_to_category.product_id
	LEFT OUTER JOIN action_to_content ap
		ON ap.action_id = @actionId AND ap.content_id = product.product_id AND ap.content_type_id = 2
	LEFT OUTER JOIN action_to_content av
		ON av.action_id = @actionId AND av.content_id = vendor.vendor_id AND av.content_type_id = 6
	LEFT OUTER JOIN action_to_content ac
		ON ac.action_id = @actionId AND ac.content_id = product_to_category.category_id AND ac.content_type_id = 1
	LEFT OUTER JOIN action_to_content ast
		ON ast.action_id = @actionId AND ast.content_id = @siteId AND ast.content_type_id = 5

			
WHERE product_to_category.category_id <> @categoryId AND lead.created > DATEADD(m, @months, GETDATE()) AND lead.site_id = @siteId AND 
	product.enabled = 1 AND vendor.enabled = 1 AND
	(COALESCE(ap.enabled, av.enabled, ac.enabled, ast.enabled) = 1 OR 
	COALESCE(ap.enabled, av.enabled, ac.enabled, ast.enabled) IS NULL) AND
	(
	(SELECT MAX(leads_enabled) leads_enabled
	FROM (
		SELECT 
			CASE WHEN (parameter_type_id = 101 AND vendor_parameter_value = 1) THEN 1
			WHEN parameter_type_id = 47 AND vendor_parameter_value = 1 THEN 0
			WHEN parameter_type_id = 47 AND vendor_parameter_value = 0 THEN 1
			ELSE 0 
			END leads_enabled
		FROM vendor_parameter vp 
		WHERE vp.vendor_id = vendor.vendor_id
	) AS temp_leads_enabled
	) = 0) AND
	lead.content_id NOT IN
	(SELECT DISTINCT l.content_id 
	FROM lead l
	WHERE l.lead_id IN (SELECT [value] FROM global_Split(@leadIds, ',')))

GROUP BY lead.content_id
) other_user_product

ON product.product_id = other_user_product.content_id
ORDER BY leads DESC

DELETE FROM #TempProductList
WHERE id NOT IN (select max(t.id) FROM #TempProductList t
INNER JOIN product_to_vendor pv on t.id = pv.product_id
GROUP BY vendor_id)

SELECT TOP (@rows) t.id, t.site_id, t.product_Name, t.[rank], t.has_image, t.catalog_number, t.[enabled], t.modified, t.created, t.product_type, t.status, t.has_related, t.has_model, t.completeness
,t.flag1, t.flag2, t.flag3, t.flag4, t.search_rank, t.search_content_modified, t.hidden, t.business_value, t.ignore_in_rapid, t.show_in_matrix, t.show_detail_page

FROM #TempProductList t
WHERE t.id NOT IN (select content_id FROM lead l WHERE public_user_id = @userId AND 
	  created > DATEADD(m, -1, GETDATE()) AND site_id = @siteId)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByOtherUserRequestedList TO VpWebApp 
GO

------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductForSearchList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductForSearchList
	@siteId int,
	@search varchar(255),
	@categoryId int, 
	@vendorId int,
	@startIndex int,
	@endIndex int,
	@sortBy varchar(8),
	@total int output,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@filterVendorIds varchar(MAX),
	@sortBySpecificationTypeId int,
	@sortOrderBy varchar(4)
AS
-- ==========================================================================
-- Author: Naveen
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #search_product (search_product_id int)

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, vendor_name varchar(100), price money, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL,
		show_in_matrix bit, show_detail_page bit)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

	INSERT INTO #search_product
	SELECT DISTINCT content_id AS search_product_id
	FROM FREETEXTTABLE(content_text, *, @search) RankedTable
		INNER JOIN content_text
			ON [KEY] = content_text.content_text_id AND content_text.site_id = @siteId
		INNER JOIN product_to_category
			ON content_type_id IN (2,3) AND content_id = product_to_category.product_id
	WHERE content_text.enabled = '1' AND product_to_category.category_id = @categoryId


	--Populate filtered products with calculated total rank
	INSERT INTO #total_ranked_product
	SELECT product.product_id, product.site_id, product.parent_product_id
		, product.product_name, product.[rank]
		, product.has_image, product.catalog_number, product.enabled, product.modified
		, product.created
		, CASE WHEN product.[rank] = 3 THEN 6
			WHEN vendor.[rank] = 3 THEN 5
			ELSE product.[rank] + vendor.[rank]
			END total_rank
		, vendor.vendor_name
		, NULL
		, vendor.vendor_id
		, product.product_type
		, product.status
		, product.has_related
		, product.has_model
		, product.completeness
		, product.flag1
		, product.flag2
		, product.flag3
		, product.flag4
		, product.search_rank
		, product.search_content_modified
		, product.hidden
		, product.business_value
		, product.ignore_in_rapid
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
		, NULL
		,product.show_in_matrix
		,product.show_detail_page
	FROM product
		INNER JOIN #search_product ON search_product_id = product.product_id
		INNER JOIN product_to_category
			ON product.product_id = product_to_category.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id
	WHERE product_to_category.category_id = @categoryId AND 
		product.enabled = 1 AND 
		product_to_category.enabled = 1 AND 
		vendor.enabled = 1 AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)

	--Increase the vendors total rank
	--If vendor id is passed to the sp and sort parameter is by 'rank' we need to boost the rank.
	--Number 8 is used to boost since the rank at the moment of all products going to be below 8. 
	IF @vendorId IS NOT NULL
	BEGIN
		UPDATE #total_ranked_product
		SET total_rank = total_rank + 8
		WHERE vendor_id = @vendorId
	END

	--- update price to the temporary table, to sort with price.
	UPDATE #total_ranked_product
	SET price =  (
		SELECT TOP 1 price
		FROM product_to_vendor_to_price p
		WHERE p.product_to_vendor_id = #total_ranked_product.product_to_vendor_id
			AND
			(
				(p.country_flag1 & @countryFlag1 > 0) OR (p.country_flag2 & @countryFlag2 > 0) OR 
				(p.country_flag3 & @countryFlag3 > 0) OR (p.country_flag4 & @countryFlag4 > 0)
			)
		ORDER BY p.country_flag1, p.country_flag2, p.country_flag3, p.country_flag4)	

	IF (@sortBySpecificationTypeId > 0)
	BEGIN
		UPDATE #total_ranked_product
		SET #total_ranked_product.specification = s.specification
		FROM #total_ranked_product p 
			INNER JOIN specification s
				ON s.content_type_id = 2 AND s.content_id = p.product_id
		WHERE s.spec_type_id = @sortBySpecificationTypeId
	END

	--Populate with row number columns
	DECLARE @query nvarchar(MAX)
	SET @query = 'INSERT INTO #temp_product
		SELECT product_id, site_id, '
	IF (@sortBySpecificationTypeId > 0)
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY specification ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE IF (@sortBy = 'Product')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY product_name ' + @sortOrderBy + ') AS row, '
	ELSE IF (@sortBy = 'Vendor')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY vendor_name ' + @sortOrderBy + ', product_name) AS row, '
	ELSE IF (@sortBy = 'Price')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE  
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row, '
	
	SET @query = @query + 'parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM #total_ranked_product '	

	IF (DATALENGTH(@filterVendorIds) > 0)
		SET @query = @query + 'WHERE parent_vendor_id IN (SELECT [value] FROM Global_Split(''' + @filterVendorIds + ''','',''))'

	EXECUTE sp_executesql @query

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status, has_related, has_model
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductForSearchList TO VpWebApp
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsByOtherUserRequestedListCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsByOtherUserRequestedListCategoryId
	@siteId int,
	@categoryId int,
	@actionId int,
	@productIds varchar(255),
	@rows int,
	@userId int,
	@leadIds varchar(255)
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
SET NOCOUNT ON;

CREATE TABLE #TempProductList
	(
		id int NOT NULL,
		site_id int NOT NULL,
		product_name varchar(500) NOT NULL,
		rank int NOT NULL,
		has_image bit NOT NULL,
		catalog_number varchar(255) NULL,
		enabled bit NOT NULL,
		modified smalldatetime NOT NULL,
		created smalldatetime NOT NULL,
		product_type int NOT NULL DEFAULT ((1)),
		status int NOT NULL DEFAULT ((0)),
		has_related bit NOT NULL,
		has_model bit NOT NULL,
		completeness int NOT NULL,
		leads int,
		flag1 bigint,
		flag2 bigint,
		flag3 bigint,
		flag4 bigint,
		search_rank int,
		search_content_modified bit,
		hidden bit,
		business_value int,
		ignore_in_rapid bit,
		show_in_matrix bit,
		show_detail_page bit
	)

DECLARE @months int
SET @months = -1

INSERT INTO #TempProductList

SELECT DISTINCT product.product_id as id, product.site_id as site_id, product.product_name as product_name, product.rank as rank, 
				product.has_image as has_image, product.catalog_number as catalog_number, product.enabled as enabled, 
				product.modified as modified, product.created as created, product.product_type as product_type, product.status as status,
				product.has_related as has_related, product.has_model as has_model, 
				product.completeness as completeness, leads as leads, 
				product.flag1, product.flag2, product.flag3, product.flag4,
				product.search_rank, product.search_content_modified, product.hidden, product.business_value, product.ignore_in_rapid,
				product.show_in_matrix, product.show_detail_page

FROM product
INNER JOIN
(
	SELECT lead.content_id, count(lead.content_id) AS leads
	FROM lead
	  INNER JOIN product 
			ON lead.content_id = product.product_id AND lead.content_type_id in (2,21)
	  INNER JOIN product_to_vendor 
            ON product.product_id = product_to_vendor.product_id
      INNER JOIN vendor 
            ON product_to_vendor.vendor_id = vendor.vendor_id
      INNER JOIN product_to_category 
            ON product.product_id = product_to_category.product_id
	  
      LEFT OUTER JOIN action_to_content ap
            ON ap.action_id = @actionId AND ap.content_id = product.product_id AND ap.content_type_id = 2
      LEFT OUTER JOIN action_to_content av
            ON av.action_id = @actionId AND av.content_id = vendor.vendor_id AND av.content_type_id = 6
      LEFT OUTER JOIN action_to_content ac
            ON ac.action_id = @actionId AND ac.content_id = product_to_category.category_id AND ac.content_type_id = 1
      LEFT OUTER JOIN action_to_content ast
            ON ast.action_id = @actionId AND ast.content_id = @siteId AND ast.content_type_id = 5
	  
	WHERE product_to_category.category_id = @categoryId AND
		  product.product_id NOT IN (SELECT [value] FROM global_Split(@productIds, ',')) AND
		  product.product_id NOT IN 
		  (SELECT l.content_id 
		  FROM lead l
		  WHERE l.lead_id IN (SELECT [value] FROM global_Split(@leadIds, ','))) AND
		  product.enabled = 1 AND vendor.enabled = 1 AND
		  (COALESCE(ap.enabled, av.enabled, ac.enabled, ast.enabled) = 1 OR 
		  COALESCE(ap.enabled, av.enabled, ac.enabled, ast.enabled) IS NULL) AND
		  (
		  (SELECT MAX(leads_enabled) leads_enabled
		  FROM (
				SELECT 
					  CASE	WHEN (parameter_type_id = 101 AND vendor_parameter_value = 1) THEN 1
							WHEN parameter_type_id = 47 AND vendor_parameter_value = 1 THEN 0
							WHEN parameter_type_id = 47 AND vendor_parameter_value = 0 THEN 1
							ELSE 0 
					  END leads_enabled
				FROM vendor_parameter vp 
				WHERE vp.vendor_id = vendor.vendor_id
		  ) AS temp_leads_enabled
		  ) = 0)

GROUP BY lead.content_id
) other_user_product

ON product.product_id = other_user_product.content_id
ORDER BY leads DESC


DELETE FROM #TempProductList
WHERE id NOT IN (select max(t.id) FROM #TempProductList t
INNER JOIN product_to_vendor pv on t.id = pv.product_id
GROUP BY vendor_id)

SELECT TOP (@rows) t.id, t.site_id, t.product_Name, t.[rank], t.has_image
	, t.catalog_number, t.[enabled], t.modified, t.created, t.product_type
	, t.status, t.has_related, t.has_model, t.completeness, t.leads
	, t.flag1, t.flag2, t.flag3, t.flag4, t.search_rank, t.search_content_modified, t.hidden, t.business_value, t.ignore_in_rapid
	, t.show_in_matrix, t.show_detail_page
FROM #TempProductList t
WHERE t.id NOT IN (select content_id FROM lead l WHERE public_user_id = @userId AND 
	  created > DATEADD(m, @months, GETDATE()) AND site_id = @siteId)

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsByOtherUserRequestedListCategoryId TO VpWebApp 
GO
-------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsSearchResults'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsSearchResults
	@productIds varchar(8000),
	@startIndex int,
	@endIndex int,
	@sortBy varchar(20),
	@total int output,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@filterVendorIds varchar(MAX)
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	--Create temp table to store the product ids ordered by its relevancy score
	CREATE TABLE #relevancy_based_product(relevancy_id int identity(1,1) , product_id int)

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, relevancy_order int, vendor_name varchar(100), price money
		, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, product_row int, vendor_row int
		, price_row int, relevancy_row int, rank_row int, parent_product_id int
		, product_name varchar(500), [rank] int
		, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit
		, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

	--Populate relevancy based product results
	INSERT INTO #relevancy_based_product
	SELECT [value] FROM global_Split(@productIds, ',')
	
	--Populate filtered products with calculated total rank
	INSERT INTO #total_ranked_product
	SELECT product.product_id, product.site_id, product.parent_product_id
		, product.product_name, product.[rank]
		, product.has_image, product.catalog_number, product.enabled, product.modified
		, product.created
		, CASE WHEN product.[rank] = 3 THEN 6
			WHEN vendor.[rank] = 3 THEN 5
			ELSE product.[rank] + vendor.[rank]
			END total_rank
		, rbp.relevancy_id
		, vendor.vendor_name
		, null
		, vendor.vendor_id
		, product.product_type
		, product.status
		, product.has_related
		, product.has_model
		, product.completeness
		, product.flag1
		, product.flag2
		, product.flag3
		, product.flag4
		, product.search_rank
		, product.search_content_modified
		, product.hidden
		, product.business_value
		, product.ignore_in_rapid
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
		,product.show_in_matrix
		,product.show_detail_page
	FROM product
		INNER JOIN #relevancy_based_product AS rbp
			ON rbp.product_id = product.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id

	WHERE product.enabled = 1 AND vendor.enabled = 1 AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)

	--- update price to the temporary table, to sort with price.
	UPDATE #total_ranked_product
	SET price =  product_to_vendor_to_price.price	
	FROM  #total_ranked_product
		INNER JOIN product_to_vendor_to_price
			ON product_to_vendor_to_price.product_to_vendor_id = #total_ranked_product.product_to_vendor_id
				AND product_to_vendor_to_price.price =
				(SELECT TOP(1) product_to_vendor_to_price.price  
				FROM product_to_vendor_to_price 
				WHERE #total_ranked_product.product_to_vendor_id = product_to_vendor_to_price.product_to_vendor_id
					AND
					(
						(product_to_vendor_to_price.country_flag1 & @countryFlag1 > 0) OR (product_to_vendor_to_price.country_flag2 & @countryFlag2 > 0) OR 
						(product_to_vendor_to_price.country_flag3 & @countryFlag3 > 0) OR (product_to_vendor_to_price.country_flag4 & @countryFlag4 > 0)
					)					
				)


	--Populate with row number columns
	INSERT INTO #temp_product
	SELECT product_id, site_id
		, ROW_NUMBER() OVER(ORDER BY product_name) AS product_row
		, ROW_NUMBER() OVER(ORDER BY vendor_name, product_name) AS vendor_row
		, ROW_NUMBER() OVER(ORDER BY price) AS price_row
		, ROW_NUMBER() OVER(ORDER BY relevancy_order) AS relevancy_row
		, ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS rank_row
		, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		, parent_vendor_id
	FROM #total_ranked_product
	WHERE	(
			DATALENGTH(@filterVendorIds) = 0 
			OR
			parent_vendor_id IN (SELECT [value] FROM Global_Split(@filterVendorIds, ','))
		)

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT id, site_id, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page
	FROM
	(
		SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, enabled, modified, created, product_type, status
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page
			, CASE @sortBy
				WHEN 'Product' THEN product_row
				WHEN 'Vendor' THEN vendor_row
				WHEN 'Price' THEN price_row
				WHEN 'Relevancy' THEN relevancy_row
				ELSE rank_row
			END AS row
		FROM #temp_product
	) AS temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #relevancy_based_product
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsSearchResults TO VpWebApp
GO
           
BEGIN TRY

    BEGIN TRAN  
    
    DECLARE @moduleInstanceId INT 

    DECLARE module_instances_cursor CURSOR
    FOR
        SELECT  module_instance_id 
FROM    dbo.page
        INNER JOIN dbo.module_instance ON dbo.page.page_id = dbo.module_instance.page_id
WHERE   ( page_name = 'VerticalMatrix'
          OR page_name = 'HorizontalMatrix'
        )
        AND ( module_instance.title = 'Horizontal Matrix'
              OR module_instance.title = 'Vertical Matrix'
            )           
            

    OPEN module_instances_cursor   
    FETCH NEXT FROM module_instances_cursor INTO @moduleInstanceId   

    WHILE @@FETCH_STATUS = 0 
        BEGIN        

            
            IF ( NOT EXISTS ( SELECT    *
                              FROM      [module_instance_setting]
                              WHERE     [module_instance_id] = @moduleInstanceId
                                        AND [name] = 'MatrixShowMoreVersionsText' )
               ) 
                BEGIN 
           
                 
   
                    INSERT  INTO [module_instance_setting]
                            ( [module_instance_id] ,
                              [name] ,
                              [value] ,
                              [enabled] ,
                              [modified] ,
                              [created]
                                
                            )
                    VALUES  ( @moduleInstanceId ,
                              'MatrixShowMoreVersionsText' ,
                              'Show More Versions' ,
                              1 ,
                              GETDATE() ,
                              GETDATE()
                            )                       
                        
                END           
            
            FETCH NEXT FROM module_instances_cursor INTO @moduleInstanceId            
        
        END    
       
        

    CLOSE module_instances_cursor   
    DEALLOCATE module_instances_cursor

    COMMIT TRAN

END TRY
BEGIN CATCH
    ROLLBACK TRAN

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT  @ErrorMessage = ERROR_MESSAGE() ,
            @ErrorSeverity = ERROR_SEVERITY() ,
            @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH 

