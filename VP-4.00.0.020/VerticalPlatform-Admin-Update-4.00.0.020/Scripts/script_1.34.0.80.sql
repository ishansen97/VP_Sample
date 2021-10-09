IF NOT EXISTS(SELECT module_name FROM dbo.module WHERE module_name = 'DisqusComment')
BEGIN
INSERT INTO dbo.module (module_name, usercontrol_name,enabled,is_container)
VALUES ('DisqusComment','~/Modules/Article/DisqusComment.ascx',1,0)
END
GO

