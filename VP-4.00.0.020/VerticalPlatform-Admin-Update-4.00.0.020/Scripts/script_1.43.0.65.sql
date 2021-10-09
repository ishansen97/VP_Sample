EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetEnabledSearchOptions'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetEnabledSearchOptions
	@optionIds varchar(max)

AS
-- ==========================================================================
-- $ Author : Akila Tharuka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled, so.modified
	FROM search_option so
	INNER JOIN global_Split(@optionIds, ',') p
		ON p.[value] = so.search_option_id
	WHERE so.enabled = 1

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetEnabledSearchOptions TO VpWebApp 
GO