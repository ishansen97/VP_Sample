<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="Default.aspx.cs" Inherits="VerticalPlatformAdminWeb.Default" Title="Untitled Page" %>

<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			Welcome to Vertical Platform Admin
		</h3>
	</div>
	<asp:TreeView ID="tvSiteNavigation" EnableViewState="false" runat="server" ExpandImageUrl="~/App_Themes/Default/Images/treeview-plus.png"
		CollapseImageUrl="~/App_Themes/Default/Images/treeview-minus.png" NodeStyle-ImageUrl="~/App_Themes/Default/Images/web_page.gif"
		ShowLines="true" ontreenodedatabound="tvSiteNavigation_TreeNodeDataBound" >
		<RootNodeStyle Font-Bold="true" />
		<ParentNodeStyle Font-Bold="False" />
		<HoverNodeStyle Font-Underline="True" />
		<SelectedNodeStyle Font-Bold="true" />
		<NodeStyle Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" HorizontalPadding="0px"
			NodeSpacing="0px" VerticalPadding="0px" CssClass="home_page_tree_view" />
	</asp:TreeView>
	<asp:SiteMapDataSource ID="sitemap" runat="server" ShowStartingNode="false" />
</asp:Content>
