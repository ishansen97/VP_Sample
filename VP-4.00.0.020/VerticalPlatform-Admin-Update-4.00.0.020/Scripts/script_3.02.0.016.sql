EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_DeletePublicUserScoreByPublicUserId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_DeletePublicUserScoreByPublicUserId
	@publicUserId int
AS
-- ==========================================================================
-- $Author: chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM public_user_score
	WHERE public_user_id = @publicUserId

END
GO

GRANT EXECUTE ON dbo.adminUser_DeletePublicUserScoreByPublicUserId TO VpAdminWeb 
GO