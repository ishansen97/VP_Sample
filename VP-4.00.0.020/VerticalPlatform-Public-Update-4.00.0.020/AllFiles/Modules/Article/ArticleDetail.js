RegisterNamespace("VP.ArticleDetail");

VP.ArticleDetail.ScrollToElement = function(id) {
	var theElement = $get(id);
	var selectedPosX = 0;
	var selectedPosY = 0;

	while (theElement != null) {
		selectedPosX += theElement.offsetLeft;
		selectedPosY += theElement.offsetTop;
		theElement = theElement.offsetParent;
	}

	window.scrollTo(selectedPosX, selectedPosY);
};

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
};

VP.ArticleDetail.CanclePopUp = function(sectionid) {
	$("#" + sectionid).jqmHide();
};

VP.ArticleDetail.ToggleArticleSection = function (sender) {
	var sectionId = sender.id.split("_")[1];
	var toggleSection = "#section" + sectionId;
	$(toggleSection).toggle("slow");
};


VP.ArticleDetail.SetWebinarOverlay = function (btnText) {
	var videoContainer = $(".video-js");
	var containerOverlay = "<div class='container-overlay-background'>" +
		"<div class='container-overlay-content'> <input type='button' class='container-overlay-button' value='" + btnText + "'>" +
		"</div>" +
		"</div>";
	containerOverlay = $(containerOverlay);
	videoContainer.parent().css("position","relative").append(containerOverlay);

	containerOverlay.find(".container-overlay-button").click(function () {
		VP.ArticleDetail.EaseInToDiv(".formHolder.module");
	});

	//disabling chapters
	$(".chapters").find("li").css("pointer-events", "none").unbind();
	if (videojs) {
		$(videojs.getAllPlayers()).each(function (index, player) {
			player.on('loadedmetadata', function () {
				player.autoplay(false);
				player.pause();
			});
		});
	}
};

VP.ArticleDetail.EaseInToDiv = function (scrollDiv) {
	if (scrollDiv) {
		var tp = ($(scrollDiv).offset().top) - 10;
		$('html, body').animate({
			scrollTop: tp
		}, 1000);
	}
};

//Article leadform resorurce
VP.ArticleDetail.ChangeLeadResourceCss = function () {
  var secondPageButton = $(".downloadContentLeadFormContainer");
  if (secondPageButton.length) {
    $(".downloadContentLeadFormContainer").parent().addClass("second-step-lead");
  }
}

$(document).ready(function (){
	$('.ratingControl').raty({
		readOnly: true,
		starOff: '/Images/star-off.png',
		starOn: '/Images/star-on.png',
		starHalf: '/Images/star-half.png',
		halfShow: true,
		hints: ['Ratings', 'Ratings', 'Ratings', 'Ratings', 'Ratings'],
		//width: 150,
		noRatedMsg: 'Ratings',
		score: function () {
			return $(this).attr('ratingScore');
		}
	});

	_options = {
		context: $(this).find('.relatedProducts.itemList'),
		selectedProducts: [],
		noOfItemsToCompare: 5
	};

  $(this).find('.relatedProducts.itemList').relatedProducts(_options);

  VP.ArticleDetail.ChangeLeadResourceCss();
});

