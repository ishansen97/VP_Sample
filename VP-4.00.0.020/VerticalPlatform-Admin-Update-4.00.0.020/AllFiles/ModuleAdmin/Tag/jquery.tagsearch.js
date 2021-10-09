(function($) {
	$.fn.tagSearch = function(options) {

		var defaults = {
			title: 'tag search',
			closeButton: true
		};

		$(document).mousedown(checkExternalClick);

		options = $.extend(defaults, options);

		return this.each(function() {
			var elm = $(this);
			elm.focus(function() {
				var felm = $(this);
				if (activeElement == null) {
					searchWidget(felm);
				}
				else if (activeElement != null && felm.attr('id') != activeElement.attr('id')) {
					removeSearchWidget();
					searchWidget(felm);
				}
			});
		});
	};

	function searchWidget(elm) {
		activeElement = elm;
		var position = elm.position();
		var left = position.left;
		var browserHeight = document.documentElement.clientHeight;
		var top = position.top + 20;
		var html = "<div id='tagdialog' style='position:absolute;top:" + top + "px;left:" + left + "px;" +
			"' class='tagSearch_window'><div id='tagsearch'>" +
			"<div class='form-horizontal'>" +
			"<div class='control-group'>" +
			"<label class='control-label'>Content Type </label> " +
			"<div class='controls'><select id='selContentType'>" +
			"<option value='1'>Category</option><option value='2'>Product</option><option value='11'>Tag</option>" +
			"</select></div></div>" +
			"<div class='control-group'>" +
			"<label class='control-label'>Content Text</label>" +
			"<div class='controls'><input type='text' id='content' style='width:135px;' /></div></div>" +
			"<div class='control-group'>" +
			"<label class='control-label'>Content ID</label>" +
			"<div class='controls'><div class='inline-form-container'><input type='text' id='contentId' style='width:80px;' /> " +
			"<input type='button' id='btnContentId' value='Set' class='btn'/></div>" +
			"<div></div>" +
			"</div>" +
			"</div><div class='tagSearchButton'><a id='close' class='btn'>close</a></div></div>";
		$('body').append(html);
		$('#tagsearch #content').autocomplete({
			delay: 600,
			minLength: 2,
			source: getValues,
			select: setValue
		});

		$('#tagsearch #btnContentId').click(function() {
			var contentType = $('#tagsearch #selContentType').val();
			var contentId = $('#tagsearch #contentId').val().trim();
			if (contentId != '') {
				var webMethod = VP.AjaxWebServiceUrl + "/GetContent";
				if (!isNaN(contentId)) {
					$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: webMethod,
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'siteId':" + VP.SiteId + ",'contentType':" + contentType + ",'contentId':" + contentId + "}",
						success: function(msg) {
							if (msg.d != null) {
								var item = msg.d;
								var contentTypeValue = $('#tagsearch #selContentType option:selected').text();
								var value = "ContentType=" + contentTypeValue + ";Name=" + item.Name + ";Id=" + item.Id;
								activeElement.val(value);
								removeSearchWidget();
							}
							else {
								$.notify({ message: 'Invalid Content Id.', type: 'error' });
							}
						},
						error: function(xmlHttpRequest, textStatus, errorThrown) {
							document.location(VP.ErrorPage);
						}
					});
				}
				else {
					$.notify({ message: 'Content id should be numeric value.', type: 'error' });
				}
			}
			else {
				$.notify({ message: 'Please enter content Id.', type: 'error' });
			}
		});

		$('#tagdialog .close').click(removeSearchWidget);
	}

	function getValues(request, response) {
		var list = [];
		var contentType = $('#tagsearch #selContentType').val();
		var webMethod = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: webMethod,
			dataType: "json",
			contentType: "application/json; charset=utf-8",
			data: "{'siteId' :" + VP.SiteId + ",'contentType' : '" + contentType + "', 'searchText' : '" + request.term + "', 'enabled' :" + null + "}",
			success: function(msg) {
				list = $.map(msg.d, function(item) {
					return {
						value: "Name=" + item.Name + ";Id=" + item.Id,
						label: item.Name + "(id=" + item.Id + ")"
					};
				});
			},
			error: function(xmlHttpRequest, textStatus, errorThrown) {
				document.location(VP.ErrorPage);
			}
		});

		response(list);
	}

	function setValue(event, ui) {
		var contentType = $('#tagsearch #selContentType option:selected').text();
		var value = "ContentType=" + contentType + ";" + ui.item.value;
		activeElement.val(value);
		removeSearchWidget();
	}

	function removeSearchWidget() {
		$('#tagdialog').remove();
		activeElement = null;
	}

	function checkExternalClick(event) {
		var target = $(event.target);
		if (activeElement != null) {
			if ((target.attr('id') != activeElement.attr('id')) &&
					(target.attr('id') != 'tagsearch') &&
					(target.parents('#tagsearch').length == 0) &&
					(target.attr('class').indexOf("ui-corner-all") == -1)) {

				removeSearchWidget();
			}
		}
	}

	var activeElement;

})(jQuery);
