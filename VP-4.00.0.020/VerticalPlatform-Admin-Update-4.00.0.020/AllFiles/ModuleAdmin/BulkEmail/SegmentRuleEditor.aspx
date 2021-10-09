<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SegmentRuleEditor.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.SegmentRuleEditor" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.modal.js" type="text/javascript"></script>

	<script src="../../Js/BulkEmail/SegmentTree.js" type="text/javascript"></script>

	<script src="../../Js/BulkEmail/ConditionEditor.js" type="text/javascript"></script>

	<script src="../../Js/BulkEmail/FieldConditionEditor.js" type="text/javascript"></script>

	<script src="../../Js/BulkEmail/RegionConditionEditor.js" type="text/javascript"></script>

	<script src="../../Js/BulkEmail/MultiSelectConditionEditor.js" type="text/javascript"></script>

	<script src="../../Js/BulkEmail/SegmentRuleManager.js" type="text/javascript"></script>

	<script type="text/javascript">
	    $(document).ready(function () {
	        var element = $("#divSegmentRuleEditor");
	        var segmentId = $("input[id$='hdnSegmentId']", element).val()
	        var segmentRuleManager = new VP.BulkEmail.SegmentRuleManager(segmentId, element);

	        var top = $('.main_editor_content').offset().top - parseFloat($('.main_editor_content').css('margin-top').replace(/auto/, 0));
	        $(window).scroll(function (event) {
	            var y = $(this).scrollTop();
	            if (y >= top) {
	                $('.main_editor_content').addClass('toolBoxFixed');
	            } else {
					$('.main_editor_content').removeClass('toolBoxFixed');
	            }

	        });

	    });
	</script>

	<div class="AdminPanelHeader">
		<h3>
			<asp:Label runat="server" ID="lblPageTitle"></asp:Label></h3>
	</div>
	<div class="AdminPanelContent segment_rule_container">
		<asp:ScriptManagerProxy ID="smScript" runat="server">
			<Services>
				<asp:ServiceReference InlineScript="true" Path="~/Services/BulkEmailWebService.asmx" />
			</Services>
		</asp:ScriptManagerProxy>
		<div id="divSegmentRuleEditor" class="segment_rule_editor">
			<div class="main_editor_content clearfix">
				<div>
					<b>Add Rule</b></div>
				<ul id="ulAdd">
					<li>
						<asp:RadioButton runat="server" ID="rbtnRegion" Text="Region" GroupName="RuleType"
							CssClass="rbtnRegion" />
					</li>
					<li>
						<asp:RadioButton runat="server" ID="rbtnField" Text="Field" GroupName="RuleType"
							CssClass="rbtnField" Checked="true" />
						<div class="form">
							<asp:DropDownList ID="ddlFieldType" runat="server" CssClass="ddlFieldType" AppendDataBoundItems="true">
								<asp:ListItem Selected="True" Text="-Select Filed Type-" Value="-1"></asp:ListItem>
							</asp:DropDownList>
							<asp:RequiredFieldValidator runat="server" ID="rfvFieldType" InitialValue="-1"
								ControlToValidate="ddlFieldType"></asp:RequiredFieldValidator>
							<select id="ddlField">
								<option value="">-Select Field-</option>
							</select>
						</div>
					</li>
					<li>
						<input type="button" id="btnAddSegmentField" value="Add" class="btn" /></li>
				</ul>
			</div>
			<div id="divRuleCanves">
			</div>
			<div>
				<table>
					<tr>
						<td><input id="btnSaveSegment" class="btnSaveSegment btn" type="button" value='Save' /></td>
						<td><input id="btnPreview" class="btn" type="button" value="Preview" /></td>
						<td><asp:HyperLink ID="lnkBack" CssClass="btn" runat="server">Back</asp:HyperLink></td>
					</tr>
				</table>
			</div>
			<asp:HiddenField ID="hdnSegmentId" runat="server" />
		</div>
	</div>
	<div id="divRuleTemplates" class="jqmWindow">
		<div class="divSegmentFieldTemplate">
			<div class="segmentFieldName">
			</div>
			<div>
				<input class="addSegmentCondition btn" type="button" value="Add Condition" />
				<span class="deleteSegmentField">X</span>
				<span class="collapseSegmentField">-</span>
				<ul class="ulSegmentConditions">
				</ul>
			</div>
		</div>
		<div class="divSegmentConditionTemplate">
			<div>
				<asp:DropDownList runat="server" ID="ddlOperations" CssClass="ddlOperations">
				</asp:DropDownList>
				<span class='valueSection'></span><span class="deleteSegmentCondition">X</span>
			</div>
		</div>
		<div class="divSegmentMultiSelectTemplate" >
			<div>
				<table>
					<tr>
						<td>
							<select class="all_option_list"  style="height: 220px; width: 175px;" multiple="multiple" size="4"> </select>
						</td>
						<td>
							<table>
								<tr>
									<td>
										<a class="add_equal_option btn" style="width: 30px; margin-bottom: 2px;text-align:center;"  >></a>
										<br>
										<a class="remove_equal_option btn" style="width: 30px; margin-bottom: 2px;text-align:center;"><</a>
										<br>
										<a class="add_all_equal_option btn" style="width: 30px; margin-bottom: 2px;text-align:center;" >>></a>
										<br>
										<a class="remove_all_equal_option btn" style="width: 30px; text-align:center;" ><<</a>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<strong>Equals/True</strong>
							<select class="equal_option_list" style="height: 220px; width: 175px;" multiple="multiple" size="4"> </select>
						</td>
						<td>
							<table>
								<tr>
									<td>
										<a class="add_not_equal_option btn" style="width: 30px; margin-bottom: 2px;text-align:center;" >></a>
										<br>
										<a class="remove_not_equal_option btn"  style="width: 30px; margin-bottom: 2px;text-align:center;" ><</a>
										<br>
										<a class="add_all_not_equal_option btn" style="width: 30px; margin-bottom: 2px;text-align:center;">>></a>
										<br>
										<a class="remove_all_not_equal_option btn" style="width: 30px;text-align:center;" ><<</a>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<strong>Dosen't Equal/False</strong>
							<select class="not_equal_option_list" style="height: 220px; width: 175px;" multiple="multiple" size="4"> </select>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div id="divSegmentPreview" class="jqmWindow" style="width:auto; min-width:600px; max-width:700px;">
		<div class="dialog_container">
			<div class="dialog_header clearfix">
				<h2>
					Preview : Recipient List (<span id="spanTotoalCount"></span>)</h2>
				<div id="btnCloseSegmentPreview" class="dialog_close">
					x</div>
			</div>
			<div class="select_site_panel_outer">
				<div class="dialog_content_outer">
					<div class="dialog_content1" style="padding:10px;" >
						<ul class="common_form_area" id="ulSearch">
							<li class="common_form_row clearfix">
								<span class="label_span" style="width:auto; margin-right:10px;">Search</span>
								<span>
									<input type="text" id="txtEmailSearch" maxlength="200" />
									<input type="button" value="Apply" class="btn" id="btnApplySearch"/>
									<input type="button" value="Reset" class="btn" id="btnResetSearch"/>
								</span>
							</li>
						</ul>
						<a id="scroll"></a>
						<div id="divSegmentEmailList" style="padding: 10px; padding-bottom: 0px;">
						</div>
					</div>
				</div>
			</div>
			<div class="dialog_footer">
			</div>
		</div>
	</div>
</asp:Content>
