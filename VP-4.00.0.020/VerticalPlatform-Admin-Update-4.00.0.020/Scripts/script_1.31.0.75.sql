EXEC dbo.global_DropStoredProcedure 'dbo.publicSearchCategory_GetSearchOptionsByGroupIdVendorIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearchCategory_GetSearchOptionsByGroupIdVendorIdsList
	@groupId int,
	@vendorIds varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled, so.modified
	FROM
	(
		SELECT DISTINCT s.search_option_id
		FROM search_option s
			INNER JOIN product_to_search_option po
				ON po.search_option_id = s.search_option_id
			INNER JOIN product_to_vendor pv
				ON pv.product_id = po.product_id
		WHERE search_group_id = @groupId
			AND pv.vendor_id IN (SELECT [value] FROM global_Split(@vendorIds, ','))
	) AS o
	INNER JOIN search_option so
		ON so.search_option_id = o.search_option_id
	ORDER BY so.sort_order ASC, so.[name] ASC
	
END
GO

GRANT EXECUTE ON dbo.publicSearchCategory_GetSearchOptionsByGroupIdVendorIdsList TO VpWebApp 
GO

----

EXEC dbo.global_DropStoredProcedure 'dbo.publicSearch_GetSearchOptionsByCategorySearchGroupIdVendorIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicSearch_GetSearchOptionsByCategorySearchGroupIdVendorIdsList
	@categorySearchGroupId int,
	@vendorIds varchar(max)
AS
-- ==========================================================================
-- $ Author : Dilshan $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT so.search_option_id AS id, so.search_group_id, so.[name], so.sort_order, so.created, so.enabled, so.modified
	FROM
	(
		SELECT DISTINCT s.search_option_id
		FROM search_option s
			INNER JOIN	category_to_search_group_to_search_option cgo
				ON cgo.search_option_id = s.search_option_id
			INNER JOIN product_to_search_option po
				ON po.search_option_id = s.search_option_id
			INNER JOIN product_to_vendor pv
				ON pv.product_id = po.product_id
		WHERE cgo.category_to_search_group_id = @categorySearchGroupId
			AND pv.vendor_id IN (SELECT [value] FROM global_Split(@vendorIds, ','))  
	) AS o
	INNER JOIN search_option so
		ON so.search_option_id = o.search_option_id
	ORDER BY so.sort_order ASC, so.[name] ASC

END
GO

GRANT EXECUTE ON dbo.publicSearch_GetSearchOptionsByCategorySearchGroupIdVendorIdsList TO VpWebApp 
GO

--------------------------------------------------------------------------

IF NOT EXISTS
(
SELECT [name] FROM syscolumns WHERE [name] = 'has_image' AND id =
(SELECT object_id FROM sys.objects
WHERE object_id = OBJECT_ID(N'author') AND type in (N'U'))
)
BEGIN
	ALTER TABLE author
		ADD has_image bit
END
GO
----------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM author WHERE has_image IS NULL)
BEGIN
	UPDATE author
		SET has_image = 0
END
GO
------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_AddAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_AddAuthor
	@siteId int,
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@organization varchar(250),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminArticle_AddAuthor.sql $ 
-- $Revision: 6105 $ 
-- $Date: 2010-08-03 16:43:55 +0530 (Tue, 03 Aug 2010) $ 
-- $Author: eranga $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO author(site_id,first_name, last_name, title, organization, position, department, profile_html, [enabled], created, modified, has_image)
	VALUES (@siteId,@firstName, @lastName, @title, @organization,@position,@department, @profileHtml, @enabled, @created, @created, @hasImage)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminArticle_AddAuthor TO VpWebApp 
GO
---------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateAuthor'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateAuthor
	@id int,
	@siteId int, 
	@firstName varchar(100),
	@lastName varchar(100),
	@title varchar(10),
	@position varchar(100),
	@department varchar(100),
	@profileHtml varchar(max),	
	@hasImage bit,
	@enabled bit,
	@organization varchar(250),	
	@modified smalldatetime output 
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminArticle_UpdateAuthor.sql $ 
-- $Revision: 6105 $ 
-- $Date: 2010-08-03 16:43:55 +0530 (Tue, 03 Aug 2010) $ 
-- $Author: eranga $ 
-- ==========================================================================

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.author
	SET site_id = @siteId,
		first_name =@firstName,
		last_name = @lastName,
		title = @title,
		position = @position,
		department = @department, 
		profile_html = @profileHtml, 
		enabled = @enabled,
		organization = @organization,
		modified = @modified,
		has_image = @hasImage
	WHERE author_id = @id

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateAuthor TO VpWebApp 
GO
---------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetAuthorDetail
@id int
	
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicArticle_GetAuthorDetail.sql $ 
-- $Revision: 6105 $ 
-- $Date: 2010-08-03 16:43:55 +0530 (Tue, 03 Aug 2010) $
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, department, profile_html, has_image, enabled, created, modified
	FROM author	
	WHERE author_id = @id 

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetAuthorDetail TO VpWebApp 
GO
-----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetAuthorsBySiteId
	@siteId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/adminArticle_GetAuthorsBySiteId.sql $ 
-- $Revision: 6105 $
-- $Date: 2010-08-03 16:43:55 +0530 (Tue, 03 Aug 2010) $
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, enabled, created, modified, has_image
	FROM author
	WHERE site_id = @siteId
	ORDER BY  first_name, last_name

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteId TO VpWebApp 
GO
---------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicArticle_GetAuthorsByArticleId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicArticle_GetAuthorsByArticleId
	@articleId int
AS
-- ==========================================================================
-- $URL: https://avatar/svn/VerticalPlatform/trunk/db/VerticalPlatformDB/publicArticle_GetAuthorsByArticleId.sql $
-- $Revision: 6105 $ 
-- $Date: 2010-08-03 16:43:55 +0530 (Tue, 03 Aug 2010) $
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT aut.author_id as id, aut.site_id, aut.first_name, aut.last_name, aut.title, aut.organization
			, aut.position, aut.department, aut.profile_html, aut.enabled, aut.created, aut.modified, aut.has_image
	FROM author aut
		INNER JOIN article_to_author ata
			ON ata.author_id= aut.author_id 
	
	WHERE ata.article_id = @articleId
	ORDER BY ata.article_to_author_id 

END
GO

GRANT EXECUTE ON dbo.publicArticle_GetAuthorsByArticleId TO VpWebApp 
GO
-------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList  
 @siteId int,  
 @startRowIndex int,  
 @endRowIndex int,  
 @totalRowCount int output  
AS  
-- ==========================================================================  
-- $Author: eranga $  
-- ==========================================================================  
BEGIN  
   
 SET NOCOUNT ON;  
  
 WITH AuthorList AS  
 (  
  SELECT author_id as id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id, has_image  
  FROM author  
  WHERE site_id = @siteId   
 )  
  
 SELECT id, site_id, first_name, last_name, title, organization, position,   
    department, profile_html, enabled, created, modified, has_image 
 FROM AuthorList  
 WHERE row_id BETWEEN @startRowIndex AND @endRowIndex  
  
 SELECT @totalRowCount = COUNT(*)  
 FROM author  
 WHERE site_id = @siteId   
  
END  
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsBySiteIdStartRowIndexEndRowIndexList TO VpWebApp 
GO
--------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList
	@siteId int,
	@authorId int = NULL,
	@firstName varchar(100) = NULL,
	@lastName varchar(100)	= NULL,
	@startRowIndex int,
	@endRowIndex int,
	@totalRowCount int output
AS
-- ==========================================================================
-- $Author: eranga $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	WITH AuthorList AS
	(
		SELECT author_id as id, site_id, first_name, last_name, title, organization, position, has_image,
				department, profile_html, enabled, created, modified, ROW_NUMBER() OVER (ORDER BY first_name) AS row_id
		FROM author
		WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')
	)

	SELECT id, site_id, first_name, last_name, title, organization, position, department, profile_html, enabled, created, modified, has_image
	FROM AuthorList
	WHERE row_id BETWEEN @startRowIndex AND @endRowIndex

	SELECT @totalRowCount = COUNT(*)
	FROM author
	WHERE site_id = @siteId
		AND (@authorId IS NULL OR author_Id = @authorId)
		AND (@firstName IS NULL OR first_name LIKE	@firstName + '%')
		AND (@lastName IS NULL OR last_name LIKE	@lastName + '%')

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorsByAuthorIdOrFirstNameOrLastNameList TO VpWebApp 
GO
------------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetAuthorInformationsByArticleIdsList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetAuthorInformationsByArticleIdsList
	@articleIds varchar(max)
AS
-- ==========================================================================
-- $Author: eranga
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SELECT a.author_id as id, site_id, first_name, last_name, title, organization, position, 
			department, profile_html, a.enabled, a.created, a.modified, aa.article_id, a.has_image
	FROM author a
		INNER JOIN article_to_author aa ON  a.author_id = aa.author_id
	WHERE aa.article_id IN (SELECT [value] FROM Global_Split(@articleIds, ',') )

END
GO

GRANT EXECUTE ON dbo.adminArticle_GetAuthorInformationsByArticleIdsList TO VpWebApp 
GO
----------------------------------------------------------
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name = 'spider_setting')
BEGIN

	CREATE TABLE [dbo].[spider_setting](
		[spider_setting_id] [int] IDENTITY(1,1) NOT NULL,
		[spider_ip_group_id] [int] NOT NULL,
		[name] [varchar](200) NOT NULL,
		[value] [varchar](max) NOT NULL,
		[enabled] [bit] NOT NULL,
		[modified] [smalldatetime] NOT NULL,
		[created] [smalldatetime] NOT NULL,
	 CONSTRAINT [PK_spider_setting] PRIMARY KEY CLUSTERED 
	(
		[spider_setting_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
END
GO
----------------------------------------

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_spider_setting_spider_ip_group') AND parent_object_id = OBJECT_ID(N'spider_setting'))
BEGIN

	ALTER TABLE [dbo].[spider_setting]  WITH CHECK ADD  CONSTRAINT [FK_spider_setting_spider_ip_group] FOREIGN KEY([spider_ip_group_id])
	REFERENCES [dbo].[spider_ip_group] ([ip_group_id])
	ALTER TABLE [dbo].[spider_setting] CHECK CONSTRAINT [FK_spider_setting_spider_ip_group]

END
GO
--------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_AddSpiderSetting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_AddSpiderSetting
	@ipGorupId int,
	@name varchar(200),
	@value varchar(max),
	@enabled bit,
	@created smalldatetime output,
	@id int output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO dbo.spider_setting(spider_ip_group_id, name, [value], enabled, modified, created)
	VALUES(@ipGorupId, @name, @value, @enabled, @created, @created )

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSpider_AddSpiderSetting TO VpWebApp 
GO
----------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_GetSpiderSettingDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_GetSpiderSettingDetail
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [spider_setting_id] As id
		  ,[spider_ip_group_id]
		  ,[name]
		  ,[value]
		  ,[enabled]
		  ,[modified]
		  ,[created]
	  FROM [dbo].[spider_setting]
	WHERE spider_setting_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpider_GetSpiderSettingDetail TO VpWebApp 
GO
----------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_UpdateSpiderSetting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_UpdateSpiderSetting
	@id int,
	@ipGorupId int,
	@name varchar(200),
	@value varchar(max),
	@enabled bit,
	@modified smalldatetime output
AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()
	UPDATE spider_setting
	SET [spider_ip_group_id] = @ipGorupId
	  ,[name] = @name
	  ,[value] = @value
	  ,[enabled] = @enabled
	  ,[modified] = @modified
	WHERE spider_setting_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpider_UpdateSpiderSetting TO VpWebApp 
GO
---------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_DeleteSpiderSetting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_DeleteSpiderSetting
	@id int
AS
-- ==========================================================================
-- Author : Tharaka Wanigasekera $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	DELETE FROM spider_setting
	WHERE spider_setting_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpider_DeleteSpiderSetting TO VpWebApp 
GO
--------------------------------------------------------------
GRANT SELECT ON [user] TO VpWebApp
GRANT SELECT ON [user_to_role] TO VpWebApp
--------------------------------------------------------------

IF NOT EXISTS (SELECT parameter_type_id FROM parameter_type WHERE parameter_type_id = 142)
BEGIN
	INSERT INTO parameter_type VALUES (142, 'SearchPanelOverridePageTitle', '1', GETDATE(), GETDATE())
END
GO
-----------------------------------------------------------------------------------

--####################################################################################################################
-----------------------------------------------------------------------------------

IF NOT EXISTS(select * from sys.columns where Name = N'blocked_status' and Object_ID = Object_ID(N'spider_ip_address'))
	BEGIN
	
		ALTER TABLE spider_ip_address ADD blocked_status int NOT NULL DEFAULT 0	

	END
GO


IF EXISTS(select * from sys.columns where Name = N'blocked' and Object_ID = Object_ID(N'spider_ip_address'))
	BEGIN	
			
		UPDATE spider_ip_address		
		SET blocked_status = case blocked WHEN 1 THEN 1 ELSE 2  END	
			
		
	END
GO

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_NAME = 'spider_ip_address' AND COLUMN_NAME = 'blocked')
	BEGIN
		DECLARE @ConstraintName nvarchar(200)
		SELECT @ConstraintName = CONSTRAINT_NAME FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_NAME = 'spider_ip_address' AND COLUMN_NAME = 'blocked'
		EXEC('ALTER TABLE __TableName__ DROP CONSTRAINT ' + @ConstraintName)
	END
GO

IF EXISTS(select * from sys.columns where Name = N'blocked' and Object_ID = Object_ID(N'spider_ip_address'))
	BEGIN
		
		ALTER TABLE spider_ip_address DROP COLUMN blocked			
		
	END
GO

-----------------------------------------------------------------------------------


IF NOT EXISTS(select * from sys.columns where Name = N'Country' and Object_ID = Object_ID(N'spider_ip_address'))
	BEGIN
		ALTER TABLE spider_ip_address ADD Country varchar(250) NULL
	END
GO

-----------------------------------------------------------------------------

IF NOT EXISTS(select * from sys.columns where Name = N'Owner' and Object_ID = Object_ID(N'spider_ip_address'))
	BEGIN
		ALTER TABLE spider_ip_address ADD [Owner] varchar(500) NULL
	END
GO

----------------------------------------------------------------------------



EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_AddIpAddress'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_AddIpAddress
	@id int output,
	@ipAddress varchar(50),
	@ipNumeric bigint,
	@requestIpGroupId int,
	@blocked int,
	@description varchar(1000),
	@country varchar(250),
	@owner varchar(500),
	@enabled bit,
	@created smalldatetime output
AS

BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO spider_ip_address(ip_address, ip_numeric,ip_group_id, blocked_status, description, enabled, modified, created, country, [owner])
	VALUES (@ipAddress, @ipNumeric, @requestIpGroupId, @blocked, @description, @enabled, @created, @created, @country, @owner)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_AddIpAddress TO VpWebApp 
GO

----------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_UpdateIpAddress'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_UpdateIpAddress
	@id int,
	@ipAddress varchar(50),
	@ipNumeric bigint,
	@requestIpGroupId int,
	@blocked int,
	@description varchar(1000),
	@enabled bit,
	@country varchar(250),
	@owner varchar(500),
	@modified smalldatetime output	
	 
AS

BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE dbo.spider_ip_address
	SET ip_address = @ipAddress,
		ip_numeric = @ipNumeric,
		ip_group_id = @requestIpGroupId,
		blocked_status = @blocked,
		description = @description,
		country = @country,
		[owner] = @owner,
		[enabled] = @enabled,		
		modified = @modified
			
	WHERE ip_address_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_UpdateIpAddress TO VpWebApp 
GO

-------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIpAddressDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIpAddressDetail
	@id int
	
AS

BEGIN
	
	SET NOCOUNT ON;

	SELECT ip_address_id as id, ip_address, ip_numeric, ip_group_id, blocked_status, description, enabled, created, modified, country, [owner]
	FROM spider_ip_address	
	WHERE ip_address_id = @id 

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIpAddressDetail TO VpWebApp 
GO

-----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByType'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByType
	@blocked bit

AS

BEGIN
	--
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM spider_ip_address
	WHERE blocked_status = @blocked

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByType TO VpWebApp 
GO


---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByGroup'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByGroup
	@groupId int

AS

BEGIN
	--
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM spider_ip_address
	WHERE ip_group_id = @groupId

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByGroup TO VpWebApp 
GO

---------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByGroupWithPagingSorting'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByGroupWithPagingSorting
	@groupId int,
	@pageSize int,
	@pageIndex int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (idRowDesc, ipRow, ipRowDesc, modifiedRow, modifiedRowDesc, 
								ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS idRowDesc, 
				ROW_NUMBER() OVER (ORDER BY ip_address ASC) AS ipRow,
			    ROW_NUMBER() OVER (ORDER BY ip_address DESC) AS ipRowDesc, 
				ROW_NUMBER() OVER (ORDER BY modified ASC) AS modifiedRow,
				ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedRowDesc, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE ip_group_id = @groupId
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM temp_request_ip_address
	WHERE (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'ip' AND @sortOrder = 'asc' AND ipRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'ip' AND @sortOrder = 'desc' AND ipRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex)	

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE ip_group_id = @groupId

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByGroupWithPagingSorting TO VpWebApp 
GO

------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByGroupWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByGroupWithPaging
	@groupId int,
	@pageSize int,
	@pageIndex int,	
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (row, ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE ip_group_id = @groupId
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE ip_group_id = @groupId

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByGroupWithPaging TO VpWebApp 
GO

---------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressList
	
AS

BEGIN
	
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, 
		[description], [enabled], created, modified, country, [owner]
	FROM spider_ip_address	

END

GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressList TO VpWebApp 
GO

-------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetAllIPAddresses'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetAllIPAddresses
	
AS

BEGIN
	--
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created,  [owner], country
	FROM spider_ip_address	

END

GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetAllIPAddresses TO VpWebApp 
GO
--------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetUngroupedIPAddressList'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetUngroupedIPAddressList
	@pageSize int,
	@pageIndex int,
	@sortBy varchar(14),
	@sortOrder varchar(5),
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (idRowDesc, ipRow, ipRowDesc, modifiedRow, modifiedRowDesc, 
								ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS idRowDesc, 
				ROW_NUMBER() OVER (ORDER BY ip_address ASC) AS ipRow,
			    ROW_NUMBER() OVER (ORDER BY ip_address DESC) AS ipRowDesc, 
				ROW_NUMBER() OVER (ORDER BY modified ASC) AS modifiedRow,
				ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedRowDesc, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE  ip_group_id is null 
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM temp_request_ip_address
	WHERE (@sortBy = 'id' AND @sortOrder = 'desc' AND idRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'ip' AND @sortOrder = 'asc' AND ipRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'ip' AND @sortOrder = 'desc' AND ipRowDesc BETWEEN @startIndex AND @endIndex) OR 
			  (@sortBy = 'modified' AND @sortOrder = 'asc' AND modifiedRow BETWEEN @startIndex AND @endIndex) OR
			  (@sortBy = 'modified' AND @sortOrder = 'desc' AND modifiedRowDesc BETWEEN @startIndex AND @endIndex)	

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE  ip_group_id is null

END
GO


GRANT EXECUTE ON dbo.adminSpiderManagement_GetUngroupedIPAddressList TO VpWebApp 
GO
-----------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetUngroupedIPListWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetUngroupedIPListWithPaging
	@pageSize int,
	@pageIndex int,
	@totalCount int output

AS

BEGIN
	--
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (row, ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner])
	AS
	(
		 SELECT ROW_NUMBER() OVER (ORDER BY ip_address_id DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE  ip_group_id is null 
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)			  

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE  ip_group_id is null

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetUngroupedIPListWithPaging TO VpWebApp 
GO


------------------------------------------------------------------------------


EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPAddressByIPDetail'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPAddressByIPDetail
	@ip varchar(50)
AS

BEGIN
	
	SET NOCOUNT ON;

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, 
		[description], [enabled], created, modified, country, [owner]
	FROM spider_ip_address	
	WHERE ip_address = @ip

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPAddressByIPDetail TO VpWebApp 
GO

--------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_GetSpiderSettingByIpGroupIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_GetSpiderSettingByIpGroupIdList
	@ipGroupId int
AS
-- ==========================================================================
-- Author : Tishan Malalasekara $
-- ==========================================================================
BEGIN

	SET NOCOUNT ON;

	SELECT [spider_setting_id] As id
		  ,[spider_ip_group_id]
		  ,[name]
		  ,[value]
		  ,[enabled]
		  ,[modified]
		  ,[created]
	  FROM [dbo].[spider_setting]
	WHERE spider_ip_group_id = @ipGroupId

END
GO

GRANT EXECUTE ON dbo.adminSpider_GetSpiderSettingByIpGroupIdList TO VpWebApp 
GO
--------------------------------------------------------------
GRANT SELECT ON [user] TO VpWebApp
GRANT SELECT ON [user_to_role] TO VpWebApp
--------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging
	@groupId int,
	@blockedStatus int,
	@startDate smalldatetime,
	@endDate smalldatetime,
	@pageSize int,
	@pageIndex int,
	@totalCount int output

AS
-- ==========================================================================
-- $Author: Tharaka Wanigasekera $
-- ==========================================================================

BEGIN
	SET NOCOUNT ON;

	DECLARE @startIndex int
	DECLARE @endIndex int
	SET @startIndex = @pageSize * (@pageIndex - 1) + 1;
	SET @endIndex = @pageSize * @pageIndex;

	WITH temp_request_ip_address (row, ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, 
								description, [enabled], modified, created, country, [owner])
	AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY modified DESC) AS row, 
				ip_address_id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
				[enabled], modified, created, country, [owner]
		FROM spider_ip_address
		WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
				(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
				(@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate)	
	)	

	SELECT ip_address_id AS id, ip_address, ip_numeric, ip_group_id, blocked_status, description, 
			[enabled], modified, created, country, [owner]
	FROM temp_request_ip_address
	WHERE (row BETWEEN @startIndex AND @endIndex)			  

	SELECT @totalCount = COUNT(*)
	FROM spider_ip_address
	WHERE	(@groupId = -1  OR ip_group_id = @groupId) AND 
			(@blockedStatus = -1 OR blocked_status = @blockedStatus) AND
			(@startDate IS NULL OR @endDate IS NULL) OR (created BETWEEN @startDate AND @endDate)	

END
GO

GRANT EXECUTE ON dbo.adminSpiderManagement_GetIPCollectionByStatusDateGroupWithPaging TO VpWebApp 
-----------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList
    @parentProductId INT ,
    @categoryId INT,
    @compressionGroupId INT ,
    @countryFlag1 BIGINT ,
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS -- ==========================================================================
-- Author : Dimuthu
-- ==========================================================================
    BEGIN
	
        SET NOCOUNT ON;
	
        SELECT  product.product_id AS id ,
                site_id ,
                product_name ,
                [rank] ,
                has_image ,
                catalog_number ,
                product.enabled ,
                product.modified ,
                product.created ,
                product_type ,
                status ,
                has_model ,
                has_related ,
                flag1 ,
                flag2 ,
                flag3 ,
                flag4 ,
                completeness ,
                search_rank ,
                search_content_modified ,
                hidden ,
                business_value ,
                show_in_matrix ,
                show_detail_page ,
                ignore_in_rapid
        FROM    product
                INNER JOIN product_compression_group_to_product cp ON product.product_id = cp.product_id
                INNER JOIN product_to_product pp ON product.product_id = pp.product_id
                INNER JOIN dbo.product_to_category ptc ON pp.product_id = ptc.product_id
        WHERE   product.enabled = 1
                AND cp.product_compression_group_id = @compressionGroupId
                AND pp.parent_product_id = @parentProductId
                AND ( ( product.flag1 & @countryFlag1 > 0 )
                      OR ( product.flag2 & @countryFlag2 > 0 )
                      OR ( product.flag3 & @countryFlag3 > 0 )
                      OR ( product.flag4 & @countryFlag4 > 0 )
                    )
                AND ptc.category_id =@categoryId
		

    END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductByParentProductIdCompressionGroupIdCategoryIdList TO VpWebApp 
GO
-----------------------------------------------------------------------------------------
EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList
    @productIds VARCHAR(4000),
    @categoryId INT,
    @countryFlag1 BIGINT ,	
    @countryFlag2 BIGINT ,
    @countryFlag3 BIGINT ,
    @countryFlag4 BIGINT
AS -- ==========================================================================  
-- Author : Dimuthu  
-- ==========================================================================  
    BEGIN  
  
        SET NOCOUNT ON;  
  
        SELECT  c.product_compression_group_id AS id ,
                site_id ,
                show_in_matrix ,
                show_product_count ,
                group_title ,
                expand_products ,
                enabled ,
                created ,
                modified ,
                is_default ,
				group_name ,
                product_id ,
                product_count
	FROM
	(
		SELECT CAST(p.[value] AS int) AS product_id, cp.product_compression_group_id, COUNT(*) product_count 
		FROM product_to_product pp
			INNER JOIN global_Split(@productIds, ',') AS p
				ON pp.parent_product_id = p.[value]
			INNER JOIN product
				ON pp.product_id = product.product_id
			INNER JOIN product_compression_group_to_product cp
				ON pp.product_id = cp.product_id
			INNER JOIN dbo.product_to_category ptc ON pp.product_id = ptc.product_id
		WHERE (product.flag1 & @countryFlag1 > 0) OR (product.flag2 & @countryFlag2 > 0) OR 
			(product.flag3 & @countryFlag3 > 0) OR (product.flag4 & @countryFlag4 > 0)
			 AND ptc.category_id =@categoryId
		GROUP BY p.[value], cp.product_compression_group_id
	) g
	INNER JOIN product_compression_group c
		ON g.product_compression_group_id = c.product_compression_group_id	

END
GO

GRANT EXECUTE ON dbo.publicProduct_GetProductCompressionGroupByProductIdsCategoryIdList TO VpWebApp 
GO
--------------------------------------------------------------
GRANT SELECT ON [user] TO VpWebApp
GRANT SELECT ON [user_to_role] TO VpWebApp
--------------------------------------------------------------
