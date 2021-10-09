IF NOT EXISTS(select * from sys.columns where Name = N'search_enabled' and Object_ID = Object_ID(N'search_group'))
BEGIN
	ALTER TABLE search_group ADD search_enabled BIT NOT NULL DEFAULT 1
END
GO

--------

IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'VendorSearchNotifier')
BEGIN
	INSERT INTO module ([module_name], [usercontrol_name], [enabled], [modified], [created], [is_container])
	VALUES('VendorSearchNotifier','~/Modules/ContentSearch/VendorSearchNotifier.ascx','1',GETDATE(),GETDATE(), 0)
END
GO

-------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchEnabledOptionsByProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchEnabledOptionsByProductIdsList
	@productIds varchar(max)

AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled,
		so.modified, pso.product_id
	FROM search_option so
		INNER JOIN search_group sg
			ON sg.search_group_id = so.search_group_id
		INNER JOIN product_to_search_option pso
			ON so.search_option_id = pso.search_option_id
		INNER JOIN global_Split(@productIds, ',') p
			ON p.[value] = pso.product_id
	WHERE so.enabled = 1 AND sg.search_enabled = 1

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchEnabledOptionsByProductIdsList TO VpWebApp 
GO

--------

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
				  ,sg.[suffix_text], sg.search_enabled
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
				  ,sg.[suffix_text], sg.search_enabled
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

-----------

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
  sg.[created], sg.[enabled], sg.[modified]  
 FROM search_group sg  
  INNER JOIN dbo.category_to_search_group csg  
   ON sg.search_group_id = csg.search_group_id  
 WHERE csg.category_id IN (SELECT [value] FROM [global_Split](@categoryIdList, ','))
   
 ORDER BY csg.sort_order, sg.[name]  
END  
GO

GRANT EXECUTE ON dbo.adminSearchCategory_GetSearchGroupsByCategoryIdList TO VpWebApp 
GO

------------

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
		sg.[created], sg.[enabled], sg.[modified]
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



-----------


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
		add_options_automatically, prefix_text, suffix_text, search_enabled, [created], [enabled], [modified]
	FROM search_group
	WHERE [parent_search_group_id] = @parentGroupId

	SELECT @totalCount = COUNT(*)
	FROM search_group
	WHERE [parent_search_group_id] = @parentGroupId
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupsByParentGroupIdList TO VpWebApp 
GO


------------

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
		add_options_automatically, prefix_text, suffix_text, search_enabled, enabled, created, modified) 
	AS	
	(
		SELECT 
			ROW_NUMBER() OVER (ORDER BY search_group_id) AS row, 
			search_group_id, site_id, parent_search_group_id, [name], description,
			add_options_automatically, prefix_text, suffix_text, search_enabled, enabled, created, modified
		FROM search_group
		WHERE site_id = @siteId AND (@groupId IS NULL OR search_group_id = @groupId) AND [name] LIKE (@searchText + '%')
	)

	SELECT	search_group_id AS id,  site_id, parent_search_group_id, [name], description,
		add_options_automatically, prefix_text, suffix_text, search_enabled, enabled, created, modified
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

------------


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
		add_options_automatically, prefix_text, suffix_text, search_enabled, [created], [enabled], [modified]
	FROM search_group
	WHERE [site_id] = @siteId

	SELECT @totalCount = COUNT(*)
	FROM search_group
	WHERE [site_id] = @siteId
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupsBySiteIdList TO VpWebApp 
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
		add_options_automatically, prefix_text, suffix_text, search_enabled, [created], [enabled], [modified]
	FROM search_group
	WHERE search_group_id = @id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchGroupDetail TO VpWebApp 
GO

----------

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
		[enabled] = @enabled,
		[modified] = @modified
	WHERE search_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateSearchGroup TO VpWebApp 
GO

---------

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
		prefix_text, suffix_text, search_enabled, [enabled], [modified], [created])
	VALUES (@siteId, @parentSearchGroupId, @name, @description, @addOptionsAutomatically,
		@prefixText, @suffixText, @searchEnabled, @enabled, @created, @created)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddSearchGroup TO VpWebApp 
Go

--------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUnindexedVendorsBySiteIdWithPagingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUnindexedVendorsBySiteIdWithPagingList
	@siteId int,
	@startIndex int,
	@endIndex int
AS
-- ==========================================================================
-- Author : Dilshan
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	WITH selectedVendor(id, row_id, site_id, vendor_name, rank, has_image, [enabled], modified, created, parent_vendor_id,
		vendor_keywords, internal_name, description)
	AS
	(
		SELECT  id, ROW_NUMBER() OVER (ORDER BY id DESC) AS row_id, site_id, vendor_name, rank, has_image, [enabled], modified,
			created, parent_vendor_id, vendor_keywords, internal_name, description
		FROM
		(	
			SELECT vendor_id as id, site_id, vendor_name, rank, has_image, [enabled], modified, created, parent_vendor_id,
				vendor_keywords, internal_name, description
			FROM vendor
			WHERE enabled = 1 AND site_id = @siteId
		) AS orderedVendors
	)

	SELECT id, site_id, vendor_name, rank, has_image, [enabled], modified, created, parent_vendor_id,
		vendor_keywords, internal_name, description
	FROM selectedVendor
	WHERE row_id BETWEEN @startIndex AND @endIndex
END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUnindexedVendorsBySiteIdWithPagingList TO VpWebApp
GO

-----------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetDeletedOrDisabledVendorSearchContentsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetDeletedOrDisabledVendorSearchContentsList
	@siteId int,
	@batchSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) search_content_status_id AS id, site_id, content_type_id, content_id, [enabled], created, modified
	FROM search_content_status
	WHERE content_type_id = 6 AND site_id = @siteId AND content_id NOT IN 
		(	SELECT vendor_id 
			FROM vendor
			WHERE site_id = @siteId AND enabled = 1
		)
		
	SELECT @totalCount = COUNT(*)
	FROM search_content_status
	WHERE content_type_id = 6 AND site_id = @siteId AND content_id NOT IN 
		(	SELECT vendor_id 
			FROM vendor
			WHERE site_id = @siteId AND enabled = 1
		)
END
GO

GRANT EXECUTE ON dbo.adminSearch_GetDeletedOrDisabledVendorSearchContentsList TO VpWebApp 
GO

------------