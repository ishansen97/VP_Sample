RegisterNamespace("VP.Unsubscription");

$(document).ready(function () {
	var reason = new VP.Unsubscription.Reason();
});

VP.Unsubscription.Reason = function () {
	VP.Unsubscription.Reason.BindToUnsubscriptionReasonEvent();
	VP.Unsubscription.Reason.BindToUnsubscriptionSubmitEvent();
};

VP.Unsubscription.Reason.BindToUnsubscriptionReasonEvent = function () {
	$('.rbFeedback').click(function () {
		$("#feedbacktext").val("");
		$("#vField").text("");
		$("#feedbacktext").attr("disabled", "disabled");

		if ($('input:radio[name=feedback]:checked').val() == "Other (fill in reason below)") {
			$("#feedbacktext").removeAttr("disabled");
		}
	});
};

VP.Unsubscription.Reason.BindToUnsubscriptionSubmitEvent = function () {
	$("#btnSubmitSubscriptionReason").click(function () {
		if (VP.Unsubscription.Reason.ValidateReason()) {
			VP.Unsubscription.Reason.SaveUnsubscriptionReason();
			location.href = location.href.split('?')[0];
		}
	});
};

VP.Unsubscription.Reason.ValidateReason = function () {
	var isValid = true;
	$("#unsubscriptionError").text("");
	if ($('input:radio[name=feedback]:checked').val() == "Other (fill in reason below)") {
		if ($("#feedbacktext").val() == "") {
			$("#unsubscriptionError").text("Please fill in the reason below.");
			isValid = false;
		}

	}
	return isValid;
}

VP.Unsubscription.Reason.SaveUnsubscriptionReason = function () {
	var feedback = null;
	publicUserId = $("#hdnPublicUserId").val();
	if (publicUserId != undefined && publicUserId != "") {
		var feedback = null;
		if ($('input:radio[name=feedback]:checked').val() == "Other (fill in reason below)") {
			feedback = $("#feedbacktext").val();
		}
		else {
			feedback = $('input:radio[name=feedback]:checked').val();
		}

		$.ajax({
			type: "POST",
			dataType: "json",
			async: false,
			url: VP.AjaxWebServiceUrl + "/SaveUnsubscriptionReasonForPublicUser",
			data: "{'feedback':'" + feedback + "','publicUserId':'" + publicUserId + "'}",
			contentType: "application/json; charset=utf-8",
			success: function (msg) {
			}
		});
	}
};

