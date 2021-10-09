$(document).ready(function () {
	var searchMenuPosition;
	var searchMenuHeight;
	var footerPosition = Math.floor($(".footerOuter").offset().top);
	var searchPositions = [];

	if ($(".searchMenu").length && $(".searchMenu") !== null && $(".searchMenu").offset() !== null) {
		searchMenuPosition = Math.floor($(".searchMenu").offset().top);
		searchMenuHeight = Math.floor($(".searchMenu").height());
	}

	$('.searchResultPlaceHolder').each(function () {
		if ($(this).offset().top > 0) {
			searchPositions.push(Math.floor($(this).offset().top));
		}
	});

	$(window).scroll(function (event) {
		var scrollPosition = $(window).scrollTop();
		if (scrollPosition >= searchMenuPosition) {
			$('.searchMenu').addClass('searchHeaderFixed');
		}
		else {
			$('.searchMenu').removeClass('searchHeaderFixed');
		}

		if ((scrollPosition + searchMenuHeight) > footerPosition) {
			$(".searchMenu").removeClass("fixedTop");
		}

		if (searchPositions !== undefined && searchPositions !== null) {
			for (var i = 0; i < searchPositions.length; i++) {
				if ((scrollPosition + searchMenuHeight) < searchPositions[0]) {
					$(".searchMenu ul li").removeClass("active");
					$(".searchMenu ul li:eq(0)").addClass("active");
					return;
				}

				if ((scrollPosition + searchMenuHeight) > searchPositions[i]) {
					$(".searchMenu ul li").removeClass("active");
					$(".searchMenu ul li:eq(" + (i + 1) + ")").addClass("active");
				}
			}
		}
	});
});