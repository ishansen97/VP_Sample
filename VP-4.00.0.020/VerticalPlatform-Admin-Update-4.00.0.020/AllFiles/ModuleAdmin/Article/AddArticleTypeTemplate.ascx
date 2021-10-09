<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddArticleTypeTemplate.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.AddArticleTypeTemplate" %>
<div class="AdminPanel">
	<div class="AdminPanelContent">
		<table style="width: 100%;">
			<tr class="control-group">
				<td class="control-label">Article Type</td>
				<td class="controls">
					<asp:Label ID="articleTypeName" runat="server" Text="articleType"></asp:Label>
				</td>
			</tr>
			<tr class="control-group">
				<td class="control-label">
					Article Template</td>
				<td>
					&nbsp;
					<asp:DropDownList ID="articleTypeTemplates" runat="server">
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="templateValidator" runat="server" 
						ControlToValidate="articleTypeTemplates" ErrorMessage="*" 
						InitialValue="-Select Template-">Please select a template.</asp:RequiredFieldValidator>
				</td>
			</tr>
			<tr class="control-group">
				<td class="control-label">
					Custom Page</td>
				<td class="controls">
					<asp:DropDownList ID="articleDetailPages" runat="server">
					</asp:DropDownList>
				</td>
			</tr>
			<tr class="control-group">
				<td class="control-label">
					Enabled</td>
				<td class="controls">
					<asp:CheckBox ID="enabled" runat="server" />
				</td>
			</tr>
		</table>
	</div>
</div>