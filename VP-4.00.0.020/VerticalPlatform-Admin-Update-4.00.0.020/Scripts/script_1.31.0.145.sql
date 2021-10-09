

EXEC dbo.global_DropStoredProcedure 'adminTag_GetTagsBySiteIdWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE adminTag_GetTagsBySiteIdWithPaging
	@siteId int,
	@pageIndex int,
	@pageSize int,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Sujith $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1)
	SET @endIndex = @pageSize * @pageIndex

	SELECT @numberOfRows = COUNT(*)
	FROM
	(
		SELECT [tag]
		FROM tag
			INNER JOIN content_tag
				ON tag.content_tag_id = content_tag.content_tag_id
		WHERE content_tag.site_id = @siteId
		GROUP BY [tag]
	) AS a;
	
	With temp_tag(row_id, id, content_tag_id, tag, [user_id], is_public_user, [enabled], modified, created) AS
	(		
		SELECT ROW_NUMBER() OVER (ORDER BY tag ASC) AS row_id, id, content_tag_id, tag, [user_id], 
			is_public_user, [enabled], modified, created
		FROM
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY tag ORDER BY tag ASC) AS row, tag_id AS id, tag.content_tag_id,
				 tag, [user_id], is_public_user, tag.enabled, tag.modified, tag.created
					FROM tag
						INNER JOIN content_tag
							ON tag.content_tag_id = content_tag.content_tag_id
					WHERE content_tag.site_id = @siteId 
		) AS t
		WHERE  t.row = 1
	)
	
	SELECT id, content_tag_id, tag, [user_id], is_public_user, [enabled], modified, created
	FROM temp_tag
	WHERE row_id BETWEEN @startIndex AND @endIndex
	
END
GO

GRANT EXECUTE ON adminTag_GetTagsBySiteIdWithPaging TO VpWebApp 
GO