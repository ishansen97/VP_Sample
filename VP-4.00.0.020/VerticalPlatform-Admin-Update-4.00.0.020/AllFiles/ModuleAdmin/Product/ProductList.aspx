<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" MasterPageFile="~/MasterPage.Master"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductList" %>

<asp:Content ID="cntProduct" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			$(".author_srh_btn").click(function() {
				$(".author_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
			});

			var productNameOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15", showName: "true" };
			var categoryIdOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", categoryType: "Leaf" };
			var vendorIdOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15" };
			$("input[type=text][id*=txtProductName]").contentPicker(productNameOptions);
			$("input[type=text][id*=txtCategory]").contentPicker(categoryIdOptions);
			$("input[type=text][id*=txtVendorId]").contentPicker(vendorIdOptions);
			$(".common_data_grid td table").removeAttr("width").width('100%');

			$(".menuHorizontal .menu li a.active").parent().addClass("selected");

			$("div.AdminPanelContent a.menuLink").click(function () {
				if (typeof (Page_ClientValidate) == 'function')
					var valid = Page_ClientValidate();
			});

			$("div.menuHorizontal > ul.menu > li").each(function () {
				var ele = $(this);
				if (ele.text().trim().length == 0) {
					ele.hide();
				}
			});

		});
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblTitle" runat="server"></asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent page-content-area">
		<div class="tabs-container">
			<div class="menuHorizontal">
				<ul class="menu">
					<li class="first">
						<asp:LinkButton ID="lbtnProductDetails" runat="server" OnClick="lbtnTab_Click" CommandArgument="0" >
						Product List</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnArchiveProducts" runat="server" OnClick="lbtnTab_Click" CommandArgument="1" >
						Archived Product List</asp:LinkButton>
					</li>
				</ul>
			</div>
		</div>
		</div>
		<div class="menu_tab_contents">
			<asp:PlaceHolder ID="cphProductControl" runat="server"></asp:PlaceHolder>
		</div>
	</div>
</asp:Content>
