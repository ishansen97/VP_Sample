<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpecificationDetail.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.SpecificationDetail" %>

<tr class="AdminPanelSection">
	<td colspan="2">
		<h4>
			Add or Edit Product Specifications</h4>
	</td>
</tr>
<tr>
	<td colspan="2">
		<div id="divOuterSpec" runat="server">
				<asp:HyperLink ID="lnkAddCategorySpecification" runat="server" CssClass="aDialog">
					Add or Edit Category Related Specification</asp:HyperLink>
				<br />
				<br />
				<asp:HyperLink ID="lnkAddProductSpecification" runat="server" CssClass="aDialog">
					Add or Edit Product Related Specification</asp:HyperLink>
		</div>
	</td>
</tr>