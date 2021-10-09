<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DailyTriggerSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Task.DailyTriggerSetting" %>

<script type="text/javascript">
	$(document).ready(function() {
		$("input[id$='txtDailyTriggerStartDate']").datepicker(
		{
			changeYear: true
		});
	});
</script>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span">
			<label>Type</label>
		</span>
		<span>
			<asp:DropDownList runat="server" ID="ddlDailyTriggerPerformTask"></asp:DropDownList>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span">
			<label>Start Time(24hr)</label>
		</span>
		<span>
			<asp:TextBox ID="txtStartTimeHour" ToolTip="Hours" Width="25px" MaxLength="2" runat="server" style="padding:3px;"></asp:TextBox>
			<asp:CompareValidator ID="startTimeHourValidator" runat="server" ErrorMessage="Hours in time should be a number." 
					Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtStartTimeHour">*</asp:CompareValidator>
			:
			<asp:TextBox ID="txtStartTimeMinutes" ToolTip="Minutes" Width="25px" MaxLength="2" runat="server" style="padding:3px;"></asp:TextBox>
			<asp:CompareValidator ID="startTimeMinutesValidator" runat="server" ErrorMessage="Minutes in time should be a number." 
					Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtStartTimeMinutes">*</asp:CompareValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span">
			<label>Start Date</label>
		</span>
		<span>
			<asp:TextBox ID="txtDailyTriggerStartDate" runat="server"></asp:TextBox>
            <asp:CompareValidator ID="triggerStartDateValidator" runat="server" ErrorMessage="Please enter a valid start date." Type="Date"
                Operator="DataTypeCheck" ControlToValidate="txtDailyTriggerStartDate">*</asp:CompareValidator>
            <asp:RequiredFieldValidator ID="triggerStartDateRequiredValidator" runat="server" ErrorMessage="Please enter a valid start date." ControlToValidate="txtDailyTriggerStartDate">
                *
            </asp:RequiredFieldValidator>
		</span>
	</li>
</ul>
