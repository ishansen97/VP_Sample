<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeaturedVendors.ascx.cs" Inherits="VerticalPlatformWeb.Modules.VendorDetail.FeaturedVendors" %>
<div id = "FeaturedVendorsModuleHolder" class = "FeaturedVendorsModule module" runat = "server" > 
	<ul class="articleList" style="padding-left: 0; list-style-type:none; margin: 0;">
		<asp:Literal ID="featuredVendors" runat="server"></asp:Literal>
	</ul>
</div>