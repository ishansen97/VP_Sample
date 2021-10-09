

EXEC dbo.global_DropStoredProcedure 'dbo.adminVendor_UpdateVendorProducts'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminVendor_UpdateVendorProducts
	@targetVendorId int,
	@sourceVendorId int		
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @modified smalldatetime 
	SET @modified = GETDATE() 	

	SELECT product_to_vendor_id
	INTO #tmp_source_product_to_vendor
	FROM product_to_vendor 
	WHERE vendor_id = @sourceVendorId

	UPDATE ptv
	SET  ptv.vendor_id = @targetVendorId,
		 ptv.modified = @modified
	FROM product_to_vendor ptv
	INNER JOIN #tmp_source_product_to_vendor tmp on tmp.product_to_vendor_id = ptv.product_to_vendor_id

	UPDATE	pro
	SET pro.content_modified = 1
	FROM	product pro WITH(NOLOCK)
	INNER JOIN dbo.product_to_vendor ptv WITH(NOLOCK) ON ptv.product_id = pro.product_id
	INNER JOIN #tmp_source_product_to_vendor tmp on tmp.product_to_vendor_id = ptv.product_to_vendor_id

END
GO

GRANT EXECUTE ON dbo.adminVendor_UpdateVendorProducts TO VpWebApp 
GO



--==== adminProduct_DeleteProductMultimediaItem

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductMultimediaItem'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_DeleteProductMultimediaItem
	@id int
AS
-- ==========================================================================
-- $Author: chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE pro
	SET pro.content_modified = 1
	FROM dbo.product pro
	INNER JOIN product_multimedia_item pmi ON pmi.product_id = pro.product_id
	WHERE pmi.product_multimedia_item_id = @id

	DELETE FROM product_multimedia_item
	WHERE product_multimedia_item_id = @id


END
GO

GRANT EXECUTE ON dbo.adminProduct_DeleteProductMultimediaItem TO VpWebApp 
GO

--==== adminProduct_GetModifiedProductIdsForProductSync

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetModifiedProductIdsForProductSync'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetModifiedProductIdsForProductSync
	@limit int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	Select DISTINCT TOP(@limit) p.product_id as id
	from product p with(nolock)
	INNER JOIN product_to_vendor ptv with(nolock) ON ptv.product_id = p.product_id
	where  p.content_modified = 1
	AND ptv.is_manufacturer = 1
	ORDER BY p.product_id

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetModifiedProductIdsForProductSync TO VpWebApp 
GO


--==== adminCategory_AssociateAndDeleteProductsForGeneratedCategories


EXEC dbo.global_DropStoredProcedure 'dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminCategory_AssociateAndDeleteProductsForGeneratedCategories]
	@categoryId int,
	@associateSearchCategoryId int
AS
-- ==========================================================================
-- $ Author : Chinthaka $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @optionsCount INT
	DECLARE @lastUpdateDate DATETIME = GETDATE()

	SELECT @optionsCount = COUNT(*)
	FROM category_to_search_option ctso
	WHERE ctso.category_id = @categoryId

	SELECT p.product_id
	INTO #tmpProducts
	FROM product p
	INNER JOIN product_to_search_option ptso
		ON ptso.product_id = p.product_id
	INNER JOIN category_to_search_option ctso
		ON ctso.search_option_id = ptso.search_option_id
	INNER JOIN product_to_category ptc
		ON ptc.product_id = p.product_id
	WHERE ctso.category_id = @categoryId
		AND p.enabled = 1
		AND ptc.category_id = @associateSearchCategoryId
	GROUP BY p.product_id
	HAVING COUNT(ptso.product_id) = @optionsCount

	INSERT INTO product_to_category (category_id, product_id, [enabled], modified, created)
	SELECT @categoryId, product_id, 1, GETDATE(), GETDATE()
	FROM #tmpProducts
	WHERE product_id NOT IN (
		SELECT product_id
		FROM product_to_category ptc
		WHERE ptc.category_id = @categoryId
		)


	DELETE
	FROM product_to_category
	WHERE category_id = @categoryId
		AND product_id NOT IN (
			SELECT p.product_id
			FROM product p
			INNER JOIN product_to_search_option ptso
				ON ptso.product_id = p.product_id
			INNER JOIN category_to_search_option ctso
				ON ctso.search_option_id = ptso.search_option_id
			INNER JOIN product_to_category ptc
		        ON ptc.product_id = p.product_id
			WHERE ctso.category_id = @categoryId
				AND p.enabled = 1
				AND ptc.category_id = @associateSearchCategoryId
			GROUP BY p.product_id
			HAVING COUNT(ptso.product_id) = @optionsCount
		)

	DROP TABLE #tmpProducts


	--updating for elastic search index (only on last updated products)
	UPDATE  pro
	SET		pro.search_content_modified = 1 ,
			pro.content_modified = 1
	FROM	product pro
			INNER JOIN product_to_category prc ON	prc.product_id = pro.product_id
	WHERE   prc.category_id = @categoryId
	AND	prc.modified >= @lastUpdateDate

END
GO

GRANT EXECUTE ON dbo.adminCategory_AssociateAndDeleteProductsForGeneratedCategories TO VpWebApp 
GO
------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductDisplayIncludeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductDisplayIncludeList
	@timeInterval int
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime

	SET @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	SELECT pds.product_display_status_id 
	,pds.product_id
	INTO #tmp_exclude_statuses
	FROM product_display_status pds
	WHERE [include] = 1
		AND (end_date <= DATEADD(DAY, -@timeInterval, @today)
			OR end_date >= DATEADD(DAY, @timeInterval, @today))

	UPDATE pds
	SET [include] = 0,
		modified = GETDATE()
	FROM product_display_status pds
	INNER JOIN #tmp_exclude_statuses tmp ON tmp.product_display_status_id = pds.product_display_status_id


	SELECT pds.product_display_status_id 
	,pds.product_id
	INTO #tmp_include_statuses
	FROM product_display_status pds
	WHERE [include] = 0
		AND ([start_date] BETWEEN DATEADD(DAY, -@timeInterval, @today) AND DATEADD(DAY, @timeInterval, @today)
			OR end_date BETWEEN DATEADD(DAY, -@timeInterval, @today) AND DATEADD(DAY, @timeInterval, @today))

	UPDATE pds
	SET [include] = 1,
		modified = GETDATE()
	FROM product_display_status pds
	INNER JOIN #tmp_include_statuses tmp ON tmp.product_display_status_id = pds.product_display_status_id



	--update product content modified status
	--UPDATE pro
	--SET pro.content_modified = 1
	--FROM dbo.product pro
	--INNER JOIN (
	--	SELECT product_id
	--	FROM #tmp_include_statuses
	--	UNION ALL
	--	SELECT product_id
	--	FROM #tmp_exclude_statuses
	--)T  ON T.product_id = pro.product_id


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductDisplayIncludeList TO VpWebApp 
GO


