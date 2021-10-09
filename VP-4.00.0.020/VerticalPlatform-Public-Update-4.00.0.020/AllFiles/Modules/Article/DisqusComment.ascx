<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DisqusComment.ascx.cs" 
Inherits="VerticalPlatformWeb.Modules.Article.DisqusComment" %>
<asp:Literal ID="disqusComment" runat="server"></asp:Literal>
<script type="text/javascript">
var disqus_shortname = $("#disqusShortName").val();
var disqus_identifier = window.location.pathname;
var disqus_url = window.location.href;

(function () {
	var dsq = document.createElement('script');
	dsq.type = 'text/javascript';
	dsq.async = true;
	dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
	(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();

function disqus_callback() {
	$.vp.domFragments.contentPane.find('ul.artcleToolList li:last .comments span').text($.vp.domFragments.contentPane.find('#dsq-num-posts').text());
}

$(document).ready(function () {
	var countDom = $.vp.domFragments.contentPane.find('ul.artcleToolList li:last').after('<li/>').next();
	countDom.html('<a href="#disqus_thread " class="icon comments">Comments (<span>0</span>)</a>');
});
</script>