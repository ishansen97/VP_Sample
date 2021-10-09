<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditPublicUserEmail.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.EditPublicUserEmail" %>

<table >
	<tr>
		<td>Email</td>
		<td>
			<asp:TextBox ID="txtEmail" runat="server" Width="150" MaxLength="250"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvEmail" runat="server"
				ErrorMessage="Please enter email address." ControlToValidate="txtEmail">*</asp:RequiredFieldValidator>
		</td>
	</tr>
</table>
<br />

