RegisterNamespace("VP.StickyHeader");

$(document).ready(function () {
    var duration = 500;
    $('ul.sticky-anchor-links').find('li').first().addClass('selected');
    $(".sticky-header-back-to-top-link").click(function () {
        $("html, body").animate({ scrollTop: 0 }, duration);
        return false;
    });

    $(".sticky-anchor-links li").click(function (event) {
        li_elements = $(this).siblings("li");
        if (li_elements.hasClass("selected")) {
            li_elements.removeClass("selected");
        }
        $(this).addClass("selected");
        var parentDiv = $(this).closest(".container");
        VP.StickyHeader.prototype.EaseInToDiv(parentDiv, $(this).index());
        VP.StickyHeader.prototype.ReWriteUrl($(this).find("a"));
        return false;
    });

});
VP.StickyHeader = function (moduleInstanceId) {
    this._moduleInstanceId = moduleInstanceId;
};

VP.StickyHeader.prototype.Initialize = function() {
    VP.StickyHeader.prototype.SyncStickyHeaderLinks($("ul.anchor-nav-container li"));
    VP.StickyHeader.prototype.RegisterStickyHeaderScroll($(".anchor-nav-container"));
};

VP.StickyHeader.prototype.EaseInToDiv = function (parentDiv,moduleIndex) {
    //console.log(divID);
    //debugger;
    var sickyHeaderHeight = $(".sticky-header-module>div").height() || 0;

    var childModules = $(parentDiv).find(".module:not(.sticky-header-module)").not($(parentDiv).find(".module .module"));
    var indexedModule = childModules.eq(moduleIndex);

    if (indexedModule) {
        var tp = ($(indexedModule).offset().top) - sickyHeaderHeight;
        $('html, body').animate({
            scrollTop: tp
        }, 1000);
    }
    
};


VP.StickyHeader.prototype.SyncStickyHeaderLinks = function (linkToSynchWith) {
    if (linkToSynchWith && linkToSynchWith.length > 0) {

        //binding links synched with
        linkToSynchWith.click(function() {
            var selectedId = $(this).find("a").attr('id');
            VP.StickyHeader.prototype.hightlightLinkById($(".sticky-header-module ul.sticky-anchor-links"), selectedId);
        });

        //binding sticky header links
        $(".sticky-header-module ul.sticky-anchor-links li").click(function () {
            var selectedId = $(this).find("a").attr('id');
            VP.StickyHeader.prototype.hightlightLinkById(linkToSynchWith, selectedId);
        });

    }
};

VP.StickyHeader.prototype.RegisterStickyHeaderScroll = function (anchorLink) {
    if (anchorLink && anchorLink.length > 0) {
        $(window).scroll(function () {
            if (window.pageYOffset > $('.anchor-nav-container').offset().top) {
                $('#sticky-header-div').addClass("displayStickyHeader");
                $('.anchor-content-body').addClass("displayStickyHeader-anchor");
            } else {
                $('#sticky-header-div').removeClass("displayStickyHeader");
                $('.anchor-content-body').removeClass("displayStickyHeader-anchor");
            }
        });
    }
}


VP.StickyHeader.prototype.hightlightLinkById = function(link, id) {
    link.find("a[id=" + id + "]")
        .parent("li")
        .addClass("selected")
        .siblings("li")
        .removeClass("selected");
};

VP.StickyHeader.prototype.ReWriteUrl = function(aLink) {
    var linkName = aLink.html();
    linkName = linkName.split("(")[0].replace(/\s/g, "").toLowerCase();
    window.location.hash = linkName;
};

