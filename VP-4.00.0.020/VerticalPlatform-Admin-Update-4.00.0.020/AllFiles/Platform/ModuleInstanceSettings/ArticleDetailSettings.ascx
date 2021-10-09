<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleDetailSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ArticleDetailSettings" %>
<table>
	<tr>
		<td>
			Use Article as Module Title
		</td>
		<td>
			<asp:CheckBox ID="chkUseArticleAsModuleTitle" runat="server" />
			<asp:HiddenField ID="hdnUseArticleAsModuleTitle" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Primary Article Detail Module of Page
		</td>
		<td>
			<asp:CheckBox ID="chkIsPrimaryModule" runat="server" />
			<asp:HiddenField ID="hdnIsPrimaryModule" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Hide Module When Empty
		</td>
		<td>
			<asp:CheckBox ID="chkHideWhenEmpty" runat="server" />
			<asp:HiddenField ID="hdnHideWhenEmpty" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Show Unpublished Articles
		</td>
		<td>
			<asp:CheckBox ID="chkShowUnpublished" runat="server" />
			<asp:HiddenField ID="hdnShowUnpublished" runat="server" />
		</td>
	</tr>
		<tr>
		<td>
			Enable Web Analytics
		</td>
		<td>
			<asp:CheckBox ID="chkEnableWebAnalytics" runat="server" />
			<asp:HiddenField ID="hdnEnableWebAnalytics" runat="server" />
		</td>
	</tr>
</table>
<br />
<br />

<asp:Panel ID="pnlAssociatedSections" runat="server">
<h4>
	Template Section Settings</h4>
	<table>
		<tr>
			<td>
				<asp:Label ID="lblSectionsAssociated" runat="server" Text="Article Section Holders to display"></asp:Label>
			</td>
			<td>
			</td>
		</tr>
		<tr>
			<td>
			</td>
			<td>
				<asp:CheckBoxList ID="chklSections" runat="server">
				</asp:CheckBoxList>
				<asp:HiddenField ID="hdnSectionsAssociated" runat="server" />
			</td>
		</tr>
	</table>
</asp:Panel>
