RegisterNamespace("VP.VendorDetail");

VP.VendorDetail.readMoreCollapsedText = "Read More";
VP.VendorDetail.readMoreExpandedText = "Read Less";
VP.VendorDetail.readMoreDescriptionCssClass = ".readmore-desc";
VP.VendorDetail.readMoreLinkCssClass = ".readmore-lnk";
VP.VendorDetail.readMoreLinkCollection = null;

VP.VendorDetail.Init = function () {
	var that = this;
	$(document).ready(function () {
		that.readMoreLinkCollection = $(that.readMoreLinkCssClass);
		if (that.readMoreLinkCollection.length > 0) {
			that.readMoreLinkCollection.each(function () {
				var container = $(this).parent();
				$(this).click(function () {
					that.ExpandReadMoreDescription(event, container);
					that.SetExpanderLinkText(container);
				});
				that.SetExpanderLinkText(container);
			});
		}
	});
};

VP.VendorDetail.ExpandReadMoreDescription = function (e, container) {
	var that = this;
	e.preventDefault();
	var readMoreDesc = container.find(that.readMoreDescriptionCssClass);
	readMoreDesc.slideToggle("slow");
};

VP.VendorDetail.SetExpanderLinkText = function (container) {
	var that = this;
	var readMoreDesc = container.find(that.readMoreDescriptionCssClass);
	var isDescriptionExpanded = readMoreDesc.is(":visible");
	var readMoreLink = container.find(that.readMoreLinkCssClass);
	if (isDescriptionExpanded === true) {
		readMoreLink.text(that.readMoreExpandedText);
	} else {
		readMoreLink.text(that.readMoreCollapsedText);
	}
};

VP.VendorDetail.Init();