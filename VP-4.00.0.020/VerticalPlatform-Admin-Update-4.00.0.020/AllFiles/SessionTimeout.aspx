<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SessionTimeout.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.SessionTimeout" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Session has been expired</title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="logiin-container" style="width:500px;">
        <div class="site-logo"><img id="Img1" src="~/App_Themes/Default/Images/login-logo.png" runat="server" ></div>
        <div class="brand">Vertical Platform <span>Admin</span></div>
        <div id="loginPanel">
           <h2 style="margin-top:0px; font-size:18px;line-height:26px;">
								Session has been expired. Please login to the system.</h2>
							<asp:Button ID="btnOk" runat="server" Text="Ok" OnClick="btnOk_Click" CssClass="btn" />
        </div>
        <div class="footer-txt">
            &copy; CompareNetworks
        </div>
    </div>
    </form>
</body>
</html>