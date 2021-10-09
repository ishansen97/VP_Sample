EXEC dbo.global_DropStoredProcedure 'dbo.publicUser_GetPublicUserEmailOptoutsForPublicUserList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicUser_GetPublicUserEmailOptoutsForPublicUserList
	@publicUserId int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT public_user_email_optout_id as id, public_user_id, feedback, userfields, [enabled], modified, created
	FROM public_user_email_optout
	WHERE public_user_id = @publicUserId

END
GO

GRANT EXECUTE ON dbo.publicUser_GetPublicUserEmailOptoutsForPublicUserList TO VpWebApp 
GO

----

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsByGroupIdVendorIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsByGroupIdVendorIdsList
	@groupId int,
	@vendorIds varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT s.search_option_id AS id, s.search_group_id, s.[name], s.sort_order, s.created, s.enabled, s.modified
	FROM search_option s
		INNER JOIN product_to_search_option po
			ON po.search_option_id = s.search_option_id
		INNER JOIN product_to_vendor pv
			ON pv.product_id = po.product_id
	WHERE search_group_id = @groupId
		AND pv.vendor_id IN (SELECT [value] FROM global_Split(@vendorIds, ','))
	ORDER BY sort_order ASC, [name] ASC
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsByGroupIdVendorIdsList TO VpWebApp 
GO

---

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetSearchOptionsByCategorySearchGroupIdVendorIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetSearchOptionsByCategorySearchGroupIdVendorIdsList
	@categorySearchGroupId int,
	@vendorIds varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled,so.modified
	FROM search_option so
		INNER JOIN	category_to_search_group_to_search_option cgo
			ON cgo.search_option_id = so.search_option_id
		INNER JOIN product_to_search_option po
			ON po.search_option_id = so.search_option_id
		INNER JOIN product_to_vendor pv
			ON pv.product_id = po.product_id
	WHERE cgo.category_to_search_group_id = @categorySearchGroupId
		AND pv.vendor_id IN (SELECT [value] FROM global_Split(@vendorIds, ','))  
	ORDER BY cgo.sort_order ASC, so.[name] ASC

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetSearchOptionsByCategorySearchGroupIdVendorIdsList TO VpWebApp 
GO

----