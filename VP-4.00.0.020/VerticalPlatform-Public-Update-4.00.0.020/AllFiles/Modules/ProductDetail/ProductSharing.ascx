<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductSharing.ascx.cs" Inherits="VerticalPlatformWeb.Modules.ProductDetail.ProductSharing" %>
<div id="divProductSharing" class="productSharing module" runat="server">
	<asp:Literal ID="ltlProductSharing" runat="server"></asp:Literal>
	<asp:HiddenField ID="hdnProductId" runat="server" />
	<asp:HiddenField ID="hdnPrivacyPolicy" runat="server" />
	<asp:HiddenField ID="hdnUserInfo" runat="server" />
	<asp:HiddenField ID="hdnProductUrl" runat="server" />
</div>
