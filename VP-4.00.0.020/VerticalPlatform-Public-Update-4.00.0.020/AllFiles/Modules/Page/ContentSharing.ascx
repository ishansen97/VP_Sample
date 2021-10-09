<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentSharing.ascx.cs" 
    Inherits="VerticalPlatformWeb.Modules.Page.ContentSharing" %>
<div id="divContentSharing" class="ContentSharing module" runat="server">
	<asp:Literal ID="ltlContentSharing" runat="server"></asp:Literal>
	<asp:HiddenField ID="hdnContentId" runat="server" />
	<asp:HiddenField ID="hdnPrivacyPolicy" runat="server" />
	<asp:HiddenField ID="hdnUserInfo" runat="server" />
	<asp:HiddenField ID="hdnContentUrl" runat="server" />
	<asp:HiddenField ID="hdnContentType" runat="server" />
</div>