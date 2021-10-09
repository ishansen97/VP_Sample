DECLARE @siteId int	

DECLARE @predefinedPageId int
SET @predefinedPageId = (SELECT TOP 1 predefined_page_id FROM predefined_page WHERE page_name = 'SubscriptionPreferences')

DECLARE site_cursor CURSOR FOR
SELECT site_id FROM site

OPEN site_cursor

FETCH NEXT FROM site_cursor
INTO @siteId

WHILE @@FETCH_STATUS = 0
BEGIN

	IF NOT EXISTS (SELECT * FROM page WHERE site_id = @siteId AND predefined_page_id = @predefinedPageId)
	BEGIN
		INSERT INTO page (site_id, predefined_page_id, page_name, page_title, keywords
			, template_name, sort_order, navigable, hidden, log_in_to_view, enabled, modified, created
			, page_title_prefix, page_title_suffix, description_prefix, description_suffix, include_in_sitemap, navigation_title)
		VALUES (@siteId, @predefinedPageId, 'SubscriptionPreferences', 'SubscriptionPreferences', ''
			, '~/Templates/TwoColumnLayout/TwoColumnLayout.ascx', 50, 0, 1, 0, 1
			, GETDATE(), GETDATE(), '', '', '', '', 0, '')

		-- Create page
		DECLARE @pageId int
		SELECT @pageId = page_id
		FROM page
		WHERE site_id = @siteId AND predefined_page_id = @predefinedPageId

		--Formating page name
		DECLARE @formatedPageName varchar(255)
		EXEC dbo.global_FormatUrl 'SubscriptionPreferences', @formatedPageName output

		--Creating site page url
		DECLARE @url varchar(255)
		SET @url = '/' + CONVERT(varchar(10), @pageId) + '-' + @formatedPageName + '/'

		INSERT INTO fixed_url (fixed_url, site_id, page_id, content_type_id, content_id
			, enabled, created, modified)
		VALUES (@url, @siteId, @pageId, 7, @pageId, 1, GETDATE(), GETDATE())
	END

	FETCH NEXT FROM site_cursor
	INTO @siteId
END

CLOSE site_cursor
DEALLOCATE site_cursor

GO

------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductForSearchList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductForSearchList
	@siteId int,
	@search varchar(255),
	@categoryId int, 
	@vendorId int,
	@startIndex int,
	@endIndex int,
	@sortBy varchar(8),
	@total int output,
	@countryFlag1 bigint,
	@countryFlag2 bigint,
	@countryFlag3 bigint,
	@countryFlag4 bigint,
	@filterVendorIds varchar(MAX),
	@sortBySpecificationTypeId int,
	@sortOrderBy varchar(4)
AS
-- ==========================================================================
-- Author: Naveen
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #search_product (search_product_id int)

	--Create temp table to store the filtered products with calculated total rank
	CREATE TABLE #total_ranked_product (product_id int, site_id int, parent_product_id int
		, product_name varchar(500), [rank] int, has_image bit
		, catalog_number varchar(255), enabled bit, modified smalldatetime, created smalldatetime
		, total_rank int, vendor_name varchar(100), price money, vendor_id int, product_type int, status int
		, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, product_to_vendor_id int, parent_vendor_id int, specification varchar(MAX) NULL,
		show_in_matrix bit, show_detail_page bit, price_sort_order money,  default_rank int, default_search_rank int)

	--Create temp table to store filtered, total rank calculated products with row number columns 
	--relavant to sorting types
	CREATE TABLE #temp_product (product_id int, site_id int, row int, parent_product_id int, product_name varchar(500)
		, [rank] int, has_image bit, catalog_number varchar(255)
		, enabled bit, modified smalldatetime, created smalldatetime, vendor_name varchar(100)
		, price money, vendor_id int, product_type int, status int, has_related bit, has_model bit, completeness int
		, flag1 bigint, flag2 bigint, flag3 bigint, flag4 bigint, search_rank int, search_content_modified bit, hidden bit
		, business_value int, ignore_in_rapid bit, parent_vendor_id int, show_in_matrix bit, show_detail_page bit,  default_rank int, default_search_rank int)

	INSERT INTO #search_product
	SELECT DISTINCT content_id AS search_product_id
	FROM FREETEXTTABLE(content_text, *, @search) RankedTable
		INNER JOIN content_text
			ON [KEY] = content_text.content_text_id AND content_text.site_id = @siteId
		INNER JOIN product_to_category
			ON content_type_id IN (2,3) AND content_id = product_to_category.product_id
	WHERE content_text.enabled = '1' AND product_to_category.category_id = @categoryId


	--Populate filtered products with calculated total rank
	INSERT INTO #total_ranked_product
	SELECT product.product_id, product.site_id, product.parent_product_id
		, product.product_name, product.[rank]
		, product.has_image, product.catalog_number, product.enabled, product.modified
		, product.created
		, CASE WHEN product.[rank] = 3 THEN 6
			WHEN vendor.[rank] = 3 THEN 5
			ELSE product.[rank] + vendor.[rank]
			END total_rank
		, vendor.vendor_name
		, NULL
		, vendor.vendor_id
		, product.product_type
		, product.status
		, product.has_related
		, product.has_model
		, product.completeness
		, product.flag1
		, product.flag2
		, product.flag3
		, product.flag4
		, product.search_rank
		, product.search_content_modified
		, product.hidden
		, product.business_value
		, product.ignore_in_rapid
		, product_to_vendor.product_to_vendor_id
		, ISNULL(vendor.parent_vendor_id, vendor.vendor_id) parent_vendor_id
		, NULL
		,product.show_in_matrix
		,product.show_detail_page
		,NULL
		,default_rank
		,default_search_rank
	FROM product
		INNER JOIN #search_product ON search_product_id = product.product_id
		INNER JOIN product_to_category
			ON product.product_id = product_to_category.product_id
		INNER JOIN product_to_vendor
			ON product.product_id = product_to_vendor.product_id 
				AND product_to_vendor.is_manufacturer = 1
		INNER JOIN vendor
			ON product_to_vendor.vendor_id = vendor.vendor_id
	WHERE product_to_category.category_id = @categoryId AND 
		product.enabled = 1 AND 
		product_to_category.enabled = 1 AND 
		vendor.enabled = 1 AND
		(
			(product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
		)

	--Increase the vendors total rank
	--If vendor id is passed to the sp and sort parameter is by 'rank' we need to boost the rank.
	--Number 8 is used to boost since the rank at the moment of all products going to be below 8. 
	IF @vendorId IS NOT NULL
	BEGIN
		UPDATE #total_ranked_product
		SET total_rank = total_rank + 8
		WHERE vendor_id = @vendorId
	END

	--- update price to the temporary table, to sort with price.
	UPDATE #total_ranked_product
	SET price =  (
		SELECT TOP 1 price
		FROM product_to_vendor_to_price p
		WHERE p.product_to_vendor_id = #total_ranked_product.product_to_vendor_id
			AND
			(
				(p.country_flag1 & @countryFlag1 > 0) OR (p.country_flag2 & @countryFlag2 > 0) OR 
				(p.country_flag3 & @countryFlag3 > 0) OR (p.country_flag4 & @countryFlag4 > 0)
			)
		ORDER BY p.country_flag1, p.country_flag2, p.country_flag3, p.country_flag4)	
	
	UPDATE #total_ranked_product
	SET price_sort_order = (
		CASE 
		WHEN @sortOrderBy = 'ASC' AND (price IS NULL OR price = 0)
		THEN
			'100000'
		ELSE
			price
		END
	)
		
		
	IF (@sortBySpecificationTypeId > 0)
	BEGIN
		UPDATE #total_ranked_product
		SET #total_ranked_product.specification = s.specification
		FROM #total_ranked_product p 
			INNER JOIN specification s
				ON s.content_type_id = 2 AND s.content_id = p.product_id
		WHERE s.spec_type_id = @sortBySpecificationTypeId
	END

	--Populate with row number columns
	DECLARE @query nvarchar(MAX)
	SET @query = 'INSERT INTO #temp_product
		SELECT product_id, site_id, '
	IF (@sortBySpecificationTypeId > 0)
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY specification ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE IF (@sortBy = 'Product')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY product_name ' + @sortOrderBy + ') AS row, '
	ELSE IF (@sortBy = 'Vendor')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY vendor_name ' + @sortOrderBy + ', product_name) AS row, '
	ELSE IF (@sortBy = 'Price')
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY price_sort_order ' + @sortOrderBy + ', vendor_name, product_name) AS row, '
	ELSE  
		SET @query = @query + 'ROW_NUMBER() OVER(ORDER BY total_rank DESC, vendor_name, product_name) AS row, '
	
	SET @query = @query + 'parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified
		, created, vendor_name, price, vendor_id, product_type, status, has_related, has_model, completeness 
		, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, parent_vendor_id, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		,default_rank, default_search_rank
	FROM #total_ranked_product '	

	IF (DATALENGTH(@filterVendorIds) > 0)
		SET @query = @query + 'WHERE parent_vendor_id IN (SELECT [value] FROM Global_Split(''' + @filterVendorIds + ''','',''))'

	EXECUTE sp_executesql @query

	--Set the total count
	SELECT @total = COUNT(product_id) 
	FROM #temp_product

	--Retrieve sorted product list
	SELECT product_id AS id, site_id, parent_product_id, product_name, [rank]
		, has_image, catalog_number, enabled, modified, created, product_type, status, has_related, has_model
		, completeness, flag1, flag2, flag3, flag4, search_rank, search_content_modified, hidden, business_value, ignore_in_rapid, show_in_matrix, show_detail_page
		, default_rank, default_search_rank
	FROM #temp_product
	WHERE row BETWEEN @startIndex AND @endIndex
	ORDER BY row
	
	DROP TABLE #total_ranked_product
	DROP TABLE #temp_product
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductForSearchList TO VpWebApp
GO
-----------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList
	@bulkEmailTypeId int,
	@siteId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
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
		WHERE pu.site_id = @siteId AND pu.email_optout = 0 AND pu.enabled = 1 AND pu.public_user_id IN
		(
			SELECT DISTINCT puf.public_user_id
			FROM public_user_field puf
				INNER JOIN bulk_email_type_to_field btf
					ON btf.bulk_email_type_id = @bulkEmailTypeId
				INNER JOIN field f
					ON btf.field_id = f.field_id
				INNER JOIN public_user_field_to_field_option pufo
					ON puf.public_user_field_id = pufo.public_user_field_id
			WHERE puf.field_id = f.field_id AND f.field_type_id = 3
		)
	)
	
	SELECT id, public_user_id, salutation, first_name, last_name
		, address_line1, address_line2, city, [state], country_id, phone_number, postal_code, company
		, email
	FROM UserList
	WHERE row_id BETWEEN @startIndex AND @endIndex

	SELECT DISTINCT @totalCount = COUNT(*)
	FROM public_user pu
	WHERE pu.site_id = @siteId AND pu.email_optout = 0 AND pu.enabled = 1 AND pu.public_user_id IN
	(
		SELECT DISTINCT puf.public_user_id
		FROM public_user_field puf
			INNER JOIN bulk_email_type_to_field btf
				ON btf.bulk_email_type_id = @bulkEmailTypeId
			INNER JOIN field f
				ON btf.field_id = f.field_id
			INNER JOIN public_user_field_to_field_option pufo
				ON puf.public_user_field_id = pufo.public_user_field_id
		WHERE puf.field_id = f.field_id AND f.field_type_id = 3
	)


END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList TO VpWebApp 
GO

----------
