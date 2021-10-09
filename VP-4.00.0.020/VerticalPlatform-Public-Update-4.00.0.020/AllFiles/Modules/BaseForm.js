RegisterNamespace("VP.Forms.BaseForm");

VP.Forms.BaseForm.isAllErrors = true;
VP.Forms.BaseForm.validationPageId = "";

VP.Forms.BaseForm.CheckEmail = function(email) {
	var isEmailExist = false;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/IsUserExist",
		data: "{'email' : '" + email + "','siteId' : '" + VP.SiteId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			isEmailExist = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	return isEmailExist;
};

VP.Forms.BaseForm.Validate = function (isAll, pageId) {
	VP.Forms.BaseForm.isAllErrors = isAll;
	VP.Forms.BaseForm.validationPageId = pageId;
	VP.Forms.BaseForm.ClearAllErrorMessages();
	var isValidate = VP.Forms.BaseForm.ClientValidate();
	if (!isValidate) {
		var errorHtml = $("#" + pageId).find(".hiddenPageError").html();
		if (errorHtml !== undefined && errorHtml !== "") {
			$(".formList").prepend("<li id='errorMessage'>" +
				$("#" + pageId).find(".hiddenPageError").html() +
			"</li>");
		}
		else {
			$("#errorMessage").hide();
		}
	}
	return isValidate;
};

VP.Forms.BaseForm.ValidateField = function(fieldType, controlId, listId, isRequired, requiredErrorMessage,
		shouldMatchRegex, regularExpression, regularExpressionErrorMessage, pageId) {
	var isValidate = true;
	if (isRequired) {
		isValidate = VP.Forms.BaseForm.ValidateRequiredField(fieldType, controlId, listId, requiredErrorMessage, pageId);
	}
	if (isValidate && shouldMatchRegex) {
		isValidate = VP.Forms.BaseForm.ValidateRegularExpressionField(fieldType, controlId, listId,
			regularExpression, regularExpressionErrorMessage, pageId);
	}

	return isValidate;
};

VP.Forms.BaseForm.ValidateFileSize = function (fieldType, controlId, listId, errorMessage, pageId, maxSize) {
	if (VP.Forms.BaseForm.ShouldValidate(controlId, pageId)) {
		return true;
	}
	else {
		return true;
	}
};

VP.Forms.BaseForm.ValidateRequiredField = function(fieldType, controlId, listId, requiredErrorMessage, pageId) {
	switch (fieldType) {
		case 1:
			return VP.Forms.BaseForm.ValidateDropdownInput(controlId, listId, requiredErrorMessage, pageId);
		case 2:
		case 5:
		case 12:
		case 16:
		case 17:
		case 18:
			return VP.Forms.BaseForm.ValidateTextboxInput(controlId, listId, requiredErrorMessage, pageId);
		case 3:
			return VP.Forms.BaseForm.ValidateCheckboxlistInput(controlId, listId, requiredErrorMessage, pageId);
		case 6:
			return VP.Forms.BaseForm.ValidateRadioButtonlistInput(controlId, listId, requiredErrorMessage, pageId);
	}

	return true;
};

VP.Forms.BaseForm.ValidateRegularExpressionField = function(fieldType, controlId, listId, regularExpression,
		regularExpresionErrorMessage, pageId) {
	switch (fieldType) {
		case 2:
		case 5:
		case 12:
			return VP.Forms.BaseForm.ValidateRegularExpression(controlId, listId, regularExpression,
				regularExpresionErrorMessage, pageId);
		case 16:
			return VP.Forms.BaseForm.ValidateFileName(controlId, listId, regularExpression,
				regularExpresionErrorMessage, pageId);
	}

	return true;
};

VP.Forms.BaseForm.ShowPageError = function (error) {
	if (error != undefined && error != "") {
		$(".formList").prepend("<li id='errorMessage'>" + error + "</li>");
	}
	else {
		$("#errorMessage").hide();
	}
};

VP.Forms.BaseForm.ClearAllErrorMessages = function() {
	$(".formList").find("li#errorMessage").remove();
	$(".formList li").removeClass("error").find(".error").remove();
};

VP.Forms.BaseForm.ClearErrorMessage = function(listId) {
	$("#" + listId).removeClass("error").find(".error").remove();
};

VP.Forms.BaseForm.AddErrorMessage = function(listId, errorMessage) {
	if ($("#" + listId + " p.error").length == 0) {
		$("#" + listId).addClass("error").append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		$("#" + listId + " p.error").append("<br />" + errorMessage);
	}
};

VP.Forms.BaseForm.ValidateRegularExpression = function(controlId, listId, regularExpression, errorMessage, pageId) {
	if (VP.Forms.BaseForm.ShouldValidate(controlId, pageId)) {
		var val = $("#" + controlId).val();
		var regex = null;
		try {
			regex = new RegExp(regularExpression);
		}
		catch (err) {
			return true;
		}
		if (val.match(regex) != null) {
			return true;
		}
		else {
			if (errorMessage == "") {
				errorMessage = "Value not in correct format";
			}
			VP.Forms.BaseForm.AddErrorMessage(listId, errorMessage);
			return false;
		}
	}
	else {
		return true;
	}
};

VP.Forms.BaseForm.ValidateFileName = function (controlId, listId, regularExpression, errorMessage, pageId) {
	if (VP.Forms.BaseForm.ShouldValidate(controlId, pageId)) {
		var fpath = $("#" + controlId).val();
		fpath = fpath.replace(/\\/g, '/');
		fpath = fpath.split('/');
		var val = fpath[fpath.length - 1];
		var regex = null;
		try {
			regex = new RegExp(regularExpression);
		}
		catch (err) {
			return true;
		}
		if (val.match(regex) != null) {
			return true;
		}
		else {
			if (errorMessage == "") {
				errorMessage = "Value not in correct format";
			}
			VP.Forms.BaseForm.AddErrorMessage(listId, errorMessage);
			return false;
		}
	}
	else {
		return true;
	}
};

VP.Forms.BaseForm.ShouldValidate = function(controlId, pageId) {
	if (!VP.Forms.BaseForm.isAllErrors) {
		var control = $("#" + VP.Forms.BaseForm.validationPageId + " #" + controlId);
		if (control.length == 0) {
			return false;
		}
	}

	return true;
};

VP.Forms.BaseForm.ValidateTextboxInput = function(controlId, listId, errorMessage, pageId) {
	if (VP.Forms.BaseForm.ShouldValidate(controlId, pageId)) {

		var val = $("#" + controlId).val();
		if (val == "") {
			if (errorMessage == "") {
				errorMessage = "This field is required";
			}
			VP.Forms.BaseForm.AddErrorMessage(listId, errorMessage);
			return false;
		}
		else {
			return true;
		}
	}
	else {
		return true;
	}
};

VP.Forms.BaseForm.ValidateDropdownInput = function (controlId, listId, errorMessage, pageId) {
	if (VP.Forms.BaseForm.ShouldValidate(controlId, pageId)) {
		var complimentControl;
		var val = "";
		var controlOption = $("#" + controlId + ' option:selected');
		if (controlOption.text().toLowerCase() === "other" && controlId !== undefined) {
			var complimentControlId = VP.Forms.BaseForm.GetDropdownComplimentId(controlId);
			if (complimentControlId !== undefined && complimentControlId !== "") {
				complimentControl = $("#" + complimentControlId);
			}
		}

		if (complimentControl !== undefined) {
			val = complimentControl.val();
		}
		else {
			val = $("#" + controlId).val();
		}

		if (val == "") {
			if (errorMessage == "") {
				errorMessage = "This field is required";
			}
			VP.Forms.BaseForm.AddErrorMessage(listId, errorMessage);
			return false;
		}
		else {
			return true;
		}
	}
	else {
		return true;
	}
};

VP.Forms.BaseForm.ValidateCheckboxlistInput = function(controlId, listId, errorMessage, pageId) {
	if (!VP.Forms.BaseForm.isAllErrors) {
		var chk = $("#" + VP.Forms.BaseForm.validationPageId + " #" + listId + " input[type=checkbox]");
		if (chk.length == 0) {
			return true;
		}
	}

	var status = false;
	var chkArray = $("#" + listId + " input[type=checkbox]");
	for (var i = 0; i < chkArray.length; i++) {
		status = $(chkArray[i]).prop('checked') || status;
	}

	if (status == false) {
		if (errorMessage == "") {
			errorMessage = "This field is required";
		}
		VP.Forms.BaseForm.AddErrorMessage(listId, errorMessage);
	}

	return status;
};

VP.Forms.BaseForm.ValidateRadioButtonlistInput = function(controlId, listId, errorMessage, pageId) {
	if (!VP.Forms.BaseForm.isAllErrors) {
		var chk = $("#" + VP.Forms.BaseForm.validationPageId + " #" + listId + " input[type=radio]");
		if (chk.length == 0) {
			return true;
		}
	}

	var status = false;
	var chkArray = $("#" + listId + " input[type=radio]");
	for (var i = 0; i < chkArray.length; i++) {
		status = $(chkArray[i]).prop('checked') || status;
	}

	if (status == false) {
		if (errorMessage == "") {
			errorMessage = "This field is required";
		}
		VP.Forms.BaseForm.AddErrorMessage(listId, errorMessage);
	}

	return status;
};

VP.Forms.BaseForm.RegisterDatePicker = function(datePickerId, startYear, endYear) {
	$(document).ready(function() {
		$("#" + datePickerId).datepicker(
		{
			changeYear: true,
			yearRange: startYear + ':' + endYear
		});
	});
};

VP.Forms.BaseForm.Prev = function(pageId) {
	VP.Forms.BaseForm.ClearAllErrorMessages();
	var pages = $(".formHolder");
	var prevPageId;
	for (var i = 0; i < pages.length; i++) {
		var currentPageId = $(pages[i]).attr('id');
		if (currentPageId == pageId) {
			if (prevPageId != null) {
				VP.Forms.BaseForm.ShowPage(prevPageId);
				break;
			}
		}
		prevPageId = currentPageId;
	}
	return false;
};

VP.Forms.BaseForm.Next = function(pageId) {
	if (VP.Forms.BaseForm.Validate(false, pageId)) {
		var pages = $(".formHolder");
		var isNextPage = false;
		for (var i = 0; i < pages.length; i++) {
			var currentPageId = $(pages[i]).attr('id');
			if (isNextPage) {
				VP.Forms.BaseForm.ShowPage(currentPageId);
				break;
			}
			if (currentPageId == pageId) {
				isNextPage = true;
			}
		}
	}
	return false;
};

VP.Forms.BaseForm.ShowPage = function(pageId) {
	var pages = $(".formHolder");
	for (var i = 0; i < pages.length; i++) {
		if ($(pages[i]).attr('id') == pageId) {
			$(pages[i]).show();
		}
		else {
			$(pages[i]).hide();
		}
	}
};

VP.Forms.BaseForm.ValidateRegistrationConfirmPassword = function(password, confirmPassword, pwdListId, cnfPwdListId) {
	if ($("#" + password).val() == $("#" + confirmPassword).val()) {
		return true;
	}
	else {
		VP.Forms.BaseForm.AddErrorMessage(cnfPwdListId, "Passwords do not match");
		return false;
	}
};

(function($) {
	$.fn.contentPicker = function (options) {
		var defaults = { siteId: 0, contentTypeId: 0, contentIdHolder: null };
		var settings = $.extend({}, defaults, options);
		return this.each(function () {
			var $this = $(this);
			$this.autocomplete({
				minLength: 1,
				source: function (request, response) {
					var url = '/WebServices/AjaxService.asmx/GetContentResult';
					var items = getContent(url, settings.siteId, settings.contentTypeId, request.term);
					response($.map(items, function (item) {
						return { label: item.Name, value: item.Id };
					}));
				},
				select: function (event, ui) {
					$this.val(ui.item.label);
					$("#" + settings.contentIdHolder).val(ui.item.value);
					event.preventDefault();
				}
			});
		});
	};

	function getContent(url, siteId, contentTypeId, searchText) {
		var result;
		$.ajax({
			type: "POST",
			async: false,
			timeout: 3000,
			cache: false,
			url: url,
			data: "{'siteId' : '" + siteId + "', 'contentTypeId' :'" + contentTypeId + "', 'searchText' : '" + searchText + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (data) {
				if (data !== null) {
					result = data.d.Items;
				}
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
			}
		});

		return result;
	}

})(jQuery);


(function($) {
	$.fn.vprating = function (options) {
		var defaults = {ratingValueHolder : ''};
		var settings = $.extend({}, defaults, options);
		return this.each(function () {
			var $this = $(this);
			var rating = $("#" + settings.ratingValueHolder).val();
			if (rating == "")
			{
				rating = 0;
			}
			$this.raty({
				starOff: '/Images/star-off.png',
				starOn: '/Images/star-on.png',
				score: rating,
				halfShow: true,
				hints: ['Ratings', 'Ratings', 'Ratings', 'Ratings', 'Ratings'],
				//width: 150,
				noRatedMsg: 'Ratings',
				click: function(score, evt) {
					$("#" + settings.ratingValueHolder).val(score);
				}
			});
		});
	};
})(jQuery);

VP.Forms.BaseForm.ValidateMaxLength = function (controlId, listId, errorMessage, maxLength) {
	var val = $("#" + controlId).val();
	if (val !== undefined && val.toString().length > maxLength) {
		if (errorMessage == "") {
			errorMessage = "Maximum Allowed Length for This Field Is " + maxLength + " Characters";
		}
		VP.Forms.BaseForm.AddErrorMessage(listId, errorMessage);
		return false;
	}
	else {
		return true;
	}
};

VP.Forms.BaseForm.ShowHideOtherOptionCompliment = function (controlId, complimentId) {
	var controlOption = $("#" + controlId + ' option:selected');
	var compliment = $("#" + complimentId);

	if (controlOption !== undefined && compliment !== undefined) {
		if (controlOption.text().toLowerCase() == "other") {
			compliment.show();
		}
		else {
			compliment.hide();
		}
	}
};

VP.Forms.BaseForm.GetDropdownComplimentId = function (controlId) {
	var complimentId = "";

	if (controlId !== undefined && controlId !== "") {
		var x;
		var splitSegments = controlId.split('_');

		for (x in splitSegments) {
			if (splitSegments[x] == "ctl") {
				complimentId += splitSegments[x].concat("_txt_");
			}
			else {
				if (x == splitSegments.length - 1) {
					complimentId += splitSegments[x];
				}
				else {
					complimentId += splitSegments[x].concat("_");
				}
			}
		}
	}

	return complimentId;
};
