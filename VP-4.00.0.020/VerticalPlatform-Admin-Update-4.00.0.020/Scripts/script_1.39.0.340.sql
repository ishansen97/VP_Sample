-- Adding New Column
IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'css_width' AND Object_ID = Object_ID(N'category_to_specification_type'))
BEGIN
	ALTER TABLE category_to_specification_type
	ADD css_width FLOAT NULL
END
GO

-- Setting Default Values
DECLARE @categoryId INT
DECLARE @categorySpecCount INT

DECLARE categorySpecTypeCursor CURSOR FOR 
SELECT DISTINCT [category_id], COUNT(spec_type_id)
FROM [category_to_specification_type]
WHERE [enabled] = 1 AND show_in_matrix = 1
GROUP BY category_id

OPEN categorySpecTypeCursor

FETCH NEXT FROM categorySpecTypeCursor 
INTO @categoryId, @categorySpecCount

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @cssWidth FLOAT = 100 / @categorySpecCount
	UPDATE category_to_specification_type
	SET
		css_width = @cssWidth
	WHERE [enabled] = 1 AND show_in_matrix = 1 AND category_id = @categoryId
	
	FETCH NEXT FROM categorySpecTypeCursor 
    INTO @categoryId, @categorySpecCount
END 
CLOSE categorySpecTypeCursor
DEALLOCATE categorySpecTypeCursor
GO

UPDATE category_to_specification_type
SET
	css_width = 0
WHERE css_width IS NULL
GO

-- Setting column to not null
IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'css_width' AND Object_ID = Object_ID(N'category_to_specification_type'))
BEGIN
	ALTER TABLE category_to_specification_type
	ALTER COLUMN css_width FLOAT NOT NULL
END
GO
-----------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddCategorySpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddCategorySpecificationType
	@categoryId int,
	@specificationTypeId int,
	@sortOrder int,
	@showInMatrix bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output,
	@specDisplayLength int,
	@displayName varchar(255),
	@cssWidth FLOAT
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO  category_to_specification_type (category_id, spec_type_id, sort_order,	[enabled], modified, created, show_in_matrix, spec_display_length, display_name, css_width) 
	VALUES (@categoryId, @specificationTypeId, @sortOrder, @enabled, @created, @created, @showInMatrix, @specDisplayLength, @displayName, @cssWidth)
	
	SET @id = SCOPE_IDENTITY() 

END
GO
GRANT EXECUTE ON dbo.adminProduct_AddCategorySpecificationType TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_GetCategorySpecificationTypeByCategoryIdSpecTypeId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_GetCategorySpecificationTypeByCategoryIdSpecTypeId
	@categoryId int,
	@specTypeId int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category_to_specification_type_id AS id, category_id, spec_type_id, sort_order, [enabled], modified, created, show_in_matrix,
			spec_display_length, display_name, css_width
	FROM category_to_specification_type
	WHERE category_id = @categoryId AND spec_type_id = @specTypeId

END
GO

GRANT EXECUTE ON dbo.adminProduct_GetCategorySpecificationTypeByCategoryIdSpecTypeId TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateCategorySpecificationType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateCategorySpecificationType
	@id int,
	@categoryId int,
	@specificationTypeId int,
	@sortOrder int,
	@showInMatrix bit,
	@enabled bit,
	@modified smalldatetime output,
	@specDisplayLength int,
	@displayName varchar(255),
	@cssWidth float
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE category_to_specification_type
	SET
		category_id = @categoryId,
		spec_type_id = @specificationTypeId,
		sort_order = @sortOrder,
		show_in_matrix = @showInMatrix,
		[enabled] = @enabled,
		modified = @modified,
		spec_display_length = @specDisplayLength,
		display_name = @displayName,
		css_width = @cssWidth
	WHERE category_to_specification_type_id = @id

END
GO

GRANT EXECUTE ON adminProduct_UpdateCategorySpecificationType TO VpWebApp
GO
-----------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategorySpecificationTypeByCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategorySpecificationTypeByCategoryIdList
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
	SET NOCOUNT ON;
	
	SELECT category_to_specification_type_id AS id, category_id, spec_type_id, sort_order
			, [enabled], modified, created, show_in_matrix, spec_display_length, display_name, css_width
	FROM category_to_specification_type
	WHERE category_id = @id
	ORDER BY sort_order

END
GO
GRANT EXECUTE ON dbo.publicProduct_GetCategorySpecificationTypeByCategoryIdList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategorySpecificationTypeDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategorySpecificationTypeDetail
	@id int
AS
-- ==========================================================================
-- $Author: Rifaz Rifky $
-- ==========================================================================
BEGIN
--
SET NOCOUNT ON;

	SELECT category_to_specification_type_id AS id, category_id, spec_type_id
			, sort_order, show_in_matrix, [enabled], modified, created, spec_display_length, display_name, css_width
	FROM category_to_specification_type
	WHERE category_to_specification_type_id = @id

END
GO

GRANT EXECUTE ON publicProduct_GetCategorySpecificationTypeDetail TO VpWebApp
GO
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------