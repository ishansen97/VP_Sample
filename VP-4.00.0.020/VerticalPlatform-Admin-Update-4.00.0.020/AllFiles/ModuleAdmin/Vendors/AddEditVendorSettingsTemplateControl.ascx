<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditVendorSettingsTemplateControl.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.AddEditVendorSettingsTemplateControl" %>
<table>
	<tr>
		<td>
			<span class="label_span">Vendor Settings Template Name</span>
		</td>
		<td>
			<asp:TextBox ID="txtSettingsTemplateName" runat="server" Width="140" MaxLength="250"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvSettingsTemplateName" runat="server"
				ErrorMessage="Please enter vendor settings template name." ControlToValidate="txtSettingsTemplateName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Sort Order</span>
		</td>
		<td>
			<asp:TextBox ID="txtSortOrder" runat="server" Width="140" MaxLength="4"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTxtSortOrder" runat="server"
					ErrorMessage="Please enter sort order." ControlToValidate="txtSortOrder">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revSortOrder" runat="server" ControlToValidate="txtSortOrder"
					ErrorMessage="Please enter a positive numeric value as the sort order." 
					ValidationExpression="^[0-9][0-9]*$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Enabled</span>
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" Checked="true" runat="server"></asp:CheckBox>
		</td>
	</tr>
</table>
