<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductSpecification.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductSpecification" %>

    <h4>Add or Edit Product Related Specification</h4>

<div class="specification_table">
				<div class="add-button-container"><asp:HyperLink ID="lnkAddSpecification" runat="server" CssClass="aDialog btn">Add Product Specification</asp:HyperLink></div>
				<asp:GridView ID="gvProductRelatedSpecification" runat="server" AutoGenerateColumns="False"
					OnRowDataBound="gvProductRelatedSpecification_RowDataBound" OnRowCommand="gvProductRelatedSpecification_RowCommand"
					CssClass="common_data_grid table table-bordered" EnableViewState="false">
					<Columns>
					    <asp:TemplateField HeaderText="Specification Type Id">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecificationTypeId" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField> 
						<asp:TemplateField HeaderText="Sort Order">
							<ItemTemplate>
								<asp:Literal ID="sortOrderLiteral" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Specification Type">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecificationType" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Specification">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecification" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Display Options">
							<ItemTemplate>
								<asp:CheckBox ID="chkShowInProductDetail"  Text="Product Detail" runat="server" Enabled="false"/>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Enable">
							<ItemTemplate>
								<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false"/>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50px">
							<ItemTemplate>
								<asp:HyperLink ID="lbtnEditSpecification" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
								<asp:LinkButton ID="lbtnRemoveSpecification" runat="server" CommandName="RemoveSpecification"
									OnClientClick="return confirm('Are you sure to delete the product specification?');" CssClass="grid_icon_link delete" ToolTip="Delete">Remove</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
	
</div>
