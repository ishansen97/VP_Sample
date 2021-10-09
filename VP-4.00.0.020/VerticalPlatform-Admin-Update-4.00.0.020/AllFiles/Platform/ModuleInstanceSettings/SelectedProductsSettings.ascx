<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SelectedProductsSettings.ascx.cs"
  Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.SelectedProductsSettings" %>
<table>
  <tr>
    <td>Selected Products Module Header Text
    </td>
    <td>
      <asp:TextBox ID="txtHeader" runat="server" Width="328px"></asp:TextBox>
      <asp:HiddenField ID="hdnHeader" runat="server" />
    </td>
  </tr>
  <tr>
    <td>Select Products Prompt Text
    </td>
    <td>
      <asp:TextBox ID="promptText" runat="server"></asp:TextBox>
      <asp:HiddenField ID="promptHidden" runat="server" />
    </td>
  </tr>
  <tr>
    <td>Enable Clear All Button</td>
    <td>
      <asp:CheckBox ID="enableClearAllButton" runat="server" />
      <asp:HiddenField ID="enableClearAllHidden" runat="server" />
    </td>
  </tr>
</table>
