<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchSimulator.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.SearchSimulator" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="content" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script type="text/javascript">
		RegisterNamespace("VP.SearchSimulator");

		VP.SearchSimulator.Initialize = function () {
			$(document).ready(function () {
				var tabIndex = $("[id*=hdnTabIndex]").val();
				var $tabs = $('#tabs').tabs();
				$('#tabs').tabs("select", tabIndex);

				var searchOptionIdOptions = { siteId: VP.SiteId, type: "Search Option", currentPage: "1", pageSize: "15" };
				var categoryIdOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", categoryType: "Leaf" };
				var vendorIdOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15" };
				$("input[type=text][id*=txtSearchOptionId]").contentPicker(searchOptionIdOptions);
				$("input[type=text][id*=txtCategoryId]").contentPicker(categoryIdOptions);
				$("input[type=text][id*=txtVendorId]").contentPicker(vendorIdOptions);
			});

			$(function () {
				$("#tabs").tabs({
					select: function (event, ui) {
						$("[id*=hdnTabIndex]").val(ui.index + 1);
					}
				});
			});
		}

		VP.SearchSimulator.Initialize();
	</script>
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label runat="server" ID="lblMessage"></asp:Label></h3>
	</div>
	<div class="AdminPanelContent">
		<div id="searchTabs" runat="server">
			<div id="tabs" class="search-simulator">
				<ul>
					<li><a href="#tabs_1" id="searchTabLink" runat="server">Search</a></li>
					<li><a href="#tabs_2" id="statsTabLink" runat="server">Performance Stats</a></li>
					<li><a href="#tabs_3" id="productsTabLink" runat="server">Product Results</a></li>
					<li><a href="#tabs_4" id="featuredProductsTabLink" runat="server">Featured Product Results</a></li>
					<li><a href="#tabs_5" id="productsQueryTabLink" runat="server">Product Query</a></li>
					<li><a href="#tabs_6" id="featuredProductsQueryTabLink" runat="server">Featured Product
						Query</a></li>
				</ul>
				<div id="tabs_1">
					<div id="searchTab" runat="server">
						<div class="form-horizontal search-simulator-form">
							<div class="control-group">
								<h3>
									Category Parameters</h3>
							</div>
							<div class="control-group">
								<label class="control-label">
									Category</label>
								<div class="controls">
									<div class="input-append">
										<asp:TextBox ID="txtCategoryId" runat="server" Width="114"></asp:TextBox>
										<asp:Button ID="btnCategoryParameters" runat="server" Text="Load Parameters" CssClass="btn"
											OnClick="btnCategoryParameters_Click" ValidationGroup="load" />
									</div>
									<asp:RequiredFieldValidator ID="rfvTxtCategoryIdForLoad" runat="server" ControlToValidate="txtCategoryId"
										ErrorMessage="Please select a category." ValidationGroup="load">*</asp:RequiredFieldValidator>
									<asp:RequiredFieldValidator ID="rfvTxtCategoryIdForSearch" runat="server" ControlToValidate="txtCategoryId"
										ErrorMessage="Please select a category." ValidationGroup="search">*</asp:RequiredFieldValidator>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Completeness Multiplier %</label>
								<div class="controls">
									<asp:TextBox ID="txtCompletenessMultiplier" runat="server" MaxLength="3" Width="250px"
										Text="100"></asp:TextBox>
									<asp:RequiredFieldValidator ID="rfvTxtCompletenessMultiplier" runat="server" ControlToValidate="txtCompletenessMultiplier"
										ErrorMessage="Please enter completeness multiplier." ValidationGroup="search">*</asp:RequiredFieldValidator>
									<asp:RangeValidator ID="rvCompletenessMultiplier" ControlToValidate="txtCompletenessMultiplier"
										Type="Integer" MinimumValue="0" MaximumValue="100" runat="server" ErrorMessage="Completeness multiplier should be between 0 and 100."
										ValidationGroup="search">*</asp:RangeValidator>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Business Value Multiplier %</label>
								<div class="controls">
									<asp:TextBox ID="txtBusinessValueMultiplier" runat="server" MaxLength="3" Width="250px"
										Text="100"></asp:TextBox>
									<asp:RequiredFieldValidator ID="rfvBusinessValueMultiplier" runat="server" ControlToValidate="txtBusinessValueMultiplier"
										ErrorMessage="Please enter business value multiplier." ValidationGroup="search">*</asp:RequiredFieldValidator>
									<asp:RangeValidator ID="rnvBusinessValueMultiplier" ControlToValidate="txtBusinessValueMultiplier"
										Type="Integer" MinimumValue="0" MaximumValue="100" runat="server" ErrorMessage="Business value multiplier should be between 0 and 100."
										ValidationGroup="search">*</asp:RangeValidator>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Featured Item Threshold %</label>
								<div class="controls">
									<asp:TextBox ID="txtFeaturedThreshold" runat="server" MaxLength="3" Width="250px"
										Text="50"></asp:TextBox>
									<asp:RequiredFieldValidator ID="rfvFeaturedThreshold" runat="server" ControlToValidate="txtFeaturedThreshold"
										ErrorMessage="Please enter featured item relevancy threshold." ValidationGroup="search">*</asp:RequiredFieldValidator>
									<asp:RangeValidator ID="rnvFeaturedThreshold" ControlToValidate="txtFeaturedThreshold"
										Type="Integer" MinimumValue="1" MaximumValue="100" runat="server" ErrorMessage="Featured item relevancy threshold should be between 1 and 100."
										ValidationGroup="search">*</asp:RangeValidator>
								</div>
							</div>
							<div class="control-group">
								<h3>
									Search Parameters</h3>
							</div>
							<div class="control-group">
								<label class="control-label">
									Search Text</label>
								<div class="controls">
									<asp:TextBox ID="txtSearchText" runat="server" MaxLength="255" Width="250px"></asp:TextBox>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Search Aspect</label>
								<div class="controls">
									<asp:DropDownList ID="ddlSearchAspect" runat="server" Width="159px">
									</asp:DropDownList>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Country</label>
								<div class="controls">
									<asp:DropDownList ID="ddlCountry" runat="server" Width="260px">
									</asp:DropDownList>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Search Options</label>
								<div class="controls">
									<div class="input-append">
										<asp:TextBox ID="txtSearchOptionId" runat="server" MaxLength="255" Width="114"></asp:TextBox>
										<asp:Button ID="btnAddOption" runat="server" Text="Add" CssClass="btn" OnClick="btnAddOption_Click" />
										<asp:Button ID="btnRemoveOption" runat="server" Text="Remove" CssClass="btn" OnClick="btnRemoveOption_Click" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<div class="controls">
									<asp:ListBox ID="lbOptions" runat="server" Width="260px" SelectionMode="Single">
									</asp:ListBox>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">
									Enable Vendor Compression</label>
								<div class="controls">
									<asp:CheckBox ID="enableVendorCompressionCheckBox" runat="server" OnCheckedChanged="enableVendorCompressionCheckBox_CheckedChanged"
										AutoPostBack="true" />
								</div>
							</div>
							<div id="vendorCompressionParameters" runat="server">
								<div class="control-group">
									<label class="control-label">
										Number of Pages</label>
									<div class="controls">
										<asp:TextBox ID="numberOfVendorPages" runat="server" MaxLength="2" Width="250px"
											Text="5"></asp:TextBox>
										<asp:RequiredFieldValidator ID="numberOfVendorPagesRequiredFieldValidator" runat="server"
											ControlToValidate="numberOfVendorPages" ErrorMessage="Please enter number of pages."
											ValidationGroup="search">*</asp:RequiredFieldValidator>
										<asp:RangeValidator ID="numberOfVendorPagesRangeValidator" ControlToValidate="numberOfVendorPages"
											Type="Integer" MinimumValue="1" MaximumValue="99" runat="server" ErrorMessage="Number of pages should be between 1 and 99."
											ValidationGroup="search">*</asp:RangeValidator>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">
										Vendors per Page</label>
									<div class="controls">
										<asp:TextBox ID="vendorsPerPageTextBox" runat="server" MaxLength="3" Width="250px"
											Text="30"></asp:TextBox>
										<asp:RequiredFieldValidator ID="vendorsPerPageTextBoxRequiredFieldValidator" runat="server"
											ControlToValidate="vendorsPerPageTextBox" ErrorMessage="Please enter vendors per page."
											ValidationGroup="search">*</asp:RequiredFieldValidator>
										<asp:RangeValidator ID="vendorsPerPageTextBoxRangeValidator" ControlToValidate="vendorsPerPageTextBox"
											Type="Integer" MinimumValue="1" MaximumValue="999" runat="server" ErrorMessage="Vendors per page should be between 1 and 999."
											ValidationGroup="search">*</asp:RangeValidator>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">
										Products per Vendor</label>
									<div class="controls">
										<asp:TextBox ID="productsPerVendorTextBox" runat="server" MaxLength="2" Width="250px"
											Text="5"></asp:TextBox>
										<asp:RequiredFieldValidator ID="productsPerVendorTextBoxRequiredFieldValidator" runat="server"
											ControlToValidate="productsPerVendorTextBox" ErrorMessage="Please enter products per vendor."
											ValidationGroup="search">*</asp:RequiredFieldValidator>
										<asp:RangeValidator ID="productsPerVendorTextBoxRangeValidator" ControlToValidate="productsPerVendorTextBox"
											Type="Integer" MinimumValue="1" MaximumValue="99" runat="server" ErrorMessage="Products per vendor should be between 1 and 99."
											ValidationGroup="search">*</asp:RangeValidator>
									</div>
								</div>
							</div>
							<div id="nonVendorCompressionParameters" runat="server">
								<div class="control-group">
									<label class="control-label">
										Number of Pages</label>
									<div class="controls">
										<asp:TextBox ID="txtNumberOfPages" runat="server" MaxLength="255" Width="250px" Text="5"></asp:TextBox>
										<asp:RequiredFieldValidator ID="rfvTxtNumberOfPages" runat="server" ControlToValidate="txtNumberOfPages"
											ErrorMessage="Please enter number of pages." ValidationGroup="search">*</asp:RequiredFieldValidator>
										<asp:CompareValidator ID="cmpvNumberOfPages" ControlToValidate="txtNumberOfPages"
											Operator="DataTypeCheck" Type="Integer" ErrorMessage="Number of pages should be a numeric value."
											runat="server" ValidationGroup="search">*</asp:CompareValidator>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">
										Results Per Page</label>
									<div class="controls">
										<asp:TextBox ID="txtResultsPerPage" runat="server" MaxLength="255" Width="250px"
											Text="30"></asp:TextBox>
										<asp:RequiredFieldValidator ID="rfvTxtResultsPerPage" runat="server" ControlToValidate="txtResultsPerPage"
											ErrorMessage="Please enter number of results per page." ValidationGroup="search">*</asp:RequiredFieldValidator>
										<asp:CompareValidator ID="cmvTxtResultsPerPage" ControlToValidate="txtResultsPerPage"
											Operator="DataTypeCheck" Type="Integer" ErrorMessage="Number of results per page should be a numeric value."
											runat="server" ValidationGroup="search">*</asp:CompareValidator>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">
										Vendors</label>
									<div class="controls">
										<div class="input-append">
											<asp:TextBox ID="txtVendorId" runat="server" MaxLength="255" Width="114"></asp:TextBox>
											<asp:Button ID="btnAddVendor" runat="server" Text="Add" CssClass="btn" OnClick="btnAddVendor_Click" />
											<asp:Button ID="btnRemoveVendor" runat="server" Text="Remove" CssClass="btn" OnClick="btnRemoveVendor_Click" />
										</div>
									</div>
								</div>
								<div class="control-group">
									<div class="controls">
										<asp:ListBox ID="lbVendors" runat="server" Width="260px" SelectionMode="Single">
										</asp:ListBox>
									</div>
								</div>
							</div>
							<div class="control-group">
								<div class="controls">
									<asp:Button ID="btnCategorySearch" runat="server" CssClass="btn" Text="Search" OnClick="btnCategorySearch_Click"
										ValidationGroup="search" />
									<asp:Button ID="downloadButton" runat="server" CssClass="btn" Text="Download" OnClick="downloadButton_Click"
										ValidationGroup="search" />
									<asp:Button ID="btnResetDetails" runat="server" CssClass="btn" Text="Reset" OnClick="btnResetDetails_Click" />
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="tabs_2">
					<div id="statsTab" runat="server">
						<h4>
							Performance Statistics in milliseconds</h4>
						<table class="common_data_grid table table-bordered" cellpadding="0" cellspacing="0"
							style="width: 600px;">
							<tr>
								<td style="width: 450px">
									Time to search for products in Elastic Search
								</td>
								<td>
									<asp:Label ID="lblAllElastic" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Time taken to transfer product results through network
								</td>
								<td>
									<asp:Label ID="lblAllRetrieval" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Time to decode retrieved product results
								</td>
								<td>
									<asp:Label ID="lblAllDecode" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Time to search for featured products in Elastic Search
								</td>
								<td>
									<asp:Label ID="lblFeaturedElastic" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Time taken to transfer featured product results through network
								</td>
								<td>
									<asp:Label ID="lblFeaturedRetrieval" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Time to decode retrieved featured product results
								</td>
								<td>
									<asp:Label ID="lblFeaturedDecode" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Total time taken for searching
								</td>
								<td>
									<asp:Label ID="lblStatsTotal" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
						<br />
					</div>
				</div>
				<div id="tabs_3">
					<div id="productsTab" runat="server">
						<h4>
							Product Results</h4>
						<table class="common_data_grid  table table-bordered" cellpadding="0" cellspacing="0">
							<tr>
								<td style="width: 200px">
									ES score calculation
								</td>
								<td>
									<asp:Label ID="lblAllESScoreCalculation" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
						<br />
						<asp:GridView ID="gvAllResultsList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
							OnRowDataBound="gvAllResultsList_RowDataBound">
							<Columns>
								<asp:TemplateField HeaderText="Page">
									<ItemTemplate>
										<asp:Label ID="ltlAllPage" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Index">
									<ItemTemplate>
										<asp:Label ID="ltlAllIndex" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="ID">
									<ItemTemplate>
										<asp:Label ID="ltlAllId" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Name">
									<ItemTemplate>
										<asp:Label ID="ltlAllName" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Catalog Number">
									<ItemTemplate>
										<asp:Label ID="ltlAllCatalog" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Completeness">
									<ItemTemplate>
										<asp:Label ID="ltlAllCompleteness" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Business Value">
									<ItemTemplate>
										<asp:Label ID="ltlAllBusinessValue" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Rank">
									<ItemTemplate>
										<asp:Label ID="ltlAllRank" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Rank Weight">
									<ItemTemplate>
										<asp:Label ID="ltlAllRankWeight" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Search Rank">
									<ItemTemplate>
										<asp:Label ID="ltlAllSearchRank" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Vendors">
									<ItemTemplate>
										<asp:Label ID="ltlAllVendors" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Natural ES Score">
									<ItemTemplate>
										<asp:Label ID="ltlAllNaturalScore" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Final Score">
									<ItemTemplate>
										<asp:Label ID="ltlAllScore" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
							<EmptyDataTemplate>
								No product results found.</EmptyDataTemplate>
						</asp:GridView>
					</div>
				</div>
				<div id="tabs_4">
					<div id="featuredProductsTab" runat="server">
						<h4>
							Featured Product Results</h4>
						<table class="common_data_grid  table table-bordered" cellpadding="0" cellspacing="0">
							<tr>
								<td style="width: 200px">
									ES score calculation
								</td>
								<td>
									<asp:Label ID="lblFeaturedESScoreCalculation" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Score of top most product
								</td>
								<td>
									<asp:Label ID="lblFeaturedNonFeaturedScore" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Percentage relevancy calculation
								</td>
								<td>
									<asp:Label ID="lblFeaturedPercentageRelevancyCalculation" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
						<br />
						<asp:GridView ID="gvFeaturedResultsList" runat="server" AutoGenerateColumns="False"
							CssClass="common_data_grid table table-bordered" OnRowDataBound="gvFeaturedResultsList_RowDataBound">
							<Columns>
								<asp:TemplateField HeaderText="Page">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedPage" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Index">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedIndex" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="ID">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedId" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Name">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedName" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Catalog Number">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedCatalog" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Completeness">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedCompleteness" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Business Value">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedBusinessValue" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Rank Weight">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedRankWeight" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Search Rank">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedSearchRank" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Vendors">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedVendors" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Natural ES Score">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedNaturalScore" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Final Score">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedScore" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Percentage Relevancy">
									<ItemTemplate>
										<asp:Label ID="ltlFeaturedPercentage" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
							<EmptyDataTemplate>
								No featured product results found.</EmptyDataTemplate>
						</asp:GridView>
					</div>
				</div>
				<div id="tabs_5">
					<div id="productsQueryTab" runat="server">
						<h4>
							Products Search Query</h4>
						<asp:TextBox ID="txtAllProductsQuery" runat="server" TextMode="MultiLine" Rows="30"
							Width="800px"></asp:TextBox>
					</div>
				</div>
				<div id="tabs_6">
					<div id="featuredProductsQueryTab" runat="server">
						<h4>
							Featured Products Search Query</h4>
						<asp:TextBox ID="txtFeaturedProductsQuery" runat="server" TextMode="MultiLine" Rows="30"
							Width="800px"></asp:TextBox>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
