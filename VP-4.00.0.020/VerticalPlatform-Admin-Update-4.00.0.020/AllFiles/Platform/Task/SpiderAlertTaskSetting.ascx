<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpiderAlertTaskSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.SpiderAlertTaskSettings" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Slider Window (Minutes)</label></span> <span>
		<asp:TextBox runat="server" ID="sliderWindow" ToolTip="Time period in minutes"></asp:TextBox>
		<asp:CompareValidator ID="sliderWindowValidator" ControlToValidate="sliderWindow" runat="server" 
				ErrorMessage="Invalid slider window." Operator="DataTypeCheck" Type="Integer" >*</asp:CompareValidator>
		<asp:RequiredFieldValidator ID="sliderWindowRequiredValidator" ControlToValidate="sliderWindow" runat="server"
			ErrorMessage="Slider window cannot be empty.">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Page Views Threshold</label></span> <span>
		<asp:TextBox runat="server" ID="pageViewsThreshold"></asp:TextBox>
		<asp:CompareValidator ID="pageViewsValidator" ControlToValidate="pageViewsThreshold" runat="server" 
				ErrorMessage="Invalid page views threshold." Operator="DataTypeCheck" Type="Integer" >*</asp:CompareValidator>
		<asp:RequiredFieldValidator ID="pageViewsRequiredValidator" ControlToValidate="pageViewsThreshold" runat="server"
			ErrorMessage="Page views threshold cannot be empty.">*</asp:RequiredFieldValidator>
		</span>
	</li>
</ul>
