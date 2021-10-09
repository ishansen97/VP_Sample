<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="GroupProductList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.GroupProductList" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script type="text/javascript">

		RegisterNamespace("VP.GroupProductList");

		VP.GroupProductList.Initialize = function () {
			$(document).ready(function () {
				var productIdOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15" };
				var compressionGroupIdOptions = { siteId: VP.SiteId, type: "ProductCompressionGroup", currentPage: "1", pageSize: "15" };
				$("input[type=text][id*=txtProductId]").contentPicker(productIdOptions);
				$("input[type=text][id*=txtGroupId]").contentPicker(compressionGroupIdOptions);
				
				$(".article_srh_btn").click(function () {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.GroupProductList.GetSearchCriteriaText());
			});
		}

		VP.GroupProductList.GetSearchCriteriaText = function () {
			var txtProductNameValue = $("input[id$='txtProductId']");
			var txtGroupIdValue = $("input[id$='txtGroupId']");

			var searchHtml = "";
			if (txtProductNameValue.length && txtProductNameValue.val().trim().length > 0) {
				searchHtml += " ; <b>Product Id : </b> " + txtProductNameValue.val().trim();
			}

			if (txtGroupIdValue.length && txtGroupIdValue.val().trim().length > 0) {
				searchHtml += " ; <b>Group Id : </b> " + txtGroupIdValue.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};

		VP.GroupProductList.Initialize();

	</script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Add Products to Compression Group</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<div class="article_srh_btn">
				Filter</div>
			<div id="divSearchCriteria">
			</div>
			<br />
			<div id="divSearchPane" class="article_srh_pane" style="display: none;">
				<div class="form-horizontal">
					<div class="control-group">
						<label class="control-label">
							Compression Group</label>
						<div class="controls">
							<asp:TextBox ID="txtGroupId" runat="server"></asp:TextBox>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">
							Product</label>
						<div class="controls">
							<asp:TextBox ID="txtProductId" runat="server"></asp:TextBox>
						</div>
					</div>
					<div class="form-actions">
						<asp:Button ID="btnFilter" runat="server" Text="Filter" ValidationGroup="FilterList"
							CssClass="btn" OnClick="btnFilter_Click" />
						<asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn" OnClick="btnReset_Click" />
					</div>
				</div>
			</div>
			<br />
			<div class="add-button-container">
				<asp:HyperLink ID="lnkAddProduct" runat="server" Text="Add Products to Compression Group"
					CssClass="aDialog btn"></asp:HyperLink></div>
			<asp:GridView ID="gvGroupProduct" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvGroupProduct_RowDataBound"
				Width="100%" CssClass="common_data_grid table table-bordered" OnRowCommand="gvGroupProduct_RowCommand">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" />
					<asp:BoundField DataField="ProductCompressionGroupId" HeaderText="Product Compression Group Id" />
					<asp:TemplateField HeaderText="Product Compression Group">
						<ItemTemplate>
							<asp:Label ID="lblProductCompressionGroup" runat="server" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField DataField="ProductId" HeaderText="Product Id" />
					<asp:TemplateField HeaderText="Product">
						<ItemTemplate>
							<asp:Label ID="lblProduct" runat="server" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField DataField="Created" HeaderText="Created" />
					<asp:BoundField DataField="Modified" HeaderText="Modified" />
					<asp:TemplateField HeaderText="Enabled">
						<ItemTemplate>
							<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton OnClientClick="return confirm('Are you sure you want to delete this product to compression group relationship?');"
								ID="lbtnDelete" runat="server" Text="Delete" CommandName="DeleteProductCompressionGroupToProduct"
								CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No Compression Group products Found.
				</EmptyDataTemplate>
			</asp:GridView>
			<br />
			<uc1:Pager ID="pgPager" runat="server" />
		</div>
	</div>
</asp:Content>
