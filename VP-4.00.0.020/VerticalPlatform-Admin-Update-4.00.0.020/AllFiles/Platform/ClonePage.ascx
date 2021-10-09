<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ClonePage.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ClonePage" %>
<table>
	<tr>
		<td>
			Page Name
		</td>
		<td>
			<asp:TextBox ID="pageNameTextBox" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="PageNameValidator" runat="server" ControlToValidate="pageNameTextBox"
							ErrorMessage="Please enter page name.">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Page Title
		</td>
		<td>
			<asp:TextBox ID="pageTitleTextBox" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="PageTitleValidator" runat="server" ControlToValidate="pageTitleTextBox"
							ErrorMessage="Please enter page title.">*</asp:RequiredFieldValidator>
		</td>
	</tr>
</table>
