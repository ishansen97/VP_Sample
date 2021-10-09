

--- specification_type
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[specification_type]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[specification_type] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


--------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddSpecificationType
	@specificationType varchar(255),
	@validationExpression varchar(100),
	@siteId int,
	@searchEnabled bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@isVisible bit,
	@isExpandedView bit,
	@displayEmpty bit,
	@autoTruncateElasticSearch bit
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_AddSpecificationType.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chinthaka $
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @created = GETDATE()

		INSERT INTO specification_type(spec_type, validation_expression
				, site_id, [enabled], modified, created, is_visible, search_enabled, is_expanded_view, display_empty
				, auto_truncate_elastic_search, content_modified)
		VALUES (@specificationType, @validationExpression, @siteId, @enabled, @created, @created, @isVisible
				, @searchEnabled, @isExpandedView, @displayEmpty
				,@autoTruncateElasticSearch, 1)

		SET @id = SCOPE_IDENTITY()
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_AddSpecificationType TO VpWebApp 
Go


-------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateSpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateSpecificationType
	@id int,
	@specificationType varchar(255),
	@validationExpression varchar(100),
	@siteId int,
	@searchEnabled bit,
	@enabled bit,
	@modified smalldatetime output,
	@isVisible bit,
	@isExpandedView bit,
	@displayEmpty BIT,
	@autoTruncateElasticSearch BIT
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_UpdateSpecificationType.sql $
-- $Revision: 4918 $
-- $Date: 2010-03-30 15:40:31 +0530 (Tue, 30 Mar 2010) $ 
-- $Author: chinthaka $
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SET @modified=GETDATE()
	UPDATE specification_type
	SET
		spec_type = @specificationType,
		validation_expression = @validationExpression,
		site_id = @siteId,
		search_enabled = @searchEnabled,
		[enabled] = @enabled,
		modified = @modified,
		is_visible = @isVisible,
		is_expanded_view = @isExpandedView,
		display_empty = @displayEmpty,
		auto_truncate_elastic_search = @autoTruncateElasticSearch,
		content_modified = 1
		
	WHERE spec_type_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateSpecificationType TO VpWebApp 
Go




--- search_option
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[search_option]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[search_option] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_AddSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_AddSearchOption
	@id int output,
	@searchGroupId int,
	@name varchar(255),
	@sortOrder int,
	@enabled bit,	
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()	

	INSERT INTO search_option (search_group_id,  [name], sort_order, enabled, modified, created, content_modified)
	VALUES (@searchGroupId, @name, @sortOrder, @enabled, @created, @created, 1)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddSearchOption TO VpWebApp 
Go



----------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_UpdateSearchOption'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_UpdateSearchOption
	@id int,
	@searchGroupId int,
	@name varchar(255),
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

	UPDATE [search_option]
	SET
		search_group_id = @searchGroupId,
		[name] = @name,
		sort_order = @sortOrder,
		enabled = @enabled,
		modified = @modified,
		content_modified = 1
	WHERE [search_option_id] = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateSearchOption TO VpWebApp 
GO




--- category
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[category]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[category] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


-----------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddCategory'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_AddCategory]    Script Date: 12/3/2018 10:38:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_AddCategory]
	@siteId int,
	@categoryName varchar(255),
	@categoryTypeId int,
	@description varchar(max),
	@shortName varchar(50),
	@specification varchar(200),
	@isSearchCategory bit,
	@isDisplayed bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@matrixType int,
	@productCount int,
	@autoGenerated bit,
	@hidden bit,
	@hasImage bit,
	@urlId INT,
	@sort_order INT
AS
-- ==========================================================================
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @created = GETDATE()
	INSERT INTO category(site_id, category_name, category_type_id, [description], short_name, specification
			, is_search_category, is_displayed, [enabled], modified, created, matrix_type, product_count, auto_generated, hidden, has_image, url_id
			,sort_order, content_modified) 
	VALUES (@siteId, @categoryName, @categoryTypeId, @description, @shortName, @specification, @isSearchCategory
			, @isDisplayed, @enabled, @created, @created, @matrixType, @productCount, @autoGenerated, @hidden, @hasImage, @urlId
			,@sort_order, 1) 

	SET @id = SCOPE_IDENTITY() 
	
END

GO
GRANT EXECUTE ON dbo.adminProduct_AddCategory TO VpWebApp
GO


-----------------------------------


GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateCategory'
GO


GO
/****** Object:  StoredProcedure [dbo].[adminProduct_UpdateCategory]    Script Date: 12/3/2018 10:41:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_UpdateCategory]
	@id int, 
	@siteId int,
	@categoryName varchar(255),
	@categoryTypeId int,
	@description varchar(max),
	@shortName varchar(50),
	@specification varchar(200),
	@isSearchCategory bit,
	@isDisplayed bit,
	@enabled bit,
	@modified smalldatetime output,
	@matrixType int,
	@productCount int,
	@autoGenerated bit,
	@hidden bit,
	@hasImage bit,
	@urlId INT,
	@sort_order INT
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminProduct_UpdateCategory.sql $
-- $Revision: 6322 $
-- $Date: 2010-08-17 16:18:26 +0530 (Tue, 17 Aug 2010) $ 
-- $Author: dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE category 
	SET
		site_id = @siteId,
		category_name = @categoryName,
		category_type_id = @categoryTypeId,
		description = @description,
		short_name = @shortName,
		specification = @specification,
		is_search_category = @isSearchCategory,
		is_displayed = @isDisplayed,
		[enabled] = @enabled,
		modified = @modified,
		matrix_type = @matrixType,
		product_count = @productCount,
		auto_generated = @autoGenerated,
		hidden = @hidden,
		has_image = @hasImage,
		url_id = @urlId,
		sort_order = @sort_order,
		content_modified = 1
	WHERE category_id = @id


END

GO
GRANT EXECUTE ON dbo.adminProduct_UpdateCategory TO VpWebApp
GO


----------------------------------------

--- action
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[action]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[action] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


---------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminAction_AddAction'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAction_AddAction
	@id int output,
	@siteId int,
	@actionType int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@created smalldatetime output,
	@landingPageId int,
	@alternateLinkText varchar(1024)
AS
-- ==========================================================================
-- $Author: nilushi $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [action] (site_id, action_type, [name], title, [enabled], modified, created, landing_page_id, alternate_link_text, content_modified)
	VALUES (@siteId, @actionType, @name, @title, @enabled, @created, @created, @landingPageId, @alternateLinkText, 1)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminAction_AddAction TO VpWebApp 
GO


---------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminAction_UpdateAction'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAction_UpdateAction
	@id int,
	@siteId int,
	@actionType int,
	@name varchar(255),
	@title varchar(255),
	@enabled bit,
	@modified smalldatetime output,
	@landingPageId int,
	@alternateLinkText varchar(1024)
	 
AS
-- ==========================================================================
-- $Author: nilushi $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[action]
	SET site_id = @siteId,
		action_type = @actionType,
		[name] = @name,
		title = @title,
		enabled = @enabled,		
		modified = @modified,
		landing_page_id = @landingPageId,
		alternate_link_text = @alternateLinkText,
		content_modified = 1
	WHERE action_id = @id

END
GO

GRANT EXECUTE ON dbo.adminAction_UpdateAction TO VpWebApp 
GO



--- country
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[country]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[country] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


---------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateCountry'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateCountry
	@id int,
	@countryName varchar(100),
	@isoCode varchar(10),
	@enabled bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@modified smalldatetime output,
	@cultureName varchar(10)
AS
-- ==========================================================================
-- $ Author : Dhanushka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE country
	SET
		modified = @modified,
		culture_name = @cultureName,
		content_modified = 1
	WHERE country_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateCountry TO VpWebApp 
GO



--- region
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[region]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[region] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


-----------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminRegion_AddRegion'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRegion_AddRegion
	@id int output,
	@siteId int,
	@name varchar(255),
	@type int,
	@created smalldatetime output, 
	@enabled bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@description varchar(500)
	
AS
-- ========================================================================== 
-- $Author:tishan $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO region (site_id, [name], [type], modified, created, [enabled], flag1, flag2, flag3, flag4, [description], content_modified)
	VALUES (@siteId, @name, @type, @created, @created, @enabled, @flag1, @flag2, @flag3, @flag4, @description, 1)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminRegion_AddRegion TO VpWebApp 
GO


----------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminRegion_UpdateRegion'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRegion_UpdateRegion
	@id int output,
	@siteId int,
	@name varchar(255),
	@type int,
	@enabled bit,
	@flag1 bigint,
	@flag2 bigint,
	@flag3 bigint,
	@flag4 bigint,
	@description varchar(500),
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE region
	SET
		site_id = @siteId,
		[name] = @name,	
		[type] = @type,
		modified = @modified,
		[enabled] = @enabled,
		flag1 = @flag1,
		flag2 = @flag2,
		flag3 = @flag3,
		flag4 = @flag4,
		[description] = @description,
		content_modified = 1
		
	WHERE region_id = @id
 

END
GO

GRANT EXECUTE ON dbo.adminRegion_UpdateRegion TO VpWebApp 
GO


--- currency
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[currency]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[currency] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


-----------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddCurrency'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddCurrency
	@description varchar(100),
	@localSymbol varchar(20),
	@internationalSymbol varchar(20),
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author Tishan$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()
	INSERT INTO currency([description], local_symbol, international_symbol, [enabled], modified, created, content_modified) 
	VALUES (@description, @localSymbol, @internationalSymbol, @enabled, @created, @created, 1)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddCurrency TO VpWebApp 
GO


--------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateCurrency'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateCurrency
	@id int,
	@description varchar(100),
	@localSymbol varchar(20),
	@internationalSymbol varchar(20),
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SET @modified = GETDATE()

	UPDATE currency
	SET
		description = @description,
		local_symbol = @localSymbol,
		international_symbol = @internationalSymbol,
		[enabled] = @enabled,
		modified = @modified,
		content_modified = 1
	WHERE currency_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateCurrency TO VpWebApp 
GO


--- vendor_settings_template
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[vendor_settings_template]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[vendor_settings_template] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddVendorSettingsTemplate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddVendorSettingsTemplate
	@id int output,
	@vendorSettingsTemplateName varchar(100),
	@vendorId int,
	@sortOrder int,
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SET @created = GETDATE()
	
	INSERT INTO vendor_settings_template
	   (vendor_settings_template_name
	   , vendor_id
	   , sort_order
	   , enabled
	   , modified
	   , created
	   , content_modified)
	VALUES
	   (@vendorSettingsTemplateName
	   , @vendorId
	   , @sortOrder
	   , @enabled
	   , @created
	   , @created
	   , 1 )
	
	SET @id = SCOPE_IDENTITY()
	
END
GO

GRANT EXECUTE ON dbo.adminProduct_AddVendorSettingsTemplate TO VpWebApp 
GO


------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateVendorSettingsTemplate'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateVendorSettingsTemplate
	@id int,
	@vendorSettingsTemplateName varchar(100),
	@vendorId int,
	@sortOrder int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @modified = GETDATE()
	
	UPDATE vendor_settings_template
	SET vendor_settings_template_name = @vendorSettingsTemplateName
		, vendor_id = @vendorId
		, sort_order = @sortOrder
		, [enabled] = @enabled
		, modified = @modified
		, content_modified = 1
	WHERE vendor_settings_template_id = @id
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateVendorSettingsTemplate TO VpWebApp 
GO


------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCountByCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductCountByCategoryId
	@categoryId int
AS

-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	WITH cte(id, category_id, sub_category_id, product_id) AS
	(
		SELECT category_product_count_contribution_id AS id, category_id, sub_category_id, product_id
		FROM category_product_count_contribution
		WHERE category_id = @categoryId

		UNION ALL 

		SELECT c.category_product_count_contribution_id AS id, c.category_id, c.sub_category_id, c.product_id
		FROM category_product_count_contribution c
			INNER JOIN cte
				ON c.category_id = cte.sub_category_id
	)

	UPDATE category 
	SET content_modified = 1, product_count = (SELECT COUNT(DISTINCT product_id) AS [count]
		FROM cte WHERE product_id IS NOT NULL)
	WHERE category_id = @categoryId
END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductCountByCategoryId TO VpWebApp
GO


-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminAction_GetModifiedActions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAction_GetModifiedActions
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) a.action_id as id, a.site_id,a.action_type,a.name,a.title,a.enabled,a.modified,a.created,
	a.landing_page_id,a.alternate_link_text
	from action a with(nolock)
	WHERE a.content_modified = 1

END
GO

GRANT EXECUTE ON dbo.adminAction_GetModifiedActions TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_GetModifiedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_GetModifiedCategories
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) c.category_id AS id, c.site_id, c.category_name, c.category_type_id, c.description, c.specification, c.enabled
	, c.modified, c.created, c.is_search_category, c.is_displayed, c.short_name, c.matrix_type, c.product_count, c.auto_generated
	, c.legacy_content_id, c.hidden, c.has_image, c.url_id, c.sort_order 
	FROM category c WITH(nolock)
	WHERE c.content_modified = 1

END
GO

GRANT EXECUTE ON dbo.adminCategory_GetModifiedCategories TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCountry_GetModifiedCountries'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCountry_GetModifiedCountries
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) c.country_id as id,c.country_name,c.iso_code,c.enabled,c.modified,c.created,c.flag1,c.flag2,c.flag3,c.flag4,c.culture_name
	FROM country c WITH(nolock)
	WHERE c.content_modified = 1

END
GO

GRANT EXECUTE ON dbo.adminCountry_GetModifiedCountries TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCurrency_GetModifiedCurrencies'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCurrency_GetModifiedCurrencies
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) c.currency_id as id,c.description,c.local_symbol,c.international_symbol,c.enabled,c.created,c.modified
	FROM currency c WITH(nolock)
	WHERE c.content_modified = 1

END
GO

GRANT EXECUTE ON dbo.adminCurrency_GetModifiedCurrencies TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRegion_GetModifiedRegions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRegion_GetModifiedRegions
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) r.region_id as id,r.site_id,r.name,r.type,r.enabled,r.created,r.modified,r.flag1,r.flag2,
	r.flag3,r.flag4,r.description,r.legacy_content_id
	FROM region r WITH(nolock)
	WHERE r.content_modified = 1

END
GO

GRANT EXECUTE ON dbo.adminRegion_GetModifiedRegions TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchOption_GetModifiedSearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchOption_GetModifiedSearchOptions
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) so.search_option_id AS id, so.search_group_id,so.name,so.enabled,so.created,so.modified,so.sort_order 
	FROM search_option so with(nolock)
	WHERE so.content_modified = 1
END
GO

GRANT EXECUTE ON dbo.adminSearchOption_GetModifiedSearchOptions TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpecificationType_GetModifiedSpecificationTypes'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpecificationType_GetModifiedSpecificationTypes
	@limit INT = 20

AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) spt.spec_type_id AS id, spt.spec_type,spt.validation_expression,spt.site_id,spt.enabled,spt.created,spt.modified,
	spt.is_visible,spt.search_enabled,spt.is_expanded_view,spt.legacy_content_id,spt.display_empty,
	spt.auto_truncate_elastic_search
	FROM specification_type spt WITH(nolock)
	WHERE spt.content_modified = 1

END
GO

GRANT EXECUTE ON dbo.adminSpecificationType_GetModifiedSpecificationTypes TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetVendorSettingsTemplateHierarchy'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetVendorSettingsTemplateHierarchy
	@vendor_settings_template_id int

AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [vendor_settings_template_id],[vendor_settings_template_name],[vendor_id],[sort_order],[enabled],[modified],[created]
	FROM [dbo].[vendor_settings_template] WITH(nolock)
	WHERE [vendor_settings_template_id] = @vendor_settings_template_id
		
	SELECT [vendor_settings_template_category_id],[vendor_settings_template_id],[category_id],[enabled],[modified],[created]
	FROM [dbo].[vendor_settings_template_category] WITH(nolock)
	WHERE [vendor_settings_template_id] = @vendor_settings_template_id	
	
	SELECT [vendor_settings_template_currency_id],[vendor_settings_template_id],[currency_id],[enabled],[created],[modified],[vendor_settings_template_currency_name]
	FROM [dbo].[vendor_settings_template_currency] 
	WHERE [vendor_settings_template_id] = @vendor_settings_template_id
		
	SELECT [content_location_id],[content_type_id],[content_id],[location_type_id],[location_id],[exclude],[modified],[created],[enabled],[site_id]
	FROM [dbo].[content_location] 
	WHERE [content_type_id] = 34 AND [content_id]= @vendor_settings_template_id

END
GO

GRANT EXECUTE ON dbo.adminVendor_GetVendorSettingsTemplateHierarchy TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetModifiedVendorSettingsTemplates'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetModifiedVendorSettingsTemplates
	@limit int = 20

AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) [vendor_settings_template_id] as id
	FROM [dbo].[vendor_settings_template] WITH(nolock)
	WHERE [content_modified]=1
	ORDER BY [vendor_settings_template_id]

END
GO

GRANT EXECUTE ON dbo.adminVendor_GetModifiedVendorSettingsTemplates TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminAction_UpdateActionContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminAction_UpdateActionContentModifiedStatus
	@actionIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE a
	SET   a.content_modified = @contentModified
	FROM [action] a
		INNER JOIN dbo.global_Split(@actionIds, ',') gs
		ON a.action_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminAction_UpdateActionContentModifiedStatus TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_UpdateCategoryContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCategory_UpdateCategoryContentModifiedStatus
	@categoryIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE c
	SET   c.content_modified = @contentModified
	FROM [category] c
		INNER JOIN dbo.global_Split(@categoryIds, ',') gs
		ON c.category_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminCategory_UpdateCategoryContentModifiedStatus TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCountry_UpdateCountryContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCountry_UpdateCountryContentModifiedStatus
	@countryIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE c
	SET   c.content_modified = @contentModified
	FROM [country] c
		INNER JOIN dbo.global_Split(@countryIds, ',') gs
		ON c.country_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminCountry_UpdateCountryContentModifiedStatus TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminCurrency_UpdateCurrenciesContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCurrency_UpdateCurrenciesContentModifiedStatus
	@currencyIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE c
	SET   c.content_modified = @contentModified
	FROM [currency] c
		INNER JOIN dbo.global_Split(@currencyIds, ',') gs
		ON c.currency_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminCurrency_UpdateCurrenciesContentModifiedStatus TO VpWebApp 
GO



-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_UpdateVendorSettingsTemplateContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_UpdateVendorSettingsTemplateContentModifiedStatus
	@vendorSettingsTemplateIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE vst
	SET   vst.content_modified = @contentModified
	FROM [vendor_settings_template] vst
		INNER JOIN dbo.global_Split(@vendorSettingsTemplateIds, ',') gs
		ON vst.vendor_settings_template_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminVendor_UpdateVendorSettingsTemplateContentModifiedStatus TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRegion_UpdateRegionContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRegion_UpdateRegionContentModifiedStatus
	@regionIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE r
	SET   r.content_modified = @contentModified
	FROM [region] r
		INNER JOIN dbo.global_Split(@regionIds, ',') gs
		ON r.region_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminRegion_UpdateRegionContentModifiedStatus TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchOption_UpdateSearchOptionContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchOption_UpdateSearchOptionContentModifiedStatus
	@searchOptIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE so
	SET   so.content_modified = @contentModified
	FROM [search_option] so
		INNER JOIN dbo.global_Split(@searchOptIds, ',') gs
		ON so.search_option_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminSearchOption_UpdateSearchOptionContentModifiedStatus TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpecificationType_UpdateSpecificationTypeContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpecificationType_UpdateSpecificationTypeContentModifiedStatus
	@specTypeIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE st
	SET   st.content_modified = @contentModified
	FROM [specification_type] st
		INNER JOIN dbo.global_Split(@specTypeIds, ',') gs
		ON st.spec_type_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminSpecificationType_UpdateSpecificationTypeContentModifiedStatus TO VpWebApp 
GO

--Content Location---------------------------------------

If Not exists ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[content_location]') AND name = 'content_modified' ) BEGIN
	ALTER TABLE [dbo].[content_location] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO


------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminLocation_AddContentLocation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminLocation_AddContentLocation
	@contentTypeId int,
	@contentId int,
	@locationTypeId int,
	@locationId int,
	@siteId int,
	@exclude bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: tishan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO content_location (content_type_id, content_id, location_type_id, location_id, site_id
				, exclude, created, modified, [enabled], content_modified)
	VALUES (@contentTypeId, @contentId, @locationTypeId, @locationId, @siteId, @exclude, @created, @created, @enabled, 1)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminLocation_AddContentLocation TO VpWebApp 
GO

------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminLocation_UpdateContentLocation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminLocation_UpdateContentLocation
	@id int,
	@contentTypeId int, 
	@contentId int,
	@locationTypeId int,
	@locationId int,
	@siteId int,
	@exclude bit,
	@enabled bit,
	@modified smalldatetime output 
AS
-- ==========================================================================
-- $Author: tishan $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.content_location
	SET content_type_id = @contentTypeId,
		content_id =@contentId,
		location_type_id = @locationTypeId,
		location_id = @locationId,
		site_id = @siteId,
		exclude = @exclude,
		enabled = @enabled,
		modified = @modified,
		content_modified = 1
	WHERE content_location_id = @id

END
GO

GRANT EXECUTE ON dbo.adminLocation_UpdateContentLocation TO VpWebApp 
GO

---Search Group--------------------------------------------------------------------

IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[search_group]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[search_group] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO

---------------------------------------------------------------------

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
		prefix_text, suffix_text, search_enabled, locked, [enabled], [modified], [created], content_modified)
	VALUES (@siteId, @parentSearchGroupId, @name, @description, @addOptionsAutomatically,
		@prefixText, @suffixText, @searchEnabled, @locked, @enabled, @created, @created, 1)	

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_AddSearchGroup TO VpWebApp 
Go

---------------------------------------------------------------------
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
		[modified] = @modified,
		content_modified = 1
	WHERE search_group_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_UpdateSearchGroup TO VpWebApp 
GO

---------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetModifiedVendorContentLocations'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetModifiedVendorContentLocations
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) c.content_location_id as id,c.content_type_id,c.content_id,c.location_type_id,c.location_id,c.exclude,c.enabled,c.site_id, c.created,c.modified
	FROM content_location c WITH(nolock)
	WHERE c.content_modified=1 AND content_type_id = 6

END
GO

GRANT EXECUTE ON dbo.adminVendor_GetModifiedVendorContentLocations TO VpWebApp 
GO
---------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminContentLocation_UpdateContentLocationModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminContentLocation_UpdateContentLocationModifiedStatus
  @contentLocationIds VARCHAR(max),
  @contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
  
  SET NOCOUNT ON;

  UPDATE c
  SET   c.content_modified = @contentModified
  FROM [content_location] c
    INNER JOIN dbo.global_Split(@contentLocationIds, ',') gs
    ON c.content_location_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminContentLocation_UpdateContentLocationModifiedStatus TO VpWebApp 
GO

-------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchGroups_GetModifiedSearchGroups'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchGroups_GetModifiedSearchGroups
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) sg.search_group_id AS id, sg.site_id, sg.parent_search_group_id, sg.name, sg.description, sg.enabled, sg.created, sg.modified, sg.add_options_automatically, sg.prefix_text, sg.suffix_text, sg.legacy_content_id, sg.search_enabled, sg.locked
	FROM search_group sg with(nolock)
	WHERE sg.content_modified = 1
END
GO

GRANT EXECUTE ON dbo.adminSearchGroups_GetModifiedSearchGroups TO VpWebApp 
GO

----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchGroups_UpdateSearchGroupModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchGroups_UpdateSearchGroupModifiedStatus
  @searchGroupIds VARCHAR(max),
  @contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
  
  SET NOCOUNT ON;

  UPDATE sg
  SET   sg.content_modified = @contentModified
  FROM [search_group] sg
    INNER JOIN dbo.global_Split(@searchGroupIds, ',') gs
    ON sg.search_group_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminSearchGroups_UpdateSearchGroupModifiedStatus TO VpWebApp 
GO

--- Vendor Currency Location-------------
IF NOT EXISTS ( SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[vendor_to_currency_to_location]') AND name = 'content_modified' )
BEGIN
	ALTER TABLE [dbo].[vendor_to_currency_to_location] ADD content_modified BIT NOT NULL DEFAULT 0	 
END
GO
-------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddVendorCurrencyLocation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddVendorCurrencyLocation
	@vendorId int,
	@currencyId int,
	@locationTypeId int,
	@locationId int,
	@enabled bit,
	@created smalldatetime output,	
	@id int output
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SET @created=GETDATE()
	INSERT INTO [dbo].[vendor_to_currency_to_location]
           ([Vendor_id]
           ,[currency_id]
           ,[location_type_id]
           ,[location_id]
           ,[enabled]
           ,[created]
           ,[modified]
		   ,[content_modified])
    VALUES
           (@vendorId, @currencyId, @locationTypeId, @locationId, @enabled, @created, @created, 1)
		   
	SET @id=SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddVendorCurrencyLocation TO VpWebApp 
GO
------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateVendorCurrencyLocation'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateVendorCurrencyLocation
	@id int,
	@vendorId int,
	@currencyId int,
	@locationTypeId int,
	@locationId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE vendor_to_currency_to_location
	SET [Vendor_id] = @vendorId
	  ,[currency_id] = @currencyId
	  ,[location_type_id] = @locationTypeId
	  ,[location_id] = @locationId
	  ,[enabled] = @enabled
	  ,[modified] = @modified	  
		,content_modified = 1
	WHERE vendor_to_currency_to_location_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateVendorCurrencyLocation TO VpWebApp 
GO



---------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetModifiedVendorCurrencyLocations'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetModifiedVendorCurrencyLocations
	@limit INT = 20
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) [vendor_to_currency_to_location_id] AS id ,[Vendor_id], [currency_id], [location_type_id], [location_id], [enabled], [created], [modified]
	FROM vendor_to_currency_to_location  with(nolock)
	WHERE content_modified = 1
END
GO

GRANT EXECUTE ON dbo.adminVendor_GetModifiedVendorCurrencyLocations TO VpWebApp 
GO
-----------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_UpdateVendorCurrencyLocationContentModifiedStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_UpdateVendorCurrencyLocationContentModifiedStatus
	@vendorCurrencyLocationIds VARCHAR(max),
	@contentModified BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE vcl
	SET   vcl.content_modified = @contentModified
	FROM [vendor_to_currency_to_location] vcl
		INNER JOIN dbo.global_Split(@vendorCurrencyLocationIds, ',') gs
		ON vcl.vendor_to_currency_to_location_id = gs.[value]

END
GO

GRANT EXECUTE ON dbo.adminVendor_UpdateVendorCurrencyLocationContentModifiedStatus TO VpWebApp 
GO



---------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rapid_product_updates' AND xtype='U')
BEGIN
CREATE TABLE [dbo].[rapid_product_updates](
	[rapid_product_update_id] [INT] NOT NULL PRIMARY KEY IDENTITY,
	[product_json] [VARCHAR](MAX),
	[job_id] [INT],
	[product_update_type] [INT],
	[status] [INT],
	[created] [DATETIME],
	[modified] [DATETIME],
	[enabled] [BIT]

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

--------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidUpdatesByStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidUpdatesByStatus
	@limit int = 20,
	@status int
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@limit) rapid_product_update_id AS id,product_json,status,created,modified,enabled FROM rapid_product_updates 
	WHERE Status = @status;

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidUpdatesByStatus TO VpWebApp 
GO


--------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_ChangeProductUpdateStatuses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_ChangeProductUpdateStatuses
	@productId INT,
	@searchContentModified BIT,
	@contentModified BIT,
	@enabled BIT,
	@archived BIT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE product
	SET search_content_modified = @searchContentModified, content_modified = @contentModified, enabled = @enabled, archived = @archived
	WHERE product_id = @productId 

END
GO

GRANT EXECUTE ON dbo.adminProduct_ChangeProductUpdateStatuses TO VpWebApp 
GO


--------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProductSearchOption_GetProductSearchOptionByProductIdAndSearchOptionId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProductSearchOption_GetProductSearchOptionByProductIdAndSearchOptionId
	@productId INT,
	@searchOptionId INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_search_option_id AS id, product_id, search_option_id,enabled, locked
	FROM product_to_search_option 
	WHERE product_id = @productId AND search_option_id = @searchOptionId

END
GO

GRANT EXECUTE ON dbo.adminProductSearchOption_GetProductSearchOptionByProductIdAndSearchOptionId TO VpWebApp 
GO


--------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId
	@productId INT,
	@categoryId INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_category_id AS id, product_id, category_id, enabled
	FROM product_to_category
	WHERE product_id = @productId AND category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_UpdateRapidProductUpdateStatusById'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_UpdateRapidProductUpdateStatusById
	@rapidUpdateId INT,
	@status INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE rapid_product_updates
	SET status = @status
	WHERE rapid_product_update_id = @rapidUpdateId

END
GO

GRANT EXECUTE ON dbo.adminRapid_UpdateRapidProductUpdateStatusById TO VpWebApp 
GO


