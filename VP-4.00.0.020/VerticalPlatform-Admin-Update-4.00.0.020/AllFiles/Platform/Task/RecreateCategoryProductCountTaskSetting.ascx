<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RecreateCategoryProductCountTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.RecreateCategoryProductCountTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="BatchSize" MaxLength="3" Width="200"></asp:TextBox></span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			Include Search Categories</label></span> <span>
		<asp:CheckBox ID="chkIncludeSearchCategories" runat="server" Checked="false" />
	</li>
</ul>