RegisterNamespace("VP.VideoPlayList");

$(document).ready(function () {
});

VP.VideoPlayList = function (moduleInstanceId, isAutoplayEnabled, autoPlayTimeout, nextVideoText) {
    this.ModuleInstanceId = moduleInstanceId;
    this.IsAutoplayEnabled = isAutoplayEnabled;
    this.AutoPlayTimeout = autoPlayTimeout;
    this.NextVideoText = nextVideoText;
    this.videoIdParam = "videoId";
}

VP.VideoPlayList.prototype.Initialize = function () {
    let vpVideoPlayListContext = this;

    vpVideoPlayListContext.PlayListItems = $(".video-playlist-list-item").map(function (index, item) {
        return {
            Index: index,
            VideoId: $(item).data('brightcove-id'),
            ListItem: $(item)
        };
    });

    $(vpVideoPlayListContext.PlayListItems).each(function(index, item) {
        $(item.ListItem).click(function() {
            vpVideoPlayListContext.PlayVideo(item);
        });
    });



    window.videojs('videoPlayer_' + vpVideoPlayListContext.ModuleInstanceId).ready(function () {
        vpVideoPlayListContext.VideoPlayerElement = $('[id*=videoPlayer_' + vpVideoPlayListContext.ModuleInstanceId + "]");
        vpVideoPlayListContext.BrightCovePlayer = this;
        vpVideoPlayListContext.LoadPlayList();


        if (vpVideoPlayListContext.IsAutoplayEnabled) {
            vpVideoPlayListContext.BrightCovePlayer.on('ended', function () {
                vpVideoPlayListContext.AutoPlayVideo();
            });
        }
    });
};

VP.VideoPlayList.prototype.LoadPlayList = function () {
    const urlParams = new URLSearchParams(window.location.search);
    let videoId = urlParams.get(this.videoIdParam);
    if (!videoId) {
        this.PlayVideo(this.PlayListItems[0]);
    } else {
        let videoToPlay = null;
        $(this.PlayListItems).each(function (index, item) {
            if (item.VideoId == videoId) {
                videoToPlay = item;
                return false;
            }
        });
        if (videoToPlay) {
            this.PlayVideo(videoToPlay);
        }
    }
}

VP.VideoPlayList.prototype.PlayVideo = function (videoToPlay, isAutoPlay) {
    //console.log(videoToPlay);
    let vpVideoPlayListContext = this; 

    let playerDiv = vpVideoPlayListContext.VideoPlayerElement.parent(".video-playlist-video-container");
    vpVideoPlayListContext.ShowHideAutoPlayOverlay(false, playerDiv);

    //don't play video if already paling on autoplay
    if (isAutoPlay) {
        if (!vpVideoPlayListContext.BrightCovePlayer.paused())
            return;
    }


    $(vpVideoPlayListContext.PlayListItems).each(function(index, item) {
        item.ListItem.removeClass("active");
    });
    videoToPlay.ListItem.addClass("active");

    vpVideoPlayListContext.CurrentPlayingVideoIndex = videoToPlay.Index;

    let videoName = videoToPlay.ListItem[0].innerText;
    videoName = vpVideoPlayListContext.escapeSpecialCharactors(videoName);
    let encodedName = encodeURIComponent(videoName);
    window.history.pushState("", "", "?" +"name=" + encodedName + "&" + vpVideoPlayListContext.videoIdParam + "=" + videoToPlay.VideoId );

    vpVideoPlayListContext.BrightCovePlayer.catalog.getVideo(videoToPlay.VideoId, function (error, video) {
        if (error) {
            vpVideoPlayListContext.BrightCovePlayer.pause();  
            let errorMessage = error.data[0].error_code || "Error occured";
            vpVideoPlayListContext.ShowHideAutoPlayOverlay(true, playerDiv, errorMessage);
        } else {
            vpVideoPlayListContext.BrightCovePlayer.catalog.load(video);
            vpVideoPlayListContext.BrightCovePlayer.play();
        }
    });
}


VP.VideoPlayList.prototype.escapeSpecialCharactors = function (str) {
    return str
        .replace(/\s+/g, '-')
        .replace(/&/g, "")
        .replace(/</g, "")
        .replace(/>/g, "")
        .replace(/"/g, "")
        .replace(/\'/g, "")
        .replace(/\$/g, "")
        .replace(/\+/g, "")
        .replace(/\//g, "")
        .replace(/:/g, "")
        .replace(/;/g, "")
        .replace(/=/g, "")
        .replace(/\?/g, "")
        .replace(/@/g, "")
        .replace(/#/g, "")
        .replace(/%/g, "")
        .replace(/{/g, "")
        .replace(/,/g, "")
        .replace(/}/g, "")
        .replace(/\|/g, "")
        .replace(/\\/g, "")
        .replace(/\^/g, "")
        .replace(/~/g, "")
        .replace(/\[/g, "")
        .replace(/]/g, "")
        .replace(/\`/g, "")
        .toLowerCase();
}

VP.VideoPlayList.prototype.AutoPlayVideo = function () {
    let vpVideoPlayListContext = this; 

    let currentVideoIndex = vpVideoPlayListContext.CurrentPlayingVideoIndex;
    let videoToPlay = null;

    $(vpVideoPlayListContext.PlayListItems).each(function (index, item) {
        if (item.Index > currentVideoIndex) {
            videoToPlay = item;
            return false;
        }
    });

    if (!videoToPlay) {
        videoToPlay = vpVideoPlayListContext.PlayListItems[0];
    }
    vpVideoPlayListContext.LoadAutoPlayOverlay(videoToPlay);
}


VP.VideoPlayList.prototype.LoadAutoPlayOverlay = function (videoItem) {
    let vpVideoPlayListContext = this;

    let timeOut =  vpVideoPlayListContext.AutoPlayTimeout;

    if (timeOut > 0) {
        let playerDiv = vpVideoPlayListContext.VideoPlayerElement.parent(".video-playlist-video-container");
        vpVideoPlayListContext.ShowHideAutoPlayOverlay(true, playerDiv);
        setTimeout(function () {
            vpVideoPlayListContext.PlayVideo(videoItem, true);
        },
        (timeOut * 1000));
    } else {
        vpVideoPlayListContext.PlayVideo(videoItem, true);
    }
}

VP.VideoPlayList.prototype.ShowHideAutoPlayOverlay = function (show, parenDiv, errorMsg) {
    let vpVideoPlayListContext = this;
    let timeOutText = errorMsg || vpVideoPlayListContext.NextVideoText;
    let overlayId = "videoOverlay_" + vpVideoPlayListContext.ModuleInstanceId;
    let videoOverlay = $("#" + overlayId);

    if (videoOverlay.length > 0) {
        videoOverlay.remove();
    }

    let overlay = "<div id='" + overlayId + "' class='video-playlist-module-overlay'>'" +
        "<span class='video-playlist-module-overlay-message'> " + timeOutText + " </span>" +
        "</div>";
    videoOverlay = $(overlay);
    parenDiv.append(videoOverlay);

    if (show)
        videoOverlay.show();
    else
        videoOverlay.hide();
}

