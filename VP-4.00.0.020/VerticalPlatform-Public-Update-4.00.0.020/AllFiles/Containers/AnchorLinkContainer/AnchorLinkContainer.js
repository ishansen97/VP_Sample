RegisterNamespace("VP.AnchorLinkContainer");

$(document).ready(function () {
    $('ul.anchor-nav-container').find('li').first().addClass('selected');
});

VP.AnchorLinkContainer = function(moduleInstanceId) {
	this._moduleInstanceId = moduleInstanceId;
};

VP.AnchorLinkContainer.prototype.Initialize = function() {
    //ease-in
    $(".anchor-nav-container li").click(function (event) {
        li_elements = $(this).siblings("li");
        if (li_elements.hasClass("selected")) {
            li_elements.removeClass("selected");
        }
        $(this).addClass("selected");
        VP.AnchorLinkContainer.prototype.EaseInToDiv($(this).find("a").attr("href"));
        VP.AnchorLinkContainer.prototype.ReWriteUrl($(this).find("a"));
        return false;
    });

};

VP.AnchorLinkContainer.prototype.EaseInToDiv = function (divID) {
    //console.log(divID);
    var sickyHeaderHeight = $(".sticky-header-module>div").height() || 0;

    var tp = $(divID).offset().top - sickyHeaderHeight;
    $('html, body').animate({
        scrollTop: tp
    }, 1000);
}


VP.AnchorLinkContainer.prototype.ReWriteUrl = function (aLink) {
    var linkName = aLink.html();
    linkName = linkName.split('(')[0].replace(/\s/g, '').toLowerCase();
    window.location.hash = linkName;
}

VP.AnchorLinkContainer.prototype.Navigate = function (divId) {
    $(".anchor-nav-container li").find("a[href='" + divId + "']").closest("li").trigger("click");
}
