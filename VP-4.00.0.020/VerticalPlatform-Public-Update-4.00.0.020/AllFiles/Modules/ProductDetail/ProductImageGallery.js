// JavaScript Document
//slide viewer pro
$(document).ready(
function () {
	$("div.multimediaGallery", "div.multimediaGalleryContainer").slideViewerPro({
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
		leftButtonInner: "<img src='../../Media/1/Images/galleryLeftArrow.gif' title='Click to see the previous image.' alt='View more thumbnails'/>",
		rightButtonInner: "<img src='../../Media/1/Images/galleryRightArrow.gif' title='Click to see the next image.' alt='View more thumbnails'/>",
		shuffle: false
	});

	$("div.multimediaGallery", "div.multimediaGalleryContainer").each(function (n) {
		var container = $(this);
		container.next("div").find('li', 'div.thumbSlider').each(function (m) {
			var bcovId = $($("ul li", container)[m]).attr('id');
			if (bcovId) {
				if (m == 0) {
					setVideoTrackingValues(bcovId);
				}

				$("a", this).click(function () {
					setVideoTrackingValues(bcovId);
				});
			}
		});
	});
	//after gallery is created, insert any videos
	insertVideos();

	function insertVideos() {
		//if the content should be video and not an image, look for video class
		jQuery("div.slideViewer").find("li.video").each(function (n) {
			var brightcoveID = "" + $(this).attr("id") + "";
			var shareLink = window.location;

			var brightcoveEmbed = "<div style='width:400px; margin:0; padding:0'><div style='display:none; margin:0; padding:0'></div><video ";
			brightcoveEmbed += "data-video-id='" + brightcoveID + "'";
			brightcoveEmbed += "data-player='rJdqBIjfl' ";
			brightcoveEmbed += "data-embed='default' ";
			brightcoveEmbed += "data-application-id ";
			brightcoveEmbed += "class='video-js' ";
			brightcoveEmbed += "width='400' ";
			brightcoveEmbed += "height='300' ";
			brightcoveEmbed += "controls>";

			brightcoveEmbed += "</video><script src='//players.brightcove.net/2135351001/rJdqBIjfl_default/index.min.js' async></script></div>";

			$(this).find("img").replaceWith(brightcoveEmbed);
		});

		//after videos are created, insert any colorbox links
		addQtipLinks();
	}

	function addQtipLinks() {
		$('a.popup2').each(function (i, domElement) {
			var values = $(domElement).attr('class').split(" ");
			var width = Number(values[1].slice(1, values[1].length)) + 15 * 2;
			var height = Number(values[2].slice(1, values[2].length)) + 15 * 2;
			var title = $(domElement).find('img').attr('alt');
			$(domElement).qtip(
			{
				id: 'modal',
				content: {
					text: "<iframe id='qtipIframe' scrolling='yes' name='iframe_" + new Date().getTime() + "' frameborder=0 src='" + $(this).attr('href') + "' />",
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
});

//brightcove waits for players to instantiated
var playerNum = 0;
var i = 0;

// called when template loads, this function stores a reference to the player and modules.
function onTemplateLoaded(experienceID) {

	//make unique variables to access player API for each video
	window["bcExp" + playerNum] = brightcove.getExperience(experienceID);
	window["modVP" + playerNum] = window["bcExp" + playerNum].getModule(APIModules.VIDEO_PLAYER);

	playerNum++;
}

function stopAllVideos() {
	for (i = 0; i < playerNum; i++) {
		window["modVP" + i].stop();
	}
}

function setVideoTrackingValues(brightCoveId) {
	if (s != undefined) {
		s.eVar25 = 0;
		s.eVar26 = brightCoveId;
	}
}