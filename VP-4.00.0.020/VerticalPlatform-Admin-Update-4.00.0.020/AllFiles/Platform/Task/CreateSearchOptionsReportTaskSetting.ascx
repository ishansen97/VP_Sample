<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateSearchOptionsReportTaskSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.CreateSearchOptionsReportTaskSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">
			<label>
				Batch Size
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="batchSize" ToolTip="The batch size." Width="200"></asp:TextBox>
			<asp:RangeValidator ID="batchSizeRangeValidator" ControlToValidate="batchSize"
						Type="Integer" MinimumValue="1" runat="server" MaximumValue="100000"
						ErrorMessage="Batch size should be an integer and greater than 0.">*</asp:RangeValidator>
		</span>
	</li>
</ul>
