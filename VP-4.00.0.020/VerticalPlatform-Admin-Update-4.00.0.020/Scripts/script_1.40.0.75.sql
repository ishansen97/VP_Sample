-- ==========================================================================
-- update rank column values in vendor table
-- ==========================================================================

UPDATE vendor
   SET rank = 2
 WHERE rank = 0
GO

-- ==========================================================================
-- update rank column values in product table
-- ==========================================================================
UPDATE product
   SET rank = 2,
   search_content_modified = 1,
   modified = GETDATE()
 WHERE rank=0
GO

-- ==========================================================================
-- update default rank column values in product table
-- ==========================================================================
UPDATE product
   SET default_rank = 2,
   search_content_modified = 1,
   modified = GETDATE()
 WHERE default_rank = 0
GO

-----------------------------------------------------------------------------------
IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 197 AND parameter_type = 'ArticleDetailClickthroughTypeId')
	BEGIN
		INSERT INTO parameter_type
	(
		parameter_type_id,
		parameter_type,
		[enabled],
		modified,
		created
	)
	VALUES
	(
		197,
		'ArticleDetailClickthroughTypeId',
		1,
		GETDATE(),
		GETDATE()
	)
	END
GO
-----------------------------------------------------------------------------------