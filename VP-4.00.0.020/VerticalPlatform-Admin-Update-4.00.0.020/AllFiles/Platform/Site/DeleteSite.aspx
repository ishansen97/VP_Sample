<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="DeleteSite.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.DeleteSite"
	Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="inline-form-container"><asp:DropDownList ID="ddlSite" runat="server">
	</asp:DropDownList>
	<asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" CssClass="btn"  /></div>
</asp:Content>
