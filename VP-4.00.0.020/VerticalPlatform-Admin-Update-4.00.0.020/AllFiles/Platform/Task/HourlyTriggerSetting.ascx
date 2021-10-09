<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HourlyTriggerSetting.ascx.cs" 
		Inherits="VerticalPlatformAdminWeb.Platform.Task.HourlyTriggerSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span">
			<label>Hourly Trigger Time Interval</label>
		</span>
		<span>
			<asp:TextBox ID="txtHourlyTriggerTimeInterval" runat="server"></asp:TextBox>
			<asp:CompareValidator ID="startTimeHourValidator" runat="server" ErrorMessage="Hours in time should be a number." 
					Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtHourlyTriggerTimeInterval">*</asp:CompareValidator>
		</span>
	</li>
</ul>