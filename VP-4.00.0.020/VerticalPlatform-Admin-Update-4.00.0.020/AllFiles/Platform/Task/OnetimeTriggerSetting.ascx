<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OnetimeTriggerSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Task.OnetimeTriggerSetting" %>

<script type="text/javascript">
	$(document).ready(function() {
		$("input[id$='txtDailyTriggerStartDateTime']").datetimepicker({
			showSecond: false,
			ampm: true,
			timeFormat: 'hh:mm:ss tt'
		});
	});
</script>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span">
			<label>Start Date Time</label>
		</span>
		<span>
			<asp:TextBox ID="txtDailyTriggerStartDateTime" runat="server"></asp:TextBox>
			<asp:RegularExpressionValidator runat="server" ID="revDateTime" ControlToValidate="txtDailyTriggerStartDateTime"
					ValidationExpression="^[0,1]\d{1}\/(([0-2]\d{1})|([3][0,1]{1}))\/(([1]{1}[9]{1}[9]{1}\d{1})|([2-9]{1}\d{3})) [0,1,2]\d{1}:[0-5]\d{1}:[0-5]\d{1} (a|A|p|P)(m|M)$"
					ErrorMessage="Invalid date time format.">*</asp:RegularExpressionValidator>
		</span>
	</li>
</ul>
