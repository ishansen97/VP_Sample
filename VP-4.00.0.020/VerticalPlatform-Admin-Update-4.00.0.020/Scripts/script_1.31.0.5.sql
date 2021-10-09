IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[product_compression_group](
		[product_compression_group_id] [int] IDENTITY(1,1) NOT NULL,
		[site_id] [int] NOT NULL,
		[show_in_matrix] [bit] NOT NULL,
		[show_product_count] [bit] NOT NULL,
		[group_title] [varchar](500) NOT NULL,
		[expand_products] [bit] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_product_compression_group] PRIMARY KEY CLUSTERED 
	(
		[product_compression_group_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

----------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group_to_product]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[product_compression_group_to_product](
		[product_compression_group_to_product_id] [int] IDENTITY(1,1) NOT NULL,
		[product_compression_group_id] [int] NOT NULL,
		[product_id] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_product_compression_group_to_product] PRIMARY KEY CLUSTERED 
	(
		[product_compression_group_to_product_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
-----------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group_order]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[product_compression_group_order](
		[product_compression_group_order_id] [int] IDENTITY(1,1) NOT NULL,
		[product_compression_group_id] [int] NOT NULL,
		[content_type_id] [int] NOT NULL,
		[content_id] [int] NOT NULL,
		[sort_order] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_product_compression_group_order] PRIMARY KEY CLUSTERED 
	(
		[product_compression_group_order_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

-----------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroup
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
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
           ,[modified])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
GO

------------------------------------------------------------
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
	FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupDetail TO VpWebApp 
GO

-------------------------------------------------------

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
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
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
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroup TO VpWebApp 
GO

----------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroup
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroup TO VpWebApp 
GO

---------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupToProduct
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupToProduct TO VpWebApp 
GO

--------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupToProduct
	@id int,
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_to_product]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[product_id] = @productId
      ,[enabled] = @enabled 
      ,[modified] = @modified
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupToProduct TO VpWebApp 
GO
-------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_to_product_id] AS id
      ,[product_compression_group_id]
      ,[product_id]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductDetail TO VpWebApp 
GO

--------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupToProduct
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_to_product]
           ([product_compression_group_id]
           ,[product_id]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @productId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupToProduct TO VpWebApp 
GO


-----------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupOrder
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder bit,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_order]
           ([product_compression_group_id]
           ,[content_type_id]
           ,[content_id]
           ,[sort_order]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @contentTypeId, @contentId, @sortOrder, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupOrder TO VpWebApp 
GO

----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupOrderDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupOrderDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_order_id] AS id
      ,[product_compression_group_id]
      ,[content_type_id]
      ,[content_id]
      ,[sort_order]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupOrderDetail TO VpWebApp 
GO

-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupOrder
	@id int,
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_order]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[content_type_id] = @contentTypeId
      ,[content_id] = @contentId
      ,[sort_order] = @sortOrder
      ,[enabled] = @enabled
      ,[modified] = @modified
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupOrder TO VpWebApp 
GO
---------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupOrder
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupOrder TO VpWebApp 
GO

----------------------------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'show_in_matrix' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[product]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [product]
	ADD show_in_matrix bit not null default '1'
END
GO

--------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'show_detail_page' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[product]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [product]
	ADD show_detail_page bit not null default '1'
END
GO

-------------------------------------------------------

IF NOT EXISTS (SELECT module_name FROM module WHERE module_name = 'GroupedProducts')
BEGIN
	INSERT INTO module
	VALUES('GroupedProducts','~/Modules/ProductDetail/GroupedProducts.ascx','1',GETDATE(),GETDATE(),'0')
END
---------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options, 1 AS [enabled], GETDATE() AS modified, GETDATE() AS created
		FROM specification 
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
Go
----------------------------------------------------
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
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdList TO VpWebApp 
GO
-------------------------------------------------------------------------------------

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
		, created, modified) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY group_title) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified
	FROM temp_product_compression_group 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList TO VpWebApp 
GO
-------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeId int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT specification_id AS id, content_type_id, content_id, spec_type_id, specification, display_options, [enabled], modified, created
		FROM specification 		
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND spec_type_id = @selectedSpecTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationList TO VpWebApp 
Go

--------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationTypeList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeIds varchar(max)
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT specification_type.spec_type_id AS id, spec_type, validation_expression, specification_type.site_id, specification_type.[enabled], 
				specification_type.modified, specification_type.created, is_visible, search_enabled, is_expanded_view, display_empty
		FROM specification_type
	INNER JOIN specification 
		ON specification_type.spec_type_id = specification.spec_type_id
	WHERE specification.content_type_id=@contentTypeId 
		AND specification.content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND specification.spec_type_id NOT IN (SELECT [value] FROM dbo.global_split(@selectedSpecTypeIds, ','))

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationTypeList TO VpWebApp 
Go

--------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_product_compression_group_to_product_product]') AND parent_object_id = OBJECT_ID(N'[product_compression_group_to_product]'))
BEGIN
	ALTER TABLE [dbo].[product_compression_group_to_product]  WITH CHECK ADD  CONSTRAINT [FK_product_compression_group_to_product_product] FOREIGN KEY([product_id])
	REFERENCES [dbo].[product] ([product_id])

	ALTER TABLE [product_compression_group_to_product] CHECK CONSTRAINT [FK_product_compression_group_to_product_product]
END
GO
-----------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_product_compression_group_to_product_product_compression_group]') AND parent_object_id = OBJECT_ID(N'[product_compression_group_to_product]'))
BEGIN
	ALTER TABLE [dbo].[product_compression_group_to_product]  WITH CHECK ADD  CONSTRAINT [FK_product_compression_group_to_product_product_compression_group] FOREIGN KEY([product_compression_group_id])
	REFERENCES [dbo].[product_compression_group] ([product_compression_group_id])

	ALTER TABLE [product_compression_group_to_product] CHECK CONSTRAINT [FK_product_compression_group_to_product_product_compression_group]
END
GO
-----------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_product_compression_group_order_product_compression_group]') AND parent_object_id = OBJECT_ID(N'[product_compression_group_order]'))
BEGIN
	ALTER TABLE [dbo].[product_compression_group_order]  WITH CHECK ADD  CONSTRAINT [FK_product_compression_group_order_product_compression_group] FOREIGN KEY([product_compression_group_id])
	REFERENCES [dbo].[product_compression_group] ([product_compression_group_id])

	ALTER TABLE [product_compression_group_order] CHECK CONSTRAINT [FK_product_compression_group_order_product_compression_group]
END
GO
---------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group_to_product]') AND name = N'AK_product_compression_group_to_product_group_id_product_id')
BEGIN
DROP INDEX [AK_product_compression_group_to_product_group_id_product_id] ON [dbo].[product_compression_group_to_product] WITH ( ONLINE = OFF )

CREATE UNIQUE NONCLUSTERED INDEX [AK_product_compression_group_to_product_group_id_product_id] ON [dbo].[product_compression_group_to_product] 
(
	[product_compression_group_id] ASC,
	[product_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO
-----------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group]') AND name = N'AK_product_compression_group_group_title_site_id')
BEGIN
DROP INDEX [AK_product_compression_group_group_title_site_id] ON [dbo].[product_compression_group] WITH ( ONLINE = OFF )

CREATE UNIQUE NONCLUSTERED INDEX [AK_product_compression_group_group_title_site_id] ON [dbo].[product_compression_group] 
(
	[site_id] ASC,
	[group_title] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO
-------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList
	@productCompressionGroupId int,
	@productId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM product_compression_group_to_product
	WHERE 	(@productCompressionGroupId IS NULL OR product_compression_group_id = @productCompressionGroupId) AND
			 (@productId IS NULL OR product_id = @productId);

	WITH temp_group_product(row, id, product_compression_group_id, product_id, enabled, created, modified) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY product_compression_group_to_product_id) AS row, product_compression_group_to_product_id AS id, product_compression_group_id, 
		product_id, enabled, created, modified
		FROM  product_compression_group_to_product proGro
		WHERE 	(@productCompressionGroupId IS NULL OR proGro.product_compression_group_id = @productCompressionGroupId) AND
			 (@productId IS NULL OR proGro.product_id = @productId)
	)
		
	SELECT  id, product_compression_group_id, product_id, enabled, created, modified
	FROM temp_group_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
		
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList TO VpWebApp 
GO
--------------------------------------


-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
IF NOT EXISTS (SELECT * FROM content_type WHERE content_type_id = 33)
BEGIN
	INSERT INTO content_type (content_type_id, content_type, enabled, modified, created)
	VALUES (33, 'ProductCompressionGroup', 1, GETDATE(), GETDATE())
END

GO


----------------------------------------------------------------------
GRANT SELECT ON product_to_product TO VpWebApp;

--------------------------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options, CAST(1 AS bit) AS [enabled], GETDATE() AS modified, GETDATE() AS created
		FROM specification 
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
Go

------------------------------------------------------------------

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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
			FROM product 
			WHERE site_id = @siteId AND product_Name like @value+'%' AND (@isEnabled IS NULL OR product.enabled = @isEnabled)
				AND (@status IS NULL OR status = @status)
				AND (@excludeParentChild IS NULL OR product.product_id NOT IN (SELECT product_id FROM dbo.product_to_product UNION SELECT parent_product_id FROM dbo.product_to_product))
		END
	ELSE
		BEGIN
			SELECT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
				, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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

-------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryByProductIdsList
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image
	FROM category AS cat
	WHERE category_id
		IN (SELECT DISTINCT category_id FROM product_to_category prodCat
				WHERE prodCat.product_id IN (SELECT [value] FROM Global_Split(@productIds, ',')))

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryByProductIdsList TO VpWebApp
GO

-----------------------------------------------------------------------

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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified
	FROM [dbo].[product_compression_group]
	WHERE group_title like +'%' + @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO




EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options, CAST(1 AS bit) AS [enabled], GETDATE() AS modified, GETDATE() AS created
		FROM specification 
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
Go



-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[product_compression_group](
		[product_compression_group_id] [int] IDENTITY(1,1) NOT NULL,
		[site_id] [int] NOT NULL,
		[show_in_matrix] [bit] NOT NULL,
		[show_product_count] [bit] NOT NULL,
		[group_title] [varchar](500) NOT NULL,
		[expand_products] [bit] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_product_compression_group] PRIMARY KEY CLUSTERED 
	(
		[product_compression_group_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

----------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group_to_product]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[product_compression_group_to_product](
		[product_compression_group_to_product_id] [int] IDENTITY(1,1) NOT NULL,
		[product_compression_group_id] [int] NOT NULL,
		[product_id] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_product_compression_group_to_product] PRIMARY KEY CLUSTERED 
	(
		[product_compression_group_to_product_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
-----------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group_order]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[product_compression_group_order](
		[product_compression_group_order_id] [int] IDENTITY(1,1) NOT NULL,
		[product_compression_group_id] [int] NOT NULL,
		[content_type_id] [int] NOT NULL,
		[content_id] [int] NOT NULL,
		[sort_order] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_product_compression_group_order] PRIMARY KEY CLUSTERED 
	(
		[product_compression_group_order_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

-----------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_product_compression_group_to_product_product]') AND parent_object_id = OBJECT_ID(N'[product_compression_group_to_product]'))
BEGIN
	ALTER TABLE [dbo].[product_compression_group_to_product]  WITH CHECK ADD  CONSTRAINT [FK_product_compression_group_to_product_product] FOREIGN KEY([product_id])
	REFERENCES [dbo].[product] ([product_id])

	ALTER TABLE [product_compression_group_to_product] CHECK CONSTRAINT [FK_product_compression_group_to_product_product]
END
GO
-----------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_product_compression_group_to_product_product_compression_group]') AND parent_object_id = OBJECT_ID(N'[product_compression_group_to_product]'))
BEGIN
	ALTER TABLE [dbo].[product_compression_group_to_product]  WITH CHECK ADD  CONSTRAINT [FK_product_compression_group_to_product_product_compression_group] FOREIGN KEY([product_compression_group_id])
	REFERENCES [dbo].[product_compression_group] ([product_compression_group_id])

	ALTER TABLE [product_compression_group_to_product] CHECK CONSTRAINT [FK_product_compression_group_to_product_product_compression_group]
END
GO
-----------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_product_compression_group_order_product_compression_group]') AND parent_object_id = OBJECT_ID(N'[product_compression_group_order]'))
BEGIN
	ALTER TABLE [dbo].[product_compression_group_order]  WITH CHECK ADD  CONSTRAINT [FK_product_compression_group_order_product_compression_group] FOREIGN KEY([product_compression_group_id])
	REFERENCES [dbo].[product_compression_group] ([product_compression_group_id])

	ALTER TABLE [product_compression_group_order] CHECK CONSTRAINT [FK_product_compression_group_order_product_compression_group]
END
GO

-----------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group_to_product]') AND name = N'AK_product_compression_group_to_product_group_id_product_id')
BEGIN

CREATE UNIQUE NONCLUSTERED INDEX [AK_product_compression_group_to_product_group_id_product_id] ON [dbo].[product_compression_group_to_product] 
(
	[product_compression_group_id] ASC,
	[product_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO
-----------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[product_compression_group]') AND name = N'AK_product_compression_group_group_title_site_id')
BEGIN

CREATE UNIQUE NONCLUSTERED INDEX [AK_product_compression_group_group_title_site_id] ON [dbo].[product_compression_group] 
(
	[site_id] ASC,
	[group_title] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO
-------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroup
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
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
           ,[modified])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
GO
------------------------------------------------

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
	FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupDetail TO VpWebApp 
GO
----------------------------------------------------------------

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
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
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
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroup TO VpWebApp 
GO
-------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroup
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroup TO VpWebApp 
GO
--------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupToProduct
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupToProduct TO VpWebApp 
GO
----------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupToProduct
	@id int,
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_to_product]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[product_id] = @productId
      ,[enabled] = @enabled 
      ,[modified] = @modified
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupToProduct TO VpWebApp 
GO

-------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_to_product_id] AS id
      ,[product_compression_group_id]
      ,[product_id]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductDetail TO VpWebApp 
GO

----------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupToProduct
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_to_product]
           ([product_compression_group_id]
           ,[product_id]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @productId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupToProduct TO VpWebApp 
GO
-------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupOrder
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder bit,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_order]
           ([product_compression_group_id]
           ,[content_type_id]
           ,[content_id]
           ,[sort_order]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @contentTypeId, @contentId, @sortOrder, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupOrder TO VpWebApp 
GO
----------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupOrderDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupOrderDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_order_id] AS id
      ,[product_compression_group_id]
      ,[content_type_id]
      ,[content_id]
      ,[sort_order]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupOrderDetail TO VpWebApp 
GO

-------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupOrder
	@id int,
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_order]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[content_type_id] = @contentTypeId
      ,[content_id] = @contentId
      ,[sort_order] = @sortOrder
      ,[enabled] = @enabled
      ,[modified] = @modified
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupOrder TO VpWebApp 
GO
---------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupOrder
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupOrder TO VpWebApp 
GO
------------------------


IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'show_in_matrix' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[product]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [product]
	ADD show_in_matrix bit not null default '1'
END
GO

--------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'show_detail_page' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[product]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [product]
	ADD show_detail_page bit not null default '1'
END
GO

-------------------------------------------------------

IF NOT EXISTS (SELECT module_name FROM module WHERE module_name = 'GroupedProducts')
BEGIN
	INSERT INTO module
	VALUES('GroupedProducts','~/Modules/ProductDetail/GroupedProducts.ascx','1',GETDATE(),GETDATE(),'0')
END

---------------------------------------------------

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
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdList TO VpWebApp 
GO
------------------------------------------------

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
		, created, modified) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY group_title) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified
	FROM temp_product_compression_group 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList TO VpWebApp 
GO

--------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList
	@productCompressionGroupId int,
	@productId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM product_compression_group_to_product
	WHERE 	(@productCompressionGroupId IS NULL OR product_compression_group_id = @productCompressionGroupId) AND
			 (@productId IS NULL OR product_id = @productId);

	WITH temp_group_product(row, id, product_compression_group_id, product_id, enabled, created, modified) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY product_compression_group_to_product_id) AS row, product_compression_group_to_product_id AS id, product_compression_group_id, 
		product_id, enabled, created, modified
		FROM  product_compression_group_to_product proGro
		WHERE 	(@productCompressionGroupId IS NULL OR proGro.product_compression_group_id = @productCompressionGroupId) AND
			 (@productId IS NULL OR proGro.product_id = @productId)
	)
		
	SELECT  id, product_compression_group_id, product_id, enabled, created, modified
	FROM temp_group_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
		
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList TO VpWebApp 
GO
------------------------------------------
IF NOT EXISTS (SELECT * FROM content_type WHERE content_type_id = 33)
BEGIN
	INSERT INTO content_type (content_type_id, content_type, enabled, modified, created)
	VALUES (33, 'ProductCompressionGroup', 1, GETDATE(), GETDATE())
END

GO
----------------------------------------------------
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
		proGro.site_id, proGro.enabled, proGro.created, proGro.modified
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
---------------------------------------------------------------
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
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id
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
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO
----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteCompressionGroupToProductBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteCompressionGroupToProductBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

		DELETE FROM product_compression_group_to_product 
		WHERE product_compression_group_id IN
		(
				SELECT groPro.product_compression_group_id
				FROM product_compression_group_to_product groPro
					INNER JOIN product_compression_group gro
						ON gro.product_compression_group_id = groPro.product_compression_group_id
				WHERE gro.site_id = @siteId
		)

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteCompressionGroupToProductBySiteIdList TO VpWebApp 
GO
----------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteCompressionGroupBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteCompressionGroupBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

		DELETE FROM product_compression_group
		WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteCompressionGroupBySiteIdList TO VpWebApp 
GO
-----------------------------------------------







-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
-- =====================Start : adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@segmentName varchar(200),
	@segmentTypeId int,
	@sortBy varchar(20),
	@sortOrder varchar(20),
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_segments(idAsc, idDesc, nameAsc, nameDesc, typeAsc, typeDesc,
		segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable) AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY segment_id) AS idAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_id DESC) AS idDesc, 
			ROW_NUMBER() OVER (ORDER BY name) AS nameAsc, 
			ROW_NUMBER() OVER (ORDER BY name DESC) AS nameDesc,
			ROW_NUMBER() OVER (ORDER BY segment_type) AS typeAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_type DESC) AS typeDesc,
			segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
		FROM segment
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
	)

	SELECT segment_id AS id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
	FROM temp_segments
	WHERE 
		(@sortBy = 'id' AND @sortOrder = 'asc' AND idAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'id' AND @sortOrder = 'desc' AND idDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
		CASE 
			WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idAsc 
			WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameAsc
			WHEN @sortBy = 'type' AND @sortOrder = 'asc' THEN typeAsc
			WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idDesc 
			WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameDesc
			WHEN @sortBy = 'type' AND @sortOrder = 'desc' THEN typeDesc
		END
	
	SELECT @totalCount = COUNT(*)
		FROM segment
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList TO VpWebApp 
GO
--
--
-- =====================End : adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList.sql ==============================
--
-- 
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
		 , has_related, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		 , show_in_matrix, show_detail_page
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
		business_value, show_in_matrix, show_detail_page
)
	AS
	(
		SELECT  product_id, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified,
			created, product_type, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
			, show_in_matrix, show_detail_page
		FROM product
		WHERE enabled = 1 AND site_id = @siteId
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status,
		has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value,
		show_in_matrix, show_detail_page

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
	@showInMatrix bit,
	@showDetailPage bit
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO product(site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, show_in_matrix, show_detail_page) 
	VALUES (@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @created, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue, @showInMatrix, @showDetailPage) 

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
-- =====================Start : adminProduct_AddProductCompressionGroup.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroup
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
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
           ,[modified])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_AddProductCompressionGroup.sql ==============================
--
-- 
-- =====================Start : adminProduct_AddProductCompressionGroupOrder.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupOrder
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder bit,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_order]
           ([product_compression_group_id]
           ,[content_type_id]
           ,[content_id]
           ,[sort_order]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @contentTypeId, @contentId, @sortOrder, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupOrder TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_AddProductCompressionGroupOrder.sql ==============================
--
-- 
-- =====================Start : adminProduct_AddProductCompressionGroupToProduct.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupToProduct
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_to_product]
           ([product_compression_group_id]
           ,[product_id]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @productId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupToProduct TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_AddProductCompressionGroupToProduct.sql ==============================
--
-- 
-- =====================Start : adminProduct_DeleteProductCompressionGroup.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroup
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroup TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_DeleteProductCompressionGroup.sql ==============================
--
-- 
-- =====================Start : adminProduct_DeleteProductCompressionGroupOrder.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupOrder
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupOrder TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_DeleteProductCompressionGroupOrder.sql ==============================
--
-- 
-- =====================Start : adminProduct_DeleteProductCompressionGroupToProduct.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupToProduct
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupToProduct TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_DeleteProductCompressionGroupToProduct.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetCategoryByProductIdList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryByProductIdList
	@productId int
AS
-- ==========================================================================
-- $Archive: /Documents/Templates/moduleName_StoredProcedureName.sql $
-- $Revision: 2 $
-- $Date: 3/14/08 3:43p $ 
-- $Author: Dherbst $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image
	FROM category AS cat 
		INNER JOIN product_to_category AS prodCat
			ON prodCat.product_id = @productId AND cat.category_id = prodCat.category_id

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryByProductIdList TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetCategoryByProductIdList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetCategoryByProductIdsList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryByProductIdsList
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image
	FROM category AS cat
	WHERE category_id
		IN (SELECT DISTINCT category_id FROM product_to_category prodCat
				WHERE prodCat.product_id IN (SELECT [value] FROM Global_Split(@productIds, ',')))

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryByProductIdsList TO VpWebApp
GO
--
--
-- =====================End : adminProduct_GetCategoryByProductIdsList.sql ==============================
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
			, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value
			, pro.show_in_matrix, pro.show_detail_page

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
			, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.show_in_matrix, pro.show_detail_page

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
				pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value,
				pro.show_in_matrix, pro.show_detail_page

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
				pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value,
				pro.show_in_matrix, pro.show_detail_page

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
				pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.show_in_matrix, pro.show_detail_page

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
		pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value,
		pro.show_in_matrix, pro.show_detail_page

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
		p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value,
		p.show_in_matrix, p.show_detail_page

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
				pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value,
				pro.show_in_matrix, pro.show_detail_page

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
		, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value
		, pro.show_in_matrix, pro.show_detail_page
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
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.show_in_matrix, pro.show_detail_page
 INTO #tmpProducts
	FROM product pro
			INNER JOIN product_to_category_group_option pcg
				ON pro.product_id = pcg.product_id
			INNER JOIN category_group_option cgo
				ON cgo.category_group_option_id = pcg.category_group_option_id 
	WHERE cgo.option_id = @optionId AND pro.site_id = @siteId
	
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model, completeness
			, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page

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
		, modified, created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value,
		show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
		SELECT DISTINCT pro.product_id AS id, pro.site_id, pro.parent_product_id, pro.product_name, pro.[rank]
				,pro.has_image, pro.catalog_number, pro.[enabled], pro.modified, pro.created, product_type, status
				,pro.has_related, pro.has_model, pro.completeness, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value
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
				, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
				, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
	, prod.flag1, prod.flag2, prod.flag3, prod.flag4, prod.search_rank, prod.search_content_modified, prod.hidden, prod.business_value
	, prod.show_in_matrix, prod.show_detail_page
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
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value
		, p.show_in_matrix, p.show_detail_page
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
		, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value
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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
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
			, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page)
	AS
	(
		SELECT  product_id AS id, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id, site_id, product_Name, [rank]
				, has_image, catalog_number, [enabled], modified, created, product_type
				, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4
				, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
		FROM product
		WHERE site_id = @siteId AND enabled = 1 AND hidden = 0 AND product_type <> 3
	)

	SELECT id, site_id, product_Name, [rank]
			, has_image, catalog_number, [enabled], modified, created, product_type
			, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4
			, search_rank, search_content_modified, hidden, business_value
			, show_in_matrix, show_detail_page
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

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, 
					id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, 
					product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow, 
					catalog_number, [enabled], modified, created, product_type, [status], 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value,
					show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					, p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					, p.has_related, p.has_model, p.completeness
					, p.flag1, p.flag2, p.flag3, p.flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId AND p.[enabled] = @enabled 
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status
					, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
					, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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

	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY id) AS idRow, 
					id, site_id, parent_product_id, 
					ROW_NUMBER() OVER (ORDER BY product_name) AS nameRow, 
					product_name, [rank], has_image, 
					ROW_NUMBER() OVER (ORDER BY catalog_number) AS catalogNoRow, 
					catalog_number, [enabled], modified, created, product_type, [status], 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
					,show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					,p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					,p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value
					,p.show_in_matrix, p.show_detail_page
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status, 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page

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
					, has_image, catalog_number, [enabled], modified, created, product_type, status, 
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page

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
					has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value,
					show_in_matrix, show_detail_page INTO #tmpProducts
	FROM(
			SELECT DISTINCT p.product_id AS id, p.site_id, p.parent_product_id, p.product_name, p.[rank]
					,p.has_image, p.catalog_number, p.[enabled], p.modified, p.created, product_type, [status]
					,p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4
					,p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.show_in_matrix, p.show_detail_page
			FROM product p
					INNER JOIN product_to_vendor pv
						ON pv.product_id = p.product_id
			WHERE pv.vendor_id = @vendorId AND p.site_id = @siteId AND p.[rank] = @productStatus 
		) AS tmp

	IF @sortOrder = 'asc'
		BEGIN
			SELECT id, site_id, parent_product_id, product_name, rank
					, has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model
					, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
					, show_in_matrix, show_detail_page
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
-- =====================Start : adminProduct_GetProductCompressionGroupBySiteIdPageList.sql=============================
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
		, created, modified) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY group_title) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified
	FROM temp_product_compression_group 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetProductCompressionGroupBySiteIdPageList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetProductCompressionGroupBySiteIdSearchTextList.sql=============================
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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified
	FROM [dbo].[product_compression_group]
	WHERE group_title like +'%' + @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO

--
--
-- =====================End : adminProduct_GetProductCompressionGroupBySiteIdSearchTextList.sql ==============================
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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
			FROM product 
			WHERE site_id = @siteId AND product_Name like @value+'%' AND (@isEnabled IS NULL OR product.enabled = @isEnabled)
				AND (@status IS NULL OR status = @status)
				AND (@excludeParentChild IS NULL OR product.product_id NOT IN (SELECT product_id FROM dbo.product_to_product UNION SELECT parent_product_id FROM dbo.product_to_product))
		END
	ELSE
		BEGIN
			SELECT TOP (@selectLimit) product.product_id as id, site_id, product_Name, [rank], has_image
				, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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
			 , flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM (
			SELECT DISTINCT	p.product_id as id,site_id, product_name, [rank]
					, has_image, catalog_number, [enabled], modified
					, created, product_type, status, has_model, has_related, completeness
					, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
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
--
--
-- =====================End : adminProduct_GetRecentlyModifiedIndexedProducts.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetSKUSpecificationList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeId int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT specification_id AS id, content_type_id, content_id, spec_type_id, specification, display_options, [enabled], modified, created
		FROM specification 		
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND spec_type_id = @selectedSpecTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationList TO VpWebApp 
Go


--
--
-- =====================End : adminProduct_GetSKUSpecificationList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetSKUSpecificationTypeList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationTypeList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeIds varchar(max)
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT specification_type.spec_type_id AS id, spec_type, validation_expression, specification_type.site_id, specification_type.[enabled], 
				specification_type.modified, specification_type.created, is_visible, search_enabled, is_expanded_view, display_empty
		FROM specification_type
	INNER JOIN specification 
		ON specification_type.spec_type_id = specification.spec_type_id
	WHERE specification.content_type_id=@contentTypeId 
		AND specification.content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND specification.spec_type_id NOT IN (SELECT [value] FROM dbo.global_split(@selectedSpecTypeIds, ','))

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationTypeList TO VpWebApp 
Go


--
--
-- =====================End : adminProduct_GetSKUSpecificationTypeList.sql ==============================
--
-- 
-- =====================Start : adminProduct_GetVendorBySiteIdSearchSortedPageList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList
	@siteId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@startIndex int,
	@endIndex int,
	@search varchar(50) = NULL,
	@numberOfRows int output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_GetVendorBySiteIdSortedPageList.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chamindu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #temp_vendor (vendor_id int, site_id int, vendor_name varchar(100), vendor_rank int
	, has_image bit, enabled bit, modified smalldatetime, created smalldatetime, parent_vendor_id int
	, vendor_keywords varchar(MAX), internal_name varchar(255), row int)

	DECLARE @query nvarchar(max)

	SET @query ='INSERT INTO #temp_vendor (vendor_id, site_id, vendor_name, vendor_rank, has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name
		, created, row)
		SELECT vendor_id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name
		, created'
		
	IF(@sortBy = ' ')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_id ' + @sortOrder + ' ) AS row'
	IF(@sortBy = 'id')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_id ' + @sortOrder + ' ) AS row'
	ELSE IF(@sortBy = 'Name')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_name ' + @sortOrder + ' ) AS row'
	
	SET @query = @query + ' FROM 
		(
		SELECT vendor.vendor_id, vendor.site_id, vendor.vendor_name, vendor.[rank] AS vendor_rank
			, vendor.has_image, vendor.enabled, vendor.modified, vendor.created, vendor.parent_vendor_id
			, vendor.vendor_keywords, internal_name
		FROM vendor WHERE '
	
	SET @query = @query + ' vendor.site_id =' + CAST(@siteId AS varchar(10))
	
	IF (@search IS NOT NULL) 
		SET @query = @query + ' AND  (vendor.vendor_name like ''%' + @search + '%'')'
	
	
	SET @query = @query + ' ) AS temp_table'

	
	EXECUTE sp_executesql @query

	SELECT @numberOfRows = COUNT(*) 
	FROM #temp_vendor

	SELECT vendor_id AS id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled
		, modified, created, parent_vendor_id, vendor_keywords, internal_name
	FROM #temp_vendor
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
 
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_GetVendorBySiteIdSearchSortedPageList.sql ==============================
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
	@showInMatrix bit,
	@showDetailPage bit
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
		show_in_matrix = @showInMatrix,
		show_detail_page = @showDetailPage
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
-- =====================Start : adminProduct_UpdateProductCompressionGroup.sql=============================
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
	@groupTitle varchar(500),
	@siteId int,
	@enabled bit,
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
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroup TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_UpdateProductCompressionGroup.sql ==============================
--
-- 
-- =====================Start : adminProduct_UpdateProductCompressionGroupOrder.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupOrder
	@id int,
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_order]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[content_type_id] = @contentTypeId
      ,[content_id] = @contentId
      ,[sort_order] = @sortOrder
      ,[enabled] = @enabled
      ,[modified] = @modified
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupOrder TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_UpdateProductCompressionGroupOrder.sql ==============================
--
-- 
-- =====================Start : adminProduct_UpdateProductCompressionGroupToProduct.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupToProduct
	@id int,
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_to_product]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[product_id] = @productId
      ,[enabled] = @enabled 
      ,[modified] = @modified
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupToProduct TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_UpdateProductCompressionGroupToProduct.sql ==============================
--
-- 
-- =====================Start : adminProduct_UpdateProductLocationByVendorLocationList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductLocationByVendorLocationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductLocationByVendorLocationList
	@vendorId int,
	@newCountryFlag1 bigint,
	@newCountryFlag2 bigint,
	@newCountryFlag3 bigint,
	@newCountryFlag4 bigint,
	@oldCountryFlag1 bigint,
	@oldCountryFlag2 bigint,
	@oldCountryFlag3 bigint,
	@oldCountryFlag4 bigint,
	@updateAll bit
AS
-- ==========================================================================
-- $Author: Dhanushka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DECLARE @productTable TABLE (product_id int)
	DECLARE @maxFlag bigint
	SET @maxFlag = 9223372036854775807
	
	IF @updateAll = 1
	BEGIN

		INSERT INTO @productTable (product_id)
		SELECT product_id
		FROM product_to_vendor
		WHERE vendor_id = @vendorId AND is_manufacturer = 1

	END
	ELSE
	BEGIN

		INSERT INTO @productTable (product_id)
		SELECT product.product_id
		FROM product
			INNER JOIN product_to_vendor
				ON product.product_id = product_to_vendor.product_id
		WHERE vendor_id = @vendorId	AND is_manufacturer = 1 AND
			(
				(flag1 = @maxFlag OR flag1 = @oldCountryFlag1) AND
				(flag2 = @maxFlag OR flag2 = @oldCountryFlag2) AND
				(flag3 = @maxFlag OR flag3 = @oldCountryFlag3) AND
				(flag4 = @maxFlag OR flag4 = @oldCountryFlag4)
			)

	END

	DECLARE @modified smalldatetime
	SET @modified = GETDATE()

	UPDATE product 
	SET flag1 = @newCountryFlag1,
		flag2 = @newCountryFlag2,
		flag3 = @newCountryFlag3,
		flag4 = @newCountryFlag4,
		search_content_modified = 1,
		modified = @modified
	WHERE product_id IN 
	(
		SELECT product_id
		FROM @productTable
	)

	DELETE FROM content_location 
	WHERE content_type_id = 2 AND content_id IN
		(SELECT product_id 
		FROM @productTable)

	INSERT INTO content_location (content_type_id, content_id, location_type_id, location_id, exclude,
		modified, created, enabled, site_id)
	SELECT 2, product_id, location_type_id, location_id, exclude, GETDATE(), GETDATE(), 1, site_id 
	FROM content_location
		CROSS JOIN @productTable
	WHERE content_type_id = 6 AND content_id = @vendorId

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductLocationByVendorLocationList TO VpWebApp 
GO
--
--
-- =====================End : adminProduct_UpdateProductLocationByVendorLocationList.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_AddCategorySearchAspect.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddCategorySearchAspect'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddCategorySearchAspect
	@id int output,
	@categoryId int,
	@name varchar(255),
	@prefixText varchar(100),
	@suffixText varchar(100),
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_search_aspect(category_id, [name], prefix_text, suffix_text, [enabled], modified, created)
	VALUES (@categoryId, @name, @prefixText, @suffixText, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchAspect TO VpWebApp 
Go
--
--
-- =====================End : adminSearchCategory_AddCategorySearchAspect.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_AddCategorySearchAspectContent.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddCategorySearchAspectContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddCategorySearchAspectContent
	@id int output,
	@categorySearchAspectId int,
	@contentTypeId int,
	@contentId int,
	@contentName varchar(500),
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_search_aspect_content
		(category_search_aspect_id, content_type_id, content_id, content_name, [enabled], modified, created)
	VALUES (@categorySearchAspectId, @contentTypeId, @contentId, @contentName, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchAspectContent TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_AddCategorySearchAspectContent.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_AddCategorySearchGroup.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddCategorySearchGroup
	@id int output,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@browseSortOrder int,
	@browsable bit,
	@enabled bit,	
	@guidedBrowseTitle varchar(200),
	@guidedBrowsePrefix varchar(100),
	@guidedBrowseSuffix varchar(100),
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@guidedBrowseDescription varchar(max),
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO category_to_search_group ([category_id], [search_group_id], [sort_order], [searchable], [browse_sort_order], [browsable], [guided_browse_title],
	[guided_browse_description], [guided_browse_prefix], [guided_browse_suffix], [matrix_prefix], [matrix_suffix], [enabled], [modified], [created])
	VALUES (@categoryId, @searchGroupId, @sortOrder, @searchable,  @browseSortOrder, @browsable, @guidedBrowseTitle, @guidedBrowseDescription,
		@guidedBrowsePrefix, @guidedBrowseSuffix, @matrixPrefix, @matrixSuffix, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddCategorySearchGroup TO VpWebApp 
Go
--
--
-- =====================End : adminSearchCategory_AddCategorySearchGroup.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_AddSearchOptionRedirect.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionRedirectBySource'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionRedirectBySource
	@sourceOptionId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [search_option_redirect_id] AS id, source_option_id, destination_option_id, created, enabled, modified
	FROM search_option_redirect
	WHERE source_option_id = @sourceOptionId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionRedirectBySource TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_AddSearchOptionRedirect.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_DeleteCategorySearchAspectContent.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_DeleteCategorySearchAspectContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_DeleteCategorySearchAspectContent
	@id int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM category_search_aspect_content
	WHERE category_search_aspect_content_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_DeleteCategorySearchAspectContent TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_DeleteCategorySearchAspectContent.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_DeleteSearchAspectContentsBySearchAspectId.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_DeleteSearchAspectContentsBySearchAspectId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_DeleteSearchAspectContentsBySearchAspectId
	@categorySearchAspectId int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM category_search_aspect_content
	WHERE category_search_aspect_id = @categorySearchAspectId

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_DeleteSearchAspectContentsBySearchAspectId TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_DeleteSearchAspectContentsBySearchAspectId.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_DeleteSearchAspectContentsBySiteId.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_DeleteSearchAspectContentsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_DeleteSearchAspectContentsBySiteId
	@siteId int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM category_search_aspect_content
	WHERE category_search_aspect_id IN
	(
		SELECT category_search_aspect_id
		FROM category_search_aspect
		WHERE category_id IN
		(
			SELECT category_id FROM category
			WHERE site_id = @siteId
		)
	)

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_DeleteSearchAspectContentsBySiteId TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_DeleteSearchAspectContentsBySiteId.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_DeleteSearchOptionRedirect.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_DeleteSearchOptionRedirect'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_DeleteSearchOptionRedirect
	@id int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM search_option_redirect
	WHERE [search_option_redirect_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_DeleteSearchOptionRedirect TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_DeleteSearchOptionRedirect.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_DeleteSearchOptionRedirectsBySiteId.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_DeleteSearchOptionRedirectsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_DeleteSearchOptionRedirectsBySiteId
	@siteId int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM search_option_redirect
	WHERE source_option_id IN
	(
		SELECT search_option_id
		FROM search_option
		WHERE search_group_id IN
		(
			SELECT search_group_id
			FROM search_group
			WHERE site_id = @siteId
		)
	)

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_DeleteSearchOptionRedirectsBySiteId TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_DeleteSearchOptionRedirectsBySiteId.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_UpdateCategorySearchAspect.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateCategorySearchAspect'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateCategorySearchAspect
	@id int,
	@categoryId int,
	@name varchar(255),
	@prefixText varchar(100),
	@suffixText varchar(100),
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()	
	
	UPDATE category_search_aspect
	SET
		category_id = @categoryId,
		[name] = @name,
		prefix_text = @prefixText,
		suffix_text = @suffixText,
		[enabled] = @enabled,
		modified = @modified
	WHERE category_search_aspect_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchAspect TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_UpdateCategorySearchAspect.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_UpdateCategorySearchAspectContent.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateCategorySearchAspectContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateCategorySearchAspectContent
	@id int,
	@categorySearchAspectId int,
	@contentTypeId int,
	@contentId int,
	@contentName varchar(500),
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()	
	
	UPDATE category_search_aspect_content
	SET
		category_search_aspect_id = @categorySearchAspectId,
		content_type_id = @contentTypeId,
		content_id = @contentId,
		content_name = @contentName,
		[enabled] = @enabled,
		modified = @modified
	WHERE category_search_aspect_content_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchAspectContent TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_UpdateCategorySearchAspectContent.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_UpdateCategorySearchGroup.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateCategorySearchGroup
	@id int,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@browseSortOrder int,
	@browsable bit,
	@enabled bit,	
	@guidedBrowseTitle varchar(200),
	@guidedBrowsePrefix varchar(100),
	@guidedBrowseSuffix varchar(100),
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@guidedBrowseDescription varchar(max),
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE [category_to_search_group]
	SET
		[category_id] = @categoryId,
		[search_group_id] = @searchGroupId,
		[sort_order] = @sortOrder,
		[searchable] = @searchable,
		[browse_sort_order] = @browseSortOrder,
		[browsable] = @browsable,
		[guided_browse_title] = @guidedBrowseTitle,
		[guided_browse_description] = @guidedBrowseDescription,
		[guided_browse_prefix] = @guidedBrowsePrefix,
		[guided_browse_suffix] = @guidedBrowseSuffix,
		[matrix_prefix] = @matrixPrefix,
		[matrix_suffix] = @matrixSuffix,
		[enabled] = @enabled,
		[modified] = @modified
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchGroup TO VpWebApp 
GO
--
--
-- =====================End : adminSearchCategory_UpdateCategorySearchGroup.sql ==============================
--
-- 
-- =====================Start : adminSearchCategory_UpdateSearchOptionRedirect.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateSearchOptionRedirect'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateSearchOptionRedirect
	@id int,
	@sourceOptionId int,
	@destinationOptionId int,
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE search_option_redirect
	SET
		source_option_id = @sourceOptionId,
		destination_option_id = @destinationOptionId,
		enabled = @enabled,
		modified = @modified
	WHERE [search_option_redirect_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateSearchOptionRedirect TO VpWebApp 
Go
--
--
-- =====================End : adminSearchCategory_UpdateSearchOptionRedirect.sql ==============================
--
-- 
-- =====================Start : adminUser_GetPublicUsersByEmailList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUsersByEmailList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUsersByEmailList
	@email varchar(255)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_id AS id, site_id, email, email_optout, [enabled], modified, created
	FROM public_user 
	WHERE email = @email
 
END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUsersByEmailList TO VpWebApp 
GO
--
--
-- =====================End : adminUser_GetPublicUsersByEmailList.sql ==============================
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
		, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value
		, p.show_in_matrix, p.show_detail_page
		, p.completeness, pc.product_to_category_id, pc.category_id, pc.product_id
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
	ORDER BY newid()


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
		, p.has_related, p.has_model, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value
		, p.show_in_matrix, p.show_detail_page
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
-- =====================Start : publicProduct_GetCommonSpecificationDetail.sql=============================


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options, CAST(1 AS bit) AS [enabled], GETDATE() AS modified, GETDATE() AS created
		FROM specification 
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
Go



--
--
-- =====================End : publicProduct_GetCommonSpecificationDetail.sql ==============================
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
		show_in_matrix bit,
		show_detail_page bit

	)

	

	INSERT INTO #TempProductList
	
		SELECT DISTINCT p.product_id as id, p.site_id as site_id, p.product_name as product_name, ROW_NUMBER() OVER (ORDER BY product_Name) AS row_id
						, p.rank as rank 
						, p.has_image as has_image, p.catalog_number as catalog_number, p.enabled as enabled, p.modified as modified
						, p.created as created, p.product_type as product_type, p.status as status, p.has_related as has_related, p.has_model as has_model
						, p.completeness as completeness, p.flag1, p.flag2, p.flag3, p.flag4
						, p.search_rank, p.search_content_modified, p.hidden, p.business_value, p.show_in_matrix, p.show_detail_page

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

		WHERE p.enabled = 1 AND ptc.category_id = @categoryId AND ptv.vendor_id <> @vendorId AND (COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) = 1 OR COALESCE(atcp.enabled, atcv.enabled, atcc.enabled, atcs.enabled) IS NULL)
			  AND (vpVENDOR.vendor_parameter_value = 1 OR vpVENDOR.vendor_parameter_value IS NULL) AND (vpALL.vendor_parameter_value = 0 OR vpALL.vendor_parameter_value IS NULL)
			  AND (vpPRODUCT.product_parameter_value = 0 OR vpPRODUCT.product_parameter_value IS NULL)
		
		
		SELECT id, site_id, product_Name, [rank], has_image, catalog_number
			, [enabled], modified, created, product_type, status, has_related, has_model
			, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page

		FROM #TempProductList
		WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

		
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
		, business_value int, show_in_matrix bit, show_detail_page bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, show_in_matrix bit, show_detail_page bit, parent_vendor_id int)

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
		,product.show_in_matrix
		,product.show_detail_page
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
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
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, show_in_matrix, show_detail_page
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
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
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
			, has_related, has_model, completeness, business_value, show_in_matrix, show_detail_page
			, pro.flag1, pro.flag2, pro.flag3, pro.flag4, pro.search_rank, pro.search_content_modified, pro.hidden
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
			, pro.search_content_modified, pro.hidden, pro.business_value, show_in_matrix, show_detail_page
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
		SELECT product.product_id as id, site_id, product_Name, ROW_NUMBER() OVER (ORDER BY product_Name) AS row_id, [rank]
				, has_image, catalog_number, product.[enabled], product.modified, product.created, product_type, status
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
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
		completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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
			 , flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
-- 
-- =====================Start : publicProduct_GetProductByCategoryIdPageList.sql=============================
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
		, business_value int, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL
		, show_in_matrix bit, show_detail_page bit)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

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
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
		, NULL
		,product.show_in_matrix
		,product.show_detail_page
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
	
	SET @query = @query + 'parent_product_id, product_name, [rank], has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value
		, show_in_matrix, show_detail_page

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
		search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdPageList TO VpWebApp
GO

--
--
-- =====================End : publicProduct_GetProductByCategoryIdPageList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductByCategoryIdProductIdsList.sql=============================

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByCategoryIdProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByCategoryIdProductIdsList
	@categoryId int,
	@productIds varchar(100)
AS
-- ==========================================================================
-- Author : nilushi
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #vendor_product (id int identity(1,1), product_id int, product_name varchar(512), 
		vendor_id int)

	INSERT INTO #vendor_product (product_id, product_name, vendor_id)
	SELECT product.product_id, product.product_name, product_to_vendor.vendor_id
	FROM product 
		INNER JOIN product_to_category 
			ON product.product_id = product_to_category.product_id 
		INNER JOIN product_to_vendor 
			ON product.product_id = product_to_vendor.product_id AND 
				product_to_vendor.is_manufacturer = 1 AND product_to_vendor.lead_enabled = 1
	WHERE product_to_category.category_id = @categoryId 
		AND
		product.product_id NOT IN 
			(SELECT [value] FROM global_Split(@productIds, ','))
		AND 
		product_to_vendor.vendor_id NOT IN 
			(SELECT vendor_id FROM product_to_vendor WHERE product_to_vendor.product_id IN 
				(SELECT [value] FROM global_Split(@productIds, ',')))
		AND product.enabled = 1 AND product_to_category.enabled = 1 
		AND product_to_vendor.enabled = 1
	ORDER BY product_to_vendor.vendor_id, product.product_name

	SELECT product.product_id AS id, site_id, parent_product_id, product.product_name, [rank],
		has_image, catalog_number, product.[enabled], product.modified, product.created, 
		product_type, [status], has_related, has_model, completeness, 
		product.flag1, product.flag2, product.flag3, product.flag4, product.search_rank, product.search_content_modified, hidden, business_value,
		show_in_matrix, show_detail_page
	FROM #vendor_product 
		INNER JOIN (
			SELECT MIN(id) AS id
			FROM #vendor_product
			GROUP BY vendor_id
		) temp
			ON #vendor_product.id = temp.id
		INNER JOIN product 
			ON #vendor_product.product_id = product.product_id

	DROP TABLE #vendor_product
	
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByCategoryIdProductIdsList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductByCategoryIdProductIdsList.sql ==============================
--
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
			, pro.search_content_modified, pro.hidden, pro.business_value, pro.show_in_matrix, pro.show_detail_page

	FROM (
			SELECT product_id, site_id, parent_product_id, product_name, [rank]
				, has_image, catalog_number, enabled, modified, created, product_type
				, status, has_related, has_model
				, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
			, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.show_in_matrix, pro.show_detail_page
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
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
				  product.search_rank, product.search_content_modified, product.hidden, product.business_value, product.show_in_matrix, product.show_detail_page

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
,t.flag1, t.flag2, t.flag3, t.flag4, t.search_rank, t.search_content_modified, t.hidden, t.business_value, t.show_in_matrix, t.show_detail_page

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
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
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
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page

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
-- =====================Start : publicProduct_GetProductCompressionGroupByProductIdsList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsList
	@productIds varchar(4000)
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT CAST(p.[value] AS int) AS product_id, product_compression_group_id AS id, g.site_id, show_in_matrix, show_product_count, 
		group_title, expand_products, g.enabled, g.created, g.modified,
		(SELECT COUNT(*) 
		FROM product_compression_group_to_product 
		WHERE product_compression_group_id = g.product_compression_group_id) AS product_count
	FROM product_compression_group AS g
		INNER JOIN content_to_content AS c
			ON c.associated_content_type_id = 33 AND c.associated_content_id = g.product_compression_group_id
		INNER JOIN global_Split(@productIds, ',') AS p
			ON c.content_type_id = 2 AND c.content_id = p.[value]
		

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsList TO VpWebApp 
GO

--
--
-- =====================End : publicProduct_GetProductCompressionGroupByProductIdsList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductCompressionGroupDetail.sql=============================
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
	FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupDetail TO VpWebApp 
GO

--
--
-- =====================End : publicProduct_GetProductCompressionGroupDetail.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductCompressionGroupOrderDetail.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupOrderDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupOrderDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_order_id] AS id
      ,[product_compression_group_id]
      ,[content_type_id]
      ,[content_id]
      ,[sort_order]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupOrderDetail TO VpWebApp 
GO

--
--
-- =====================End : publicProduct_GetProductCompressionGroupOrderDetail.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList
	@productCompressionGroupId int,
	@productId int,
	@pageIndex int,
	@pageSize int,
	@totalRowCount int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = (@pageSize * (@pageIndex - 1)) + 1
	SET @endIndex = @pageSize * @pageIndex

	SELECT @totalRowCount = COUNT(*)
	FROM product_compression_group_to_product
	WHERE 	(@productCompressionGroupId IS NULL OR product_compression_group_id = @productCompressionGroupId) AND
			 (@productId IS NULL OR product_id = @productId);

	WITH temp_group_product(row, id, product_compression_group_id, product_id, enabled, created, modified) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY product_compression_group_to_product_id) AS row, product_compression_group_to_product_id AS id, product_compression_group_id, 
		product_id, enabled, created, modified
		FROM  product_compression_group_to_product proGro
		WHERE 	(@productCompressionGroupId IS NULL OR proGro.product_compression_group_id = @productCompressionGroupId) AND
			 (@productId IS NULL OR proGro.product_id = @productId)
	)
		
	SELECT  id, product_compression_group_id, product_id, enabled, created, modified
	FROM temp_group_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
		
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList TO VpWebApp 
GO

--
--
-- =====================End : publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductCompressionGroupToProductDetail.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_to_product_id] AS id
      ,[product_compression_group_id]
      ,[product_id]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductDetail TO VpWebApp 
GO

--
--
-- =====================End : publicProduct_GetProductCompressionGroupToProductDetail.sql ==============================
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
		, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
		, business_value int, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL,
		show_in_matrix bit, show_detail_page bit)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

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
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, show_in_matrix, show_detail_page
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
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
		, has_model, flag1, flag2, flag3, flag4, search_rank, completeness, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
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
			, p.search_content_modified, p.hidden, p.business_value, p.show_in_matrix, p.show_detail_page
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
				product.search_rank, product.search_content_modified, product.hidden, product.business_value,
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
	, t.flag1, t.flag2, t.flag3, t.flag4, t.search_rank, t.search_content_modified, t.hidden, t.business_value
	, t.show_in_matrix, t.show_detail_page
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
		, business_value int, product_to_vendor_id int, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

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
		, business_value int, parent_vendor_id int, show_in_matrix bit, show_detail_page bit)

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
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
	FROM
	(
		SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
			, has_image, catalog_number, enabled, modified, created, product_type, status
			, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
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
	@batchSize int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) product_id AS id, site_id, product_Name, [rank], has_image
		, catalog_number, [enabled], modified, created, product_type, [status]
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
	FROM product 
	WHERE site_id = @siteId AND enabled = 1 AND search_content_modified = 1
	ORDER BY product_id
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductsToIndexInSearchProviderList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductsToIndexInSearchProviderList.sql ==============================
--
-- 
-- =====================Start : publicProduct_GetProductToProductByChildProductIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductToProductByChildProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.publicProduct_GetProductToProductByChildProductIdList
	@productId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_product_id AS id, parent_product_id, product_id, enabled, created, modified
	FROM product_to_product	
	WHERE product_to_product.product_id = @productId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductToProductByChildProductIdList TO VpWebApp 
GO
--
--
-- =====================End : publicProduct_GetProductToProductByChildProductIdList.sql ==============================
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
			, has_related, has_model, flag1, flag2, flag3, flag4, search_rank, completeness, search_content_modified, hidden, business_value
			, show_in_matrix, show_detail_page
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
--
-- 
-- =====================Start : publicSearchCategory_GetCategorySearchAspect.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchAspect'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchAspect
	@id int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_search_aspect_id] AS id, [category_id], [name], prefix_text, suffix_text, [created], [enabled], [modified]
	FROM category_search_aspect
	WHERE [category_search_aspect_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchAspect TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetCategorySearchAspect.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetCategorySearchAspectContent.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchAspectContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchAspectContent
	@id int
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT category_search_aspect_content_id AS id, category_search_aspect_id, content_type_id, content_id, content_name, created, [enabled], modified
	FROM category_search_aspect_content
	WHERE category_search_aspect_content_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchAspectContent TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetCategorySearchAspectContent.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetCategorySearchGroupDetail.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable], [browse_sort_order], [browsable],
	[guided_browse_title], [guided_browse_description], [guided_browse_prefix], [guided_browse_suffix], [matrix_prefix], [matrix_suffix],[created], [enabled], [modified]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetCategorySearchGroupDetail.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetCategorySearchGroupsByCategoryIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList
	@categoryId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable], [browse_sort_order], [browsable],
	[guided_browse_title], [guided_browse_description],[guided_browse_prefix], [guided_browse_suffix], [matrix_prefix], [matrix_suffix], [created], [enabled], [modified]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetCategorySearchGroupsByCategoryIdList.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList
	@categorySearchAspectId int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT category_search_aspect_content_id AS id, category_search_aspect_id, content_type_id, content_id, content_name, created, [enabled], modified
	FROM category_search_aspect_content
	WHERE [category_search_aspect_id] = @categorySearchAspectId

	SELECT @totalCount = COUNT(*)
	FROM category_search_aspect_content
	WHERE [category_search_aspect_id] = @categorySearchAspectId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetSearchAspectContentsBySearchAspectIdList.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetSearchAspectsByCategoryId.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchAspectsByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchAspectsByCategoryId
	@categoryId int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_search_aspect_id] AS id, [category_id], [name], prefix_text, suffix_text, [created], [enabled], [modified]
	FROM category_search_aspect
	WHERE category_id = @categoryId

	SELECT @totalCount = COUNT(*)
	FROM category_search_aspect
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchAspectsByCategoryId TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetSearchAspectsByCategoryId.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetSearchOptionRedirectBySource.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionRedirectBySource'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionRedirectBySource
	@sourceOptionId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [search_option_redirect_id] AS id, source_option_id, destination_option_id, created, enabled, modified
	FROM search_option_redirect
	WHERE source_option_id = @sourceOptionId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionRedirectBySource TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetSearchOptionRedirectBySource.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetSearchOptionRedirectDetail.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionRedirectDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionRedirectDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [search_option_redirect_id] AS id, source_option_id, destination_option_id, created, enabled, modified
	FROM search_option_redirect
	WHERE search_option_redirect_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionRedirectDetail TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetSearchOptionRedirectDetail.sql ==============================
--
-- 
-- =====================Start : publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList.sql=============================
EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList
	@categoryId int,
	@primaryOptions varchar(max),
	@secondaryOptions varchar(max)
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	-- Populate primary search option ids
	CREATE TABLE #PrimarySearchOption (search_option_id int)
	INSERT INTO #PrimarySearchOption
	SELECT [VALUE] FROM global_split(@primaryOptions, ',')

	-- Populate secondary search option ids
	CREATE TABLE #SecondarySearchOption (search_option_id int)
	INSERT INTO #SecondarySearchOption
	SELECT [VALUE] FROM global_split(@secondaryOptions, ',')

	-- Find number of rows in secondary option ids
	DECLARE @secondarySearchOptionCount int
	SELECT @secondarySearchOptionCount = COUNT(*) FROM #SecondarySearchOption

	-- Find products having at least one primary option and all secondary options
	CREATE TABLE #FilteredProduct (product_id int)
	INSERT INTO #FilteredProduct
	SELECT ps.product_id
	FROM product_to_search_option ps
		INNER JOIN product_to_category pc
			ON ps.product_id = pc.product_id AND pc.category_id = @categoryId
	WHERE ps.product_id IN 
	(
		SELECT product_id
		FROM product_to_search_option so
			INNER JOIN #PrimarySearchOption
				ON so.search_option_id = #PrimarySearchOption.search_option_id
	)
	AND ps.search_option_id IN
	(
		SELECT search_option_id
		FROM #SecondarySearchOption
	)
	GROUP BY ps.product_id
	HAVING COUNT(ps.search_option_id) = @secondarySearchOptionCount

	-- Select search options in primary option list having products in filtered products list
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id
		FROM product_to_search_option ps
			INNER JOIN #FilteredProduct
				ON ps.product_id = #FilteredProduct.product_id
		WHERE search_option_id IN
		(
			SELECT search_option_id
			FROM #PrimarySearchOption
		)
	)

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList TO VpWebApp 
GO
--
--
-- =====================End : publicSearchCategory_GetSecondarySearchOptionsFilteredByPrimaryOptionsList.sql ==============================
----------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList
	@productCompressionGroupId int,
	@searchOptionIds varchar(max)
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	
	SELECT DISTINCT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList TO VpWebApp 
GO
-----------------------------------------------------------------------------
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetMissingProductByCategoryIdCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetMissingProductByCategoryIdCount
	@categoryId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@productIds varchar(MAX),
	@filterVendorIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT COUNT(p.product_id)
	FROM product p
		INNER JOIN product_to_category ptc
			ON p.product_id = ptc.product_id
		INNER JOIN product_to_vendor ptv
			ON p.product_id = ptv.product_id 
				AND ptv.is_manufacturer = 1
		INNER JOIN vendor v
			ON ptv.vendor_id = v.vendor_id
	WHERE ptc.category_id = @categoryId 
		AND p.enabled = 1
		AND p.show_in_matrix = 1
		AND ptc.enabled = 1
		AND v.enabled = 1 
		AND	p.product_id NOT IN 
		(
			SELECT [value] FROM dbo.global_Split(@productIds, ',')
		)
		AND
		(
			@filterVendorIds IS NULL	
			OR DATALENGTH(@filterVendorIds) = 0
			OR	(
					DATALENGTH(@filterVendorIds) > 0 
					AND
					(
						ISNULL(v.parent_vendor_id, v.vendor_id) 
						IN (
								SELECT [value] FROM global_Split(@filterVendorIds, ',')
						   )
					)
				) 
		)
		AND
		(
			(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
			(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
		)
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetMissingProductByCategoryIdCount TO VpWebApp 
GO

---------

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
		, business_value int, show_in_matrix bit, show_detail_page bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, show_in_matrix bit, show_detail_page bit, parent_vendor_id int)

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
		,product.show_in_matrix
		,product.show_detail_page
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
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
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, show_in_matrix, show_detail_page
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
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
		, show_in_matrix, show_detail_page
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetMissingProductByCategoryIdPageList TO VpWebApp
GO

-----------
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
IF EXISTS (SELECT module_name FROM module WHERE module_name = 'GroupedProducts')
BEGIN
	UPDATE module
	SET usercontrol_name = '~/Modules/ProductDetail/GroupedProducts.ascx'
	WHERE module_name = 'GroupedProducts'
END
-------------------------------------------------

IF NOT EXISTS (SELECT module_name FROM module WHERE module_name = 'GroupedProducts')
BEGIN
	INSERT INTO module
	VALUES('GroupedProducts','~/Modules/ProductDetail/GroupedProducts.ascx','1',GETDATE(),GETDATE(),'0')
END

-----------------------------------------
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		, group_title, expand_products, enabled, created, modified, product_id, product_count
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


-------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList
	@parentProductId int,
	@compressionGroupId int,
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
	
	SELECT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product		
		INNER JOIN product_compression_group_to_product cp
			ON product.product_id = cp.product_id
		INNER JOIN product_to_product pp
			ON product.product_id = pp.product_id
	WHERE cp.product_compression_group_id = @compressionGroupId AND pp.parent_product_id = @parentProductId
		AND (
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList TO VpWebApp 
GO

----------------------------------------------------------------------------------------
IF NOT EXISTS 
(SELECT [name] FROM syscolumns where [name] = 'is_default' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'product_compression_group') AND type in (N'U')))
	BEGIN
		ALTER TABLE product_compression_group
		ADD is_default BIT not null DEFAULT 0
	END
GO

----------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroup
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
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
		   ,[is_default])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created, @isDefault)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
GO

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
		, created, modified, is_default) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY group_title) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified, is_default
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified, is_default
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
		, group_title, expand_products, enabled, created, modified, is_default, product_id, product_count
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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified, is_default
	FROM [dbo].[product_compression_group]
	WHERE group_title like @searchText +'%' AND site_id = @siteId

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
		proGro.site_id, proGro.enabled, proGro.created, proGro.modified, proGro.is_default
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

-------------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductToDefaultCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductToDefaultCompressionGroup
	@productID int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF ((select count(product_compression_group_id) from [product_compression_group_to_product] where product_id = @productID)=0)
	BEGIN
		DECLARE @defaultGroupID int
		DECLARE @enabled bit
		DECLARE @created smalldatetime
		
		SET @enabled = 1
		SET @created = GETDATE()
		SET @defaultGroupID = (SELECT product_compression_group_id 
								FROM product_compression_group 
								WHERE is_default = 1 and site_id = (
									SELECT site_id 
									FROM product 
									WHERE product_id = @productID))
		
		INSERT INTO [product_compression_group_to_product]
           ([product_compression_group_id]
           ,[product_id]
           ,[enabled]
           ,[created]
           ,[modified])
		VALUES
           (@defaultGroupID
           ,@productID
           ,@enabled
           ,@created
           ,@created)
	END
END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductToDefaultCompressionGroup TO VpWebApp 
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
	FROM [product_compression_group] gro
		INNER JOIN product_compression_group_to_product groPro
			ON gro.product_compression_group_id = groPro.product_compression_group_id
	WHERE groPro.product_id = @productID

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsByProductID TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductFromCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductFromCompressionGroup
	@productID int
	,@compressionGroupID int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM product_compression_group_to_product 
	WHERE product_compression_group_id = @compressionGroupID and product_id = @productID

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductFromCompressionGroup TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompressionGroupToProduct
	@groupProductID int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [product_compression_group_to_product_id] AS id
      ,[product_compression_group_id]
      ,[product_id]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [product_compression_group_to_product]
	WHERE [product_compression_group_to_product_id] = @groupProductID

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupToProduct TO VpWebApp 
GO
----------------------------------------------------------------------------------------------------------------------------

/*DDL Modifications*/

IF NOT EXISTS ( SELECT  *
                FROM    sys.columns
                WHERE   name = N'product_compression_name'
                        AND object_id = OBJECT_ID(N'uploaded_product') ) 
    BEGIN
        ALTER TABLE dbo.uploaded_product ADD product_compression_name VARCHAR(255) NULL
    END
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.columns
                WHERE   name = N'product_compression_group'
                        AND object_id = OBJECT_ID(N'uploaded_product') ) 
    BEGIN
        ALTER TABLE dbo.uploaded_product ADD product_compression_group VARCHAR(255) NULL
    END
GO

/*Stored Procedures*/
EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_AddUploadedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_AddUploadedProduct]
    @id INT OUTPUT ,
    @batch_id VARCHAR(75) ,
    @temp_product_id INT ,
    @vendor_id INT ,
    @item_name VARCHAR(255) ,
    @catalog_number VARCHAR(255) ,
    @product_type INT ,
    @price MONEY ,
    @url VARCHAR(250) ,
    @file_Name VARCHAR(255) ,
    @site_id INT ,
    @enabled BIT ,
    @created SMALLDATETIME OUTPUT ,
    @uploaded_parent_product_id INT ,
    @is_temp_parent_product_id BIT ,
    @child_product_on_db VARCHAR(MAX) ,
    @child_product_on_excel VARCHAR(MAX) ,
    @product_compression_name VARCHAR(255) ,
    @product_compression_group VARCHAR(255)
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================  
    BEGIN    
     
        SET NOCOUNT ON;    
    
        SET @created = GETDATE()    
    
        INSERT  INTO uploaded_product
                ( batch_id ,
                  temp_product_id ,
                  vendor_id ,
                  item_name ,
                  catalog_number ,
                  price ,
                  url ,
                  uploaded_file_name ,
                  site_id ,
                  product_type ,
                  enabled ,
                  modified ,
                  created ,
                  uploaded_parent_product_id ,
                  is_temp_parent_product_id ,
                  child_product_on_db ,
                  child_product_on_excel ,
                  product_compression_name ,
                  product_compression_group
                )
        VALUES  ( @batch_id ,
                  @temp_product_id ,
                  @vendor_id ,
                  @item_name ,
                  @catalog_number ,
                  @price ,
                  @url ,
                  @file_name ,
                  @site_id ,
                  @product_type ,
                  @enabled ,
                  @created ,
                  @created ,
                  @uploaded_parent_product_id ,
                  @is_temp_parent_product_id ,
                  @child_product_on_db ,
                  @child_product_on_excel ,
                  @product_compression_name ,
                  @product_compression_group
                )    
    
        SET @id = SCOPE_IDENTITY()    
    END    
Go


GRANT EXECUTE ON dbo.adminUploadedProduct_AddUploadedProduct TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_GetUploadedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
   
CREATE PROCEDURE [dbo].[adminUploadedProduct_GetUploadedProduct] @id INT
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================   
    BEGIN    
     
        SET NOCOUNT ON    
    
        SELECT  uploaded_product_id AS id ,
                batch_id AS batch_id ,
                temp_product_id AS temp_product_id ,
                vendor_id AS vendor_id ,
                item_name AS item_name ,
                catalog_number AS catalog_number ,
                price AS price ,
                url AS url ,
                uploaded_file_name AS uploaded_file_name ,
                site_id AS site_id ,
                product_type AS product_type ,
                [enabled] AS [enabled] ,
                modified AS modified ,
                created AS created ,
                uploaded_parent_product_id AS uploaded_parent_product_id ,
                is_temp_parent_product_id AS is_temp_parent_product_id ,
                child_product_on_db AS child_product_on_db ,
                child_product_on_excel AS child_product_on_excel ,
                product_compression_name AS product_compression_name ,
                product_compression_group AS product_compression_group
        FROM    uploaded_product
        WHERE   uploaded_product_id = @id 
     
    END 
GO

GRANT EXECUTE ON dbo.adminUploadedProduct_GetUploadedProduct TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_GetUploadedProductList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_GetUploadedProductList] @SiteId AS
    INT
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================  
    BEGIN    
     
        SET NOCOUNT ON    
    
        SELECT  uploaded_product_id AS id ,
                batch_id AS batch_id ,
                temp_product_id AS temp_product_id ,
                vendor_id AS vendor_id ,
                item_name AS item_name ,
                catalog_number AS catalog_number ,
                price AS price ,
                url AS url ,
                uploaded_file_name AS uploaded_file_name ,
                site_id AS site_id ,
                product_type AS product_type ,
                [enabled] AS [enabled] ,
                modified AS modified ,
                created AS created ,
                uploaded_parent_product_id AS uploaded_parent_product_id ,
                is_temp_parent_product_id AS is_temp_parent_product_id ,
                child_product_on_db AS child_product_on_db ,
                child_product_on_excel AS child_product_on_excel ,
                product_compression_name AS product_compression_name ,
                product_compression_group AS product_compression_group
        FROM    uploaded_product
        WHERE   site_id = @SiteId    
    END 
GO

GRANT EXECUTE ON dbo.adminUploadedProduct_GetUploadedProductList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_GetUploadedProductListByBatchId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_GetUploadedProductListByBatchId] @batchId AS
    VARCHAR(75)
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================  
    BEGIN   
     
        SET NOCOUNT ON    
    
        SELECT  uploaded_product_id AS id ,
                batch_id AS batch_id ,
                temp_product_id AS temp_product_id ,
                vendor_id AS vendor_id ,
                item_name AS item_name ,
                catalog_number AS catalog_number ,
                price AS price ,
                url AS url ,
                uploaded_file_name AS uploaded_file_name ,
                site_id AS site_id ,
                product_type AS product_type ,
                [enabled] AS [enabled] ,
                modified AS modified ,
                created AS created ,
                uploaded_parent_product_id AS uploaded_parent_product_id ,
                is_temp_parent_product_id AS is_temp_parent_product_id ,
                child_product_on_db AS child_product_on_db ,
                child_product_on_excel AS child_product_on_excel ,
                product_compression_name AS product_compression_name ,
                product_compression_group AS product_compression_group
        FROM    uploaded_product
        WHERE   batch_id = @batchId;    
    END 
GO
GRANT EXECUTE ON dbo.adminUploadedProduct_GetUploadedProductListByBatchId TO VpWebApp 
GO

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
                is_default
        FROM    dbo.product_compression_group
        WHERE   site_id = @siteId

    END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsBySiteId TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_UpdateUploadedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_UpdateUploadedProduct]
    @id INT ,
    @batch_id VARCHAR(75) ,
    @temp_product_id INT ,
    @vendor_id INT ,
    @item_name VARCHAR(255) ,
    @catalog_number VARCHAR(255) ,
    @product_type INT ,
    @price MONEY ,
    @url VARCHAR(250) ,
    @file_Name VARCHAR(255) ,
    @site_id INT ,
    @enabled BIT ,
    @modified SMALLDATETIME OUTPUT ,
    @uploaded_parent_product_id INT ,
    @is_temp_parent_product_id BIT ,
    @child_product_on_db VARCHAR(MAX) ,
    @child_product_on_excel VARCHAR(MAX) ,
    @product_compression_name VARCHAR(255) ,
    @product_compression_group VARCHAR(255)
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================    
    BEGIN    
     
        SET NOCOUNT ON;    
     
        SET @modified = GETDATE()    
    
        UPDATE  uploaded_product
        SET     batch_id = @batch_id ,
                temp_product_id = @temp_product_id ,
                vendor_id = @vendor_id ,
                item_name = @item_name ,
                catalog_number = @catalog_number ,
                price = @price ,
                url = @url ,
                uploaded_file_name = @file_Name ,
                site_id = @site_id ,
                product_type = @product_type ,
                enabled = @enabled ,
                modified = @modified ,
                uploaded_parent_product_id = @uploaded_parent_product_id ,
                is_temp_parent_product_id = @is_temp_parent_product_id ,
                child_product_on_db = @child_product_on_db ,
                child_product_on_excel = @child_product_on_excel ,
                product_compression_name = @product_compression_name ,
                product_compression_group = @product_compression_group
        WHERE   uploaded_product_id = @id    
    
    END 
GO

GRANT EXECUTE ON dbo.adminUploadedProduct_UpdateUploadedProduct TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		, group_title, expand_products, enabled, created, modified, is_default, product_id, product_count
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
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList
	@productCompressionGroupId int,
	@searchOptionIds varchar(max)
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	
	SELECT DISTINCT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList TO VpWebApp 
GO
---------------------------------------------------------------------------------
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
                show_detail_page
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
                product_id ,
                product_count
        FROM    ( SELECT    CAST(p.[value] AS INT) AS product_id ,
                            cp.product_compression_group_id ,
                            COUNT(*) product_count
                  FROM      product_to_product pp
                            INNER JOIN global_Split(@productIds, ',') AS p ON pp.parent_product_id = p.[value]
                            INNER JOIN product ON pp.product_id = product.product_id
                            INNER JOIN product_compression_group_to_product cp ON pp.product_id = cp.product_id
                  WHERE     ( product.flag1 & @countryFlag1 > 0 )
                            OR ( product.flag2 & @countryFlag2 > 0 )
                            OR ( product.flag3 & @countryFlag3 > 0 )
                            OR ( product.flag4 & @countryFlag4 > 0 )
                            AND product.enabled = 1
                  GROUP BY  p.[value] ,
                            cp.product_compression_group_id
                ) g
                INNER JOIN product_compression_group c ON g.product_compression_group_id = c.product_compression_group_id   
    END  
                
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList
    @productCompressionGroupId INT ,
    @productId INT ,
    @pageIndex INT ,
    @pageSize INT ,
    @siteId INT ,
    @totalRowCount INT OUTPUT
AS -- ==========================================================================  
-- Author : Dimuthu Perera $  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
   
        DECLARE @startIndex INT  
        DECLARE @endIndex INT  
        SET @startIndex = ( @pageSize * ( @pageIndex - 1 ) ) + 1  
        SET @endIndex = @pageSize * @pageIndex  
  
        SELECT  @totalRowCount = COUNT(*)
        FROM    product_compression_group_to_product proGro
                INNER JOIN dbo.product p ON proGro.product_id = p.product_id
        WHERE   ( @productCompressionGroupId IS NULL
                  OR product_compression_group_id = @productCompressionGroupId
                )
                AND ( @productId IS NULL
                      OR proGro.product_id = @productId
                    )
                AND p.site_id = @siteId;  
  
        WITH    temp_group_product ( row, id, product_compression_group_id, product_id, enabled, created, modified )
                  AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY proGro.product_compression_group_to_product_id ) AS row ,
                                proGro.product_compression_group_to_product_id AS id ,
                                proGro.product_compression_group_id ,
                                proGro.product_id ,
                                proGro.enabled ,
                                proGro.created ,
                                proGro.modified
                       FROM     product_compression_group_to_product proGro
                                INNER JOIN dbo.product p ON proGro.product_id = p.product_id
                       WHERE    ( @productCompressionGroupId IS NULL
                                  OR proGro.product_compression_group_id = @productCompressionGroupId
                                )
                                AND ( @productId IS NULL
                                      OR proGro.product_id = @productId
                                    )
                                AND p.site_id = @siteId
                     )
            SELECT  id ,
                    product_compression_group_id ,
                    product_id ,
                    enabled ,
                    created ,
                    modified
            FROM    temp_group_product
            WHERE   row BETWEEN @startIndex AND @endIndex
            ORDER BY row  
    
    END  
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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

---------------------------------------------------------------------------------------


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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified
	FROM [dbo].[product_compression_group]
	WHERE group_title like @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsList
	@productIds varchar(4000)
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT c.product_compression_group_id AS id, site_id, show_in_matrix, show_product_count 
		, group_title, expand_products, enabled, created, modified, product_id, product_count
	FROM
	(
	SELECT CAST(p.[value] AS int) AS product_id, cp.product_compression_group_id, COUNT(*) product_count 
	FROM product_to_product pp
		INNER JOIN global_Split(@productIds, ',') AS p
			ON pp.parent_product_id = p.[value]
		INNER JOIN product_compression_group_to_product cp
			ON pp.product_id = cp.product_id
	GROUP BY p.[value], cp.product_compression_group_id
	) g
	INNER JOIN product_compression_group c
		ON g.product_compression_group_id = c.product_compression_group_id	

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsList TO VpWebApp 
GO


------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList
	@parentProductId int,
	@compressionGroupId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SELECT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product		
		INNER JOIN product_compression_group_to_product cp
			ON product.product_id = cp.product_id
		INNER JOIN product_to_product pp
			ON product.product_id = pp.product_id
	WHERE cp.product_compression_group_id = @compressionGroupId AND pp.parent_product_id = @parentProductId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList TO VpWebApp 
GO


----------------------------------------------------

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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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

---------------------------------------------------------------------------------------


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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified
	FROM [dbo].[product_compression_group]
	WHERE group_title like @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO

--------------------------------------------------

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

	
	SELECT DISTINCT product.product_id AS id, site_id, parent_product_id, product_name, [rank], has_image, catalog_number, product.enabled,
		product.modified, product.created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		product.parent_product_id = @ParentProductId AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)
		AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO
---------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList'
----------------------------------------------
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
		proGro.site_id, proGro.enabled, proGro.created, proGro.modified
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
	FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupDetail TO VpWebApp 
GO

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
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroup TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroup
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroup TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupToProduct
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupToProduct TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupToProduct
	@id int,
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_to_product]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[product_id] = @productId
      ,[enabled] = @enabled 
      ,[modified] = @modified
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupToProduct TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_to_product_id] AS id
      ,[product_compression_group_id]
      ,[product_id]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupToProduct
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_to_product]
           ([product_compression_group_id]
           ,[product_id]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @productId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupToProduct TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupOrder
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder bit,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_order]
           ([product_compression_group_id]
           ,[content_type_id]
           ,[content_id]
           ,[sort_order]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @contentTypeId, @contentId, @sortOrder, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupOrder TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupOrderDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupOrderDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_order_id] AS id
      ,[product_compression_group_id]
      ,[content_type_id]
      ,[content_id]
      ,[sort_order]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupOrderDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupOrder
	@id int,
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_order]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[content_type_id] = @contentTypeId
      ,[content_id] = @contentId
      ,[sort_order] = @sortOrder
      ,[enabled] = @enabled
      ,[modified] = @modified
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupOrder TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupOrder
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupOrder TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options, CAST(1 AS bit) AS [enabled], GETDATE() AS modified, GETDATE() AS created
		FROM specification 
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
Go



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
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdList TO VpWebApp 
GO

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
		, created, modified, is_default) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY group_title) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified, is_default
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified, is_default
	FROM temp_product_compression_group 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeId int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT specification_id AS id, content_type_id, content_id, spec_type_id, specification, display_options, [enabled], modified, created
		FROM specification 		
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND spec_type_id = @selectedSpecTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationList TO VpWebApp 
Go


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetSKUSpecificationTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetSKUSpecificationTypeList
	@productIds varchar(max),
	@contentTypeId int,
	@selectedSpecTypeIds varchar(max)
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT specification_type.spec_type_id AS id, spec_type, validation_expression, specification_type.site_id, specification_type.[enabled], 
				specification_type.modified, specification_type.created, is_visible, search_enabled, is_expanded_view, display_empty
		FROM specification_type
	INNER JOIN specification 
		ON specification_type.spec_type_id = specification.spec_type_id
	WHERE specification.content_type_id=@contentTypeId 
		AND specification.content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
		AND specification.spec_type_id NOT IN (SELECT [value] FROM dbo.global_split(@selectedSpecTypeIds, ','))

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetSKUSpecificationTypeList TO VpWebApp 
Go


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList
    @productCompressionGroupId INT ,
    @productId INT ,
    @pageIndex INT ,
    @pageSize INT ,
    @siteId INT ,
    @totalRowCount INT OUTPUT
AS -- ==========================================================================  
-- Author : Dimuthu Perera $  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
   
        DECLARE @startIndex INT  
        DECLARE @endIndex INT  
        SET @startIndex = ( @pageSize * ( @pageIndex - 1 ) ) + 1  
        SET @endIndex = @pageSize * @pageIndex  
  
        SELECT  @totalRowCount = COUNT(*)
        FROM    product_compression_group_to_product proGro
                INNER JOIN dbo.product p ON proGro.product_id = p.product_id
        WHERE   ( @productCompressionGroupId IS NULL
                  OR product_compression_group_id = @productCompressionGroupId
                )
                AND ( @productId IS NULL
                      OR proGro.product_id = @productId
                    )
                AND p.site_id = @siteId;  
  
        WITH    temp_group_product ( row, id, product_compression_group_id, product_id, enabled, created, modified )
                  AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY proGro.product_compression_group_to_product_id ) AS row ,
                                proGro.product_compression_group_to_product_id AS id ,
                                proGro.product_compression_group_id ,
                                proGro.product_id ,
                                proGro.enabled ,
                                proGro.created ,
                                proGro.modified
                       FROM     product_compression_group_to_product proGro
                                INNER JOIN dbo.product p ON proGro.product_id = p.product_id
                       WHERE    ( @productCompressionGroupId IS NULL
                                  OR proGro.product_compression_group_id = @productCompressionGroupId
                                )
                                AND ( @productId IS NULL
                                      OR proGro.product_id = @productId
                                    )
                                AND p.site_id = @siteId
                     )
            SELECT  id ,
                    product_compression_group_id ,
                    product_id ,
                    enabled ,
                    created ,
                    modified
            FROM    temp_group_product
            WHERE   row BETWEEN @startIndex AND @endIndex
            ORDER BY row  
    
    END  
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroup
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
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
		   ,[is_default])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created, @isDefault)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options, CAST(1 AS bit) AS [enabled], GETDATE() AS modified, GETDATE() AS created
		FROM specification 
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
Go



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
		 , show_in_matrix, show_detail_page
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
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		business_value,ignore_in_rapid, show_in_matrix, show_detail_page 
)
	AS
	(
		SELECT  product_id, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified,
			created, product_type, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page
		FROM product
		WHERE enabled = 1 AND site_id = @siteId
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status,
		has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		show_in_matrix, show_detail_page

	FROM selectedProduct
	WHERE row_id BETWEEN @startIndex AND @endIndex
	ORDER BY row_id
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList TO VpWebApp
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

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
	@showDetailPage bit
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO product(site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page) 
	VALUES (@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @created, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @ignoreInRapid, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue, @showInMatrix, @showDetailPage) 

	SET @id = SCOPE_IDENTITY() 

END

GO

GRANT EXECUTE ON dbo.adminProduct_AddProduct TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroup
	@showInMatrix bit,
	@showProductCount bit,
	@expandProducts bit,
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
		   ,[is_default])
    VALUES
           (@showInMatrix, @showProductCount, @groupTitle, @expandProducts, @siteId, @enabled, @created, @created, @isDefault)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroup TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupOrder
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder bit,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_order]
           ([product_compression_group_id]
           ,[content_type_id]
           ,[content_id]
           ,[sort_order]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @contentTypeId, @contentId, @sortOrder, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupOrder TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupToProduct
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_to_product]
           ([product_compression_group_id]
           ,[product_id]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @productId, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupToProduct TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductToDefaultCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductToDefaultCompressionGroup
	@productID int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF ((select count(product_compression_group_id) from [product_compression_group_to_product] where product_id = @productID)=0)
	BEGIN
		DECLARE @defaultGroupID int
		DECLARE @enabled bit
		DECLARE @created smalldatetime
		
		SET @enabled = 1
		SET @created = GETDATE()
		SET @defaultGroupID = (SELECT product_compression_group_id 
								FROM product_compression_group 
								WHERE is_default = 1 and site_id = (
									SELECT site_id 
									FROM product 
									WHERE product_id = @productID))
		
		INSERT INTO [product_compression_group_to_product]
           ([product_compression_group_id]
           ,[product_id]
           ,[enabled]
           ,[created]
           ,[modified])
		VALUES
           (@defaultGroupID
           ,@productID
           ,@enabled
           ,@created
           ,@created)
	END
END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductToDefaultCompressionGroup TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteCompressionGroupBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteCompressionGroupBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

		DELETE FROM product_compression_group
		WHERE site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteCompressionGroupBySiteIdList TO VpWebApp 
GO




-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteCompressionGroupToProductBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteCompressionGroupToProductBySiteIdList
	@siteId int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

		DELETE FROM product_compression_group_to_product 
		WHERE product_compression_group_id IN
		(
				SELECT groPro.product_compression_group_id
				FROM product_compression_group_to_product groPro
					INNER JOIN product_compression_group gro
						ON gro.product_compression_group_id = groPro.product_compression_group_id
				WHERE gro.site_id = @siteId
		)

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteCompressionGroupToProductBySiteIdList TO VpWebApp 
GO




-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroup
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroup TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupOrder
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupOrder TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductCompressionGroupToProduct
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductCompressionGroupToProduct TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductFromCompressionGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductFromCompressionGroup
	@productID int
	,@compressionGroupID int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM product_compression_group_to_product 
	WHERE product_compression_group_id = @compressionGroupID and product_id = @productID

END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductFromCompressionGroup TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryByProductIdList
	@productId int
AS
-- ==========================================================================
-- $Archive: /Documents/Templates/moduleName_StoredProcedureName.sql $
-- $Revision: 2 $
-- $Date: 3/14/08 3:43p $ 
-- $Author: Dherbst $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id
	FROM category AS cat 
		INNER JOIN product_to_category AS prodCat
			ON prodCat.product_id = @productId AND cat.category_id = prodCat.category_id

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryByProductIdList TO VpWebApp
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryByProductIdsList
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image
	FROM category AS cat
	WHERE category_id
		IN (SELECT DISTINCT category_id FROM product_to_category prodCat
				WHERE prodCat.product_id IN (SELECT [value] FROM Global_Split(@productIds, ',')))

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryByProductIdsList TO VpWebApp
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
			, pro.show_in_matrix, pro.show_detail_page

	FROM product_to_category catPro
		INNER JOIN product pro
			ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @categoryId AND pro.[enabled] = 1

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetEnabledProductByCategoryIdList TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

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
			, pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page

	FROM product_to_category catPro
			INNER JOIN product pro
				ON catPro.product_id = pro.product_id
	WHERE catPro.category_id = @categoryId AND pro.product_type = 3


END
GO

GRANT EXECUTE ON dbo.adminProduct_GetGenericProductByCategoryIdDetail TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
				pro.show_in_matrix, pro.show_detail_page

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
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
				pro.show_in_matrix, pro.show_detail_page

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

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
				pro.search_rank, pro.search_content_modified, pro.hidden, pro.business_value, pro.ignore_in_rapid, pro.show_in_matrix, pro.show_detail_page

	FROM product pro
	INNER JOIN search_content_status scs
		ON scs.content_type_id = 2 AND scs.content_id = pro.product_id 
			AND scs.site_id = @siteId AND pro.enabled = 1 AND pro.modified > scs.modified
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetIndexedProductsWithModifiedProduct TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		pro.show_in_matrix, pro.show_detail_page

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
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		p.show_in_matrix, p.show_detail_page

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



-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
				pro.show_in_matrix, pro.show_detail_page

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
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		, created, modified, is_default) AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY group_title) AS row, product_compression_group_id AS id, show_in_matrix, show_product_count
			, group_title , expand_products , site_id, enabled, created, modified, is_default
		FROM product_compression_group
		WHERE site_id = @siteId
	)

	SELECT id, show_in_matrix, show_product_count, group_title , expand_products , site_id, enabled, created, modified, is_default
	FROM temp_product_compression_group 
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdPageList TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified, is_default
	FROM [dbo].[product_compression_group]
	WHERE group_title like @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
	FROM [product_compression_group] gro
		INNER JOIN product_compression_group_to_product groPro
			ON gro.product_compression_group_id = groPro.product_compression_group_id
	WHERE groPro.product_id = @productID

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsByProductID TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
                is_default
        FROM    dbo.product_compression_group
        WHERE   site_id = @siteId

    END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupsBySiteId TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductCompressionGroupToProduct
	@groupProductID int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [product_compression_group_to_product_id] AS id
      ,[product_compression_group_id]
      ,[product_id]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [product_compression_group_to_product]
	WHERE [product_compression_group_to_product_id] = @groupProductID

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupToProduct TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
				, show_in_matrix, show_detail_page
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
				, show_in_matrix, show_detail_page
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
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroup TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupOrder
	@id int,
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_order]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[content_type_id] = @contentTypeId
      ,[content_id] = @contentId
      ,[sort_order] = @sortOrder
      ,[enabled] = @enabled
      ,[modified] = @modified
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupOrder TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupToProduct
	@id int,
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_to_product]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[product_id] = @productId
      ,[enabled] = @enabled 
      ,[modified] = @modified
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupToProduct TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_AddUploadedProduct'

set ANSI_NULLS ON
GO
set QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_AddUploadedProduct]
    @id INT OUTPUT ,
    @batch_id VARCHAR(75) ,
    @temp_product_id INT ,
    @vendor_id INT ,
    @item_name VARCHAR(255) ,
    @catalog_number VARCHAR(255) ,
    @product_type INT ,
    @price MONEY ,
    @url VARCHAR(250) ,
    @file_Name VARCHAR(255) ,
    @site_id INT ,
    @enabled BIT ,
    @created SMALLDATETIME OUTPUT ,
    @uploaded_parent_product_id INT ,
    @is_temp_parent_product_id BIT ,
    @child_product_on_db VARCHAR(MAX) ,
    @child_product_on_excel VARCHAR(MAX) ,
    @product_compression_name VARCHAR(255) ,
    @product_compression_group VARCHAR(255)
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================  
    BEGIN    
     
        SET NOCOUNT ON;    
    
        SET @created = GETDATE()    
    
        INSERT  INTO uploaded_product
                ( batch_id ,
                  temp_product_id ,
                  vendor_id ,
                  item_name ,
                  catalog_number ,
                  price ,
                  url ,
                  uploaded_file_name ,
                  site_id ,
                  product_type ,
                  enabled ,
                  modified ,
                  created ,
                  uploaded_parent_product_id ,
                  is_temp_parent_product_id ,
                  child_product_on_db ,
                  child_product_on_excel ,
                  product_compression_name ,
                  product_compression_group
                )
        VALUES  ( @batch_id ,
                  @temp_product_id ,
                  @vendor_id ,
                  @item_name ,
                  @catalog_number ,
                  @price ,
                  @url ,
                  @file_name ,
                  @site_id ,
                  @product_type ,
                  @enabled ,
                  @created ,
                  @created ,
                  @uploaded_parent_product_id ,
                  @is_temp_parent_product_id ,
                  @child_product_on_db ,
                  @child_product_on_excel ,
                  @product_compression_name ,
                  @product_compression_group
                )    
    
        SET @id = SCOPE_IDENTITY()    
    END    
GO
GRANT EXECUTE ON dbo.adminUploadedProduct_AddUploadedProduct TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_GetUploadedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_GetUploadedProduct] @id INT
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================   
    BEGIN    
     
        SET NOCOUNT ON    
    
        SELECT  uploaded_product_id AS id ,
                batch_id AS batch_id ,
                temp_product_id AS temp_product_id ,
                vendor_id AS vendor_id ,
                item_name AS item_name ,
                catalog_number AS catalog_number ,
                price AS price ,
                url AS url ,
                uploaded_file_name AS uploaded_file_name ,
                site_id AS site_id ,
                product_type AS product_type ,
                [enabled] AS [enabled] ,
                modified AS modified ,
                created AS created ,
                uploaded_parent_product_id AS uploaded_parent_product_id ,
                is_temp_parent_product_id AS is_temp_parent_product_id ,
                child_product_on_db AS child_product_on_db ,
                child_product_on_excel AS child_product_on_excel ,
                product_compression_name AS product_compression_name ,
                product_compression_group AS product_compression_group
        FROM    uploaded_product
        WHERE   uploaded_product_id = @id 
     
    END 
GO
GRANT EXECUTE ON dbo.adminUploadedProduct_GetUploadedProduct TO VpWebApp 
Go



-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_GetUploadedProductList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_GetUploadedProductList] @SiteId AS
    INT
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================  
    BEGIN    
     
        SET NOCOUNT ON    
    
        SELECT  uploaded_product_id AS id ,
                batch_id AS batch_id ,
                temp_product_id AS temp_product_id ,
                vendor_id AS vendor_id ,
                item_name AS item_name ,
                catalog_number AS catalog_number ,
                price AS price ,
                url AS url ,
                uploaded_file_name AS uploaded_file_name ,
                site_id AS site_id ,
                product_type AS product_type ,
                [enabled] AS [enabled] ,
                modified AS modified ,
                created AS created ,
                uploaded_parent_product_id AS uploaded_parent_product_id ,
                is_temp_parent_product_id AS is_temp_parent_product_id ,
                child_product_on_db AS child_product_on_db ,
                child_product_on_excel AS child_product_on_excel ,
                product_compression_name AS product_compression_name ,
                product_compression_group AS product_compression_group
        FROM    uploaded_product
        WHERE   site_id = @SiteId    
    END 
GO
GRANT EXECUTE ON dbo.adminUploadedProduct_GetUploadedProductList TO VpWebApp 
Go



-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_GetUploadedProductListByBatchId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_GetUploadedProductListByBatchId] @batchId AS
    VARCHAR(75)
AS 
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================  
    BEGIN   
     
        SET NOCOUNT ON    
    
        SELECT  uploaded_product_id AS id ,
                batch_id AS batch_id ,
                temp_product_id AS temp_product_id ,
                vendor_id AS vendor_id ,
                item_name AS item_name ,
                catalog_number AS catalog_number ,
                price AS price ,
                url AS url ,
                uploaded_file_name AS uploaded_file_name ,
                site_id AS site_id ,
                product_type AS product_type ,
                [enabled] AS [enabled] ,
                modified AS modified ,
                created AS created ,
                uploaded_parent_product_id AS uploaded_parent_product_id ,
                is_temp_parent_product_id AS is_temp_parent_product_id ,
                child_product_on_db AS child_product_on_db ,
                child_product_on_excel AS child_product_on_excel ,
                product_compression_name AS product_compression_name ,
                product_compression_group AS product_compression_group
        FROM    uploaded_product
        WHERE   batch_id = @batchId;    
    END 
GO
GRANT EXECUTE ON dbo.adminUploadedProduct_GetUploadedProductListByBatchId TO VpWebApp 
Go
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

EXEC dbo.global_DropStoredProcedure 'adminUploadedProduct_UpdateUploadedProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminUploadedProduct_UpdateUploadedProduct]    
 @id int,    
 @batch_id varchar(75),    
 @temp_product_id int,    
 @vendor_id int,    
 @item_name varchar(255),    
 @catalog_number varchar(255),    
 @product_type int,    
 @price money,    
 @url varchar(250),    
 @file_Name varchar(255),    
 @site_id int,    
 @enabled bit,    
 @modified smalldatetime output,    
 @uploaded_parent_product_id int,    
 @is_temp_parent_product_id bit,    
 @child_product_on_db varchar(MAX),    
 @child_product_on_excel varchar(MAX),  
 @product_compression_name varchar(255),
 @product_compression_group varchar(255)
     
AS    
-- ==========================================================================    
-- $Author: Dimuthu $    
-- ==========================================================================    
BEGIN    
     
 SET NOCOUNT ON;    
     
 SET @modified = GETDATE()    
    
 UPDATE uploaded_product    
 SET batch_id = @batch_id,    
  temp_product_id = @temp_product_id,    
  vendor_id = @vendor_id,    
  item_name = @item_name,    
  catalog_number = @catalog_number,    
  price = @price,    
  url = @url,    
  uploaded_file_name = @file_Name,    
  site_id = @site_id,    
  product_type = @product_type,    
  enabled = @enabled,    
  modified = @modified,    
  uploaded_parent_product_id = @uploaded_parent_product_id,    
  is_temp_parent_product_id = @is_temp_parent_product_id,    
  child_product_on_db = @child_product_on_db,    
  child_product_on_excel = @child_product_on_excel,   
  product_compression_name =  @product_compression_name,  
  product_compression_group = @product_compression_group
    
 WHERE uploaded_product_id = @id    
    
END 
GO

GRANT EXECUTE ON dbo.adminUploadedProduct_UpdateUploadedProduct TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id
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
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCommonSpecificationDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCommonSpecificationDetail
	@productIds varchar(max),
	@contentTypeId int,
	@productCount int
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT 0 AS id, 2 AS content_type_id, 0 AS content_id, spec_type_id, specification, 7 AS display_options, CAST(1 AS bit) AS [enabled], GETDATE() AS modified, GETDATE() AS created
		FROM specification 
	WHERE content_type_id=@contentTypeId 
		AND content_id IN (SELECT [value] FROM dbo.global_split(@productIds, ','))
	GROUP BY spec_type_id, specification 
	HAVING COUNT(specification) = @productCount

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCommonSpecificationDetail TO VpWebApp 
Go



-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetMissingProductByCategoryIdCount'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetMissingProductByCategoryIdCount
	@categoryId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@productIds varchar(MAX),
	@filterVendorIds varchar(MAX)
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT COUNT(p.product_id)
	FROM product p
		INNER JOIN product_to_category ptc
			ON p.product_id = ptc.product_id
		INNER JOIN product_to_vendor ptv
			ON p.product_id = ptv.product_id 
				AND ptv.is_manufacturer = 1
		INNER JOIN vendor v
			ON ptv.vendor_id = v.vendor_id
	WHERE ptc.category_id = @categoryId 
		AND p.enabled = 1
		AND p.show_in_matrix = 1
		AND ptc.enabled = 1
		AND v.enabled = 1 
		AND	p.product_id NOT IN 
		(
			SELECT [value] FROM dbo.global_Split(@productIds, ',')
		)
		AND
		(
			@filterVendorIds IS NULL	
			OR DATALENGTH(@filterVendorIds) = 0
			OR	(
					DATALENGTH(@filterVendorIds) > 0 
					AND
					(
						ISNULL(v.parent_vendor_id, v.vendor_id) 
						IN (
								SELECT [value] FROM global_Split(@filterVendorIds, ',')
						   )
					)
				) 
		)
		AND
		(
			(p.flag1 & @countryFlag1 > 0) OR (p.flag2 & @countryFlag2 > 0) OR 
			(p.flag3 & @countryFlag3 > 0) OR (p.flag4 & @countryFlag4 > 0)
		)
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetMissingProductByCategoryIdCount TO VpWebApp 
GO
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		, business_value int, ignore_in_rapid bit, show_in_matrix bit, show_detail_page bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, show_in_matrix bit, show_detail_page bit, parent_vendor_id int)

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
		, show_in_matrix, show_detail_page
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END

GO

GRANT EXECUTE ON dbo.publicProduct_GetMissingProductByCategoryIdPageList TO VpWebApp
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
                show_detail_page
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
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdList TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList
	@productCompressionGroupId int,
	@searchOptionIds varchar(max)
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	
	SELECT DISTINCT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList TO VpWebApp 
GO
---------------------------------------------------------------------------------
-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsList
	@productIds varchar(4000)
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT c.product_compression_group_id AS id, site_id, show_in_matrix, show_product_count 
		, group_title, expand_products, enabled, created, modified, product_id, product_count
	FROM
	(
	SELECT CAST(p.[value] AS int) AS product_id, cp.product_compression_group_id, COUNT(*) product_count 
	FROM product_to_product pp
		INNER JOIN global_Split(@productIds, ',') AS p
			ON pp.parent_product_id = p.[value]
		INNER JOIN product_compression_group_to_product cp
			ON pp.product_id = cp.product_id
	GROUP BY p.[value], cp.product_compression_group_id
	) g
	INNER JOIN product_compression_group c
		ON g.product_compression_group_id = c.product_compression_group_id	

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsList TO VpWebApp 
GO


------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList
	@parentProductId int,
	@compressionGroupId int
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SELECT product.product_id AS id, site_id, product_name, [rank], has_image, catalog_number, product.enabled, 
		product.modified, product.created, product_type, status, has_model, has_related, flag1, flag2, flag3, flag4, 
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product		
		INNER JOIN product_compression_group_to_product cp
			ON product.product_id = cp.product_id
		INNER JOIN product_to_product pp
			ON product.product_id = pp.product_id
	WHERE cp.product_compression_group_id = @compressionGroupId AND pp.parent_product_id = @parentProductId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdList TO VpWebApp 
GO


----------------------------------------------------

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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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
				, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value
				, show_in_matrix, show_detail_page
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

---------------------------------------------------------------------------------------


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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified
	FROM [dbo].[product_compression_group]
	WHERE group_title like @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO

--------------------------------------------------

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

	
	SELECT DISTINCT product.product_id AS id, site_id, parent_product_id, product_name, [rank], has_image, catalog_number, product.enabled,
		product.modified, product.created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		product.parent_product_id = @ParentProductId AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)
		AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO
---------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByProductCompressionGroupIdSearchOptionIdsList'
----------------------------------------------
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
		proGro.site_id, proGro.enabled, proGro.created, proGro.modified
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
----------------------------------------------------------------



-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
                product_id ,
                product_count
        FROM    ( SELECT    CAST(p.[value] AS INT) AS product_id ,
                            cp.product_compression_group_id ,
                            COUNT(*) product_count
                  FROM      product_to_product pp
                            INNER JOIN global_Split(@productIds, ',') AS p ON pp.parent_product_id = p.[value]
                            INNER JOIN product ON pp.product_id = product.product_id
                            INNER JOIN product_compression_group_to_product cp ON pp.product_id = cp.product_id
                  WHERE     ( product.flag1 & @countryFlag1 > 0 )
                            OR ( product.flag2 & @countryFlag2 > 0 )
                            OR ( product.flag3 & @countryFlag3 > 0 )
                            OR ( product.flag4 & @countryFlag4 > 0 )
                            AND product.enabled = 1
                  GROUP BY  p.[value] ,
                            cp.product_compression_group_id
                ) g
                INNER JOIN product_compression_group c ON g.product_compression_group_id = c.product_compression_group_id   
    END  
                
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsList TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
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
	FROM [dbo].[product_compression_group]
	WHERE product_compression_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupDetail TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupOrderDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupOrderDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_order_id] AS id
      ,[product_compression_group_id]
      ,[content_type_id]
      ,[content_id]
      ,[sort_order]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_order]
	WHERE product_compression_group_order_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupOrderDetail TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList
    @productCompressionGroupId INT ,
    @productId INT ,
    @pageIndex INT ,
    @pageSize INT ,
    @siteId INT ,
    @totalRowCount INT OUTPUT
AS -- ==========================================================================  
-- Author : Dimuthu Perera $  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
   
        DECLARE @startIndex INT  
        DECLARE @endIndex INT  
        SET @startIndex = ( @pageSize * ( @pageIndex - 1 ) ) + 1  
        SET @endIndex = @pageSize * @pageIndex  
  
        SELECT  @totalRowCount = COUNT(*)
        FROM    product_compression_group_to_product proGro
                INNER JOIN dbo.product p ON proGro.product_id = p.product_id
        WHERE   ( @productCompressionGroupId IS NULL
                  OR product_compression_group_id = @productCompressionGroupId
                )
                AND ( @productId IS NULL
                      OR proGro.product_id = @productId
                    )
                AND p.site_id = @siteId;  
  
        WITH    temp_group_product ( row, id, product_compression_group_id, product_id, enabled, created, modified )
                  AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY proGro.product_compression_group_to_product_id ) AS row ,
                                proGro.product_compression_group_to_product_id AS id ,
                                proGro.product_compression_group_id ,
                                proGro.product_id ,
                                proGro.enabled ,
                                proGro.created ,
                                proGro.modified
                       FROM     product_compression_group_to_product proGro
                                INNER JOIN dbo.product p ON proGro.product_id = p.product_id
                       WHERE    ( @productCompressionGroupId IS NULL
                                  OR proGro.product_compression_group_id = @productCompressionGroupId
                                )
                                AND ( @productId IS NULL
                                      OR proGro.product_id = @productId
                                    )
                                AND p.site_id = @siteId
                     )
            SELECT  id ,
                    product_compression_group_id ,
                    product_id ,
                    enabled ,
                    created ,
                    modified
            FROM    temp_group_product
            WHERE   row BETWEEN @startIndex AND @endIndex
            ORDER BY row  
    
    END  
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductByProductCompressionGroupIdProductIdWithPagingList TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupToProductDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupToProductDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [product_compression_group_to_product_id] AS id
      ,[product_compression_group_id]
      ,[product_id]
      ,[enabled]
      ,[created]
      ,[modified]
	FROM [dbo].[product_compression_group_to_product]
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupToProductDetail TO VpWebApp 
GO

-- ===============================================================
--                                                                
--                                                                
-- ===============================================================

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
	@showDetailPage bit
	
AS
-- ==========================================================================
-- Author : Dhanushka
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO product(site_id, product_name, [rank], has_image, catalog_number, [enabled]
		, modified, created, product_type, status, has_related, has_model,  completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden
		, business_value, ignore_in_rapid, show_in_matrix, show_detail_page) 
	VALUES (@siteId, @productName, @rank, @hasImage, @catalogNumber, @enabled
		, @created, @created, @productType, @status, @hasRelated, @hasModel, @completeness, @flag1, @flag2, @flag3, @flag4, @searchRank, @searchContentModified, @hidden
		, @businessValue,@ignoreInRapid, @showInMatrix, @showDetailPage) 

	SET @id = SCOPE_IDENTITY() 

END

GO

GRANT EXECUTE ON dbo.adminProduct_AddProduct TO VpWebApp 
GO

--


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategoryByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategoryByProductIdsList
	@productIds varchar(max)
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cat.category_id AS id, cat.site_id, cat.category_name, cat.category_type_id
		, cat.description, cat.short_name, cat.specification, cat.is_search_category 
		, cat.is_displayed, cat.enabled, cat.modified, cat.created, matrix_type, product_count, auto_generated
		, hidden, has_image, url_id
	FROM category AS cat
	WHERE category_id
		IN (SELECT DISTINCT category_id FROM product_to_category prodCat
				WHERE prodCat.product_id IN (SELECT [value] FROM Global_Split(@productIds, ',')))

END
GO

GRANT EXECUTE ON adminProduct_GetCategoryByProductIdsList TO VpWebApp
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateCategorySearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateCategorySearchGroup
	@id int,
	@categoryId int,
	@searchGroupId int,
	@sortOrder int,
	@searchable bit,
	@enabled bit,	
	@matrixPrefix varchar(100),
	@matrixSuffix varchar(100),
	@includeAllOptions bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE [category_to_search_group]
	SET
		[category_id] = @categoryId,
		[search_group_id] = @searchGroupId,
		[sort_order] = @sortOrder,
		[searchable] = @searchable,
		[matrix_prefix] = @matrixPrefix,
		[matrix_suffix] = @matrixSuffix,
		[enabled] = @enabled,
		[modified] = @modified,
		[include_all_options] = @includeAllOptions
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateCategorySearchGroup TO VpWebApp 
GO

----

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix],[created], [enabled], [modified], [include_all_options]
	FROM category_to_search_group
	WHERE [category_to_search_group_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupDetail TO VpWebApp 
GO

------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList
	@categoryId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [category_to_search_group_id] AS id, [category_id], [search_group_id], [sort_order], [searchable],
		[matrix_prefix], [matrix_suffix], [include_all_options], [created], [enabled], [modified]
	FROM category_to_search_group
	WHERE [category_id] = @categoryId

	SELECT @totalCount = COUNT(*)
    FROM category_to_search_group
	WHERE category_id = @categoryId 
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetCategorySearchGroupsByCategoryIdList TO VpWebApp 
GO

---

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
      ,site_id , show_in_matrix , show_product_count ,group_title, expand_products, [enabled], created, modified, is_default
	FROM [dbo].[product_compression_group]
	WHERE group_title like @searchText +'%' AND site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductCompressionGroupBySiteIdSearchTextList TO VpWebApp 
GO

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
		proGro.site_id, proGro.enabled, proGro.created, proGro.modified, proGro.is_default
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
 

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByChildProductIdList'
GO
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
		completeness, search_rank, search_content_modified, hidden, business_value, show_in_matrix, show_detail_page,ignore_in_rapid
	FROM product 
		INNER JOIN product_to_product AS association
			ON product.product_id = association.parent_product_id
	WHERE association.product_id = @productId
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByChildProductIdList TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetSpecificationsNotInParent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetSpecificationsNotInParent
    @parentProductId INT ,
    @contentTypeId INT,
    @productIds VARCHAR(MAX)
 AS -- ==========================================================================  
-- $Author: dimuthu $  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
  
        SELECT  specification_id AS id ,
                content_id ,
                specification.spec_type_id ,
                specification ,
                display_options ,
                specification.enabled ,
                specification.modified ,
                specification.created ,
                content_type_id
        FROM    specification
        WHERE   content_type_id = @contentTypeId
                AND content_id IN (
                SELECT  product_id
                FROM    dbo.product_to_product
                WHERE   parent_product_id = @parentProductId )
                AND specification NOT IN (
                SELECT  specification
                FROM    dbo.specification
                WHERE   content_type_id = @contentTypeId
                        AND content_id = @parentProductId )
  
    END  
    
GO

GRANT EXECUTE ON dbo.publicProduct_GetSpecificationsNotInParent TO VpWebApp 
GO
 
-----

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
				ignore_in_rapid
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

-----

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupOrder'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductCompressionGroupOrder
	@productCompressionGroupId int,
	@contentTypeId int,
	@contentId int,
	@sortOrder int,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO [dbo].[product_compression_group_order]
           ([product_compression_group_id]
           ,[content_type_id]
           ,[content_id]
           ,[sort_order]
           ,[enabled]
           ,[created]
           ,[modified])
    VALUES
           (@productCompressionGroupId, @contentTypeId, @contentId, @sortOrder, @enabled, @created, @created)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductCompressionGroupOrder TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupToProduct'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCompressionGroupToProduct
	@id int,
	@productCompressionGroupId int,
	@productId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE [dbo].[product_compression_group_to_product]
	SET [product_compression_group_id] = @productCompressionGroupId
      ,[product_id] = @productId
      ,[enabled] = @enabled 
      ,[modified] = @modified
	WHERE product_compression_group_to_product_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCompressionGroupToProduct TO VpWebApp 
GO

------
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
		ignore_in_rapid
	FROM product
	INNER JOIN product_compression_group_to_product proGro
		ON product.product_id = proGro.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByProductCompressionGroupIdList TO VpWebApp 
GO

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
		, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid,show_in_matrix, show_detail_page
	FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY p.product_id ASC) AS row, p.product_id as id, p.site_id, p.product_Name, p.rank
			, p.has_image, p.catalog_number, p.enabled, p.modified, p.created, p.product_type, p.[status]
			, p.has_related, p.has_model, p.completeness, p.flag1, p.flag2, p.flag3, p.flag4, p.search_rank, p.search_content_modified, p.hidden, p.business_value,p.ignore_in_rapid,p.show_in_matrix, p.show_detail_page
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
		business_value,ignore_in_rapid, show_in_matrix, show_detail_page 
)
	AS
	(
		SELECT  product_id, ROW_NUMBER() OVER (ORDER BY product_id) AS row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified,
			created, product_type, status, has_related, has_model, completeness, flag1,flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
			, show_in_matrix, show_detail_page
		FROM product
		WHERE enabled = 1 AND site_id = @siteId
	)

	SELECT id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status,
		has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid
		show_in_matrix, show_detail_page

	FROM selectedProduct
	WHERE row_id BETWEEN @startIndex AND @endIndex
	ORDER BY row_id
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList TO VpWebApp
GO
-----
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList'
GO

CREATE PROCEDURE dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList
    @siteId INT ,
    @startIndex INT ,
    @endIndex INT
AS -- ==========================================================================  
-- Author : Dilshan  
-- ==========================================================================  
    BEGIN  
        SET NOCOUNT ON;  
  
        WITH    selectedProduct ( id, row_id, site_id, product_Name, [rank], has_image, catalog_number, [enabled], modified, created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page )
                  AS ( SELECT   product_id ,
                                ROW_NUMBER() OVER ( ORDER BY product_id ) AS row_id ,
                                site_id ,
                                product_Name ,
                                [rank] ,
                                has_image ,
                                catalog_number ,
                                [enabled] ,
                                modified ,
                                created ,
                                product_type ,
                                status ,
                                has_related ,
                                has_model ,
                                completeness ,
                                flag1 ,
                                flag2 ,
                                flag3 ,
                                flag4 ,
                                search_rank ,
                                search_content_modified ,
                                hidden ,
                                business_value ,
                                ignore_in_rapid ,
                                show_in_matrix ,
                                show_detail_page
                       FROM     product
                       WHERE    enabled = 1
                                AND site_id = @siteId
                     )
            SELECT                     id ,
                    site_id ,
                    product_Name ,
                    [rank] ,
                    has_image ,
                    catalog_number ,
                    [enabled] ,
                    modified ,
                    created ,
                    product_type ,
                    status ,
                    has_related ,
                    has_model ,
                    completeness ,
                    flag1 ,
                    flag2 ,
                    flag3 ,
                    flag4 ,
                    search_rank ,
                    search_content_modified ,
                    hidden ,
                    business_value ,
                    ignore_in_rapid,
                     show_in_matrix ,
                    show_detail_page
            FROM    selectedProduct
            WHERE   row_id BETWEEN @startIndex AND @endIndex
            ORDER BY row_id  
    END  
 GO   
    GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedProductsBySiteIdWithPagingList TO VpWebApp
GO



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
				, show_in_matrix, show_detail_page
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
				, show_in_matrix, show_detail_page
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
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page, ignore_in_rapid
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id
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
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ',')))

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO