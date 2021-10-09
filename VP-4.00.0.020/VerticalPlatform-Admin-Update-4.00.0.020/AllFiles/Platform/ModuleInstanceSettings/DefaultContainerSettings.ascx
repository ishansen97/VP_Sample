<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DefaultContainerSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.DefaultContainerSettings" %>
<table>
	<tr>
		<td>
			Display Title
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayTitle" runat="server" />
			<asp:HiddenField ID="hdnDisplayTitle" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Containers First Available Module Title as the Container Title
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayFirstModuleTitle" runat="server" />
			<asp:HiddenField ID="hdnDisplayFirstModuleTitle" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Schema Type
		</td>
		<td>
			<asp:DropDownList ID="schemaType" runat="server"></asp:DropDownList>
			<asp:HiddenField ID="schemaTypeHidden" runat="server" />
		</td>
	</tr>
</table>