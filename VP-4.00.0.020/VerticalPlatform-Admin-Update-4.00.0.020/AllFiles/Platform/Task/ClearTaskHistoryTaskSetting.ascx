<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ClearTaskHistoryTaskSetting.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.Platform.Task.ClearTaskHistoryTaskSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Number of History Records to Keep Per Task
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtRecordCount" ToolTip="No of records to keep without deleting"
					Width="200" />
			<asp:RequiredFieldValidator ID="rfvRecordCount" runat="server" 
				ErrorMessage="Please enter a value for number of records." ControlToValidate="txtRecordCount">*</asp:RequiredFieldValidator>
			<asp:CompareValidator ID="cvRecordCount" runat="server" ErrorMessage="Number of records should be a positive integer." Type="Integer" ControlToValidate="txtRecordCount" Operator="GreaterThan" ValueToCompare="0">*</asp:CompareValidator>
		</span>
	</li>
</ul>
