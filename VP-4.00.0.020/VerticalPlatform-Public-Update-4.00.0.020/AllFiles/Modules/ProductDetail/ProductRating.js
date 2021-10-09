$(document).ready(function () {
	$('.ratingControl').raty({
		readOnly: true,
		starOff: '/Images/star-off.png',
		starOn: '/Images/star-on.png',
		starHalf: '/Images/star-half.png',
		halfShow: true,
		hints: ['Ratings', 'Ratings', 'Ratings', 'Ratings', 'Ratings'],
		//width: 150,
		noRatedMsg: '',
		score: function () {
			return $(this).attr('ratingScore');
		}
	});

	var hashUrl = $(".citations").parent().attr('id');
	$(".haveCitations").click(function (event) {
	    $(".haveCitations").attr("href", '#' + hashUrl);
	    
	    var sickyHeaderHeight = $(".sticky-header-module>div").height() || 0;

	    var tp = ($('#' + hashUrl).parent(".module").offset().top) - sickyHeaderHeight;
	    $('html, body').animate({
	        scrollTop: tp
	    }, 1000);
	});

	$(".ratingCount").click(function (event) {
		VP.ReviewList?.ScrollToReviewsSection();
	});

});


