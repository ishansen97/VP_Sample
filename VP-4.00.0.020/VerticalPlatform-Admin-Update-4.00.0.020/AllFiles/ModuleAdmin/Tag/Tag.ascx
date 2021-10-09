<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Tag.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Tag.Tag" %>
<table>
	<tr>
		<td>
			Tag
		</td>
		<td>
			<asp:TextBox ID="txtTag" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTag" runat="server" ErrorMessage="Please enter tag" ControlToValidate="txtTag">*</asp:RequiredFieldValidator>
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
