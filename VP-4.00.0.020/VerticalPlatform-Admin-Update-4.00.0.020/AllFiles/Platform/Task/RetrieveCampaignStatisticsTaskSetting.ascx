<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RetrieveCampaignStatisticsTaskSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Task.RetrieveCampaignStatisticsTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
		<label>
			Days of Interest</label></span> <span>
				<asp:TextBox runat="server" ID="txtDaysOfInterest" ToolTip="Retrieve stats of campaigns deployed since this number of days"
					Width="200"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvDaysOfInterest" runat="server" ErrorMessage="Please enter days of interest"
					ControlToValidate="txtDaysOfInterest">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="revDaysOfInterest" runat="server" ControlToValidate="txtDaysOfInterest"
					ErrorMessage="Only numbers are allowed" ValidationExpression="[0-9]*"></asp:RegularExpressionValidator>
			</span></li>
</ul>
