<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContextualArticleSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ContextualArticleSettings" %>
<table>
	<tr>
		<td>
			Article Type
		</td>
		<td>
			<asp:DropDownList ID="articleTypeDropDown" runat="server" AutoPostBack="True" 
				onselectedindexchanged="ArticleTypeDropDown_SelectedIndexChanged" >
				<asp:ListItem Text=" - Select Article Type - " Value="-1"></asp:ListItem>
			</asp:DropDownList>
			   <asp:HiddenField ID="articleTypeId" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Template
		</td>
		<td>
			<asp:DropDownList ID="articleTemplateDropDown" runat="server" 
                AutoPostBack="True" 
                onselectedindexchanged="ArticleTemplateDropDown_SelectedIndexChanged" />
			<asp:HiddenField ID="articleTemplateId" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Hide Module When Empty
		</td>
		<td>
			<asp:CheckBox ID="hideWhenEmptyCheck" runat="server" />
			<asp:HiddenField ID="hideWhenEmptyHidden" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Show Unpublished Articles
		</td>
		<td>
			<asp:CheckBox ID="showUnpublishedCheck" runat="server" />
			<asp:HiddenField ID="showUnpublishedHidden" runat="server" />
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
				<asp:Label ID="sectionsAssociatedLabel" runat="server" Text="Article Section Holders to display"></asp:Label>
			</td>
			<td>
			</td>
		</tr>
		<tr>
			<td>
			</td>
			<td>
				<asp:CheckBoxList ID="sectionsCheckList" runat="server">
				</asp:CheckBoxList>
				<asp:HiddenField ID="sectionsAssociatedHidden" runat="server" />
			</td>
		</tr>
	</table>
</asp:Panel>
