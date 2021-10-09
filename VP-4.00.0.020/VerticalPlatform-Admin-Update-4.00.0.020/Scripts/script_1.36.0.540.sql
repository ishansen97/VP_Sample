IF NOT EXISTS ( SELECT  1
                FROM    predefined_page
                WHERE   page_name = 'ProductDisabled' ) 
    BEGIN
        DECLARE @now DATETIME
        SET @now = GETDATE()

        INSERT  predefined_page
                ( page_name ,
                  enabled ,
                  modified ,
                  created
                )
                SELECT  'ProductDisabled' ,
                        1 ,
                        @now ,
                        @now
    END
GO

IF NOT EXISTS ( SELECT  1
				FROM    parameter_type
				WHERE   parameter_type_id = 171 ) 
		BEGIN
	INSERT  dbo.parameter_type
			( parameter_type_id ,
			  parameter_type ,
			  enabled ,
			  modified ,
			  created
		    
			)
	VALUES  ( 171 , -- parameter_type_id - int
			  'SiteParameterHidePriceInfo' , -- parameter_type - varchar(50)
			  1 , -- enabled - bit
			  GETDATE() , -- modified - smalldatetime
			  GETDATE()  -- created - smalldatetime
			)
END
GO
----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleCustomPropertyById'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleCustomPropertyById
	@articleId int,
	@customPropertyId int 	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SELECT article_custom_property_id as id, article_id, article_custom_property.custom_property_id, custom_property_value, 
		article_custom_property.modified, article_custom_property.created, article_custom_property.[enabled], custom_property.property_name
	FROM article_custom_property INNER JOIN
                      custom_property ON article_custom_property.custom_property_id = custom_property.custom_property_id
                      AND custom_property.enabled = 1
	WHERE article_id = @articleId and article_custom_property.custom_property_id = @customPropertyId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleCustomPropertyById TO VpWebApp
GO

----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleCustomPropertyByName'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleCustomPropertyByName
	@articleId int,
	@customPropertyName varchar(100) 	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SELECT article_custom_property_id as id, article_id, article_custom_property.custom_property_id, custom_property_value, 
		article_custom_property.modified, article_custom_property.created, article_custom_property.[enabled], custom_property.property_name
	FROM article_custom_property INNER JOIN
                      custom_property ON article_custom_property.custom_property_id = custom_property.custom_property_id
                      AND custom_property.enabled = 1
	WHERE article_id = @articleId and property_name = @customPropertyName

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleCustomPropertyByName TO VpWebApp
GO

-------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleCustomProperty'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleCustomProperty
	@id int	
AS
-- ==========================================================================
-- $URL: https://dbserver:8443/svn/VerticalPlatform/branches/ArticleEnhancement/db/VPArticalMgt/adminArticle_GetArticleCustomProperty.sql $
-- $Revision: 3514 $
-- $Date: 2009-10-08 17:08:24 +0530 (Thu, 08 Oct 2009) $ 
-- $Author: Sahan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	SELECT article_custom_property_id as id, article_id, [acp].custom_property_id, custom_property_value, cp.property_name, [acp].enabled, 
	[acp].created, [acp].modified
	FROM article_custom_property acp
		INNER JOIN custom_property cp
			ON cp.custom_property_id = [acp].custom_property_id
	WHERE article_custom_property_id = @id

END
GO

GRANT EXECUTE ON adminArticle_GetArticleCustomProperty TO VpWebApp
GO

-------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleCustomPropertyByNameArticleIdList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleCustomPropertyByNameArticleIdList
	@articleIdList varchar(MAX),
	@customPropertyName varchar(100) 	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SELECT article_custom_property_id as id, article_id, article_custom_property.custom_property_id, custom_property_value, 
		article_custom_property.modified, article_custom_property.created, article_custom_property.[enabled], custom_property.property_name
	FROM article_custom_property 
		INNER JOIN custom_property 
			ON article_custom_property.custom_property_id = custom_property.custom_property_id AND custom_property.enabled = 1
		INNER JOIN global_split(@articleIdList, ',') AS articleIdList
			ON article_id = articleIdList.[value]
	WHERE property_name = @customPropertyName

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleCustomPropertyByNameArticleIdList TO VpWebApp
GO

-------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleCustomPropertyList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleCustomPropertyList
	@articleId int 	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SELECT article_custom_property_id as id, article_id, [acp].custom_property_id, custom_property_value, [acp].modified, [acp].created, [acp].[enabled], 
	cp.property_name
	FROM article_custom_property acp
		INNER JOIN custom_property cp
			ON cp.custom_property_id = [acp].custom_property_id
	WHERE article_id = @articleId

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleCustomPropertyList TO VpWebApp
GO

-----------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleCustomPropertiesByArticleIdsCustomPropertyIdsList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleCustomPropertiesByArticleIdsCustomPropertyIdsList
	@articleIds VARCHAR(MAX),
	@customPropertyIds VARCHAR(MAX) 	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SELECT article_custom_property_id as id, article_id, acp.custom_property_id, custom_property_value, acp.modified, acp.created, acp.[enabled], cp.property_name
	FROM article_custom_property acp
		INNER JOIN custom_property cp
			ON cp.custom_property_id = acp.custom_property_id
	WHERE article_id IN (SELECT [value] FROM Global_Split(@articleIds, ','))
		AND acp.custom_property_id IN (SELECT [value] FROM Global_Split(@customPropertyIds, ','))

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleCustomPropertiesByArticleIdsCustomPropertyIdsList TO VpWebApp
GO

---------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticleOverallRatingCustomPropertyList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticleOverallRatingCustomPropertyList
	@siteId int 	
AS
-- ==========================================================================
-- $Author: Sahan
-- ==========================================================================
BEGIN

	--This query retrieves overall rating custom properties for
	--articles which are not included in the content rating table.
	
	SELECT artcp.article_custom_property_id AS id, artcp.article_id, artcp.custom_property_id,
		artcp.custom_property_value, artcp.modified, artcp.created, artcp.[enabled], cp.property_name
	FROM article_custom_property artcp
		INNER JOIN custom_property cp
			ON cp.custom_property_id = artcp.custom_property_id
		INNER JOIN article a
			ON artcp.article_id = a.article_id
		INNER JOIN (SELECT DISTINCT article_type_template.article_type_id FROM review_type
						INNER JOIN article_type_template ON review_type.article_type_template_id = article_type_template.article_type_template_id) rt 
			ON rt.article_type_id = a.article_type_id
		LEFT JOIN content_rating cr
			ON a.article_id = cr.content_id AND cr.content_type_id = 4
	WHERE cp.property_name = 'Overall' AND
		(@siteId IS NULL OR a.site_id = @siteId)  AND
		cr.content_rating_id IS NULL AND a.[enabled] = 1
END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticleOverallRatingCustomPropertyList TO VpWebApp
GO

---------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArticlesCustomPropertyList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArticlesCustomPropertyList
	@articleIds VARCHAR(MAX) 	
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SELECT article_custom_property_id as id, article_id, acp.custom_property_id, custom_property_value, acp.modified, acp.created, acp.[enabled], 
	cp.property_name
	FROM article_custom_property acp
		INNER JOIN custom_property cp
			on cp.custom_property_id = acp.custom_property_id
		INNER JOIN global_Split(@articleIds, ',') AS article_id_table
			ON acp.article_id = article_id_table.[value]

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArticlesCustomPropertyList TO VpWebApp
GO

---------------------------------------------------------------------------------

UPDATE module_instance_setting
SET value = REPLACE(value, ',', '|')
WHERE name = 'ArticleListDefaultSortByItem'

-----------------------------------------------------------------------------------