-----------------Dropping tables---------------------------

IF OBJECT_ID('dbo.subcategory_to_search_option', 'U') IS NOT NULL 
  DROP TABLE subcategory_to_search_option
  
IF OBJECT_ID('dbo.subcategory_rule_group_option', 'U') IS NOT NULL 
  DROP TABLE subcategory_rule_group_option

IF OBJECT_ID('dbo.subcategory_rule_group', 'U') IS NOT NULL 
  DROP TABLE subcategory_rule_group
  
IF OBJECT_ID('dbo.subcategory_rule', 'U') IS NOT NULL 
  DROP TABLE subcategory_rule
  
IF OBJECT_ID('dbo.subcategory_products', 'U') IS NOT NULL 
  DROP TABLE subcategory_products
  
IF OBJECT_ID('dbo.subcategory', 'U') IS NOT NULL 
  DROP TABLE subcategory

--------------Dropping SPs---------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryBySiteIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoriesBySiteId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_AddProductsToSubcategory'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryBySiteIdListWithPaging'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategories'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubcategory_GetCategoryBySearchOptions'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubcategory_GetCategoryBySearchOptionsAndRuleId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_AddSubcategoryProducts'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_AddSubcategoryProductsFilterByLastRunDate'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_UpdateSubcategoryProducts'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryProductsBySiteId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryProductIdsWithPaging'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRule'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_AddSubcategoryRule'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_UpdateSubcategoryRule'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryRuleDetail'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryRulesBySiteIdWithPagingList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRulesBySiteId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRuleGroup'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_AddSubcategoryRuleGroup'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_UpdateSubcategoryRuleGroup'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryRuleGroupDetail'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryRuleGroupsByRuleIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRuleGroupsBySiteId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRuleGroupsByRuleId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRuleGroupOption'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_AddSubcategoryRuleGroupOption'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_UpdateSubcategoryRuleGroupOption'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryRuleGroupOptionDetail'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryRuleGroupOptionsByRuleGroupIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRuleGroupOptionsBySiteId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategoryRuleGroupOptionsByRuleId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategorySearchOption'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_AddSubcategorySearchOption'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_UpdateSubcategorySearchOption'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategorySearchOptionDetail'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategorySearchOptionsByCategoryIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategorySearchOptionsBySiteId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_DeleteSubcategorySearchOptionsByCategoryId'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubcategory_GetSearchOptionsBySubcategoryRuleGroupIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubcategory_GetSearchOptionsBySiteIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubcategory_GetSubcategorySearchOptionsBySubcategoryRuleIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubcategory_GetCategoriesBySubcategoryIds'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryRulesBySiteIdList'

EXEC dbo.global_DropStoredProcedure 'dbo.adminSubCategory_GetSubcategoryDetail'
