EXEC dbo.global_DropStoredProcedure 'dbo.adminRapid_GetRapidLogByQueueId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapid_GetRapidLogByQueueId
	@id NVARCHAR(50)
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT rl.job_id, rl.date, rl.level, rl.message, rl.exception, rl.count, rl.action
	FROM RapidLog rl
	INNER JOIN RapidJobQueue rjq
		ON rl.job_id = rjq.job_id 
			AND (rl.date BETWEEN CONVERT(VARCHAR, rjq.start_time, 20) AND CONVERT(VARCHAR, rjq.stop_time, 20))
	WHERE rjq.job_queue_id = @id
	ORDER BY rl.date DESC

END
GO

GRANT EXECUTE ON dbo.adminRapid_GetRapidLogByQueueId TO VpWebApp 
GO
