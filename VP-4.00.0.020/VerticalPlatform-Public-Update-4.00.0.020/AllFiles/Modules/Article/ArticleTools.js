RegisterNamespace("VP.ArticleTools");

$(document).ready(function() {
	var tool = new VP.ArticleTools();
});

VP.ArticleTools = function() {
	var that = this;
	this._commentId = "";
	this._webServiceUrl = VP.AjaxWebServiceUrl;
	this._modalPopup = $("#modalPopup");
	this._modalPopup.jqm(
	{
		modal: true
	});

	$(".articleToolsEmail").click(function() {
		that.ClearErrorMessage("txtFromEmail");
		that.ClearErrorMessage("txtToEmail");
		that.ClearErrorMessage("txtMessage");
		that.ClearErrorMessage("txtUsername");
		that._commentId = '';
		that.ShowEmailPopUp($(this).parent());
	});

	$(".articleToolsBookmark").click(function() {
		that.CreateBookmarkLink();
	});

	$(".articleToolsPrint").click(function() {
		that.GetPrinterFriendlyArticleHtml();
	});
};

VP.ArticleTools.prototype.EmailToFriend = function (articleId, element) {
	var that = this;

	var fromEmail = $("#txtFromEmail").val();
	var toEmails = $("#txtToEmail").val();
	var message = $("#txtMessage").val();
	var name = $("#txtUsername").val();
	var url = window.location.href;

	if (window.location.href.substr(0, window.location.href.indexOf('#disqus_thread')) != "") {
		url = window.location.href.substr(0, window.location.href.indexOf('#disqus_thread'));
	}

	$.ajax({
		type: "POST",
		url: that._webServiceUrl + "/SendEmailToFriend",
		data: "{'fromEmail':'" + fromEmail + "','toEmails':'" + toEmails + "','message':'" + message +
			"','name':'" + name + "','articleId':'" + articleId + "','commentId':'" + that._commentId +
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

VP.ArticleTools.prototype.ShowEmailPopUp = function(element) {
	var that = this;
	var privacyPolicyHtml = '';
	if ($($("input[id$='hdnPrivacyPolicy']")[0])) {
		privacyPolicyHtml = $($("input[id$='hdnPrivacyPolicy']")[0]).val();
		//decode html
		privacyPolicyHtml = $('<div/>').html(privacyPolicyHtml).text();
	}
	var html = '<div class="formHolder leftLabel emailArticle">' +
						'<h1>Email Article</h1>' +
						'<div class="close">' +
							'<input id="btnClose" class="closeButton" type="button" value="X">' +
						'</div>' +
						'<ul class="formList">' +
							'<li  id="litxtUsername">' +
								'<label class="description">Your Name</label>' +
								'<span class="required">*</span>' +
								'<div class="inputElements module">' +
									'<input type="text" id="txtUsername" class="textbox large">' +
								'</div>' +
							'</li>' +
							'<li id="litxtFromEmail">' +
								'<label class="description">Your Email Address</label>' +
								'<span class="required">*</span>' +
								'<div id="divtxtFromEmail" class="inputElements module">' +
									'<input type="text" id="txtFromEmail" class="textbox large">' +
								'</div>' +
							'</li>' +
							'<li id="litxtToEmail">' +
								'<label class="description">Recipient(s) Email Addresses</label>' +
								'<span class="required">*</span>' +
								'<div id="divtxtToEmail" class="inputElements module">' +
									'<input type="text" id="txtToEmail" class="textbox large">' +
								'</div>' +
							'</li>' +
							'<li id="litxtMessage">' +
								'<label class="description">Message</label>' +
								'<span class="required">*</span>' +
								'<div id="divtxtMessage" class="inputElements module">' +
									'<textarea id="txtMessage"></textarea>' +
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

	$("#btnEmailToFriend").click(function() {
		that.EmailToFriend($("input[id$='hdnArticleId']")[0].value, element);
	});

	$("#btnEmailToFriendDummy").click(function() {
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

	$("#btnCancelEmailToFriend").click(function() {
		that._modalPopup.empty();
		that._modalPopup.jqmHide();
	});
	
	$("#btnClose").click(function() {
		that._modalPopup.empty();
		that._modalPopup.jqmHide();
	});

	this.FillEmailToFriendDetails();
	this._modalPopup.jqmShow();
};

VP.ArticleTools.prototype.Validate = function() {
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

VP.ArticleTools.prototype.RequiredFieldValidator = function(control) {
	if ($("#" + control).val() != '') {
		return true;
	}
	this.AddErrorMessage(control, "Required field");
	return false;
};

VP.ArticleTools.prototype.EmailsValidator = function(control) {
	var emails = $("#" + control).val();
	var emailArray = emails.split(',');
	for (var i = 0; i < emailArray.length; i++) {
		var regularExpression = new RegExp("(^([\\w-+]+(?:\\.[\\w-+]+)*(?:[\\+]){0,1})@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([A-Za-z]{2,6}(?:\\.[A-Za-z]{2})?)$)", "i");
		var email = emailArray[i].trim();
		if (!email.match(regularExpression)) {
			this.AddErrorMessage(control, "Invalid email address");
			return false;
		}
	}
	return true;
};

VP.ArticleTools.prototype.ClearErrorMessage = function(listId) {
	$("#li" + listId).removeClass("error").find(".error").remove();
};

VP.ArticleTools.prototype.AddErrorMessage = function(listId, errorMessage) {
	if ($("#li" + listId + " p.error").length == 0) {
		$("#li" + listId).addClass("error").append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		$("#li" + listId + " p.error").append("<br />" + errorMessage);
	}
};

VP.ArticleTools.EmailToFriendWithComment = function(commentId, element) {
	var tool = new VP.ArticleTools();
	tool._commentId = commentId;
	tool.ShowEmailPopUp($(element).parent());
};

VP.ArticleTools.prototype.CreateBookmarkLink = function() {

	var ua = navigator.userAgent.toLowerCase();
	var isKonq = (ua.indexOf('konqueror') != -1);
	var isSafari = (ua.indexOf('webkit') != -1);
	var isMac = (ua.indexOf('mac') != -1);
	var buttonStr = isMac ? 'Command/Cmd' : 'CTRL';

	if (window.sidebar) { // Mozilla Firefox Bookmark
		window.sidebar.addPanel(document.title, window.location, "");

	}
	else if (window.external && (!document.createTextNode ||
	(typeof (window.external.AddFavorite) == 'unknown'))) { // IE Favorite
		window.external.AddFavorite(window.location, document.title);

	}
	else if (isKonq) {
		alert('You need to press CTRL + B to bookmark our site.');

	}
	else if (window.opera) {	// Opera Bookmark
		alert('You need to press CTRL + D to bookmark our site.');

	}
	else if (window.home || isSafari) {
		alert('You need to press ' + buttonStr + ' + D to bookmark our site.');

	}
	else if (!window.print || isMac) {
		alert('You need to press Command/Cmd + D to bookmark our site.');

	}
	else {
		alert('In order to bookmark this site you need to do so manually through your browser.');

	}
};

VP.ArticleTools.prototype.GetPrinterFriendlyArticleHtml = function() {
	var that = this;
	var articleId = $("input[id$='hdnArticleId']")[0].value;
	$.ajax({
		type: "POST",
		url: that._webServiceUrl + "/GetPrinterFriendlyArticleHtml",
		data: "{'articleId':" + articleId + ",'siteId':" + VP.SiteId + ", 'pageId' : " + VP.PageId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			var previewWindow = window.open('', 'Print',
			'location=0,status=1,scrollbars=1,toolbar=0,menubar=0,resizable=1,width=700,height=1000');
			var htmlSource = "<!DOCTYPE html><HTML><HEAD><TITLE>Print " + document.title + "</TITLE>";

			htmlSource += msg.d[1];

			htmlSource += "</HEAD><BODY>";
			htmlSource += msg.d[0];
			htmlSource += "</BODY></HTML>";
			previewWindow.document.open();
			previewWindow.document.write(htmlSource);
			previewWindow.document.close();
		}
	});
};

VP.ArticleTools.prototype.FillEmailToFriendDetails = function() {
	var userInfo = $("input[id$='hdnUserInfo']")[0].value;
	if (userInfo != "") {
		var userInfoArray = userInfo.split('|');
		var userId = userInfoArray[0];
		var userName = userInfoArray[1];
		$("#txtUsername").val(userName);
		this.GetUserEmail(userId);		
	}
};

VP.ArticleTools.prototype.GetUserEmail = function(userId) {
	var that = this;
	$.ajax({
		type: "POST",
		url: that._webServiceUrl + "/GetUserEmail",
		data: "{'userId':'" + userId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			$("#txtFromEmail").val(msg.d);
		}
	});
};

if (typeof String.prototype.trim !== 'function') {
	String.prototype.trim = function () {
		return this.replace(/^\s+|\s+$/g, '');
	}
}