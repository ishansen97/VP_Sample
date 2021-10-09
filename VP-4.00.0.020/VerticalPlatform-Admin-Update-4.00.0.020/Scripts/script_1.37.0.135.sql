-- VP-8791
DELETE FROM category_search_aspect_content
WHERE content_type_id = 2 AND 
		content_name = 'categories.description' AND 
		content_id = 5
		
DELETE FROM content_relevancy
WHERE content_type_id = 1 AND
		content_property_name = 'description'
----------------------------------------------------------------