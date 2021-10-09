<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpdateUnsubscriptionsTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.UpdateUnsubscriptionsTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Days of Interest</label></span> <span>
		<asp:TextBox runat="server" ID="txtDaysOfInterest" ToolTip="Days of interest when synchronizing unsubscriptions" 
			MaxLength="2" Width="200"></asp:TextBox></span>
		<asp:CompareValidator ID="cvDaysOfInterest" runat="server" ErrorMessage="Days of interest should be an integer."
			Type="Integer" ControlToValidate="txtDaysOfInterest" Operator="DataTypeCheck">*</asp:CompareValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Depreciation Window(Hours)</label></span> <span>
		<asp:TextBox runat="server" ID="depreciationWindow" ToolTip="Threshold to depreciate the user score" 
			MaxLength="2" Width="200"></asp:TextBox></span>
		<asp:CompareValidator ID="depreciationWindowValidator" runat="server" ErrorMessage="Depreciatin window should be an integer."
			Type="Integer" ControlToValidate="depreciationWindow" Operator="DataTypeCheck">*</asp:CompareValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="batchSize" ToolTip="Threshold to depreciate the user score" Width="200"></asp:TextBox></span>
		<asp:CompareValidator ID="batchSizeValidator" runat="server" ErrorMessage="Batch size should be an integer."
			Type="Integer" ControlToValidate="batchSize" Operator="DataTypeCheck">*</asp:CompareValidator>
	</li>
</ul>