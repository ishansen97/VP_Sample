<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WeeklyTriggerSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Task.WeeklyTriggerSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span">
			<label>Day of Week</label>
		</span>
		<span>
			<asp:DropDownList runat="server" ID="ddlWeeklyTriggerDayOfWeek"></asp:DropDownList>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span">
			<label>Start Time(24hr)</label>
		</span>
		<span>
			<asp:TextBox ID="txtStartTimeHour" ToolTip="Hours" Width="25px" MaxLength="2" runat="server" Style="padding: 3px;"></asp:TextBox>
			<asp:CompareValidator ID="startTimeHourValidator" runat="server" ErrorMessage="Hours in time should be a number." 
					Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtStartTimeHour">*</asp:CompareValidator>
			:
			<asp:TextBox ID="txtStartTimeMinutes" ToolTip="Minutes" Width="25px" MaxLength="2" runat="server" Style="padding: 3px;"></asp:TextBox>
			<asp:CompareValidator ID="startTimeMinutesValidator" runat="server" ErrorMessage="Minutes in time should be a number." 
					Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtStartTimeMinutes">*</asp:CompareValidator>
		</span>
	</li>
</ul>
