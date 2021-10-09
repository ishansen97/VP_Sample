
VP.ArticleEditor.RelatedCategoryResourceEditor = function () {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.RelatedCategoryResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.RelatedCategoryResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	var that = this;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Related Category Resource");
	var html = $("#RelatedCategoryResourceEditorTemplate").clone();
	$(this._element).append(html);
	if (this._resource != null) {
		if (typeof (this._resource.DescriptionLength) != 'undefined' && this._resource.DescriptionLength != null) {
			$(".txtLength", this._element).val(this._resource.DescriptionLength);
		}
		if (this._resource.DisplayCategoryShortName) {
			$(".chkDisplayShortName", this._element).attr('checked', 'checked');
		}
		if (this._resource.MaximumCategories) {
			$(".txtMax", this._element).val(this._resource.MaximumCategories);
		}
		if (this._resource.HideCategoryDescription) {
			$(".hideCategoryDescriptionCheckbox", this._element).attr('checked', 'checked');
		}
		if (this._resource.DisplayCategoryImage) {
			$(".DisplayCategoryImageCheckbox", this._element).attr('checked', 'checked');
		}
		if (this._resource.ImageSize) {
			$(".ImageSize", this._element).val(this._resource.ImageSize);
		}

		that.EnableImageSize();

		$(".DisplayCategoryImageCheckbox").bind("click", function (e) {
			that.EnableImageSize();
		});
	}
};

VP.ArticleEditor.RelatedCategoryResourceEditor.prototype.EnableImageSize = function () {
	if ($(".DisplayCategoryImageCheckbox").is(":checked")) {
		$(".ImageSize").removeAttr("disabled");
	} else {
		$(".ImageSize").attr("disabled", "disabled");
	}
};

VP.ArticleEditor.RelatedCategoryResourceEditor.prototype.Save = function () {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.DescriptionLength = $(".txtLength", this._element).val();
	this._resource.MaximumCategories = $(".txtMax", this._element).val();
	this._resource.DisplayCategoryShortName = $(".chkDisplayShortName", this._element).attr('checked');
	this._resource.HideCategoryDescription = $(".hideCategoryDescriptionCheckbox", this._element).attr('checked');
	this._resource.DisplayCategoryImage = $(".DisplayCategoryImageCheckbox", this._element).attr('checked');
	if ($(".DisplayCategoryImageCheckbox").is(":checked")) {
		this._resource.ImageSize = $(".ImageSize", this._element).val();
	} else {
		this._resource.ImageSize = 0;
	}
};

VP.ArticleEditor.RelatedCategoryResourceEditor.prototype.Validate = function (isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	var length = $(".txtLength", this._element).val();
	if (length != "") {
		if (isNaN(length)) {
			this._errors[this._errors.length] = "Please enter a numeric value for the 'Category description truncate length'";
			ret = false;
		}
	}

	var maximumCategories = $(".txtMax", this._element).val();
	if (maximumCategories != "") {
		if (isNaN(maximumCategories)) {
			this._errors[this._errors.length] = "Please enter a positive numeric value for the 'Maximum Number of Categories'";
			ret = false;
		}
		else if (maximumCategories <= 0) {
			this._errors[this._errors.length] = "Please enter a positive numeric value for the 'Maximum Number of Categories'";
			ret = false;
		}
	}
	else {
		this._errors[this._errors.length] = "Please enter a positive numeric value for the 'Maximum Number of Categories'";
		ret = false;
	}

	return ret;
};

VP.ArticleEditor.RelatedCategoryResourceEditor.prototype.ValidateResourceObject = function() {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
};