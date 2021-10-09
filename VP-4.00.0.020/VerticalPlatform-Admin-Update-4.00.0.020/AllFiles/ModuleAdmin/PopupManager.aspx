<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PopupManager.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.PopupManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" style="background: #ffffff;">
<head runat="server">
	<title>Untitled Page</title>
	<link href="../App_Themes/Default/modelInlineStyle.css" rel="stylesheet" type="text/css" />

	<script src="../Js/JQuery/jquery-1.4.2.min.js" type="text/javascript"></script>

	<script type="text/javascript">
        $(document).ready(function() {
            $('input[type=submit]').addClass("common_text_button");
        });
	</script>

</head>
<body style="background: #ffffff; padding: 10px;">
	<form id="form1" runat="server">
	<asp:ScriptManager ID="ScriptManager1" runat="server">
	</asp:ScriptManager>
	<div>
		<asp:PlaceHolder ID="phPopupContainer" runat="server"></asp:PlaceHolder>
		<asp:Label ID="lblMessage" runat="server"></asp:Label>
	</div>
	</form>
</body>
</html>
