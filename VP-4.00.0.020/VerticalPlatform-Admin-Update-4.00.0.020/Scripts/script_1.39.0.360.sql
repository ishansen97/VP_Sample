
EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetModuleSettingsByModuleNameAndValue'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].[adminPlatform_GetModuleSettingsByModuleNameAndValue]       
	@name VARCHAR(200),      
	@value VARCHAR(MAX)   
AS
   
-- ==========================================================================      
-- $Author: Sahan Diasena $      
-- ==========================================================================
    
BEGIN      
       
	SET NOCOUNT ON;
	 
	SELECT mi.module_instance_id as id, mi.page_id, mi.module_id, mi.title, mi.pane,
       mi.sort_order, mi.[enabled], mi.modified, mi.created, mi.custom_css_class,
       mi.title_link_url, mi.site_id, mi.parent_module_instance_id
	FROM module_instance mi
	INNER JOIN module_instance_setting mis
		ON mis.module_instance_id = mi.module_instance_id
	WHERE mis.name = @name 
		AND mis.[value] = @value
	       
END  
GO

GRANT EXECUTE ON dbo.adminPlatform_GetModuleSettingsByModuleNameAndValue TO VpWebApp 
GO