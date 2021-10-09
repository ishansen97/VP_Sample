
EXEC dbo.global_DropStoredProcedure 'dbo.publicCategory_GetCategoryByArticleTypeIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicCategory_GetCategoryByArticleTypeIdList
	@siteId INT ,
	@articleTypeIds VARCHAR(MAX) ,
	@childCategoryIds VARCHAR(MAX) = '' ,
	@startIndex INT ,
	@endIndex INT ,
	@totalCount INT OUTPUT
AS -- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
	BEGIN
	
		SET NOCOUNT ON;
		DECLARE	@ChildCategoryFilterEnabled BIT
		SET @ChildCategoryFilterEnabled = 0

		IF ( LEN(@childCategoryIds) > 0 ) 
			BEGIN
				SET @ChildCategoryFilterEnabled = 1
			END;

		WITH	article_type_associated_category_list
				  AS ( SELECT	ROW_NUMBER() OVER ( ORDER BY category_id ) AS row ,
								category_id AS id ,
								site_id ,
								category_name ,
								category_type_id ,
								[description] ,
								short_name ,
								specification ,
								is_search_category ,
								is_displayed ,
								[enabled] ,
								modified ,
								created ,
								matrix_type ,
								product_count ,
								auto_generated ,
								hidden ,
								has_image ,
								url_id
					   FROM		category
					   WHERE	EXISTS ( SELECT	associated_content_id ,
												[enabled] ,
												created ,
												modified ,
												site_id ,
												associated_site_id ,
												sort_order
										 FROM	content_to_content
										 WHERE	content_type_id = 4
												AND enabled = 1
												AND associated_content_id = category.category_id
												AND site_id = @siteId
												AND associated_content_type_id = 1
												AND content_id IN (
												SELECT	article_id
												FROM	article
												WHERE	site_id = @siteid
														AND enabled =  1
														AND published = 1
														AND article_type_id IN (
														SELECT
															  [value]
														FROM  Global_Split(@articleTypeIds,
															  ',') ) ) )
								AND enabled = 1
								AND ( @ChildCategoryFilterEnabled = 0
									  OR ( @ChildCategoryFilterEnabled = 1
										   AND category_id IN (
										   SELECT	[value]
										   FROM		Global_Split(@childCategoryIds,
															  ',') )
										 )
									)
					 )

			SELECT	*
			FROM	article_type_associated_category_list
			WHERE	( row BETWEEN @startIndex AND @endIndex )
					OR ( @startIndex = 0 )
			ORDER BY row

		SELECT	@totalCount = COUNT(*)
		FROM	category
		WHERE	EXISTS ( SELECT	associated_content_id ,
								[enabled] ,
								created ,
								modified ,
								site_id ,
								associated_site_id ,
								sort_order
						 FROM	content_to_content
						 WHERE	content_type_id = 4
								AND enabled = 1
								AND associated_content_id = category.category_id
								AND site_id = @siteId
								AND associated_content_type_id = 1
								AND content_id IN (
								SELECT	article_id
								FROM	article
								WHERE	site_id = @siteid
										AND enabled = 1
										AND published = 1
										AND article_type_id IN (
										SELECT	[value]
										FROM	Global_Split(@articleTypeIds,
												','))))
				AND enabled = 1
				AND ( @ChildCategoryFilterEnabled = 0
					  OR ( @ChildCategoryFilterEnabled = 1
						   AND category_id IN (
						   SELECT	[value]
						   FROM		Global_Split(@childCategoryIds, ',') )
						 )
					)
	END


GRANT EXECUTE ON dbo.publicCategory_GetCategoryByArticleTypeIdList TO VpWebApp 
