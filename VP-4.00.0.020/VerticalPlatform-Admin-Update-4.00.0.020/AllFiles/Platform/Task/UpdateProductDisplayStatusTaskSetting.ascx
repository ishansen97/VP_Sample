<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpdateProductDisplayStatusTaskSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.UpdateProductDisplayStatusTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="BatchSize" MaxLength="5"></asp:TextBox></span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Time Interval(Days)</label></span> <span>
		<asp:TextBox runat="server" ID="timeIntervalTextBox" ToolTip="Time Interval" MaxLength="2"></asp:TextBox></span>
		<asp:CompareValidator ID="timeIntervalCompareValidator" runat="server" Operator="GreaterThanEqual" Type="Integer"
			ControlToValidate="timeIntervalTextBox" Text="Text must be an integer." ValueToCompare="0"/>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">Properties to Update</span> 
		<span>
			<asp:CheckBoxList ID="updateProperties" runat="server" CssClass="updateProperties" RepeatDirection="Horizontal" RepeatColumns="2"></asp:CheckBoxList>
		</span>
	</li>
</ul>