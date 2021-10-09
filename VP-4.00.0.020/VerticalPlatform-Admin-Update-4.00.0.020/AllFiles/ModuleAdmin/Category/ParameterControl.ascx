<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ParameterControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.ParameterControl" %>
<style type="text/css">
	.controls input[type=radio]
	{
		margin-top: 0px;
	}
</style>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script type="text/javascript">
	RegisterNamespace("VP.CategoryParameter");

	VP.CategoryParameter.InitSearchOptions = function () {
		$(document).ready(function () {
			var searchOptionNameElement = { contentName: "defaultSearchOptionSelector" };
			var searchOptionNameOptions = { siteId: VP.SiteId, type: "Search Option", currentPage: "1", pageSize: "15",
				displaySearchGroups: true
			};

			$("input[type=text][id*=defaultSearchOptionSelector]").contentPicker(searchOptionNameOptions);

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
	};

	VP.CategoryParameter.ShowHideDefaultParameters = function () {
		if ($("input[type=checkbox][id*=defaultShowProductsInInitialView]").attr('checked')) {
			$('.defaultParamtersHolder').hide();
		}
		else {
			$('.defaultParamtersHolder').show();
		}
	};

	$(document).ready(function () {
		$("input[type=checkbox][id*=defaultShowProductsInInitialView]").click(function () {
			VP.CategoryParameter.ShowHideDefaultParameters();
		});

		VP.CategoryParameter.InitSearchOptions();
		VP.CategoryParameter.ShowHideDefaultParameters();
	});
</script>

<table id="tableShowSearchPanel" runat="server" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<div class="form-horizontal">
				<div class="control-group">
					<h3>
						Search Category Parameters</h3>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Search Panel of</label>
					<div class="controls">
						<asp:DropDownList runat="server" ID="ddlSearchPanelCategory">
						</asp:DropDownList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Search Panel Title as Category Page Title</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblOverrideCategoryPageTitle" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
<div id="fixedGuidedBrowses" runat="server">
	<h3>Fixed Guided Browse</h3>
	<div class="menu_tab_contents">
		<div class="add-button-container">
			<asp:HyperLink runat="server" ID="addFixedGuidedBrowse" Text="Add Fixed Guided Browse" CssClass="aDialog btn"/>
		</div>
		<asp:GridView ID="fixedGuidedBrowseList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
			OnRowCommand="fixedGuidedBrowseList_RowCommand" OnRowDataBound="fixedGuidedBrowseList_RowDataBound">
			<Columns>
				<asp:TemplateField HeaderText="Category">
					<ItemTemplate>
						<asp:Label ID="category" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:BoundField HeaderText="Fixed Guided Browse" DataField="Name" />
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="editButton" runat="server" Text="Edit" CssClass="aDialog grid_icon_link edit"
							ToolTip="Edit"></asp:HyperLink>
						<asp:LinkButton OnClientClick="return confirm('Are you sure you want to remove this fixed guided browse?');"
							ID="removeButton" runat="server" Text="Remove" CommandName="RemoveFixedGuidedBrowseSetting" 
							CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No fixed guided browse settings were found.</EmptyDataTemplate>
		</asp:GridView>
		<asp:Button ID="applyChanges" runat="server" Text="Apply Changes" Width="123px" CssClass="btn" OnClick="applyChanges_Click" />
	</div>
</div>
<table id="tableLeafParameters" runat="server" visible="false">
	<tr>
		<td>
			<div class="form-horizontal">
				<div class="control-group">
					<h3>
						Category Parameters</h3>
				</div>
				<div class="control-group">
					<label class="control-label">
						Specification Length</label>
					<div class="controls">
						<asp:RadioButton ID="rdbInheritSpecLength" runat="server" GroupName="SpecLength"
							Text="Inherit" Checked="true" />
						<asp:RadioButton ID="rdbSpecifySpecLength" runat="server" GroupName="SpecLength"
							Text="Specify" />
						<asp:TextBox ID="txtSpecLength" runat="server"></asp:TextBox>
						<asp:CompareValidator ID="cvSpecLength" ControlToValidate="txtSpecLength" Operator="DataTypeCheck"
							Type="Integer" ErrorMessage="Specification length should be numeric value." runat="server">*</asp:CompareValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Primary Lead Form Button Text</label>
					<div class="controls">
						<asp:RadioButton ID="rdbInheritButtonText" runat="server" GroupName="ButtonText"
							Text="Inherit" Checked="true" />
						<asp:RadioButton ID="rdbSpecifyButtonText" runat="server" GroupName="ButtonText"
							Text="Specify" />
						<asp:TextBox ID="txtButtonText" runat="server"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Request Information for All Products Button Text</label>
					<div class="controls">
						<asp:RadioButton ID="rdbInheritAllButtonText" runat="server" GroupName="AllButtonText"
							Text="Inherit" Checked="true" />
						<asp:RadioButton ID="rdbSpecifyAllButtonText" runat="server" GroupName="AllButtonText"
							Text="Specify" />
						<asp:TextBox ID="txtAllButtonText" runat="server"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Request Information for Selected Products Button Text</label>
					<div class="controls">
						<asp:RadioButton ID="rdbInheritSelectedInfo" runat="server" GroupName="SelectedInfoText"
							Text="Inherit" Checked="true" />
						<asp:RadioButton ID="rdbSpecifySelectedInfo" runat="server" GroupName="SelectedInfoText"
							Text="Specify" />
						<asp:TextBox ID="txtSelectedInfoText" runat="server"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						No of Rows per Matrix Page</label>
					<div class="controls">
						<asp:TextBox ID="txtNoOfRows" runat="server"></asp:TextBox>
						<asp:CompareValidator ID="cvNoOfRows" ControlToValidate="txtNoOfRows" Operator="DataTypeCheck"
							Type="Integer" ErrorMessage="No of Rows per Matrix Page should be numeric value"
							runat="server">*</asp:CompareValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Link to Vendor Profile Page</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblVendorProfileLink" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Request Information Link</label>
					<div class="controls">
						<asp:RadioButtonList ID="rbdlShowRequestInformationLink" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Secondary Action In Spec List</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowSecondaryAction" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Direct Click Through</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblDirectClickTrough" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Display Images in Related Product Module</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblDisplayRelatedProductImages" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Include Catalog Number In Product SEO Tags<br/>(Title, Description, H1)</label>
					<div class="controls">
						<asp:CheckBoxList ID = "includeCatalogNumberSettings" runat = "server" CssClass = "includeCatalogNumberSettings">
						</asp:CheckBoxList>
					</div>
				</div> 
				<div class="control-group">
					<label class="control-label">
						Include Quantity In Product SEO Tags<br/>(Title, Description, H1)</label>
					<div class="controls">
						<asp:CheckBoxList ID = "includeQuantitySettings" runat = "server" CssClass = "includeQuantitySettings">
						</asp:CheckBoxList>
					</div>
				</div>
				<div class="control-group">
					<h3>
						Matrix Element Display Status</h3>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Image in Compare Page</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowImageInComparePage" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Manufacturer</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowManufacturer" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Distributor</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowDistributor" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Specifications</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowSpecification" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Item Price</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowItemPrice" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Link to Item Detail</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowLinkToItemDetail" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Link to Content Association</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowLinkToContentAssociation" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Link to Vendor Product Page</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowLinkToVendorProductPage" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Request Info for All Button</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowRequestInfoForAllButton" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Request Info for All Button in Compare Page</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowHorizontalRequestInfoForAllButton" runat="server"
							RepeatDirection="Horizontal" CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Vertical Matrix Images</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowVerticalMatrixImages" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Vendor Address If No Specs Selected</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblShowVendorAddress" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True" Selected="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Column Based Matrix</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblColumnBasedMatrix" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Category Level Leads</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblCategoryLevelLeads" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Display Non Related Products in Search Results</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblDisplayMissingProducts" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True" Selected="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Number of Featured Items</label>
					<div class="controls">
						<asp:TextBox ID="txtFeaturedItemCount" runat="server"></asp:TextBox>
						<asp:CompareValidator ID="cmpvFeaturedCount" ControlToValidate="txtFeaturedItemCount"
							Operator="DataTypeCheck" Type="Integer" ErrorMessage="Featured Item count should be a numeric value."
							runat="server">*</asp:CompareValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Featured Item Relevancy Threshold</label>
					<div class="controls">
						<asp:TextBox ID="txtFeaturedRelavancyPercentage" runat="server"></asp:TextBox>%
						<asp:CompareValidator ID="cmpvFeaturedRelavancy" ControlToValidate="txtFeaturedRelavancyPercentage"
							Operator="DataTypeCheck" Type="Integer" ErrorMessage="Featured item relavancy threshold should be a numeric value."
							runat="server">*</asp:CompareValidator>
						<asp:RangeValidator ID="rnvFeaturedRelavancy" ControlToValidate="txtFeaturedRelavancyPercentage"
							Type="Integer" MinimumValue="1" MaximumValue="100" runat="server" ErrorMessage="Featured item relavancy threshold value should be between 1 and 100.">*</asp:RangeValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Completeness Multiplier for Search Results</label>
					<div class="controls">
						<asp:TextBox ID="txtCompletenessMultiplier" runat="server"></asp:TextBox>%
						<asp:CompareValidator ID="cmpvCompletenessMultiplier" ControlToValidate="txtCompletenessMultiplier"
							Operator="DataTypeCheck" Type="Integer" ErrorMessage="Completeness multiplier should be a numeric value."
							runat="server">*</asp:CompareValidator>
						<asp:RangeValidator ID="rnvCompletenessMultiplier" ControlToValidate="txtCompletenessMultiplier"
							Type="Integer" MinimumValue="0" MaximumValue="100" runat="server" ErrorMessage="Completeness multiplier should be between 0 and 100.">*</asp:RangeValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Business Value Multiplier for Search Results</label>
					<div class="controls">
						<asp:TextBox ID="txtBusinessValueMultiplier" runat="server"></asp:TextBox>%
						<asp:CompareValidator ID="cmpvBusinessValueMultiplier" ControlToValidate="txtBusinessValueMultiplier"
							Operator="DataTypeCheck" Type="Integer" ErrorMessage="Business value multiplier should be a numeric value."
							runat="server">*</asp:CompareValidator>
						<asp:RangeValidator ID="rnvBusinessValueMultiplier" ControlToValidate="txtBusinessValueMultiplier"
							Type="Integer" MinimumValue="0" MaximumValue="100" runat="server" ErrorMessage="Business value multiplier should be between 0 and 100.">*</asp:RangeValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Display Ratings</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblDisplayRatings" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Show Citations Count for Products</label>
					<div class="controls">
						<asp:RadioButtonList ID="showCitationsOptions" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<h3>
						Vendor Compression Settings</h3>
				</div>
				<div class="control-group">
					<label class="control-label">
						Enable Vendor Compression</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblEnableVendorCompression" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Vendors per Page</label>
					<div class="controls">
						<asp:TextBox ID="txtVendorsPerPage" runat="server"></asp:TextBox>
						<asp:CompareValidator ID="cmvVendorsPerPage" ControlToValidate="txtVendorsPerPage"
							Operator="DataTypeCheck" Type="Integer" ErrorMessage="Vendors per page should be a numeric value."
							runat="server">*</asp:CompareValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Initial Number of Products to be Shown Before Expanding</label>
					<div class="controls">
						<asp:TextBox ID="txtVendorCompressionInitialCount" runat="server"></asp:TextBox>
						<asp:CompareValidator ID="cmvVendorCompressionInitialCount" ControlToValidate="txtVendorCompressionInitialCount"
							Operator="DataTypeCheck" Type="Integer" ErrorMessage="Initial number of products should be a numeric value."
							runat="server">*</asp:CompareValidator>
						<asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtVendorCompressionInitialCount"
							Type="Integer" MinimumValue="1" MaximumValue="50" runat="server" ErrorMessage="Initial number of products value should be between 1 and 50.">*</asp:RangeValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Number of Products to be Shown When Expanded</label>
					<div class="controls">
						<asp:TextBox ID="txtVendorCompressionExpandCount" runat="server"></asp:TextBox>
						<asp:CompareValidator ID="cmvVendorCompressionExpandCount" ControlToValidate="txtVendorCompressionExpandCount"
							Operator="DataTypeCheck" Type="Integer" ErrorMessage="Total number of products should be a numeric value."
							runat="server">*</asp:CompareValidator>
						<asp:RangeValidator ID="rnvVendorCompressionExpandCount" ControlToValidate="txtVendorCompressionExpandCount"
							Type="Integer" MinimumValue="1" MaximumValue="50" runat="server" ErrorMessage="Total number of products value should be between 1 and 50.">*</asp:RangeValidator>
					</div>
				</div>
                <div class="control-group">
					<h3>
						Image Gallery Settings</h3>
				</div>
                <div class="control-group">
					<label class="control-label">
						Add Single Image Class</label>
					<div class="controls">
						<asp:RadioButtonList ID="addSingleImageClassRadio" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
<table id="tableGuidedBrowseParameters" runat="server" visible="false" cellpadding="0"
	cellspacing="0">
	<tr>
		<td>
			<div class="form-horizontal">
				<div class="control-group">
					<h3>Search Category Parameters</h3>
				</div>
				<div class="control-group">
					<label class="control-label">
						Show Search Text</label>
					<div class="controls">
						<asp:RadioButtonList ID="showSearchText" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Search Category Naming Rule</label>
					<div class="controls">
						<asp:TextBox runat="server" Width="250" ID="txtSearchCategoryNamingRule"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Search Panel Default Title</label>
					<div class="controls">
						<asp:TextBox runat="server" Width="250" ID="txtSearchPanelTitle"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Set Search Panel Title as Page Title</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblOverridePageTitle" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True" Selected="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Display Vendor Filter in Search Panel</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblDisplayVendorFilter" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True" Selected="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Enable Filter in Vendor Filter in Search Panel</label>
					<div class="controls">
						<asp:RadioButtonList ID="VendorFilterFiltering" runat="server" RepeatDirection="Horizontal"
							CellPadding="0" CellSpacing="0" CssClass="radio_table">
							<asp:ListItem Text="Yes" Value="True"></asp:ListItem>
							<asp:ListItem Text="No" Value="False" Selected="True"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Category Description Singular</label>
					<div class="controls">
						<asp:TextBox runat="server" Width="250" ID="txtCategoryDescriptionSingular"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						Category Description Plural</label>
					<div class="controls">
						<asp:TextBox runat="server" Width="250" ID="txtCategoryDescriptionPlural"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<h3>Default Search Parameters</h3>
				</div>
				<div class="control-group">
					<label class="control-label">Show Products in Initial View</label>
					<div class="controls">
						<asp:CheckBox ID="defaultShowProductsInInitialView" runat="server" />
					</div>
				</div>
				<div class="defaultParamtersHolder">
					<div class="control-group">
						<label class="control-label">Search Text</label>
						<div class="controls">
							<asp:TextBox Id="defaultSearchText" runat="server" Width="250"></asp:TextBox>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Search Aspect</label>
						<div class="controls">
							<asp:DropDownList ID="defaultSearchAspect" runat="server" Width="265"></asp:DropDownList>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Search Options</label>
						<div class="controls">
							<asp:TextBox ID="defaultSearchOptionSelector" runat="server" Width="107"></asp:TextBox>
							<asp:Button ID="addSearchOption" runat="server" OnClick="addSearchOption_click" CssClass="btn" Text="Add" style="margin-top:-5px"/>
							<asp:Button ID="removeSearchOption" runat="server" OnClick="removeSearchOption_click" CssClass="btn" Text="Remove" style="margin-top:-5px" />
						</div>
						<div class="controls">
							<asp:ListBox ID="defaultSearchOptions" runat="server"  Width="265"></asp:ListBox>
						</div>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
<table id="tableCommonCategoryParameters">
	<tr>
		<td>
			<div class="form-horizontal">
				<div class="control-group">
					<h3>Common Category Parameters</h3>
				</div>
				<div class="control-group">
					<label class="control-label">Quick Links HTML</label>
					<div class="controls">
					<asp:HyperLink ID="quickLinksButton" runat="server" Text="Edit Quick Links HTML" CssClass="aDialog btn" style="font-family:'Helvetica Neue', Helvetica, Arial, sans-serif" />
					</div>  
				</div> 
			</div>
		</td>
	</tr>
</table>
