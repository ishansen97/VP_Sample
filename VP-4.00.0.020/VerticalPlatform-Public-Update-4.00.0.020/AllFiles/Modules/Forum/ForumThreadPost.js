RegisterNamespace("VP.ForumThreadPost");

VP.ForumThreadPost = function() {
};

VP.ForumThreadPost.prototype.init = function() {
	var $forumPost = $("div.forumThreadPost");
	var that = this;
	$forumPost.find("input[id$=btnSave]").bind('click', function() {

		if (that.Validate()) {
			that.ReplaceTags("_txtBody");
			return true;
		}
		else {
			return false;
		}
	});

	$forumPost.find("input[id$=btnCancel]").bind('click', function() {
		that.ReplaceTags("_txtBody");
		return true;
	});
};

VP.ForumThreadPost.prototype.ReplaceTags = function(txtBodyId) {
	var body = $("[id$=" + txtBodyId + "]").val();
	body = body.replace(/</g, "&lt;");
	body = body.replace(/>/g, "&gt;");
	$("[id$=" + txtBodyId + "]").val(body);
}

VP.ForumThreadPost.prototype.Validate = function() {
	this.ClearErrorMessage("txtSubject");
	this.ClearErrorMessage("txtBody");

	var isvalied = true;
	isvalied = this.RequiredFieldValidator("txtSubject") && isvalied;
	isvalied = this.RequiredFieldValidator("txtBody") && isvalied;
	return isvalied;
};

VP.ForumThreadPost.prototype.ClearErrorMessage = function(listId) {
	$("#li" + listId).removeClass("error").find(".error").remove();
};

VP.ForumThreadPost.prototype.RequiredFieldValidator = function(control) {
	if ($("[id$=_" + control + "]").val() != '') {
		return true;
	}
	this.AddErrorMessage(control, "Required field");
	return false;
};

VP.ForumThreadPost.prototype.AddErrorMessage = function(listId, errorMessage) {
	if ($("#li" + listId + " p.error").length == 0) {
		$("#li" + listId).addClass("error").append("<p class=\"error\">" + errorMessage + "</p>");
	}
	else {
		$("#li" + listId + " p.error").append("<br />" + errorMessage);
	}
};

$(document).ready(function() {
	var threadPost = new VP.ForumThreadPost();
	threadPost.init();
});