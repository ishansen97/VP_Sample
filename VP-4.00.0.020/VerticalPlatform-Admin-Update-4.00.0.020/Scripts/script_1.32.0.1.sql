BEGIN TRY 
	BEGIN TRANSACTION 
		DECLARE @predefinedPageId int
		DECLARE @reviewFormListModuleId int
		DECLARE @pageContentTypeId int

		SET @predefinedPageId = NULL
		SET @reviewFormListModuleId = NULL
		SET @pageContentTypeId = (SELECT content_type_id FROM content_type WHERE content_type = 'Page')
		
		IF NOT EXISTS (SELECT * FROM [predefined_page] WHERE page_name = 'ReviewTypeList')
		BEGIN
			INSERT INTO [predefined_page] (page_name, enabled, modified, created)
			VALUES ('ReviewTypeList', 1, GETDATE(), GETDATE())

			SET @predefinedPageId = @@IDENTITY
		END

		IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'ReviewTypeList')
		BEGIN
			INSERT INTO module ([module_name], [usercontrol_name], [enabled], [modified], [created], [is_container])
			VALUES('ReviewTypeList','~/Modules/Reviews/ReviewTypeList.ascx','1',GETDATE(),GETDATE(), 0)

			SET @reviewFormListModuleId = @@IDENTITY
		END

		IF ((@predefinedPageId IS NOT NULL) AND (@reviewFormListModuleId IS NOT NULL))
		BEGIN
			INSERT INTO [predefined_page_module] ([predefined_page_id],[module_id],[enabled],[modified],[created])
			VALUES (@predefinedPageId, @reviewFormListModuleId, 1, GETDATE(), GETDATE())

			--Insert the page for each site and the related modules
			DECLARE @siteId int
			DECLARE @pageId int
			DECLARE @sortOrder int
			DECLARE @primaryContainerId int
			DECLARE @primaryContainerModuleInstanceId int

			IF NOT EXISTS(SELECT * FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1')
			BEGIN
				INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
				VALUES ('PrimaryContainer', '~/Containers/PrimaryContainer/PrimaryContainer.ascx',
						'1', GETDATE(), GETDATE(), '1')
				SET @primaryContainerId = SCOPE_IDENTITY();
			END
			ELSE
			BEGIN
				SELECT @primaryContainerId = module_id FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1'
			END
			
			DECLARE siteCursor CURSOR 
			FOR (SELECT site_id FROM site)
			OPEN siteCursor
			FETCH NEXT FROM siteCursor INTO @siteId
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT top(1) @sortOrder = [sort_order] 
					FROM [page]
					WHERE site_id = @siteId
					ORDER BY sort_order DESC
				
					--Insert the site pages
					INSERT INTO [page] ([site_id], [predefined_page_id], [parent_page_id], [page_name], [page_title], 
						[keywords], [template_name], [sort_order], [navigable], [hidden], [log_in_to_view], [enabled], 
						[modified], [created], [page_title_prefix], [page_title_suffix], [description_prefix], 
						[description_suffix], [include_in_sitemap], [navigation_title], [default_title_prefix])
					VALUES (@siteId, @predefinedPageId, NULL, 'ReviewTypeList', 'Review Type List', '', '~/Templates/TwoColumnLayout/TwoColumnLayout.ascx',
						(@sortOrder + 1), 0, 0, 0, 1, GETDATE(), GETDATE(), '', '', '', '', 1, 'Review Type List', '')
					   
					SET @pageId = @@IDENTITY
					
					--Formating page name
					DECLARE @formatedPageName varchar(255)
					EXEC dbo.global_FormatUrl 'ReviewTypeList', @formatedPageName output

					--Creating site page url
					DECLARE @url varchar(255)
					SET @url = '/' + CONVERT(varchar(10), @pageId) + '-' + @formatedPageName + '/'

					INSERT INTO [fixed_url] ([fixed_url], [site_id], [page_id], [content_type_id], [content_id], 
						[query_string], [enabled], [created], [modified])
					VALUES (@url, @siteId, @pageId, @pageContentTypeId, @pageId, '', 1, GETDATE(), GETDATE())

					-- Insert the module instances
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @primaryContainerId, 'Primary Container', 'contentPane', 1, 1, GETDATE(), GETDATE(), NULL, @siteId, 
						NULL, NULL)
					
					SET @primaryContainerModuleInstanceId = @@IDENTITY
					
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @reviewFormListModuleId, 'Review Type List', 'contentPane', 1, 1, GETDATE(), GETDATE(), 
						NULL, @siteId, NULL, @primaryContainerModuleInstanceId)

					FETCH NEXT FROM siteCursor INTO @siteId			
				END
			CLOSE siteCursor
			DEALLOCATE siteCursor
		END
		
    COMMIT TRAN 
	
END TRY
BEGIN CATCH
    ROLLBACK TRAN
	
	IF (CURSOR_STATUS('global','siteCursor') > 0)
		BEGIN
			CLOSE siteCursor
			DEALLOCATE siteCursor			
		END
	PRINT ERROR_MESSAGE()
	
END CATCH
GO
---------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN TRY 
	BEGIN TRANSACTION 
		DECLARE @predefinedPageId int
		DECLARE @reviewFormModuleId int
		DECLARE @pageContentTypeId int

		SET @predefinedPageId = NULL
		SET @reviewFormModuleId = NULL
		SET @pageContentTypeId = (SELECT content_type_id FROM content_type WHERE content_type = 'Page')
		
		IF NOT EXISTS (SELECT * FROM [predefined_page] WHERE page_name = 'ReviewForm')
		BEGIN
			INSERT INTO [predefined_page] (page_name, enabled, modified, created)
			VALUES ('ReviewForm', 1, GETDATE(), GETDATE())

			SET @predefinedPageId = @@IDENTITY
		END

		IF NOT EXISTS (SELECT * FROM [module] WHERE [module_name] = 'ReviewForm')
		BEGIN
			INSERT INTO module ([module_name], [usercontrol_name], [enabled], [modified], [created], [is_container])
			VALUES('ReviewForm','~/Modules/Reviews/ReviewForm.ascx','1',GETDATE(),GETDATE(), 0)

			SET @reviewFormModuleId = @@IDENTITY
		END

		IF ((@predefinedPageId IS NOT NULL) AND (@reviewFormModuleId IS NOT NULL))
		BEGIN
			INSERT INTO [predefined_page_module] ([predefined_page_id],[module_id],[enabled],[modified],[created])
			VALUES (@predefinedPageId, @reviewFormModuleId, 1, GETDATE(), GETDATE())

			--Insert the page for each site and the related modules
			DECLARE @siteId int
			DECLARE @pageId int
			DECLARE @sortOrder int
			DECLARE @primaryContainerId int
			DECLARE @primaryContainerModuleInstanceId int

			IF NOT EXISTS(SELECT * FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1')
			BEGIN
				INSERT INTO module (module_name, usercontrol_name, enabled, modified, created, is_container)
				VALUES ('PrimaryContainer', '~/Containers/PrimaryContainer/PrimaryContainer.ascx',
						'1', GETDATE(), GETDATE(), '1')
				SET @primaryContainerId = SCOPE_IDENTITY();
			END
			ELSE
			BEGIN
				SELECT @primaryContainerId = module_id FROM module WHERE usercontrol_name = '~/Containers/PrimaryContainer/PrimaryContainer.ascx' AND is_container = '1'
			END
			
			DECLARE siteCursor CURSOR 
			FOR (SELECT site_id FROM site)
			OPEN siteCursor
			FETCH NEXT FROM siteCursor INTO @siteId
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT top(1) @sortOrder = [sort_order] 
					FROM [page]
					WHERE site_id = @siteId
					ORDER BY sort_order DESC
				
					--Insert the site pages
					INSERT INTO [page] ([site_id], [predefined_page_id], [parent_page_id], [page_name], [page_title], 
						[keywords], [template_name], [sort_order], [navigable], [hidden], [log_in_to_view], [enabled], 
						[modified], [created], [page_title_prefix], [page_title_suffix], [description_prefix], 
						[description_suffix], [include_in_sitemap], [navigation_title], [default_title_prefix])
					VALUES (@siteId, @predefinedPageId, NULL, 'ReviewForm', 'Review Form', '', '~/Templates/TwoColumnLayout/TwoColumnLayout.ascx',
						(@sortOrder + 1), 0, 0, 0, 1, GETDATE(), GETDATE(), '', '', '', '', 1, 'Review Form', '')
					   
					SET @pageId = @@IDENTITY
					
					--Formating page name
					DECLARE @formatedPageName varchar(255)
					EXEC dbo.global_FormatUrl 'ReviewForm', @formatedPageName output

					--Creating site page url
					DECLARE @url varchar(255)
					SET @url = '/' + CONVERT(varchar(10), @pageId) + '-' + @formatedPageName + '/'

					INSERT INTO [fixed_url] ([fixed_url], [site_id], [page_id], [content_type_id], [content_id], 
						[query_string], [enabled], [created], [modified])
					VALUES (@url, @siteId, @pageId, @pageContentTypeId, @pageId, '', 1, GETDATE(), GETDATE())

					-- Insert the module instances
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @primaryContainerId, 'Primary Container', 'contentPane', 1, 1, GETDATE(), GETDATE(), NULL, @siteId, 
						NULL, NULL)
					
					SET @primaryContainerModuleInstanceId = @@IDENTITY
					
					INSERT INTO [module_instance] ([page_id], [module_id], [title], [pane], [sort_order], [enabled], 
						[modified], [created], [custom_css_class], [site_id], [title_link_url], [parent_module_instance_id])
					VALUES (@pageId, @reviewFormModuleId, 'Review Form', 'contentPane', 1, 1, GETDATE(), GETDATE(), 
						NULL, @siteId, NULL, @primaryContainerModuleInstanceId)

					FETCH NEXT FROM siteCursor INTO @siteId			
				END
			CLOSE siteCursor
			DEALLOCATE siteCursor
		END
		
    COMMIT TRAN 
	
END TRY
BEGIN CATCH
    ROLLBACK TRAN
	
	IF (CURSOR_STATUS('global','siteCursor') > 0)
		BEGIN
			CLOSE siteCursor
			DEALLOCATE siteCursor			
		END
	PRINT ERROR_MESSAGE()
	
END CATCH
GO
---------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM article_resource_type WHERE type_name = 'Rating')
BEGIN
	INSERT INTO article_resource_type
		VALUES(18, 'Rating', 1, GETDATE(), GETDATE())
END
GO
----------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM content_type WHERE content_type = 'ReviewType')
BEGIN
 INSERT INTO content_type (content_type_id, content_type, enabled, modified, created)
 VALUES (36, 'ReviewType', 1, GETDATE(), GETDATE())
END
GO
----------------------------------------------------------------------------------------------------------------------------------------------------
