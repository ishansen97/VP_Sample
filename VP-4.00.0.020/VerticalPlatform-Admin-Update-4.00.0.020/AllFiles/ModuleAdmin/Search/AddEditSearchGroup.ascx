<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditSearchGroup.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.AddEditSearchGroup" %>

<table >
	<tr>
		<td>Name</td>
		<td>
			<asp:TextBox ID="txtGroupName" runat="server" Width="150" MaxLength="250"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTxtGroupName" runat="server"
				ErrorMessage="Please enter group name." ControlToValidate="txtGroupName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>Description</td>
		<td>
			<asp:TextBox ID="txtDescription" runat="server" Width="150" MaxLength="400"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>Parent Group</td>
		<td>
			<asp:DropDownList ID="ddlParentGroup" AutoPostBack="False" runat="server" Width="150"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>Add Options Automatically</td>
		<td>
			<asp:CheckBox ID="chkAddOptionsAutomatically" runat="server"></asp:CheckBox>
		</td>
	</tr>
	<tr>
		<td>Prefix</td>
		<td>
			<asp:TextBox ID="txtPrefix" runat="server" Width="150" MaxLength="400"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>Suffix</td>
		<td>
			<asp:TextBox ID="txtSuffix" runat="server" Width="150" MaxLength="400"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>Search Enabled</td>
		<td>
			<asp:CheckBox ID="searchEnabledCheckBox" runat="server" Checked="true"></asp:CheckBox>
		</td>
	</tr>
	<tr>
		<td>Locked</td>
		<td>
			<asp:CheckBox ID="lockedCheckBox" runat="server" Checked="false"></asp:CheckBox>
		</td>
	</tr>
</table>
<br />
<asp:Label ID="lblParentGroupMessage" runat="server"></asp:Label>
