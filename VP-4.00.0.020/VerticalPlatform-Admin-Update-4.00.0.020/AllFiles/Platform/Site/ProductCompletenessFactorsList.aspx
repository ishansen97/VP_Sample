<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ProductCompletenessFactorsList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.ProductCompletenessFactorsList" %>

<asp:content id="contents" contentplaceholderid="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>Product Completeness Factors</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container"><asp:HyperLink ID="addNewFactorButton" runat="server" CssClass="aDialog btn">Add New Factor</asp:HyperLink></div>
			<asp:GridView ID="productCompletenessFactorsList" runat="server" AutoGenerateColumns="False" 
					CssClass="common_data_grid table table-bordered" OnRowDataBound="productCompletenessFactorsList_RowDataBound" 
					onrowcommand="productCompletenessFactorsList_RowCommand" style="width:auto">
				<Columns>
						<asp:TemplateField HeaderText="Factor Content Type" >
							<ItemTemplate>
								<asp:Literal ID="factorContentType" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Factor Content Name">
							<ItemTemplate>
								<asp:Literal ID="factorContentName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Completeness Weight">
							<ItemTemplate>
								<asp:Literal ID="completenessWeight" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Incompleteness Weight">
							<ItemTemplate>
								<asp:Literal ID="incompletenessWeight" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50">
							<ItemTemplate>
								<asp:HyperLink ID="editButton" runat="server" CommandName="EditCompleteness" 
									ToolTip="Edit" CssClass="aDialog grid_icon_link edit" Text=""></asp:HyperLink>
								<asp:LinkButton ID="deleteButton" runat="server" CommandName="DeleteCompleteness" 
									CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>No Product completness factors found.</EmptyDataTemplate>
			</asp:GridView>
		</div>
	</div>
</asp:content>
