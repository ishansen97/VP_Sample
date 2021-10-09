VP.ArticleEditor.MetadataResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.MetadataResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.MetadataResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Metadata Resource");
	var html = $("#MetadataResourceEditorTemplate").clone();
	$(this._element).append(html);
	if (this._resource != null) {
		if (this._resource.IsShowArticleTitle) {
			$(".chkIsShowArticleTitle", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowArticleTitle", this._element).removeAttr('checked');
		}
		if (this._resource.IsShowArticleSubTitle) {
			$(".chkIsShowArticleSubTitle", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowArticleSubTitle", this._element).removeAttr('checked');
		}
		if (this._resource.IsShowAuthorDetails) {
			$(".chkIsShowAuthorDetails", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowAuthorDetails", this._element).removeAttr('checked');
		}
		if (this._resource.IsShowDatePublished) {
			$(".chkIsShowDatePublished", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowDatePublished", this._element).removeAttr('checked');
		}
		if (this._resource.IsShowArticleType) {
			$(".chkIsShowArticleType", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkIsShowArticleType", this._element).removeAttr('checked');
		}

		this.SetReviewMetaData();
	}
};

VP.ArticleEditor.MetadataResourceEditor.prototype.Save = function () {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.IsShowArticleTitle = $(".chkIsShowArticleTitle", this._element).attr('checked');
	this._resource.IsShowArticleSubTitle = $(".chkIsShowArticleSubTitle", this._element).attr('checked');
	this._resource.IsShowAuthorDetails = $(".chkIsShowAuthorDetails", this._element).attr('checked');
	this._resource.IsShowDatePublished = $(".chkIsShowDatePublished", this._element).attr('checked');
	this._resource.IsShowArticleType = $(".chkIsShowArticleType", this._element).attr('checked');
};

VP.ArticleEditor.MetadataResourceEditor.prototype.Validate = function (isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	return ret;
};

VP.ArticleEditor.MetadataResourceEditor.prototype.ValidateResourceObject = function () {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
};

VP.ArticleEditor.MetadataResourceEditor.prototype.SetReviewMetaData = function () {
	if (!this.IsNullUndefinedOrEmpty(this._resource.ReviewProductName)) {
		$("ul", this._element).append('<li><label>Review Product Name</label><label>' + this._resource.ReviewProductName + '</label></li>');
	}
	if (!this.IsNullUndefinedOrEmpty(this._resource.ReviewVendorName)) {
		$("ul", this._element).append('<li><label>Review Vendor Name</label><label>' + this._resource.ReviewVendorName + '</label></li>');
	}
	if (!this.IsNullUndefinedOrEmpty(this._resource.ReviewAuthorName)) {
		$("ul", this._element).append('<li><label>Review Author Name</label><label>' + this._resource.ReviewAuthorName + '</label></li>');
	}
	if (!this.IsNullUndefinedOrEmpty(this._resource.ReviewAuthorEmail)) {
		$("ul", this._element).append('<li><label>Review Author Email</label><label>' + this._resource.ReviewAuthorEmail + '</label></li>');
	}
};