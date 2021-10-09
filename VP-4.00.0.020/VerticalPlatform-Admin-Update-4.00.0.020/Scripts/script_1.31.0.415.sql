IF NOT EXISTS(SELECT * FROM predefined_page WHERE page_name = 'SubscriptionPreferences')
BEGIN
	INSERT INTO predefined_page(page_name,enabled,modified,created)
	VALUES('SubscriptionPreferences','1',GETDATE(),GETDATE())
END

-----------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_UnsubscribeSoftBouncedSubscribersList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_UnsubscribeSoftBouncedSubscribersList
	@optoutLimit int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH public_user_temp (email) AS
	(
		SELECT campaign_recipient.email
		FROM campaign_recipient
			INNER JOIN public_user
				ON public_user.email = campaign_recipient.email
		WHERE public_user.email_optout = 0 AND campaign_recipient.status = 1 
		GROUP BY campaign_recipient.email
		HAVING COUNT(*) >= @optoutLimit
	)
	
	UPDATE pu SET
		pu.email_optout = 1, 
		pu.modified = GETDATE()
	FROM public_user pu
		INNER JOIN public_user_temp
			ON pu.email = public_user_temp.email

END
GO

GRANT EXECUTE ON dbo.adminUser_UnsubscribeSoftBouncedSubscribersList TO VpWebApp 
GO

----------------------------------------------------------------------------------------


IF NOT EXISTS 
(
SELECT [name] FROM syscolumns where [name] = 'site_id' AND id = 
(SELECT object_id FROM sys.objects 
WHERE object_id = OBJECT_ID(N'fixed_url_setting') AND type in (N'U'))
)
BEGIN
	ALTER TABLE fixed_url_setting
		ADD site_id int 
END
GO

UPDATE fixed_url_setting
 SET site_id = fixed_url.site_id 
FROM fixed_url 
INNER JOIN fixed_url_setting ON fixed_url.fixed_url_id=fixed_url_setting.fixed_url_id AND fixed_url_setting.site_id IS NULL
GO

IF NOT EXISTS(SELECT * FROM fixed_url_setting WHERE site_id IS NULL)
BEGIN
	ALTER TABLE fixed_url_setting
		ALTER COLUMN site_id int not null
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[FK_fixed_url_setting_site]') AND parent_object_id = OBJECT_ID(N'[fixed_url_setting]'))
BEGIN
	ALTER TABLE [dbo].[fixed_url_setting]  WITH CHECK ADD  CONSTRAINT [FK_fixed_url_setting_site] FOREIGN KEY([site_id])
	REFERENCES [dbo].[site] ([site_id])

	ALTER TABLE [dbo].[fixed_url_setting] CHECK CONSTRAINT [FK_fixed_url_setting_site]
END
GO



---  SPs ----------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_AddFixedUrlSetting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_AddFixedUrlSetting
	@id int output,
	@fixedUrlId int,
	@fixedUrlSettingKey varchar(255),
	@fixedUrlSettingValue varchar(MAX),
	@siteId int,
	@enabled bit,
	@created smalldatetime output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminPlatform_AddFixedUrlSetting.sql $
-- $Revision: 6943 $
-- $Date: 2013-02-21 11:03:37 +0530 (Wed, 29 Sep 2010) $ 
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SET @created = GETDATE()

	INSERT INTO fixed_url_setting (fixed_url_id, fixed_url_setting_key, fixed_url_setting_value, [enabled], modified, created, site_id)
	VALUES(@fixedUrlId, @fixedUrlSettingKey, @fixedUrlSettingValue, @enabled, @created, @created, @siteId)

	SET @id = SCOPE_IDENTITY();

END
GO

GRANT EXECUTE ON dbo.adminPlatform_AddFixedUrlSetting TO VpWebApp 
GO
----------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlSettingDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlSettingDetail
	@id int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicPlatform_GetFixedUrlSettingDetail.sql $
-- $Revision: 6943 $
-- $Date: 2013-02-21 11:03:37 +0530 (Wed, 29 Sep 2010) $ 
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_setting_id as id, fixed_url_id, fixed_url_setting_key, fixed_url_setting_value,[enabled], modified, created, site_id
	FROM fixed_url_setting
	WHERE  fixed_url_setting_id = @id

END
GO

GRANT EXECUTE ON dbo.publicPlatform_GetFixedUrlSettingDetail TO VpWebApp 
GO
----------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_UpdateFixedUrlSetting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_UpdateFixedUrlSetting
	@id int,
	@fixedUrlId int,
	@fixedUrlSettingKey varchar(255),
	@fixedUrlSettingValue varchar(MAX),
	@siteId int,
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminPlatform_UpdateFixedUrlSetting.sql $
-- $Revision: 6943 $
-- $Date: 2010-09-29 11:03:37 +0530 (Wed, 29 Sep 2010) $ 
-- $Author: eranga $
-- ==========================================================================
BEGIN
	--
	SET NOCOUNT ON;
	
	SET @modified = GETDATE()

	UPDATE fixed_url_setting
		SET  fixed_url_id = @fixedUrlId,
			fixed_url_setting_key = @fixedUrlSettingKey,
			fixed_url_setting_value = @fixedUrlSettingValue,
			[enabled] = @enabled,
			modified = @modified,
			site_id = @siteId
		WHERE fixed_url_setting_id = @id 

END
GO

GRANT EXECUTE ON dbo.adminPlatform_UpdateFixedUrlSetting TO VpWebApp
GO
---------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlSettingsByFixedUrlIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlSettingsByFixedUrlIdList
	@fixedUrlId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicPlatform_GetFixedUrlSettingsByFixedUrlIdList.sql $
-- $Revision: 6943 $
-- $Date: 2010-09-29 11:03:37 +0530 (Wed, 29 Sep 2010) $ 
-- $Author: eranga $
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_setting_id AS id, fixed_url_id, fixed_url_setting_key, fixed_url_setting_value, enabled, created, modified, site_id
	FROM fixed_url_setting
	WHERE fixed_url_id = @fixedUrlId

END
GO

GRANT EXECUTE ON publicPlatform_GetFixedUrlSettingsByFixedUrlIdList TO VpWebApp
GO
---------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList
	@bulkEmailTypeId int,
	@siteId int,
	@pageSize int,
	@pageIndex int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH UserList AS
	(
		SELECT pup.public_user_profile_id AS id, ROW_NUMBER() OVER (ORDER BY pup.public_user_id) AS row_id, pup.public_user_id, pup.salutation, pup.first_name, pup.last_name,
			pup.address_line1, pup.address_line2, pup.city, pup.[state], pup.country_id, pup.phone_number, pup.postal_code, pup.company, pu.email
		FROM public_user pu
			INNER JOIN public_user_profile pup
				ON pu.public_user_id = pup.public_user_id
		WHERE pu.site_id = @siteId AND pu.email_optout = 0 AND pu.enabled = 1 AND pu.public_user_id IN
		(
			SELECT DISTINCT puf.public_user_id
			FROM public_user_field puf
				INNER JOIN bulk_email_type_to_field btf
					ON btf.bulk_email_type_id = @bulkEmailTypeId
				INNER JOIN field f
					ON btf.field_id = f.field_id
				INNER JOIN public_user_field_to_field_option pufo
					ON puf.public_user_field_id = pufo.public_user_field_id
			WHERE puf.field_id = f.field_id AND f.field_type_id = 3
		)
	)
	
	SELECT id, public_user_id, salutation, first_name, last_name
		, address_line1, address_line2, city, [state], country_id, phone_number, postal_code, company
		, email
	FROM UserList
	WHERE row_id BETWEEN @startIndex AND @endIndex

	SELECT DISTINCT @totalCount = COUNT(*)
	FROM public_user pu
	WHERE pu.site_id = @siteId AND pu.email_optout = 0 AND pu.enabled = 1 AND pu.public_user_id IN
	(
		SELECT DISTINCT puf.public_user_id
		FROM public_user_field puf
			INNER JOIN bulk_email_type_to_field btf
				ON btf.bulk_email_type_id = @bulkEmailTypeId
			INNER JOIN field f
				ON btf.field_id = f.field_id
			INNER JOIN public_user_field_to_field_option pufo
				ON puf.public_user_field_id = pufo.public_user_field_id
		WHERE puf.field_id = f.field_id AND f.field_type_id = 3
	)


END
GO

GRANT EXECUTE ON dbo.adminUser_GetPublicUserProfileInfoByBulkEmailTypeIdSiteIdList TO VpWebApp 
GO

--------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicPlatform_GetFixedUrlSettingByFixedUrlIdAndSettingKey'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicPlatform_GetFixedUrlSettingByFixedUrlIdAndSettingKey
	@fixedUrlId int,
	@settingKey varchar(255),
	@siteId int
AS
-- ==========================================================================
-- $Date: 2012-10-26
-- $Author: eranga $
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SELECT fixed_url_setting_id AS id, fixed_url_id, fixed_url_setting_key, fixed_url_setting_value, enabled, created, modified, site_id
	FROM fixed_url_setting
	WHERE fixed_url_id = @fixedUrlId AND fixed_url_setting_key = @settingKey AND site_id=@siteId

END
GO

GRANT EXECUTE ON publicPlatform_GetFixedUrlSettingByFixedUrlIdAndSettingKey TO VpWebApp
GO

EXEC dbo.global_DropStoredProcedure 'dbo.adminPlatform_GetContentMetadataByPageId'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminPlatform_GetContentMetadataByPageId
	@pageId int
AS
-- ==========================================================================
-- $Author: Dimuthu $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT content_metadata_to_page_id as id,
		page_id,
		content_metadata_id,
		displayed,
		created,
		modified,
		enabled
	FROM content_metadata_to_page
	WHERE  page_id = @pageId	

END
GO

GRANT EXECUTE ON dbo.adminPlatform_GetContentMetadataByPageId TO VpWebApp 
GO
------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 147)
BEGIN
	INSERT INTO parameter_type VALUES (147, 'OverrideCategoryPageTitle', '1', GETDATE(), GETDATE())
END
GO
--------------------------------------------------------------------------------------------------
UPDATE task_setting
SET setting_name = 'UpdateproductDisplayStatusTaskBatchSize'
where setting_name COLLATE Latin1_General_CS_AS= 'updateproductDisplayStatusTaskBatchSize'
----------------------------------------------
