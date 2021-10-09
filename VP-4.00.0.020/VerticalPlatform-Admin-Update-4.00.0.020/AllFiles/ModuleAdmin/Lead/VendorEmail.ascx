<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorEmail.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Lead.VendorEmail" %>
<table>
	<tr>
		<td colspan="2">
			<asp:HiddenField ID="hdnEmailId" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Email
		</td>
		<td>
			<asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
			<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail" ErrorMessage="Invalid email address." 
				ValidateEmptyText="true" ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="true" />
		</td>
	</tr>
</table>
