IF NOT EXISTS (SELECT * FROM module m WHERE m.module_name = 'FeaturedVendorArticles')
BEGIN
	INSERT INTO [module]
		([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES
		('FeaturedVendorArticles','~/Modules/Article/FeaturedVendorArticles.ascx',1,GETDATE(),GETDATE(),0)	
END
GO
---------------------------------------------------------------------------------------------------------