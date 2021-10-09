<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DirectorySettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.DirectorySettings" %>
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
		var manualCategoryOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15" };
		$("input[type=text][id*=txtManualCategory]").contentPicker(manualCategoryOptions);
		
		var tabIndex = $("[id*=hdnTabIndex]").val();
		var $tabs = $('#tabs').tabs();
		$('#tabs').tabs("select", tabIndex);
	});
	
	$(function() {
		$("#tabs").tabs({
			select: function(event, ui) {
				$("[id*=hdnTabIndex]").val(ui.index + 1);
			}
		});
	});
</script>
<div id="tabs" style="width: 600px">
	<ul>
		<li><a href="#tabs-1">Display Settings</a></li>
		<li><a href="#tabs-2">Subhomes</a></li>
		<li><a href="#tabs-3">Categories</a></li>
		<li><a href="#tabs-4">Other</a></li>
	</ul>
	<div id="tabs-1">
		<ul class="common_form_area">			
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Display Category Image
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkDisplayCategoryImage" runat="server" Visible="False" />
					<asp:HiddenField ID="hdnDisplayCategoryImage" runat="server" />
                    <asp:DropDownList ID="thumbnailSizeDropdown" runat="server"></asp:DropDownList>
                    <asp:HiddenField ID="thumbnailSizeHidden" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Display Short Name
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkDisplayShortName" runat="server" />
					<asp:HiddenField ID="hdnDisplayShortName" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Display Product Count
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkEnabledProductCount" runat="server" />
					<asp:HiddenField ID="hdnEnableProductCount" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Check for category level product display override setting
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkCategoryLevelProductDisplay" runat="server" />
					<asp:HiddenField ID="hdnCategoryLevelProductDisplay" runat="server" />
				</div>
			</li>	
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Split Child Categories in to Two Columns
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkChildTwoColumns" runat="server" />
					<asp:HiddenField ID="hdnChildTwoColumns" runat="server" />
				</div>
			</li>	
		</ul>
	</div>
	<div id="tabs-2">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Enable Subhome Filtering
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkEnableSubHome" runat="server" />
					<asp:HiddenField ID="hdnEnableSubHome" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Display Subhome Title Prefix
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkSubHomeTitlePrefix" runat="server" />
					<asp:HiddenField ID="hdnSubHomeTitlePrefix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Subhome Normal View(Not Digest View)
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkSubhomeNormalView" runat="server" />
					<asp:HiddenField ID="hdnSubhomeNormalView" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Sub Home Digest Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSubhomeDigestLength" runat="server"></asp:TextBox>
			<asp:CompareValidator ID="cpvSubhomeDigestLength" runat="server" ErrorMessage="Please enter a numeric value to 'Subhome Digest length'."
				ControlToValidate="txtSubhomeDigestLength" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
			<asp:HiddenField ID="hdnSubHomeDigestLength" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-3">
		<ul class="common_form_area">			
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Categories to Display Always
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtManualCategory" runat="server"></asp:TextBox>
			<asp:Button ID="btnAddCategory" runat="server" Text="Add" 
				CausesValidation="false" CssClass="common_text_button" 
				onclick="btnAddCategory_Click" />
			<div class="common_form_row_div clearfix">
				<asp:ListBox ID="lstCategories" runat="server" Height="70px" Width="220px"></asp:ListBox>
			</div>
			<div class="common_form_row_div clearfix">
				<asp:Button ID="btnRemoveCategory" runat="server" Text="Remove" 
					CssClass="common_text_button" onclick="btnRemoveCategory_Click" />
				<asp:HiddenField ID="hdnManualCategoryListing" runat="server" />
			</div>
				
			</li>
		</ul>
	</div>
	<div id="tabs-4">
		<ul class="common_form_area">			
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Normal View(Not Digest View)
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkNormalView" runat="server" />
					<asp:HiddenField ID="hdnNormalView" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Digest Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDigestLength" runat="server"></asp:TextBox>
					<asp:CompareValidator ID="cpvDigestLength" runat="server" ErrorMessage="Please enter a numeric value to 'Digest length'."
						ControlToValidate="txtDigestLength" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
					<asp:HiddenField ID="hdnDigestLength" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Default Title Prefix
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDefaultTitlePrefix" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnDefaultTitlePrefix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Directory Home Description
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDirectoryDescription" runat="server" Width="220px" Height="200px" TextMode="MultiLine"></asp:TextBox>
					<asp:HiddenField ID="hdnDirectoryDescription" runat="server" />
				</div>
			</li>
		</ul>
	</div>
</div>
<asp:HiddenField ID="hdnTabIndex" runat="server" />