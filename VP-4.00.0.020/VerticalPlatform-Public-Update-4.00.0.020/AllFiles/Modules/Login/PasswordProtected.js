RegisterNamespace("VP.Forms.PasswordProtected");

VP.Forms.PasswordProtected.Validate = function () {
	var isValid, password, fixedUrlId, cookieValue, message, container;
	container = $("#divPasswordProtected");
	isValid = true;
	password = $("input[type=password][id*=txtPassword]", container).val();
	fixedUrlId = $("input[type=hidden][id*=hdnFixedUrlId]", container).val();
	message = $("input[type=hidden][id*=hdnMessage]", container).val();

	if (password == "") {
		isValid = false;
		$("#lblMessage", container).html(message);
	} else {
		cookieValue = VP.Forms.PasswordProtected.AuthenticateFixedUrlPassword(fixedUrlId, password);
		if (cookieValue != "") {
			VP.Forms.PasswordProtected.SetCookie(fixedUrlId, cookieValue);
			location.reload();
		} else {
			isValid = false;
			$("#lblMessage", container).html(message);
		}
	}

	return isValid;
};

VP.Forms.PasswordProtected.SetCookie = function (key, value) {
	document.cookie = key + "=" + value;
};

VP.Forms.PasswordProtected.AuthenticateFixedUrlPassword = function (fixedUrlId, password) {
	var cookieValue = "";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/AuthenticateFixedUrlPassword",
		data: "{'fixedUrlId' : '" + fixedUrlId + "','password' : '" + password + "', 'siteId' : '" + VP.SiteId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			cookieValue = msg.d;
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	return cookieValue;
};