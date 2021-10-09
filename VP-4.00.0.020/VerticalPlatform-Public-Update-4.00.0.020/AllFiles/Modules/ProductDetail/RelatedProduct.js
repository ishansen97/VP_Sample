(function($) {
	_options = {};
	_checkBoxes = {};

	$.fn.relatedProduct = function(options) {
		_options = $.extend({}, $.fn.relatedProduct.defaults, options);
		this.find(':checkbox').click(itemSelect);
		_checkBoxes = this.find(':checkbox');
		_options.context = this;
		this.find('.pager a').click(pagerIndexClick);
		getProductListFromQueryString(_options.selectedProductParam);
		getProductListForSelectedProducts();
		setCheckBoxForSelectedProducts(_options.selectedProducts);
		setNavigationHyperlinkForSelectedCheckBoxes();
		setUrlForNavigationLinks();
	};

	function itemSelect(event) {
		var span = $(event.currentTarget).next('span');
		var productId = $(event.currentTarget).val();
		if ($(event.currentTarget).is(':checked')) {
			if (_options.displayCompare && (_options.selectedProducts.length + 1) >= _options.noOfItemsToCompare) {
				var msg = "Can't compare more than " + _options.noOfItemsToCompare + " items";
				$(event.currentTarget).prop('checked', false);
				alert(msg);
			}
			else if ($.inArray(productId, _options.selectedProducts) == -1) {
				_options.selectedProducts.push(productId);
				addNavigationHyperlink(span);
				setUrlForNavigationLinks();
			}
		}
		else {
			$(span).children().remove();
			if (_options.displayCompare) {
				$(span).text('select to compare');
			}
			else {
				$(span).text('select to request information');
			}
			for (var i = 0; i < _options.selectedProducts.length; i++) {
				if (_options.selectedProducts[i] == productId) {
					_options.selectedProducts.splice(i, 1);
					setUrlForNavigationLinks();
					break;
				}
			}
		}
	}

	function getProductListFromQueryString(selectedProductParam) {
		var url = window.location;
		var parameter = selectedProductParam + "=";
		var selectedProductString = "";
		var selectedProducts = [];
		var urlComponents = url.href.split("?");
		var queryStrings = [];
		if (urlComponents.length > 1) {
			queryStrings = urlComponents[1].split("&");
		}

		for (var i = 0; i < queryStrings.length; i++) {
			if (queryStrings[i].indexOf(parameter) >= 0) {
				selectedProductString = queryStrings[i].replace(parameter, "");
			}
		}

		if (selectedProductString != "") {
			_options.selectedProducts = selectedProductString.split(',');
		}

		return selectedProducts;
	}

	function getProductListForSelectedProducts() {
		_checkBoxes.each(function(i, domElement) {
			if ($(domElement).is(':checked') && $.inArray($(domElement).val(), _options.selectedProducts) == -1) {
				_options.selectedProducts.push($(domElement).val());
			}
		});
	}

	function setCheckBoxForSelectedProducts(selectedProducts) {
		_checkBoxes.each(function(i, domElement) {
			if ($.inArray($(domElement).val(), selectedProducts) != -1) {
				$(domElement).attr('checked', 'true');
			}
		});
	}

	function getCommaSeperatedProductIds(forNavigationUrl) {
		var productIds = '';
		if (forNavigationUrl) {
			productIds = _options.pageProductId;
		}

		$.each(_options.selectedProducts, function(index, value) {
		if (!_options.displayCompare || !forNavigationUrl) {
				if (index > 0 || forNavigationUrl) {
					productIds = productIds + "," + value;
				}
				else {
					productIds = value;
				}
			}
			else if ((index + 1) < _options.noOfItemsToCompare){
				if (index > 0 || forNavigationUrl) {
					productIds = productIds + "," + value;
				}
				else {
					productIds = value;
				}
			 }
		});

		return productIds;
	}

	function getNavigationPageUrl() {
		var productIds = getCommaSeperatedProductIds(true);
		var url = '';
		if (_options.displayCompare) {
			url = _options.comparePageUrl + '&' + _options.compareParameter + '=' + productIds;
		}
		else {
			url = _options.leadFormUrl + '&' + _options.leadProductIdParameter + '=' + productIds;
		}

		return url;
	}

	function setUrlForNavigationLinks() {
		var url = getNavigationPageUrl();
		$(_options.context).find('.navigationLink').attr('href', url);
	}

	function addNavigationHyperlink(control) {
		$(control).text('');
		if (_options.displayCompare) {
			$(control).append('<a title="Compare selected products" href="" class="navigationLink">compare with product</a>');
		}
		else {
			$(control).append('<a title="Request information for selected products" href="" class="navigationLink">request information</a>');
		}
	}

	function setNavigationHyperlinkForSelectedCheckBoxes() {
		var span = '';
		_checkBoxes.each(function(i, domElement) {
			if ($(domElement).is(':checked')) {
				span = $(domElement).next('span');
				addNavigationHyperlink(span);
			}
		});
	}

	function pagerIndexClick(event) {
		var pagerLink = $(event.currentTarget);
		var url = addSelectedProductsToUrl($(pagerLink).attr('href'));
		$(pagerLink).attr('href', url);
	}

	function addSelectedProductsToUrl(url) {
		var urlComponents = url.split("&");
		var foundSelectParam = false;
		var productList = getCommaSeperatedProductIds(false);
		var selectParam = _options.selectedProductParam + "=";

		$.each(urlComponents, function(i, value) {
			if (urlComponents[i].indexOf(selectParam) >= 0) {
				urlComponents[i] = selectParam + productList;
				foundSelectParam = true;
			}
		});

		if (foundSelectParam) {
			url = urlComponents.join("&");
		}
		else {
			url += "&" + selectParam + productList;
		}

		return url;
	}

	$.fn.relatedProduct.defaults =
	{
		context: '',
		selectedProductParam: 'sel',
		comparePageUrl: '',
		selectedProducts: [],
		pageProductId: '',
		compareParameter: '',
		displayCompare: true,
		leadFormUrl: '',
		leadProductIdParameter: '',
		noOfItemsToCompare: 5
	};
})(jQuery);