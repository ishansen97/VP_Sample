RegisterNamespace("VP.ArticleDetail");

VP.ArticleDetail.PopupSection = function(sectionid) {
	$("#" + sectionid).jqm(
	{
		modal: true
	});

	$("#" + sectionid).css("width", 500);
	$("#" + sectionid).jqmShow();
	$("#btnCancle" + sectionid).click(function() {
		VP.ArticleDetail.CanclePopUp(sectionid);
	});

}

VP.ArticleDetail.CanclePopUp = function(sectionid) {
	$("#" + sectionid).jqmHide();
}

VP.ArticleDetail.LoadPage =  function(pageId) {
	$(".previewPage")
	.css("visibility", "hidden")
	.css("display", "none");

	$("#page_" + pageId)
	.css("visibility", "visible")
	.css("display", "block");

	$(".pageNumber")
	.css("font-waight", "normal")
	.css("cursor", "pointer");

	$("#pageNumber_" + pageId)
	.css("font-waight", "bold")
	.css("cursor", "pointer");
} 