<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="VendorCategory.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorCategory" %>

<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {

			var categoryIdOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", categoryType: "Leaf" };
			$("input[type=text][id*=txtCategory]").contentPicker(categoryIdOptions);
		});
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Associate categories to vendor</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div id="divSearchPane">
				<table>
					<tr>
						<td>
							<asp:Literal ID="ltlCategoryId" runat="server" Text="Category Id"></asp:Literal>
						</td>
						<td>
							<asp:TextBox ID="txtCategory" runat="server"></asp:TextBox>
						</td>
					</tr>
				</table>
			</div>
			<br />
			<div>
				<asp:Button ID="btnAssociateCategory" runat="server" Text="Associate" Width="90px"
					OnClick="btnAssociateCategory_Click" CssClass="common_text_button" />
				<asp:Button ID="btnCancelAssociate" runat="server" Text="Cancel" Width="90px" OnClick="btnCancelAssociate_Click"
					CssClass="common_text_button" />
			</div>
			<br />
			<div>
				<asp:GridView ID="gvCategory" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvCategory_RowDataBound"
					CssClass="common_data_grid" OnRowCommand="gvCategory_RowCommand">
					<AlternatingRowStyle CssClass="GridAltItem" />
					<RowStyle CssClass="GridItem" />
					<HeaderStyle CssClass="GridHeader" />
					<Columns>
						<asp:TemplateField HeaderText="Category Id" ItemStyle-Width="100px">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryId" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category Name">
							<ItemTemplate>
								<asp:Literal ID="ltlName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteAssociation" CssClass="grid_icon_link delete"
								ToolTip="Delete" OnClientClick="return confirm('Are you sure to delete the category association?');">Delete</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						No Categories Found.
					</EmptyDataTemplate>
				</asp:GridView>
			</div>
		</div>
	</div>
</asp:Content>
