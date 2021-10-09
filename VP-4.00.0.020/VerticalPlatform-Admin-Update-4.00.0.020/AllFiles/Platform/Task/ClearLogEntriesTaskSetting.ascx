<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ClearLogEntriesTaskSetting.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.Platform.Task.ClearLogEntriesTaskSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Number of Days to Keep Log Entries
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtDaysOfInterest" ToolTip="Number of days to keep log entries."
					Width="200" />
			<asp:RequiredFieldValidator ID="rfvDaysOfInterest" runat="server" 
				ErrorMessage="Please enter a value for the number of days to keep log entries." ControlToValidate="txtDaysOfInterest">*</asp:RequiredFieldValidator>
			<asp:CompareValidator ID="cvOrder" runat="server" ErrorMessage="Number of days to keep log entries should be a positive integer." Type="Integer" ControlToValidate="txtDaysOfInterest" Operator="GreaterThan" ValueToCompare="0">*</asp:CompareValidator>
		</span>
	</li>
</ul>