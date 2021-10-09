<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PredefinedPage.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.PredefinedPage" %>
<table>
	<tr>
		<td>
			Name
		</td>
		<td>
			<asp:TextBox ID="txtName" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Please enter name" ControlToValidate="txtName">*</asp:RequiredFieldValidator>
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
