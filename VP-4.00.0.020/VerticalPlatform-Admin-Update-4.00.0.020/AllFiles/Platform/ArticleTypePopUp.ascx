<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleTypePopUp.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ArticleTypePopUp" %>

<style type="text/css">
    .form-horizontal .control-group{margin-bottom:5px;}
</style>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Article Types</label>
		<div class="controls">
			<asp:DropDownList runat="server" ID="ddlArticleType">
			</asp:DropDownList>
		</div>
	</div>
</div>