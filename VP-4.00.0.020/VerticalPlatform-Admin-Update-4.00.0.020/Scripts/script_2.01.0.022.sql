


EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateRapidReportTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateRapidReportTask]
	@id INT,
    @rapid_status_id INT,
	@duration DECIMAL (14,2),
	@inserted_records INT,
	@updated_records INT,
	@deleted_records INT,
	@error_records INT,
	@error_message VARCHAR,
	@is_error BIT

AS
-- ==========================================================================
-- Author : Deshapriya
-- ==========================================================================
BEGIN

	DECLARE @endtime DATETIME = GETDATE()
	UPDATE dbo.rapid_task
	SET rapid_status_id = @rapid_status_id,	
	start_time = DATEADD(second, -@duration, @endtime),	
	end_time = @endtime,	
	inserted_records = @inserted_records,
	updated_records = @updated_records,
	deleted_records = @deleted_records,
	error_records = @error_records,
	error_message = @error_message,
	is_error = @is_error,
	modified = @endtime
	WHERE rapid_task_id = @id
		
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidReportTask TO VpWebApp 
GO