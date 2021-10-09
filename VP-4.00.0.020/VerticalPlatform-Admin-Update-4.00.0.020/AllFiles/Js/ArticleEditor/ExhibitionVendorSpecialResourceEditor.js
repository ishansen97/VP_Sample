VP.ArticleEditor.ExhibitionVendorSpecialResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
	this._showApplyButton = false;
};

VP.ArticleEditor.ExhibitionVendorSpecialResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.ExhibitionVendorSpecialResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Exhibition Vendor Special Resource");
	var html = $("#ExhibitionVendorSpecialResourceEditorTemplate").clone();
	$(this._element).append(html);
};

VP.ArticleEditor.ExhibitionVendorSpecialResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
};

VP.ArticleEditor.ExhibitionVendorSpecialResourceEditor.prototype.Validate = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	return ret;
};

VP.ArticleEditor.ExhibitionVendorSpecialResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
};
