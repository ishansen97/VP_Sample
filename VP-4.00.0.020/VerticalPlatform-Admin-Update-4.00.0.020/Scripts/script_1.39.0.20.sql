EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetFixedGuidedBrowses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetFixedGuidedBrowses
	@ids VARCHAR(MAX)

AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_guided_browse_id AS id, category_id, [name], segment_size, prefix_text, 
		suffix_text, naming_rule, build_option_list, is_dynamic, [enabled], created, modified, include_in_sitemap, is_clean, prebuilt
	FROM fixed_guided_browse fgb
	INNER JOIN dbo.global_Split(@ids, ',') gs
		ON fgb.fixed_guided_browse_id = gs.value

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetFixedGuidedBrowses TO VpWebApp 
GO

--------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryParameterByParameterTypeParameterValueSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryParameterByParameterTypeParameterValueSiteIdList
	@parameterTypeId int,
	@siteId int,
	@parameterValue varchar(max)
AS
-- ==========================================================================
-- $Author Sahan Diasena
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT cp.category_parameter_id AS id, cp.category_id, cp.parameter_type_id, cp.category_parameter_value, cp.[enabled],
		 cp.modified, cp.created
	FROM category_parameter cp
		INNER JOIN category c
			ON c.category_id = cp.category_id
	WHERE cp.parameter_type_id = @parameterTypeId 
		AND c.site_id = @siteId
		AND (cp.category_parameter_value = @parameterValue
			OR cp.category_parameter_value LIKE '%,'+ @parameterValue +',%' 
			OR cp.category_parameter_value LIKE '%,'+ @parameterValue 
			OR cp.category_parameter_value LIKE @parameterValue + ',%' )

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryParameterByParameterTypeParameterValueSiteIdList TO VpWebApp 
GO