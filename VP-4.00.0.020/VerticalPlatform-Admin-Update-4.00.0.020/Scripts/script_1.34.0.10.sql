EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCompressionGroupsByGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCompressionGroupsByGroupIdList  
 @compressionGroupIds varchar(4000)  
AS  
-- ==========================================================================  
-- $ Author : Rifaz Rifky $  
-- ==========================================================================  
BEGIN  
  
	SET NOCOUNT ON;  

	SELECT pcg.[product_compression_group_id] AS [Id], pcg.[site_id], pcg.[show_in_matrix], pcg.[show_product_count], pcg.[group_title], pcg.[expand_products]
      , pcg.[enabled], pcg.[created], pcg.[modified], pcg.[is_default], pcg.[group_name], pcg.[sort_order]
	FROM [product_compression_group] pcg
		INNER JOIN global_split(@compressionGroupIds, ',') AS temp_groupId
		ON pcg.[product_compression_group_id] = temp_groupId.[value]
	ORDER BY pcg.[product_compression_group_id]
	
END  
GO

GRANT EXECUTE ON dbo.adminProduct_GetCompressionGroupsByGroupIdList TO VpWebApp 
GO
