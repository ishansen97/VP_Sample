VP.ArticleEditor.ArticleListResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.ArticleListResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.ArticleListResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	var that = this;

	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Article List Resource");
	var html = $("#ArticleListResourceEditorTemplate").clone();
	$(this._element).append(html);
	$(".lstArticles", this._element).empty();
	$(".lstArticleListDisplayItems", this._element).empty();

	if (this._resource != null) {
		if (typeof (this._resource.ArticleIds) != 'undefined' && this._resource.ArticleIds != null) {
			this.SetArticles(this._resource.ArticleIds);
		}
		if (typeof (this._resource.DisplaySettings) != 'undefined' && this._resource.DisplaySettings != null) {
			this.SetDisplayItems(this._resource.DisplaySettings);
		}
		if (typeof (this._resource.ShowReadMoreLink) != 'undefined' && this._resource.ShowReadMoreLink != null) {
			if (this._resource.ShowReadMoreLink) {
				$(".chkReadMore", this._element).attr('checked', 'checked');
			}
		}
		if (typeof (this._resource.SynopsisLength) != 'undefined' && this._resource.SynopsisLength != null && this._resource.SynopsisLength > 0) {
			$(".txtSynopsisLength", this._element).val(this._resource.SynopsisLength);
		}
		if (typeof (this._resource.CssClass) != 'undefined' && this._resource.CssClass != null) {
		    $(".txtCssClass", this._element).val(this._resource.CssClass);
		}
		if (typeof (this._resource.ArticleThumbnailSize) != 'undefined') {
		    $(".ddlArticleThumbnailSize", this._element).val(this._resource.ArticleThumbnailSize);
		}
	}

	var options = { siteId: VP.SiteId, currentPage: '1', pageSize: '10', type: 'Article', enabled: 'true' };
	$(".txtArticle", this._element).contentPicker(options);

	$(".btnAddDisplayItem", this._element).click(function() {
		var selectedText = $(".ddlArticleListDisplayItems option:selected", that._element).text();
		var selectedValue = $(".ddlArticleListDisplayItems", that._element).val();
		var list = $(".lstArticleListDisplayItems", that._element);
		if (selectedText != '' && !isNaN(selectedValue)) {
			that.AddItem(list, selectedValue, selectedText);
		}
	});

	$(".btnAddArticle", this._element).click(function() {
		var selectedValue = $(".txtArticle", that._element).val();
		if (!isNaN(selectedValue)) {
			var selectedText = that.GetArticleName(selectedValue);
			if (selectedText) {
				var list = $(".lstArticles", that._element);
				that.AddItem(list, selectedValue, selectedText);
				$(".txtArticle", that._element).val('');
			}
		}
	});

	$(".btnDisplayItemRemoveItem", this._element).click(function() {
		var list = $(".lstArticleListDisplayItems", that._element);
		that.RemoveItem(list);
	});
	$(".btnArticleRemoveItem", this._element).click(function() {
		var list = $(".lstArticles", that._element);
		that.RemoveItem(list);
	});
	$(".btnDisplayItemMoveUp", this._element).click(function() {
		var list = $(".lstArticleListDisplayItems", that._element);
		that.ItemMoveUp(list);
	});
	$(".btnArticleMoveUp", this._element).click(function() {
		var list = $(".lstArticles", that._element);
		that.ItemMoveUp(list);
	});

	$(".btnDisplayItemMoveDown", this._element).click(function() {
		var list = $(".lstArticleListDisplayItems", that._element);
		that.ItemMoveDown(list);
	});
	$(".btnArticleMoveDown", this._element).click(function() {
		var list = $(".lstArticles", that._element);
		that.ItemMoveDown(list);
	});
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.ItemMoveDown = function(list) {
	if ($('option:selected', list)) {
		$('option:selected', list).insertAfter($('option:selected', list).next());
	}
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.ItemMoveUp = function(list) {
	if ($('option:selected', list)) {
		$('option:selected', list).insertBefore($('option:selected', list).prev());
	}
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.RemoveItem = function(list) {
	if ($("option:selected", list)) {
		$("option:selected", list).remove();
	}
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.AddItem = function(list, val, text) {
	if (this.IsAddedItem(val, list) == null) {
		$(list).append($('<option></option>').val(val).html(text));
	}
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.GetItems = function(list) {
	var displayItems = "";
	var delimeter = "|";

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

VP.ArticleEditor.ArticleListResourceEditor.prototype.SetArticles = function(articleIds) {
	$(".lstArticles", this._element).empty();
	if (articleIds != null) {
		var articleArray = articleIds.split('|');
		for (var i = 0; i < articleArray.length; i++) {
			var articleName = this.GetArticleName(articleArray[i]);
			if (articleName) {
				$(".lstArticles", this._element).append($('<option></option>').val(articleArray[i]).html(articleName));
			}
		}
	}
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.GetArticleName = function(articleId) {
	var articleName = null;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetContent",
		data: "{'siteId' : " + VP.SiteId + ",'contentType' : 4, 'contentId': " + articleId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (msg.d != null) {
				var item = msg.d;
				articleName = item.Name;
			}
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location("../../Error.aspx");
		}
	});

	return articleName;
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.SetDisplayItems = function(displayItems) {
	$(".lstArticleListDisplayItems", this._element).empty();
	if (displayItems != null) {
		var displayItemArray = displayItems.split('|');
		for (var i = 0; i < displayItemArray.length; i++) {
			$(".ddlArticleListDisplayItems option", this._element).each(function() {
				$this = $(this);
				if ($(this).val() == displayItemArray[i]) {
					$(".lstArticleListDisplayItems", this._element)
							.append($('<option></option>')
							.val($(this).val())
							.html($(this)[0].text));
				}
			});
		}
	}
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.IsAddedItem = function(selectedValue, list) {
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

VP.ArticleEditor.ArticleListResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	var synopsisLength = $(".txtSynopsisLength", this._element).val();
	this._resource.DisplaySettings = this.GetItems($(".lstArticleListDisplayItems", this._element));
	this._resource.ArticleIds = this.GetItems($(".lstArticles", this._element));
	this._resource.SynopsisLength = synopsisLength;
	this._resource.CssClass = $(".txtCssClass", this._element).val();;
	this._resource.ShowReadMoreLink = $(".chkReadMore", this._element).attr('checked');
	this._resource.ArticleThumbnailSize = $(".ddlArticleThumbnailSize", this._element).val();
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.Validate = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	var articleLength = $(".lstArticles option", this._element).length;
	if (!isTemplate && articleLength == 0) {
		this._errors[this._errors.length] = "Please add article to list.";
		ret = false;
	}

	var displaySettingsLength = $(".lstArticleListDisplayItems option", this._element).length;
	if (!isTemplate && displaySettingsLength == 0) {
		this._errors[this._errors.length] = "Please add article display settings to list.";
		ret = false;
	}
	
	var synopsisLenght = $(".txtSynopsisLength", this._element).val();
	if (synopsisLenght != '' && isNaN(synopsisLenght)) {
		this._errors[this._errors.length] = "Please provide numerical value for synopsis length.";
		ret = false;
	}
	return ret;
};

VP.ArticleEditor.ArticleListResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate) {
		if (!this._resource.ArticleIds || this._resource.ArticleIds == "") {
			ret = false;
		}
		if (!this._resource.DisplaySettings || this._resource.DisplaySettings == "") {
			ret = false;
		}
	}
	return ret;
};
