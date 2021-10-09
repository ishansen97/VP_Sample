<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CampaignDeployProgress.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignDeployProgress" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<title>Campaign Deployment Progress</title>
	<link href="../../App_Themes/Default/Admin.css" rel="stylesheet" type="text/css" />
	<script src="../../Js/Utility.js" type="text/javascript"></script>
	<style type="text/css">
		html,body{background:#ffffff !important;}
	</style>
	
	<script type="text/javascript">
		(function() {
			RegisterNamespace("VP.BulkEmail");
			VP.BulkEmail.RefreshParent = function() {
				window.opener.location.href = window.opener.location.href;
				if (window.opener.progressWindow) {
					window.opener.progressWindow.close()
				}
				window.close();
			}
		})();
	</script>

</head>
<body class="campaign_deploy_progress" onunload="VP.BulkEmail.RefreshParent()">
<input class="common_text_button" onclick="VP.BulkEmail.RefreshParent()" value="Close" type="button"/>
</body>
</html>
