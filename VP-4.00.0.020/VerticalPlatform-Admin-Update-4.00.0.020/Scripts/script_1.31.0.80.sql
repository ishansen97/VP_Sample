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
			[enabled], modified, created, country, [owner]
	FROM spider_ip_address
	WHERE blocked_status = @blocked

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByType TO VpWebApp 
GO
-----------------------------------------------------------
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
								description, [enabled], modified, created, country, [owner])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS idRowDesc, 
				ROW_NUMBER() OVER (ORDER BY ip_address ASC) AS ipRow,
			    ROW_NUMBER() OVER (ORDER BY ip_address DESC) AS ipRowDesc, 
				ROW_NUMBER() OVER (ORDER BY modified ASC) AS modifiedRow,
				ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedRowDesc, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE  ip_group_id is null 
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
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
----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds
	@ParentProductId int,
	@productCompressionGroupId int,
	@searchOptionIds varchar(max),
	@categoryId int,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	
	SELECT DISTINCT product.product_id AS id, site_id, product.parent_product_id, product_name, [rank], has_image, catalog_number, product.enabled,
		product.modified, product.created, product_type, status, has_related, has_model, completeness, flag1, flag2, flag3, flag4, search_rank,
		search_content_modified, hidden, business_value, show_in_matrix, show_detail_page, ignore_in_rapid
	FROM product
	INNER JOIN product_to_product pp
		ON product.product_id = pp.product_id
	INNER JOIN product_to_category ptc
		ON 	ptc.product_id = pp.product_id  AND ptc.enabled = '1'
	INNER JOIN product_compression_group_to_product proGro
		ON pp.product_id = proGro.product_id
	LEFT JOIN product_to_search_option pso
		ON pso.product_id = product.product_id
	WHERE proGro.product_compression_group_id = @productCompressionGroupId AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		) AND 
		pp.parent_product_id = @ParentProductId AND
		(@searchOptionIds IS NULL OR pso.search_option_id IN (SELECT [value] FROM [global_Split](@searchOptionIds, ','))) AND
		(@categoryId= 0 OR ptc.category_id = @categoryId)

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetChildProductsByProductCompressionGroupIdSearchOptionIds TO VpWebApp 
GO
-------------------------------------------------------------
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
	@totalCount int output

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
								description, [enabled], modified, created, country, [owner])
	AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
				(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
				((@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate))
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)			  

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
			(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
			(@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate)	

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging TO VpWebApp 
GO
-----------------------------------------------------------------------------
UPDATE article SET featured_identifier = 8 WHERE featured_identifier = 0
-----------------------------------------------------------------------------