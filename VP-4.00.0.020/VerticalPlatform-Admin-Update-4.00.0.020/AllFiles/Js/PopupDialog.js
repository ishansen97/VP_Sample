(function($) {
	$.popupDialog = {
		refreshAfterClose: true,
		callback: null,
		callbackArguments: null,
		redirectUrl: "",
		onShow: function(hash) {
			var $modalWindow = $(hash.w);
			var $trigger = $(hash.t);
			var $modalContainer = $('iframe', $modalWindow);
			var myUrl = $trigger.attr('href');
			if (myUrl) {
				$modalContainer.attr('src', myUrl);
			}
			$modalWindow.show();
		},
		onHide: function(hash) {
			var $modalWindow = $(hash.w);
			var $modalContainer = $('iframe', $modalWindow);
			$modalContainer.html('').attr('src', '').css('height', '0px');
			$modalWindow.fadeOut('2000', function() {
				hash.o.remove();
				if ($.popupDialog.redirectUrl != "") {
					window.document.location.href = $.popupDialog.redirectUrl;
				}
				else if ($.popupDialog.refreshAfterClose == true) {
					window.document.forms[0].submit();
				}

				if ($.popupDialog.callback) {
					$.popupDialog.callback.call(this, $.popupDialog.callbackArguments);
					$.popupDialog.callback = null;
					$.popupDialog.callbackArguments = null;
				}
			});
		},
		close: function() {
			window.parent.$("#popupDialog").jqmHide();
			window.parent.$(".main-wrapper").removeAttr("style");
		},

		openDialog: function(url) {
			$("#popupDialogIframe").attr('src', url);
			$("#popupDialog").jqmShow();

		}
	};

	$(document).ready(function() {
		$("#popupDialog").jqm(
		{
			modal: true,
			overlay: 50,
			trigger: $('.aDialog'),
			target: $('#popupDialogIframe'),
			onHide: $.popupDialog.onHide,
			onShow: $.popupDialog.onShow
		});
		Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
			$("#popupDialog").jqmAddTrigger('.aDialog');
		});
	});

})(jQuery);