EXEC dbo.global_DropStoredProcedure 'dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId
	@productId INT,
	@categoryId INT
AS
-- ==========================================================================
-- $Author: Chirath $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT product_to_category_id AS id, product_id, category_id, enabled, modified, created
	FROM product_to_category
	WHERE product_id = @productId AND category_id = @categoryId

END
GO

GRANT EXECUTE ON dbo.adminProductCategory_GetProductCategoryByProductIdAndCategoryId TO VpWebApp 
GO
---------------------------------------------------------------------------------------------------------

--==== parameter_type

GO

DELETE FROM dbo.parameter_type WHERE parameter_type =  'RapidRuleFileContent'

--UPDATE dbo.parameter_type SET parameter_type_id = 212 WHERE parameter_type = 

INSERT INTO	dbo.parameter_type
(
    parameter_type_id,
    parameter_type,
    enabled,
    modified,
    created
)
VALUES
(    212,                     -- parameter_type_id - int
    'RapidRuleFileContent',                    -- parameter_type - varchar(50)
    1,                  -- enabled - bit
    '2020-09-07 11:34:52', -- modified - smalldatetime
    '2020-09-07 11:34:52'  -- created - smalldatetime
)

GO


