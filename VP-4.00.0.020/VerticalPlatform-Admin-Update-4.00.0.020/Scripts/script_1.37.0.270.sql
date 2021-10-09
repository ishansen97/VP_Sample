IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'locked' AND id = (SELECT object_id FROM sys.objects WHERE object_id = OBJECT_ID(N'search_group') AND type in (N'U'))
)
BEGIN
ALTER TABLE search_group ADD locked bit NOT NULL DEFAULT 0
END
GO

-------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'locked' AND id = (SELECT object_id FROM sys.objects WHERE object_id = OBJECT_ID(N'product_to_search_option') AND type in (N'U'))
)
BEGIN
ALTER TABLE product_to_search_option ADD locked bit NOT NULL DEFAULT 0
END
GO

------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetProductSearchOptionDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetProductSearchOptionDetail
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [product_to_search_option_id] AS id, [product_id], [search_option_id], locked, [created], [enabled], [modified]
	FROM product_to_search_option
	WHERE [product_to_search_option_id] = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionDetail TO VpWebApp 
GO

-------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId
	@contentType int,
	@contentId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	SET ARITHABORT ON;

	IF @contentType = 1
		BEGIN
			SELECT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
				  ,sg.[enabled],sg.[created],sg.[modified],sg.[add_options_automatically],sg.[prefix_text]
				  ,sg.[suffix_text], sg.search_enabled, sg.locked
			FROM [search_group] sg
			WHERE sg.search_group_id IN (
				SELECT so.search_group_id
				FROM search_option so
					INNER JOIN product_to_search_option ptso
						ON so.search_option_id = ptso.search_option_id
					INNER JOIN product_to_category pc 
						ON ptso.product_id = pc.product_id
				WHERE pc.category_id =  @contentId
			)
		END
	ELSE IF @contentType = 6
		BEGIN
			SELECT sg.[search_group_id] AS [id],sg.[site_id],sg.[parent_search_group_id],sg.[name],sg.[description]
				  ,sg.[enabled],sg.[created],sg.[modified],sg.[add_options_automatically],sg.[prefix_text]
				  ,sg.[suffix_text], sg.search_enabled, sg.locked
			FROM [search_group] sg
			WHERE sg.search_group_id IN (
				SELECT so.search_group_id
				FROM search_option so
					INNER JOIN product_to_search_option ptso
						ON ptso.search_option_id = so.search_option_id
					INNER JOIN product_to_vendor ptv
						ON ptv.product_id = ptso.product_id
					WHERE ptv.vendor_id = @contentId
			)
		END
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductSearchGroupsByContentTypeContentId TO VpWebApp
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_GetSearchGroupsByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_GetSearchGroupsByCategoryIdList  
 @categoryIdList varchar(4000)  
AS  
-- ==========================================================================  
-- $ Author : Dimuthu Perera $  
-- ==========================================================================  
BEGIN  
  
 SET NOCOUNT ON;  
  
 SELECT sg.[search_group_id] AS id, sg.[site_id], sg.[parent_search_group_id], sg.[name],  
  sg.[description], sg.add_options_automatically, sg.prefix_text, sg.suffix_text, sg.search_enabled,
  sg.locked, sg.[created], sg.[enabled], sg.[modified]  
 FROM search_group sg  
  INNER JOIN dbo.category_to_search_group csg  
   ON sg.search_group_id = csg.search_group_id  
 WHERE csg.category_id IN (SELECT [value] FROM [global_Split](@categoryIdList, ','))
   
 ORDER BY csg.sort_order, sg.[name]  
END  
GO

GRANT EXECUTE ON dbo.adminSearchCategory_GetSearchGroupsByCategoryIdList TO VpWebApp 
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchGroupsByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchGroupsByCategoryId
	@categoryId int
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT sg.[search_group_id] AS id, sg.[site_id], sg.[parent_search_group_id], sg.[name],
		sg.[description], sg.add_options_automatically, sg.prefix_text, sg.suffix_text, sg.search_enabled, 
		sg.locked, sg.[created], sg.[enabled], sg.[modified]
	FROM search_group sg
		INNER JOIN dbo.category_to_search_group csg
			ON sg.search_group_id = csg.search_group_id
	WHERE csg.category_id = @categoryId
		AND csg.searchable = 1
		AND csg.sort_order > 0
	ORDER BY csg.sort_order, sg.[name]
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupsByCategoryId TO VpWebApp 
GO

------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchGroupsByParentGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchGroupsByParentGroupIdList
	@parentGroupId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [search_group_id] AS id, [site_id], [parent_search_group_id], [name], [description],
		add_options_automatically, prefix_text, suffix_text, search_enabled, locked, [created], [enabled], [modified]
	FROM search_group
	WHERE [parent_search_group_id] = @parentGroupId

	SELECT @totalCount = COUNT(*)
	FROM search_group
	WHERE [parent_search_group_id] = @parentGroupId
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupsByParentGroupIdList TO VpWebApp 
GO

----------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchGroupsBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchGroupsBySiteIdWithPagingList
	@siteId int,
	@groupId int,
	@searchText varchar(500),
	@startIndex int,
	@endIndex int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH temp_search_group(row, search_group_id, site_id, parent_search_group_id, [name], description,
		add_options_automatically, prefix_text, suffix_text, search_enabled, locked, enabled, created, modified) 
	AS	
	(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY search_group_id) AS row, 
			search_group_id, site_id, parent_search_group_id, [name], description,
			add_options_automatically, prefix_text, suffix_text, search_enabled, locked, enabled, created, modified
		FROM search_group
		WHERE site_id = @siteId AND (@groupId IS NULL OR search_group_id = @groupId) AND [name] LIKE (@searchText + '%')
	)

	SELECT	search_group_id AS id,  site_id, parent_search_group_id, [name], description,
		add_options_automatically, prefix_text, suffix_text, search_enabled, locked, enabled, created, modified
	FROM temp_search_group
	WHERE (row BETWEEN @startIndex AND @endIndex)
	ORDER BY row

	SELECT @totalCount = COUNT(*)
	FROM search_group
	WHERE site_id = @siteId AND (@groupId IS NULL OR search_group_id = @groupId) AND [name] LIKE (@searchText + '%')

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupsBySiteIdWithPagingList TO VpWebApp 
GO

-----------


EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchGroupsBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchGroupsBySiteIdList
	@siteId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [search_group_id] AS id, [site_id], [parent_search_group_id], [name], [description],
		add_options_automatically, prefix_text, suffix_text, search_enabled, locked, [created], [enabled], [modified]
	FROM search_group
	WHERE [site_id] = @siteId

	SELECT @totalCount = COUNT(*)
	FROM search_group
	WHERE [site_id] = @siteId
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupsBySiteIdList TO VpWebApp 
GO

------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateSearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateSearchGroup
	@id int,
	@siteId int,
	@parentSearchGroupId int,
	@name varchar(255),
	@description varchar(500),
	@addOptionsAutomatically bit,
	@prefixText varchar(255),
	@suffixText varchar(255),
	@searchEnabled bit,
	@locked bit,
	@enabled bit,	
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE [search_group]
	SET
		site_id = @siteId,
		parent_search_group_id = @parentSearchGroupId,
		[name] = @name,
		[description] = @description,
		add_options_automatically = @addOptionsAutomatically,
		prefix_text = @prefixText,
		suffix_text = @suffixText,
		search_enabled = @searchEnabled,
		locked = @locked,
		[enabled] = @enabled,
		[modified] = @modified
	WHERE search_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateSearchGroup TO VpWebApp 
GO

---------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchGroupDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchGroupDetail
	@id int
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT [search_group_id] AS id, [site_id], [parent_search_group_id], [name], [description],
		add_options_automatically, prefix_text, suffix_text, search_enabled, locked, [created], [enabled], [modified]
	FROM search_group
	WHERE search_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupDetail TO VpWebApp 
GO

----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddSearchGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddSearchGroup
	@id int output,
	@siteId int,
	@parentSearchGroupId int,
	@name varchar(255),
	@description varchar(500),
	@addOptionsAutomatically bit,
	@prefixText varchar(255),
	@suffixText varchar(255),
	@searchEnabled bit,
	@locked bit,
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO search_group(site_id, parent_search_group_id, [name], [description], add_options_automatically,
		prefix_text, suffix_text, search_enabled, locked, [enabled], [modified], [created])
	VALUES (@siteId, @parentSearchGroupId, @name, @description, @addOptionsAutomatically,
		@prefixText, @suffixText, @searchEnabled, @locked, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddSearchGroup TO VpWebApp 
Go

------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetProductSearchOptionsByCategorySearchGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetProductSearchOptionsByCategorySearchGroupIdList
	@searchGroupId int,
	@categoryId int
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT ps.product_to_search_option_id AS id, ps.search_option_id, ps.product_id, ps.locked, ps.created, ps.enabled, ps.modified
	FROM product_to_search_option ps
	INNER JOIN search_option so
		ON so.search_option_id = ps.search_option_id AND so.search_group_id = @searchGroupId
	INNER JOIN product_to_category pc
		ON ps.product_id = pc.product_id AND pc.category_id = @categoryId
	

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionsByCategorySearchGroupIdList TO VpWebApp 
GO

----------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetProductSearchOptionsByProductIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetProductSearchOptionsByProductIdList
	@productId int,
	@totalCount int output
AS
-- ==========================================================================
-- $ Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT pso.[product_to_search_option_id] AS id, pso.[search_option_id], pso.[product_id], pso.locked, pso.[created], pso.[enabled], pso.[modified]
	FROM product_to_search_option pso
		INNER JOIN search_option so
			ON so.search_option_id = pso.search_option_id
	WHERE product_id = @productId
	Order By so.search_group_id, so.search_option_id

	SELECT @totalCount = COUNT(*)
	FROM product_to_search_option
	WHERE product_id = @productId

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetProductSearchOptionsByProductIdList TO VpWebApp 
GO

----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddProductSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddProductSearchOption
	@id int output,
	@productId int,
	@searchOptionId int,	
	@locked bit,
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO product_to_search_option ([product_id], [search_option_id], locked, [enabled], [modified], [created])
	VALUES (@productId, @searchOptionId, @locked, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddProductSearchOption TO VpWebApp 
Go

----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateProductSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateProductSearchOption
	@id int,
	@productId int,
	@searchOptionId int,
	@locked bit,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE [product_to_search_option]
	SET
		[product_id] = @productId,
		[search_option_id] = @searchOptionId,
		locked = @locked,
		[enabled] = @enabled,
		[modified] = @modified
	WHERE [product_to_search_option_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateProductSearchOption TO VpWebApp 
GO