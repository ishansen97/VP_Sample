<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DownloadBulkEmailSubscriberListTaskSetting.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.Platform.Task.DownloadBulkEmailSubscriberListTaskSetting" %>

<ul class="common_form_area" style="width:430px">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Bulk Email Type
			</label>
		</span>
		<span>
			<asp:DropDownList runat="server" ID="ddlBulkEmailType" />
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Destination Path
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtDownloadPath" ToolTip="The destination download path." Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvDownloadPath" runat="server" 
				ErrorMessage="Please enter the download path." ControlToValidate="txtDownloadPath">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Batch Size
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="The batch size." Width="200"></asp:TextBox>
			<asp:CompareValidator ID="cvBatchSize" runat="server" ErrorMessage="Batch size should be an integer."
					Type="Integer" ControlToValidate="txtBatchSize" Operator="DataTypeCheck">*</asp:CompareValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Excel format
			</label>
		</span>
		<span>
			<asp:RadioButton ID="rdbXls" runat="server" GroupName="ExcelType" Text="xls" />
			<asp:RadioButton ID="rdbXlsx" runat="server" GroupName="ExcelType" Text="xlsx" />
		</span>
	</li>
</ul>