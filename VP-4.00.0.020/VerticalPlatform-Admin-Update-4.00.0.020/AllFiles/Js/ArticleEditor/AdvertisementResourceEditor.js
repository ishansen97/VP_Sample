
VP.ArticleEditor.AdvertisementResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.AdvertisementResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.AdvertisementResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Advertisement Resource");
	var html = $("#AdvertisementResourceEditorTemplate").clone();
	$(this._element).append(html);
	if (this._resource != null) {
		if (typeof (this._resource.Position) != 'undefined' && this._resource.Position != null) {
			$(".txtPosition", this._element).val(this._resource.Position);
		}
	}
}

VP.ArticleEditor.AdvertisementResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.Position = $(".txtPosition", this._element).val();
}

VP.ArticleEditor.AdvertisementResourceEditor.prototype.Validate = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	if (!isTemplate) {
		var that = this;
		if ($(".txtPosition", this._element).val() == "") {
			this._errors[this._errors.length] = "Please enter the 'Position'";
			ret = false;
		}
	}
	return ret;
}

VP.ArticleEditor.AdvertisementResourceEditor.prototype.ValidateResourceObject = function() {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
}
