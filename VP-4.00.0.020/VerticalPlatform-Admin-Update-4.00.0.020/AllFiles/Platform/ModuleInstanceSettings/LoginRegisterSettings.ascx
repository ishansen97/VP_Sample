<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LoginRegisterSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.LoginRegisterSettings" %>
<table>
	<tr>
		<td class="LoginRegisterSettingLable">
			Show Register Link
		</td>
		<td>
			<asp:HiddenField ID="hdnShowRegisterLink" runat="server" />
			<asp:CheckBox ID="chkShowRegisterLink" runat="server" />
		</td>
	</tr>
	<tr>
		<td class="LoginRegisterSettingLable">
			Show Password Reset
		</td>
		<td>
			<asp:HiddenField ID="hdnPasswordReset" runat="server" />
			<asp:CheckBox ID="chkPasswordReset" runat="server" />
		</td>
	</tr>
</table>
