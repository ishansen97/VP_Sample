
VP.ArticleEditor.RelatedVendorResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.RelatedVendorResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.RelatedVendorResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Related Vendor Resource");
	var html = $("#RelatedVedndorResourceEditorTemplate").clone();
	$(this._element).append(html);

	if (this._resource.DisplayVendorLogo) {
		$(".DisplayVendorLogo", this._element).attr('checked', 'checked');
	}
};

VP.ArticleEditor.RelatedVendorResourceEditor.prototype.Save = function () {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.DisplayVendorLogo = $(".DisplayVendorLogo", this._element).attr('checked');
};

VP.ArticleEditor.RelatedVendorResourceEditor.prototype.Validate = function (isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	return ret;
};

VP.ArticleEditor.RelatedVendorResourceEditor.prototype.ValidateResourceObject = function () {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
};
