<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReviewForm.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Reviews.ReviewForm" %>

<div class ="ReviewFormModule">
	<asp:PlaceHolder ID="reviewForm" runat="server"></asp:PlaceHolder>
	<asp:HiddenField ID="contentIdField" runat="server" Value="0" />
	<asp:HiddenField ID="currentPageField" runat="server" Value="0" />
	<asp:HiddenField ID="productIdField" runat="server"/>
	<asp:HiddenField ID="vendorIdField" runat="server"/>
</div>
