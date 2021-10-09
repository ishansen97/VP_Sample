DELETE 
FROM [module_instance_setting]
WHERE [module_instance_setting].[module_instance_id] IN
	(
		SELECT [module_instance].[module_instance_id]
		FROM [module_instance]
			INNER JOIN [module]
			ON [module].[module_id] = [module_instance].[module_id] AND [module].[module_name] = 'ReviewTypeList'
	)