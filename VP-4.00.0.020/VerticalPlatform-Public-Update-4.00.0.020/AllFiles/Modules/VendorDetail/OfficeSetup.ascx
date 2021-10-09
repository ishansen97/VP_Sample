<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OfficeSetup.ascx.cs" 
		Inherits="VerticalPlatformWeb.Modules.VendorDetail.OfficeSetup" %>

<div class="OfficeSetupModule" runat="server" id="divOfficeSetupModule">
	<asp:PlaceHolder ID="phVendors" runat="server"></asp:PlaceHolder>
	<div class="inputElements">
		<asp:HyperLink ID ="lnkSave" CssClass="officeSetupLeadAction" runat="server" Text="Sign Me UP!"></asp:HyperLink>
	</div>
</div>
