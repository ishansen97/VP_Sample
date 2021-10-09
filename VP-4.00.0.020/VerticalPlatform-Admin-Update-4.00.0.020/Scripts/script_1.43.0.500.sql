

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'sent_by' AND Object_ID = Object_ID(N'lead'))
BEGIN
    ALTER TABLE	dbo.lead
	ADD sent_by INT NOT NULL DEFAULT 0
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'published' AND Object_ID = Object_ID(N'lead'))
BEGIN
    ALTER TABLE	dbo.lead
	ADD published BIT NOT NULL DEFAULT 0
END
GO


IF NOT EXISTS(SELECT parameter_type FROM dbo.parameter_type WHERE parameter_type = 'EnableRealTimeLeads')
BEGIN
	INSERT INTO dbo.parameter_type (parameter_type_id, parameter_type, enabled, modified, created)
	VALUES (201, 'EnableRealTimeLeads', 1, GETDATE(), GETDATE())
END
GO

IF NOT EXISTS(SELECT parameter_type FROM dbo.parameter_type WHERE parameter_type = 'VendorLeadUrl')
BEGIN
	INSERT INTO dbo.parameter_type (parameter_type_id, parameter_type, enabled, modified, created)
	VALUES (202, 'VendorLeadUrl', 1, GETDATE(), GETDATE())
END

GO

IF NOT EXISTS(SELECT parameter_type FROM dbo.parameter_type WHERE parameter_type = 'VendorLeadTrackingScript')
BEGIN
	INSERT INTO dbo.parameter_type (parameter_type_id, parameter_type, enabled, modified, created)
	VALUES (203, 'VendorLeadTrackingScript', 1, GETDATE(), GETDATE())
END


GO


EXEC dbo.global_DropStoredProcedure 'dbo.adminLeadDeployment_GetVPLeadDataByVendorIdLeadTypeIdList'

GO
/****** Object:  StoredProcedure [dbo].[adminLeadDeployment_GetVPLeadDataByVendorIdLeadTypeIdList]    Script Date: 10/11/2018 11:16:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[adminLeadDeployment_GetVPLeadDataByVendorIdLeadTypeIdList]
	@vendorId int,
	@leadTypeId int,
	@customQuery nvarchar(max),
	@countryList nvarchar(max),
	@isMaster bit,
	@leadStates nvarchar(100),
	@states nvarchar(max) ,
	@siteId INT,
	@leadId INT = NULL   --M001
AS
-- ==========================================================================
-- $URL:  $
-- $Revision:  $
-- $Date:  $ 
-- $Author: Eranga $
-- Modifications
-- M001		20181011		Chinthaka		"Added optional lead parametre"	
-- ==========================================================================
BEGIN

DECLARE @statesFilter nvarchar(max)
SET @statesFilter = ''

DECLARE @typeFilter nvarchar(80)
DECLARE @countryFilter nvarchar(max)
DECLARE @leadFilter VARCHAR(MAX) = ''
DECLARE @isRecompile VARCHAR(MAX) = ''
SET @countryFilter = ''
DECLARE @stringEmpty char(1)
SET @stringEmpty = ''
SET @typeFilter = ''


IF @countryList != ''
BEGIN
	IF @states != ''
	BEGIN
		SET @countryFilter = ' AND ( pup.country_id IN (' + @countryList + ') '
	END
	ELSE
	BEGIN
		SET @countryFilter = ' AND pup.country_id IN (' + @countryList + ') '
	END
	
END

IF @states != ''
BEGIN
	IF @countryList != ''
	BEGIN
		SET @statesFilter = ' OR (pup.country_id=219 AND pup.state IN (select [value] FROM  global_Split(''' + @states + ''','',''))))'
	END
	ELSE
	BEGIN
		SET @statesFilter = ' AND (pup.country_id=219 AND pup.state IN (select [value] FROM  global_Split(''' + @states + ''','',''))) '
	END
END


IF @customQuery != ''
BEGIN 
	SET @customQuery = 'l.lead_id AS LeadId, l.lead_state_type_id AS LeadStateTypeId, pup.country_id AS CountryId, pup.State AS [State],' + @customQuery
END
ELSE 
BEGIN
	SET @customQuery = 'l.lead_id AS LeadId, l.lead_state_type_id AS LeadStateTypeId, pup.country_id AS CountryId, pup.state AS [State], c.country_name AS Country'
END

If @isMaster = 0
BEGIN 
	SET @typeFilter = ' AND l.lead_state_type_id in (' + @leadStates + ') '
END
ELSE
BEGIN 
	SET @typeFilter = ' AND l.lead_state_type_id IN (' + @leadStates + ') AND l.is_included_to_master = 0 '
END

--M001
If @leadId IS NOT NULL
BEGIN 
	SET @leadFilter = ' AND l.lead_id = '+CAST(@leadId AS VARCHAR)+' '
	SET @isRecompile = ' OPTION	(RECOMPILE)'
END




DECLARE @queryStatement nvarchar(max)
SET @queryStatement = 'SELECT ' + @customQuery + ' 	FROM  lead AS l 
		INNER JOIN public_user AS pu ON l.public_user_id = pu.public_user_id
		INNER JOIN public_user_profile AS pup ON pup.public_user_id = pu.public_user_id 
		INNER JOIN country AS c ON c.country_id = pup.country_id
		INNER JOIN action AS lt ON lt.action_id = l.action_id AND lt.site_id = l.site_id
		LEFT OUTER JOIN product AS p ON l.content_id = p.product_id AND l.site_id = p.site_id AND l.content_type_id = 2 
		LEFT OUTER JOIN category AS cg ON l.content_id = cg.category_id AND l.site_id = cg.site_id AND l.content_type_id = 1
		LEFT OUTER JOIN model as m ON l.content_id = m.model_id AND l.content_type_id = 21
		LEFT OUTER JOIN product AS pm ON m.product_id = pm.product_id AND l.site_id = pm.site_id AND l.content_type_id = 21
		LEFT OUTER JOIN dbo.specification s ON s.content_id = p.product_id AND s.content_type_id = 2 AND  l.content_type_id = 2 AND s.spec_type_id = 15455
		
	WHERE l.site_id=@siteId AND l.vendor_id=@vendorId AND l.action_id =@leadTypeId  ' + @typeFilter + @countryFilter +@statesFilter+@leadFilter+@isRecompile
		 

EXECUTE sp_executesql @queryStatement, N'@siteId int, @vendorId int, @leadTypeId int', 
		@siteId, @vendorId, @leadTypeId


END


GO
GRANT EXECUTE ON dbo.adminLeadDeployment_GetVPLeadDataByVendorIdLeadTypeIdList TO VpWebApp
GO



EXEC dbo.global_DropStoredProcedure 'dbo.adminLeadDeployment_UpdateVPLeadStatusRealTime'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Chinthak Fernando
-- Create date: 2018-10-09
-- Description:	Updates Lead Deployment Status after Realtime Deployment
-- =============================================
CREATE PROCEDURE [dbo].[adminLeadDeployment_UpdateVPLeadStatusRealTime]
	@leadId int,
	@statusId int,
	@vpStatusId int,
	@message varchar(max),
	@isIncludedToMaster bit,
	@siteId INT,
	@sentBy INT,
	@isPublished BIT
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE lead
	SET lead_state_type_id = @statusId,
		lead_status_id = @vpStatusId,
		lead_comment = @message,
		is_included_to_master = @isIncludedToMaster,
		state_modification_date = GETDATE(),
		send_date = GETDATE(),
		sent_by = @sentBy,
		published = @isPublished
	WHERE lead_id = @leadId
		AND site_id = @siteId
	
END

GO


GO
GRANT EXECUTE ON dbo.adminLeadDeployment_UpdateVPLeadStatusRealTime TO VpWebApp
GO


EXEC dbo.global_DropStoredProcedure 'dbo.publicProduct_GetVendorParametersForProductList'

GO
/****** Object:  StoredProcedure [dbo].[publicProduct_GetVendorParametersForProductList]    Script Date: 10/11/2018 11:16:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[publicProduct_GetVendorParametersForProductList]
	@productListCSV VARCHAR(MAX),
	@parameterTypeId INT
AS
-- ==========================================================================
-- $URL:  $
-- $Revision:  $
-- $Date:  $ 
-- $Author: Chinthaka $
-- Modifications
-- ==========================================================================
BEGIN

	SELECT	vnd_prm.vendor_parameter_id AS id
			,vnd_prm.vendor_id
			,vnd_prm.parameter_type_id
			,vnd_prm.vendor_parameter_value
			,vnd_prm.enabled
			,vnd_prm.modified
			,vnd_prm.created 
	FROM	dbo.product_to_vendor prd_vnd
			INNER JOIN dbo.vendor vnd ON vnd.vendor_id = prd_vnd.vendor_id
			INNER JOIN dbo.global_Split(@productListCSV,',') prd_ids ON prd_ids.value = prd_vnd.product_id
			INNER JOIN dbo.vendor_parameter vnd_prm ON vnd_prm.vendor_id = vnd.vendor_id
	WHERE	prd_vnd.is_manufacturer = 1
			AND	vnd_prm.parameter_type_id = @parameterTypeId

END


GO
GRANT EXECUTE ON dbo.publicProduct_GetVendorParametersForProductList TO VpWebApp
GO

