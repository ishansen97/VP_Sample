<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GenarateProductReportForScrazzlTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.GenarateProductReportForScrazzlTaskSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 250px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="batchSize" ToolTip="Batch Size" MaxLength="5"></asp:TextBox></span>
	</li>
    <li class="common_form_row clearfix">
		<span class="label_span" style="width: 250px;"><label>
			Product Amount per CSV File</label></span> <span>
		<asp:TextBox runat="server" ID="csvSize" ToolTip="Csv Size" MaxLength="5"></asp:TextBox></span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 250px;"><label>
			S3 Bucket URL</label></span> <span>
		<asp:TextBox runat="server" ID="s3BucketUrl" ToolTip="Elasticsearch server node" MaxLength="200"></asp:TextBox></span>
	</li>
</ul>