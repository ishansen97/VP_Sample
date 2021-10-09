<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeaturedVendorArticles.ascx.cs" 
		Inherits="VerticalPlatformWeb.Modules.Article.FeaturedVendorArticles" %>

<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<script type="text/javascript">
	$(document).ready(function () {
		$('.pagingHolder li').each(function (i, liElement) {
			if ($('a', liElement).length < 1 && !$(liElement).hasClass('active')) {
				$(liElement).hide();
			}
		});
	});
</script>

<div id="filteredVendorArticles" class="filteredVendorArticles" runat="server">
	<div class="articleList module">
		<asp:Label ID="messageLabel" runat="server" CssClass="errorMessage"></asp:Label>
		<asp:PlaceHolder ID="featuredArticlesPlaceholder" runat="server"></asp:PlaceHolder>
	</div>
	<uc1:Pager ID="vendorArticleListPager" runat="server" />
</div>
