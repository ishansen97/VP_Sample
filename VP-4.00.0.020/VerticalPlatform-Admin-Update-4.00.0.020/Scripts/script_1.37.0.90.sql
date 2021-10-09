DECLARE	@now DATETIME

SET @now = GETDATE()
IF NOT EXISTS ( SELECT	*
				FROM	dbo.parameter_type
				WHERE	parameter_type_id = 181 ) 
	BEGIN
		INSERT	dbo.parameter_type
				( parameter_type_id ,
				  parameter_type ,
				  enabled ,
				  modified ,
				  created
				)
		VALUES	( 181 , -- parameter_type_id - int
				  'PermanentlyDisabledProduct' , -- parameter_type - varchar(50)
				  1 , -- enabled - bit
				  @now , -- modified - smalldatetime
				  @now  -- created - smalldatetime
				)
	END

GO 

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList
	@siteId int,
	@batchSize int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT TOP(@batchSize) scs.search_content_status_id AS id, scs.site_id, scs.content_type_id, scs.content_id, scs.[enabled], scs.created, scs.modified
	FROM search_content_status scs
		INNER JOIN product p
			ON scs.content_id = p.product_id
	WHERE scs.content_type_id = 2 AND scs.site_id = @siteId AND p.enabled = 0 AND p.hidden = 0
		
	SELECT @totalCount = COUNT(*)
	FROM search_content_status scs
		INNER JOIN product p
			ON scs.content_id = p.product_id
	WHERE scs.content_type_id = 2 AND scs.site_id = @siteId AND p.enabled = 0 AND p.hidden = 0

END
GO

GRANT EXECUTE ON dbo.adminSearch_GetDeletedOrDisabledProductSearchContentsList TO VpWebApp 
GO
