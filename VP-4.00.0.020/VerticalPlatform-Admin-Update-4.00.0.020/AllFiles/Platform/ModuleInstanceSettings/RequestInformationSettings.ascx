<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RequestInformationSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.RequestInformationSettings" %>
<table>
	<tr>
		<td>
			Image Size Extension
		</td>
		<td>
			<asp:DropDownList ID="ddlSizeExtension" runat="server"></asp:DropDownList>
			<asp:HiddenField ID="hdnSizeExtension" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Button
		</td>
		<td>
			<asp:DropDownList ID="ddlActionButton" runat="server"></asp:DropDownList>
			<asp:HiddenField ID="hdnActionButton" runat="server" />
		</td>
	</tr>
    <tr>
        <td>
            Enable Lead Form Popup
        </td>
        <td>
            <asp:CheckBox ID="chkLeadFormPopup" runat="server" />
            <asp:HiddenField ID="hdnLeadFormPopup" runat="server" />
        </td>
    </tr>
</table>
