--- Adding review status to existing review articles.
IF NOT EXISTS (SELECT * FROM content_parameter WHERE content_parameter_type = 'ReviewArticleStatus')
BEGIN
	INSERT INTO content_parameter (content_type_id, content_id, content_parameter_type, content_parameter_value, enabled, created, modified)
	SELECT 4, article.article_id, 'ReviewArticleStatus', 
		CASE WHEN article.published = 1 AND article_to_author.gift_card_id <> '' THEN '4'
		WHEN  article.published = 1 AND article_to_author.gift_card_id IS NULL OR article_to_author.gift_card_id <> '' THEN '1'
		ELSE '3' END, 
		1, GETDATE(), GETDATE()  FROM article 
	INNER JOIN article_type_template att
		ON article.article_type_id = att.article_type_id 
			AND article.article_template_id = att.template_id
	INNER JOIN review_type ON review_type.article_type_template_id = att.article_type_template_id
	LEFT OUTER JOIN article_to_author ON article.article_id = article_to_author.article_id
END
GO