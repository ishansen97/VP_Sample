EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_ReorderCategory'

GO

/****** Object:  StoredProcedure [dbo].[adminProduct_ReorderCategory]    Script Date: 11/28/2018 4:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_ReorderCategory]
	@categoryId INT, 
	@sortOrder INT,
	@originalSortOrder INT --if 2147483647 (sql-max) new category
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE	@siteId INT
	DECLARE @rangeMin INT
	DECLARE @rangeMax INT
	DECLARE @shift INT


	SELECT	@siteId = site_id
	FROM	dbo.category
	WHERE	category_id = @categoryId

	--send to last sort order
	IF @sortOrder = 0
	BEGIN
		SELECT @sortOrder = MAX(sort_order)+1
		FROM dbo.category WHERE site_id = @siteId AND category_type_id = 1 --trunk level
		UPDATE dbo.category
		SET sort_order = @sortOrder
		WHERE category_id = @categoryId
	END


	IF @sortOrder > @originalSortOrder 
	BEGIN
		SET @shift = -1
		SET @rangeMin = @originalSortOrder
		SET @rangeMax = @sortOrder
	END
	ELSE
	BEGIN
		SET @shift = 1
		SET @rangeMin = @sortOrder
		SET @rangeMax = @originalSortOrder
	END

	--shifting all categories inside range
	UPDATE dbo.category
	SET	sort_order = CASE WHEN category_id = @categoryId THEN @sortOrder ELSE sort_order+@shift END
	WHERE	category_type_id = 1 --only trunk level categories affected
			AND	[sort_order] >= @rangeMin AND [sort_order] <= @rangeMax
			AND	site_id = @siteId
			--AND category_id <> @categoryId

END


GO
GRANT EXECUTE ON dbo.adminProduct_ReorderCategory TO VpWebApp
GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_CategoryGetNextSortOrder'

GO

/****** Object:  StoredProcedure [dbo].[adminProduct_CategoryGetNextSortOrder]    Script Date: 11/28/2018 4:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[adminProduct_CategoryGetNextSortOrder]
	@site_id INT,
	@nextSortOrder int output
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT	@nextSortOrder = MAX(sort_order)+1
	FROM	dbo.category
	WHERE	site_id = @site_id
			AND	category_type_id = 1

END


GO
GRANT EXECUTE ON dbo.adminProduct_CategoryGetNextSortOrder TO VpWebApp
GO


