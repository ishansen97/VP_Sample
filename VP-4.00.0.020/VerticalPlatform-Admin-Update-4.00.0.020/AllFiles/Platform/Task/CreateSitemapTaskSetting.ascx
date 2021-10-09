<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateSitemapTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.CreateSitemapTaskSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Sitemap folder</label></span> <span>
			<asp:TextBox runat="server" ID="txtSiteMapFolder" ToolTip="SiteMapFolder" Width="200"></asp:TextBox></span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="BatchSize" MaxLength="5" Width="200"></asp:TextBox>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Urls per Site Map File</label></span> <span>
		<asp:TextBox runat="server" ID="txtUrlsPerSiteMapFile" ToolTip="Number of urls per site map file" MaxLength="10" Width="200"></asp:TextBox>
		</span>
		<asp:CompareValidator ID="cvUrlsPerSiteMapFile" runat="server" ErrorMessage="Urls per site map file should be an integer."
				Type="Integer" ControlToValidate="txtUrlsPerSiteMapFile" Operator="DataTypeCheck">*</asp:CompareValidator>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Compression On</label></span> <span>
				<asp:CheckBox ID="chkCompressionOn" runat="server" />
		</span>
	</li>
</ul>