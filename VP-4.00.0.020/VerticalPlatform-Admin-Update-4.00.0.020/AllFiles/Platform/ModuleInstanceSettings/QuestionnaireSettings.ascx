<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuestionnaireSettings.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.QuestionnaireSettings" %>
<table>
    <tr>
        <td>Enable Lead Form Popup
        </td>
        <td>
            <asp:CheckBox ID="chkLeadFormPopup" runat="server" />
            <asp:HiddenField ID="hdnLeadFormPopup" runat="server" />
        </td>
    </tr>
</table>
