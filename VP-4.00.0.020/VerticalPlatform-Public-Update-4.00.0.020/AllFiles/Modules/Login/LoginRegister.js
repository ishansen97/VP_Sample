RegisterNamespace("VP.Forms.LoginRegister");

VP.Forms.LoginRegister.Init = function() {
	$(document).ready(function() {
		//$("#divLoginRegister").tabs();
	});
};

VP.Forms.LoginRegister.Validate = function () {
	var isValid = true;
	var container = $("#divLoginRegister");
	$("#vEmail", container).text("");
	$("#vPassword", container).text("");
	var email = $("input[type=text][id*=txtEmail]", container).val();
	var password = $("input[type=password][id*=txtPassword]", container).val();
	if (email == "") {
		$("#vEmail", container).text("*");
		isValid = false;
	}
	else {
		var regex = new RegExp(VP.EmailRegEx);
		if (!email.match(regex)) {
			isValid = false;
			$("#vEmail", container).text("Not a valid email-address");
		}
	}

	if (password == "") {
		isValid = false;
		$("#vPassword", container).text("*");
	}

	return isValid;
};

VP.Forms.LoginRegister.CheckEmail = function (id, listId) {
    var email = $("#" + id).val();
    if (email != "") {
        var regularExpression = new RegExp("(^([\\w-+]+(?:\\.[\\w-+]+)*(?:[\\+]){0,1})@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([A-Za-z]{2,6}(?:\\.[A-Za-z]{2})?)$)", "i");
        if (email.match(regularExpression)) {
            var isEmailExist = VP.Forms.BaseForm.CheckEmail(email);
            if (isEmailExist) {
                VP.Forms.BaseForm.ClearErrorMessage(listId);
                VP.Forms.BaseForm.AddErrorMessage(listId, "This email is already taken.");
            }
        }
    }
};


VP.Forms.LoginRegister.ShowRegisterTab = function() {
	$(document).ready(function() {
		$("#divLoginRegister").tabs().tabs("option", "active", 1);
	});
};

VP.Forms.LoginRegister.Init();