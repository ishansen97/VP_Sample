<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorContactAddress.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorContactAddress" %>
<div style="width:420px;">
<table>
	<tr>
		<td>
			Address Line 1
		</td>
		<td>
			<asp:TextBox ID="txtAddressLine1" runat="server" Width="250px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvAddressLine1" runat="server" ErrorMessage="Please enter address line1. " ControlToValidate="txtAddressLine1">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Address Line 2
		</td>
		<td>
			<asp:TextBox ID="txtAddressLine2" runat="server" Width="250px"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			City
		</td>
		<td>
			<asp:TextBox ID="txtCity" runat="server" Width="250px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvCity" runat="server" ErrorMessage="Please enter city. " ControlToValidate="txtCity">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			State/Province
		</td>
		<td>
			<asp:TextBox ID="txtState" runat="server" Width="250px"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Zip/Postal Code
		</td>
		<td>
			<asp:TextBox ID="txtZipPostalCode" runat="server" Width="250px"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Country
		</td>
		<td>
			<asp:DropDownList ID="ddlCountry" runat="server" Width="260px" AppendDataBoundItems="true">
				<asp:ListItem Text="Select" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvCountry" runat="server" ErrorMessage="Please select country." ControlToValidate="ddlCountry">*</asp:RequiredFieldValidator>
		</td>
	</tr>
</table>
</div>