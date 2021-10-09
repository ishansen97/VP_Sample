<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleTypes.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleTypes" %>
<h4>Add/Edit Article Type</h4>
	<table>
		<tr>
			<td>
				Article Type
			</td>
			<td>
				<asp:TextBox ID="txtArticleType" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvArticleType" runat="server"
					ErrorMessage="Please enter 'Article Type'." ControlToValidate="txtArticleType">*</asp:RequiredFieldValidator>
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
			<td>
				Content Based
			</td>
			<td>
				<asp:CheckBox ID="chkContentBased" runat="server" />
			</td>
		</tr>
		<tr>
			<td colspan="2">
			&nbsp;<asp:HyperLink ID="lnkParameters" runat="server" Text="Parameters" />
			</td>
		</tr>
	</table>