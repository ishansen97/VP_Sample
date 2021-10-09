
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetCategoryHavingProductsOrVendorsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetCategoryHavingProductsOrVendorsList
	@categoryId int
AS
-- ==========================================================================
-- $Author: Sahan Diasena $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT category.category_id AS id, site_id, category_name, category_type_id, [description], short_name, specification
		, is_search_category, is_displayed, category.enabled, category.modified, category.created
		, matrix_type, product_count, auto_generated, category.hidden, has_image, url_id
	FROM
	(
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category 
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
		WHERE category_to_category_branch.category_id = @categoryId AND category_to_category_branch.enabled = 1
			AND category_to_category_branch.hidden = 0 AND category.hidden = 0
			AND
			(
				(category_type_id <> 4)
				OR 
				(
					(SELECT COUNT(product_id)
					FROM product_to_category
					WHERE product_to_category.category_id = category.category_id) > 0
				)
			)

		UNION

		SELECT category.category_id, category_to_category_branch.sort_order 
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN category_to_vendor
				ON category.category_id = category_to_vendor.category_id
			INNER JOIN vendor
				ON category_to_vendor.vendor_id = vendor.vendor_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = 1 AND category_to_category_branch.hidden = 0 AND
			category.category_type_id = 4 AND category.hidden = 0 AND
			vendor.[enabled] = 1 AND category_to_vendor.[enabled] = 1
			
		UNION
		
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN fixed_guided_browse
				ON category.category_id = fixed_guided_browse.category_id
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = 1 AND category_to_category_branch.hidden = 0 AND
			category.category_type_id = 4 AND category.hidden = 0 AND fixed_guided_browse.[enabled] = 1
			
		UNION
		
		SELECT category.category_id, category_to_category_branch.sort_order
		FROM category
			INNER JOIN category_to_category_branch
				ON category.category_id = category_to_category_branch.sub_category_id
			INNER JOIN category_parameter
				ON category.category_id = category_parameter.category_id AND category_parameter.parameter_type_id = 143
		WHERE 
			category_to_category_branch.category_id = @categoryId AND 
			category_to_category_branch.enabled = 1 AND category_to_category_branch.hidden = 0 AND
			category.category_type_id = 4 AND category.hidden = 0 AND category_parameter.category_parameter_value IS NOT NULL
	) temp_table
		INNER JOIN category
			ON temp_table.category_id = category.category_id
	ORDER BY sort_order ASC, category_name ASC
END
GO

GRANT EXECUTE ON dbo.publicProduct_GetCategoryHavingProductsOrVendorsList TO VpWebApp 
GO

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'SearchProvider' AND parameter_type_id = 167)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(167,'SearchProvider','1',GETDATE(),GETDATE())
END
GO

INSERT [dbo].[site_parameter]
	([site_id],[parameter_type_id],[site_parameter_value],[enabled],[modified],[created])
	SELECT DISTINCT mi.site_id, 167, 1, 1, GETDATE(), GETDATE()
	FROM module_instance_setting mis 
	INNER JOIN module_instance mi ON mi.module_instance_id = mis.module_instance_id
	LEFT JOIN [site_parameter] sp ON sp.site_id = mi.site_id AND sp.parameter_type_id = 167
	WHERE name ='MatrixEnableElasticSearch' AND mis.value = 'True' AND sp.parameter_type_id IS NULL
GO

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'FeaturedWeightPercentage' AND parameter_type_id = 168)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(168, 'FeaturedWeightPercentage', '1', GETDATE(), GETDATE())
END
GO

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'StandardWeightPercentage' AND parameter_type_id = 169)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(169, 'StandardWeightPercentage', '1', GETDATE(), GETDATE())
END
GO

IF NOT EXISTS (SELECT * FROM [parameter_type] WHERE parameter_type = 'MinimizedWeightPercentage' AND parameter_type_id = 170)
BEGIN
	INSERT INTO [parameter_type]([parameter_type_id],[parameter_type],[enabled],[modified],[created])
	VALUES(170, 'MinimizedWeightPercentage', '1', GETDATE(), GETDATE())
END
GO

