<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ManageCampaignsTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.ManageCampaignsTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="Batch Size" MaxLength="3" Width="200"></asp:TextBox></span>
		<asp:CompareValidator ID="cvBatchSize" runat="server" ErrorMessage="Batch size should be an integer."
				Type="Integer" ControlToValidate="txtBatchSize" Operator="DataTypeCheck">*</asp:CompareValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Max Time for Deployment in Minutes</label></span> <span>
		<asp:TextBox runat="server" ID="txtTime" ToolTip="The time to wait before retrying the deployment of a locked campaign" MaxLength="2" Width="200"></asp:TextBox></span>
		<asp:CompareValidator ID="cmvTime" runat="server" ErrorMessage="The max time for deployment should be an integer."
				Type="Integer" ControlToValidate="txtTime" Operator="DataTypeCheck">*</asp:CompareValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Deployment Waiting Time after Synchronizing User Data in Minutes</label></span> <span>
		<asp:TextBox runat="server" ID="deploymentWait" ToolTip="The time to wait before deploying a campaign after the user data sync is complete" MaxLength="3" Width="200"></asp:TextBox></span>
		<asp:CompareValidator ID="deploymentWaitCompareValidator" runat="server" ErrorMessage="The deployment wait time should be an integer."
				Type="Integer" ControlToValidate="deploymentWait" Operator="DataTypeCheck">*</asp:CompareValidator>
		<asp:RangeValidator ID="deploymentWaitRangeValidator" ControlToValidate="deploymentWait"
				Type="Integer" MinimumValue="0" MaximumValue="100" runat="server" ErrorMessage="The deployment wait should be between 0 and 100.">*</asp:RangeValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			 Time Gap to Left Till Scheduled Time before Synching in Minutes</label></span> <span>
		<asp:TextBox runat="server" ID="syncStartTimeGap" ToolTip="The time gap to left till scheduled time, the process should wait before synching campaign data." MaxLength="4" Width="200"></asp:TextBox></span>
		<asp:CompareValidator ID="syncStartTimeGapCompareValidator" runat="server" ErrorMessage="The sync start wait time should be an integer."
				Type="Integer" ControlToValidate="syncStartTimeGap" Operator="DataTypeCheck">*</asp:CompareValidator>
		<asp:RangeValidator ID="syncStartTimeGapRangeValidator" ControlToValidate="syncStartTimeGap"
				Type="Integer" MinimumValue="0" MaximumValue="1000" runat="server" ErrorMessage="The sync start wait time should be between 0 and 1000.">*</asp:RangeValidator>
	</li>
</ul>