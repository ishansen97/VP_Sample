VP.ArticleEditor.RelatedProductsResourceEditor = function () {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	var that = this;
	this._displayItemOrder = 1;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Related Product Resource");
	var html = $("#RelatedProductsResourceEditorTemplate").clone();
	$(this._element).append(html);

	$(".lstDisplayItems", this._element).empty();
	if (this._resource != null) {
		if (typeof (this._resource.SpecificationLength) != 'undefined' && this._resource.SpecificationLength != null) {
			$(".txtLength", this._element).val(this._resource.SpecificationLength);
		}

		if (typeof (this._resource.ProductTitleLength) != 'undefined' && this._resource.ProductTitleLength != null) {
			$(".txtLengthProductTitle", this._element).val(this._resource.ProductTitleLength);
		}

		if (typeof (this._resource.DisplaySettings) != 'undefined' && this._resource.DisplaySettings != null) {
			this.SetDisplayItems(this._resource.DisplaySettings);
		}

		this.SetNavigationUrl(this._resource.NavigateUrl);

		if (this._resource.EnableRandomization) {
			$(".chkEnableRandomization", this._element).attr('checked', 'checked');
		}

		if (this._resource.EnableCompareButton) {
			$(".chkEnableCompareButton", this._element).attr('checked', 'checked');
		}

		if (typeof (this._resource.TotalSlots) != 'undefined' && this._resource.TotalSlots != null) {
			$(".txtTotalSlots", this._element).val(this._resource.TotalSlots);
		}

		if (typeof (this._resource.AssociatedSlots) != 'undefined' && this._resource.AssociatedSlots != null) {
			$(".txtAssociatedSlots", this._element).val(this._resource.AssociatedSlots);
		}

		if (this._resource.EnableCustomText) {
			$(".chkCustomTextCompareButton", this._element).attr('checked', 'checked');
		}

		if (typeof (this._resource.CompareButtonCustomText) != 'undefined' && this._resource.CompareButtonCustomText != null) {
			$(".txtCompareButtonCustomText", this._element).val(this._resource.CompareButtonCustomText);
		}

		that.CheckCustomTextBox();

		$(".chkCustomTextCompareButton").bind("click", function (e) {
			that.CheckCustomTextBox();
		});

		if (this._resource.HideLearnMoreText) {
			$(".learnMoreCheckbox", this._element).attr('checked', 'checked');
		}

		if (this._resource.ShowGetInfoLink) {
			$(".getInfoLinkTextBox", this._element).attr('checked', 'checked');
		}
	}

	$(".btnAddItem", this._element).click(function () {
		that.AddDisplayItem();
	});

	$(".btnRemoveItem", this._element).click(function () {
		that.RemoveDisplayItem();
	});

	$(".btnMoveUp", this._element).click(function () {
		that.DisplayItemMoveUp();
	});

	$(".btnMoveDown", this._element).click(function () {
		that.DisplayItemMoveDown();
	});
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.CheckCustomTextBox = function () {
	if ($(".chkCustomTextCompareButton").is(":checked")) {
		$(".txtCompareButtonCustomText").removeAttr("disabled");
	} else {
		$(".txtCompareButtonCustomText").attr("disabled", "disabled");
	}
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.DisplayItemMoveDown = function () {
	$('.lstDisplayItems option:selected').insertAfter($('.lstDisplayItems option:selected').next());
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.DisplayItemMoveUp = function () {
	$('.lstDisplayItems option:selected').insertBefore($('.lstDisplayItems option:selected').prev());
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.RemoveDisplayItem = function () {
	$(".lstDisplayItems option:selected", this._element).remove();
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.AddDisplayItem = function () {
	var selectedValue = $(".ddlProductListDisplayItems", this._element).val();
	if (this.IsAddDisplayItem(selectedValue) == null) {
		var selectedValue = $(".ddlProductListDisplayItems", this._element).val();
		var selectedText = $(".ddlProductListDisplayItems option:selected", this._element).text();
		$(".lstDisplayItems", this._element).append($('<option></option>').val(selectedValue).html(selectedText));
	}
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.GetDisplayItems = function () {
	var displayItems = "";
	var delimeter = "|";

	$(".lstDisplayItems option", this._element).each(function () {
		var $this = $(this);
		displayItems = displayItems + $this.val() + delimeter;
	});

	return displayItems;
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.SetNavigationUrl = function (navigationUrl) {
	if (navigationUrl == "LeadForm") {
		$('.rdoLeadForm', this._element).attr("checked", "checked");
	}
	else {
		$('.rdoProductDetails', this._element).attr("checked", "checked");
	}
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.GetNavigationUrl = function () {
	if ($("input[@name='rdoNavigationUrl']:checked").val() == "Product details page") {
		return "ProductDetail";
	}
	else if ($("input[@name='rdoNavigationUrl']:checked").val() == "Lead form page") {
		return "LeadForm";
	}
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.SetDisplayItems = function (displayItems) {
	$(".lstDisplayItems", this._element).empty();
	if (displayItems != null) {
		var displayItemArray = displayItems.split('|');
		for (var i = 0; i < displayItemArray.length; i++) {
			$(".ddlProductListDisplayItems option", this._element).each(function () {
				$this = $(this);
				if ($(this).val() == displayItemArray[i]) {
					$(".lstDisplayItems", this._element)
							.append($('<option></option>')
							.val($(this).val())
							.html($(this)[0].text));
				}
			});
		}
	}
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.IsAddDisplayItem = function (selectedValue) {
	var ret = null;

	var items = $(".lstDisplayItems option", this._element);
	for (var i = 0; i < items.length; i++) {
		if (items[i].value == selectedValue) {
			ret = items[i];
			break;
		}
	}

	return ret;
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.Save = function () {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.SpecificationLength = $(".txtLength", this._element).val();
	this._resource.ProductTitleLength = $(".txtLengthProductTitle", this._element).val();
	this._resource.DisplaySettings = this.GetDisplayItems();
	this._resource.NavigateUrl = this.GetNavigationUrl();
	this._resource.EnableRandomization = $(".chkEnableRandomization", this._element).attr('checked');
	this._resource.EnableCompareButton = $(".chkEnableCompareButton", this._element).attr('checked');
	this._resource.TotalSlots = $(".txtTotalSlots", this._element).val();
	this._resource.AssociatedSlots = $(".txtAssociatedSlots", this._element).val();
	this._resource.EnableCustomText = $(".chkCustomTextCompareButton", this._element).attr('checked');
	this._resource.CompareButtonCustomText = $(".txtCompareButtonCustomText", this._element).val();
	this._resource.HideLearnMoreText = $(".learnMoreCheckbox", this._element).attr('checked');
	this._resource.ShowGetInfoLink = $(".getInfoLinkTextBox", this._element).attr('checked');
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.Validate = function (isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	var length = $(".txtLength", this._element).val();
	if (length != "") {
		if (isNaN(length)) {
			this._errors[this._errors.length] = "Please enter a numeric value for the 'Product specification length'";
			ret = false;
		}
	}

	var productTitleLength = $(".txtLengthProductTitle", this._element).val();
	if (productTitleLength != "") {
		if (isNaN(productTitleLength)) {
			this._errors[this._errors.length] = "Please enter a numeric value for the 'Product title length'";
			ret = false;
		}
	}

	var totalSlots = $(".txtTotalSlots", this._element).val();
	var associatedSlots = $(".txtAssociatedSlots", this._element).val();
	var customText = $(".txtCompareButtonCustomText", this._element).val();
	if ((($(".chkEnableRandomization", this._element).attr('checked') == true)
			|| ($(".chkEnableCompareButton", this._element).attr('checked') == true))) {
		if (totalSlots == "") {
			this._errors[this._errors.length] = "Please enter a numeric value for the 'Total Display Slots'";
			ret = false;
		}
		else if (associatedSlots == "") {
			this._errors[this._errors.length] = "Please enter a numeric value for the 'Slots allocated for Associated Products'";
			ret = false;
		}
	}

	if (isNaN(totalSlots)) {
		this._errors[this._errors.length] = "Please enter a numeric value for the 'Total Display Slots'";
		ret = false;
	}

	if (isNaN(associatedSlots)) {
		this._errors[this._errors.length] = "Please enter a numeric value for the 'Slots allocated for Associated Products'";
		ret = false;
	}

	if (parseInt(totalSlots) < parseInt(associatedSlots)) {
		this._errors[this._errors.length] = "Number of 'Associated Slots' can not be greater than the number of 'Total Slots'";
		ret = false;
	}

	if ($(".chkCustomTextCompareButton", this._element).attr('checked')) {
		if (customText == "") {
			this._errors[this._errors.length] = "'Custom Text' cannot be empty";
			ret = false;
		}
	}

	return ret;
};

VP.ArticleEditor.RelatedProductsResourceEditor.prototype.ValidateResourceObject = function () {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
};