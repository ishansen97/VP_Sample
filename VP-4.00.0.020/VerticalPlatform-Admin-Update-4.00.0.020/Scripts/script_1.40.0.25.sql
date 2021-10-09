
EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetSearchCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetSearchCategories
	@siteId INT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT c.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category 
			, is_displayed, c.[enabled], c.modified, c.created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
	FROM category c
	WHERE c.site_id = @siteId
		AND c.is_search_category = 1
	
END
GO

GRANT EXECUTE ON dbo.adminCategory_GetSearchCategories TO VpWebApp 
GO


---------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptions
	@optionIds varchar(max)

AS
-- ==========================================================================
-- $ Author : Sahan Diasena $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled, so.modified
	FROM search_option so
	INNER JOIN global_Split(@optionIds, ',') p
		ON p.[value] = so.search_option_id

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptions TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[category_to_search_option]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[category_to_search_option](
		[category_to_search_option_id] [int] IDENTITY(1,1) NOT NULL,
		[category_id] [int] NOT NULL,
		[search_option_id] [int] NOT NULL,
		[enabled] [bit] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_category_to_search_option] PRIMARY KEY NONCLUSTERED 
	(
		[category_to_search_option_id] ASC
	)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[category_to_search_option]  WITH CHECK ADD  CONSTRAINT [FK_category_to_search_option_category] FOREIGN KEY([category_id])
	REFERENCES [dbo].[category] ([category_id])

	ALTER TABLE [dbo].[category_to_search_option] CHECK CONSTRAINT [FK_category_to_search_option_category]

	ALTER TABLE [dbo].[category_to_search_option]  WITH CHECK ADD  CONSTRAINT [FK_category_to_search_option_search_option] FOREIGN KEY([search_option_id])
	REFERENCES [dbo].[search_option] ([search_option_id])

	ALTER TABLE [dbo].[category_to_search_option] CHECK CONSTRAINT [FK_category_to_search_option_search_option]
END
--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AddCategorySearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_AddCategorySearchOption
	@categoryId int,
	@searchOptionId int,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Sahan Diasena $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO category_to_search_option(category_id, search_option_id, enabled, created, modified)
	VALUES (@categoryId, @searchOptionId, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminCategory_AddCategorySearchOption TO VpWebApp 
GO

GO

--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_UpdateCategorySearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_UpdateCategorySearchOption
	@id int,
	@categoryId int,
	@searchOptionId int,
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE category_to_search_option
	SET category_id = @categoryId, 
	search_option_id = @searchOptionId, 
	enabled = @enabled,
	modified = @modified
	WHERE category_to_search_option_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCategory_UpdateCategorySearchOption TO VpWebApp 
GO
--------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_DeleteCategorySearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_DeleteCategorySearchOption
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM category_to_search_option
	WHERE category_to_search_option_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCategory_DeleteCategorySearchOption TO VpWebApp 
Go

-------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetCategorySearchOptionDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetCategorySearchOptionDetail
	@id int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT category_to_search_option_id AS id, category_id, search_option_id, created, enabled, modified
	FROM category_to_search_option
	WHERE category_to_search_option_id = @id

END
GO

GRANT EXECUTE ON dbo.adminCategory_GetCategorySearchOptionDetail TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetSearchOptionsByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetSearchOptionsByCategoryId
	@categoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled, so.modified
	FROM search_option so
	INNER JOIN category_to_search_option ctso
		ON so.search_option_id = ctso.search_option_id
	INNER JOIN category c
		ON c.category_id = ctso.category_id
	WHERE c.category_id = @categoryId
		AND c.auto_generated = 1

END
GO

GRANT EXECUTE ON dbo.adminCategory_GetSearchOptionsByCategoryId TO VpWebApp 
GO

----------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetCategorySearchOptionsByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetCategorySearchOptionsByCategoryId
	@categoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT category_to_search_option_id AS id, category_id, search_option_id, created, enabled, modified
	FROM category_to_search_option
	WHERE category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.adminCategory_GetCategorySearchOptionsByCategoryId TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetGeneratedCategories
	@siteId INT
AS
-- ==========================================================================
-- Author : Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT c.category_id AS id, site_id, category_name, category_type_id
			, [description], short_name, specification, is_search_category 
			, is_displayed, c.[enabled], c.modified, c.created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
	FROM category c
	WHERE c.site_id = @siteId
		AND c.auto_generated = 1
	
END
GO

GRANT EXECUTE ON dbo.adminCategory_GetGeneratedCategories TO VpWebApp 
GO

------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByOptionIdListWithSorting'

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductByOptionIdList'

------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories
	@categoryId int
AS
-- ==========================================================================
-- $ Author : Sahan Diasena $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT

	SELECT @optionsCount = COUNT(*)
	FROM category_to_search_option ctso
	WHERE ctso.category_id = @categoryId

	SELECT p.product_id
	INTO #tmpProducts
	FROM product p
	INNER JOIN product_to_search_option ptso
		ON ptso.product_id = p.product_id
	INNER JOIN category_to_search_option ctso
		ON ctso.search_option_id = ptso.search_option_id
	WHERE ctso.category_id = @categoryId
		AND p.enabled = 1
	GROUP BY p.product_id
	HAVING COUNT(ptso.product_id) = @optionsCount

	INSERT INTO product_to_category (category_id, product_id, [enabled], modified, created)
	SELECT @categoryId, product_id, 1, GETDATE(), GETDATE()
	FROM #tmpProducts
	WHERE product_id NOT IN (
		SELECT product_id
		FROM product_to_category ptc
		WHERE ptc.category_id = @categoryId
		)

	DELETE
	FROM product_to_category
	WHERE category_id = @categoryId
		AND product_id NOT IN (
			SELECT product_id
			FROM #tmpProducts
		)
		
	DROP TABLE #tmpProducts
END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp 
GO

------------------------------------------------------------------------------------------------

dbo.global_DropStoredProcedure 'dbo.adminCategory_GetPrebuiltGuidedBrowsePermutations'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetPrebuiltGuidedBrowsePermutations
	@guidedBrowseId INT,
	@guidedBrowseTypeId INT
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT prebuilt_guided_browse_id AS id, guided_browse_type_id, guided_browse_id, guided_browse_search_options, fixed_guided_browse_search_options,
		start_character, range_index, start_search_option_name, end_search_option_name, start_search_option_id, end_search_option_id, all_search_option_ids,
		previous_search_options, created, enabled, modified
	FROM prebuilt_guided_browse pgb
	WHERE pgb.guided_browse_type_id = @guidedBrowseTypeId
		AND pgb.guided_browse_id = @guidedBrowseId

END
GO

GRANT EXECUTE ON dbo.adminCategory_GetPrebuiltGuidedBrowsePermutations TO VpWebApp 
GO
------------------------------------------------------------------------------------------------

/*IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spider_page_views]') AND type in (N'U'))
BEGIN

	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	SET ANSI_PADDING ON

	CREATE TABLE [dbo].[spider_page_views](
		[spider_page_views_id] [int] IDENTITY(1,1) NOT NULL,
		[ip_address] [varchar](50) NOT NULL,
		[ip_numeric] [bigint] NOT NULL,
		[timestamp] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[enabled] [bit] NOT NULL,
	 CONSTRAINT [PK_spider_page_views] PRIMARY KEY CLUSTERED 
	(
		[spider_page_views_id] ASC
	)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	SET ANSI_PADDING OFF
	
END*/

------------------------------------------------------------------------------------------------

/*IF  NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_ip_address_timestamp' AND object_id = OBJECT_ID(N'[dbo].[spider_page_views]'))
BEGIN

	CREATE NONCLUSTERED INDEX [IX_ip_address_timestamp] ON [dbo].[spider_page_views] 
	(
		[ip_address] ASC,
		[timestamp] DESC
	)WITH (PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
	
END*/
------------------------------------------------------------------------------------------------

/*DROP TABLE spider_page_views*/
------------------------------------------------------------------------------------------------

/*IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'spider_page_views')
DROP SYNONYM [dbo].[spider_page_views]
GO*/

------------------------------**************************------------------------------------
-- If the VPTrans database name is not [VPTrans] replace it with the correct database name
------------------------------**************************------------------------------------
/****** Object:  Synonym [dbo].[spider_page_views]    ******/
/*CREATE SYNONYM [dbo].[spider_page_views] FOR [VPTrans].[dbo].[spider_page_views]
GO*/
------------------------------------------------------------------------------------------------