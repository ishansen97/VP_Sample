VP.ArticleEditor.MultimediaGalleryResourceEditor = function () {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.MultimediaGalleryResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.MultimediaGalleryResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Multimedia Gallery");
	var html, that, linkCss, productIdElement, productNameElement, productNameOptions, productIdOptions;
	html = $("#MultimediaGalleryResourceEditorTemplate").clone();
	that = this;
	$(this._element).append(html);

	linkCss = $("select[id*=ddlLinkResourceCssClass]");
	if (linkCss.length > 0) {
		$("select[id*=ddlLinkResourceCssClass] option").clone().appendTo($(".ddlGalleryCssClass", that._element));
	}

	if (this._resource != null) {
		if (typeof (this._resource.ProductName) != 'undefined' && this._resource.ProductName != null) {
			$(".txtProductName", this._element).val(this._resource.ProductName);
		}
		if (typeof (this._resource.ProductId) != 'undefined' && this._resource.ProductId != null) {
			$(".txtProductId", this._element).val(this._resource.ProductId);
		}
		if (typeof (this._resource.CustomCss) != 'undefined' && this._resource.CustomCss != null) {
			$(".txtGalleryCss", this._element).val(this._resource.CustomCss);
		}
		if (typeof (this._resource.MultimediaGalleryType) != 'undefined' && this._resource.MultimediaGalleryType != null) {
			$(".mediaGalleryType", this._element).val(this._resource.MultimediaGalleryType);
		}

		$(".ddlGalleryCssClass", this._element).change(function () {
			if ($(".ddlGalleryCssClass", that._element).val() > 0) {
				$(".txtGalleryCss", that._element).
						val($('option:selected', $(".ddlGalleryCssClass", that._element)).text());
			}
		});

		$(".mediaGalleryType", this._element).change(function () {
			that.SetProductSelect();
		});
	}

	productIdElement = { contentId: "txtProductId" };
	productNameElement = { contentName: "txtProductName" };
	productNameOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "10", showName: "true", bindings: productIdElement };
	productIdOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "10", bindings: productNameElement };
	$(".txtProductName", this._element).contentPicker(productNameOptions);
	$(".txtProductId", this._element).contentPicker(productIdOptions);

	that.SetProductSelect();
};

VP.ArticleEditor.MultimediaGalleryResourceEditor.prototype.Save = function () {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.ProductName = $(".txtProductName", this._element).val();
	this._resource.ProductId = $(".txtProductId", this._element).val();
	this._resource.CustomCss = $(".txtGalleryCss", this._element).val();
	this._resource.MultimediaGalleryType = $(".mediaGalleryType", this._element).val();
};

VP.ArticleEditor.MultimediaGalleryResourceEditor.prototype.Validate = function (isTemplate) {
	var that, ret;
	that = this;
	ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	var galeryTypeId = $(".mediaGalleryType", this._element).val();
	
	if (!isTemplate && galeryTypeId!= 2) {
		if ($(".txtProductId", this._element).val() == "") {
			this._errors[this._errors.length] = "Please select a product";
			ret = false;
		}
	}

	return ret;
};

VP.ArticleEditor.MultimediaGalleryResourceEditor.prototype.ValidateResourceObject = function (isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate && this._resource.MultimediaGalleryType != 2) {
		if (this._resource.ProductId == "") {
			ret = false;
		}
	}

	return ret;
};

VP.ArticleEditor.MultimediaGalleryResourceEditor.prototype.SetProductSelect = function () {
	if ($(".mediaGalleryType", this._element).val() == 2) {
		$(".txtProductName", this._element).val("");
		$(".txtProductId", this._element).val("");
		$(".txtProductName", this._element).attr('disabled', 'disabled');
		$(".txtProductId", this._element).attr('disabled', 'disabled');
	}
	else {
		$(".txtProductName", this._element).removeAttr('disabled');
		$(".txtProductId", this._element).removeAttr('disabled');
	}
};

