<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordProtectedSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.PasswordProtectedSettings" %>
<table>
	<tr>
		<td>
			<asp:Label ID="lblTitle" runat="server" Text="Password validation Title"></asp:Label>
		</td>
		<td>
			<asp:TextBox ID="txtTitle" runat="server" ></asp:TextBox>
			<asp:HiddenField ID="hdnTitle" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			<asp:Label ID="lblHtml" runat="server" Text="Password validation message"></asp:Label>
		</td>
		<td>
			<asp:TextBox ID="txtMessage" runat="server" ></asp:TextBox>
			<asp:HiddenField ID="hdnMessage" runat="server" />
		</td>
	</tr>
</table>