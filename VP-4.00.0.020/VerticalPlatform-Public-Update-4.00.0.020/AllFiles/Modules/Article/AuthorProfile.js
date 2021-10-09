RegisterNamespace("VP.AuthorProfile");


$(document).ready(function () {
	VP.AuthorProfile.initAuthorDesc();
	VP.AuthorProfile.toggleDesc();
});

VP.AuthorProfile = function () {
    var that = this;
}

VP.AuthorProfile.PartialAuthorDescription = "";
VP.AuthorProfile.TotalAuthorDescription = "";

VP.AuthorProfile.initAuthorDesc = function () {
	if ($('.author-morelink').length)
	{
		if ($('.author-description .profile').length)
		{
			$('.author-description-more').hide();
			var originalText = $('.author-description .profile').html();
			$('.author-description .profile').html(originalText + "...");
			VP.AuthorProfile.PartialAuthorDescription = $('.author-description').html();

			var authorDesc = $('.author-description');
			var totalDescription = originalText + $('.author-description-more').html();
			authorDesc.find('.profile').html(totalDescription)
			VP.AuthorProfile.TotalAuthorDescription = authorDesc[0].innerHTML;

			$('.author-description .profile').html(originalText + "...");
		}
		else
		{
			$('.author-description-more').hide();
			VP.AuthorProfile.PartialAuthorDescription = $('.author-description').html() + "...";
			VP.AuthorProfile.TotalAuthorDescription = $('.author-description').html() + $('.author-description-more').html();
			$('.author-description').html(VP.AuthorProfile.PartialAuthorDescription);
		}
	}
}

VP.AuthorProfile.toggleDesc = function () {
	$('.author-morelink').click(function (e) {
		e.preventDefault();

		if ($('.author-description-more').hasClass('show'))
		{
			$('.author-description').html(VP.AuthorProfile.PartialAuthorDescription);
			$('.author-description-more').removeClass('show');
			$('.author-morelink span').text("Read More");
			$('#authorReadMore_caret').removeClass('fa fa-caret-up').addClass('fa fa-caret-down');
		} else
		{
			$('.author-description').html(VP.AuthorProfile.TotalAuthorDescription);
			$('.author-description-more').addClass('show');
			$('.author-morelink span').text("Show Less");
			$('#authorReadMore_caret').removeClass('fa fa-caret-down').addClass('fa fa-caret-up');
		}
	});
}

