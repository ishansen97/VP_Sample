<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddRelatedProducts.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddRelatedProducts" %>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			var txtProductId = { contentId: "txtProductId" };
			var productNameOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15",
					showName: "true", bindings: txtProductId, excludeParentChild: true };
			$("input[type=text][id*=txtProductName]").contentPicker(productNameOptions);
		});
	</script>

<div>
	<table>
		<tr>
			<td>
				<asp:Label ID="lblProductName" runat="server" Text="Product Name"></asp:Label>
			</td>
			<td>
				<asp:TextBox ID="txtProductName" runat="server" Width="250px">
				</asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="lblProductId" runat="server" Text="Product Id"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtProductId" runat="server" Width="250px">
				</asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				Sort Order
			</td>
			<td>
				<asp:TextBox ID="sortOrderTextBox" runat="server" Width="250px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="sortOrderRequiredValidator" runat="server" ControlToValidate="sortOrderTextBox"
					ErrorMessage="Please enter sort order.">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="sortOrderIntegerValidator" runat="server" ControlToValidate="sortOrderTextBox"
						ErrorMessage="Sort order should be a numeric value." ValidationExpression="^\d+$">*</asp:RegularExpressionValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Label ID="lblEnableProduct" runat="server" Text="Product Enabled"></asp:Label>
			</td>
			<td>
				<asp:CheckBox ID="chkProductEnabled" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
	</table>
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
</div>
