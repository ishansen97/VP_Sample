<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.SearchSettings" %>
<table>
	<tr>
		<td>
			Turn on AutoComplete
		</td>
		<td>
			<asp:CheckBox ID="chkAutoComplete" runat="server" AutoPostBack="true" OnCheckedChanged="chkAutoComplete_CheckedChange"/>
			<asp:HiddenField ID="hdnAutoComplete" runat="server" />
		</td>
	</tr>
	<tr>
    <td>
			<asp:Literal ID="ltlSearchTruncation" runat="server" Text="Header Truncation Length"></asp:Literal>
    </td>
    <td>
        <asp:TextBox ID="txtSearchTruncation" runat="server" Width="200"></asp:TextBox>
        <asp:HiddenField ID="hdnSearchTruncation" runat="server" />
        <asp:CompareValidator ID="cpvSearchTruncation" runat="server" ErrorMessage="Numbers only" ControlToValidate="txtSearchTruncation"
            Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
    </td>
  </tr>
</table>