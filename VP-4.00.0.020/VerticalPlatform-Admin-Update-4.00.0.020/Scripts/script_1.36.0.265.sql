EXEC dbo.global_DropStoredProcedure 'dbo.adminSiteMaps_GetSearchCategories'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminSiteMaps_GetSearchCategories]

@siteId int

AS

BEGIN

	SELECT DISTINCT

		  '/pfu/' + CONVERT(varchar(30), fu.[fixed_url_id]) + '/soids/'

			+ CONVERT(varchar(30), so.[search_option_id]) + '/' 

			+ isnull(replace(c.[category_name], ' ', '_'), '_') + '/' AS fixed_url

		, c.[category_name]

		, csg.[category_id]

		, csg.[search_group_id]

		, sg.[name] AS group_name

		, so.[search_option_id]

		, so.[name] AS option_name

		, CONVERT(varchar(10), GETDATE(), 110) as changedDate

		, 'Monthly' as frequency

		, 1 as priority

	FROM [dbo].[category_to_search_group] csg WITH ( NOLOCK )

	INNER JOIN [dbo].[category] c WITH ( NOLOCK )

		ON csg.[category_id] = c.[category_id]

	INNER JOIN [dbo].[search_group] sg WITH ( NOLOCK )

		ON csg.[search_group_id] = sg.[search_group_id]

	INNER JOIN [dbo].[search_option] so WITH ( NOLOCK )

		ON sg.[search_group_id] = so.[search_group_id]

	INNER JOIN [dbo].[fixed_url] fu WITH ( NOLOCK ) 

		ON fu.[content_id] = c.[category_id]

			AND c.[site_id] = fu.[site_id]

			AND fu.[content_type_id] = 1

	WHERE c.[site_id] = @siteId

		AND csg.[browsable] = 1

		AND csg.[enabled] = 1

		AND c.[enabled] = 1

		AND sg.[enabled] = 1

		AND so.[enabled] = 1

		AND fu.[enabled] = 1

		AND ( csg.[browse_sort_order] > 0

			  OR ( csg.[category_id] = 10940

				   AND csg.[sort_order] > 0

				 )

			)

		AND c.[is_search_category] = 1

		AND c.[category_name] IS NOT NULL

		AND so.[name] IS NOT NULL

		AND fu.[fixed_url] IS NOT NULL

		AND so.[search_option_id] IN 

			(

				SELECT sso.search_option_id

				FROM [dbo].[product_to_search_option] sso WITH ( NOLOCK )

				INNER JOIN [dbo].[product_to_category] pc WITH ( NOLOCK )

					ON sso.[product_id] = pc.[product_id] 

				WHERE sso.[enabled] = 1

					AND pc.[enabled] = 1

					AND pc.[category_id] = c.[category_id]

					AND pc.[product_id] IN 

					(

						SELECT [product_id]

						FROM [dbo].[product] WITH ( NOLOCK )

						WHERE [site_id] = @siteid

							AND [enabled] = 1

					)

			)

	ORDER BY csg.[category_id],

			so.[name]

END

GO

GRANT EXECUTE ON dbo.adminSiteMaps_GetSearchCategories TO VpWebApp 
GO
--------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_SearchContent'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_SearchContent
	@siteId int,
	@searchFor varchar(200),
	@numberOfRecords int,
	@targetContentTypeId int
AS

-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicSearch_SearchContent.sql $
-- $Revision: 5214 $
-- $Date: 2010-05-10 16:50:51 +0530 (Mon, 10 May 2010) $ 
-- $Author: Nilanka $
-- ==========================================================================

BEGIN	

	SELECT TOP(@numberOfRecords) [KEY] AS id, RankedTable.RANK AS relevance
		, site_id, content_type_id, content_id
		, (SELECT CASE content_text.content_type_id 
			WHEN @targetContentTypeId THEN 4 -- Need to get the target content type at top
			WHEN 1 THEN 3 -- category
			WHEN 2 THEN 2 -- product
			WHEN 3 THEN 1 -- specification
			ELSE content_text.rank END) AS rank
		, enabled, modified, created

	FROM FREETEXTTABLE(content_text, *, @searchFor) RankedTable
		INNER JOIN content_text
			ON [KEY] = content_text.content_text_id 
			AND content_text.site_id = @siteId
	WHERE enabled = '1'
	ORDER BY rank DESC, relevance DESC, content_id DESC
END
GO

GRANT EXECUTE ON dbo.publicSearch_SearchContent TO VpWebApp 
GO

-------------------------------------






