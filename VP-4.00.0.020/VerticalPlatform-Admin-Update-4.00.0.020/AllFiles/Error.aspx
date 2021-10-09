<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="VerticalPlatformAdminWeb.Error" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Error</title>
	<link id="Link1" rel="Stylesheet" href="App_Themes/Default/Admin.css" runat="server" />
</head>
<body>
	<form id="frmError" runat="server">
	<div class="Common_outer" style="width: 50%;">
		<div class="Common_inner">
			<!-- header -->
			<div class="site_header">
				<div class="log_in_div">
					&nbsp;
				</div>
				<div class="header_content">
					<div class="logo1">
						<div style="float: left;">
							<a id="A2" href="~/Default.aspx" runat="server" class="Vp-link"><strong>Vertical Platform</strong>
								<span style="font-size: 11px">Admin</span> </a>
						</div>
					</div>
					<div class="logo2">
						<img id="Img2" src="~/App_Themes/Default/Images/CN-logo.png" runat="server" /></div>
				</div>
			</div>
			<div class="body_bg_div">
				<div class="Common_content_outer">
					<div class="Common_content" style="min-height: 300px;">
						<div class="Error_page_div">
							<h2>
								Server error please try again later.</h2>
							<p>
								<asp:Label ID="lblMessage" runat="server"></asp:Label>
							</p>
							<p>
								<asp:Label ID="lblException" runat="server"></asp:Label>
							</p>
							<p>
								<asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="common_text_button" />
							</p>
							<div class="clear">
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="site_footer">
				<div id="footer" class="Footer" runat="server">
					&copy; Compare Networks.
				</div>
			</div>
		</div>
	</div>
	</form>
</body>
</html>
