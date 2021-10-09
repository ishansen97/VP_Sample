
(function ($) {

	$(document).delegate('#notify-close', 'click', function () { $.notify.remove(); });

	$.notify = function (options) {
		var opts = $.extend({}, $.notify.defaults, options);
		var doc, win;
		if (window.parent) {
			win = window.parent;
			doc = window.parent.document;
		}
		else {
			win = window;
			doc = document;
		}

		if (!$("#notify").length) {
			var message = $("<span class=\"notify-content\"/>", doc).addClass(opts.type).html(opts.message);
			var bar = $("<div id=\"notify\"/>", doc).addClass(opts.type).append(message).append("<a id='notify-close'>&nbsp;</a>");
			bar.appendTo($("body", doc)).fadeIn('fast');
			if (opts.time > 0) {
				win.$.notify.timeOut = win.setTimeout("$.notify.remove()", opts.time);
			}
			$("span[id*='show_progress_div']").hide();
		}
		else {
			clearTimeout(win.$.notify.timeOut);
			$("#notify", doc).removeClass().addClass(opts.type);
			$(".notify-content", doc).removeClass().addClass("notify-content " + opts.type).html(opts.message);
			$('#notify').fadeOut('fast').fadeIn('slow');
			if (opts.time > 0) {
				win.$.notify.timeOut = win.setTimeout("$.notify.remove()", opts.time);
			}
			$("span[id*='show_progress_div']").hide();
		}
	};

	$.notify.remove = function () {
		clearTimeout($.notify.timeOut);
		$('#notify').fadeOut('fast', function () {
			$(this).remove();
		});
	};

	$.notify.defaults = {
		type: "error",
		time: 15000
	};

	$(document).ready(function () {
		var s = $.notify.startup;
		if (s) {
			$.notify({ message: s.message, type: s.type });
			$.notify.startup = null;
		}
	});

})(jQuery);