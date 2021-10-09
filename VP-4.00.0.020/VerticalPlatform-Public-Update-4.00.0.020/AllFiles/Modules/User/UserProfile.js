RegisterNamespace("VP.UserProfile");

$(document).ready(function () {

	var element = $('.country.dropdownList');
	element.stateSelectBox();

	var state = $('.state').val()
	var stateSelect = $('.stateSelect');

	if (stateSelect && state) {
		stateSelect.val(state);
		stateSelect.trigger("change");
	}
});

VP.UserProfile.ValidateLogin = function(emailId, oldPassId, newPassId, confPassId) {
	VP.UserProfile.ClearAllErrorMessages();
	var isValid = true;
	if (!VP.UserProfile.ValidateRequiredField(emailId)) {
		VP.UserProfile.AddErrorMessage(emailId, "Email required");
		isValid = false;
	}
	else {
		if (!VP.UserProfile.ValidateRegularExpression(emailId, VP.EmailRegEx)) {
			VP.UserProfile.AddErrorMessage(emailId, "Email not in correct format");
			isValid = false;
		}
	}

	if (!VP.UserProfile.ValidateRequiredField(oldPassId)) {
		VP.UserProfile.AddErrorMessage(oldPassId, "Old password required");
		isValid = false;
	}

	if (!VP.UserProfile.ValidateRequiredField(newPassId)) {
		VP.UserProfile.AddErrorMessage(newPassId, "New password required");
		isValid = false;
	}
  else {
		var regexPassword = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*.]).{6,25}$";
    if (!VP.UserProfile.ValidateRegularExpression(newPassId, regexPassword)) {
			VP.UserProfile.AddErrorMessage(newPassId, "Password should contain 6-25 characters with atleast one letter, capital letter, number and special character");
			isValid = false;
		}
	}

	if (!VP.UserProfile.ValidateRequiredField(confPassId)) {
		VP.UserProfile.AddErrorMessage(confPassId, "Confirm password required");
		isValid = false;
	}
	else {
		if (!VP.UserProfile.CompareFields(confPassId, newPassId)) {
			VP.UserProfile.AddErrorMessage(confPassId, "Passwords should match");
			isValid = false;
		}
	}

	return isValid;
};

VP.UserProfile.ValidateContactInfo = function(fNameId, lNameId, institution, aLine1, city, state, pCode, country, phnNumber) {
	VP.UserProfile.ClearAllErrorMessages();
	var isValid = true;
	if (!VP.UserProfile.ValidateRequiredField(fNameId)) {
		VP.UserProfile.AddErrorMessage(fNameId, "Firstname required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRequiredField(lNameId)) {
		VP.UserProfile.AddErrorMessage(lNameId, "Lastname required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRequiredField(institution)) {
		VP.UserProfile.AddErrorMessage(institution, "Company / Institution required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRequiredField(aLine1)) {
		VP.UserProfile.AddErrorMessage(aLine1, "Address1 required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRequiredField(city)) {
		VP.UserProfile.AddErrorMessage(city, "City required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRequiredField(state)) {
		VP.UserProfile.AddErrorMessage(state, "State required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRequiredField(pCode)) {
		VP.UserProfile.AddErrorMessage(pCode, "Postalcode required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRequiredField(country)) {
		VP.UserProfile.AddErrorMessage(country, "Country required");
		isValid = false;
	}
	if (!VP.UserProfile.ValidateRegularExpression(phnNumber, "^[0-9+ ()]*$")) {
	    VP.UserProfile.AddErrorMessage(phnNumber, "Enter a valid phone number");
	    isValid = false;
	}

	return isValid;
};

VP.UserProfile.ValidateNickname = function(nicknameId) {
	VP.UserProfile.ClearAllErrorMessages();
	var isValid = true;
	if (!VP.UserProfile.ValidateRequiredField(nicknameId)) {
		VP.UserProfile.AddErrorMessage(nicknameId, "Nickname required");
		isValid = false;
	}
	
	return isValid;
};

VP.UserProfile.ClearAllErrorMessages = function() {
	$("#errLogin").hide();
	$("#errContact").hide();
	$("#errNickname").hide();
	$(".formList").find("li#errorMessage").remove();
	$(".formList li").removeClass("error").find(".error").remove();
};

VP.UserProfile.AddErrorMessage = function(conrolId, errorMessage) {
	var list = $("#" + conrolId).parents("li:eq(0)");
	if ($(list).find("p.error").length == 0) {
		$(list).addClass("error").append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		$(list).find("p.error").append("<br />" + errorMessage);
	}
};

VP.UserProfile.AddSubmitErrorMessage = function(listId, errorMessage, success) {
	$("#" + listId).empty();
	if (success) {
		$("#" + listId).append("<p class=\"success\">" + errorMessage + "</p>");
	}
	else {
		$("#" + listId).append("<p class=\"error\">" + errorMessage + "</p>");
	}

	$("#" + listId).show();
	return false;
};

VP.UserProfile.AddNicknameErrorMessage = function(conrolId, errorMessage) {
	var list = $("#" + conrolId).parents("li:eq(0)");
	if ($(list).find("p.error").length == 0) {
		$(list).addClass("error").append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		$(list).find("p.error").append("<br />" + errorMessage);
	}

	return false;
};

VP.UserProfile.ValidateRequiredField = function(controlId) {
	var value = $("#" + controlId).val();
	if (value == "") {
		return false;
	}
	return true;
};

VP.UserProfile.ValidateRegularExpression = function(controlId, regexText) {
	var val = $("#" + controlId).val();
	var regex = null;
	try {
		regex = new RegExp(regexText);
	}
	catch (err) {
		return true;
	}
	if (val.match(regex) != null) {
		return true;
	}
	return false;
};

VP.UserProfile.CompareFields = function(targetId, compareId) {
	if ($("#" + targetId).val() == $("#" + compareId).val()) {
		return true;
	}
	return false;
};

VP.UserProfile.CheckNickname = function(nicknameId, publicUserId) {
	var nickname = $("#" + nicknameId).val();
	var isValid = true;
	if (VP.UserProfile.ValidateNickname(nicknameId)) {
		VP.UserProfile.ClearAllErrorMessages();
		if (nickname != "") {
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: VP.AjaxWebServiceUrl + "/IsNicknameExist",
				data: "{'nickname' : '" + nickname + "','publicUserId' : '" + publicUserId + "'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(msg) {
					if (msg.d) {
						VP.UserProfile.AddNicknameErrorMessage(nicknameId, "This nickname is already taken. Please provide another.");
						isValid = false;
					}
				}
			});
		}
	}
	else 
	{
		isValid = false;
	}

	return isValid;
};

VP.UserProfile.ShowHideOtherOptionCompliment = function (controlId, complimentId) {
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

function selectUserTab(tabIndex) {
	$("#" + tabIndex).trigger("click");
};