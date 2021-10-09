EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_DepreciatePublicUserScore'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_DepreciatePublicUserScore
	@depreciationRate float,
	@window int,
	@batchSize int,
	@rowCount INT OUTPUT
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE TOP(@batchSize) pus
	SET pus.public_user_score = (pus.public_user_score - (pus.public_user_score * (@depreciationRate/100))),
		pus.depreciated_timestamp = GETDATE(),
		pus.modified = GETDATE()
	FROM public_user_score pus
	WHERE (GETDATE() > DATEADD(HOUR, @window, pus.depreciated_timestamp) OR pus.depreciated_timestamp IS NULL)
		AND pus.public_user_score > 0
		
	SELECT @rowCount = @@ROWCOUNT

END
GO

GRANT EXECUTE ON dbo.adminUser_DepreciatePublicUserScore TO VpWebApp 
GO

---------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_UnsubscribeSubscribersListByScore'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_UnsubscribeSubscribersListByScore
	@optOutScore int,
	@batchSize int,
	@rowCount INT OUTPUT
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE TOP(@batchSize) pu
	SET pu.email_optout = 1,
		pu.modified = GETDATE()
	FROM public_user_score pus
	INNER JOIN public_user pu 
		ON pu.public_user_id = pus.public_user_id
	WHERE pu.email_optout = 0
		AND pus.public_user_score <= @optOutScore
	
	SELECT @rowCount = @@ROWCOUNT

END
GO

GRANT EXECUTE ON dbo.adminUser_UnsubscribeSubscribersListByScore TO VpWebApp 
GO