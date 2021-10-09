
---------------------------------
-- Akila
---------------------------------
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'title' AND Object_ID = Object_ID(N'product_multimedia_item'))
BEGIN
    ALTER TABLE product_multimedia_item
	ALTER COLUMN title varchar(MAX)
END
GO
---------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductMultimediaItem'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_AddProductMultimediaItem
	@productId int,
	@type tinyint,
	@title varchar(MAX),
	@thumbnail_link varchar(255),
	@sort_order int,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @created = GETDATE()

	INSERT INTO product_multimedia_item(product_id, [type], title, thumbnail_link, sort_order, enabled, modified, created)
	VALUES(@productId, @type, @title, @thumbnail_link, @sort_order, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY();

END
GO

GRANT EXECUTE ON dbo.adminProduct_AddProductMultimediaItem TO VpWebApp 
GO

---------------------------------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductMultimediaItem'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminProduct_UpdateProductMultimediaItem
	@id int,
	@productId int,
	@type tinyint,
	@title varchar(MAX),
	@thumbnail_link varchar(255),
	@sort_order int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Akila $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @modified = GETDATE()

	UPDATE product_multimedia_item
	SET product_id = @productId,
		 [type] = @type,
		 title = @title, 
		 thumbnail_link = @thumbnail_link,
		 sort_order = @sort_order,
		 enabled = @enabled,
		 modified = @modified
	WHERE product_multimedia_item_id = @id

END
GO

GRANT EXECUTE ON dbo.adminProduct_UpdateProductMultimediaItem TO VpWebApp 
GO

