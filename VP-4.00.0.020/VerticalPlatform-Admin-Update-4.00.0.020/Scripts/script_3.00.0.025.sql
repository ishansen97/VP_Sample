
--adminRapidTask_UpdateRapidTask

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidTask_UpdateRapidTask'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminRapidTask_UpdateRapidTask]
	@id INT OUTPUT,
	@rapid_job_id INT,
    @rapid_status_id INT,
    @rapid_task_type_id INT,
	@start_time smalldatetime,
	@end_time smalldatetime,
	@enabled BIT,
	@is_error BIT,
	@error_message VARCHAR(1000),
	@inserted_records INT,
	@updated_records INT,
	@deleted_records INT,
	@error_records INT,
	@report_path VARCHAR(1000),
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Deshapriya
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.rapid_task
	SET rapid_job_id = @rapid_job_id,
		rapid_status_id = @rapid_status_id,
		rapid_task_type_id = @rapid_task_type_id,
		start_time = CASE WHEN rapid_status_id IN(1,2) AND @rapid_status_id = 3 THEN GETDATE() ELSE start_time END,
		end_time = CASE WHEN rapid_status_id = 3 AND @rapid_status_id = 4 THEN GETDATE() ELSE end_time END,
		enabled = @enabled,
		is_error = @is_error,
		error_message  = @error_message,
		inserted_records  = @inserted_records,
		updated_records  = @updated_records,
		deleted_records  = @deleted_records,
		error_records  = @error_records,
		report_path = @report_path,
		modified = @modified
	WHERE rapid_task_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidTask TO VpWebApp
GO


