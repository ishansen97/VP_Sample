
GO
EXEC dbo.global_DropStoredProcedure 'dbo.publicCategory_GetLeafCategoriesWithoutEnabledProducts';
GO


GO
/****** Object:  StoredProcedure [dbo].[publicCategory_GetLeafCategoriesWithoutEnabledProducts]    Script Date: 12/3/2018 10:43:16 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[publicCategory_GetLeafCategoriesWithoutEnabledProducts] @siteId INT
AS
-- ==========================================================================
-- $Date: 2010-08-17 $ 
-- $Author: chinthaka $
-- ==========================================================================
BEGIN
	SET ARITHABORT ON;
    SET NOCOUNT ON;

    SELECT category_id AS id,
           site_id,
           category_name,
           category_type_id,
           [description],
           short_name,
           specification,
           is_search_category,
           is_displayed,
           [enabled],
           modified,
           created,
           matrix_type,
           product_count,
           auto_generated,
           hidden,
           has_image,
           url_id,
           sort_order
    FROM dbo.category WITH(NOLOCK)
    WHERE category_id NOT IN (
                                 SELECT cat.category_id
                                 FROM dbo.category cat WITH(NOLOCK)
                                     INNER JOIN dbo.product_to_category procat WITH(NOLOCK)
                                         ON procat.category_id = cat.category_id
                                     INNER JOIN dbo.product pro WITH(NOLOCK)
                                         ON pro.product_id = procat.product_id
                                 WHERE pro.enabled = 1
                                       AND procat.enabled = 1
										AND cat.category_type_id = 4 --leaf category
										AND cat.site_id = @siteId
                             )
    AND category_type_id = 4 --leaf category
	and	enabled = 1
    AND site_id = @siteId;

END;


GO
GRANT EXECUTE
ON dbo.publicCategory_GetLeafCategoriesWithoutEnabledProducts
TO  VpWebApp;
GO

