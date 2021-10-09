VP.ArticleEditor.FlashResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.FlashResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.FlashResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Flash Resource");
	var html = $("#FlashResourceEditorTemplate").clone();
	$(this._element).append(html);
	if (typeof (this._resource.Url) != 'undefined') {
		$(".txtUrl", this._element).val(this._resource.Url);
	}
	if (typeof (this._resource.Width) != 'undefined') {
		$(".txtWidth", this._element).val(this._resource.Width);
	}
	if (typeof (this._resource.Height) != 'undefined') {
		$(".txtHeight", this._element).val(this._resource.Height);
	}
	if (typeof (this._resource.FlashVars) != 'undefined') {
		$(".txtFlashVars", this._element).val(this._resource.FlashVars);
	}
	
	$(".txtFlashVars", this._element).AddTagPicker();
}

VP.ArticleEditor.FlashResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.Url = $(".txtUrl", this._element).val();
	this._resource.Width = $(".txtWidth", this._element).val();
	this._resource.Height = $(".txtHeight", this._element).val();
	this._resource.FlashVars = $(".txtFlashVars", this._element).val();
}

VP.ArticleEditor.FlashResourceEditor.prototype.Validate = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	
	if(!isTemplate)
	{
		var that = this;
		if ($(".txtUrl", this._element).val() == "") {
			this._errors[this._errors.length] = "Please enter the flash 'URL'";
			ret = false;
		}
		if ($(".txtWidth", this._element).val() == "") {
			this._errors[this._errors.length] = "Please enter the flash 'Width'";
			ret = false;
		}
		if ($(".txtHeight", this._element).val() == "") {
			this._errors[this._errors.length] = "Please enter the flash 'Hieght'";
			ret = false;
		}
	}

	return ret;
}

VP.ArticleEditor.FlashResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate) {
		if (this._resource.Url == "") {
			ret = false;
		}
		if (this._resource.Width == "") {
			ret = false;
		}
		if (this._resource.Height == "") {
			ret = false;
		}
	}
	return ret;
}
