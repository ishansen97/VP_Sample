
---------------------------------
-- Added AnchorLinkContainer
-- Chinthaka Fernando
---------------------------------
IF NOT EXISTS (SELECT * FROM module m WHERE m.module_name = 'AnchorLinkContainer')
BEGIN
	INSERT INTO [module]
		([module_name],[usercontrol_name],[enabled],[modified],[created],[is_container])
	VALUES
		('AnchorLinkContainer','~/Containers/AnchorLinkContainer/AnchorLinkContainer.ascx',1,GETDATE(),GETDATE(),1)	
END
GO
---------------------------------------------------------------------------------------------------------


--===================  
--    Roshan 
--===================   
IF NOT EXISTS(	SELECT	*	FROM	module	WHERE	module_name = 'StickyHeader')
BEGIN
	INSERT INTO module
	(module_name,usercontrol_name,enabled,modified,created,is_container)
	VALUES
	('StickyHeader','~/Modules/ProductDetail/StickyHeaders.ascx',1,GETDATE(),GETDATE(),0)
END

--------------------------------------------------------------------------------------------------------