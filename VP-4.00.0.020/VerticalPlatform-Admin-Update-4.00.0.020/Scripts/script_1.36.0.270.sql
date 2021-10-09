IF NOT EXISTS(SELECT parameter_type FROM parameter_type where parameter_type = 'EnableProductBasedArticleClickThroughs' )
BEGIN
	INSERT INTO parameter_type VALUES (164, 'EnableProductBasedArticleClickThroughs', '1', GETDATE(), GETDATE())
END
GO

IF NOT EXISTS (SELECT module_name FROM module WHERE module_name = 'ProviderContainer')
BEGIN
	INSERT INTO module VALUES ('ProviderContainer', '~/Containers/ProviderContainer/ProviderContainer.ascx'
		, '1', GETDATE(), GETDATE(), 1)
END
GO