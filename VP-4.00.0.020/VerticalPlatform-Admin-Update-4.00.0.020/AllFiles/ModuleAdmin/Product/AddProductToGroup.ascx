<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddProductToGroup.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddProductToGroup" %>
<script type="text/javascript">
	$(document).ready(function() {
		var productIdOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15" };
		var compressionGroupIdOptions = { siteId: VP.SiteId, type: "ProductCompressionGroup", currentPage: "1", pageSize: "15" };

		$("input[type=text][id*=txtProductId]").contentPicker(productIdOptions);
		$("input[type=text][id*=txtGroupId]").contentPicker(compressionGroupIdOptions);
	});
</script>

<table>
	<tr>
		<td width="120">
			Compression Group
		</td>
		<td>
			<asp:TextBox ID="txtGroupId" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Product
		</td>
		<td>
			<asp:TextBox ID="txtProductId" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
		
			&nbsp;</td>
		<td>
			
			<asp:Button ID="btnAdd" runat="server" onclick="btnAdd_Click" Text="Add" CssClass="common_text_button" />
&nbsp;<asp:Button ID="btnRemove" runat="server" onclick="btnRemove_Click" Text="Remove" CssClass="common_text_button" />
			
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:ListBox ID="lstProducts" runat="server" Height="92px" Width="375px">
			</asp:ListBox>
		</td>
	</tr>
	</table>