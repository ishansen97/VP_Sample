RegisterNamespace("VP.ArticleComment");

$(document).ready(function() {
	var comment = new VP.ArticleComment();
});

VP.ArticleComment = function() {
	var that = this;
	$("#btnDummyPostComment").click(function() {
		that.ValidateComment();
	});
};

VP.ArticleComment.prototype.RestrictHTMLTags = function() {
	var comment = $(".txtCmtComment").val();
	var regularExpression = new RegExp("<\\/?\\w+((\\s+\\w+(\\s*=\\s*(?:\".*?\"|'.*?'|[^'\">\\s]+))?)+\\s*|\\s*)\\/?>");
	if (comment.match(regularExpression)) {
		this.AddCommentErrorMessage("txtCmtComment", "HTML or JavaScript tags are not allowed");
		return false;
	}
	return true;
};

VP.ArticleComment.prototype.ValidateComment = function() {
	$('#btnDummyPostComment').attr('disabled', 'disabled').addClass('disabled');
	this.ClearCommentErrorMessage("txtCmtUsername");
	this.ClearCommentErrorMessage("txtCmtEmail");
	this.ClearCommentErrorMessage("txtCmtComment");
	var isvalied = true;
	isvalied = this.CommentRequiredFieldValidator("txtCmtUsername") && isvalied;
	isvalied = this.CommentRequiredFieldValidator("txtCmtEmail") && isvalied;
	isvalied = this.CommentRequiredFieldValidator("txtCmtComment") && isvalied;
	isvalied = this.CommentEmailsValidator("txtCmtEmail") && isvalied;
	isvalied = this.RestrictHTMLTags() && isvalied;
	if (isvalied) {
		$("input[id$='btnPostcomment'].hiddenButton").click();
	}
	else {
		$('#btnDummyPostComment').removeAttr('disabled').removeClass('disabled');
	}
	return isvalied;
};

VP.ArticleComment.prototype.CommentRequiredFieldValidator = function(control) {
	if ($("." + control).val() != '') {
		return true;
	}
	this.AddCommentErrorMessage(control, "Required field");
	return false;
};

VP.ArticleComment.prototype.CommentEmailsValidator = function(control) {
	var emails = $("." + control).val();
	if (emails != "") {
		var emailArray = emails.split(',');
		for (var index = 0; index < emailArray.length; index++) {
			var regularExpression = new RegExp("(^[a-z]([a-z0-9_\\.\\!\\#\\$\\%\\&\\*\\+\\-\\/\\=\\?\\^\\`\\{\\|\\}\\~]*)@([a-z0-9_\\.]*)([.][a-z]{3})$)|(^[a-z]([a-z_\\.\\!\\#\\$\\%\\&\\*\\+\\-\\/\\=\\?\\^\\`\\{\\|\\}\\~]*)@([a-z0-9_\\.]*)(\\.[a-z]{3})(\\.[a-z]{2})*$)", "i");
			if (!emailArray[index].match(regularExpression)) {
				this.AddCommentErrorMessage(control, "Invalid email address");
				return false;
			}
		}
	}
	return true;
};

VP.ArticleComment.prototype.ClearCommentErrorMessage = function(listId) {
	$("#div" + listId).removeClass("error").find(".error").remove();
};

VP.ArticleComment.prototype.AddCommentErrorMessage = function(listId, errorMessage) {
	if ($("#div" + listId + " p.error").length == 0) {
		$("#div" + listId).append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		$("#div" + listId + " p.error").append("<br />" + errorMessage);
	}
};