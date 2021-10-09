<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReviewListSettings.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ReviewListSettings" %>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	$(function () {
		$("#tabs").tabs({
			select: function (event, ui) {
				$("[id*=hdnTabIndex]").val(ui.index + 1);
			}
		});
	});
</script>

<div id="tabs" style="width: 450px">
	<ul>
		<li><a href="#tabs-1">Settings</a></li>
		<li><a href="#tabs-2">Dependency</a></li>
	</ul>
	<div id="tabs-1">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Review List Display Settings
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="reviewListDisplaySettingDropDownList" runat="server" Width="144px">
					</asp:DropDownList>
					<asp:Button ID="addDisplaySettings" runat="server" OnClick="AddDisplaySettings_Click"
						Text="Add" CssClass="common_text_button" CausesValidation="False" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="reviewListDisplaySettingList" runat="server" Width="247px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="moveUpDisplaySetting" runat="server" OnClick="MoveUpDisplaySetting_Click" Text="Move Up"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="moveDownDisplaySetting" runat="server" Text="Move Down" OnClick="MoveDownDisplaySetting_Click"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="removeDisplaySetting" runat="server" OnClick="RemoveDisplaySetting_Click" Text="Remove"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:HiddenField ID="reviewDisplaySettingsValueHidden" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Review Synopsis Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="reviewSynopsisLength" runat="server"></asp:TextBox>
					<asp:HiddenField ID="reviewSynopsisLengthHidden" runat="server" />
					<asp:RegularExpressionValidator ID="reviewSynopsisLengthValidator" runat="server" 
						ErrorMessage="Please enter a numeric value for 'Review Synopsis Length'." ControlToValidate="reviewSynopsisLength" 
						ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Filter By Review Type
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="reviewTypeDropDownList" runat="server" Width="144px">
					</asp:DropDownList>
					<asp:Button ID="addReviewTypeFilter" runat="server" OnClick="AddReviewTypeFilter_Click"
						Text="Add" CssClass="common_text_button" CausesValidation="False" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="reviewTypeFilterList" runat="server" Width="247px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="removeReviewTypeFilter" runat="server" OnClick="removeReviewTypeFilter_Click"
							Text="Remove" CssClass="common_text_button" CausesValidation="False" />
						<asp:HiddenField ID="reviewListFilterByReviewTypeHidden" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Review List Thumbnail Size
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="reviewThumbSizeDropDownList" runat="server"></asp:DropDownList>
					<asp:HiddenField ID="reviewThumbSizeHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Review List Page Size
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID = "reviewListPageSizeText" runat="server" ></asp:TextBox>
					<asp:HiddenField ID="reviewListPageSizeHidden" runat="server" />
					<asp:RegularExpressionValidator ID="reviewListPageSizeValidator" runat="server" 
						ErrorMessage="Please enter a numeric value for 'Review List Page Size'." ControlToValidate="reviewListPageSizeText" 
						ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
					<asp:RequiredFieldValidator ID="reviewListPageSizeRequiredField" runat="server" ErrorMessage="Please Provide a Page Size." 
						ControlToValidate="reviewListPageSizeText">*</asp:RequiredFieldValidator>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Filter by Vendor(s)
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="reviewListFilterByVendorCheck" runat ="server" />
					<asp:HiddenField ID="reviewListFilterByVendorHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Filter by Products(s)
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="reviewListFilterByProductCheck" runat ="server" />
					<asp:HiddenField ID="reviewListFilterByProductHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Maximum Number of Reviews
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="maximumNumberOfReviewsVal" runat="server"></asp:TextBox>
					<asp:HiddenField ID="maximumNumberOfReviewsValHidden" runat="server" />
					<asp:RegularExpressionValidator ID="maxNumberOfReviewsValidator" runat="server" 
						ErrorMessage="Please enter a numeric value for 'Maximum Number of Reviews'." 
						ControlToValidate="maximumNumberOfReviewsVal" ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Custom "Write a Review" Link Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="customWriteAReviewText" runat="server"></asp:TextBox>
					<asp:HiddenField ID="customWriteAReviewTextHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Custom "Be the First to Write a Review" Link Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="customBeTheFirstToWriteAReviewText" runat="server"></asp:TextBox>
					<asp:HiddenField ID="customBeTheFirstToWriteAReviewTextHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Write a Review Link Location
				</div>
				<div class="common_form_row_data">
					<asp:RadioButtonList ID="writeAReviewLinkLocation" runat="server">
						<asp:ListItem Value="0" Text="Top of Page" Selected="True"></asp:ListItem>
						<asp:ListItem Value="1" Text="Bottom of Page"></asp:ListItem>
						<asp:ListItem Value="2" Text="For Each Review"></asp:ListItem>
					</asp:RadioButtonList>
					<asp:HiddenField ID="writeAReviewLinkLocationHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Display Custom "User Reviews" Title
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="displayCustomTitle" runat ="server" Checked="true"/>
					<asp:HiddenField ID="displayCustomTitleHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Display Total Review Count in Title
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="displayTotalReviewsCheck" runat ="server" Checked="true"/>
					<asp:HiddenField ID="displayTotalReviewsHidden" runat="server" />
				</div>
			</li>
            <li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Hide Module When Empty
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="hideWhenEmptyCheck" runat ="server" Checked="false"/>
					<asp:HiddenField ID="hideWhenEmptyHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Show Reviews for Disabled Products
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="ShowReviewsDisabledProductsCheck" runat ="server" Checked="false"/>
					<asp:HiddenField ID="ShowReviewsDisabledProductsHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Article Thumbnail Image First
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="ReviewListPrioritizeThumbnailCheck" runat ="server" Checked="false"/>
					<asp:HiddenField ID="ReviewListPrioritizeThumbnailHidden" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-2">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Dependent Module
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="pageModuleList" runat="server" Width="220px" style="vertical-align:top;"></asp:DropDownList>
					<asp:HiddenField ID="hdnPageModuleList" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Dependency Type
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="providerConditionType" runat="server" Width="220px" style="vertical-align:top;"></asp:DropDownList>
					<asp:HiddenField ID="hdnProviderConditionType" runat="server" />
				</div>
			</li> 
		</ul>
	</div>
</div>
