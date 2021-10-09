<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditPageType.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.AddEditPageType" %>
<table>
	<tr>
		<td>
			Page Category
		</td>
		<td>
			<asp:DropDownList ID="ddlPageCategory" runat="server"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Page
		</td>
		<td>
			<asp:DropDownList ID="ddlPage" runat="server"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" runat="server" />
		</td>
	</tr>
</table>
