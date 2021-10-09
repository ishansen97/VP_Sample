<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductDetailSpecificationSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductDetailSpecificationSettings" %>
<table>
	<tr>
		<td>
			Enable vendor Link For None-Ranked Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkEnableNoneRankedVendorLink" runat="server" />
			<asp:HiddenField ID="hdnEnableNoneRankedVendorLink" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable vendor Link For Minimized Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkEnableMinimizedVendorLink" runat="server" />
			<asp:HiddenField ID="hdnEnableMinimizedVendorLink" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable vendor Link For Standard Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkEnableStandardVendorLink" runat="server" />
			<asp:HiddenField ID="hdnEnableStandardVendorLink" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable vendor Link For Featured Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkEnableFeaturedVendorLink" runat="server" />
			<asp:HiddenField ID="hdnEnableFeaturedVendorLink" runat="server" />
		</td>
	</tr>
    <tr>
        <td>
            Enable Lead Form Popup
        </td>
        <td>
            <asp:CheckBox ID="chkLeadFormPopup" runat="server" />
            <asp:HiddenField ID="hdnLeadFormPopup" runat="server" />
        </td>
    </tr>
	<tr>
		<td>
			Price Label Text:
		</td>
		<td>
			<asp:TextBox ID="txtPriceLabelText" runat="server" Style="margin-left: 0px"
				Width="200px"></asp:TextBox>
			<asp:HiddenField ID="hdnPriceLabelText" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Price Label Help Text:
		</td>
		<td>
			<asp:TextBox ID="txtPriceLabelHelpText" runat="server" Style="margin-left: 0px"
				Width="200px" TextMode="MultiLine"></asp:TextBox>
			<asp:HiddenField ID="hdnPriceLabelHelpText" runat="server" />
		</td>
	</tr>
    <tr>
        <td>
            Redirect Company Name To Vendor Detail Page
        </td>
        <td>
            <asp:CheckBox ID="chkRedirectToVendorDetail" runat="server" />
            <asp:HiddenField ID="hdnRedirectToVendorDetail" runat="server" />
        </td>
    </tr>
</table>
