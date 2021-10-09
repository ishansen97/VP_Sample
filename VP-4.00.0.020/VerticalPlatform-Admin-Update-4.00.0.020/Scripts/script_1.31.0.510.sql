IF NOT EXISTS (SELECT content_type FROM content_type WHERE content_type = 'FixedGuidedBrowse')
BEGIN
	INSERT INTO content_type (content_type_id,content_type, enabled, modified, created)
	VALUES ('36','FixedGuidedBrowse', 1, GETDATE(), GETDATE())
END
GO

------------------------------------------------------------------------------
INSERT INTO fixed_url
SELECT fixed_url, site_id, page_id, content_type_id, content_id,query_string ,[enabled], 
	created, modified, include_in_sitemap
FROM 
	(SELECT '/' + CAST(fixed_guided_browse_id AS VARCHAR) + '-' + REPLACE(name,' ','') + '/' AS fixed_url, 
		 c.site_id, p.page_id, 36 AS content_type_id, fgb.fixed_guided_browse_id AS content_id,
		 '' AS query_string, 1 AS [enabled], GETDATE() AS created, GETDATE() AS modified, 1 AS include_in_sitemap
	FROM fixed_guided_browse fgb
		INNER JOIN category c
			ON fgb.category_id = c.category_id
		INNER JOIN page p
			ON p.site_id = c.site_id
	WHERE fixed_guided_browse_id 
		NOT IN 
		(
			SELECT content_id FROM fixed_url 
			WHERE content_type_id = 36
		) 
		AND p.page_name = 'BrowseCategory'
	 ) urls
	 