VP.ArticleEditor.HorizontalMatrixResourceEditor = function () {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	var that = this;
    var html = $("#HorizontalMatrixResourceEditorTemplate").clone();
    
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Horizontal Matrix Resource");
	
	$(this._element).append(html);
	$(".lstProducts", this._element).empty();
	
	if (this._resource != null) {
		if (typeof (this._resource.ProductIds) != 'undefined' && this._resource.ProductIds != null) {
			this.SetProducts(this._resource.ProductIds);
		}
		if (typeof (this._resource.CategoryId) != 'undefined' && this._resource.CategoryId != null) {
			$(".txtCategory", this._element).val(this._resource.CategoryId);
		}
		if (typeof (this._resource.DescriptionTruncationLength) != 'undefined' && this._resource.DescriptionTruncationLength != null) {
			$(".txtTruncationLength", this._element).val(this._resource.DescriptionTruncationLength);
		}
		if (typeof (this._resource.DisplayCatalogNumber) != 'undefined' && this._resource.DisplayCatalogNumber != null) {
			if (this._resource.DisplayCatalogNumber == true ) {
				$(".cbDisplayCatalogNumber", this._element).attr('checked', 'checked');
			}
		}
		if (typeof (this._resource.DisplayCategoryDescription) != 'undefined' && this._resource.DisplayCategoryDescription != null) {
			if (this._resource.DisplayCategoryDescription == true) {
				$(".cbDisplayCategoryText", this._element).attr('checked', 'checked');
			}
		}
		if (typeof (this._resource.HideProductDescription) != 'undefined' && this._resource.HideProductDescription != null) {
			if (this._resource.HideProductDescription == true) {
				$(".cbHideProductDescription", this._element).attr('checked', 'checked');
			}
		}
	}
	
    if ($(".txtCategory", that._element).val() == '') {
	    $(".txtProduct", that._element).attr("disabled", "disabled");
	}
	
	var catOptions = { siteId: VP.SiteId, currentPage: '1', pageSize: '10', type: 'Category', enabled: 'true', categoryType: '4' };
	var prodOptions = { siteId: VP.SiteId, currentPage: '1', pageSize: '10', type: 'Product', categoryTypeElementId:'txtCategory', enabled: 'true' };
	$(".txtCategory", this._element).contentPicker(catOptions);
	$(".txtProduct", this._element).contentPicker(prodOptions);

	$(".btnAddProduct", this._element).click(function() {
		var selectedValue = $(".txtProduct", that._element).val();
		if (!isNaN(selectedValue)) {
			var selectedText = that.GetProductName(selectedValue);
			if (selectedText) {
				var list = $(".lstProducts", that._element);
				that.AddItem(list, selectedValue, selectedText);
				$(".txtProduct", that._element).val('');
			}
		}
	});
    
    $(".txtCategory", this._element).change(function() {
		var txtCategory = $(".txtCategory", that._element).val();
		if (!isNaN(txtCategory) && txtCategory != '') {
			$(".txtProduct", that._element).removeAttr("disabled"); 
		} 
		else{
		    $(".txtProduct", that._element).attr("disabled", "disabled");
		}
	});
	
	$(".btnProductRemoveItem", this._element).click(function() {
		var list = $(".lstProducts", that._element);
		that.RemoveItem(list);
	});
	
	$(".btnProductMoveUp", this._element).click(function() {
		var list = $(".lstProducts", that._element);
		that.ItemMoveUp(list);
	});
	
	$(".btnProductMoveDown", this._element).click(function() {
		var list = $(".lstProducts", that._element);
		that.ItemMoveDown(list);
	});
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.ItemMoveDown = function(list) {
	if ($('option:selected', list)) {
		$('option:selected', list).insertAfter($('option:selected', list).next());
	}
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.ItemMoveUp = function(list) {
	if ($('option:selected', list)) {
		$('option:selected', list).insertBefore($('option:selected', list).prev());
	}
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.RemoveItem = function(list) {
	if ($("option:selected", list)) {
		$("option:selected", list).remove();
	}
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.AddItem = function(list, val, text) {
	if($('.lstProducts option').length < 5) {
	    if (this.IsAddedItem(val, list) == null) {
		    $(list).append($('<option></option>').val(val).html(text));
	    }
	}
	else{	
	    alert ('You can only add 5 items to compare!');
	}
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.GetItems = function(list) {
	var displayItems = "";
	var delimeter = ",";

	$("option", list).each(function() {
		if (displayItems == '') {
			displayItems += $(this).val();
		}
		else {
			displayItems += delimeter + $(this).val();
		}
	});

	return displayItems;
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.SetProducts = function(productIds) {
	$(".lstProducts", this._element).empty();
	if (productIds != null && $.trim(productIds) !="") {
		var productArray = productIds.split(',');
		for (var i = 0; i < productArray.length; i++) {
			var productName = this.GetProductName(productArray[i]);
			if (productName) {
				$(".lstProducts", this._element).append($('<option></option>').val(productArray[i]).html(productName));
			}
		}
	}
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.GetProductName = function(productId) {
	var productName = null;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetContent",
		data: "{'siteId' : " + VP.SiteId + ",'contentType' : 2, 'contentId': " + productId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (msg.d != null) {
				var item = msg.d;
				productName = item.Name;
			}
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location("../../Error.aspx");
		}
	});

	return productName;
};



VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.IsAddedItem = function(selectedValue, list) {
	var ret = null;
	var items = $("option", list);
	for (var i = 0; i < items.length; i++) {
		if (items[i].value == selectedValue) {
			ret = items[i];
			break;
		}
	}

	return ret;
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.ProductIds = this.GetItems($(".lstProducts", this._element));
	this._resource.CategoryId = $(".txtCategory", this._element).val();
	this._resource.DescriptionTruncationLength = $(".txtTruncationLength", this._element).val();
	this._resource.DisplayCatalogNumber = $(".cbDisplayCatalogNumber", this._element).attr('checked');
	this._resource.DisplayCategoryDescription = $(".cbDisplayCategoryText", this._element).attr('checked');
	this._resource.HideProductDescription = $(".cbHideProductDescription", this._element).attr('checked');
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.Validate = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	var productCount = $(".lstProducts option", this._element).length;
	if (!isTemplate && productCount == 0) {
		this._errors[this._errors.length] = "Please add products to list.";
		ret = false;
	}
	if (!isTemplate && $.trim($(".txtCategory", this._element).val()) == '') {
		this._errors[this._errors.length] = "Please select a Category.";
		ret = false;
	}
	if (isNaN($.trim($(".txtTruncationLength", this._element).val()))) {
		this._errors[this._errors.length] = "Please enter a valid length for Description Truncation Length.";
		ret = false;
	}

	return ret;
};

VP.ArticleEditor.HorizontalMatrixResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate) {
		if (!this._resource.ProductIds || this._resource.ProductIds == "") {
			ret = false;
		}
		if (!this._resource.CategoryId || this._resource.CategoryId == "") {
			ret = false;
		}
	}
	
	return ret;
};
