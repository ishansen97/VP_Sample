IF EXISTS(SELECT name FROM sys.tables WHERE name = 'product_compression_group_order')
BEGIN
	DROP TABLE dbo.[product_compression_group_order]
END
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_AddProductCompressionGroupOrder'
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupOrderDetail'
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_UpdateProductCompressionGroupOrder'
EXEC dbo.global_DropStoredProcedure 'dbo.adminProduct_DeleteProductCompressionGroupOrder'



