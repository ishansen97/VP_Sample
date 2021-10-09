(function ($) {

	$.imageGallery = function (options) {
		$(document).ready(function () {

			$("div.reviewItemGallery", "div.reviewItemGalleryContainer").slideViewerPro({
				thumbs: 5,
				autoslide: false,
				asTimer: 3500,
				typo: true,
				galBorderWidth: 0,
				thumbsBorderOpacity: 0,
				buttonsTextColor: "#707070",
				buttonsWidth: 40,
				thumbsActiveBorderOpacity: 0.8,
				thumbsActiveBorderColor: "#0E82C7",
				thumbsPercentReduction: 15,
				shuffle: false
			});

			if ($('img.oneImage').length > 0 && $('img.oneImage').attr('src').indexOf('-400x300') < 0) {
				$('img.oneImage').qtip({
					content: {
						text: function (api) {
							return '<img src="' + getImagePath($(this).attr('src')) + '" width="400" height="300" />';
						}
					},
					position: {
						my: "left center",
						at: "right center",
						viewport: true
					},
					show: {
						solo: true
					},
					style: {
						tip: true,
						classes: "ui-tooltip-light ui-tooltip-rounded"
					},
					prerender: true
				});
			}


			addQtipLinks();

			$('.slideViewer ul li').each(function (i, domElement) {

				$(domElement).append('<span class="icon zoom compact">Zoom In</span>');
				$(domElement).hover(function (event) {
					$(event.currentTarget).find('.zoom').fadeIn(200);
				}, function (event) {
					$(event.currentTarget).find('.zoom').fadeOut(200);
				});

				var newImagePath = $(domElement).find('img').attr('src');
				var newImage = '<a href="#"><img src="' + newImagePath + '" width=400 height=300></a>';
				var tipContent = '<div class="zoomedContent"><div class="image">' +
						newImage + '</div></div>';
				var textTop = $(domElement).find('img').attr('alt');

				$(domElement).find('img').qtip(
					{
						content: {
							title: {
								text: textTop,
								button: "Close"
							},
							text: tipContent
						},
						position: {
							my: "left center",
							at: "right center"
						},
						show: {
							delay: 0,
							solo: true,
							event: false
						},
						hide: {
							event: "unfocus"
						},
						style: {
							tip: true,
							classes: "ui-tooltip-light ui-tooltip-rounded"
						},
						prerender: false
					});

				$(domElement).find('.zoom').click(function (event) {
					$(event.currentTarget).parent("li").find('img').qtip("show");
				});
			});
		});
	};

	function getImagePath(rowImagePath) {
		var imageSize = "-400x300";
		var paths = rowImagePath.split('/');
		var imageNameParts = paths[paths.length - 1].split('.');
		var previousImageName = imageNameParts[0];
		var imageExtension = imageNameParts[1];
		var itemName = (previousImageName.split('-'))[0];
		var zoomImagePath = "";
		for (var i = 0; i < paths.length - 1; i++) {
			zoomImagePath = zoomImagePath + paths[i] + "/";
		}
		zoomImagePath = zoomImagePath + itemName + imageSize + "." + imageExtension;
		return zoomImagePath;
	}

	function addQtipLinks() {
		$('a.popup').each(function (i, domElement) {
			var values = $(domElement).attr('class').split(" ");
			var width = Number(values[1].slice(1, values[1].length)) + 15 * 2;
			var height = Number(values[2].slice(1, values[2].length)) + 15 * 2;
			var title = $(domElement).find('img').attr('alt');
			$(domElement).qtip(
			{
				id: 'modal',
				content: {
					text: "<iframe id='qtipIframe' scrolling='yes' name='iframe_" + new Date().getTime() +
					"' frameborder=0 src='" + $(this).attr('href') + "' " +
					"width=" + width + "px height=" + height + "px />",
					title: {
						text: title,
						button: true
					}
				},

				position: {
					my: 'center',
					at: 'center',
					target: $(window)
				},
				show: {
					event: 'click',
					solo: true,
					modal: true,
					delay: 0
				},
				hide: false,
				style: 'ui-tooltip-light ui-tooltip-rounded tooltip-iframe-page'

			}).click(function () {
				return false;
			});
		});
	}
})(jQuery);

$.imageGallery();
