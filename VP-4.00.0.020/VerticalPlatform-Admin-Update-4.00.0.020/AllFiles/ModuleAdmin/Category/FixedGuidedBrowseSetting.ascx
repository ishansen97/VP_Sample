<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedGuidedBrowseSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.FixedGuidedBrowseSetting" %>
<script language="javascript" type="text/javascript">
	$(document).ready(function () {
		var tabIndex = $("[id*=hdnTabIndex]").val();
		var $tabs = $('#moduleTitleNamingRuleTab').tabs();
		$('#moduleTitleNamingRuleTab').tabs("select", tabIndex);

		$(function () {
			$("#moduleTitleNamingRuleTab").tabs({
				select: function (event, ui) {
					$("[id*=hdnTabIndex]").val(ui.index + 1);
				}
			});
		});
	});
</script>
<style type="text/css">
	.form-horizontal .control-group
	{
		margin-bottom: 5px !important;
	}
	.form-horizontal .control-label
	{
		width: 150px !important;
	}
	.form-horizontal .controls
	{
		margin-left: 170px !important;
	}
	.form-horizontal .controls.well
	{
		margin-bottom: 5px;
	}
	#moduleTitleNamingRuleTab .tab2-container span{display:block;}
	#moduleTitleNamingRuleTab .tab2-container span b:first-child{margin-top:0px;}
	#moduleTitleNamingRuleTab .tab2-container span b{display:block; margin-top:5px;}
</style>
<div class="fgb-setting" id="fixed_url_settings">
	<asp:PlaceHolder ID="guidedBrowseMetaData" runat="server"></asp:PlaceHolder>
	<div class="form-horizontal" id="fixedUrlDiv" style="border-top: solid 1px #dddddd;
		padding-top: 10px; margin-top: 10px" runat="server">
		<div class="control-group">
			<label class="control-label">
				Fixed URL</label>
			<div class="controls">
				<asp:TextBox ID="fixedUrl" runat="server" Width="250px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="fixedUrlRequiredFieldValidator" runat="server" ErrorMessage="Please enter fixed url."
					ControlToValidate="fixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="fixedUrlExpressionValidator" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-vendor-name/'."
					ControlToValidate="fixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
					Display="Static">*</asp:RegularExpressionValidator>
			</div>
		</div>
	</div>
</div>
<table class="parameters" id="parameters" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<div class="form-horizontal" style="border-top: solid 1px #dddddd; padding-top: 10px; margin-top: 10px">
				<div class="control-group">
					<label style="font-size:0.8em;">Module Title Naming Rule</label>
					<div id="moduleTitleNamingRuleTab" style="width: 600px">
						<ul>
							<li><a href="#tabs-1">Ruby Script</a></li>
							<li><a href="#tabs-2">Supported Properties</a></li>
						</ul>
						<div id="tabs-1">
							<asp:TextBox ID="moduleTitleNamingRule" Width="570" Height="140" runat="server" TextMode="MultiLine"></asp:TextBox>
						</div>
						<div id="tabs-2" class="tab2-container">
							<div>
								<span><b>Guided Browse Details</b></span>
								<span>context.GuidedBrowse.Name</span>
								<span>context.GuidedBrowse.Prefix</span>
								<span>context.GuidedBrowse.Suffix</span>
								<span><b>Category Details</b></span>
								<span>context.Category.Name</span>
								<span>context.Category.Description</span>
								<span>context.Category.ShortName</span>
								<span><b>Guided Browse Search Group Details</b></span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Name</span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Description</span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Prefix</span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Suffix</span>
								<span><b>Search Group Details</b></span>
								<span>context.GroupDetails.SearchGroup.Name</span>
								<span>context.GroupDetails.SearchGroup.Description</span>
								<span>context.GroupDetails.SearchGroup.PrefixText</span>
								<span>context.GroupDetails.SearchGroup.SuffixText</span>
								<span>context.GroupDetails.SearchOption</span>
								<span><b>Methods</b></span>
								<span>bool Exists(int groupId)</span>
								<span>GuidedBrowseSearchGroupDetail GetGroupDetail(int groupId)</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
<asp:HiddenField ID="hdnTabIndex" runat="server" />
