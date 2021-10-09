<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="CategoryList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.CategoryList"
	Title="Category List" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register src="../Pager.ascx" tagname="Pager" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
    <style type="text/css">
        .main-container .main-content .radio label{padding-left:0px;}
    </style>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script type="text/javascript">
		RegisterNamespace("VP.CategoryList");

		VP.CategoryList.Initialize = function() {
			$(document).ready(function() {
				var categoryIdElement = { contentId: "txtCategoryId" };
				var categoryNameElement = { contentName: "txtCategoryName" };
				var categoryNameOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", showName: "true", bindings: categoryIdElement };
				var categoryIdOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", bindings: categoryNameElement };
				$("input[type=text][id*=txtCategoryName]").contentPicker(categoryNameOptions);
				$("input[type=text][id*=txtCategoryId]").contentPicker(categoryIdOptions);

				$(".article_srh_btn").click(function() {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.CategoryList.GetSearchCriteriaText());

				var tabIndex = $("[id*=hdnTabIndex]").val();
				var $tabs = $('#tabs').tabs();
				$('#tabs').tabs("select", tabIndex);

				$(function () {
					$("#tabs").tabs({
						select: function (event, ui) {
							$("[id*=hdnTabIndex]").val(ui.index + 1);
						}
					});
				});
			});
		}

		VP.CategoryList.GetSearchCriteriaText = function() {
			var txtCategoryNameValue = $("input[id$='txtCategoryName']");
			var txtCategoryIdValue = $("input[id$='txtCategoryId']");

			var searchHtml = "";
			if (txtCategoryNameValue.length && txtCategoryNameValue.val().trim().length > 0) {
				searchHtml += " ; <b>Name : </b> " + txtCategoryNameValue.val().trim();
			}

			if (txtCategoryIdValue.length && txtCategoryIdValue.val().trim().length > 0) {
				searchHtml += " ; <b>Id : </b> " + txtCategoryIdValue.val().trim();
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
		<div class="AdminPanelContent">
			<asp:Panel ID="pnlcategoryList" runat="server">
				<div class="article_srh_btn">
					Search</div>
				<div id="divSearchCriteria">
				</div>
				<br />
				<div id="divCategorySearch" runat="server" class="article_srh_pane" style="display: none;">
					<div class="inline-form-container">
						<span class="title">Category Name</span>
						<asp:TextBox ID="txtCategoryName" runat="server"></asp:TextBox>
					    <asp:TextBox ID="txtCategoryId" runat="server"></asp:TextBox>
					    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
						    CssClass="btn"/>
					    <asp:Button ID="btnCancelSearch" runat="server" Text="Cancel" CssClass="btn"
						    OnClick="btnCancelSearch_Click" />
                    </div>
				</div>
				<br />
				<div class="add-button-container"><asp:Button ID="btnAddCategory" runat="server" OnClick="btnAddCategory_Click" Text="Add Category"
					CssClass="btn" /></div>
				<asp:GridView ID="gvCategoryList" runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
					OnRowDataBound="gvCategoryList_RowDataBound" OnRowCommand="gvCategoryList_RowCommand"
					AllowSorting="True" OnSorting="gvCategoryList_Sorting" PageSize="5" CssClass="common_data_grid table table-bordered">
					<RowStyle CssClass="DataTableRow" />
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<EmptyDataTemplate>
						No Categories found.
					</EmptyDataTemplate>
					<Columns>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:LinkButton ID="lbtnEnabled" runat="server" CommandName="ToggleEnabled" CommandArgument='<%#Eval("Id") %>' style="display:block;width:16px">
									<asp:Image ID="imgEnabledState" runat="server" Width="16" Height="16" />
								</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkLinkState" runat="server" CssClass="aDialog" Visible="false" Width="16">
									<asp:Image ID="imgLinkState" runat="server" ImageUrl="~/Images/link.png" ToolTip = "Unlink category from parent category" />
								</asp:HyperLink>
								<asp:LinkButton ID="lbtnLinkEnabled" runat="server" CommandName="ToggleLinkEnabled"
									CommandArgument='<%#Eval("Id") %>' Width="16">
									<asp:Image ID="imgLinkEnabledState" runat="server" />
								</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category&nbsp;ID" SortExpression="Id">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryId" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Name" SortExpression="Name" ItemStyle-Width="600px">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="SortOrder">
							<ItemTemplate>
								<asp:Label ID="lblSortOrder" runat="server"></asp:Label>
								<asp:HyperLink ID="lnkEditSortOrder" runat="server" Text="Edit" CssClass="aDialog grid_icon_link edit"
									ToolTip="Edit Sort Order" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Created" SortExpression="Created">
							<ItemTemplate>
								<asp:Label ID="lblCreatedDate" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Modified" SortExpression="Modified">
							<ItemTemplate>
								<asp:Label ID="lblModifiedDate" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkProducts" runat="server" Text="Products" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkAssociateVendor" runat="server" CssClass="aDialog">Vendor</asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkActionList" runat="server" CssClass="aDialog">Action&nbsp;List</asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="80px">
							<ItemTemplate>
								<asp:HyperLink ID="lnkLeadForm" runat="server" CssClass="grid_icon_link form" ToolTip="Lead Form">Lead Form</asp:HyperLink>
								<asp:HyperLink ID="lnkEdit" runat="server" Text="Edit" CssClass="grid_icon_link edit"
									ToolTip="Edit" />
								<asp:LinkButton ID="lbtnDownload" runat="server" CommandName="Download" CssClass="grid_icon_link excel"
									CommandArgument='<%#Eval("Id") %>'>
									<asp:Image ID="imgUploadDownload" ImageUrl="~/Images/FileManager/xls.gif" runat="server" /></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
					<uc1:Pager ID="PagerCategoryList" runat="server" />
				
				<asp:Label ID="lblMessage" runat="server"></asp:Label>
				<br />
				<div class="inline-form-container">
                    <asp:Button ID="btnBack" runat="server" OnClick="btnBack_Click" Text="&laquo; Back" CssClass="btn" />
				    <asp:Button ID="btnAssociate" runat="server" Text="Associate Existing Category" Visible="False"
								OnClick="btnAssociate_Click" CssClass="btn" />
				    <asp:Button ID="btnAssociateOrphaned" runat="server" OnClick="btnAssociateOrphaned_Click"
								Text="Associate Orphaned Category" Visible="False" CssClass="btn" />
                 </div>
				<input type="hidden" id="hdnDisableSubcategoryId" runat="server" value="0" />
				<input type="hidden" id="hdnCategoryBranchId" runat="server" value="0" />
				<asp:LinkButton ID="lbtnDeleteLink" runat="server" Style="display: none"></asp:LinkButton>
			</asp:Panel>
			
			<asp:Panel ID="pnlProduct" runat="server">
				<div>Your download/upload templates may include Action-Parent values, but will not be considered in product upload.</div>  
				<table>
					<tr>
						<td style="width: 90px">
							<input type="hidden" id="hdnExcelCategoryId" runat="server" />
						</td>
						<td style="width: 148px">
							&nbsp;
						</td>
					</tr>
				</table>
			<div id="tabs">
				<ul>
					<li><a href="#tabs_1" id="downloadTabLink" runat="server">Download</a></li>
					<li><a href="#tabs_2" id="uploadTabLink" runat="server">Upload</a></li>
				</ul>
				<div id="tabs_1">
					<div id="downloadTab" runat="server">
						<table>
							<tr id="DownloadExcelRow1" runat="server">
								<td colspan="2">
									Excel Type &nbsp;
									<label class="radio inline"  style="display:inline-block">
										<asp:RadioButton ID="rdbXlsx" runat="server" GroupName="ExcelType" Text="xlsx" />
									</label>
									<label class="radio inline"  style="display:inline-block">
										<asp:RadioButton ID="rdbXls" runat="server" GroupName="ExcelType" Text="xls" />
									</label>
								</td>
							</tr>
						</table>
						<h5 id = "ProductDownloadHeader" runat = "server">Product Download</h5>
						<br />
						<table id = "ProductDownload" runat="server">
							<tr id="DownloadExcelRow2" runat="server">
								<td colspan="2">
									<asp:Button ID="btnDownloadExcelReportAllProducts" runat="server" 
										OnClick="btnDownloadExcelReportAllProducts_Click" Text="Download All Products" CssClass="btn" />
									&nbsp;<asp:Button ID="btnDownloadExcelReportAllLiveProducts" runat="server" 
										OnClick="btnDownloadExcelReportAllLiveProducts_Click" Text="Download Live Products" CssClass="btn" />
									<asp:Literal ID="ltlSuccessUpload" runat="server"></asp:Literal>
								</td>
							</tr>
						</table>
						<br />
						<h5 id = "TemplateDownloadHeader" runat = "server">Template Download</h5>
						<table id = "TemplateDownload" runat="server">
							<tr id="DownloadExcelRow3" runat="server">
								<td>
									<span>Product Status</span>
									<div class="radio inline" style="display:inline-block">
										<asp:RadioButtonList ID="productStatusGroup" runat="server" RepeatDirection="Horizontal" 
												CellPadding = "13">
											<asp:ListItem Text="All" Value="2" Selected="True"></asp:ListItem>
											<asp:ListItem Text="Enabled" Value="1"></asp:ListItem>
											<asp:ListItem Text="Disabled" Value="0"></asp:ListItem>
										</asp:RadioButtonList>
									</div>
								</td>
							</tr>
							<tr id="DownloadExcelRow4" runat="server">
								<td colspan="2">
									Simplified Excel
									<label class="checkbox inline" style="display:inline-block">
										<asp:CheckBox runat="server" ID="downloadSimplified" CssClass="checkbox"/>
									</label>
								</td>
							</tr>
							<tr id="DownloadExcelRow5" runat="server">
								<td>
									<br />
									<asp:Button ID="btnDownloadExcel" runat="server" OnClick="btnDownloadExcel_Click"
										Text="Download Template" CssClass="btn" />
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="tabs_2">
					<div id="uploadTab" runat="server">
						<table>
							<tr>
								<td id="UploadExcelRow" runat="server" colspan="2">
									<asp:FileUpload ID="fuProductExcel" runat="server" />
									<asp:Button ID="btnUploadExcel" runat="server" Text="Upload" OnClick="btnUploadExcel_Click"
										CssClass="btn" />
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
				<table>
					<tr>
						<td>
							<br />
							<asp:Button ID="btnCancelProduct" runat="server" OnClick="btnCancelProduct_Click"
									Text="Cancel" CssClass="btn" />
						</td>
					</tr>
				</table>
			</asp:Panel>
		</div>
	</div>
</asp:Content>
