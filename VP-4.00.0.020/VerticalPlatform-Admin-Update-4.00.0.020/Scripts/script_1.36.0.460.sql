
--Rifaz Rifky
--VP-8226

DECLARE @siteId INT
SET @siteId = 0

DECLARE siteIdCursor CURSOR FOR
	SELECT [site_id]
	FROM [site]
	
OPEN siteIdCursor
FETCH NEXT FROM siteIdCursor
INTO @siteId

WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS(SELECT * FROM [specification_type] WHERE [site_id] = @siteId AND [spec_type] = 'SEO Description')
		BEGIN
			INSERT INTO [specification_type]
				([spec_type],[validation_expression],[site_id],[enabled]
				,[modified],[created],[is_visible],[search_enabled]
				,[is_expanded_view],[legacy_content_id],[display_empty])
			VALUES
				('SEO Description','',@siteId,1,GETDATE(),GETDATE(),0
				,0,0,NULL,0)
		END
	
	FETCH NEXT FROM siteIdCursor
	INTO @siteId
END

CLOSE siteIdCursor
DEALLOCATE siteIdCursor
---------------------------------------------------------------------------------------------------------------------------