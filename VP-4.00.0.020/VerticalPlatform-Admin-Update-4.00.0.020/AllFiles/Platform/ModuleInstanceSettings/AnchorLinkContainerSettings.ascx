<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AnchorLinkContainerSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.AnchorLinkContainerSettings" %>
<table>
	<tr>
		<td>
			Display Title
		</td>
		<td>
			<asp:CheckBox ID="displayTitleCheck" runat="server" />
			<asp:HiddenField ID="displayTitleHidden" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Containers First Available Module Title as the Container Title
		</td>
		<td>
			<asp:CheckBox ID="displayFirstModuleTitleCheck" runat="server" />
			<asp:HiddenField ID="displayFirstModuleTitleHidden" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Schema Type
		</td>
		<td>
			<asp:DropDownList ID="schemaTypeDropdown" runat="server"></asp:DropDownList>
			<asp:HiddenField ID="schemaTypeHidden" runat="server" />
		</td>
	</tr>
</table>