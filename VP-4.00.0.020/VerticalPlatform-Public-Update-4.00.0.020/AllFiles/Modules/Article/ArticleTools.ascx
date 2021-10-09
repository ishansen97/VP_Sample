<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleTools.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Articles.ArticleTools" %>
<div>
	<ul class="artcleToolList">
		<li runat="server" id="liEmailButton"><a id="btnEmail" class="articleToolsEmail">Email</a>
		</li>
		<li runat="server" id="liPrintButton"><a id="btnPrint" class="articleToolsPrint">Print</a>
		</li>
		<li runat="server" id="Bookmark"><a id="btnBookmark" class="articleToolsBookmark">Bookmark</a>
		</li>
		<li runat="server" id="ShareThisPage">
			<div class="sharethisholder module">
				<a id="ck_facebook" class="chicklet" title="Share this page on Facebook" href="javascript:void(0);">
						Share this page on Facebook</a> 
				<a id="ck_twitter" class="chicklet" title="Tweet this page"
						href="javascript:void(0);">Tweet this page</a> 
				<a id="ck_digg" class="chicklet" title="Digg this page"
						href="javascript:void(0);">Digg this Page</a> 
				<a id="ck_sharethis" title="Share this page"
						class="chicklet" href="javascript:void(0);">Share this page</a>
			</div>
		</li>
	</ul>
</div>

<asp:HiddenField ID="hdnArticleId" runat="server" />
<asp:HiddenField ID="hdnPrivacyPolicy" runat="server" />
<asp:HiddenField ID="hdnUserInfo" runat="server" />
<div class="jqmWindow" id="PrintArticle">
</div>
