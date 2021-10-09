<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumThreadListSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ForumThreadListSettings" %>
<%@ Register Src="../../Controls/PopupDialogSmartScroller.ascx" TagName="SmartScroller" TagPrefix="uc2" %>
<style type="text/css">
	*:first-child + html .ui-tabs-nav
	{
		width: auto;
		float: none;
		margin-left: -5px;
		position: static;
	}
	*:first-child + html .ui-tabs .ui-tabs-nav li
	{
		position: static;
	}
	.ui-widget input, .ui-widget select, .ui-widget textarea, .ui-widget button
	{
		font-size: 10px;
	}
</style>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	$(document).ready(function () {
		var manualForumThreadOptions = { siteId: VP.SiteId, type: "ForumThread", currentPage: "1", pageSize: "15" };
		var forumTopicOptions = { siteId: VP.SiteId, type: "ForumTopic", currentPage: "1", pageSize: "15" };

		$("input[type=text][id*=manualForumThreadListing]").contentPicker(manualForumThreadOptions);
		$("input[type=text][id*=forumTopicFilter]").contentPicker(forumTopicOptions);

		var tabIndex = $("[id*=hdnTabIndex]").val();
		$('#tabs').tabs();
		$('#tabs').tabs("select", tabIndex);
	});

	$(function () {
		$("#tabs").tabs({
			select: function (event, ui) {
				$("[id*=hdnTabIndex]").val(ui.index + 1);
			}
		});
	});
</script>

<div id="tabs" style="width: 650px">
	<ul>
		<li><a href="#tabs-1">Display Lists</a></li>
		<li><a href="#tabs-2">Settings</a></li>
		<li><a href="#tabs-3">Sorting</a></li>
	</ul>
	
	<div id="tabs-1">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Forum Thread List Display Settings
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="forumThreadDisplaySettingDropDown" runat="server" Height="20px" Width="144px"></asp:DropDownList>
					<asp:Button ID="addDisplaySettings" runat="server" OnClick="addDisplaySettings_OnClick" Text="Add" 
						CssClass="common_text_button" CausesValidation="False" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="forumThreadDisplaySettingList" runat="server" Width="247px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="displaySettingUp" runat="server" OnClick="displaySettingUp_OnClick" Text="Move Up"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="displaySettingDown" runat="server" Text="Move Down" OnClick="displaySettingDown_OnClick"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="displaySettingRemove" runat="server" OnClick="displaySettingRemove_OnClick" Text="Remove"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:HiddenField ID="displaySettingHidden" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Manual Forum Thread Listing
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="manualForumThreadListing" runat="server"></asp:TextBox>
					<asp:Button ID="addManualForumThreadListing" runat="server" Text="Add" OnClick="addManualForumThreadListing_OnClick"
						CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix" style="clear:both">
						<asp:ListBox ID="manualForumThreadList" runat="server" Height="70px" Width="220px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="manualForumThreadListingUp" runat="server" OnClick="manualForumThreadListingUp_OnClick" Text="Move Up" CssClass="common_text_button" />
						<asp:Button ID="manualForumThreadListingDown" runat="server" OnClick="manualForumThreadListingDown_OnClick" Text="Move Down"
							CssClass="common_text_button" />
						<asp:Button ID="manualForumThreadListingRemove" runat="server" OnClick="manualForumThreadListingRemove_OnClick"
							Text="Remove" CssClass="common_text_button" CausesValidation="False"/>
						<asp:HiddenField ID="manualForumThreadListingHidden" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Forum Topics
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="forumTopicFilter" runat="server" Style="width: 210px" />
					<asp:Button ID="addForumTopic" runat="server" Text="Add" OnClick="addForumTopic_OnClick"
						CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="forumTopicList" runat="server" Width="220px" Height="54px" Style="float: left;">
						</asp:ListBox>
						&nbsp;
						<asp:Button ID="removeForumTopic" Text="Remove" runat="server" OnClick="removeForumTopic_OnClick"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:HiddenField ID="forumTopicHidden" runat="server" />
					</div>
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-2">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Number of Threads Per Page
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="numberOfThreadsPerPage" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="numberOfThreadsPerPageHidden" runat="server" />
					<asp:CompareValidator ID="numberOfThreadsPerPageCompareValidator" runat="server" 
						ErrorMessage="Please enter a numeric value for 'Number of Threads Per Page'." 
						ControlToValidate="numberOfThreadsPerPage" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Max Number of Threads
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="maxNumberOfThreads" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="maxNumberOfThreadsHidden" runat="server" />
					<asp:CompareValidator ID="maxNumberOfThreadsCompareValidator" runat="server" 
						ErrorMessage="Please enter a numeric value for 'Max number of Threads'." ControlToValidate="maxNumberOfThreads" 
						Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Enable Paging
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="enablePaging" runat="server" />
					<asp:HiddenField ID="enablePagingHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Forum Thread Title Display Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="titleDisplayLength" runat="server" MaxLength="4" Width="220px" />
					<asp:HiddenField ID="titleDisplayLengthHidden" runat="server" />
					<asp:CompareValidator ID="titleDisplayLengthValidator" runat="server" ErrorMessage="Please enter a numeric value for 'Article title display length'"
						ControlToValidate="titleDisplayLength" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Hide When Empty
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="hideWhenEmpty" runat="server" />
					<asp:HiddenField ID="hideWhenEmptyHidden" runat="server" />
				</div>
			</li>

            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Open In New Window
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="openInNewWindowCheckBox" runat="server" />
					<asp:HiddenField ID="openInNewWindowHidden" runat="server" />
				</div>
			</li>

		</ul>
	</div>
	<div id="tabs-3">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Default Sorting Property
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="defaultSort" runat="server"></asp:DropDownList>
					<asp:DropDownList ID="defaultSortOrder" runat="server"  Width="200">
						<asp:ListItem Value="asc">Ascending</asp:ListItem>
						<asp:ListItem Value="desc">Descending</asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="defaultSortHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Sorting Properties
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="sortPropertiesDropDown" runat="server">
					</asp:DropDownList>
					<asp:Button ID="addSortProperties" runat="server" Text="Add" OnClick="addSortProperties_OnClick"
						CssClass="common_text_button" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="sortPropertiesList" runat="server" Width="247px" Style="float: left;">
						</asp:ListBox>
						&nbsp;
						<asp:Button ID="removeSortProperties" runat="server" Text="Remove" OnClick="removeSortProperties_OnClick"
							CssClass="common_text_button" />
						<asp:HiddenField ID="sortPropertiesHidden" runat="server" />
					</div>
				</div>
			</li>
		</ul>
	</div>
</div>
<p>&nbsp;</p>
<uc2:SmartScroller ID="SmartScroller1" runat="server" />
<asp:HiddenField ID="hdnTabIndex" runat="server" />