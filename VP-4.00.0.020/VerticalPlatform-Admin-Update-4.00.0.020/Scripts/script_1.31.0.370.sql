UPDATE segment
SET capped_applicable = 1
WHERE segment_type = 1

-----------

UPDATE public_user_field_to_field_option
SET enabled = 1
WHERE enabled = 0

-----------
EXEC dbo.global_DropStoredProcedure 'dbo.adminField_GetFieldToFieldsByDestinationField'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminField_GetFieldToFieldsByDestinationField
	@destinationField int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT field_to_field_id as id, source_field, destination_field, prerequisite_field, prerequisite_field_option, enabled, created, modified
	FROM field_to_field
	WHERE destination_field = @destinationField

END
GO

GRANT EXECUTE ON dbo.adminField_GetFieldToFieldsByDestinationField TO VpWebApp 
GO

-----------


EXEC dbo.global_DropStoredProcedure 'dbo.adminField_GetFieldToFieldsByPrerequisiteField'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminField_GetFieldToFieldsByPrerequisiteField
	@prerequisiteField int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT field_to_field_id as id, source_field, destination_field, prerequisite_field, prerequisite_field_option, enabled, created, modified
	FROM field_to_field
	WHERE prerequisite_field = @prerequisiteField

END
GO

GRANT EXECUTE ON dbo.adminField_GetFieldToFieldsByPrerequisiteField TO VpWebApp 
GO
---------------------------------------------------------------------------------------
IF NOT EXISTS 
(
SELECT [name] FROM syscolumns where [name] = 'sort_order' AND id = 
(SELECT object_id FROM sys.objects 
WHERE object_id = OBJECT_ID(N'product_compression_group') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [product_compression_group]
	ADD sort_order int null
END
GO
----------------------------------------------------------------------------------------
IF EXISTS
(SELECT [name] FROM syscolumns where [name] = 'sort_order' AND id = (SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'product_compression_group') AND type in (N'U')))
		BEGIN
			UPDATE product_compression_group SET sort_order = 0
		END
GO
----------------------------------------------------------------------------------------
IF EXISTS
(SELECT [name] FROM syscolumns where [name] = 'sort_order' AND id = (SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'product_compression_group') AND type in (N'U')))
		BEGIN
			ALTER TABLE product_compression_group
			ALTER COLUMN sort_order int not null
		END
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
	@sortOrder int,
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
		   ,[group_name]
		   ,[sort_order])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created, @isDefault, @groupName, @sortOrder)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
----------------------------------------------------------------------------------------
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
		, created, modified, is_default, group_name, sort_order) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY sort_order) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified, is_default, group_name, sort_order
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified, is_default, group_name, sort_order
	FROM temp_product_compression_group 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified, is_default, group_name, sort_order
	FROM [dbo].[product_compression_group]
	WHERE group_name like @searchText +'%' AND site_id = @siteId
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
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
	  ,gro.[sort_order]
	FROM [product_compression_group] gro
		INNER JOIN product_compression_group_to_product groPro
			ON gro.product_compression_group_id = groPro.product_compression_group_id
	WHERE groPro.product_id = @productID
	ORDER BY gro.[sort_order]

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsByProductID TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompressionGroupsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompressionGroupsBySiteId 
@siteId INT
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
				group_name ,
				sort_order
        FROM    dbo.product_compression_group
        WHERE   site_id = @siteId

    END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsBySiteId TO VpWebApp 
GO
----------------------------------------------------------------------------------------
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
	@sortOrder int,
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
	  ,[sort_order] = @sortOrder
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroup TO VpWebApp 
GO
----------------------------------------------------------------------------------------
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
		proGro.site_id, proGro.enabled, proGro.created, proGro.modified, proGro.is_default, proGro.group_name, proGro.sort_order
	FROM product_compression_group proGro
		INNER JOIN product_compression_group_to_product groPro
			ON groPro.product_compression_group_id = progro.product_compression_group_id
		INNER JOIN product_to_product pp
			ON pp.product_id = groPro.product_id
	WHERE proGro.site_id = @siteId AND
		pp.parent_product_id = @parentProductId
	ORDER BY proGro.sort_order
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByParentProductIdSiteIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList
    @productIds VARCHAR(4000),
    @categoryId INT,
    @countryFlag1 BIGINT ,	
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS
-- ==========================================================================  
-- Author : Dimuthu  
-- ==========================================================================  

    BEGIN  
  
        SET NOCOUNT ON;    
    
        SELECT  c.product_compression_group_id AS id ,
                site_id ,
                show_in_matrix ,
                show_product_count ,
                group_title ,
                expand_products ,
                enabled ,
                created ,
                modified ,
                is_default ,
                group_name ,
				c.sort_order ,
                product_id ,
                product_count
        FROM    ( SELECT    CAST(p.[value] AS INT) AS product_id ,
                            cp.product_compression_group_id ,
                            COUNT(*) product_count
                  FROM      product_to_product pp
                            INNER JOIN global_Split(@productIds, ',') AS p ON pp.parent_product_id = p.[value]
                            INNER JOIN product ON pp.product_id = product.product_id
                            INNER JOIN product_compression_group_to_product cp ON pp.product_id = cp.product_id
                            INNER JOIN dbo.product_to_category ptc ON pp.product_id = ptc.product_id
                  WHERE     ( product.flag1 & @countryFlag1 > 0 )
                            OR ( product.flag2 & @countryFlag2 > 0 )
                            OR ( product.flag3 & @countryFlag3 > 0 )
                            OR ( product.flag4 & @countryFlag4 > 0 )
							AND product.enabled = 1
                            AND pp.enabled = 1
                            AND ptc.enabled = 1
                            AND ptc.category_id = @categoryId
                  GROUP BY  p.[value] ,
                            cp.product_compression_group_id
                ) g
                INNER JOIN product_compression_group c ON g.product_compression_group_id = c.product_compression_group_id
		ORDER BY c.sort_order
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsList
    @productIds VARCHAR(4000) ,
    @countryFlag1 BIGINT ,
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS -- ==========================================================================  
-- Author : Dimuthu  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
  
        SELECT  c.product_compression_group_id AS id ,
                site_id ,
                show_in_matrix ,
                show_product_count ,
                group_title ,
                expand_products ,
                enabled ,
                created ,
                modified ,
                is_default ,
				group_name ,
				c.sort_order ,
                product_id ,
                product_count
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
	ORDER BY c.sort_order

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
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
	  ,[sort_order]
	FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id
	ORDER BY sort_order

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList
	@categoryId int,
	@productId int,
	@childProductIds varchar(500)
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_compression_group.product_compression_group_id AS id, product_compression_group.site_id, 
		product_compression_group.show_in_matrix, show_product_count, group_title,expand_products, 
		product_compression_group.[enabled], product_compression_group.created, product_compression_group.modified, 
		is_default, group_name, product_compression_group_to_product.product_id, product_compression_group.sort_order
	FROM product_to_product
		INNER JOIN product_to_category
			ON product_to_product.product_id = product_to_category.product_id
		INNER JOIN product_compression_group_to_product
			ON product_compression_group_to_product.product_id = product_to_product.product_id
		INNER JOIN product_compression_group
			ON product_compression_group_to_product.product_compression_group_id = product_compression_group.product_compression_group_id
		INNER JOIN Global_Split(@childProductIds, ',') children
			ON product_to_product.product_id = children.[value]
	WHERE product_to_product.parent_product_id = @productId AND product_to_category.category_id = @categoryId 
	ORDER BY product_compression_group.product_compression_group_ID

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM [parameter_type] WHERE [parameter_type] = 'HasSitemapPriorityTag')
BEGIN
INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
VALUES (144,'HasSitemapPriorityTag','1',GETDATE(),GETDATE())
END
----------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM [parameter_type] WHERE [parameter_type] = 'PagePriority')
BEGIN
INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
VALUES (145,'PagePriority','1',GETDATE(),GETDATE())
END
----------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM [parameter_type] WHERE [parameter_type] = 'ChangeFrequency')
BEGIN
INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
VALUES (146,'ChangeFrequency','1',GETDATE(),GETDATE())
END
----------------------------------------------------------------------------------------------
IF NOT EXISTS(select * from sys.columns where Name = N'hidden' and Object_ID = Object_ID(N'category_to_category_branch'))
	BEGIN
		ALTER TABLE category_to_category_branch ADD [hidden] bit NOT NULL DEFAULT 0
	END
GO
-----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddCategoryBranch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddCategoryBranch
	@categoryId int,
	@subCategoryId int,
	@categoryBranchTypeId int,
	@displayName varchar(255),
	@displayInDigestView bit,
	@enabled bit,
	@hidden bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
--- $Author: sujith  
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO category_to_category_branch (category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden)
	VALUES (@categoryId, @subCategoryId, @categoryBranchTypeId, @enabled, @created
		, @created, @displayName, @displayInDigestView, @hidden)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddCategoryBranch TO VpWebApp 
GO
--------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBranchDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryBranchDetail
	@id int
AS
-- ==========================================================================
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden
	FROM category_to_category_branch
	WHERE category_to_category_branch_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryBranchDetail TO VpWebApp 
GO
-----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateCategoryBranch'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateCategoryBranch
	@id int,
	@categoryId int,
	@subCategoryId int,
	@categoryBranchTypeId int,
	@displayName varchar(255),
	@displayInDigestView bit,
	@enabled bit,
	@hidden bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE category_to_category_branch
	SET category_id = @categoryId
		, sub_category_id = @subCategoryId
		, category_branch_type_id = @categoryBranchTypeId
		, enabled = @enabled
		, modified = @modified
		, display_name = @displayName
		, display_in_digest_view = @displayInDigestView
		, hidden = @hidden 
	WHERE category_to_category_branch_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateCategoryBranch TO VpWebApp 
GO
---------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId
	@categoryId int,
	@subCategoryId int
AS
-- ==========================================================================
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
		, enabled, modified, created, display_name, display_in_digest_view, hidden
	FROM category_to_category_branch
	WHERE category_id = @categoryId AND sub_category_id = @subCategoryId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryBranchByCategoryIdSubCategoryId TO VpWebApp 
GO
------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBranchByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryBranchByCategoryIdList
	@categoryId int
AS

-- ==========================================================================
-- $Author: kasun $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	WITH cte(id, category_id, sub_category_id, category_branch_type_id, display_name, display_in_digest_view
		, enabled, modified, created, hidden) AS
	(
		SELECT category_to_category_branch_id AS id, category_id, sub_category_id, category_branch_type_id
			, display_name, display_in_digest_view, enabled, modified, created, hidden
		FROM category_to_category_branch
		WHERE sub_category_id = @categoryId AND enabled = '1'

		UNION ALL

		SELECT cb.category_to_category_branch_id AS id, cb.category_id, cb.sub_category_id, cb.category_branch_type_id
			, cb.display_name, cb.display_in_digest_view, cb.enabled, cb.modified, cb.created, cb.hidden
		FROM category_to_category_branch cb
				INNER JOIN cte
					ON cb.sub_category_id = cte.category_id
		WHERE cb.[enabled] = '1'
	)

	SELECT id, category_id, sub_category_id, category_branch_type_id, display_name, display_in_digest_view
		, enabled, modified, created, hidden
	FROM cte

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoryBranchByCategoryIdList TO VpWebApp
GO
---------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryByParentCategoryIdIsSelectedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryByParentCategoryIdIsSelectedList
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryByParentCategoryIdIsSelectedList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed
		, enabled, modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
	FROM
	(
		SELECT category.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category
			, is_displayed, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, 
			category.hidden, has_image, url_id
			, CASE
				WHEN (category_to_category_branch.display_name IS NOT NULL AND category_to_category_branch.display_name <> '')  THEN category_to_category_branch.display_name
				WHEN short_name IS NULL THEN category_name
				WHEN short_name = '' THEN category_name
				ELSE short_name
			END sort_name
		FROM category 
	 		INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId 
			AND category_to_category_branch.enabled = '1'
			AND category_to_category_branch.display_in_digest_view = '1'
			AND category.enabled = '1'
	) temp_table
	ORDER BY sort_name
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryByParentCategoryIdIsSelectedList TO VpWebApp 
GO
-------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryBySubCategoryIdBranchEnabledList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryBySubCategoryIdBranchEnabledList
	@subCategoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetCategoryBySubCategoryIdBranchEnabledList.sql $
-- $Revision: 8895 $
-- $Date: 2011-02-03 18:36:24 +0530 (Thu, 03 Feb 2011) $ 
-- $Author: kasun $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id
		, [description], short_name, specification , category.is_search_category
		, category.is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.category_id
	WHERE category_to_category_branch.sub_category_id = @subCategoryId 
		AND category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0'

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoryBySubCategoryIdBranchEnabledList TO VpWebApp 
GO
----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByChildCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryByChildCategoryIdList
	@childCategoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetCategoryByChildCategoryIdList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification , category.is_search_category
			, category.is_displayed, category.enabled, category.modified, category.created, matrix_type, product_count
			, auto_generated, category.hidden, has_image, url_id
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.category_id
	WHERE category_to_category_branch.sub_category_id = @childCategoryId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategoryByChildCategoryIdList TO VpWebApp 
GO

--------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsOrVendorsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryHavingProductsOrVendorsList
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryHavingProductsOrVendorsList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
	FROM
	(
	SELECT category.category_id
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
		AND category_to_category_branch.hidden = '0' AND category.hidden = 0
		AND
		(
			(category_type_id <> 4)
			OR 
			(
				(SELECT COUNT(product_id)
				FROM product_to_category
				WHERE product_to_category.category_id = category.category_id) > 0
			)
		)

	UNION

	SELECT category.category_id
	FROM category
		INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
		INNER JOIN category_to_vendor
			ON category.category_id = category_to_vendor.category_id
		INNER JOIN vendor
			ON category_to_vendor.vendor_id = vendor.vendor_id
	WHERE 
		category_to_category_branch.category_id = @categoryId 
		AND 
		category_to_category_branch.enabled = '1' AND category_to_category_branch.hidden = '0'
		AND
		category.category_type_id = 4
		AND
		vendor.[enabled] = '1' AND category_to_vendor.[enabled] = '1'
		AND
		category.hidden = 0
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	ORDER BY category_name
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsOrVendorsList TO VpWebApp 
GO
---------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryHavingProductsList
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryHavingProductsList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
		AND category.hidden = 0
		AND
		(
			(category_type_id <> 4)
			OR 
			(
				(SELECT COUNT(product_id)
				FROM product_to_category
				WHERE product_to_category.category_id = category.category_id) > 0
			)
		)
	ORDER BY category_name
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsList TO VpWebApp 
GO
-------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildCategoriesByCategoryIdProductExistenceSortedByDisplayNameWithManualCategoryIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetChildCategoriesByCategoryIdProductExistenceSortedByDisplayNameWithManualCategoryIdsList
	@categoryId int,
	@manualCategoryIds varchar(max)
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;


	SELECT id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed, [enabled]
		, modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
	FROM
	(
		SELECT category.category_id AS id, site_id, category_name, category_type_id, [description]
			, short_name, specification, is_search_category, is_displayed
			, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
			, CASE
					WHEN category_to_category_branch.display_name IS NULL THEN category_name
					WHEN category_to_category_branch.display_name = '' THEN category_name
					ELSE category_to_category_branch.display_name
				END sort_name
		FROM category 
	 		INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
			AND category_to_category_branch.hidden = '0'
			AND
			(
				(category_type_id <> 4)
				OR 
				(
					(SELECT COUNT(product_id)
					FROM product_to_category
					WHERE product_to_category.category_id = category.category_id) > 0
				)
			)

		UNION
		
		SELECT category.category_id AS id, site_id, category_name, category_type_id, [description]
			, short_name, specification, is_search_category, is_displayed
			, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
			, CASE
					WHEN category_to_category_branch.display_name IS NULL THEN category_name
					WHEN category_to_category_branch.display_name = '' THEN category_name
					ELSE category_to_category_branch.display_name
				END sort_name
		FROM category 
	 		LEFT OUTER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category.category_id IN (SELECT [value] FROM global_Split(@manualCategoryIds, '|')) AND  category.[enabled] = 1
	) temp_table
	WHERE hidden = 0
	ORDER BY sort_name
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildCategoriesByCategoryIdProductExistenceSortedByDisplayNameWithManualCategoryIdsList TO VpWebApp 
GO
----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetCategoryByCategoryIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminCategory_GetCategoryByCategoryIdsList]
	@categoryIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
			, cat.description, cat.short_name, cat.specification, cat.is_search_category 
			, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count
			, auto_generated, cat.hidden, has_image, url_id
	FROM category AS cat 
		INNER JOIN global_Split(@categoryIds, ',') AS category_id_table
			ON cat.category_id = category_id_table.[value]
		INNER JOIN category_to_category_branch cat_cat 
			ON cat_cat.sub_category_id = cat.category_id
	WHERE (cat_cat.enabled = 1 AND cat.enabled = 1 AND cat.hidden = 0)
END
GO

GRANT EXECUTE ON dbo.adminCategory_GetCategoryByCategoryIdsList TO VpWebApp 
GO
---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsSortedByDisplayNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryHavingProductsSortedByDisplayNameList
	@categoryId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicProduct_GetCategoryHavingProductsSortedByDisplayNameList.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;


	SELECT id, site_id, category_name, category_type_id, [description], short_name
		, specification, is_search_category, is_displayed, [enabled]
		, modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
	FROM
	(
		SELECT category.category_id AS id, site_id, category_name, category_type_id, [description]
			, short_name, specification, is_search_category, is_displayed
			, category.enabled, category.modified, category.created, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
			, CASE
					WHEN category_to_category_branch.display_name IS NULL THEN category_name
					WHEN category_to_category_branch.display_name = '' THEN category_name
					ELSE category_to_category_branch.display_name
				END sort_name
		FROM category 
	 		INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
			AND category.hidden = 0
			AND
			(
				(category_type_id <> 4)
				OR 
				(
					(SELECT COUNT(product_id)
					FROM product_to_category
					WHERE product_to_category.category_id = category.category_id) > 0
				)
			)
	) temp_table
	ORDER BY sort_name
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsSortedByDisplayNameList TO VpWebApp 
GO
----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildCategoriesByCategoryIdProductOrVendorExistenceWithCategoryIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetChildCategoriesByCategoryIdProductOrVendorExistenceWithCategoryIdsList
	@categoryId int,
	@manualCategoryIds varchar(max)
AS
-- ==========================================================================
-- $Author: Anuradha Malalasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, hidden, has_image, url_id
	FROM
	(
	SELECT category.category_id
	FROM category 
	 	INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
	WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = '1'
		AND category_to_category_branch.hidden = '0'
		AND
		(
			(category_type_id <> 4)
			OR 
			(
				(SELECT COUNT(product_id)
				FROM product_to_category
				WHERE product_to_category.category_id = category.category_id) > 0
			)
		)

	UNION

	SELECT category.category_id
	FROM category
		INNER JOIN category_to_category_branch
			ON category.category_id = category_to_category_branch.sub_category_id
		INNER JOIN category_to_vendor
			ON category.category_id = category_to_vendor.category_id
		INNER JOIN vendor
			ON category_to_vendor.vendor_id = vendor.vendor_id
	WHERE 
		category_to_category_branch.category_id = @categoryId 
		AND 
		category_to_category_branch.enabled = '1'
		AND 
		category_to_category_branch.hidden = '0'
		AND
		category.category_type_id = 4
		AND
		vendor.[enabled] = '1' AND category_to_vendor.[enabled] = '1'

	UNION
	
	SELECT category_id
	FROM category 
	WHERE category.category_id IN (SELECT [value] FROM global_Split(@manualCategoryIds, '|')) AND category.[enabled] = 1
	
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	WHERE hidden = 0
	ORDER BY category_name
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildCategoriesByCategoryIdProductOrVendorExistenceWithCategoryIdsList TO VpWebApp 
GO

-------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminLead_GetLeadBySiteIdLeadStatusList'

/****** Object:  StoredProcedure [dbo].[adminLead_GetLeadBySiteIdLeadStatusList]    Script Date: 02/19/2013 11:30:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminLead_GetLeadBySiteIdLeadStatusList]
	@siteId int,
	@startIndex int,
	@endIndex int,
	@leadStatus varchar(50),
	@noOfRows int output
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY lead_id desc) AS row
	, lead_id AS id, site_id, public_user_id, action_id, content_type_id
	, content_id, vendor_id, ip, ip_numeric, lead_status_id
	, archived, [enabled], modified, created, group_id, origin, lead_form_id
	INTO #temp_lead
	FROM lead
	WHERE site_id = @siteId 
		AND (@leadStatus IS NULL OR
		lead_status_id IN
			(
			SELECT [value]
			FROM global_Split(@leadStatus, ',')
			))

	SELECT id, site_id, public_user_id, action_id, content_type_id
			, content_id, vendor_id, ip, ip_numeric, lead_status_id
			, archived, [enabled], modified, created, group_id, origin, lead_form_id
	FROM #temp_lead as a
	WHERE row BETWEEN @startIndex AND @endIndex

	SELECT @noOfRows = COUNT(*) FROM #temp_lead
	DROP TABLE #temp_lead

END
GO

GRANT EXECUTE ON dbo.adminLead_GetLeadBySiteIdLeadStatusList TO VpWebApp 
GO
---------------------------------------------------------------------------------


IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'default_rank' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product') AND type in (N'U'))
)
BEGIN
	ALTER TABLE product
	ADD default_rank int not null default '0'
END
GO
-----------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'default_search_rank' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product') AND type in (N'U'))
)
BEGIN
	ALTER TABLE product
	ADD default_search_rank int not null default '0'
END
GO

-------------------------------------------------------------------

IF EXISTS

(

    SELECT [name] FROM syscolumns where [name] = 'previous_rank' AND id =

        (SELECT object_id FROM sys.objects

        WHERE object_id = OBJECT_ID(N'[dbo].product_display_status') AND type in (N'U'))

)

BEGIN

    IF NOT EXISTS

    (

        SELECT * FROM product WHERE default_rank <> 0

    )

    BEGIN

        UPDATE p

        SET p.default_rank = pds.previous_rank,

            p.default_search_rank = p.search_rank

        FROM product p

        INNER JOIN     product_display_status pds

            ON pds.product_id = p.product_id    

    END

END

GO

 

-------------------------------------------------------------------

 

IF EXISTS

(

    SELECT [name] FROM syscolumns where [name] = 'default_rank' AND id =

    (SELECT object_id FROM sys.objects

    WHERE object_id = OBJECT_ID(N'[dbo].product') AND type in (N'U'))

)

BEGIN

      IF EXISTS (

             SELECT [name] FROM syscolumns where [name] = 'previous_rank' AND id =

                  (SELECT object_id FROM sys.objects

                  WHERE object_id = OBJECT_ID(N'[dbo].product_display_status') AND type in (N'U'))

      )

      BEGIN

            UPDATE product

            SET default_rank = rank,

                  default_search_rank = search_rank

            WHERE product.product_id NOT IN

            (

                  SELECT pds.product_id

                  FROM  product_display_status pds

            )

      END

END

GO
------------------------------------------------------

-- =====================Start : adminPlatform_GetUnindexedProductsBySiteId.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsBySiteId
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) product_id as id, site_id, product_Name, [rank], has_image
		 , catalog_number, [enabled], modified, created, product_type, status,  has_model
		 , has_related, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		 , show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product
	WHERE enabled = 1 AND site_id = @siteId AND product_id NOT IN 
		(	SELECT content_id 
			FROM search_content_status
			WHERE site_id=@siteId AND content_type_id = 2
		)
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteId TO VpWebApp
GO
--
--
-- =====================End : adminPlatform_GetUnindexedProductsBySiteId.sql ==============================
--
-- 
-- =====================Start : adminPlatform_GetUnindexedProductsBySiteIdWithPagingList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedProduct(id, row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, 
		created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden,
		business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
)
	AS
	(
		SELECT  product_id, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified,
			created, product_type, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4, search_rank, search_content_modified
			, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product
		WHERE enabled = 1 AND site_id = @siteId
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status,
		has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
		show_in_matrix, show_detail_page, default_rank, default_search_rank

	FROM selectedProduct
	WHERE row_id BETWEEN @startIndex AND @endIndex
	ORDER BY row_id
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList TO VpWebApp
GO

--
--
-- =====================End : adminPlatform_GetUnindexedProductsBySiteIdWithPagingList.sql ==============================
--
-- 
-- =====================Start : adminProduct_AddProduct.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProduct
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank int,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank int
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO product(site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank) 
	VALUES (@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @created, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue,@ignoreInRapid, @showInMatrix, @showDetailPage, @defaultRank, @defaultSearchRank) 

	SET @id = SCOPE_IDENTITY() 

END

GO

GRANT EXECUTE ON dbo.adminProduct_AddProduct TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_AddProduct.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetEnabledProductByCategoryIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetEnabledProductByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetEnabledProductByCategoryIdList
	@categoryId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created
			, product_type, status, has_related, has_model, completeness
			, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid
			, pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank

	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @categoryId AND pro.[enabled] = 1

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetEnabledProductByCategoryIdList TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetEnabledProductByCategoryIdList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetGenericProductByCategoryIdDetail.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetGenericProductByCategoryIdDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetGenericProductByCategoryIdDetail
	@categoryId int 
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, pro.product_type, pro.status
			, pro.has_related , pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4
			, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid
			, pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank

	FROM product_to_category catPro
			INNER JOIN product pro
				ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @categoryId AND pro.product_type = 3


END
GO

GRANT EXECUTE ON dbo.adminProduct_GetGenericProductByCategoryIdDetail TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetGenericProductByCategoryIdDetail.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetIndexedProductsWithModifiedCategory.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetIndexedProductsWithModifiedCategory'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetIndexedProductsWithModifiedCategory
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) pro.product_id as id, pro.site_id, pro.product_name, pro.[rank],
				pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created,
				pro.product_type, pro.status, pro.has_model, pro.has_related, pro.completeness,
				pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid,
				pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank

	FROM
	(
		SELECT DISTINCT p.product_id
		FROM product p
			INNER JOIN product_to_category pc
				ON pc.product_id = p.product_id
			INNER JOIN category  c
				ON c.category_id = pc.category_id	
			INNER JOIN search_content_status scs
				ON scs.content_type_id = 2 AND scs.content_id = p.product_id
		WHERE  p.site_id = @siteId AND p.enabled = 1 AND c.modified > scs.modified
	) AS product_ids
	INNER JOIN product pro
		ON product_ids.product_id = pro.product_id
	ORDER BY pro.product_id
	
END

GO

GRANT EXECUTE ON dbo.adminProduct_GetIndexedProductsWithModifiedCategory TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetIndexedProductsWithModifiedCategory.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetIndexedProductsWithModifiedCategoryVendors.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetIndexedProductsWithModifiedCategoryVendors'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetIndexedProductsWithModifiedCategoryVendors
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) pro.product_id as id, pro.site_id, pro.product_name, pro.[rank],
				pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created,
				pro.product_type, pro.status, pro.has_model, pro.has_related, pro.completeness,
				pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid,
				pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank

	FROM
	(
		SELECT p.product_id
		FROM product p
			INNER JOIN product_to_category pc
				ON pc.product_id = p.product_id AND p.site_id = @siteId AND p.enabled = 1
			INNER JOIN category_to_vendor cv
				ON cv.category_id = pc.category_id
			INNER JOIN vendor AS v
				ON v.vendor_id = cv.vendor_id
			INNER JOIN search_content_status scs
				ON scs.content_type_id = 2 AND scs.content_id = p.product_id AND v.modified > scs.modified
				
		UNION
		
		SELECT p.product_id
		FROM product p
			INNER JOIN product_to_category pc
				ON pc.product_id = p.product_id AND p.site_id = @siteId AND p.enabled = 1
			INNER JOIN category_to_vendor cv
				ON cv.category_id = pc.category_id
			INNER JOIN search_content_status scs
				ON scs.content_type_id = 2 AND scs.content_id = p.product_id AND cv.modified > scs.modified
				
		UNION
		
		SELECT p.product_id
		FROM product p
			INNER JOIN product_to_category pc
				ON pc.product_id = p.product_id AND p.site_id = @siteId AND p.enabled = 1
			INNER JOIN search_content_status scs
				ON scs.content_type_id = 2 AND scs.content_id = p.product_id AND pc.modified > scs.modified
	) AS product_ids
	INNER JOIN product pro
		ON product_ids.product_id = pro.product_id
END

GO

GRANT EXECUTE ON dbo.adminProduct_GetIndexedProductsWithModifiedCategoryVendors TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_GetIndexedProductsWithModifiedCategoryVendors.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetIndexedProductsWithModifiedProduct.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetIndexedProductsWithModifiedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetIndexedProductsWithModifiedProduct
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) pro.product_id as id, pro.site_id, pro.product_name, pro.[rank],
				pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, 
				pro.created, pro.product_type, pro.status, pro.has_model, pro.has_related, 
				pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4,
				pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix,
				pro.show_detail_page, pro.default_rank, pro.default_search_rank

	FROM product pro
	INNER JOIN search_content_status scs
		ON scs.content_type_id = 2 AND scs.content_id = pro.product_id 
			AND scs.site_id = @siteId AND pro.enabled = 1 AND pro.modified > scs.modified
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetIndexedProductsWithModifiedProduct TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetIndexedProductsWithModifiedProduct.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetIndexedProductsWithModifiedSearchOption.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetIndexedProductsWithModifiedSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetIndexedProductsWithModifiedSearchOption
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) pro.product_id as id, pro.site_id, pro.product_name, pro.[rank],
		pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created,
		pro.product_type, pro.status, pro.has_model, pro.has_related, pro.completeness,
		pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid,
		pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank

	FROM
	(
		SELECT DISTINCT p.product_id
		FROM product p
			INNER JOIN product_to_search_option ps
				ON ps.product_id = p.product_id
			INNER JOIN search_option so
				ON so.search_option_id = ps.search_option_id	
			INNER JOIN search_content_status scs
				ON scs.content_type_id = 2 AND scs.content_id = p.product_id
		WHERE p.site_id = @siteId AND p.enabled = 1 AND so.modified > scs.modified
	) AS product_ids
	INNER JOIN product pro
		ON product_ids.product_id = pro.product_id
	ORDER BY pro.product_id
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetIndexedProductsWithModifiedSearchOption TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetIndexedProductsWithModifiedSearchOption.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetIndexedProductsWithModifiedSpecification.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetIndexedProductsWithModifiedSpecification'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetIndexedProductsWithModifiedSpecification
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) p.product_id as id, p.site_id, p.product_name, p.[rank],
		p.has_image, p.catalog_number, p.[enabled], p.modified, p.created,
		p.product_type, p.status, p.has_model, p.has_related, p.completeness,
		p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid,
		p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank

	FROM product p
		INNER JOIN specification spec
			ON spec.content_type_id = 2 AND spec.content_id = p.product_id AND p.site_id = @siteId AND p.enabled = 1 
		INNER JOIN specification_type specType
			ON specType.spec_type_id = spec.spec_type_id
		INNER JOIN search_content_status scs
			ON scs.content_type_id = 2 AND scs.content_id = p.product_id AND specType.modified > scs.modified
		
END

GO

GRANT EXECUTE ON dbo.adminProduct_GetIndexedProductsWithModifiedSpecification TO VpWebApp 
GO



--
--
-- =====================End : adminProduct_GetIndexedProductsWithModifiedSpecification.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetIndexedProductsWithModifiedVendors.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetIndexedProductsWithModifiedVendors'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetIndexedProductsWithModifiedVendors
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT TOP (@batchSize) pro.product_id as id, pro.site_id, pro.product_name, pro.[rank],
				pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created,
				pro.product_type, pro.status, pro.has_model, pro.has_related, pro.completeness,
				pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid,
				pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank

	FROM
	(
		SELECT p.product_id
		FROM product p
			INNER JOIN product_to_vendor pv
				ON pv.product_id = p.product_id AND p.site_id = @siteId AND p.enabled = 1
			INNER JOIN vendor v
				ON v.vendor_id = pv.vendor_id
			INNER JOIN search_content_status scs
				ON scs.content_type_id = 2 AND scs.content_id = p.product_id AND v.modified > scs.modified
				
		UNION
		
		SELECT p.product_id
		FROM product p
			INNER JOIN product_to_vendor pv
				ON pv.product_id = p.product_id AND p.site_id = @siteId AND p.enabled = 1
			INNER JOIN search_content_status scs
				ON scs.content_type_id = 2 AND scs.content_id = p.product_id AND pv.modified > scs.modified
	) AS product_ids
	INNER JOIN product pro
		ON product_ids.product_id = pro.product_id
		
END

GO

GRANT EXECUTE ON dbo.adminProduct_GetIndexedProductsWithModifiedVendors TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetIndexedProductsWithModifiedVendors.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductByCategoryIdVendorIdSiteIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByCategoryIdVendorIdSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByCategoryIdVendorIdSiteIdList
	@categoryId int,
	@vendorId int,
	@siteId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id as id, pro.site_id, pro.product_Name, pro.[rank], pro.has_image
		, pro.catalog_number, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.status
		, pro.has_related, pro.has_model, pro.completeness
		, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden
		, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank
	FROM product pro
		INNER JOIN product_to_category proCat
			ON pro.product_id = proCat.product_id
		INNER JOIN product_to_vendor proVen
			ON pro.product_id = proVen.product_id 
	WHERE proCat.category_id = @categoryId AND proVen.vendor_id = @vendorId AND pro.site_id = @siteId
	ORDER BY pro.created DESC

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByCategoryIdVendorIdSiteIdList TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetProductByCategoryIdVendorIdSiteIdList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductByOptionIdList.sql=============================

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
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix
			, pro.show_detail_page, pro.default_rank, pro.default_search_rank
 INTO #tmpProducts
	FROM product pro
			INNER JOIN product_to_category_group_option pcg
				ON pro.product_id = pcg.product_id
			INNER JOIN category_group_option cgo
				ON cgo.category_group_option_id = pcg.category_group_option_id 
	WHERE cgo.option_id = @optionId AND pro.site_id = @siteId
	
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model, completeness
			, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page, default_rank, default_search_rank

	FROM #tmpProducts
	WHERE rowId BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(product_id) 
	FROM #tmpProducts

	DROP TABLE #tmpProducts
		
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByOptionIdList TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetProductByOptionIdList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductByOptionIdListWithSorting.sql=============================

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
		, modified, created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified
		, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	INTO #tmpProducts
	FROM(
		SELECT DISTINCT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name, pro.[rank]
				, pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created, product_type, status
				, pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
				, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid
				, pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank

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
				, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix
				, show_detail_page, default_rank, default_search_rank
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
				, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
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
--
--
-- =====================End : adminProduct_GetProductByOptionIdListWithSorting.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductBySiteId.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteId
	@siteId int,
	@totalCount int output
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id as id, site_id, product_Name, rank
			, has_image, catalog_number, [enabled], modified, created, product_type, status
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
			, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product 
	WHERE site_id = @siteId
	
	SELECT @totalCount = COUNT(*) FROM product WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteId TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetProductBySiteId.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductBySiteIdBatchSizeModifiedList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) prod.product_id AS id, prod.site_id, prod.product_Name, prod.[rank]
	, prod.has_image, prod.catalog_number, prod.enabled, prod.modified, prod.created, prod.product_type, prod.status
	, prod.has_related, prod.has_model, prod.completeness
	, prod.flag1, prod.flag2, prod.flag3, prod.flag4, prod.search_rank, prod.search_content_modified, prod.hidden, prod.business_value, prod.ignore_in_rapid
	, prod.show_in_matrix, prod.show_detail_page, prod.default_rank, prod.default_search_rank
	FROM product prod
		LEFT OUTER JOIN content_text 
			ON prod.product_id = content_text.content_id AND content_text.content_type_id = 2
	WHERE prod.site_id = @siteId AND prod.enabled = 1 AND prod.product_type <> 3 AND prod.hidden = 0
		AND ((prod.modified > content_text.modified) OR (content_text.modified IS NULL))

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedList TO VpWebApp
GO


--
--
-- =====================End : adminProduct_GetProductBySiteIdBatchSizeModifiedList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList
	@siteId int,
	@batchSize int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (@batchSize) p.product_id as id, p.site_id, p.product_Name, p.rank
		, p.has_image, p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified
		, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
	FROM product p
		INNER JOIN product_to_vendor pv
			ON p.product_id = pv.product_id
		INNER JOIN product_to_category pc
			ON p.product_id = pc.product_id
		INNER JOIN category c
			ON c.category_id = pc.category_id AND c.hidden = '0' 
		LEFT OUTER JOIN content_text ct
			ON p.product_id = ct.content_id AND ct.content_type_id = 2
			
	WHERE (p.enabled = '1') 
		AND ((pv.modified > ct.modified) OR (ct.modified IS NULL))
		AND (p.site_id = @siteId OR @siteId IS NULL)

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetProductBySiteIdBatchSizeModifiedProductVendorList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductBySiteIdBatchSizeModifiedSpecificationList.sql=============================

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
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden
		, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
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
--
--
-- =====================End : adminProduct_GetProductBySiteIdBatchSizeModifiedSpecificationList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductBySiteIdBatchSizeModifiedTagList.sql=============================
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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
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
--
--
-- =====================End : adminProduct_GetProductBySiteIdBatchSizeModifiedTagList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductBySiteIdSearchList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdSearchList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdSearchList
	@siteId int,
	@search varchar(255),
	@numberOfItems int 
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP (@numberOfItems) product_id AS id, site_id, parent_product_id, product_name, rank
		, has_image, catalog_number, enabled, modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product
	WHERE site_id = @siteId AND product_name LIKE '%' + @search + '%'

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdSearchList TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetProductBySiteIdSearchList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductBySiteIdStartIndexEndIndexList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductBySiteIdStartIndexEndIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductBySiteIdStartIndexEndIndexList
	@siteId int,
	@startRowIndex int,
	@endRowIndex int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedProduct(id, row_id, site_id, product_Name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type
			, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4
			, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
			, default_rank, default_search_rank)
	AS
	(
		SELECT  product_id AS id, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id, site_id, product_Name, [rank]
				, has_image, catalog_number, [enabled], modified, created, product_type
				, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4
				, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product
		WHERE site_id = @siteId AND enabled = 1 AND hidden = 0 AND product_type <> 3
	)

	SELECT id, site_id, product_Name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type
			, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4
			, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM selectedProduct
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductBySiteIdStartIndexEndIndexList TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetProductBySiteIdStartIndexEndIndexList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductByVendorIdCategoryIdsListWithPaging.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdCategoryIdsListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdCategoryIdsListWithPaging
	@categoryIds varchar(1000),
	@vendorId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	--Creates temp categoryis table.
	SELECT [value]
	INTO #temp
	FROM global_split(@categoryIds, ',')

	--Creates temp product table where count equal to temp category table count
	SELECT ptc.product_id
	INTO #tempPro
	FROM product_to_category ptc
		LEFT JOIN #temp 
			ON  ptc.category_id = #temp.[value]
		INNER JOIN product_to_vendor ptv 
			ON ptv.product_id = ptc.product_id AND ptv.is_manufacturer = 1
	WHERE ptv.vendor_id = @vendorId
	GROUP BY ptc.product_id
	HAVING COUNT(ptc.product_id) = (SELECT COUNT([value]) FROM #temp)


	SELECT id, site_id, product_Name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY p.product_id ASC) AS row, p.product_id as id, p.site_id, p.product_Name, p.rank
			, p.has_image, p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.[status]
			, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified
			, p.hidden, p.business_value,p.ignore_in_rapid,p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
		FROM product p
		WHERE p.product_id IN
		(
			---Filter not matching values for given category ids from temp product table
			SELECT ptc.product_id from product_to_category ptc
			INNER JOIN #temp
			on  ptc.category_id = #temp.[value]
			INNER JOIN #tempPro
			ON ptc.product_id = #tempPro.product_id
			GROUP BY ptc.product_id
			HAVING COUNT(ptc.product_id) = (SELECT COUNT([value]) FROM #temp)
		)
	) AS tempPro
	WHERE row BETWEEN @startIndex AND @endIndex
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdCategoryIdsListWithPaging TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetProductByVendorIdCategoryIdsListWithPaging.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductByVendorIdListEnabledWithSorting.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdListEnabledWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdListEnabledWithSorting
	@siteId int,
	@vendorId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@pageSize int,
	@pageIndex int,
	@enabled int,
	@totalRowCount int output	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow
					, catalog_number, [enabled], modified, created, product_type, [status]
					, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
					, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					, p.has_related, p.has_model, p.completeness
					, p.flag1, p.flag2, p.flag3, p.flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
					, show_in_matrix, show_detail_page, p.default_rank, p.default_search_rank
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId AND p.[enabled] = @enabled 
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status
					, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
					, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
				
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
					, has_image, catalog_number, [enabled], modified, created, product_type
					, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
					, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
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

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdListEnabledWithSorting TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetProductByVendorIdListEnabledWithSorting.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductByVendorIdListWithSorting.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdListWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdListWithSorting
	@siteId int,
	@vendorId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@pageSize int,
	@pageIndex int,
	@totalRowCount int output	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow
					, catalog_number, [enabled], modified, created, product_type, [status]
					, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
					, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified
					, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status
					, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
					, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank

			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
				
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
					, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model, completeness
					, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
					, show_in_matrix, show_detail_page, default_rank, default_search_rank

			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
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

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdListWithSorting TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetProductByVendorIdListWithSorting.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductByVendorIdRankListWithSorting.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByVendorIdRankListWithSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductByVendorIdRankListWithSorting
	@siteId int,
	@vendorId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@pageSize int,
	@pageIndex int,
	@productStatus int,
	@totalRowCount int output
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, 
					id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, 
					product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow, 
					catalog_number, [enabled], modified, created, product_type, [status], 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
					show_in_matrix, show_detail_page, default_rank, default_search_rank
	INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4
					, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page
					, p.default_rank, p.default_search_rank
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId AND p.[rank] = @productStatus 
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model
					, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
					, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
				
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
					, has_image, catalog_number, [enabled], modified, created, product_type
					, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
					, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM #tmpProducts
			WHERE 
				(@sortBy = 'Id' AND idRow BETWEEN @startIndex AND @endIndex) OR 
				(@sortBy = 'Name' AND nameRow BETWEEN @startIndex AND @endIndex) OR
				(@sortBy = 'CatalogNumber' AND catalogNoRow BETWEEN @startIndex AND @endIndex) 
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

GRANT EXECUTE ON dbo.adminProduct_GetProductByVendorIdRankListWithSorting TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetProductByVendorIdRankListWithSorting.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductsBySiteIdLikeProductName.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductsBySiteIdLikeProductName'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductsBySiteIdLikeProductName
	@siteId int,
	@value varchar(max),
	@isEnabled bit,
	@categoryId int,
	@selectLimit int,
	@status int,
	@excludeParent bit,
	@excludeParentChild bit
AS
-- ==========================================================================
-- Author : Tishan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF(@categoryId IS NULL)
		BEGIN
			SELECT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
				, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM product 
			WHERE site_id = @siteId AND product_Name like @value+'%' AND (@isEnabled IS NULL OR product.enabled = @isEnabled)
				AND (@status IS NULL OR status = @status)
				AND (@excludeParent IS NULL OR product.product_id NOT IN (SELECT parent_product_id FROM dbo.product_to_product))
				AND (@excludeParentChild IS NULL OR product.product_id NOT IN (SELECT parent_product_id FROM dbo.product_to_product UNION SELECT product_id FROM dbo.product_to_product))
		END
	ELSE
		BEGIN
			SELECT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
				, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
			FROM product 
					INNER JOIN product_to_category
						ON product.product_id = product_to_category.product_id AND product_to_category.category_id = @categoryId
			WHERE site_id = @siteId AND product_Name like @value+'%'
					AND (@isEnabled IS NULL OR product.enabled = @isEnabled) AND (@status IS NULL OR product.status = @status)
		END

END
GO

GRANT EXECUTE ON adminProduct_GetProductsBySiteIdLikeProductName TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetProductsBySiteIdLikeProductName.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetRecentlyModifiedIndexedProducts.sql=============================
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
			 , flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			 , show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM (
			SELECT DISTINCT	p.product_id as id,site_id, product_name, [rank]
					, has_image, catalog_number, [enabled], modified
					, created, product_type, status, has_model, has_related, completeness
					, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
					, show_in_matrix, show_detail_page, default_rank, default_search_rank
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
--
--
-- =====================End : adminProduct_GetRecentlyModifiedIndexedProducts.sql ==============================
--
-- 
-- =====================Start : adminProduct_UpdateProduct.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProduct
	@id int, 
	@siteId int,
	@productName varchar(500),
	@rank int,
	@hasImage bit,
	@catalogNumber varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@productType int,
	@status int,
	@hasRelated bit,
	@hasModel bit,
	@completeness int,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@searchRank int,
	@searchContentModified bit,
	@hidden bit,
	@businessValue int,
	@ignoreInRapid bit,
	@showInMatrix bit,
	@showDetailPage bit,
	@defaultRank int,
	@defaultSearchRank int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE product 
	SET
		site_id = @siteId,
		product_name = @productName,
		rank = @rank,
		has_image = @hasImage,
		catalog_number = @catalogNumber,
		[enabled] = @enabled,
		modified = @modified,
		product_type = @productType,
		status = @status,
		has_related = @hasRelated,
		has_model = @hasModel,
		completeness = @completeness,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		search_rank = @searchRank,
		search_content_modified = @searchContentModified,
		hidden = @hidden,
		business_value = @businessValue,
		ignore_in_rapid = @ignoreInRapid,
		show_in_matrix = @showInMatrix,
		show_detail_page = @showDetailPage,
		default_rank = @defaultRank,
		default_search_rank = @defaultSearchRank
		
		
	WHERE product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProduct TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_UpdateProduct.sql ==============================
--
-- 
-- =====================Start : publicPlatform_GetProductsArticleRelatedCategories.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetProductsArticleRelatedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetProductsArticleRelatedCategories
	@numberofProducts int,
	@articleId int,
	@siteId int,
	@addedProducts varchar(1000),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	

	SELECT TOP (@numberofProducts)  p.product_id as id, p.site_id, p.product_Name, p.[rank], p.has_image
		, p.catalog_number, p.[enabled], p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
		, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
		, p.completeness, pc.product_to_category_id, pc.category_id, pc.product_id, ROUND(RAND() * 10000, 0) as randomId
	FROM product_to_category pc
		INNER JOIN product p
			ON p.product_id = pc.product_id
				AND p.enabled = 1
	WHERE pc.enabled = 1 AND pc.category_id IN 
	(

		SELECT associated_content_id
		FROM content_to_content
		WHERE content_id = @articleId AND content_type_id = 4 AND enabled = 1 
		AND associated_content_type_id = 1 AND site_id = @siteId 

	)  
	AND
	(
		(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
		(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
	)
	AND p.product_id NOT IN  (Select [value] FROM global_Split(@addedProducts, ','))
	ORDER BY randomId


END

GO

GRANT EXECUTE ON dbo.publicPlatform_GetProductsArticleRelatedCategories TO VpWebApp 
GO
--
--
-- =====================End : publicPlatform_GetProductsArticleRelatedCategories.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetArticleAssociatedProducts.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetArticleAssociatedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetArticleAssociatedProducts
	@articleId int,
	@numberOfSlots int,
	@siteId int,
	@addedProducts varchar(1000),
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

	SELECT  TOP (@numberOfSlots) p.product_id as id, p.site_id, p.product_Name, p.[rank], p.has_image
		, p.catalog_number, p.[enabled], p.modified, p.created, p.product_type, p.status
		, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid
		, p.show_in_matrix, p.show_detail_page, p.default_rank, p.default_search_rank
		, p.completeness, content_to_content_id, content_id, content_type_id
		, associated_content_id, associated_content_type_id, associated_site_id
	FROM content_to_content cc 
		INNER JOIN product p 
			ON cc.associated_content_id = p.product_id AND associated_content_type_id = 2
	WHERE cc.content_id = @articleId AND cc.enabled = 1 AND content_type_id = 4 
		AND p.enabled=1 AND cc.site_id = @siteId AND
		(
			(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
			(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
		)
		AND p.product_id NOT IN  (Select [value] FROM global_Split(@addedProducts, ','))
	ORDER BY newid()

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetArticleAssociatedProducts TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetArticleAssociatedProducts.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds
	@ParentProductId int,
	@productCompressionGroupId int,
	@searchOptionIds varchar(max),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	
	SELECT DISTINCT product.product_id AS id, site_id, product.parent_product_id, product_name, [rank], has_image, catalog_number, product.enabled,
		product.modified, product.created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page, ignore_in_rapid, default_rank, default_search_rank
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id AND pp.enabled = 1
	INNER JOIN product_to_category ptc
		ON 	ptc.product_id = pp.product_id  AND ptc.enabled = 1
	INNER JOIN product_compression_group_to_product proGro
		ON pp.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		) AND 
		pp.parent_product_id = @ParentProductId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ','))) AND
		product.enabled = 1

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList]
	@categoryId int,
	@vendorId int,
	@startRowIndex int,
	@endRowIndex int,
	@actionId int,
	@totalRowCount int output	
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
		row_id int NOT NULL,
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
		flag1 bigint NOT NULL,
		flag2 bigint NOT NULL,
		flag3 bigint NOT NULL,
		flag4 bigint NOT NULL,
		search_rank int NOT NULL DEFAULT ((50)),
		search_content_modified bit,
		hidden bit,
		business_value int,
		ignore_in_rapid bit,
		show_in_matrix bit,
		show_detail_page bit,
		default_rank int,
		default_search_rank int

	)

	

	INSERT INTO #TempProductList
	
		SELECT DISTINCT p.product_id as id, p.site_id as site_id, p.product_name as product_name, ROW_NUMBER() OVER (ORDER BY v.rank DESC, product_Name) AS row_id
						, p.rank as rank 
						, p.has_image as has_image, p.catalog_number as catalog_number, p.enabled as enabled, p.modified as modified
						, p.created as created, p.product_type as product_type, p.status as status, p.has_related as has_related, p.has_model as has_model
						, p.completeness as completeness, p.flag1, p.flag2, p.flag3, p.flag4
						, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page
						, p.default_rank, p.default_search_rank

		FROM product p
		INNER JOIN product_to_vendor ptv
			ON p.product_id = ptv.product_id AND ptv.enabled = 1 AND ptv.is_manufacturer = 1 AND ptv.lead_enabled = 1
		INNER JOIN vendor v
			ON ptv.vendor_id = v.vendor_id AND v.enabled = 1
		INNER JOIN product_to_category ptc
			ON p.product_id = ptc.product_id AND ptc.enabled = 1
		LEFT OUTER JOIN vendor_parameter vpALL
			ON v.vendor_id = vpALL.vendor_id AND vpALL.parameter_type_id = 101
		LEFT OUTER JOIN vendor_parameter vpVENDOR
			ON v.vendor_id = vpVENDOR.vendor_id AND vpVENDOR.parameter_type_id = 47
		LEFT OUTER JOIN product_parameter vpPRODUCT
			ON p.product_id = vpPRODUCT.product_id AND vpPRODUCT.parameter_type_id = 104

		LEFT OUTER JOIN action_to_content atcp
			ON atcp.action_id = @actionId AND atcp.content_id = p.product_id AND atcp.content_type_id = 2
		LEFT OUTER JOIN action_to_content atcv
			ON atcv.action_id = @actionId AND atcv.content_id = ptv.vendor_id AND atcv.content_type_id = 6
		LEFT OUTER JOIN action_to_content atcc
			ON atcc.action_id = @actionId AND atcc.content_id = @categoryId AND atcc.content_type_id = 1
		LEFT OUTER JOIN action_to_content atcs
			ON atcs.action_id = @actionId AND atcs.content_id = p.site_id AND atcs.content_type_id = 5

		WHERE p.enabled = 1 AND ptc.category_id = @categoryId AND ptv.vendor_id <> @vendorId
			  AND (COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) = 1 
			  OR COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) IS NULL)
			  AND (vpVENDOR.vendor_parameter_value = 1 OR vpVENDOR.vendor_parameter_value IS NULL) 
			  AND (vpALL.vendor_parameter_value = 0 OR vpALL.vendor_parameter_value IS NULL)
			  AND (vpPRODUCT.product_parameter_value = 0 OR vpPRODUCT.product_parameter_value IS NULL)
		
		
		SELECT id, site_id, product_Name, [rank], has_image, catalog_number
			, [enabled], modified, created, product_type, status, has_related, has_model
			, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page, default_rank, default_search_rank

		FROM #TempProductList
		WHERE row_id BETWEEN @startRowIndex AND @endRowIndex
		ORDER BY row_id
		
		SELECT @totalRowCount = COUNT(*)
		FROM  #TempProductList

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetLeadEnabledProductByCategoryIdVendorIdStartRowindexEndRowIndexList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetMissingProductByCategoryIdPageList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetMissingProductByCategoryIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetMissingProductByCategoryIdPageList
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
	@productIds varchar(MAX),
	@sortOrderBy varchar(4)
AS
-- ==========================================================================
-- Author: Sujith
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, vendor_name varchar(100), price money, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, show_in_matrix bit, show_detail_page bit, product_to_vendor_id int
		, parent_vendor_id int, specification varchar(MAX) NULL, default_rank int, default_search_rank int)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, show_in_matrix bit, show_detail_page bit
		, parent_vendor_id int, default_rank int, default_search_rank int)

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
		,product.show_in_matrix
		,product.show_detail_page
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
		, NULL
		, product.default_rank
		, product.default_search_rank
	FROM product
		INNER JOIN product_to_category
			ON product.product_id = product_to_category.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id
	WHERE product_to_category.category_id = @categoryId AND 
		product.enabled = 1 AND 
		product.show_in_matrix = 1 AND
		product_to_category.enabled = 1 AND 
		vendor.enabled = 1 AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		) AND
		product.product_id NOT IN 
		(
			SELECT [value] FROM dbo.global_Split(@productIds, ',')
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
		, default_rank, default_search_rank
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
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetMissingProductByCategoryIdPageList TO VpWebApp
GO

--
--
-- =====================End : publicProduct_GetMissingProductByCategoryIdPageList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByCategoryIdGeoLocationList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdGeoLocationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdGeoLocationList
	@id int,
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

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, product_type, status
			, has_related, has_model, completeness, business_value, pro.ignore_in_rapid, show_in_matrix, show_detail_page
			, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden
			, pro.default_rank, pro.default_search_rank
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @id AND
	(
		(pro.flag1 & @countryFlag1 > 0) OR (pro.flag2 & @countryFlag2 > 0) OR 
		(pro.flag3 & @countryFlag3 > 0) OR (pro.flag4 & @countryFlag4 > 0)
	)

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdGeoLocationList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByCategoryIdGeoLocationList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByCategoryIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdList
	@id int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, product_type, status
			, has_related, has_model, completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, show_in_matrix, show_detail_page
			, pro.default_rank, pro.default_search_rank
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByCategoryIdList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList.sql=============================

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
		SELECT product.product_id as id, product.site_id, product_Name, ROW_NUMBER() OVER (ORDER BY v.rank DESC, product_Name) AS row_id, product.[rank]
				, product.has_image, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor ptv
					ON product.product_id = ptv.product_id AND ptv.enabled = '1' 
						AND ptv.is_manufacturer = 1
				INNER JOIN vendor v
					ON ptv.vendor_id = v.vendor_id 
		WHERE product_to_category.category_id = @categoryId AND ptv.vendor_id <> @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled],
		modified, created, product_type, status,has_related, has_model, 
		completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,
		show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM ProductList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex
	ORDER BY row_id
	
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
--
--
-- =====================End : publicProduct_GetProductByCategoryIdManufacturerIdProductIdStartRowindexEndRowIndexList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList
	@categoryId int,
	@manufacturerId int,
	@productId int,
	@startRowIndex int,
	@endRowIndex int,
	@partialLeadEnabled bit,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
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
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
		FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id AND product_to_vendor.enabled = '1' 
						AND product_to_vendor.is_manufacturer = 1
		WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id = @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1
				AND
				(
					(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
					(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
				)
				AND (product.product_id IN (SELECT content_id FROM action_url) 
				OR 
				(@partialLeadEnabled IS NULL OR product_to_vendor.lead_enabled = @partialLeadEnabled))
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled]
			 , modified, created, product_type, status,  has_related, has_model, completeness
			 , flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			 , show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM ProductList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(*)
	FROM product 
				INNER JOIN product_to_category
					ON product.product_id = product_to_category.product_id AND product_to_category.enabled = '1'
				INNER JOIN product_to_vendor
					ON product.product_id = product_to_vendor.product_id AND product_to_vendor.enabled = '1' 
						AND product_to_vendor.is_manufacturer = 1
		WHERE product_to_category.category_id = @categoryId AND product_to_vendor.vendor_id = @manufacturerId 
				AND product.product_id <> @productId AND product.[enabled] = 1
				AND
				(
					(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
					(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
				)
				AND (product.product_id IN (SELECT content_id FROM action_url) 
				OR 
				(@partialLeadEnabled IS NULL OR product_to_vendor.lead_enabled = @partialLeadEnabled))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByCategoryIdManufacturerIdStartRowindexEndRowIndexList.sql ==============================
 

-- 
-- =====================Start : publicProduct_GetProductByCategoryIdVendorIdList.sql=============================


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdVendorIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdVendorIdList
	@categoryId int,
	@vendorId int
AS
-- ==========================================================================
-- Author: Dhanushka
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name, pro.[rank]
			, pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created, product_type, status
			, pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page
			, pro.default_rank, pro.default_search_rank

	FROM (
			SELECT product_id, site_id, parent_product_id, product_name, [rank]
				, has_image, catalog_number, enabled, modified, created, product_type
				, status, has_related, has_model
				, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
				, show_in_matrix, show_detail_page, default_rank, default_search_rank
				,CASE
				WHEN((SELECT COUNT(product_id) 
				FROM vendor 
				INNER JOIN product_to_vendor
				ON vendor.vendor_id = product_to_vendor.vendor_id
				WHERE product_to_vendor.product_id = product.product_id AND ([rank] = 2 OR [rank] = 3)) > 0)
				THEN 1
				ELSE 2
				END payed
				FROM product
			) pro
			INNER JOIN product_to_category proCat
				ON pro.product_id = proCat.product_id AND pro.enabled = '1' AND proCat.enabled = '1'
			INNER JOIN product_to_vendor proVen
				ON pro.product_id = proVen.product_id AND proVen.enabled = '1'
	WHERE proCat.category_Id = @categoryId AND proVen.vendor_Id = @vendorId AND payed = 2

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdVendorIdList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByCategoryIdVendorIdList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList
	@id int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id AS id, pro.site_id, pro.parent_product_id AS parent_product_id
			, pro.product_name AS product_name, pro.rank AS rank
			, pro.has_image AS has_image, pro.catalog_number AS catalog_number
			, pro.[enabled] AS [enabled], pro.modified AS modified, pro.created AS created, product_type, status
			, pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4
			, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid
			, pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank
	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @id AND catPro.[enabled] = '1'

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByCategoryIdWithEnabledCategoryAssociationList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByChildProductIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByChildProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByChildProductIdList
	@productId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		, default_rank, default_search_rank
	FROM product 
		INNER JOIN product_to_product AS association
			ON product.product_id = association.parent_product_id
	WHERE association.product_id = @productId
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByChildProductIdList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByChildProductIdList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByOtherUserRequestedList.sql=============================


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
		show_detail_page bit,
		default_rank int,
		default_search_rank int
		

	)

DECLARE @months int
SET @months = -3

INSERT INTO #TempProductList

SELECT DISTINCT	product.product_id as id, product.site_id as site_id, product.product_name as product_name, product.rank as rank, 
				  product.has_image as has_image, product.catalog_number as catalog_number, product.enabled as enabled, 
				  product.modified as modified, product.created as created, product.product_type as product_type, product.status as status,
				  product.has_related as has_related, product.has_model as has_model, leads as leads, 
				  product.completeness as completeness, product.flag1, product.flag2, product.flag3, product.flag4,
				  product.search_rank, product.search_content_modified, product.hidden, product.business_value, product.ignore_in_rapid, 
				  product.show_in_matrix, product.show_detail_page, product.default_rank, product.default_search_rank

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

SELECT TOP (@rows) t.id, t.site_id, t.product_Name, t.[rank], t.has_image, t.catalog_number, t.[enabled], t.modified, t.created
	, t.product_type, t.status, t.has_related, t.has_model, t.completeness
	,t.flag1, t.flag2, t.flag3, t.flag4, t.search_rank, t.search_content_modified, t.hidden, t.business_value, t.ignore_in_rapid, t.show_in_matrix
	, t.show_detail_page, t.default_rank, t.default_search_rank

FROM #TempProductList t
WHERE t.id NOT IN (select content_id FROM lead l WHERE public_user_id = @userId AND 
	  created > DATEADD(m, -1, GETDATE()) AND site_id = @siteId)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByOtherUserRequestedList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByOtherUserRequestedList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList
    @parentProductId INT ,
    @categoryId INT,
    @compressionGroupId INT ,
    @countryFlag1 BIGINT ,
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS -- ==========================================================================
-- Author : Dimuthu
-- ==========================================================================
    BEGIN
	
        SET NOCOUNT ON;
	
        SELECT  product.product_id AS id ,
                site_id ,
                product_name ,
                [rank] ,
                has_image ,
                catalog_number ,
                product.enabled ,
                product.modified ,
                product.created ,
                product_type ,
                status ,
                has_model ,
                has_related ,
                flag1 ,
                flag2 ,
                flag3 ,
                flag4 ,
                completeness ,
                search_rank ,
                search_content_modified ,
                hidden ,
                business_value ,
                show_in_matrix ,
                show_detail_page ,
                ignore_in_rapid,
				default_rank,
				default_search_rank
        FROM    product
                INNER JOIN product_compression_group_to_product cp ON product.product_id = cp.product_id
                INNER JOIN product_to_product pp ON product.product_id = pp.product_id
				INNER JOIN dbo.product_to_category ptc ON pp.product_id = ptc.product_id
        WHERE   product.enabled = 1
				AND pp.enabled = 1
                AND ptc.enabled = 1
                AND cp.product_compression_group_id = @compressionGroupId
                AND pp.parent_product_id = @parentProductId
				AND ptc.category_id =  @categoryId
                AND ( ( product.flag1 & @countryFlag1 > 0 )
                      OR ( product.flag2 & @countryFlag2 > 0 )
                      OR ( product.flag3 & @countryFlag3 > 0 )
                      OR ( product.flag4 & @countryFlag4 > 0 )
                    )
		

    END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByParentProductIdCompressionGroupIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList
    @parentProductId INT ,
    @compressionGroupId INT ,
    @countryFlag1 BIGINT ,
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS -- ==========================================================================
-- Author : Dimuthu
-- ==========================================================================
    BEGIN

        SET NOCOUNT ON;
	
        SELECT  product.product_id AS id ,
                site_id ,
                product_name ,
                [rank] ,
                has_image ,
                catalog_number ,
                product.enabled ,
                product.modified ,
                product.created ,
                product_type ,
                status ,
                has_model ,
                has_related ,
                flag1 ,
                flag2 ,
                flag3 ,
                flag4 ,
                completeness ,
                search_rank ,
                search_content_modified ,
                hidden ,
                business_value ,
                show_in_matrix ,
                show_detail_page,
				ignore_in_rapid,
				default_rank,
				default_search_rank
        FROM    product
                INNER JOIN product_compression_group_to_product cp ON product.product_id = cp.product_id
                INNER JOIN product_to_product pp ON product.product_id = pp.product_id
        WHERE   product.enabled = 1
                AND cp.product_compression_group_id = @compressionGroupId
                AND pp.parent_product_id = @parentProductId
                AND ( ( product.flag1 & @countryFlag1 > 0 )
                      OR ( product.flag2 & @countryFlag2 > 0 )
                      OR ( product.flag3 & @countryFlag3 > 0 )
                      OR ( product.flag4 & @countryFlag4 > 0 )
                    )
		

    END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByParentProductIdCompressionGroupIdList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByProductCompressionGroupIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductCompressionGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductCompressionGroupIdList
	@productCompressionGroupId int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page,
		ignore_in_rapid, default_rank, default_search_rank
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdList TO VpWebApp 
GO

--
--
-- =====================End : publicProduct_GetProductByProductCompressionGroupIdList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByProductIdsList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductIdsList
	@productIds varchar(MAX),
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

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified
		, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product
		INNER JOIN global_Split(@productIds, ',') AS product_id_table
			ON product.product_id = product_id_table.[value]
		AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductIdsList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByProductIdsList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByProductIdStringList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductIdStringList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductIdStringList
	@productIds varchar(MAX)
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank, default_rank, default_search_rank
	FROM product 
		INNER JOIN global_Split(@productIds, ',') AS product_id_table 
			ON product.product_id = product_id_table.[value]
	ORDER BY product_id_table.id
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductIdStringList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByProductIdStringList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByVendorIdList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByVendorIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByVendorIdList
	@vendorId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pro.product_id as id, pro.site_id, pro.product_Name, pro.[rank]
		, pro.has_image,pro.catalog_number, pro.[enabled], pro.modified, pro.created
		, product_type, status, has_related, has_model, completeness
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, pro.ignore_in_rapid, show_in_matrix
		, show_detail_page, default_rank, default_search_rank
	FROM product pro
			INNER JOIN product_to_vendor proVen
				ON pro.product_id = proVen.product_id
	WHERE proVen.vendor_id = @vendorId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByVendorIdList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByVendorIdList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByVendorIdRandom.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByVendorIdRandom'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByVendorIdRandom
	@vendorId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP 1 product.product_id as id, product.site_id, product_Name, product.[rank], has_image
		, catalog_number, product.[enabled], product.modified, product.created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank

	FROM product
		INNER JOIN product_to_vendor 
			ON product.product_id = product_to_vendor.product_id
	WHERE product_to_vendor.vendor_id = @vendorId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByVendorIdRandom TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByVendorIdRandom.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductDetail.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductDetail
	@id int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, status
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4
		, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product
	WHERE product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductDetail TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductDetail.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductForSearchList.sql=============================
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
		show_in_matrix bit, show_detail_page bit,  default_rank int, default_search_rank int, price_sort_order money)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit,  default_rank int, default_search_rank int)

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
		,NULL
		,default_rank
		, default_search_rank
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
	
	UPDATE #total_ranked_product
	SET price_sort_order = (
		CASE 
		WHEN @sortOrderBy = 'ASC' AND (price IS NULL OR price = 0)
		THEN
			'100000'
		ELSE
			price
		END
	)
		
		
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
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price_sort_order ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE  
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row, '
	
	SET @query = @query + 'parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		,default_rank, default_search_rank
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
		, default_rank, default_search_rank
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductForSearchList TO VpWebApp
GO
--
--
-- =====================End : publicProduct_GetProductForSearchList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductLocalized.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductLocalized'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductLocalized
	@productId int,
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

	SELECT product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status], has_related
		, has_model, flag1, flag2, flag3, flag4, search_rank, completeness, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product
	WHERE product_id = @productId AND [enabled] = 1 AND
		((flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR 
		(flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0))
	

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductLocalized TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductLocalized.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductsByCategoryIdLikeProductNameList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsByCategoryIdLikeProductNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsByCategoryIdLikeProductNameList
	@categoryId int,
	@name varchar(500),
	@numberOfResults int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@numberOfResults) p.product_id AS id, p.site_id, p.parent_product_id
			, p.product_name, p.rank
			, p.has_image, p.catalog_number
			, p.[enabled], p.modified, p.created, p.product_type, p.status
			, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank
			, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page
			, p.default_rank, p.default_search_rank
	FROM product p
		INNER JOIN product_to_category pc
			ON pc.product_id = p.product_id
	WHERE pc.category_id = @categoryId AND p.product_name LIKE (@name + '%')

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsByCategoryIdLikeProductNameList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductsByCategoryIdLikeProductNameList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList
	@categoryId int,
	@name varchar(500),
	@vendorIds varchar(max),
	@numberOfResults int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@numberOfResults) p.product_id AS id, p.site_id, p.parent_product_id  
		, p.product_name, p.rank  
		, p.has_image, p.catalog_number  
		, p.[enabled], p.modified, p.created, p.product_type, p.status  
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank  
		, p.search_content_modified, p.hidden, p.business_value, p.ignore_in_rapid, p.show_in_matrix, p.show_detail_page
		, p.default_rank, p.default_search_rank		
	FROM product p  
		INNER JOIN product_to_category pc  
			ON pc.product_id = p.product_id  
		INNER JOIN product_to_vendor pv  
			ON pv.product_id = p.product_id  
	WHERE pc.category_id = @categoryId  
		AND pv.vendor_id IN (SELECT [value] FROM global_Split(@vendorIds, ','))  
		AND p.product_name LIKE (@name + '%')  

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductsByCategoryIdVendorIdsLikeProductNameList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductsByOtherUserRequestedListCategoryId.sql=============================
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
		show_detail_page bit,
		default_rank int,
		default_search_rank int
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
				product.show_in_matrix, product.show_detail_page, product.default_rank, product.default_search_rank

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
	, t.show_in_matrix, t.show_detail_page, t.default_rank, t.default_search_rank
FROM #TempProductList t
WHERE t.id NOT IN (select content_id FROM lead l WHERE public_user_id = @userId AND 
	  created > DATEADD(m, @months, GETDATE()) AND site_id = @siteId)

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsByOtherUserRequestedListCategoryId TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductsByOtherUserRequestedListCategoryId.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductsSearchResults.sql=============================

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
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, show_in_matrix bit, show_detail_page bit
		, default_rank bit, default_search_rank bit)

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
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit
		, default_rank bit, default_search_rank bit)

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
		, product.show_in_matrix
		, product.show_detail_page
		, product.default_rank
		, product.default_search_rank
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
		, default_rank, default_search_rank
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
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM
	(
		SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, enabled, modified, created, product_type, status
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page, default_rank, default_search_rank
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

--
--
-- =====================End : publicProduct_GetProductsSearchResults.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductsToIndexInSearchProviderList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductsToIndexInSearchProviderList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductsToIndexInSearchProviderList
	@siteId int,
	@batchSize int,
	@totalCount int output
	
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1
	ORDER BY product_id
	
	SELECT @totalCount = COUNT(*)
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1
	
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsToIndexInSearchProviderList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductsToIndexInSearchProviderList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetRandomizedProducts.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetRandomizedProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetRandomizedProducts
	@siteId int,
	@products varchar(1000),
	@numberofProducts int,
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

	SELECT TOP (@numberofProducts) product_id as id, site_id, product_Name, rank
			, has_image, catalog_number, [enabled], modified, created, product_type, status
			, has_related, has_model, flag1, flag2, flag3, flag4, search_rank, completeness, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM product 
	WHERE site_id = @siteId AND [enabled] = 1 AND product_id IN (Select [value] FROM global_Split(@products, ',')) AND
		(
			(flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR 
			(flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0)
		)
	ORDER BY newid()

END

GO

GRANT EXECUTE ON dbo.publicProduct_GetRandomizedProducts TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetRandomizedProducts.sql ==============================

IF EXISTS(select * from sys.columns where Name = N'previous_rank' and Object_ID = Object_ID(N'product_display_status'))
BEGIN
	 ALTER TABLE product_display_status DROP COLUMN previous_rank
END

---------------------------------------------------------------------------------------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'featured_search_rank' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product_display_status') AND type in (N'U'))
)
BEGIN
	ALTER TABLE product_display_status
	ADD featured_search_rank int not null default '0'
END
GO

--------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductDisplayStatus
	@id int output,
	@productId int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@featuredSearchRank int,
	@newRank int,
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [product_display_status] (product_id, start_date, end_date, featured_search_rank, new_rank, [enabled], modified, created)
	VALUES (@productId, @startDate, @endDate, @featuredSearchRank, @newRank, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductDisplayStatus TO VpWebApp 
GO
---------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductDisplayStatus
	@id int,
	@productId int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@featuredSearchRank int,
	@newRank int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: rajitha $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[product_display_status]
	SET product_id = @productId,
		start_date = @startDate,
		end_date = @endDate,
		featured_search_rank = @featuredSearchRank,
		new_rank = @newRank,
		enabled = @enabled,		
		modified = @modified
	WHERE product_display_status_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductDisplayStatus TO VpWebApp 
GO
-------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductDisplayStatusDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductDisplayStatusDetail
@id int
	
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_display_status_id as id, product_id, start_date, end_date, featured_search_rank, new_rank, [enabled], modified, created
	FROM [product_display_status]	
	WHERE product_display_status_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductDisplayStatusDetail TO VpWebApp 
GO
-------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductDisplayStatusByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductDisplayStatusByProductId
	@productId int
	
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_display_status_id as id, product_id, start_date, end_date, featured_search_rank, new_rank, [enabled], modified, created
	FROM [product_display_status]	
	WHERE product_id = @productId 

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductDisplayStatusByProductId TO VpWebApp 
GO
----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductDisplayStatusBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductDisplayStatusBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pds.product_display_status_id as id, pds.product_id, pds.start_date, pds.end_date, pds.featured_search_rank, pds.new_rank, pds.[enabled], pds.modified, pds.created
	FROM [product_display_status] pds
		INNER JOIN product p
			on p.product_id = pds.product_id
	WHERE p.site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductDisplayStatusBySiteId TO VpWebApp 
GO
---------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetOverlappedProductDisplayStatusBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetOverlappedProductDisplayStatusBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SET @today = GETDATE();

	SELECT pds.product_display_status_id as id, pds.product_id, pds.start_date, pds.end_date, pds.featured_search_rank
		, pds.new_rank, pds.[enabled], pds.modified, pds.created
	FROM [product_display_status] pds
		INNER JOIN product p
			on p.product_id = pds.product_id
	WHERE p.site_id = @siteId
		AND (pds.start_date <= @today AND @today <= pds.end_date)

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetOverlappedProductDisplayStatusBySiteId TO VpWebApp 
GO
----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetNotOverlappedProductDisplayStatusProductBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetNotOverlappedProductDisplayStatusProductBySiteIdList
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SET @today = GETDATE();
	
	SELECT pro.product_id as id, pro.site_id, pro.product_Name, pro.[rank], pro.has_image
		, pro.catalog_number, pro.[enabled], pro.modified, pro.created, pro.product_type, pro.status
		, pro.has_related, pro.has_model, pro.completeness
		, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden
		, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page, pro.default_rank, pro.default_search_rank
	FROM product pro
		INNER JOIN [product_display_status] pds
			on pro.product_id = pds.product_id
	WHERE pro.site_id = @siteId
		AND NOT(pds.start_date <= @today AND @today <= pds.end_date)
		AND pro.product_id NOT IN 
		(
			SELECT p.product_id
			FROM product p
				INNER JOIN [product_display_status] pds
					ON p.product_id = pds.product_id
			WHERE p.site_id = @siteId
				AND (pds.start_date <= @today AND @today <= pds.end_date)
		)


END
GO

GRANT EXECUTE ON dbo.adminProduct_GetNotOverlappedProductDisplayStatusProductBySiteIdList TO VpWebApp 
GO

--------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdPageList
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
-- Author: Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, vendor_name varchar(100), price money, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL
		, show_in_matrix bit, show_detail_page bit, default_rank int, default_search_rank int, price_sort_order money)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit, default_rank int, default_search_rank int)

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
		, product.default_rank
		, product.default_search_rank
		, NULL
	FROM product
		INNER JOIN product_to_category
			ON product.product_id = product_to_category.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id
	WHERE product_to_category.category_id = @categoryId AND 
		product.enabled = 1 AND
		product.hidden = 0 AND
		product.show_in_matrix = 1 AND
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

	--- update price sort order to the temporary table.
	UPDATE #total_ranked_product
	SET price_sort_order = (
		CASE 
		WHEN @sortOrderBy = 'ASC' AND (price IS NULL OR price = 0)
		THEN
			'100000'
		ELSE
			price
		END
	)

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
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price_sort_order ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE  
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row, '
	
	SET @query = @query + 'parent_product_id, product_name, [rank], has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, ignore_in_rapid
		, show_in_matrix, show_detail_page, default_rank, default_search_rank

	FROM #total_ranked_product '	

	IF (DATALENGTH(@filterVendorIds) > 0)
		SET @query = @query + 'WHERE parent_vendor_id IN (SELECT [value] FROM Global_Split(''' + @filterVendorIds + ''','',''))'

	EXECUTE sp_executesql @query

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank], has_image, catalog_number, enabled, 
		modified, created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, 
		search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page, default_rank, default_search_rank
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdPageList TO VpWebApp
GO

------------------------------------------------------------