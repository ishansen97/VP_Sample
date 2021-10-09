<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddVendor.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddVendor" %>

<script type="text/javascript">
		$(document).ready(function() {
            var hdnVendorId = { contentId: "txtVendorName" };
		vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15",
		showName: "false", bindings: hdnVendorId };
		$("input[type=text][id*=txtVendorName]").contentPicker(vendorNameOptions);
		});
	</script>

<div>
	<table>
		<tr>
			<td>
				<asp:Literal ID="lblVendorName" runat="server" Text="Vendor ID"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtVendorName" runat="server" Width="179px" />
				<asp:RequiredFieldValidator ID="rfvVendorName" runat="server" ErrorMessage="Select a vendor to be associated." ControlToValidate="txtVendorName">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlManufacSeller" runat="server" Text="Manufacturer/Seller"></asp:Literal>
			</td>
			<td>
				<asp:CheckBoxList ID="chklManufacSeller" runat="server">
					<asp:ListItem>Manufacturer</asp:ListItem>
					<asp:ListItem Selected="True">Seller</asp:ListItem>
				</asp:CheckBoxList>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlLeadEnabled" runat="server" Text="Enable Leads"></asp:Literal>
			</td>
			<td>
				<asp:CheckBox ID="chkLeadEnabled" runat="server" Text=" " />
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlShowGetQuote" runat="server" Text="Show Secondary Lead Form Button"></asp:Literal>
			</td>
			<td>
				<asp:CheckBox ID="chkShowGetQuote" runat="server" Text=" " />
			</td>
		</tr>
		<tr>
			<td>
				<asp:Label ID="lblEnableVendor" runat="server" Text="Vendor Enabled"></asp:Label>
			</td>
			<td>
				<asp:CheckBox ID="chkVendorEnabled" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
	</table>
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
</div>
