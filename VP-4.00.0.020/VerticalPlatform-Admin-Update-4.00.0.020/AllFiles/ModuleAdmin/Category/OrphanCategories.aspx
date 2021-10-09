<%@ Page Language="C#"  MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="OrphanCategories.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.OrphanCategories" %>
<%@ Register src="../Pager.ascx" tagname="Pager" tagprefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script type="text/javascript">
		RegisterNamespace("VP.CategoryList");

		VP.CategoryList.Initialize = function () {
			$(document).ready(function () {
				var orphanCategoryIdElement = { contentId: "orphanCategoryId" };
				var orphanCategoryNameElement = { contentName: "orphanCategoryName" };
				var orphanCategoryNameOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", showName: "true", bindings: orphanCategoryIdElement };
				var orphanCategoryIdOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", bindings: orphanCategoryNameElement};
				$("input[type=text][id*=orphanCategoryName]").contentPicker(orphanCategoryNameOptions);
				$("input[type=text][id*=orphanCategoryId]").contentPicker(orphanCategoryIdOptions);

				$(".article_srh_btn").click(function () {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.CategoryList.GetSearchCriteriaText());
			});
		}

		VP.CategoryList.GetSearchCriteriaText = function () {
			var orphanCategoryNameValue = $("input[id$='orphanCategoryName']");
			var orphanCategoryIdValue = $("input[id$='orphanCategoryId']");

			var searchHtml = "";
			if (orphanCategoryNameValue.length && orphanCategoryNameValue.val().trim().length > 0) {
				searchHtml += " ; <b>Name : </b> " + orphanCategoryNameValue.val().trim();
			}

			if (orphanCategoryIdValue.length && orphanCategoryIdValue.val().trim().length > 0) {
				searchHtml += " ; <b>Id : </b> " + orphanCategoryIdValue.val().trim();
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
				<asp:Label ID="lblTitle" runat="server" /></h3>
			<input type="hidden" id="hdnParentName" runat="server" />
		</div>
				<div class="article_srh_btn">
					Search</div>
				<div id="divSearchCriteria">
				</div>
				<br />
				<div id="divCategorySearch" runat="server" class="article_srh_pane" style="display: none;">
					<div class="inline-form-container">
						<span class="title">Category Name</span>
						<asp:TextBox ID="orphanCategoryName" runat="server"></asp:TextBox>
						<asp:RequiredFieldValidator ID="rfvCategorytName" runat="server" ValidationGroup="orphanCategorySearch"
							ErrorMessage="Enter a Category Name." Width="10px" ControlToValidate="orphanCategoryName">*</asp:RequiredFieldValidator>
					    <asp:TextBox ID="orphanCategoryId" runat="server"></asp:TextBox>
						<asp:RequiredFieldValidator ID="rfvCategoryId" runat="server" ValidationGroup="orphanCategorySearch"
							ErrorMessage="Enter a Category Id."  Width="10px" ControlToValidate="orphanCategoryId">*</asp:RequiredFieldValidator>
					    <asp:Button ID="Search" runat="server" Text="Search"
						    CssClass="btn" OnClick="Search_Click" ValidationGroup="orphanCategorySearch"/>
					    <asp:Button ID="CancelSearch" runat="server" Text="Reset" CssClass="btn"
						OnClick="CancelSearch_Click"/>
						<asp:CompareValidator ID="categoryIdValidator" runat="server" ControlToValidate="orphanCategoryId"
								ValidationGroup="orphanCategorySearch" ErrorMessage="Please enter a number for category id."
								Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
                    </div>
				</div>
				<br />
		<div class="AdminPanelContent">
			<asp:GridView ID="gvOrphanCategories" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid" OnDataBound="gvOrphanCategories_DataBound">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" />
					<asp:TemplateField>
						<HeaderTemplate>
							Name</HeaderTemplate>
						<ItemTemplate>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField DataField="Created" HeaderText="Created" />
					<asp:BoundField DataField="Modified" HeaderText="Modified" />
				</Columns>
				<EmptyDataTemplate>
				No Orphan Categories Found.
				</EmptyDataTemplate>
			</asp:GridView>
			<uc1:Pager ID="PagerOrphanCategoryList" runat="server" />
		</div>
		<div>
		</div>
	</div>
</asp:Content>
