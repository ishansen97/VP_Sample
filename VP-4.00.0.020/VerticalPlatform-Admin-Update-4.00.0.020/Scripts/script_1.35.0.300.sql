IF NOT EXISTS(SELECT * FROM module WHERE module_name = 'HorizontalSearchCategoryPanel')
BEGIN
INSERT INTO module (module_name, usercontrol_name, enabled, created, modified, is_container)
 VALUES('HorizontalSearchCategoryPanel', '~/Modules/ContentSearch/HorizontalSearchCategoryPanel.ascx', 1, GETDATE(), GETDATE(), 0)
END
GO