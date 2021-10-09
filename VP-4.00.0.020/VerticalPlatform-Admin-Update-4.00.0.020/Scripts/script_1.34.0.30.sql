
EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserProfileInfoBySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserProfileInfoBySiteIdList
	@siteId int,
	@pageSize int,
	@pageIndex int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH UserList AS
	(
		SELECT pup.public_user_profile_id AS id, ROW_NUMBER() OVER (ORDER BY pup.public_user_id) AS row_id, pup.public_user_id, pup.salutation, pup.first_name, pup.last_name,
			pup.address_line1, pup.address_line2, pup.city, pup.[state], pup.country_id, pup.phone_number, pup.postal_code, pup.company, pu.email
		FROM public_user pu
			INNER JOIN public_user_profile pup
				ON pu.public_user_id = pup.public_user_id
		WHERE pu.site_id = @siteId AND pu.enabled = 1 AND pu.email_optout = 0
	)
	
	SELECT id, public_user_id, salutation, first_name, last_name
		, address_line1, address_line2, city, [state], country_id, phone_number, postal_code, company
		, email
	FROM UserList
	WHERE row_id BETWEEN @startIndex AND @endIndex

END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserProfileInfoBySiteIdList TO VpWebApp 
GO
-------------
