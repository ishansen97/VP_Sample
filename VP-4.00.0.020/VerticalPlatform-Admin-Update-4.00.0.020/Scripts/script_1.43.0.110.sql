EXEC dbo.global_DropStoredProcedure 'dbo.adminSearchCategory_DeleteSearchOptionToSearchOptionsByChildOptionIdBySearchGroupId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearchCategory_DeleteSearchOptionToSearchOptionsByChildOptionIdBySearchGroupId
	@searchGroupId int
AS
-- ==========================================================================
-- $Author : Akila $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE soToSo
	FROM [search_option_to_search_option] soToSo 
	INNER JOIN [search_option] so
	ON so.search_option_id = soToSo.child_option_id
	where so.search_group_id = @searchGroupId

END
GO

GRANT EXECUTE ON dbo.adminSearchCategory_DeleteSearchOptionToSearchOptionsByChildOptionIdBySearchGroupId TO VpWebApp 
GO