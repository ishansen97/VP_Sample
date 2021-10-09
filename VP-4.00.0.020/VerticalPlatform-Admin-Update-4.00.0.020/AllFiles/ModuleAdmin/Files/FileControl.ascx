<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FileControl.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Files.FileControl" %>
<table>
	<tr>
		<td>
			File Name
		</td>
		<td>
			<asp:TextBox ID="txtFileName" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFileName" runat="server" ErrorMessage="Please enter file name." ControlToValidate="txtFileName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Mime Type
		</td>
		<td>
			<asp:TextBox ID="txtMimeType" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvMimeType" runat="server" ErrorMessage="Please enter mime type." ControlToValidate="txtMimeType">*</asp:RequiredFieldValidator>
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
	<tr>
		<td colspan="2">
			<asp:Label ID="lblMessage" runat="server"></asp:Label>
		</td>
	</tr>
</table>


