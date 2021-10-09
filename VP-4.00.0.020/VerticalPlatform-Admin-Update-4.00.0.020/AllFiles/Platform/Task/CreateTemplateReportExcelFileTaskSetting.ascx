<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateTemplateReportExcelFileTaskSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Task.CreateTemplateReportExcelFileTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
		<label>
			Destination Path
		</label>
	</span><span>
		<asp:TextBox runat="server" ID="txtDownloadPath" ToolTip="The destination download path."
			Width="200"></asp:TextBox>
		<asp:RequiredFieldValidator ID="rfvDownloadPath" runat="server" ErrorMessage="Please enter the download path."
			ControlToValidate="txtDownloadPath">*</asp:RequiredFieldValidator>
	</span></li>
	<li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
		<label>
			Batch Size
		</label>
	</span><span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="The batch size." Width="200"></asp:TextBox>
	</span></li>
</ul>
