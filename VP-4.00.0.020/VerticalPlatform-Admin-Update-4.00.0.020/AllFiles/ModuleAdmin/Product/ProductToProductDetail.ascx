<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductToProductDetail.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductToProductDetail" %>

<h4>Add Related Products to the Product</h4>

<div id="divOuterProduct" runat="server">
	<div class="add-button-container">
		<asp:HyperLink ID="lnkAddProduct" runat="server" CssClass="aDialog btn">Add Related Product</asp:HyperLink>
	</div>
	<asp:GridView ID="gvRelatedProducts" runat="server" AutoGenerateColumns="False" OnRowDeleting="gvRelatedProducts_RowDeleting"
		OnRowDataBound="gvRelatedProducts_RowDataBound" CssClass="common_data_grid table table-bordered" 
		EnableViewState="false" style="width:auto">
		<Columns>
			<asp:TemplateField HeaderText="Product Id">
				<ItemTemplate>
					<asp:Literal ID="ltlProductId" runat="server" 
					Text='<%# DataBinder.Eval(Container.DataItem,"ProductToProduct.ProductId") %>'></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Product Name">
				<ItemTemplate>
					<asp:Literal ID="ltlProductName" runat="server" 
					Text='<%# DataBinder.Eval(Container.DataItem,"Product.Name") %>'></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Sort Order">
				<ItemTemplate>
					<asp:Literal ID="productToProductSortOrderLiteral" runat="server" 
					Text='<%# DataBinder.Eval(Container.DataItem,"ProductToProduct.SortOrder") %>'></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Enabled" ItemStyle-HorizontalAlign="Center">
				<ItemTemplate>
					<asp:CheckBox ID="chkProductToProductEnabled" runat="server" 
					Checked='<%# DataBinder.Eval(Container.DataItem,"ProductToProduct.Enabled") %>'
						Enabled="False" />
				</ItemTemplate>
				<ItemStyle Width="60px" />
			</asp:TemplateField>
			<asp:TemplateField ShowHeader="False" ItemStyle-HorizontalAlign="Center">
				<ItemTemplate>
					<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" 
						ToolTip="Edit">Edit</asp:HyperLink>
					<asp:LinkButton ID="lbtnRemove" runat="server" CausesValidation="False" CommandName="Delete"
						OnClientClick="return confirm(&quot;Are you sure you want to remove this product&quot;);"
						Text="Remove" CssClass="grid_icon_link delete" ToolTip="Remove"></asp:LinkButton>
				</ItemTemplate>
				<ItemStyle Width="50px" />
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
</div>
