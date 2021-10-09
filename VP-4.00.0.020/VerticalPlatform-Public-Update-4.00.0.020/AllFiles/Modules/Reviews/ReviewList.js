RegisterNamespace("VP.ReviewList");

$(document).ready(function () {  
    
    if (typeof VP.ratyInitialized === 'undefined' || !VP.ratyInitialized) {
        VP.ratyInitialized = true;
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
    }

    setTimeout(function () {
        VP.ReviewList.TransferToReviewsSection();
    }, 1);
});

VP.ReviewList.GetQueryStringParameter = function (paremeterKey) {
    var urlParams = new window.URLSearchParams(location.search);
    return urlParams.get(paremeterKey);
};


VP.ReviewList.TransferToReviewsSection = function () {
    var transferSection = VP.ReviewList.GetQueryStringParameter('transferto') || window.location.hash.substr(1);
    if (transferSection != "" && transferSection == "reviews") {
      VP.ReviewList.ScrollToReviewsSection();
    }
};

VP.ReviewList.ScrollToReviewsSection = function () {
  var reviewListContainer = $(".reviewList").closest(".container").attr("id");
  //try anchorlink container
  if (VP.AnchorLinkContainer) {
    var anchorLinkContainer = "#" + $(".reviewList").closest(".anchor-link-section").attr("id");
    VP.AnchorLinkContainer.prototype.Navigate(anchorLinkContainer);
  } else {
    var tp = $("#" + reviewListContainer).offset().top;
    $('html, body').animate({
      scrollTop: tp
    }, 1000);
  }
};

