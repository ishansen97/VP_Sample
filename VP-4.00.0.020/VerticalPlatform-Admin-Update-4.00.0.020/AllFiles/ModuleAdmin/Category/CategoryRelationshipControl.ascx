<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategoryRelationshipControl.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.CategoryRelationshipControl" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register src="../Pager.ascx" tagname="Pager" tagprefix="uc1" %>


<div>
	<asp:Panel runat="server">
		<table>
			<tr>
				<td>
					<b>Related Parent Categories</b>
				</td>
			</tr>
			<tr>
				<asp:GridView ID="gvRelatedParentCategories" runat="server" AutoGenerateColumns="False"
							OnRowDataBound="gvRelatedParentCategories_RowDataBound"
							CssClass="common_data_grid table table-bordered">
							<AlternatingRowStyle CssClass="DataTableRowAlternate" />
							<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:TemplateField HeaderText="Category ID" SortExpression="Id" ItemStyle-Width="80px">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryId" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category Name" SortExpression="Name">
							<ItemTemplate>
								<asp:HyperLink ID="ltlCategoryName" runat="server"></asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						<b>No Parent Categories Found.</b>
					</EmptyDataTemplate>
				</asp:GridView>
			</tr>
			<tr>
				<td>
					<br /><br />
				</td>
			</tr>
			<tr>
				<td>
					<b>Related Child Categories</b>
				</td>
			</tr>
			<tr>
				<asp:GridView ID="gvRelatedChildCategories" runat="server" AutoGenerateColumns="False"
							OnRowCommand="gvRelatedChildCategories_RowCommand" OnRowDataBound="gvRelatedChildCategories_RowDataBound"
							CssClass="common_data_grid table table-bordered" PageSize="5" AllowSorting="True" OnSorting="gvRelatedChildCategories_Sorting">
							<AlternatingRowStyle CssClass="DataTableRowAlternate" />
							<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:TemplateField ItemStyle-Width="10px">
							<ItemTemplate>
								<asp:HyperLink ID="lnkLinkState" runat="server" CssClass="aDialog" Visible="false" Width="16">
-									<asp:Image ID="imgLinkState" runat="server" ImageUrl="~/Images/link.png" ToolTip = "Unlink category from parent category" />
-								</asp:HyperLink>
								<asp:LinkButton ID="lbtnLinkEnabled" runat="server" CommandName="ToggleLinkEnabled"
									CommandArgument='<%#Eval("Id") %>' Width="16">
									<asp:Image ID="imgLinkEnabledState" runat="server" />
								</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category ID" SortExpression="Id" ItemStyle-Width="80px">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryId" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category Name" SortExpression="Name">
							<ItemTemplate>
								<asp:HyperLink ID="ltlCategoryName" runat="server"></asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Jump Page Display Name">
							<ItemTemplate>
								<asp:Literal ID="jumpPageDisplayName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Hidden">
							<ItemTemplate>
								<asp:CheckBox runat="server" id="hidden" Enabled="False"/>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="editLink" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>
								<asp:LinkButton  OnClientClick="return confirm('Are you sure you want to remove this link?');"
									ID="deleteButton" runat="server" CommandName="DeleteLink" CssClass="grid_icon_link delete"
									CommandArgument='<%#Eval("Id") %>' Width="16"/>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						<b>No Child Categories Found.</b>
					</EmptyDataTemplate>
				</asp:GridView>
				<uc1:Pager ID="PagerChildCategoryList" runat="server" Visible="true"/>
			</tr>
		</table>
		<input type="hidden" id="hdnDisableSubcategoryId" runat="server" value="0" />
		<input type="hidden" id="hdnCategoryBranchId" runat="server" value="0" />
		<asp:LinkButton ID="lbtnDeleteLink" runat="server" Style="display: none"></asp:LinkButton>
	</asp:Panel>
</div>