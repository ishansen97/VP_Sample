<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DailyRegisteredUserListTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.DailyRegisteredUserListTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="BatchSize" MaxLength="3" Width="200"></asp:TextBox></span>
		<asp:RequiredFieldValidator ID="rfvBatchSize" runat="server" ControlToValidate="txtBatchSize"
			ErrorMessage="Please enter value for batch size.">*</asp:RequiredFieldValidator>
		<asp:CompareValidator Type="Integer" ControlToValidate="txtBatchSize" ID="cvBatchSize"
			runat="server" ErrorMessage="Please enter integer value." Operator="DataTypeCheck">*</asp:CompareValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Email Subject</label></span> <span>
		<asp:TextBox runat="server" ID="txtEmailSubject" ToolTip="Email Subject" Width="200"></asp:TextBox></span>
		<asp:RequiredFieldValidator ID="rfvEmailSubject" runat="server" ControlToValidate="txtEmailSubject"
				ErrorMessage="Please enter email subject.">*</asp:RequiredFieldValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Days of Interest</label></span> <span>
		<asp:TextBox runat="server" ID="txtDaysOfInterest" ToolTip="Number of days to be consider" Width="200"></asp:TextBox>
		<asp:CompareValidator ID="cvDaysOfInterest" runat="server" 
			ControlToValidate="txtDaysOfInterest" ErrorMessage="Please enter integer value greater than zero." Operator="GreaterThan" 
			Type="Integer" ValueToCompare="0">*</asp:CompareValidator>
		</span>
	</li>	
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Email Public User List to
				<br />
				(comma separated,
				<br />
				no whitespaces)
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtRecipientEmail" ToolTip="RecipientEmail" Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvRecipientEmail" runat="server" ControlToValidate="txtRecipientEmail"
				ErrorMessage="Please enter recipient email addresses.">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Excel Format</label></span> <span>
		<asp:DropDownList runat="server" ID="ddlExcelFormat">
			<asp:ListItem Text="Excel 2007" Value=".xlsx"></asp:ListItem>
			<asp:ListItem Text="Excel 2003" Value=".xls"></asp:ListItem>
		</asp:DropDownList>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Field Grouping XML</label></span> <span>
		<asp:TextBox runat="server" ID="txtFieldGroupingXML" 
			ToolTip="Field Grouping XML" TextMode="MultiLine" Height="216px" Width="371px"></asp:TextBox></span>
	</li>
</ul>