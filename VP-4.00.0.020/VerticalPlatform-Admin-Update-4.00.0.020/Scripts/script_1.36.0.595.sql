ALTER TABLE vendor_parameter
ALTER COLUMN vendor_parameter_value varchar(MAX)
GO
--------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddVendorParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddVendorParameter
	@id int output,
	@vendorId int,
    @parameterTypeId int,
	@vendorParameterValue varchar(MAX),
	@enabled bit,
	@created smalldatetime output
 
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO vendor_parameter (vendor_id, parameter_type_id, vendor_parameter_value
		, [enabled], modified, created)
	VALUES(@vendorId, @parameterTypeId, @vendorParameterValue, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddVendorParameter TO VpWebApp
GO
-----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateVendorParameter'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateVendorParameter
	@id int,
	@vendorId int,
    @parameterTypeId int,
	@vendorParameterValue varchar(MAX),
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE vendor_parameter
	SET 
		vendor_id = @vendorId,
		parameter_type_id = @parameterTypeId,
		vendor_parameter_value = @vendorParameterValue,
		[enabled] = @enabled,
		modified = @modified,
		created = @modified	
	WHERE vendor_parameter_id = @id			

END
GO


GRANT EXECUTE ON dbo.adminProduct_UpdateVendorParameter TO VpWebApp 
GO
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE [parameter_type_id] = 172 AND [parameter_type] = 'VendorSummaryText')
BEGIN
	INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES (172,'VendorSummaryText',1,GETDATE(),GETDATE())
END
GO
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'VendorSummary' 
	AND [usercontrol_name] = '~/Modules/VendorDetail/VendorSummary.ascx')
BEGIN
	INSERT INTO [module] ([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES ('VendorSummary','~/Modules/VendorDetail/VendorSummary.ascx',1,GETDATE(),GETDATE(),0)
END
GO
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'VendorProductCategory' 
	AND [usercontrol_name] = '~/Modules/VendorDetail/VendorProductCategory.ascx')
BEGIN
	INSERT INTO [module] ([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES ('VendorProductCategory','~/Modules/VendorDetail/VendorProductCategory.ascx',1,GETDATE(),GETDATE(),0)
END
GO
------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'VendorDetailSpecification' 
	AND [usercontrol_name] = '~/Modules/VendorDetail/VendorDetailSpecification.ascx')
BEGIN
	INSERT INTO [module] ([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES ('VendorDetailSpecification','~/Modules/VendorDetail/VendorDetailSpecification.ascx',1,GETDATE(),GETDATE(),0)
END
GO
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'VendorSearchBox' 
	AND [usercontrol_name] = '~/Modules/VendorDetail/VendorSearchBox.ascx')
BEGIN
	INSERT INTO [module] ([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES ('VendorSearchBox','~/Modules/VendorDetail/VendorSearchBox.ascx',1,GETDATE(),GETDATE(),0)
END
GO
---------
EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_GetChildVendorsByParentVendors'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_GetChildVendorsByParentVendors
	@siteId int,
	@parentVendorIds varchar(max)
AS
-- ==========================================================================
-- $Author:  Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT vendor_id AS id, site_id AS site_id, vendor_name, rank, has_image, [enabled], modified,
		   created, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM vendor
	WHERE site_id = @siteId AND  parent_vendor_id IN (SELECT [value] FROM dbo.global_Split(@parentVendorIds, ','))
	
END
GO

GRANT EXECUTE ON dbo.adminVendor_GetChildVendorsByParentVendors TO VpWebApp 
GO

----------

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE [parameter_type_id] = 173 AND [parameter_type] = 'VendorProductCategoryIds')
BEGIN
	INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES (173,'VendorProductCategoryIds',1,GETDATE(),GETDATE())
END
GO-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE [parameter_type_id] = 174 AND [parameter_type] = 'VendorArticle')
BEGIN
	INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES (174,'VendorArticle',1,GETDATE(),GETDATE())
END
GO
---------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE [parameter_type_id] = 176 AND [parameter_type] = 'VendorShowAllProductCategories')
BEGIN
	INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES (176,'VendorShowAllProductCategories',1,GETDATE(),GETDATE())
END
--------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE [parameter_type_id] = 175 AND [parameter_type] = 'VendorTopTenContent')
BEGIN
	INSERT INTO [parameter_type] ([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES (175,'VendorTopTenContent',1,GETDATE(),GETDATE())
END
GO
-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'VendorTopContent' 
	AND [usercontrol_name] = '~/Modules/VendorDetail/VendorTopContent.ascx')
BEGIN
	INSERT INTO [module] ([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES ('VendorTopContent','~/Modules/VendorDetail/VendorTopContent.ascx',1,GETDATE(),GETDATE(),0)
END
GO
-----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList
	@siteId int,
	@sortBy varchar(20),
	@startIndex int,
	@endIndex int,
	@articleTypes varchar(200),
	@startDate smalldatetime,
	@endDate smalldatetime,
	@title varchar(max),
	@authorId int,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH articles AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY a.article_title) AS titleRowNumber
			, ROW_NUMBER() OVER (ORDER BY a.created DESC) AS createdRowNumber
			, ROW_NUMBER() OVER (ORDER BY (first_name + ' ' + last_name)) AS authorRowNumber
			, a.article_id AS id, a.article_type_id, a.site_id, a.article_title
			, a.article_summary, a.[enabled], a.modified, a.created, a.article_short_title
			, a.date_published, a.start_date, a.end_date, a.published, a.external_url_id, a.is_article_template, a.is_external
			, a.featured_identifier, a.thumbnail_image_code,a.article_template_id, a.open_new_window, a.flag1, a.flag2, a.flag3, a.flag4, a.search_content_modified, a.deleted
		FROM article a
		LEFT JOIN article_to_author at
			ON at.article_id = a.article_id
		LEFT JOIN author aa
			ON aa.author_id = at.author_id
		WHERE a.is_article_template = 0 
			AND ((@articleTypes = '' AND a.site_id = @siteId) OR a.article_type_id IN (SELECT [value] FROM Global_Split(@articleTypes, ',')))
			AND (a.article_title LIKE (@title + '%') OR @title IS NULL)
			AND (@startDate IS NULL OR a.created BETWEEN @startDate AND (@endDate+1))
			AND a.deleted = 0 
			AND (@authorId IS NULL OR @authorId = aa.author_id)
	)
	
	SELECT id, article_type_id, site_id, article_title, article_summary, 
		[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
		, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
		, flag1, flag2, flag3, flag4, search_content_modified, deleted
		, CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
			WHEN 'Author' THEN authorRowNumber
			
		END AS row
	INTO #tempArticles
	FROM articles
	ORDER BY 
		CASE @sortBy
			WHEN 'Title' THEN titleRowNumber
			WHEN 'Created' THEN createdRowNumber
			WHEN 'Author' THEN authorRowNumber
		END

	SELECT @numberOfRows = COUNT(*)
	FROM #tempArticles	

	IF((@startIndex IS NOT NULL) AND (@endIndex IS NOT NULL))
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code,article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles
			WHERE (row BETWEEN @startIndex AND @endIndex)
		END
	ELSE
		BEGIN
			SELECT id, article_type_id, site_id, article_title, article_summary, 
				[enabled], modified, created, article_short_title, date_published, start_date, end_date, published, external_url_id
				, is_article_template, is_external, featured_identifier, thumbnail_image_code, article_template_id, open_new_window
				, flag1, flag2, flag3, flag4, search_content_modified, deleted
			FROM #tempArticles			
		END
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleBySiteIdArticleTypeIdsFilteredPageList TO VpWebApp 
GO


UPDATE TOP (1)
		dbo.parameter_type
SET		parameter_type = 'IncludeCatalogNumberInSeoTags' ,
		modified = GETDATE()
WHERE	parameter_type_id = 153
		AND parameter_type = 'IncludeCatalogNumberInMetaTags'

GO

IF ( NOT EXISTS ( SELECT	1
				  FROM		parameter_type
				  WHERE		parameter_type_id = 177 )
   ) 
	BEGIN
		DECLARE @Now DATETIME
		SET @Now = GETDATE()

		INSERT	dbo.parameter_type
				( parameter_type_id ,
				  parameter_type ,
				  enabled ,
				  modified ,
				  created
				)
		VALUES	( 177 ,
				  'IncludeQuantityInSeoTags' ,
				  1 ,
				  @Now ,
				  @Now
				) 
	END
GO

