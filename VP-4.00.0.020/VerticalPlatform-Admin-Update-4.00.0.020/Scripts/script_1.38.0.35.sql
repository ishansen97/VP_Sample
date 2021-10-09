EXEC dbo.global_DropStoredProcedure 'dbo.publicArticles_SearchArticleContentList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticles_SearchArticleContentList
	@siteIds varchar(200),
	@searchText varchar(200),
	@databaseResults int,
	@articleTypeIds varchar(200),
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS

-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================

BEGIN	

	SELECT article_id AS id, article_type_id, site_id, article_title, article_summary, date_published, external_url_id,
		[enabled], modified, created, article_short_title, is_article_template, is_external, featured_identifier,
		thumbnail_image_code, article_template_id, open_new_window, start_date, end_date, published, flag1, flag2, 
		flag3, flag4, search_content_modified, deleted
	FROM article
	WHERE  	(@articleTypeIds IS NULL OR article_type_id IN (SELECT [value] FROM Global_Split(@articleTypeIds, ','))) AND
			((flag1 & @countryFlag1 > 0) OR (flag2 & @countryFlag2 > 0) OR (flag3 & @countryFlag3 > 0) OR (flag4 & @countryFlag4 > 0)) AND
			article_id IN
			(
				SELECT TOP(@databaseResults) content_id
				FROM FREETEXTTABLE(content_text, *, @searchText) RankedTable
					INNER JOIN content_text
						ON [KEY] = content_text.content_text_id AND content_text.site_id IN (SELECT [value] FROM Global_Split(@siteIds, ','))
				WHERE content_text.enabled = 1 AND content_text.content_type_id = 4
				ORDER BY RankedTable.RANK DESC	
			)
	
END
GO

GRANT EXECUTE ON dbo.publicArticles_SearchArticleContentList TO VpWebApp 
GO
