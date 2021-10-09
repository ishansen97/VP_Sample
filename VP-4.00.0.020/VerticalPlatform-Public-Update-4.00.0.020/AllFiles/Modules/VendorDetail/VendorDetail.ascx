<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorDetail.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.VendorDetail.VendorDetail" %>
<div class="VendorDeatailModule module" runat = "server" id="VendorDeatailModuleHolder">
	<div class="contactInfo module">
		<asp:HyperLink ID="lnkVendor" runat="server">
			<asp:Image ID="imgVendor" runat="server" class="vendorImage" />
		</asp:HyperLink>
		<div class="module">
			<div class ="column1">
				<asp:Literal ID="ltlContactInfoFirstColumn" runat="server"></asp:Literal>
			</div>
			
			<div class ="column2">
				<asp:Literal ID="ltlContactInfoSecondColumn" runat="server"></asp:Literal>
			</div>
		</div>
	</div>
	<asp:Literal runat="server" ID="vendorDescriptionLiteral"></asp:Literal>
	<asp:Literal ID="ltlCategoryContent" runat="server"></asp:Literal>
</div>
