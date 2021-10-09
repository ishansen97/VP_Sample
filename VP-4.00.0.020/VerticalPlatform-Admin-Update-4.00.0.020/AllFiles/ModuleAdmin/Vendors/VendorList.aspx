<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="VendorList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorList"
	Title="Untitled Page" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="cntVendorList" ContentPlaceHolderID="cphContent" runat="server">
    <style type="text/css">
        .main-container .main-content .radio label{padding-left:0px;}
    </style>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script type="text/javascript">
		RegisterNamespace("VP.VendorList");

		VP.VendorList.Initialize = function () {
			$(document).ready(function () {
				var vendorIdElement = { contentId: "txtSearchVendorId" };
				var vendorNameElement = { contentName: "txtSearchVendors" };
				var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true", bindings: vendorIdElement };
				$("input[type=text][id*=txtSearchVendors]").contentPicker(vendorNameOptions);

				$(".article_srh_btn").click(function () {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.VendorList.GetSearchCriteriaText());

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

		VP.VendorList.GetSearchCriteriaText = function () {
			var ddlType = $("select[id$='ddlFilterBy']");
			var ddlSalesPerson = $("select[id$='ddlSalesPerson']");
			var ddlMediaCoordinator = $("select[id$='ddlMediaCoordinator']");
			var txtTitle = $("input[id$='txtSearchVendors']");
			var txtVendorId = $("input[id$='txtSearchVendorId']");
			var searchHtml = "";
			if (ddlType.val() != "All") {
				searchHtml += " ; <b>Filtered Vendors : </b> " + $("option[selected]", ddlType).text();
			}

			if (ddlSalesPerson.val() != "-1") {
				searchHtml += " ; <b>Sales Person : </b> " + $("option[selected]", ddlSalesPerson).text();
			}

			if (ddlMediaCoordinator.val() != "-1") {
				searchHtml += " ; <b>Media Coordinator : </b> " + $("option[selected]", ddlMediaCoordinator).text();
			}

			if (txtTitle.length && txtTitle.val().trim().length > 0) {
				searchHtml += " ; <b>Search By Name : </b> " + txtTitle.val().trim();
			}

			if (txtVendorId.length && txtVendorId.val().trim().length > 0) {
				searchHtml += " ; <b>Search By Id : </b> " + txtVendorId.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}

			return searchHtml;
		};

		VP.VendorList.Initialize();
	</script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3 style="text-transform: none;">
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">List of Vendors</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<asp:Panel ID="pnlVendorList" runat="server">
				<div class="article_srh_btn hide_icon">
					Search and Filter</div>
				<div id="divSearchCriteria">
				</div>
				<br />
				<div id="divSearchPane" class="article_srh_pane" style="display: block;">
					<div class="form-horizontal">
						<strong>Search By</strong>
						<div id="divSearch">
							<div class="control-group">
								<label class="control-label">
									Vendor Name</label>
								<div class="controls">
									<asp:TextBox ID="txtSearchVendors" runat="server" CssClass="searchVendorTextBox"
										Width="180"></asp:TextBox></div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Vendor ID</label>
								<div class="controls">
									<asp:TextBox ID="txtSearchVendorId" runat="server" CssClass="searchVendorIdTextBox"
										Width="180"></asp:TextBox></div>
							</div>
							<div class="form-actions">
								<asp:Button ID="btnSearchVendors" runat="server" Text="Search" OnClick="btnSearchVendors_Click"
									CssClass="btn" ValidationGroup="VendorSearch" />
								<asp:Button ID="btnAllVendors" runat="server" Text="Reset" OnClick="btnAllVendors_Click"
									CssClass="btn" />
							</div>
						</div>
						<div id="divFilter">
							<div class="control-group">
								<label class="control-label">
									Filter</label>
								<div class="controls">
									<asp:DropDownList ID="ddlFilterBy" runat="server" CssClass="Filter" OnSelectedIndexChanged="ddlFilterBy_SelectedIndexChanged"
										AutoPostBack="true" Width="190">
									</asp:DropDownList>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Sales Person</label>
								<div class="controls">
									<asp:DropDownList ID="ddlSalesPerson" runat="server" CssClass="Filter" AutoPostBack="true"
										OnSelectedIndexChanged="ddlSalesPerson_SelectedIndexChanged" Width="190">
									</asp:DropDownList>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Media Coordinator</label>
								<div class="controls">
									<asp:DropDownList ID="ddlMediaCoordinator" runat="server" CssClass="Filter" AutoPostBack="true"
										OnSelectedIndexChanged="ddlMediaCoordinator_SelectedIndexChanged" Width="190">
									</asp:DropDownList>
								</div>
							</div>
						</div>
					</div>
				</div>
				<br />
				<div id="divBtnAddVendor" runat="server">
					<div class="add-button-container">
						<asp:Button ID="btnAddNew" runat="server" Text="Add Vendor" Width="100px" CausesValidation="false"
							OnClick="btnNewVendor_Click" CssClass="btn" />
					</div>
				</div>
				<asp:GridView ID="gvVendors" runat="server" AutoGenerateColumns="False" Width="100%"
					OnRowCommand="gvVendors_RowCommand" OnRowDataBound="gvVendors_RowDataBound" AllowSorting="True"
					OnSorting="gvVendors_Sorting" CssClass="common_data_grid table-bordered" EnableViewState="false">
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:BoundField HeaderText="Id" SortExpression="Id" DataField="Id" ItemStyle-HorizontalAlign="Right" />
						<%--<asp:BoundField HeaderText="Vendor Name" SortExpression="Name" DataField="Name" ItemStyle-Width="160px" />--%>
						<asp:TemplateField HeaderText="Vendor Name" SortExpression="Name">
							<ItemTemplate>
								<asp:Label ID="lblVendorName" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" Width="70px" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Rank" SortExpression="Rank">
							<ItemTemplate>
								<asp:Label ID="lblRank" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" Width="70px" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Parent Vendor">
							<ItemTemplate>
								<asp:Label ID="lblParentVendor" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" Width="70px" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Sales Person" SortExpression="Name">
							<ItemTemplate>
								<asp:Label ID="lblSalesPerson" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" Width="70px" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Media Coordinator" SortExpression="Name">
							<ItemTemplate>
								<asp:Label ID="lblMediaCoordinator" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" Width="70px" />
						</asp:TemplateField>
						<asp:CheckBoxField HeaderText="Enabled" SortExpression="Enabled" DataField="Enabled" />
						<asp:TemplateField ShowHeader="False">
							<ItemTemplate>
								<asp:HyperLink ID="lnkVendorLeads" runat="server">Leads</asp:HyperLink>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" />
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkVendorProducts" runat="server">Products</asp:HyperLink>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" />
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkCategory" runat="server">Category</asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkActionList" runat="server" CssClass="aDialog">Action List</asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="100">
							<ItemTemplate>
								<asp:HyperLink ID="lnkEdit" runat="server" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
                                <asp:HyperLink ID="lnkBulkUpdate" runat="server" CssClass="grid_icon_link upload" ToolTip="BulkUpdate">Bulk Update</asp:HyperLink>
                                <%--<asp:LinkButton ID="lnkBulkUpdate" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Id") %>'CommandName="Download" CssClass="grid_icon_link edit" ToolTip="BulkUpdate"></asp:LinkButton>--%>
								<asp:HyperLink ID="lnkLeadForm" runat="server" CssClass="grid_icon_link form" ToolTip="Lead Form">Lead Form</asp:HyperLink>
								<asp:HyperLink ID="lnkAnalytics" runat="server" CssClass="grid_icon_link analytics"
									ToolTip="Analytics"> Analytics</asp:HyperLink>
								<asp:LinkButton ID="lbtnUploadDownload" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Id") %>'
									CommandName="Download" CssClass="grid_icon_link excel" ToolTip="Download">
									<asp:Image ID="imgUploadDownload" ImageUrl="~/Images/FileManager/xls.gif" runat="server" /></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						No vendors found.</EmptyDataTemplate>
				</asp:GridView>
				<br />
				<uc1:Pager ID="Pager1" runat="server" />
				<br />
				<asp:Label ID="lblError" runat="server" CssClass="ValidationError"></asp:Label>
				<br />
				<asp:HiddenField ID="hdnVendorId" runat="server" />
				<br />
			</asp:Panel>
			<asp:Panel ID="pnlProduct" runat="server">
			<div>Your download/upload templates may include Action-Parent values, but will not be considered in product upload.</div>
			<table>
					<tr>
						<td style="width: 90px">
							<input type="hidden" id="hdnExcelVendorId" runat="server" />
						</td>
						<td>
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
									<label class="radio inline" style="display:inline-block">
										<asp:RadioButton ID="rdbXlsx" runat="server" GroupName="ExcelType" Text="xlsx" />
									</label>
									<label class="radio inline" style="display:inline-block">
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
									<asp:Button ID="btnDownloadExcelReportAllProducts" runat="server" OnClick="btnDownloadExcelReportAllProducts_Click"
										Text="Download All Products" CssClass="btn" />
									&nbsp;<asp:Button ID="btnDownloadExcelReportAllLiveProducts" runat="server" OnClick="btnDownloadExcelReportAllLiveProducts_Click"
										Text="Download Live Products" CssClass="btn" />
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
