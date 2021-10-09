<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ParentProductSpecification.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ParentProductSpecification" %>
<h4>
	Parent Product Related Specification
</h4>
<div>
	<table class="specification_table">
		<tr>
			<td>
				<br />
				<asp:HyperLink ID="lnkAddSKUSpecification" runat="server" 
					CssClass="aDialog common_text_button">Add Product Specification</asp:HyperLink>
				<br />
				<br />
				<asp:GridView ID="gvProductRelatedSpecification" runat="server" 
					AutoGenerateColumns="False" CssClass="common_data_grid" EnableViewState="false" 
					OnRowCommand="gvProductRelatedSpecification_RowCommand" 
					OnRowDataBound="gvProductRelatedSpecification_RowDataBound">
					<Columns>
						<asp:TemplateField HeaderText="Specification Type Id">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecificationTypeId" runat="server"></asp:Literal>
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
								<asp:CheckBox ID="chkShowInProductDetail" runat="server" Enabled="false" 
									Text="Product Detail" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Enable">
							<ItemTemplate>
								<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50px">
							<ItemTemplate>
								<asp:HyperLink ID="lbtnEditSpecification" runat="server" 
									CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
								<asp:LinkButton ID="lbtnRemoveSpecification" runat="server" 
									CommandName="RemoveSpecification" CssClass="grid_icon_link delete" 
									OnClientClick="return confirm('Are you sure to delete the product specification?');" 
									ToolTip="Delete">Remove</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
			</td>
		</tr>
	</table>
</div>
