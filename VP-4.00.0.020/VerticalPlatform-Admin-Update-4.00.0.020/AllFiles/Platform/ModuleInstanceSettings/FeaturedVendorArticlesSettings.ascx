<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeaturedVendorArticlesSettings.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.FeaturedVendorArticlesSettings" %>


<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	$(document).ready(function () {
		RegisterNamespace("VP.FeaturedVendorArticleList");
		var articleTypeFilterOptions = { siteId: VP.SiteId, type: "Article Type", currentPage: "1", pageSize: "15", showName: "true" };
		$("input[type=text][id*=articleTypeFilter]").contentPicker(articleTypeFilterOptions);
	});
</script>

<div id = "featuredVendorArticlesSettings">
	<ul class="common_form_area">
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Display Settings
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="articleListDisplaySetting" runat="server">
				</asp:DropDownList>
				<asp:Button ID="addDisplaySettings" runat="server" OnClick="addDisplaySettings_Click"
					Text="Add" CssClass="common_text_button" CausesValidation="False" />
				<div class="common_form_row_div clearfix">
					<asp:ListBox ID="articleListDisplaySettingList" runat="server" Width="247px"></asp:ListBox>
				</div>
				<div class="common_form_row_div clearfix">
					<asp:Button ID="moveUp" runat="server" OnClick="moveUp_Click" Text="Move Up"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:Button ID="moveDown" runat="server" Text="Move Down" OnClick="moveDown_Click"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:Button ID="remove" runat="server" OnClick="remove_Click" Text="Remove"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:HiddenField ID="articleDisplaySettingsHidden" runat="server" />
				</div>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Article Types
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="articleTypeFilter" runat="server" Style="width: 210px" />
				<asp:Button ID="addArticleType" runat="server" Text="Add" OnClick="addArticleType_Click"
					CausesValidation="false" CssClass="common_text_button" />
				<div class="common_form_row_div clearfix">
					<asp:ListBox ID="articleTypeList" runat="server" Width="220px" Height="54px" Style="float: left;">
					</asp:ListBox>
					&nbsp;
					<asp:Button ID="removeArticleType" Text="Remove" runat="server" OnClick="removeArticleType_Click"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:HiddenField ID="articleTypeListHidden" runat="server" />
				</div>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Thumbnail Size
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="thumbImageSizeList" runat="server">
					<asp:ListItem Text="Extra Large Image – 400 x 300" Value="1" Selected="True"></asp:ListItem>
					<asp:ListItem Text="Featured Image – 187 x 140" Value="2"></asp:ListItem>
					<asp:ListItem Text="Thumbnail Image – 134 x 100" Value="3"></asp:ListItem>
					<asp:ListItem Text="Micro Image – 52 x 39" Value="4"></asp:ListItem>
				</asp:DropDownList>
				<asp:HiddenField ID="thumbSizeHidden" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Page Size
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID = "pageSizeText" runat="server" ></asp:TextBox>
				<asp:HiddenField ID="pageSizeTextHidden" runat="server" />
				<asp:RegularExpressionValidator ID="pageSizeTextValidator" runat="server" 
					ErrorMessage="Please enter a numeric value for 'Page Size'." ControlToValidate="pageSizeText" 
					ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
				<asp:RequiredFieldValidator ID="pageSizeTextRequiredField" runat="server" ErrorMessage="Please Provide a page size." 
					ControlToValidate="pageSizeText">*</asp:RequiredFieldValidator>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Synopsis Length
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID = "synopsisLengthText" runat="server" ></asp:TextBox>
				<asp:HiddenField ID="synopsisLengthHidden" runat="server" />
				<asp:RegularExpressionValidator ID="synopsisLengthValidator" runat="server" 
					ErrorMessage="Please enter a numeric value for 'Synopsis Length'." ControlToValidate="synopsisLengthText" 
					ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
				<asp:RequiredFieldValidator ID="synopsisLengthRequiredValidator" runat="server" ErrorMessage="Please Provide a synopsis length." 
					ControlToValidate="synopsisLengthText">*</asp:RequiredFieldValidator>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Use Article Short Title
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="useShortTitle" runat="server" Checked="true" />
				<asp:HiddenField ID="useShortTitleHidden" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Hide When Empty
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="hideWhenEmpty" runat="server" Checked="true" />
				<asp:HiddenField ID="hideWhenEmptyHidden" runat="server" />
			</div>
		</li>
	</ul>
</div>