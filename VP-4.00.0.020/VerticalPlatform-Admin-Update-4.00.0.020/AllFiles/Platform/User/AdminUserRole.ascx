<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdminUserRole.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.User.AdminUserRole" %>
<table>
	<tr>
		<td colspan="2">
			<asp:HiddenField ID="hdnRoleId" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Role
		</td>
		<td>
			<asp:TextBox ID="txtRoleName" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvRole" runat="server" ErrorMessage="Please enter role."
				ControlToValidate="txtRoleName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" runat="server" />
		</td>
	</tr>
</table>
