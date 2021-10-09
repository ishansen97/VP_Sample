<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorProductCategorySettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.VendorProductCategorySettings" %>

<div>
	<ul>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					Max Number of Categories</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="maxCategoriesHidden" runat="server" />
				<asp:TextBox ID="maximumCategories" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
					Display All Product Categories</div>
			<div class="common_form_row_data">
				<asp:HiddenField ID="displayAllRelatedCateogriesHidden" runat="server" />
				<asp:CheckBox ID="displayAllRelatedCateogries" runat="server" Checked="false" />
			</div>
		</li>
	</ul>
</div>
