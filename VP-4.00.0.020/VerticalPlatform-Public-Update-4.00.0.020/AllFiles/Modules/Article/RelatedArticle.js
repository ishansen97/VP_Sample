(function($) {
	$.otherRequestedArticles = function() {
		var container = $(".relatedArticle_div");
		$(".request_button", container).click(function() {
			var articles = $(".requested_article input[type=checkbox]", container);
			var index = 0;
			var articlesSelected = false;
			for (; index < articles.length; index++) {
				if ($(articles[index]).prop("checked")) {
					articlesSelected = true;
					break;
				}
			}

			if (!articlesSelected) {
				alert("Please select one or more articles to request information.");
				return false;
			}
		});
	};
})(jQuery);

$(document).ready(function() {
	$.otherRequestedArticles();
});