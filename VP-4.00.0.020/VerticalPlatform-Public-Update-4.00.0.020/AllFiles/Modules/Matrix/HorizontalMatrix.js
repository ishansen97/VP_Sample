$(document).ready(function () {
    $(".seeMore").click(function () {
        var parent = $(this).closest('.productColumn');
        var moreText = parent.find("#fullDesc");
        var btnText = parent.find("#seeMoreBtn");
        var truncatedText = parent.find("#truncatedDesc");

        if (moreText.css("display") !== "none") {
            btnText.text("... Read more");
            moreText.css('display', "none");
            truncatedText.css('display', "inline");
        } else {
            btnText.text("Read less");
            moreText.css('display', "inline");
            truncatedText.css('display', "none");
        }
    });

});