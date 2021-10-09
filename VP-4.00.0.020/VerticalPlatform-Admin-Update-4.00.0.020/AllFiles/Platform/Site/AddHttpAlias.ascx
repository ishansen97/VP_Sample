<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddHttpAlias.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Site.AddHttpAlias" %>
<div>
	<table>
		<tr>
			<td>
				Http Alias
			</td>
			<td>
				<asp:TextBox ID="txtHttpAliasName" runat="server" Width="318px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvHttpAlias" runat="server" ControlToValidate="txtHttpAliasName"
					ErrorMessage="Please enter a valid alias.">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Enabled
			</td>
			<td>
				<asp:CheckBox ID="chkEnableHttpAlias" runat="server" />
			</td>
		</tr>
		<tr>
			<td>
				Primary
			</td>
			<td>
				<asp:CheckBox ID="chkIsPrimary" runat="server" />
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
			</td>
		</tr>
	</table>
</div>
