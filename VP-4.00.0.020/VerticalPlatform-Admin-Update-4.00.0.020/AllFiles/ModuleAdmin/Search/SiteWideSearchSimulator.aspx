<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SiteWideSearchSimulator.aspx.cs" MasterPageFile="~/MasterPage.Master"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.SiteWideSearchSimulator" %>

<asp:Content ID="content" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script type="text/javascript">
		RegisterNamespace("VP.SearchSimulator");

		VP.SearchSimulator.Initialize = function () {
			$(document).ready(function () {
				var tabIndex = $("[id*=hdnTabIndex]").val();
				var $tabs = $('#tabs').tabs();
				$('#tabs').tabs("select", tabIndex);
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
					<li><a href="#tabs_2" id="productsTabLink" runat="server">Product Results</a></li>
					<li><a href="#tabs_3" id="categoriesTabLink" runat="server">Category Results</a></li>
					<li><a href="#tabs_4" id="articlesTabLink" runat="server">Article Results</a></li>
				</ul>
				<div id="tabs_1">
					<div id="searchTab" runat="server">
						<div class="form-horizontal search-simulator-form">
							<div class="control-group">
								<label class="control-label">Search Text</label>
								<div class="controls">
									<asp:TextBox ID="searchText" runat="server" MaxLength="255" Width="250px"></asp:TextBox>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Country</label>
								<div class="controls">
									<asp:DropDownList ID="countriesList" runat="server" Width="260px"></asp:DropDownList>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Number of Results</label>
								<div class="controls">
									<asp:TextBox ID="numberOfResults" runat="server" MaxLength="255" Width="250px" Text="30"></asp:TextBox>
									<asp:RequiredFieldValidator ID="numberOfResultsRequiredFieldValidator" runat="server" ControlToValidate="numberOfResults"
										ErrorMessage="Please enter number of results." ValidationGroup="search">*</asp:RequiredFieldValidator>
									<asp:CompareValidator ID="numberOfResultsCompareValidator" ControlToValidate="numberOfResults"
										Operator="DataTypeCheck" Type="Integer" ErrorMessage="Number of results should be a numeric value."
										runat="server" ValidationGroup="search">*</asp:CompareValidator>
									<asp:RangeValidator ID="numberOfResultsRangeValidator" ControlToValidate="numberOfResults" Type="Integer" MinimumValue="1" MaximumValue="1000"
										runat="server" ValidationGroup="search" ErrorMessage="The number of results should be between 1 and 1000.">*</asp:RangeValidator>
								</div>
							</div>
							<div class="control-group">
								<div class="controls">
									<asp:Button ID="searchButton" runat="server" CssClass="btn" Text="Search" OnClick="searchButton_Click" ValidationGroup="search" />
									<asp:Button ID="downloadButton" runat="server" CssClass="btn" Text="Download" OnClick="downloadButton_Click" ValidationGroup="search" />
									<asp:Button ID="resetButton" runat="server" CssClass="btn" Text="Reset" OnClick="resetButton_Click" />
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="tabs_2">
					<div id="productsTab" runat="server">
						<asp:GridView ID="productsList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered" OnRowDataBound="productsList_RowDataBound">
							<Columns>
								<asp:TemplateField HeaderText="Index">
									<ItemTemplate>
										<asp:Label ID="productIndexField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="ID">
									<ItemTemplate>
										<asp:Label ID="productIdField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Name">
									<ItemTemplate>
										<asp:Label ID="productNameField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Vendor">
									<ItemTemplate>
										<asp:Label ID="vendorNameField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Rank">
									<ItemTemplate>
										<asp:Label ID="productRankField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Score">
									<ItemTemplate>
										<asp:Label ID="productScoreField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
							<EmptyDataTemplate>
								No product results found.</EmptyDataTemplate>
						</asp:GridView>
					</div>
				</div>
				<div id="tabs_3">
					<div id="categoriesTab" runat="server">
						<asp:GridView ID="categoriesList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered" OnRowDataBound="categoriesList_RowDataBound">
							<Columns>
								<asp:TemplateField HeaderText="Index">
									<ItemTemplate>
										<asp:Label ID="categoryIndexField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="ID">
									<ItemTemplate>
										<asp:Label ID="categoryIdField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Name">
									<ItemTemplate>
										<asp:Label ID="categoryNameField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Top Product Score">
									<ItemTemplate>
										<asp:Label ID="topProductScoreField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
							<EmptyDataTemplate>
								No category results found.</EmptyDataTemplate>
						</asp:GridView>
					</div>
				</div>
				<div id="tabs_4">
					<div id="articlesTab" runat="server">
						<asp:GridView ID="articlesList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered" OnRowDataBound="articlesList_RowDataBound">
							<Columns>
								<asp:TemplateField HeaderText="Index">
									<ItemTemplate>
										<asp:Label ID="articleIndexField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="ID">
									<ItemTemplate>
										<asp:Label ID="articleIdField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Type">
									<ItemTemplate>
										<asp:Label ID="articleTypeField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Name">
									<ItemTemplate>
										<asp:Label ID="articleNameField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Score">
									<ItemTemplate>
										<asp:Label ID="articleScoreField" runat="server"></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
							<EmptyDataTemplate>
								No article results found.</EmptyDataTemplate>
						</asp:GridView>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>