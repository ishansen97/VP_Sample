<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleComment.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleComment" %>
<table>
	<tr>
		<td colspan="2"><h3>Edit Comment</h3></td>
	</tr>
	<tr>
		<td>
			Comment
		</td>
		<td>
			<asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Width="600" Height="200"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="true" />
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:Label ID="lblMessage" runat="server"></asp:Label>
		</td>
	</tr>
</table>