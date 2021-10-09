
VP.ArticleEditor.ImageResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.ImageResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.ImageResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Image Resource");
	var html = $("#ImageResourceEditorTemplate").clone();
	$(this._element).append(html);
	if (this._resource != null) {
		if (typeof (this._resource.ImageName) != 'undefined') {
			$(".txtImageName", this._element).val(this._resource.ImageName);
		}
		if (typeof (this._resource.Height) != 'undefined') {
			$(".txtImageHeight", this._element).val(this._resource.Height);
		}
		if (typeof (this._resource.Width) != 'undefined') {
			$(".txtImageWidth", this._element).val(this._resource.Width);
		}
		if (typeof (this._resource.ImageAltTag) != 'undefined') {
			$(".txtImageAltTag", this._element).val(this._resource.ImageAltTag);
		}

		if (typeof (this._resource.ImageCustomCss) != 'undefined') {
		    $(".imageCustomCssText", this._element).val(this._resource.ImageCustomCss);
		}

		if (this._resource.ImageFigure) {
			$(".chkImageFigure", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkImageFigure", this._element).removeAttr('checked');
		}

		if (this._resource.ImageZoom) {
			$(".chkImageZoom", this._element).attr('checked', 'checked');
		}
		else {
			$(".chkImageZoom", this._element).removeAttr('checked');
		}
	}
	
	$(".txtImageAltTag", this._element).AddTagPicker();
	$(".txtImageName", this._element).AddTagPicker();
}

VP.ArticleEditor.ImageResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.ImageName = $.trim($(".txtImageName", this._element).val());
	this._resource.Height = $(".txtImageHeight", this._element).val();
	this._resource.Width = $(".txtImageWidth", this._element).val();
	this._resource.ImageAltTag = $(".txtImageAltTag", this._element).val();
	this._resource.ImageCustomCss = $(".imageCustomCssText", this._element).val();
	this._resource.ImageFigure = $(".chkImageFigure", this._element).attr('checked');
	this._resource.ImageZoom = $(".chkImageZoom", this._element).attr('checked');
	
}

VP.ArticleEditor.ImageResourceEditor.prototype.Validate = function(isTemplate) {
	var that = this;
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	
	if(!isTemplate)
	{
		if ($(".txtImageName", this._element).val() == "" || $.trim($(".txtImageName", this._element).val() == "")) {
			this._errors[this._errors.length] = "Please enter the 'Image Name'";
			ret = false;
		}
		if ($(".txtImageHeight", this._element).val() == "" || isNaN($(".txtImageHeight", this._element).val())) {
			this._errors[this._errors.length] = "Please enter the 'Image Height'";
			ret = false;
		}
		if ($(".txtImageWidth", this._element).val() == "" || isNaN($(".txtImageWidth", this._element).val())) {
			this._errors[this._errors.length] = "Please enter the 'Image Width'";
			ret = false;
		}
	}
	return ret;
}

VP.ArticleEditor.ImageResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate) {
		if (this._resource.ImageName == "") {
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

