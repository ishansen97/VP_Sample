<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddModuleInstance.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.AddModuleInstance" %>

<table>
	<tr>
		<td>
			Module
		</td>
		<td>
			<asp:DropDownList ID="ddlModuleList" runat="server" AppendDataBoundItems="true">
				<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvModuleList" runat="server" ErrorMessage="Please select a moudle" ControlToValidate="ddlModuleList">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Title
		</td>
		<td>
			<asp:TextBox ID="txtModuleTitle" runat="server" Width="250px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvModuleTitle" runat="server" ControlToValidate="txtModuleTitle"
				ErrorMessage="Please enter module title">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Title Link URL
		</td>
		<td>
			<asp:TextBox ID="txtTitleLinkUrl" runat="server" Width="250px" MaxLength="255"></asp:TextBox>
			<asp:RegularExpressionValidator ID="revTitleLinkUrl" runat="server" ControlToValidate="txtTitleLinkUrl"
				ErrorMessage="Please enter valid Url" ValidationExpression="http(s)?://([\w-]+[\.]?)+[\w-]+(/[\w- ./?%&amp;=]*)?" >*
			</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Pane
		</td>
		<td>
			<asp:DropDownList ID="ddlModulePane" runat="server" AppendDataBoundItems="true">
				<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvModulePane" runat="server" ControlToValidate="ddlModulePane"
				ErrorMessage="Please select a module pane">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Custom Style Class
		</td>
		<td>
			<asp:TextBox runat="server" ID="txtCustomStyle" Width="200px"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Sort Order
		</td>
		<td>
			<asp:TextBox ID="txtSortOrder" runat="server"></asp:TextBox>
			<asp:CompareValidator ID="cvSortOrder" ControlToValidate="txtSortOrder" Operator="DataTypeCheck"
							Type="Integer" Text="Invalid" runat="server" ErrorMessage="Please enter interger for sort order">*</asp:CompareValidator>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkModuleEnabled" runat="server" />
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:Label ID="lblMessage" runat="server"></asp:Label>
		</td>
	</tr>
</table>
