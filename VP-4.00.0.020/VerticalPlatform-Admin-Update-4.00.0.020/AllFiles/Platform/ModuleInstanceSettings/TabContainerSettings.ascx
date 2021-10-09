<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TabContainerSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.TabContainerSettings" %>
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
			Persist Selected Item
		</td>
		<td>
			<asp:CheckBox ID="chkPersistItem" runat="server" />
			<asp:HiddenField ID="hdnPersistItem" runat="server" />
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
	<tr>
		<td>
			Display Headers Vertically
		</td>
		<td>
			<asp:CheckBox ID="chkVerticalHeaders" runat="server" AutoPostBack="true" OnCheckedChanged="chkVerticalHeaders_checkedChange"/>
			<asp:HiddenField ID="hdnVerticalHeaders" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			<asp:Label ID="lblHeaderQuote" runat="server" Text="Header Quote Text" />
		</td>
    <td>
        <asp:TextBox ID="txtHeaderQuote" runat="server"></asp:TextBox>
        <asp:HiddenField ID="hdnHeaderQuote" runat="server" />
    </td>
	</tr>
</table>