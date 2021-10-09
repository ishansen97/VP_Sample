<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentList.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Controls.ContentList" %>
<div id="divContentList" runat="server">
	<asp:TextBox ID="txtContentValue" runat="server" CssClass="contentValue"></asp:TextBox>
	<asp:TextBox ID="txtContentId" runat="server" CssClass="contentId"></asp:TextBox>
	<asp:HiddenField ID="hdnContentId" runat="server" />
</div>
