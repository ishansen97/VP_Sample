<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RelatedCategoriesSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.RelatedCategories" %>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
	$(document).ready(function() {
		RegisterNamespace("VP.RelatedCategories");

		var categoryFilterOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", displaySites: true };
		$("input[type=text][id*=categoryText]").contentPicker(categoryFilterOptions);
	});

</script>

<div>
	<ul>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					Max Number of Categories</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="maxCategoriesHidden" runat="server" />
				<asp:TextBox ID="maximumCategories" runat="server" />
				<asp:CompareValidator ID="maxCategoriesValidator" runat="server" ErrorMessage="Invalid Number" 
					ControlToValidate="maximumCategories" ValueToCompare="0" Type="Integer" Operator="GreaterThan">*</asp:CompareValidator>
			</div>
		</li>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					Enable Randomization</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="enableRandomizationHidden" runat="server" />
				<asp:CheckBox ID="enableRandomization" runat="server" Checked="false" />
			</div>
		</li>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					Display Child Categories</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="displayChildCategoriesHidden" runat="server" />
				<asp:CheckBox ID="displayChildCategories" runat="server" Checked="false" />
			</div>
		</li>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					Max Number of Child Categories</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="maximumChildCategoriesHidden" runat="server" />
				<asp:TextBox ID="maximumChildCategories" runat="server" />
				<asp:CompareValidator ID="maximumChildCategoriesValidator" runat="server" ErrorMessage="Invalid Number" 
					ControlToValidate="maximumChildCategories" ValueToCompare="0" Type="Integer" Operator="GreaterThan">*</asp:CompareValidator>
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Manual Category Listing
				</div>
				<div class="common_form_row_data">
					<div class="ManualCategoryList">
						<asp:TextBox ID="categoryText" runat="server"></asp:TextBox>
					</div>
					<asp:Button ID="addCategory" Text="Add" runat="server" OnClick="addCategory_Click" CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix" style="clear:both">
						<asp:ListBox ID="categoryList" runat="server" Width="220px" Height="49px" Style="float: left;"></asp:ListBox>
						&nbsp;
						<asp:Button ID="removeCategory" Text="Remove" runat="server" OnClick="removeCategory_Click" CssClass="common_text_button" CausesValidation="False" />
						<asp:HiddenField ID="categoryListHidden" runat="server" />
					</div>
				</div>
			</li>

        <li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					View More Link Text</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="viewMoreLinkTextHidden" runat="server" />
				<asp:TextBox ID="viewMoreLinkText" runat="server" />				
			</div>
		</li>

        <li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					View More Link</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="viewMoreLinkHidden" runat="server" />
				<asp:TextBox ID="viewMoreLink" runat="server" />
			</div>
		</li>

        <li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					Open In New Window</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="openInNewWindowHidden" runat="server" />
				<asp:CheckBox ID="openInNewWindow" runat="server" Checked="false" />
			</div>
		</li>

	</ul>
</div>
