EXEC dbo.global_DropStoredProcedure 'dbo.adminCitation_GetCitationByProductIdDuration'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminCitation_GetCitationByProductIdDuration
	@productId INT,
	@duration INT,
	@sortParams NVARCHAR(MAX)
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [citation_id] AS [id],[product_id],[title],[journal_name],[published_date]
			,[scrazzl_url],[article_url],[doi],[enabled],[created],[modified],[authors]
	FROM [citation]
	WHERE product_id = @productId AND created >= DATEADD(MONTH, (-1 * @duration), GETDATE())
	ORDER BY 
			CASE WHEN @sortParams = 'title asc' THEN title END ASC ,
			CASE WHEN @sortParams = 'title desc' THEN title END DESC,
			CASE WHEN @sortParams = 'journal_name asc' THEN journal_name END ASC,
			CASE WHEN @sortParams = 'journal_name desc' THEN journal_name END DESC,
			CASE WHEN @sortParams = 'published_date asc' THEN published_date END ASC,
			CASE WHEN @sortParams = 'published_date desc' THEN published_date END DESC
END
GO

GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDuration TO VpWebApp
GRANT EXECUTE ON dbo.adminCitation_GetCitationByProductIdDuration TO VpWebAPI
GO