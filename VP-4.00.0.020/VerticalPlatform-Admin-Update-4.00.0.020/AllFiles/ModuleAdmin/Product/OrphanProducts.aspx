<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="OrphanProducts.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.OrphanProducts" %>
<%@ Register src="../Pager.ascx" tagname="Pager" tagprefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script type="text/javascript">
		RegisterNamespace("VP.CategoryList");

		VP.CategoryList.Initialize = function () {
			$(document).ready(function () {
				var orphanProductIdElement = { contentId: "orphanProductId" };
				var orphanProductNameElement = { contentName: "orphanProductName" };
				var orphanProductNameOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15", showName: "true", bindings: orphanProductIdElement };
				var orphanProductIdOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15", bindings: orphanProductNameElement };
				$("input[type=text][id*=orphanProductName]").contentPicker(orphanProductNameOptions);
				$("input[type=text][id*=orphanProductId]").contentPicker(orphanProductIdOptions);

				$(".article_srh_btn").click(function () {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.CategoryList.GetSearchCriteriaText());
			});
		}

		VP.CategoryList.GetSearchCriteriaText = function () {
			var orphanProductNameValue = $("input[id$='orphanProductName']");
			var orphanProductIdValue = $("input[id$='orphanProductId']");

			var searchHtml = "";
			if (orphanProductNameValue.length && orphanProductNameValue.val().trim().length > 0) {
				searchHtml += " ; <b>Name : </b> " + orphanProductNameValue.val().trim();
			}

			if (orphanProductIdValue.length && orphanProductIdValue.val().trim().length > 0) {
				searchHtml += " ; <b>Id : </b> " + orphanProductIdValue.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};

		VP.CategoryList.Initialize();
	</script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Orphan Products</h3>
		</div>
		<div class="article_srh_btn">
					Search</div>
				<div id="divSearchCriteria">
				</div>
				<br />
				<div id="divCategorySearch" runat="server" class="article_srh_pane" style="display: none;">
					<div class="inline-form-container">
						<span class="title">Product Name</span>
						<asp:TextBox ID="orphanProductName" runat="server"></asp:TextBox>
						<asp:RequiredFieldValidator ID="rfvProductName" runat="server" ValidationGroup="orphanProductSearch"
							ErrorMessage="Enter a Product Name." Width="10px" ControlToValidate="orphanProductName">*</asp:RequiredFieldValidator>
					    <asp:TextBox ID="orphanProductId" runat="server"></asp:TextBox>
						<asp:RequiredFieldValidator ID="rfvProductId" runat="server" ValidationGroup="orphanProductSearch"
							ErrorMessage="Enter a Product Id." Width="10px" ControlToValidate="orphanProductId">*</asp:RequiredFieldValidator>
					    <asp:Button ID="Search" runat="server" Text="Search" OnClick="Search_Click"
						    CssClass="btn" ValidationGroup="orphanProductSearch"/>
					    <asp:Button ID="CancelSearch" runat="server" Text="Reset" CssClass="btn"
						OnClick="CancelSearch_Click"/>
						<asp:CompareValidator ID="productIdValidator" runat="server" ControlToValidate="orphanProductId"
								ValidationGroup="orphanProductSearch" ErrorMessage="Please enter a number for product id."
								Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
					</div>
				</div>
				<br />
		<div class="AdminPanelContent">
			<asp:GridView ID="gvOrphanProducts" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" HeaderStyle-Width="120px" />
					<asp:BoundField DataField="Name" HeaderText="Name"/>
					<asp:BoundField DataField="Created" HeaderText="Created" HeaderStyle-Width="200px"/>
					<asp:BoundField DataField="Modified" HeaderText="Modified" HeaderStyle-Width="200px"/>
				</Columns>
				<EmptyDataTemplate>
				No Orphan Products Found.
				</EmptyDataTemplate>
			</asp:GridView>
			<uc1:Pager ID="PagerOrphanProductList" runat="server" />
		</div>
		<div>
		</div>
	</div>
</asp:Content>
