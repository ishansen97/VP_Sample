<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Login.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Header.Login" %>
<div class="login" id="divLogin">
	<asp:Literal ID="ltlWelcome" runat="server"></asp:Literal>
	<asp:HyperLink ID="lnkMyAccount" runat="server" CssClass="myAccount" ToolTip="My Account">My Account</asp:HyperLink>
	<asp:HyperLink ID="lnkLoginPopup" runat="server" CssClass="loginPopup" ToolTip="Sign In">Sign In</asp:HyperLink>
	<asp:HyperLink ID="lnkRegisterPopup" runat="server" CssClass="registerPopup" ToolTip="Register">Register</asp:HyperLink>
</div>