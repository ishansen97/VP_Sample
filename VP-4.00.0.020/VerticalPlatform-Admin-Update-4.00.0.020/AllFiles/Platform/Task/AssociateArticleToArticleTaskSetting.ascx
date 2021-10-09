<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AssociateArticleToArticleTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.AssociateArticleToArticleTaskSetting" %>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	$(document).ready(function() {
		RegisterNamespace("VP.ArticleToArticle");
		var articleTypeFilterOptions = { siteId: VP.SiteId, type: "Article Type", currentPage: "1", pageSize: "15", showName: "true" };
		
		$("input[type=text][id*=txtSourceArticleType]").contentPicker(articleTypeFilterOptions);
		$("input[type=text][id*=txtTargetedArticleType]").contentPicker(articleTypeFilterOptions);
	});
</script>
		
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Node Score</label></span> <span>
		<asp:TextBox runat="server" ID="txtNodeScore" ToolTip="BatchSize" MaxLength="5"></asp:TextBox>
		<asp:RequiredFieldValidator ID="rfvNodeScore" runat="server" 
				ErrorMessage="Please enter the node score." ControlToValidate="txtNodeScore">*</asp:RequiredFieldValidator>
		<asp:RegularExpressionValidator ID="revNodeScore" runat="server" ValidationExpression="^[0-9]+$" 
				ErrorMessage="Please enter a numeric value for node score." ControlToValidate="txtNodeScore">*</asp:RegularExpressionValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Source Article Type</label></span> <span>
		<asp:TextBox ID="txtSourceArticleType" runat="server" Style="width: 210px" />
		<asp:RequiredFieldValidator ID="rfvSourceArticleType" runat="server" 
				ErrorMessage="Please select the source article type." ControlToValidate="txtSourceArticleType">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Targeted Article Type</label></span> <span>
		<asp:TextBox ID="txtTargetedArticleType" runat="server" Style="width: 210px" />
		<asp:RequiredFieldValidator ID="rfvTargetedArticleType" runat="server" 
				ErrorMessage="Please select the targeted article type." ControlToValidate="txtTargetedArticleType">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="BatchSize" MaxLength="5"></asp:TextBox></span>
	</li>
</ul>