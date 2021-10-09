<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditMenuAction.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.AddEditMenuAction" %>
<table>
    <tr>
        <td>
            Menu Action Type
        </td>
        <td>
            <asp:DropDownList ID="menuActionTypeList" runat="server">
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvMenuActionType" runat="server" ControlToValidate="menuActionTypeList" InitialValue="-1" ErrorMessage="Please select an action type." />
        </td>
    </tr>
    <tr>
        <td>
            Display Text
        </td>
        <td>
            <asp:TextBox ID="menuActionText" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            Custom CSS Class
        </td>
        <td>
            <asp:TextBox ID="cssClassCustomText" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            Enabled
        </td>
        <td>
            <asp:CheckBox ID="enabledCheckbox" runat="server"></asp:CheckBox>
        </td>
    </tr>
</table>