<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateContentRatingTaskSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.CreateContentRatingTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Batch Size
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="BatchSize" MaxLength="3" Width="200"></asp:TextBox>
			<asp:RangeValidator ID="rvBatchSize" ControlToValidate="txtBatchSize"
						Type="Integer" MinimumValue="1" runat="server" MaximumValue="1000"
						ErrorMessage="Batch size should be greater than 0.">*</asp:RangeValidator>
		</span>
	</li>
</ul>
