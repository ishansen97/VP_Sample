VP.ArticleEditor.ArticleToolsResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.ArticleToolsResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.ArticleToolsResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Article Tool Resource");
	var html = $("#ArticleToolsResourceEditorTemplate").clone();
	$(this._element).append(html);
	if (this._resource != null) {
		if (this._resource.IsShowEmailToFriend) {
			$(".chkIsShowEmailToFriend", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowEmailToFriend", this._element).removeAttr('checked');
		}
		if (this._resource.IsShowPrint) {
			$(".chkIsShowPrint", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowPrint", this._element).removeAttr('checked');
		}
		if (this._resource.IsShowBookmark) {
			$(".chkIsShowBookmark", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowBookmark", this._element).removeAttr('checked');
		}
		if (this._resource.IsShowShareThisPage) {
			$(".chkIsShowShareThisPage", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowShareThisPage", this._element).removeAttr('checked');
		}
	}
}

VP.ArticleEditor.ArticleToolsResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.IsShowEmailToFriend = $(".chkIsShowEmailToFriend", this._element).attr('checked');
	this._resource.IsShowPrint = $(".chkIsShowPrint", this._element).attr('checked');
	this._resource.IsShowBookmark = $(".chkIsShowBookmark", this._element).attr('checked');
	this._resource.IsShowShareThisPage = $(".chkIsShowShareThisPage", this._element).attr('checked');
}

VP.ArticleEditor.ArticleToolsResourceEditor.prototype.Validate = function() {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	return ret;
}

VP.ArticleEditor.ArticleToolsResourceEditor.prototype.ValidateResourceObject = function() {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
}
