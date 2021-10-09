IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 194)
BEGIN
	INSERT INTO parameter_type VALUES (194, 'ShowCategorySearchGroupsSearchOptions', '1', GETDATE(), GETDATE())
END
GO