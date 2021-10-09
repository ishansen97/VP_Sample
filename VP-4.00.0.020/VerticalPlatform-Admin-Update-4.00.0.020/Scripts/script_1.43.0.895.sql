
EXEC dbo.global_DropStoredProcedure 'dbo.adminLead_GetFilteredLeadsWithPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminLead_GetFilteredLeadsWithPageList
	@leadId int = null,
	@vendorId int = null,
	@actionId int = null,
	@contentTypeId int = null,
	@contentId int = null,
	@fromDate datetime = null,
	@toDate datetime = null,
	@leadStatus varchar(50) = NULL,
	@startIndex int,
	@endIndex int,
	@noOfRows int output
AS
-- ==========================================================================
-- $Author: Chinthaka Fernando $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT [value]
	INTO #tmp_lead_status
	FROM global_Split(ISNULL(@leadStatus,''), ',');


	SELECT ROW_NUMBER() OVER (ORDER BY lead_id) AS row 
		, lead_id AS id
	INTO #temp_lead
	FROM lead WITH(NOLOCK)
	WHERE (@leadId IS NULL OR lead_id = @leadId)
		  AND (@vendorId IS NULL OR vendor_id = @vendorId)
		  AND (@actionId IS NULL OR action_id = @actionId)
		  AND (@contentTypeId IS NULL OR content_type_id = @contentTypeId)
		  AND (@contentId IS NULL OR content_id = @contentId)
		  AND (@fromDate IS NULL OR  created > @fromDate)
		  AND (@toDate IS NULL OR created < @toDate)
		  AND( @leadStatus IS NULL 
				OR lead_status_id IN
				(
				SELECT [value]
				FROM #tmp_lead_status
				))
		OPTION  (RECOMPILE);


	SELECT tmp.id, site_id, public_user_id, action_id, content_type_id
			, content_id, vendor_id, ip, ip_numeric, lead_status_id
			, archived, [enabled], modified, created, group_id, origin, lead_form_id
	FROM lead ld INNER JOIN
			#temp_lead tmp ON ld.lead_id = tmp.id
	WHERE tmp.row BETWEEN @startIndex AND @endIndex;


	SELECT @noOfRows = COUNT(*) FROM #temp_lead;

END
GO

GRANT EXECUTE ON dbo.adminLead_GetFilteredLeadsWithPageList TO VpWebApp 
GO

