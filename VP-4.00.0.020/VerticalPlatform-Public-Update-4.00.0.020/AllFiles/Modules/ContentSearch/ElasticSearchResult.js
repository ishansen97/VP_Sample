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
});


