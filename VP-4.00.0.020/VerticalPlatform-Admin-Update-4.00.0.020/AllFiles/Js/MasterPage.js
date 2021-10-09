$(document).ready(function () {
	var redirectUrl = "";
	if (VP.RedirectUrl) {
		redirectUrl = VP.RedirectUrl;
	}

	if (VP.IsUserPasswordExpired) {
		var url = VP.ApplicationRoot + "DialogHost.aspx?pconid=42&uid=" + VP.UserId;
		$.popupDialog.openDialog(url);
		$.notify({ message: 'Your password has expired. Please change your password to continue.', type: 'info' });
	} else {
		if (typeof (VP.SiteId) == 'undefined') {
			var url = VP.ApplicationRoot + "DialogHost.aspx?pconid=37&redirectUrl=" + VP.RedirectUrl;
			$.popupDialog.openDialog(url);
		}

		$(".change_site").live('click', function () {
			var url = VP.ApplicationRoot + "DialogHost.aspx?pconid=37&redirectUrl=" + VP.RedirectUrl;
			$.popupDialog.openDialog(url);
		});

		$('.close_message').click(function (event) {
			var id = $(this).attr('id');
			var args = id.split('_');
			var userId = args[0];
			var messageId = args[1];
			var container = $(this).parent();

			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: VP.ApplicationRoot + "Services/AjaxService.asmx" + "/ApplicationMessageView",
				data: "{'userId' : " + userId + ", 'messageId' : " + messageId + "}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (msg) {
					container.slideToggle("slow");
					var count = $(".moreMessages:visible").length;
					if (count == 1) {
						$('#toggleHideMessages').hide();
					}
					var firstThreeMessagecount = $(".firstMessages:visible").length;
					if ((firstThreeMessagecount < 2) && ($('#extraMessages').length > 0)) {
						location.reload();
					}
					if (firstThreeMessagecount == 1 && count > 0) {
						$('#firstThreeMessages').hide();
					}
				},
				error: function (xmlHttpRequest, textStatus, errorThrown) {
				}
			});
		});

		$window = $(window);
		$leftTopBar = $('.main-container .main-left .top-bar');
		$rightTopBar = $('.main-container .main-content .top-bar');

		$leftTopBar.width($('.main-container .main-left').width());
		$rightTopBar.width($('.main-container .main-content').width());

		$window.scroll(function () {
			if ($window.scrollTop() > 1) {
				$leftTopBar.show();
				$rightTopBar.show();
			}
			else {
				$leftTopBar.hide();
				$rightTopBar.hide();
			}
		});
	}
});
