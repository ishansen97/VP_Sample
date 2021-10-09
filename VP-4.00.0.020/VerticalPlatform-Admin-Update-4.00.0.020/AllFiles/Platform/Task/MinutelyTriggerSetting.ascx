<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MinutelyTriggerSetting.ascx.cs" 
		Inherits="VerticalPlatformAdminWeb.Platform.Task.MinutelyTriggerSetting" %>
		
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:165px;">
			<label>Minutely Trigger Time Interval</label>
		</span>
		<span>
			<asp:TextBox ID="txtMinutelyTriggerTimeInterval" runat="server"></asp:TextBox>
			<asp:CompareValidator ID="startTimeMinutesValidator" runat="server" ErrorMessage="Minutes in time should be a number." 
					Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtMinutelyTriggerTimeInterval">*</asp:CompareValidator>
		</span>
	</li>
</ul>
