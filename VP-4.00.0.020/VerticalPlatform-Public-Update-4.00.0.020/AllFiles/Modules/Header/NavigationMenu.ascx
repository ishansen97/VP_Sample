<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NavigationMenu.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Header.NavigationMenu" %>
<nav class="navigaterMenu">
	<asp:Menu ID="mnuNavigation" runat="server" CssSelectorClass="navMenu" Orientation="Horizontal"
		DataSourceID="smdsMap" OnMenuItemDataBound="mnuNavigation_MenuItemDataBound">
	</asp:Menu>
	<asp:SiteMapDataSource ID="smdsMap" runat="server" ShowStartingNode="False" />
</nav>
