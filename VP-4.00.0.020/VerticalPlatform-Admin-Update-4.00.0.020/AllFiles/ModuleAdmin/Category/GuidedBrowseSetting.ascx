<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GuidedBrowseSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.GuidedBrowseSetting" %>

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
	#moduleTitleNamingRuleTab{width:600px;}
	#moduleTitleNamingRuleTab .tab2-container span{display:block;}
	#moduleTitleNamingRuleTab .tab2-container span b:first-child{margin-top:0px;}
	#moduleTitleNamingRuleTab .tab2-container span b{display:block; margin-top:5px;}
</style>

<table class="parameters" id="parameters" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<div class="form-horizontal">
				<div class="control-group">
					<label style="font-size:0.8em;">Module Title Naming Rule</label>
					<div id="moduleTitleNamingRuleTab">
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
