<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ArticleLocations.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleLocations" Title="Untitled Page" %>
<%@ Register src="../Location/ContentLocations.ascx" tagname="ContentLocations" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<uc1:ContentLocations ID="contentLocations" runat="server" />
	<br />
	<asp:Button ID="btnSaveLocations" runat="server" Text="Save Locations" 
		onclick="btnSaveLocations_Click" CssClass="btn" />
	<asp:Button ID="btnCancel" runat="server" Text="Cancel" 
		onclick="btnCancel_Click" CssClass="btn" />
</asp:Content>
