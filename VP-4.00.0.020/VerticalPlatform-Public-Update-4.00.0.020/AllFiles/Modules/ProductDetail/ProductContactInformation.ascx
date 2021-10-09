<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductContactInformation.ascx.cs" Inherits="VerticalPlatformWeb.Modules.ProductDetail.ProductContactInformation" %>
<div id="divContactInformation" class="contactInfo module">
	
	<asp:Literal ID="ltlVendorImage" runat="server"></asp:Literal>
	
	<div class="moduleWrap">
		<div class ="column1">
			<asp:Literal ID="ltlContactInfoFirstColumn" runat="server"></asp:Literal>
		</div>
		
		<div class ="column2">
			<asp:Literal ID="ltlContactInfoSecondColumn" runat="server"></asp:Literal>
		</div>
	</div>
	
</div>