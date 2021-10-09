EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList
	@categoryId int,
	@productId int,
	@childProductIds varchar(500)
AS
-- ==========================================================================
-- $Author: Dhanushka$
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_compression_group.product_compression_group_id AS id, product_compression_group.site_id, 
		product_compression_group.show_in_matrix, show_product_count, group_title,expand_products, 
		product_compression_group.[enabled], product_compression_group.created, product_compression_group.modified, 
		is_default, group_name, product_compression_group_to_product.product_id, product_compression_group.sort_order
	FROM product_to_product
		INNER JOIN product_to_category
			ON product_to_product.product_id = product_to_category.product_id
		INNER JOIN product_compression_group_to_product
			ON product_compression_group_to_product.product_id = product_to_product.product_id
		INNER JOIN product_compression_group
			ON product_compression_group_to_product.product_compression_group_id = product_compression_group.product_compression_group_id
		INNER JOIN Global_Split(@childProductIds, ',') children
			ON product_to_product.product_id = children.[value]
	WHERE product_to_product.parent_product_id = @productId AND product_to_category.category_id = @categoryId 
	ORDER BY product_compression_group.sort_order, product_compression_group.product_compression_group_ID

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByChildProductIdsList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList
    @productIds VARCHAR(4000),
    @categoryId INT,
    @countryFlag1 BIGINT ,	
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS
-- ==========================================================================  
-- Author : Dimuthu  
-- ==========================================================================  

    BEGIN  
  
        SET NOCOUNT ON;    
    
        SELECT  c.product_compression_group_id AS id ,
                site_id ,
                show_in_matrix ,
                show_product_count ,
                group_title ,
                expand_products ,
                enabled ,
                created ,
                modified ,
                is_default ,
                group_name ,
				c.sort_order,
                product_id ,
                product_count
        FROM    ( SELECT    CAST(p.[value] AS INT) AS product_id ,
                            cp.product_compression_group_id ,
                            COUNT(*) product_count
                  FROM      product_to_product pp
                            INNER JOIN global_Split(@productIds, ',') AS p ON pp.parent_product_id = p.[value]
                            INNER JOIN product ON pp.product_id = product.product_id
                            INNER JOIN product_compression_group_to_product cp ON pp.product_id = cp.product_id
                            INNER JOIN dbo.product_to_category ptc ON pp.product_id = ptc.product_id
                  WHERE     (( product.flag1 & @countryFlag1 > 0 )
                            OR ( product.flag2 & @countryFlag2 > 0 )
                            OR ( product.flag3 & @countryFlag3 > 0 )
                            OR ( product.flag4 & @countryFlag4 > 0 ))
							AND product.enabled = 1
                            AND pp.enabled = 1
                            AND ptc.enabled = 1
                            AND ptc.category_id = @categoryId
                  GROUP BY  p.[value] ,
                            cp.product_compression_group_id
                ) g
                INNER JOIN product_compression_group c ON g.product_compression_group_id = c.product_compression_group_id   
		ORDER BY c.sort_order
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------
IF EXISTS(select * from sys.columns where Name = N'featured_search_rank' 
	and Object_ID = Object_ID(N'product_display_status'))
BEGIN
	DECLARE @ConstraintName nvarchar(200)
	SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE
		 PARENT_OBJECT_ID = OBJECT_ID('product_display_status') AND
		 PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns 
		 WHERE NAME = N'featured_search_rank' AND object_id = OBJECT_ID(N'product_display_status'))
	print @ConstraintName 

	IF @ConstraintName IS NOT NULL
	EXEC('ALTER TABLE product_display_status DROP CONSTRAINT ' + @ConstraintName)
	IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('product_display_status') 
	AND name='featured_search_rank')
	EXEC('ALTER TABLE product_display_status DROP COLUMN featured_search_rank')
END
GO

-----------------------------------------------------------

IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'search_rank' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].product_display_status') AND type in (N'U'))
)
BEGIN
	  ALTER TABLE product_display_status
	  ADD search_rank int not null default '0'
END
GO

--------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductDisplayStatus
	@id int output,
	@productId int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@SearchRank int,
	@newRank int,
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO [product_display_status] (product_id, start_date, end_date, search_rank, new_rank, [enabled], modified, created)
	VALUES (@productId, @startDate, @endDate, @SearchRank, @newRank, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductDisplayStatus TO VpWebApp 
GO
---------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductDisplayStatus'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductDisplayStatus
	@id int,
	@productId int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@SearchRank int,
	@newRank int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: rajitha $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.[product_display_status]
	SET product_id = @productId,
		start_date = @startDate,
		end_date = @endDate,
		search_rank = @SearchRank,
		new_rank = @newRank,
		enabled = @enabled,		
		modified = @modified
	WHERE product_display_status_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductDisplayStatus TO VpWebApp 
GO
-------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductDisplayStatusDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductDisplayStatusDetail
@id int
	
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_display_status_id as id, product_id, start_date, end_date, search_rank, new_rank, [enabled], modified, created
	FROM [product_display_status]	
	WHERE product_display_status_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductDisplayStatusDetail TO VpWebApp 
GO
-------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductDisplayStatusByProductId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductDisplayStatusByProductId
	@productId int
	
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_display_status_id as id, product_id, start_date, end_date, search_rank, new_rank, [enabled], modified, created
	FROM [product_display_status]	
	WHERE product_id = @productId 

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductDisplayStatusByProductId TO VpWebApp 
GO
----------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetProductDisplayStatusBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetProductDisplayStatusBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: rajitha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT pds.product_display_status_id as id, pds.product_id, pds.start_date, pds.end_date, pds.search_rank, pds.new_rank, pds.[enabled], pds.modified, pds.created
	FROM [product_display_status] pds
		INNER JOIN product p
			on p.product_id = pds.product_id
	WHERE p.site_id = @siteId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetProductDisplayStatusBySiteId TO VpWebApp 
GO
---------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetOverlappedProductDisplayStatusBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetOverlappedProductDisplayStatusBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SET @today = GETDATE();

	SELECT pds.product_display_status_id as id, pds.product_id, pds.start_date, pds.end_date, pds.search_rank
		, pds.new_rank, pds.[enabled], pds.modified, pds.created
	FROM [product_display_status] pds
		INNER JOIN product p
			on p.product_id = pds.product_id
	WHERE p.site_id = @siteId
		AND (pds.start_date <= @today AND @today <= pds.end_date)


END
GO

GRANT EXECUTE ON dbo.adminProduct_GetOverlappedProductDisplayStatusBySiteId TO VpWebApp 
GO
-------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetDisplayStatusProductCountBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetDisplayStatusProductCountBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	SELECT COUNT(*)
	FROM [product_display_status] pds
		INNER JOIN product p
			on p.product_id = pds.product_id
	WHERE p.site_id = @siteId
		AND (pds.start_date <= @today AND @today <= pds.end_date)
		AND p.rank <> pds.new_rank
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetDisplayStatusProductCountBySiteId TO VpWebApp 
GO
--------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	SELECT count(pro.product_id) FROM product pro
		INNER JOIN [product_display_status] pds
			ON pro.product_id = pds.product_id
	WHERE pro.site_id = @siteId
		AND NOT(pds.start_date <= @today AND @today <= pds.end_date)
		AND pro.rank <> pro.default_rank
		AND pro.product_id NOT IN 
		(
			SELECT p.product_id
			FROM product p
				INNER JOIN [product_display_status] pds
					ON p.product_id = pds.product_id
			WHERE p.site_id = @siteId
				AND (pds.start_date <= @today AND @today <= pds.end_date)
				AND p.rank <> pds.new_rank
		)
END
GO

GRANT EXECUTE ON dbo.adminProduct_GetNotOverlappedDisplayStatusProductCountBySiteId TO VpWebApp 
GO
---------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	Declare @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);
	
	UPDATE p
		SET p.rank = p.default_rank,
			p.search_rank = p.default_search_rank
	FROM product p
	WHERE p.product_id IN
	(
		SELECT top 100 pro.product_id FROM product pro
			INNER JOIN [product_display_status] pds
				on pro.product_id = pds.product_id
		WHERE pro.site_id = @siteId
			AND NOT(pds.start_date <= @today AND @today <= pds.end_date)
			AND pro.rank <> pro.default_rank
			AND pro.product_id NOT IN 
			(
				SELECT p.product_id
				FROM product p
					INNER JOIN [product_display_status] pds
						ON p.product_id = pds.product_id
				WHERE p.site_id = @siteId
					AND (pds.start_date <= @today AND @today <= pds.end_date)
					AND p.rank <> pds.new_rank
		)
	)


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateNotOverlappedDisplayStatusProductsBySiteId TO VpWebApp 
GO
-------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateDisplayStatusProductsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateDisplayStatusProductsBySiteId
	@siteId int
	
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @today smalldatetime
	SELECT @today = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0);

	UPDATE p
		SET p.rank = product_display.new_rank,
			p.search_rank = product_display.search_rank
	FROM 
	(
		SELECT top 100 p.product_id, pds.new_rank, pds.search_rank
		FROM [product_display_status] pds
			INNER JOIN product p
				ON p.product_id = pds.product_id
		WHERE p.site_id = @siteId
			AND (pds.start_date <= @today AND @today <= pds.end_date)
			AND p.rank <> pds.new_rank
	)product_display
	INNER JOIN product p
		ON p.product_id = product_display.product_id


END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateDisplayStatusProductsBySiteId TO VpWebApp 
GO
------------------------------------------------------
