<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentArticleList.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Articles.ContentArticleList" %>
<div class="contentArticleList module">
	<div id="divTitle" runat="server">
		<h3>
			Articles</h3>
	</div>
	<asp:PlaceHolder ID="phArticleList" runat="server"></asp:PlaceHolder>
</div>
