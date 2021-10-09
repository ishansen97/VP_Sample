RegisterNamespace("VP.Login");

VP.Login.ModalDialog = null;
VP.Login.CurrentPageUrl = null;
VP.Login.SiteUrl = null;
VP.Login.PasswordResetPageUrl = null;
VP.Login.RegisterFields = [];
VP.Login.IsValidateAllPages = false;
VP.Login.ValidatePageId = null;
VP.Login.IsLogged = null;
VP.Login.UserProfilePage = null;
VP.Login.UserProfilePageFromCountryFlag = null;
VP.Login.RedirectPageUrl = null;
VP.Login.DefaultAdminContactEmail = null;

VP.Login.Initialize = function () {
	$(document).ready(function () {
		VP.Login.ModalDialog = $("#modalPopup");
		VP.Login.ModalDialog.jqm(
		{
			modal: true
		});
		$(".loginPopup").click(function () {
			if ($(".loginPopup").text() == "Sign In") {
				VP.Login.ShowLoginDialog();
			}
			else {
				VP.Login.Logout();
			}
		});

	    $(".navMenu").on("click", "li[data-on-click='SignIn']", function() {
	        VP.Login.ShowLoginDialog();
	    });
		$(".navMenu").on("click", "li[data-on-click='SignOut']", VP.Login.Logout);
		$(".navMenu").on("click", "li[data-on-click='Register']", VP.Login.ShowRegisterDialog);

		$(".loginlink").click(function () {
			VP.Login.ShowLoginDialog();
		});
		$(".registerPopup").click(function () {
			VP.Login.ShowRegisterDialog();
		});
		$(document).keyup(function (event) {
			if (event.keyCode == 27) {
				VP.Login.HideDialog();
			}
		});
		$(".countryFlag").click(function () {
			if (VP.Login.IsLogged == "true") {
				window.location = VP.Login.UserProfilePageFromCountryFlag;
			}
			else {
				VP.Login.ShowChangeCountry();
			}
		});

		if (VP.Login.GetQueryStringParameter("slp") !== "") {
			setTimeout(function() {
				VP.Login.ShowLoginDialogWithRegisterPageRedirect();
			}, (VP.Login.GetQueryStringParameter("slp") * 1000));
		}
	});
};

VP.Login.GetQueryStringParameter = function (paremeterKey) {
	paremeterKey = paremeterKey.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + paremeterKey + "=([^&#]*)");
	var results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
};

VP.Login.ShowDialog = function (top) {
	VP.Login.ModalDialog.empty();
	VP.Login.ModalDialog.css("top", top);
	VP.Login.ModalDialog.jqmShow();
};

VP.Login.HideDialog = function () {
	VP.Login.ModalDialog.jqmHide();
};

VP.Login.ShowLoginDialog = function (email) {
	VP.Login.ShowDialog("30%");
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetLoginHtml",
		data: "{}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			VP.Login.ModalDialog.append(msg.d);
			VP.Login.SetLoginProperties(email);
			VP.Login.BindToLoginEvents();
			VP.Login.RedirectPageUrl = null;
		}
	});
};

VP.Login.ShowLoginDialogWithRegisterPageRedirect = function (email) {
	VP.Login.ShowDialog("30%");
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetLoginHtml",
		data: "{}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			VP.Login.ModalDialog.append(msg.d);
			VP.Login.SetLoginProperties(email);
			VP.Login.BindToLoginEvents(window.location.pathname);
			VP.Login.RedirectPageUrl = null;
		}
	});
};

VP.Login.ShowLoginDialogWithRedirectUrl = function (redirectUrl) {
	VP.Login.ShowDialog("30%");
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetLoginHtml",
		data: "{}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			VP.Login.ModalDialog.append(msg.d);
			VP.Login.BindToLoginEvents();
			VP.Login.RedirectPageUrl = redirectUrl;
		}
	});
};

VP.Login.ShowRegisterDialog = function () {
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetRegisterUserHtml",
		data: "{'siteId':'" + VP.SiteId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			var redirectUrl = msg.d;
			window.location = redirectUrl;
		}
	});
};

VP.Login.ShowRegisterDialogWithRedirect = function (registerRedirectUrl) {
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetRegisterUserHtmlRedirect",
		data: "{'redirectUrl':'" + registerRedirectUrl + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			var redirectUrl = msg.d;
			window.location = redirectUrl;
		}
	});
};

VP.Login.SetLoginProperties = function (email) {
	if (email != null) {
		$("#txtEmail", VP.Login.ModalDialog).val(email);
		$("#txtPassword", VP.Login.ModalDialog).focus();
	}
	else {
		$("#txtEmail", VP.Login.ModalDialog).focus();
	}
};

VP.Login.SetRegisterProperties = function (pageId) {
	VP.Login.ShowPage(pageId);
	VP.Login.RegisterFields = $("#hiddenFields", VP.Login.ModalDialog).text().split(',');
};

VP.Login.StopEventPropagation = function (event) {
	if (event.stopPropagation) {
		event.stopPropagation();
	}
	else {
		event.cancelBubble = true;
	}
};

VP.Login.BindToLoginEvents = function (registrationPageRedirectUrl) {
	$("div.login", VP.Login.ModalDialog).unbind("keypress").keypress(function (event) {
		VP.Login.KeyPressEvent(event, "btnLogin");
		VP.Login.StopEventPropagation(event);
	});
	$("div.forgotPassword", VP.Login.ModalDialog).unbind("keypress").keypress(function (event) {
		VP.Login.KeyPressEvent(event, "btnForgotPassword");
		VP.Login.StopEventPropagation(event);
	});
	$("#btnLogin", VP.Login.ModalDialog).click(function () {
		VP.Login.ClearPasswordResetControls();
		$("#loginMessage", VP.Login.ModalDialog).text("");
		if (VP.Login.ValidateLogin()) {
			VP.Login.Authenticate();
		}
	});
	$("#btnForgotPassword", VP.Login.ModalDialog).click(function () {
		VP.Login.ClearLoginControls();
		$("#forgotPasswordMessage", VP.Login.ModalDialog).text("");
		if (VP.Login.ValidateResetPassword()) {
			VP.Login.ResetPassword();
		}
	});
	$("#btnRegister", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
		if (registrationPageRedirectUrl !== null && registrationPageRedirectUrl !== undefined) {
			VP.Login.ShowRegisterDialogWithRedirect(registrationPageRedirectUrl);
		}
		else {
			VP.Login.ShowRegisterDialog();
		}
	});
	$("#btnCancelLogin", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
	});
	$("#btnClose", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
	});
};

VP.Login.BindToRegisterEvents = function () {
	VP.Login.ModalDialog.unbind("keypress").keypress(function (event) {
		if (event.which == 13) {
			VP.Login.Register("p_0");
			event.returnValue = false;
			event.cancel = true;
			event.keyCode = 0;
			return false;
		}
	});
	$("#btnSignIn", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
		VP.Login.ShowLoginDialog();
	});
};

VP.Login.KeyPressEvent = function (event, controlIdToClick) {
	if (event.which == 13) {
		$("#" + controlIdToClick, VP.Login.ModalDialog).click();
		event.returnValue = false;
		event.cancel = true;
		event.keyCode = 0;
		return false;
	}
};

VP.Login.ClearPasswordResetControls = function () {
	$("#txtForgotPasswordEmail", VP.Login.ModalDialog).val("");
	$("#rfvForgotPasswordEmail", VP.Login.ModalDialog).text("").css("display", "none");
	$("#forgotPasswordMessage", VP.Login.ModalDialog).text("");
};

VP.Login.ClearLoginControls = function () {
	$("#txtEmail", VP.Login.ModalDialog).val("");
	$("#rfvEmail", VP.Login.ModalDialog).text("").css("display", "none");

	$("#txtPassword", VP.Login.ModalDialog).val("");
	$("#rfvPassword", VP.Login.ModalDialog).text("").css("display", "none");
	$("#loginMessage", VP.Login.ModalDialog).text("");
};

VP.Login.SetCookie = function (loginResult) {
	if (loginResult.Persistance == true) {
		var date = new Date();
		date.setTime(date.getTime() + (loginResult.CookieExpirationPeriod * 24 * 60 * 60 * 1000));
		document.cookie = "VpLogin=" + loginResult.CookieValue + "; path=/;" + "expires=" + date.toGMTString();
	}
	else {
		document.cookie = "VpLogin=" + loginResult.CookieValue + "; path=/;";
	}
};

VP.Login.RedirectToCurrentPage = function () {
    VP.Login.RedirectRelativeURL(VP.Login.CurrentPageUrl);
};

VP.Login.Authenticate = function () {
	$.ajax({
		type: "POST",
		url: VP.AjaxWebServiceUrl + "/Authenticate",
		async: false,
		cache: false,
		data: "{'email':'" + $('#txtEmail', VP.Login.ModalDialog).val() +
			"','password':'" + $('#txtPassword', VP.Login.ModalDialog).val() +
			"','siteId':'" + VP.SiteId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
        success: function (msg) {
            var loginMsg = msg.d.CookieValue.trim().split(";");
            if (loginMsg[0] == 'Locked:False') {
                $("#loginMessage", VP.Login.ModalDialog).text("Incorrect password or email");
                $("#txtPassword", VP.Login.ModalDialog).val("");
            }
            else if (loginMsg[0] == 'Locked:True') {
                var email = VP.Login.DefaultAdminContactEmail;
                if (loginMsg.length > 1 && loginMsg[1].trim().length > 0) {
                    email = loginMsg[1];
                }
                $("#loginMessage", VP.Login.ModalDialog).html("This account has been locked due to multiple failed login attempts. Please send an email to "
                     +"<a href='mailto:"+email+"'>"+email+"</a> to unlock it.");
                //$("#txtPassword", VP.Login.ModalDialog).val("");
            }
			else {
				VP.Login.ClearUserInfo();
				VP.Login.SetCookie(msg.d);
				VP.Login.HideDialog();

				if (VP.Login.RedirectPageUrl == null) {
					VP.Login.RedirectToCurrentPage();
				}
				else {
				    VP.Login.RedirectRelativeURL(VP.Login.CurrentPageUrl);
				}
			}
		}
	});
};

VP.Login.Logout = function () {
	var date = new Date();
	date.setTime(date.getTime() + (-2 * 24 * 60 * 60 * 1000));
	document.cookie = "VpLogin=something; expires=" + date.toGMTString() + "; path=/";
	document.cookie = "VpPartialLogin=something; expires=" + date.toGMTString() + "; path=/";
	VP.Login.ClearUserInfo();

	VP.Login.RedirectRelativeURL(VP.Login.CurrentPageUrl);
};

VP.Login.RedirectRelativeURL = function(urlToRedirect) {
    var regEX = /(^\w+:|^)\/\//;
    var currentUrl = location.href.replace(regEX, '').split("#")[0]; 
    var vpUrl = urlToRedirect.replace(regEX, '').split("#")[0];

    if (currentUrl == vpUrl)
        window.location.reload(true);
    else
        window.location = urlToRedirect;
}

VP.Login.ResetPassword = function () {
	$.ajax({
		type: "POST",
		url: VP.AjaxWebServiceUrl + "/ResetPassword",
		async: false,
		cache: false,
		data: "{'email':'" + $('#txtForgotPasswordEmail', VP.Login.ModalDialog).val() +
			"','siteId' : '" + VP.SiteId +
			"','siteHomeUrl':'" + VP.Login.SiteUrl +
			"','passwordResetUrl':'" + VP.Login.PasswordResetPageUrl + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			$("#forgotPasswordMessage", VP.Login.ModalDialog).text(msg.d);
			$("#txtForgotPasswordUserName", VP.Login.ModalDialog).val("");
			$("#txtForgotPasswordEmail", VP.Login.ModalDialog).val("");
		}
	});
};

VP.Login.Register = function (pageId) {
	if (VP.Login.ValidateRegister(pageId)) {
		var registerFormData = VP.Login.GetRegisterFormData();
		$.ajax({
			type: "POST",
			url: VP.AjaxWebServiceUrl + "/RegisterPublicUser",
			async: false,
			cache: false,
			data: "{\"args\":\"" + registerFormData + "\"}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				var flag = msg.d.CookieValue.charAt(0);
				if (flag == "-") {
					var message = msg.d.CookieValue.substring(1, msg.d.CookieValue.length);
					$("#modalPopup .formList").append("<li id='errorMessage'>" +
						message + "</li>");
				}
				else {
					//create cookie and redirect to the same page again
					VP.Login.ClearUserInfo();
					VP.Login.SetCookie(msg.d);
					VP.Login.HideDialog();
					VP.Login.RedirectToCurrentPage();
				}
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				$(".formList", VP.Login.ModalDialog).append("<li id='errorMessage'>User creation failed. Please try again later</li>");
			}
		});
	}
};

VP.Login.ValidateLogin = function () {
	var isValid = true;
	isValid = VP.Login.ValidateEmail("txtEmail", "rfvEmail") && isValid;
	isValid = VP.Login.ValidateTextBox("txtPassword", "rfvPassword") && isValid;
	return isValid;
};

VP.Login.ValidateResetPassword = function () {
	var isValid = true;
	isValid = VP.Login.ValidateEmail("txtForgotPasswordEmail", "rfvForgotPasswordEmail") && isValid;
	return isValid;
};

VP.Login.ValidateRegister = function (pageId) {
	VP.Login.IsValidateAllPages = true;
	VP.Login.ValidatePageId = pageId;
	return VP.Login.ValidateRegisterFormData();
};

VP.Login.ValidateRegisterPage = function (pageId) {
	VP.Login.IsValidateAllPages = false;
	VP.Login.ValidatePageId = pageId;
	return VP.Login.ValidateRegisterFormData();
};

VP.Login.ValidateRegisterFormData = function () {
	VP.Login.ClearAllErrorMessages();
	var isValidate = VP.Login.ClientValidate();
	if (!isValidate) {

		$(".formList", VP.Login.ModalDialog).prepend("<li id='errorMessage'>" +
			$("#" + VP.Login.ValidatePageId, VP.Login.ModalDialog).find(".hiddenPageError").html() +
			"</li>");
	}
	return isValidate;
};


VP.Login.ValidateEmail = function (textboxId, validatorId) {
	var isValid = VP.Login.ValidateTextBox(textboxId, validatorId);
	if (isValid) {
		isValid = VP.Login.ValidateEmailAddress($("#" + textboxId, VP.Login.ModalDialog).val());
		if (!isValid) {
			$("#" + validatorId, VP.Login.ModalDialog).text("Invalid email").css("display", "inline");
		}
	}

	return isValid;
};

VP.Login.ValidateEmailAddress = function (email) {
	var isValid = false;
	if (email != "") {
		var regex = new RegExp("(^([\\w-+]+(?:\\.[\\w-+]+)*(?:[\\+]){0,1})@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([A-Za-z]{2,6}(?:\\.[A-Za-z]{2})?)$)", "i");
		if (email.match(regex)) {
			isValid = true;
		}
	}

	return isValid;
};

VP.Login.ValidateTextBox = function (textboxId, validatorId) {
	if ($("#" + textboxId, VP.Login.ModalDialog).val() == "") {
		$("#" + validatorId, VP.Login.ModalDialog).text("* Required").css("display", "inline");
		return false;
	}
	else {
		$("#" + validatorId, VP.Login.ModalDialog).css("display", "none");
		return true;
	}
};

VP.Login.PreviousPage = function (pageId) {
	VP.Login.ClearAllErrorMessages();
	var pages = $(".formHolder", VP.Login.ModalDialog);
	var prevPageId = null;
	for (var i = 0; i < pages.length; i++) {
		var currentPageId = $(pages[i]).attr('id');
		if (currentPageId == pageId) {
			if (prevPageId != null) {
				VP.Login.ShowPage(prevPageId);
				page = prevPageId;
				break;
			}
		}
		prevPageId = currentPageId;
	}
	return false;
};

VP.Login.NextPage = function (pageId) {
	if (VP.Login.ValidateRegisterPage(pageId)) {
		var pages = $(".formHolder", VP.Login.ModalDialog);
		var isNextPage = false;
		for (var i = 0; i < pages.length; i++) {
			var currentPageId = $(pages[i]).attr('id');
			if (isNextPage) {
				VP.Login.ShowPage(currentPageId);
				page = currentPageId;
				break;
			}
			if (currentPageId == pageId) {
				isNextPage = true;
			}
		}
	}
	return false;
};

VP.Login.ShowPage = function (pageId) {
	var pages = $(".formHolder", VP.Login.ModalPopup);
	for (var i = 0; i < pages.length; i++) {
		if ($(pages[i]).attr('id') == pageId) {
			$(pages[i]).show();
		}
		else {
			$(pages[i]).hide();
		}
	}
};

VP.Login.ValidateField = function (fieldType, controlId, listId, isRequired, requiredErrorMessage, shouldMatchRegex,
		regularExpression, regularExpressionErrorMessage, pageId) {
	var isValidate = true;
	if (isRequired) {
		isValidate = VP.Login.ValidateRequiredField(fieldType, controlId, listId, requiredErrorMessage, pageId);
	}
	if (isValidate && shouldMatchRegex) {
		isValidate = VP.Login.ValidateRegularExpressionField(fieldType, controlId, listId, regularExpression,
			regularExpressionErrorMessage, pageId);
	}

	return isValidate;
};

VP.Login.ValidateRequiredField = function (fieldType, controlId, listId, requiredErrorMessage, pageId) {
	switch (fieldType) {
		case 1:
			return VP.Login.ValidateDropdownInput(controlId, listId, requiredErrorMessage, pageId);
		case 2:
		case 5:
		case 12:
			return VP.Login.ValidateTextboxInput(controlId, listId, requiredErrorMessage, pageId);
		case 3:
			return VP.Login.ValidateCheckboxlistInput(controlId, listId, requiredErrorMessage, pageId);
	}

	return true;
};

VP.Login.ValidateRegularExpressionField = function (fieldType, controlId, listId, regularExpression,
		regularExpresionErrorMessage, pageId) {
	switch (fieldType) {
		case 2:
		case 5:
		case 12:
			return VP.Login.ValidateRegularExpression(controlId, listId, regularExpression,
				regularExpresionErrorMessage, pageId);
	}

	return true;
};

VP.Login.ClearAllErrorMessages = function () {
	$(".formList", VP.Login.ModalDialog).find("#errorMessage").remove();
	$(".formList li", VP.Login.ModalDialog).removeClass("error").find(".error").remove();
};

VP.Login.ClearErrorMessage = function (listId) {
	$("#" + listId, VP.Login.ModalDialog).removeClass("error").find(".error").remove();
};

VP.Login.AddErrorMessage = function (listId, errorMessage, pageId) {
	if (VP.Login.ModalDialog.find("#" + listId + " p.error").length == 0) {
		VP.Login.ModalDialog.find("#" + listId).addClass("error").append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		VP.Login.ModalDialog.find("#" + listId + " p.error").append("<br />" + errorMessage);
	}
};

VP.Login.ValidateRegularExpression = function (controlId, listId, regularExpression, errorMessage, pageId) {
	if (VP.Login.ShouldValidate(controlId, pageId)) {
		var val = $("#modalPopup #" + controlId).val();
		var regex = null;
		try {
			regex = new RegExp(regularExpression, "i");
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
			VP.Login.AddErrorMessage(listId, errorMessage);
			return false;
		}
	}
	else {
		return true;
	}
};

VP.Login.ShouldValidate = function (controlId, pageId) {
	if (!VP.Login.IsValidateAllPages) {
		var control = $("#" + VP.Login.ValidatePageId + " #" + controlId, VP.Login.ModalDialog);
		if (control.length == 0) {
			return false;
		}
	}

	return true;
};

VP.Login.ValidateTextboxInput = function (controlId, listId, errorMessage, pageId) {
	if (VP.Login.ShouldValidate(controlId, pageId)) {
		var val = $("#" + controlId, VP.Login.ModalDialog).val();
		if (val == "") {
			if (errorMessage == "") {
				errorMessage = "This field is required";
			}
			VP.Login.AddErrorMessage(listId, errorMessage);
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

VP.Login.ValidateDropdownInput = function (controlId, listId, errorMessage, pageId) {
	if (VP.Login.ShouldValidate(controlId, pageId)) {
		var val = $("#" + controlId, VP.Login.ModalDialog).val();
		if (val == "") {
			if (errorMessage == "") {
				errorMessage = "This field is required";
			}
			VP.Login.AddErrorMessage(listId, errorMessage);
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

VP.Login.RegisterDatePicker = function (datePickerId, startYear, endYear) {
	$(document).ready(function () {
		$("#" + datePickerId, VP.Login.ModalDialog).datepicker(
		{
			changeYear: true,
			yearRange: startYear + ':' + endYear
		});
	});
};

VP.Login.ValidateCheckboxlistInput = function (controlId, listId, errorMessage, pageId) {
	var chk = $("#" + pageId + " #" + listId + " #" + controlId + " input[type=checkbox]", VP.Login.ModalDialog);
	if (chk.length == 0) {
		return true;
	}

	var status = false;
	var chkArray = $("#" + listId + " #" + controlId + " input[type=checkbox]", VP.Login.ModalDialog);
	for (var i = 0; i < chkArray.length; i++) {
		status = $(chkArray[i]).attr('checked') || status;
	}

	if (status == false) {
		if (errorMessage == "") {
			errorMessage = "This field is required";
		}
		VP.Login.AddErrorMessage(listId, errorMessage);
	}

	return status;
};

VP.Login.CheckEmail = function (id, listId) {
	var email = $("#" + id, VP.Login.ModalDialog).val();
	if (VP.Login.ValidateEmailAddress(email)) {
		VP.Login.ClearErrorMessage(listId);
		if (email != "") {
			var regex = new RegExp("(^([\\w-+]+(?:\\.[\\w-+]+)*(?:[\\+]){0,1})@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([A-Za-z]{2,6}(?:\\.[A-Za-z]{2})?)$)", "i");
			if (email.match(regex)) {
				$.ajax({
					type: "POST",
					async: false,
					cache: false,
					url: VP.AjaxWebServiceUrl + "/IsUserExist",
					data: "{'email' : '" + email + "','siteId' : '" + VP.SiteId + "'}",
					contentType: "application/json; charset=utf-8",
					dataType: "json",
					success: function (msg) {
						if (msg.d) {
							VP.Login.AddErrorMessage(listId, "This email is already taken. Please provide another");
						}
					}
				});
			}
		}
	}
};

VP.Login.ValidateRegistrationConfirmPassword = function (password, confirmPassword, pwdListId, cnfPwdListId) {
	if ($("#" + password, VP.Login.ModalDialog).val() == $("#" + confirmPassword, VP.Login.ModalDialog).val()) {
		return true;
	}
	else {
		if (VP.Login.ModalDialog.find("#" + cnfPwdListId + " p.error").length == 0) {
			VP.Login.AddErrorMessage(cnfPwdListId, "Passwords do not match");
			$("#" + password, VP.Login.ModalDialog).val("");
			$("#" + confirmPassword, VP.Login.ModalDialog).val("");
			VP.Login.ModalDialog.find("#" + pwdListId).addClass("error");
		}
		return false;
	}
};

VP.Login.GetRegisterFormData = function () {
	var registerFormValues = VP.SiteId;
	var selectedValues;
	for (var i = 0; i < VP.Login.RegisterFields.length; i++) {
		var fieldData = [];
		fieldData = VP.Login.RegisterFields[i].split(":");
		var fieldType = fieldData[2];
		switch (fieldType) {
			case "1":
				if (typeof (registerFormValues) == 'undefined') {
					registerFormValues = fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				else {
					registerFormValues += ";" + fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				break;

			case "2":
				if (typeof (registerFormValues) == 'undefined') {
					registerFormValues = fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				else {
					registerFormValues += ";" + fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				break;

			case "3":
				var checkBoxes = $("#" + fieldData[1] + " .checkbox", VP.Login.ModalDialog);
				selectedValues = '';
				for (var j = 0; j < checkBoxes.length; j++) {
					if (checkBoxes[j].checked) {
						if (!selectedValues) {
							selectedValues = checkBoxes[j].value;
						}
						else {
							selectedValues = selectedValues + "|" + checkBoxes[j].value;
						}
					}
				}

				if (typeof (registerFormValues) == 'undefined') {
					registerFormValues = fieldData[0] + ":" + selectedValues;
				}
				else {
					registerFormValues += ";" + fieldData[0] + ":" + selectedValues;
				}
				break;

			case "5":
				if (typeof (registerFormValues) == 'undefined') {
					registerFormValues = fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				else {
					registerFormValues += ";" + fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				break;

			case "6":
				var radioBtns = $("#" + fieldData[1] + " .radio", VP.Login.ModalDialog);
				for (var k = 0; k < radioBtns.length; k++) {
					if (radioBtns[k].checked) {
						if (typeof (registerFormValues) == 'undefined') {
							registerFormValues = fieldData[0] + ":" + radioBtns[k].value;
						}
						else {
							registerFormValues += ";" + fieldData[0] + ":" + radioBtns[k].value;
						}
					}
				}

				break;

			case "12":
				if (typeof (registerFormValues) == 'undefined') {
					registerFormValues = fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				else {
					registerFormValues += ";" + fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog).val();
				}
				break;

			case "15":
				if (typeof (registerFormValues) == 'undefined') {
					registerFormValues = fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog)[0].checked;
				}
				else {
					registerFormValues += ";" + fieldData[0] + ":" + $("#" + fieldData[1], VP.Login.ModalDialog)[0].checked;
				}
				break;
		}
	}
	return registerFormValues;
};

VP.Login.ShowChangeCountry = function () {
	VP.Login.ShowDialog("5%");
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetChangeCountryPopup",
		data: "{'countryId':'" + VP.Login.CountryId + "','siteId':'" + VP.SiteId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			VP.Login.ModalDialog.append(msg.d);
			VP.Login.BindToChangeCountryEvents();
		}
	});
};

VP.Login.BindToChangeCountryEvents = function () {
	$("#btnSetCountry", VP.Login.ModalDialog).click(function () {
		var countryId = $("#ddlCountry").val();
		VP.Login.SetUserInfo(countryId);
		VP.Login.HideDialog();
		VP.Login.RedirectToCurrentPage();
	});
	$(".exit", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
	});
	$("#btnCancel", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
	});
	$("#lnkRegister", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
		VP.Login.ShowRegisterDialog();
	});
	$("#lnkLogin", VP.Login.ModalDialog).click(function () {
		VP.Login.HideDialog();
		VP.Login.ShowLoginDialog();
	});
};

VP.Login.SetUserInfo = function (countyId) {
	document.cookie = "VpUserInfo=" + countyId + "; path=/";
};

VP.Login.ClearUserInfo = function () {
	var date = new Date();
	date.setTime(date.getTime() + (-2 * 24 * 60 * 60 * 1000));
	document.cookie = "VpUserInfo=sometghing; expires=" + date.toGMTString() + "; path=/";
};

VP.Login.Initialize();
