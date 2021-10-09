﻿RegisterNamespace("VP.ProductSharing");

$(document).ready(function () {
	var tool = new VP.ProductSharing();
});

VP.ProductSharing = function () {
	var that = this;
	this._webServiceUrl = VP.AjaxWebServiceUrl;
	this._modalPopup = $("#modalPopup");
	this._modalPopup.jqm(
	{
		modal: true
	});

	$(".ProductEmailShare").click(function () {
		that.ClearErrorMessage("txtFromEmail");
		that.ClearErrorMessage("txtToEmail");
		that.ClearErrorMessage("txtMessage");
		that.ClearErrorMessage("txtUsername");
		that.ShowEmailPopUp($(this).parent());
	});
};

VP.ProductSharing.prototype.EmailToFriend = function (productId, element) {
	var that = this;

	var fromEmail = $("#txtFromEmail").val();
	var toEmails = $("#txtToEmail").val();
	var message = $("#txtMessage").val();
	var name = $("#txtUsername").val();
	var url = $("input[id$='hdnProductUrl']")[0].value.toString();

	$.ajax({
		type: "POST",
		url: that._webServiceUrl + "/SendProductToFriendViaEmail",
		data: "{'fromEmail':'" + fromEmail + "','toEmails':'" + toEmails + "','message':'" + message +
			"','name':'" + name + "','productId':'" + productId +
			"','siteId':'" + VP.SiteId + "','url': '" + escape(url) + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		async: true,
		success: function (msg) {
			that._modalPopup.empty();
			that._modalPopup.jqmHide();
		}
	});
};

VP.ProductSharing.prototype.ShowEmailPopUp = function (element) {
	var that = this;
	var privacyPolicyHtml = '';
	if ($($("input[id$='hdnPrivacyPolicy']")[0])) {
		privacyPolicyHtml = $($("input[id$='hdnPrivacyPolicy']")[0]).val();
		//decode html
		privacyPolicyHtml = $('<div/>').html(privacyPolicyHtml).text();
	}
	var html = '<div class="formHolder leftLabel">' +
						'<h1>Email Product</h1>' +
						'<div class="close">' +
							'<input id="btnClose" class="closeButton" type="button" value="X">' +
						'</div>' +
						'<ul class="formList">' +
							'<li  id="litxtUsername">' +
								'<label class="description">Your Name</label>' +
								'<div class="inputElements module">' +
									'<input type="text" id="txtUsername" class="textbox large">' +
									'<span class="required">*</span>' +
								'</div>' +
							'</li>' +
							'<li id="litxtFromEmail">' +
								'<label class="description">Your Email Address</label>' +
								'<div id="divtxtFromEmail" class="inputElements module">' +
									'<input type="text" id="txtFromEmail" class="textbox large">' +
									'<span class="required">*</span>' +
								'</div>' +
							'</li>' +
							'<li id="litxtToEmail">' +
								'<label class="description">Recipient(s) Email Addresses</label>' +
								'<div id="divtxtToEmail" class="inputElements module">' +
									'<input type="text" id="txtToEmail" class="textbox large">' +
									'<span class="required">*</span>' +
								'</div>' +
							'</li>' +
							'<li id="litxtMessage">' +
								'<label class="description">Message</label>' +
								'<div id="divtxtMessage" class="inputElements module">' +
									'<textarea id="txtMessage"></textarea>' +
									'<span class="required">*</span>' +
								'</div>' +
							'</li>' +
							'<li>' +
								'<div id="inputElements" class="inputElements">' +
									'<input type="button" id="btnEmailToFriendDummy" class="button" value="Send">' +
									'<input type="button" id="btnCancelEmailToFriend" class="button cancel" value="Cancel">' +
									'<input type="button" id="btnEmailToFriend" class="hiddenButton" /><br/>' +
								'</div>' +
							'</li>' +
							 privacyPolicyHtml +
						'</ul>' +
				'</div>';

	this._modalPopup.empty();
	this._modalPopup.append(html);

	$("#btnEmailToFriend").click(function () {
		that.EmailToFriend($("input[id$='hdnProductId']")[0].value.toString(), element);
	});

	$("#btnEmailToFriendDummy").click(function () {
		$("#btnEmailToFriendDummy").attr('disabled', 'disabled').addClass('disabled');
		$("#inputElements").prepend("<div class='InProgress'></div>");

		if (that.Validate()) {
			$("#btnEmailToFriend").click();
		}
		else {
			$(".InProgress", "#inputElements").remove();
			$("#btnEmailToFriendDummy").removeAttr('disabled').removeClass('disabled');
		}
	});

	$("#btnCancelEmailToFriend").click(function () {
		that._modalPopup.empty();
		that._modalPopup.jqmHide();
	});

	$("#btnClose").click(function () {
		that._modalPopup.empty();
		that._modalPopup.jqmHide();
	});

	this.FillEmailToFriendDetails();
	this._modalPopup.jqmShow();
};

VP.ProductSharing.prototype.Validate = function () {
	this.ClearErrorMessage("txtFromEmail");
	this.ClearErrorMessage("txtToEmail");
	this.ClearErrorMessage("txtMessage");
	this.ClearErrorMessage("txtUsername");

	var isvalied = true;
	isvalied = this.RequiredFieldValidator("txtFromEmail") && isvalied;
	isvalied = this.RequiredFieldValidator("txtToEmail") && isvalied;
	isvalied = this.RequiredFieldValidator("txtMessage") && isvalied;
	isvalied = this.RequiredFieldValidator("txtUsername") && isvalied;
	isvalied = this.EmailsValidator("txtFromEmail") && isvalied;
	isvalied = this.EmailsValidator("txtToEmail") && isvalied;
	return isvalied;
};

VP.ProductSharing.prototype.RequiredFieldValidator = function (control) {
	if ($("#" + control).val() !== '') {
		return true;
	}
	this.AddErrorMessage(control, "Required field");
	return false;
};

VP.ProductSharing.prototype.EmailsValidator = function (control) {
	var emails = $("#" + control).val();
	var emailArray = emails.split(',');
	for (var i = 0; i < emailArray.length; i++) {
		//var regularExpression = new RegExp("(^[\_]*([a-z0-9]+(\.|\_*)?)+@([a-z][a-z0-9\-]+(\.|\-*\.))+[a-z]{2,6}$)", "i");
		var regularExpression = new RegExp("(^[a-z]([a-z0-9_\\.\\!\\#\\$\\%\\&\\*\\+\\-\\/\\=\\?\\^\\`\\{\\|\\}\\~]*)@([a-z0-9_\\-\\.]*)([.][a-z]{3})$)|(^[a-z]([a-z_\\.\\!\\#\\$\\%\\&\\*\\+\\-\\/\\=\\?\\^\\`\\{\\|\\}\\~]*)@([a-z0-9_\\-\\.]*)(\\.[a-z]{3})(\\.[a-z]{2})*$)", "i");
		var email = emailArray[i].trim();
		if (!email.match(regularExpression)) {
			this.AddErrorMessage(control, "Invalid email address");
			return false;
		}
	}
	return true;
};

VP.ProductSharing.prototype.ClearErrorMessage = function (listId) {
	$("#li" + listId).removeClass("error").find(".error").remove();
};

VP.ProductSharing.prototype.AddErrorMessage = function (listId, errorMessage) {
	if ($("#li" + listId + " p.error").length === 0) {
		$("#li" + listId).addClass("error").append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		$("#li" + listId + " p.error").append("<br />" + errorMessage);
	}
};

VP.ProductSharing.EmailToFriendWithComment = function (commentId, element) {
	var tool = new VP.ProductSharing();
	tool.ShowEmailPopUp($(element).parent());
};

VP.ProductSharing.prototype.FillEmailToFriendDetails = function () {
	var userInfo = $("input[id$='hdnUserInfo']")[0].value;
	if (userInfo !== "") {
		var userInfoArray = userInfo.split('|');
		var userId = userInfoArray[0];
		var userName = userInfoArray[1];
		$("#txtUsername").val(userName);
		this.GetUserEmail(userId);
	}
};

VP.ProductSharing.prototype.GetUserEmail = function (userId) {
	var that = this;
	$.ajax({
		type: "POST",
		url: that._webServiceUrl + "/GetUserEmail",
		data: "{'userId':'" + userId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			$("#txtFromEmail").val(msg.d);
		}
	});
};

if (typeof String.prototype.trim !== 'function') {
	String.prototype.trim = function () {
		return this.replace(/^\s+|\s+$/g, '');
	};
}