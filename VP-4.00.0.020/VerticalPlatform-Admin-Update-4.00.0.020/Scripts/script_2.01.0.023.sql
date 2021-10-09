EXEC dbo.global_DropStoredProcedure 'adminRapidTask_UpdateRapidTask';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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
	@modified smalldatetime output
AS
-- ==========================================================================
-- Author : Madushan
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
		modified = @modified
	WHERE rapid_task_id = @id
	
END
GO

GRANT EXECUTE ON dbo.adminRapidTask_UpdateRapidTask TO VpWebApp 
GO


-- ==========================================================================

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_IsIncompleteRapidJobs'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_IsIncompleteRapidJobs
 @vendor_id int,
 @boolean_val int output  

AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF (EXISTS (SELECT TOP (1) rapid_job_id
			FROM rapid_job
			WHERE vendor_id = @vendor_id AND
			rapid_status_id NOT IN (4,5)))
		BEGIN
			SELECT @boolean_val = 1
		END
	ELSE
		BEGIN
			SELECT @boolean_val = 0
		END	


END
GO

GRANT EXECUTE ON dbo.adminRapidJob_IsIncompleteRapidJobs TO VpWebApp 
GO

-- ==========================================================================

EXEC dbo.global_DropStoredProcedure 'dbo.adminRapidJob_IsSyncPending'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminRapidJob_IsSyncPending
 @vendor_id int,
 @boolean_val int output  

AS
-- ==========================================================================
-- Author: Madushan
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF (EXISTS (SELECT (1)
			FROM product p INNER JOIN product_to_vendor pv WITH(NOLOCK) ON p.product_id = pv.product_id
			WHERE pv.vendor_id = @vendor_id AND
			p.content_modified = 1))
		BEGIN
			SELECT @boolean_val = 1
		END
	ELSE
		BEGIN
			SELECT @boolean_val = 0
		END	

END	
GO

GRANT EXECUTE ON dbo.adminRapidJob_IsSyncPending TO VpWebApp 
GO