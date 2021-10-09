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
  sg.[description], sg.add_options_automatically, sg.prefix_text, sg.suffix_text,  
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
