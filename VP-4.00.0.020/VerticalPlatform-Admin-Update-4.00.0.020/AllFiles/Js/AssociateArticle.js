RegisterNamespace("VP.Forms");

VP.Forms.AssociateArticle = function() {
	var that = this;
	$(".txtCategories").keydown(function(event) {
		that.GetCategoriesAutoComplete();
	});
	if ($(".txtCategories").length > 0) {
		$(".txtCategories").autocomplete({
			source: []
		});
	}

	$(".txtProducts").keydown(function(event) {
		that.GetProductsAutoComplete();
	});
	if ($(".txtProducts").length > 0) {
		$(".txtProducts").autocomplete({
			source: []
		});
	}

	$(".txtVendors").keydown(function(event) {
		that.GetVendorsAutoComplete();
	});
	if ($(".txtVendors").length > 0) {
		$(".txtVendors").autocomplete({
			source: []
		});
	}

	$(".txtArticles").keydown(function(event) {
		that.GetArticlesAutoComplete();
	});
	if ($(".txtArticles").length > 0) {
		$(".txtArticles").autocomplete({
			source: []
		});
	}
};

VP.Forms.AssociateArticle.prototype.GetCategoriesAutoComplete = function() {
	try {
	var that = this;
		$(".txtCategories").autocomplete({
			source: function(request, response) {
				var list = [];
				$.ajax({
					type: "POST",
					async: false,
					cache: false,
					url: VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults",
					dataType: "json",
					contentType: "application/json; charset=utf-8",
					data: "{'siteId' :" + VP.SiteId + ",'contentType' : 'Category', 'searchText' : '" + request.term + "', 'enabled' :" + null + ", 'vendorId' : " + null +"}",
					success: function(msg) {
						list = $.map(msg.d, function(n) {
							return {
								value: n.Id,
								label: n.Name + "(id=" + n.Id + ")"
							};
						});
					},
					error: function(xmlHttpRequest, textStatus, errorThrown) {
						document.location("../../Error.aspx");
					}
				});
				response(list);
			},
			select: function(event, ui) {
				$(".txtCategories").val(ui.item.label);
				$(".txtCategoryId").val(ui.item.value);
				return false;
			},
			focus: function(event, ui) {
				$(".txtCategories").val(ui.item.label);
				return false;
			}
		});

	} catch (e) { }
};

VP.Forms.AssociateArticle.prototype.GetContentId = function(contentItemFullName) {
	var equalSignPosition = contentItemFullName.lastIndexOf('=');
	var contentId = contentItemFullName.substring(equalSignPosition + 1, contentItemFullName.length - 1);
	return contentId;
};

VP.Forms.AssociateArticle.prototype.GetProductsAutoComplete = function() {
	try {
		var that = this;
		$(".txtProducts").autocomplete({
			source: function(request, response) {
				var list = [];
				$.ajax({
					type: "POST",
					async: false,
					cache: false,
					url: VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults",
					dataType: "json",
					contentType: "application/json; charset=utf-8",
					data: "{'siteId' :" + VP.SiteId + ",'contentType' : 'Product', 'searchText' : '" + request.term + "', 'enabled' :" + null + ", 'vendorId' : " + null + "}",
					success: function(msg) {
						list = $.map(msg.d, function(n) {
							return {
								value: n.Id,
								label: n.Name + "(id=" + n.Id + ")"
							};
						});
					},
					error: function(xmlHttpRequest, textStatus, errorThrown) {
						document.location("../../Error.aspx");
					}
				});
				response(list);
			},
			select: function(event, ui) {
				$(".txtProducts").val(ui.item.label);
				$(".txtProductId").val(ui.item.value);
				return false;
			},
			focus: function(event, ui) {
				$(".txtProducts").val(ui.item.label);
				return false;
			}
		});

	} catch (e) { }
};

VP.Forms.AssociateArticle.prototype.GetVendorsAutoComplete = function() {
	try {
		var that = this;
		$(".txtVendors").autocomplete({
			source: function(request, response) {
				var list = [];
				$.ajax({
					type: "POST",
					async: false,
					cache: false,
					url: VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults",
					dataType: "json",
					contentType: "application/json; charset=utf-8",
					data: "{'siteId' :" + VP.SiteId + ",'contentType' : 'Vendor', 'searchText' : '" + request.term + "', 'enabled' :" + null + ", 'vendorId' : " + null + "}",
					success: function(msg) {
						list = $.map(msg.d, function(n) {
							return {
								value: n.Id,
								label: n.Name + "(id=" + n.Id + ")"
							};
						});
					},
					error: function(xmlHttpRequest, textStatus, errorThrown) {
						document.location("../../Error.aspx");
					}
				});
				response(list);
			},
			select: function(event, ui) {
				$(".txtVendors").val(ui.item.label);
				$(".txtVendorId").val(ui.item.value);
				return false;
			},
			focus: function(event, ui) {
				$(".txtVendors").val(ui.item.label);
				return false;
			}
		});

	} catch (e) { }
};

VP.Forms.AssociateArticle.prototype.GetArticlesAutoComplete = function() {
	try {
		var that = this;
		$(".txtArticles").autocomplete({
			source: function(request, response) {
				var list = [];
				$.ajax({
					type: "POST",
					async: false,
					cache: false,
					url: VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults",
					dataType: "json",
					contentType: "application/json; charset=utf-8",
					data: "{'siteId' :" + VP.SiteId + ",'contentType' : 'Vendor', 'searchText' : '" + request.term + "', 'enabled' :" + null + ", 'vendorId' : " + null + "}",
					success: function(msg) {
						list = $.map(msg.d, function(n) {
							return {
								value: n.Id,
								label: n.Name + "(id=" + n.Id + ")"
							};
						});
					},
					error: function(xmlHttpRequest, textStatus, errorThrown) {
						document.location("../../Error.aspx");
					}
				});
				response(list);
			},
			select: function(event, ui) {
				$(".txtArticles").val(ui.item.label);
				$(".txtArticleId").val(ui.item.value);
				return false;
			},
			focus: function(event, ui) {
				$(".txtArticles").val(ui.item.label);
				return false;
			}
		});

	} catch (e) { }
};

