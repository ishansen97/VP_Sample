EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetPagebySiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetPagebySiteIdList
@siteId int
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	SET NOCOUNT ON;

	SELECT  page_id AS id, site_id, predefined_page_id, parent_page_id, page_name
	, page_title, page_title_prefix, page_title_suffix, description_prefix, description_suffix
	, keywords, template_name, sort_order, navigable, hidden,log_in_to_view
	, [enabled], modified, created, navigation_title, default_title_prefix
	FROM page
	WHERE site_id = @siteId
	ORDER BY parent_page_id, sort_order
END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetPagebySiteIdList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentSearchGroupSearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicSearchCategory_GetFixedGuidedBrowseAllSegmentSearchGroupSearchOptionsList]
	@categoryId int,
	@searchGroupId int,
	@selectedOptions varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	-- Populate primary search option ids
	CREATE TABLE #PrimarySearchOption (search_option_id int)
	INSERT INTO #PrimarySearchOption
	SELECT DISTINCT s.search_option_id
	FROM search_option s
		INNER JOIN product_to_search_option ps
			ON ps.search_option_id = s.search_option_id
		INNER JOIN product_to_category pc
			ON pc.product_id = ps.product_id
		INNER JOIN product p
			ON p.product_id = pc.product_id
	WHERE s.enabled = 1 AND s.search_group_id = @searchGroupId AND p.enabled = 1 AND pc.enabled = 1 AND p.show_in_matrix = 1

	-- Populate secondary search option ids
	CREATE TABLE #SecondarySearchOption (search_option_id int)
	INSERT INTO #SecondarySearchOption
	SELECT [VALUE] FROM global_split(@selectedOptions, ',')
	
	-- Find number of rows in secondary option ids
	DECLARE @secondarySearchOptionCount int
	SELECT @secondarySearchOptionCount = COUNT(*) FROM #SecondarySearchOption

	-- Find products having at least one primary option and all secondary options
	CREATE TABLE #FilteredProduct (product_id int)
	INSERT INTO #FilteredProduct
	SELECT ps.product_id
	FROM product_to_search_option ps
	WHERE ps.product_id IN 
	(
		SELECT product_id
		FROM product_to_search_option so
			INNER JOIN #PrimarySearchOption
				ON so.search_option_id = #PrimarySearchOption.search_option_id
	)
	AND ps.search_option_id IN
	(
		SELECT search_option_id
		FROM #SecondarySearchOption
	)
	GROUP BY ps.product_id
	HAVING COUNT(ps.search_option_id) = @secondarySearchOptionCount

	-- Select search options in primary option list having products in filtered products list
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id
		FROM product_to_search_option ps
			INNER JOIN #FilteredProduct
				ON ps.product_id = #FilteredProduct.product_id
		WHERE search_option_id IN
		(
			SELECT search_option_id
			FROM #PrimarySearchOption
		)
	)
	ORDER BY [name]

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentSearchGroupSearchOptionsList TO VpWebApp 
GO

------------------------Spider related modifications (VP-7740)------
IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'access_code' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[spider_ip_address]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [dbo].[spider_ip_address]
	ADD [access_code] [varchar](1000) NULL  
END
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_AddIpAddress'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_AddIpAddress
	@id int output,
	@ipAddress varchar(50),
	@ipNumeric bigint,
	@requestIpGroupId int,
	@blocked bit,
	@description varchar(1000),
	@accessCode varchar(1000),
	@country varchar(250),
	@owner varchar(500),
	@enabled bit,
	@created smalldatetime output
AS

BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO spider_ip_address(ip_address, ip_numeric,ip_group_id, blocked_status, description,access_code, enabled, modified, created, country, [owner])
	VALUES (@ipAddress, @ipNumeric, @requestIpGroupId, @blocked, @description, @accessCode, @enabled, @created, @created, @country, @owner)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_AddIpAddress TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_UpdateIpAddress'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_UpdateIpAddress
	@id int,
	@ipAddress varchar(50),
	@ipNumeric bigint,
	@requestIpGroupId int,
	@blocked int,
	@description varchar(1000),
	@accessCode varchar(1000),
	@enabled bit,
	@country varchar(250),
	@owner varchar(500),
	@modified smalldatetime output	
	 
AS

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.spider_ip_address
	SET ip_address = @ipAddress,
		ip_numeric = @ipNumeric,
		ip_group_id = @requestIpGroupId,
		blocked_status = @blocked,
		country = @country,
		[owner] = @owner,
		description = @description,
		access_code = @accessCode,
		[enabled] = @enabled,		
		modified = @modified		
	WHERE ip_address_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_UpdateIpAddress TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging
	@groupId int,
	@blockedStatus int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@pageSize int,
	@pageIndex int,
	@totalCount int output,
	@ipaddress varchar(50),
	@ipnumeric bigint

AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (row, ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner], [access_code])
	AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner], [access_code]
		FROM spider_ip_address
		WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
				(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
				((@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate)) AND
				(((@ipaddress IS NULL OR ip_address LIKE @ipaddress)) AND ((@ipnumeric = 0 OR ip_numeric = @ipnumeric)))
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner], [access_code]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)			  

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
			(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
			((@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate)) AND
			(((@ipaddress IS NULL OR ip_address LIKE @ipaddress)) AND ((@ipnumeric = 0 OR ip_numeric = @ipnumeric)))

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging TO VpWebApp 
GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetUngroupedIPAddressList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetUngroupedIPAddressList
	@pageSize int,
	@pageIndex int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (idRowDesc, ipRow, ipRowDesc, modifiedRow, modifiedRowDesc, 
								ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner], [access_code])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS idRowDesc, 
				ROW_NUMBER() OVER (ORDER BY ip_address ASC) AS ipRow,
			    ROW_NUMBER() OVER (ORDER BY ip_address DESC) AS ipRowDesc, 
				ROW_NUMBER() OVER (ORDER BY modified ASC) AS modifiedRow,
				ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedRowDesc, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner], [access_code]
		FROM spider_ip_address
		WHERE  ip_group_id is null 
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner], [access_code]
	FROM temp_request_ip_address
	WHERE (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'ip' AND @sortOrder = 'asc' AND ipRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'ip' AND @sortOrder = 'desc' AND ipRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex)	

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE  ip_group_id is null

END
GO


GRANT EXECUTE ON dbo.adminSpiderManagement_GetUngroupedIPAddressList TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressList
	
AS

BEGIN
	
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, 
		[description], [enabled], created, modified, country, [owner], [access_code]
	FROM spider_ip_address	

END

GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressList TO VpWebApp 
GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIpAddressDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIpAddressDetail
	@id int
	
AS

BEGIN
	
	SET NOCOUNT ON;

	SELECT ip_address_id as id, ip_address, ip_numeric, ip_group_id, blocked_status, description, enabled, created, modified, country, [owner], [access_code]
	FROM spider_ip_address	
	WHERE ip_address_id = @id 

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIpAddressDetail TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByType
	@blocked int

AS

BEGIN
	--
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner], [access_code]
	FROM spider_ip_address
	WHERE blocked_status = @blocked

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByType TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByIPDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByIPDetail
	@ip varchar(50)
AS

BEGIN
	
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, 
		[description], [enabled], created, modified, country, [owner], [access_code]
	FROM spider_ip_address	
	WHERE ip_address = @ip

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByIPDetail TO VpWebApp 
GO
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByGroupWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByGroupWithPaging
	@groupId int,
	@pageSize int,
	@pageIndex int,	
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (row, ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner], [access_code])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner], [access_code]
		FROM spider_ip_address
		WHERE ip_group_id = @groupId
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner], [access_code]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE ip_group_id = @groupId

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByGroupWithPaging TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByGroupWithPagingSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByGroupWithPagingSorting
	@groupId int,
	@pageSize int,
	@pageIndex int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (idRowDesc, ipRow, ipRowDesc, modifiedRow, modifiedRowDesc, 
								ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner], [access_code])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS idRowDesc, 
				ROW_NUMBER() OVER (ORDER BY ip_address ASC) AS ipRow,
			    ROW_NUMBER() OVER (ORDER BY ip_address DESC) AS ipRowDesc, 
				ROW_NUMBER() OVER (ORDER BY modified ASC) AS modifiedRow,
				ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedRowDesc, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner], [access_code]
		FROM spider_ip_address
		WHERE ip_group_id = @groupId
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner], [access_code]
	FROM temp_request_ip_address
	WHERE (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'ip' AND @sortOrder = 'asc' AND ipRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'ip' AND @sortOrder = 'desc' AND ipRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex)	

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE ip_group_id = @groupId

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByGroupWithPagingSorting TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByGroup
	@groupId int

AS

BEGIN
	--
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner], [access_code]
	FROM spider_ip_address
	WHERE ip_group_id = @groupId

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByGroup TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetAllIPAddresses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetAllIPAddresses
	
AS

BEGIN
	--
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, [description], 
			[enabled], modified, created, country, [owner], [access_code]
	FROM spider_ip_address	

END

GRANT EXECUTE ON dbo.adminSpiderManagement_GetAllIPAddresses TO VpWebApp 
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetUngroupedIPListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetUngroupedIPListWithPaging
	@pageSize int,
	@pageIndex int,
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (row, ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner], [access_code])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner], [access_code]
		FROM spider_ip_address
		WHERE  ip_group_id is null 
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner], [access_code]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)			  

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE  ip_group_id is null

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetUngroupedIPListWithPaging TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'start_date' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[application_message]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [dbo].[application_message]
	ADD start_date smalldatetime
END
GO

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'end_date' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[application_message]') AND type in (N'U'))
)
BEGIN
	ALTER TABLE [dbo].[application_message]
	ADD end_date smalldatetime
END
GO

----

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddApplicationMessage
	@siteId int,
	@applicationType int, 
	@messageType int, 
	@messageText varchar(5000),
	@show bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@startDate smalldatetime,
	@endDate smalldatetime
AS
-- ==========================================================================
-- $Author: Nilanka $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO application_message(site_id, application_type, message_type, message_text, show, [enabled], created, modified, start_date, end_date)
	VALUES (@siteId, @applicationType, @messageType, @messageText, @show, @enabled, @created, @created,@startDate,@endDate)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddApplicationMessage TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateApplicationMessage'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateApplicationMessage
	@id int,
	@siteId int,
	@applicationType int, 
	@messageType int, 
	@messageText varchar(5000),
	@show bit,
	@enabled bit,
	@modified smalldatetime output,
	@startDate smalldatetime,
	@endDate smalldatetime
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE application_message
	SET site_id = @siteId,
		application_type = @applicationType,
		message_type = @messageType,
		message_text = @messageText,
		show = @show,
		enabled = @enabled,
		modified = @modified,
		start_date = @startDate ,
		end_date= @endDate
	WHERE application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateApplicationMessage TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetApplicationMessageDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetApplicationMessageDetail
	@id int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT application_message_id AS id, site_id, application_type, message_type, message_text, show, [created], [enabled], [modified],start_date,end_date
	FROM application_message
	WHERE application_message_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetApplicationMessageDetail TO VpWebApp 
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetApplicationMessages'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetApplicationMessages
	@siteId int,
	@applicationType int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	SELECT application_message_id AS id, site_id, application_type, message_type, message_text, show, [created], [enabled], [modified],start_date,end_date
	FROM application_message
	WHERE (@siteId IS NULL OR site_id = @siteId) AND (@applicationType IS NULL OR @applicationType = application_type)

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetApplicationMessages TO VpWebApp 
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetUserApplicationMessagesToBeShown'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetUserApplicationMessagesToBeShown
	@userId int
AS
-- ==========================================================================
-- $Author: Nilanka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT am.application_message_id AS id, am.site_id, am.application_type, am.message_type, am.message_text, am.show, am.[created], am.[enabled], am.[modified], am.start_date,am.end_date
	FROM application_message am
		INNER JOIN user_to_application_message uam
			ON uam.application_message_id = am.application_message_id
	WHERE uam.show = 1 AND uam.user_id = @userId AND GETDATE() BETWEEN  am.start_date AND am.end_date

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetUserApplicationMessagesToBeShown TO VpWebApp 
GO

--------

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentGuidedBrowseSearchGroupSearchOptionsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[publicSearchCategory_GetFixedGuidedBrowseAllSegmentGuidedBrowseSearchGroupSearchOptionsList]
	@categoryId int,
	@guidedBrowseSearchGroupId int,
	@selectedOptions varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	-- Populate primary search option ids
	CREATE TABLE #PrimarySearchOption (search_option_id int)
	INSERT INTO #PrimarySearchOption
	SELECT DISTINCT s.search_option_id
	FROM search_option s
		INNER JOIN guided_browse_to_search_group_to_search_option gbso
			ON gbso.search_option_id = s.search_option_id
		INNER JOIN product_to_search_option ps
			ON ps.search_option_id = s.search_option_id
		INNER JOIN product_to_category pc
			ON pc.product_id = ps.product_id
		INNER JOIN product p
			ON p.product_id = pc.product_id
	WHERE s.enabled = 1 AND gbso.guided_browse_to_search_group_id = @guidedBrowseSearchGroupId AND p.enabled = 1 AND pc.enabled = 1 AND p.show_in_matrix = 1

	-- Populate secondary search option ids
	CREATE TABLE #SecondarySearchOption (search_option_id int)
	INSERT INTO #SecondarySearchOption
	SELECT [VALUE] FROM global_split(@selectedOptions, ',')
	
	-- Find number of rows in secondary option ids
	DECLARE @secondarySearchOptionCount int
	SELECT @secondarySearchOptionCount = COUNT(*) FROM #SecondarySearchOption

	-- Find products having at least one primary option and all secondary options
	CREATE TABLE #FilteredProduct (product_id int)
	INSERT INTO #FilteredProduct
	SELECT ps.product_id
	FROM product_to_search_option ps
	WHERE ps.product_id IN 
	(
		SELECT product_id
		FROM product_to_search_option so
			INNER JOIN #PrimarySearchOption
				ON so.search_option_id = #PrimarySearchOption.search_option_id
	)
	AND ps.search_option_id IN
	(
		SELECT search_option_id
		FROM #SecondarySearchOption
	)
	GROUP BY ps.product_id
	HAVING COUNT(ps.search_option_id) = @secondarySearchOptionCount

	-- Select search options in primary option list having products in filtered products list
	SELECT search_option_id AS id, search_group_id, [name], sort_order, created, enabled, modified
	FROM search_option
	WHERE search_option_id IN
	(
		SELECT search_option_id
		FROM product_to_search_option ps
			INNER JOIN #FilteredProduct
				ON ps.product_id = #FilteredProduct.product_id
		WHERE search_option_id IN
		(
			SELECT search_option_id
			FROM #PrimarySearchOption
		)
	)
	ORDER BY [name]

END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetFixedGuidedBrowseAllSegmentGuidedBrowseSearchGroupSearchOptionsList TO VpWebApp 
GO