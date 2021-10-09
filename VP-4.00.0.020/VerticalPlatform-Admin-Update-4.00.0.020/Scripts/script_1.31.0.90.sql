EXEC dbo.global_DropStoredProcedure 'dbo.adminSpider_DeleteSpiderSettingBySpiderIpGroupId'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSpider_DeleteSpiderSettingBySpiderIpGroupId
	 @ipGroupId int
AS

BEGIN
	
	SET NOCOUNT ON;

	DELETE FROM spider_setting where spider_ip_group_id = @ipGroupId


END
GO

GRANT EXECUTE ON dbo.adminSpider_DeleteSpiderSettingBySpiderIpGroupId TO VpWebApp 
GO