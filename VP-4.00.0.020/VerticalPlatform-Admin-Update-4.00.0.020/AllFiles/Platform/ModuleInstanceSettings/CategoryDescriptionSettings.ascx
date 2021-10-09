<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategoryDescriptionSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.CategoryDetailSettings" %>

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
					Display Settings
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="categoryDescriptionDisplaySettingsDropDown" runat="server" Width="144px"/>
					<asp:Button ID="addDisplaySettings" runat="server" OnClick="AddDisplaySettings_Click" Text="Add" CssClass="common_text_button" CausesValidation="False" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="categoryDescriptionDisplaySettingList" runat="server" Width="247px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="moveUpDisplaySetting" runat="server" OnClick="MoveUpDisplaySetting_Click" Text="Move Up"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="moveDownDisplaySetting" runat="server" Text="Move Down" OnClick="MoveDownDisplaySetting_Click"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="removeDisplaySetting" runat="server" OnClick="RemoveDisplaySetting_Click" Text="Remove" CssClass="common_text_button" CausesValidation="False" />
						<asp:HiddenField ID="categoryDescriptionDisplaySettingsValueHidden" runat="server" />
					</div>
					<br />
				</div>
				<div class="common_form_row_lable">
					Description Truncate Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtLength" runat="server" Style="margin-left: 0px" Width="200px"></asp:TextBox>
					<asp:HiddenField ID="hdnLength" runat="server" />
					<asp:RegularExpressionValidator ID="revLength" runat="server" ControlToValidate="txtLength"
						ErrorMessage="Description truncate length should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
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