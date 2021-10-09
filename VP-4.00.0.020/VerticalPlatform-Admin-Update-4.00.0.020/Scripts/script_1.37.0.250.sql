EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList
	@siteId int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@startIndex int,
	@endIndex int,
	@search varchar(50) = NULL,
	@numberOfRows int output
AS
-- ==========================================================================
-- $Author: Sahan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #temp_vendor (vendor_id int, site_id int, vendor_name varchar(100), vendor_rank int
	, has_image bit, enabled bit, modified smalldatetime, created smalldatetime, parent_vendor_id int
	, vendor_keywords varchar(MAX), internal_name varchar(255), [description] varchar(MAX), row int)

	DECLARE @query nvarchar(max)

	SET @query ='INSERT INTO #temp_vendor (vendor_id, site_id, vendor_name, vendor_rank, has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name, [description],
		created, row)
		SELECT vendor_id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled, modified, parent_vendor_id, vendor_keywords, internal_name, [description],
		created'
		
	IF(@sortBy = ' ')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_id ' + @sortOrder + ' ) AS row'
	IF(@sortBy = 'id')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_id ' + @sortOrder + ' ) AS row'
	ELSE IF(@sortBy = 'Name')
		SET @query = @query + ', ROW_NUMBER() OVER (ORDER BY vendor_name ' + @sortOrder + ' ) AS row'
	
	SET @query = @query + ' FROM 
		(
		SELECT vendor.vendor_id, vendor.site_id, vendor.vendor_name, vendor.[rank] AS vendor_rank
			, vendor.has_image, vendor.enabled, vendor.modified, vendor.created, vendor.parent_vendor_id
			, vendor.vendor_keywords, internal_name, [description]
		FROM vendor WHERE '
	
	SET @query = @query + ' vendor.site_id =' + CAST(@siteId AS varchar(10))
	
	IF (@search IS NOT NULL) 
		SET @query = @query + ' AND  (vendor.vendor_name like ''%' + @search + '%'')'
	
	
	SET @query = @query + ' ) AS temp_table'

	
	EXECUTE sp_executesql @query

	SELECT @numberOfRows = COUNT(*) 
	FROM #temp_vendor

	SELECT vendor_id AS id, site_id, vendor_name, vendor_rank AS [rank], has_image, enabled
		, modified, created, parent_vendor_id, vendor_keywords, internal_name, [description]
	FROM #temp_vendor
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
 
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetVendorBySiteIdSearchSortedPageList TO VpWebApp 
GO