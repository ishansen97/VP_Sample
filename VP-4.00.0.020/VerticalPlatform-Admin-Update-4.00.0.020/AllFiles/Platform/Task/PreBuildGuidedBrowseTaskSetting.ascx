<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PrebuildGuidedBrowseTaskSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.PrebuildGuidedBrowseTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Fixed Guided Browse Ids (comma separated)</label></span> <span>
		<asp:TextBox runat="server" ID="txtFixedGuidedBrowseIds" ToolTip="Comma separated list of fixed guided browse ids to build"></asp:TextBox></span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Guided Browse Ids (comma separated)</label></span> <span>
		<asp:TextBox runat="server" ID="txtGuidedBrowseIds" ToolTip="Comma separated list of guided browse ids to build"></asp:TextBox></span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Build New and Schema Changed Guided Browses Only</label></span><span>
		<asp:CheckBox ID="buildNewAndChanged" runat="server" ToolTip="Only build new guided browses and those with considerable change to its levels definition"/></span>
	</li>
</ul>