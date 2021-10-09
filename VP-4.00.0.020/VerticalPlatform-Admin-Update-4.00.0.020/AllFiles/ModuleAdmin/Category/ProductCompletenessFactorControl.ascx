<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductCompletenessFactorControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.ProductCompletenessFactorControl" %>
<h4>
	Product Completeness Factors</h4>
<div class="add-button-container">
	<asp:HyperLink ID="addFactor" runat="server" CssClass="aDialog btn">Add Product Completeness Factor</asp:HyperLink>
</div>
<asp:GridView ID="productCompletenessFactorsList" runat="server" AutoGenerateColumns="False"
	CssClass="common_data_grid table table-bordered" OnRowCommand="productCompletenessFactorsList_RowCommand"
	OnRowDataBound="productCompletenessFactorsList_RowDataBound">
	<Columns>
		<asp:TemplateField HeaderText="Factor Content Type">
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
				<asp:HyperLink ID="editButton" runat="server" CommandName="EditCompleteness" ToolTip="Edit"
					CssClass="aDialog grid_icon_link edit" Text=""></asp:HyperLink>
				<asp:LinkButton ID="deleteButton" runat="server" CommandName="DeleteCompleteness"
					CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No Product completness factors found.</EmptyDataTemplate>
</asp:GridView>
