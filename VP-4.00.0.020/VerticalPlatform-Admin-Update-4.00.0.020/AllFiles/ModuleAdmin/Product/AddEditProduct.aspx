<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditProduct.aspx.cs"
	MasterPageFile="~/MasterPage.Master" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddEditProduct" %>

<asp:Content ID="cntProduct" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$(".menuHorizontal .menu li a.active").parent().addClass("selected");

			$("div.AdminPanelContent a.menuLink").click(function() {
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
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">
					Add/Edit Product
				</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent page-content-area">
		<div class="tabs-container">
			<div class="menuHorizontal">
				<ul class="menu">
					<li class="first">
						<asp:LinkButton ID="lbtnProductDetails" runat="server" OnClick="lbtnTab_Click" CommandArgument="1">
						Product Details</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnProductParameters" runat="server" OnClick="lbtnTab_Click" CommandArgument="2">
						Product Parameters</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnCategoryDetails" runat="server" OnClick="lbtnTab_Click" CommandArgument="3">
						Category Details</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnVendorDetails" runat="server" OnClick="lbtnTab_Click" CommandArgument="4">
						Vendor Details</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnProductSpecification" runat="server" OnClick="lbtnTab_Click" CommandArgument="5">
						Product Specification</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnCategorySpecification" runat="server" OnClick="lbtnTab_Click" CommandArgument="6">
						Category Specification</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnModelDetail" runat="server" OnClick="lbtnTab_Click" CommandArgument="7">
					Model Detail</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnRelatedProductDetail" runat="server" OnClick="lbtnTab_Click" CommandArgument="8">
					Related Product Detail</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnContentAssociation" runat="server" OnClick="lbtnTab_Click" CommandArgument="9">
					Content Association</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnLocations" runat="server" OnClick="lbtnTab_Click" CommandArgument="10">
					Locations</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnActionDetail" runat="server" OnClick="lbtnTab_Click" CommandArgument="11">
					Action Detail</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnUrls" runat="server" OnClick="lbtnTab_Click" CommandArgument="12">
					Urls</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnClickthroughDetail" runat="server" OnClick="lbtnTab_Click" CommandArgument="13">
					Clickthrough Detail</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnSearchOptions" runat="server" OnClick="lbtnTab_Click" CommandArgument="14">
						Search Options</asp:LinkButton>
					</li>
					<li >
						<asp:LinkButton ID="lbtnProductDisplayStatus" runat="server" OnClick="lbtnTab_Click" CommandArgument="15">
						Display Status</asp:LinkButton>
					</li>
					<li>
						<asp:LinkButton ID="lbtnMetadata" runat="server" OnClick="lbtnTab_Click" CommandArgument="16">
						Metadata</asp:LinkButton>
					</li>
					<li class="last">
						<asp:LinkButton ID="leadActionLocationsLink" runat="server" OnClick="lbtnTab_Click" CommandArgument="17">
						Lead Action Locations</asp:LinkButton>
					</li>
				</ul>
			</div>
		</div>
		<div class="menu_tab_contents">
			<asp:PlaceHolder ID="cphProductControl" runat="server"></asp:PlaceHolder>
		</div>
		<div>
			<asp:Button ID="btnSaveProduct" runat="server" Text="Save Product" Width="150px"
					OnClick="btnSaveProduct_Click" CssClass="btn" />
			<input type="hidden" id="hdnDisableInvalidCategory" value="" runat="server" class="common_text_button" />
			&nbsp
			<asp:Button ID="btnClose" runat="server" Text="Close" Width="150px"
					OnClick="btnClose_Click" CssClass="btn" CausesValidation="false" />
		</div>
		</div>
	</div>
</asp:Content>
