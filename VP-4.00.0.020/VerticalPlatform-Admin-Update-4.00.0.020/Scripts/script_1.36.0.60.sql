--Updates all the existing review products with search content modified flag.
UPDATE product SET search_content_modified = 1 WHERE product_id IN
(
	SELECT  ctc.associated_content_id 
	FROM content_to_content ctc
		INNER JOIN article a
			ON a.[article_id] = ctc.[content_id]
		INNER JOIN article_type_template att
			ON att.article_type_id = a.article_type_id AND att.template_id = a.article_template_id
		INNER JOIN review_type rt
			ON rt.article_type_template_id = att.article_type_template_id
	WHERE content_type_id = 4 AND associated_content_type_id = 2
)
GO
