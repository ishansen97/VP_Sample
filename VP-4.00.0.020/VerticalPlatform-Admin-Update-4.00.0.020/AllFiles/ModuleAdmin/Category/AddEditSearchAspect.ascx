<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditSearchAspect.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddEditSearchAspect" %>

<table>
	<tr>
		<td>
			Name
		</td>
		<td>
			<asp:TextBox ID="txtName" runat="server" MaxLength="250"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Please enter search aspect name."
				ControlToValidate="txtName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Prefix
		</td>
		<td>
			<asp:TextBox ID="txtPrefix" runat="server" MaxLength="250"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Suffix
		</td>
		<td>
			<asp:TextBox ID="txtSuffix" runat="server" MaxLength="250"></asp:TextBox>
		</td>
	</tr>
</table>
