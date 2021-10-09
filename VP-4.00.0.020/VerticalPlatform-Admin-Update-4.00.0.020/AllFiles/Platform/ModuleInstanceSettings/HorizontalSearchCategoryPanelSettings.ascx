<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HorizontalSearchCategoryPanelSettings.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.HorizontalSearchCategoryPanelSettings" %>

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

<div id="tabs" style="width: 410px">
	<ul>
		<li><a href="#tabs-1">Settings</a></li>
		<li><a href="#tabs-2">Dependency</a></li>
	</ul>
	<div id="tabs-1">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Disable Localization for Vendor Filtering
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkDisableLocalization" runat="server"></asp:CheckBox>
					<asp:HiddenField ID="hdnDisableLocalization" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix " style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Enable Progressive Search Option Filtering
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="enableProgressive" runat="server"></asp:CheckBox>
					<asp:HiddenField ID="enableProgressiveHidden" runat="server" />
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

