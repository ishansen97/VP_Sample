(function ($, ko) {
	$.fn.multiColumnContentPicker = function (options) {
		var initialOptions = $.extend({}, $.fn.multiColumnContentPicker.defaults, options);
		$(document).mousedown(checkExternalClick);
		return this.each(function () {
			var elm = $(this);
			if (this._cpid) {
				return true;
			}
			_count++;
			this._cpid = _count;
			_hash[_count] = {
				e: elm,
				o: initialOptions
			};

			$.multiColumnContentPicker.bindElement(_count);
		});
	};

	$.fn.multiColumnContentPicker.defaults = {
		siteId: VP.SiteId,
		contentType: "Article",
		searchText: "",
		pageIndex: 1,
		pageSize: 15,
		sortBy: "Id",
		ascendingSortOrder: true,
		selectionType: "Id",
		enabled: null,
		displaySites: false,
		displayArticleTypes: false,
		selectedSiteId: VP.SiteId,
		selectedArticleTypeId: 0,
		isArticleTemplate: null,
		isArticlePublished: null,
		isArticleCrossPosted: null,
		showArticleTypeColumn: true,
		showArticlePublishedColumn: true
	};

	$.multiColumnContentPicker = {
		hash: {},
		bindElement: function (elementId) {
			w = _hash[elementId];
			var element = w.e;
			var options = w.o;
			element.data("eId", elementId);

			element.focus(function () {
				if (_contentPickerDisplay !== true) {
					createContentPickerPopUpHtml(element, options);
					ko.applyBindings(new dataModel(element, options));
					setCustomBindings(element);
				}
			});
		}
	};

	function checkExternalClick(event) {
		var target = $(event.target);

		if (_activeElement !== null) {
			if (target.attr('id') !== _activeElement.attr('id') &&
					(target.attr('id') !== 'cpp_divContentPickerPopUp') &&
					(target.parents('#cpp_divContentPickerPopUp').length === 0) &&
					(target.attr('class').indexOf("ui-corner-all") === -1)) {

				removeContentPickerPopUp();
			}
		}
	}

	function removeContentPickerPopUp() {
		$('.contentPickerPopUp').remove();
		_activeElement = null;
		_contentPickerDisplay = false;
	}

	function setCustomBindings(element) {
		$("." + element.data("eId") + "_contentTableRow").live('mouseover', function () {
			$(this).addClass("contentTableRaw-select");
		});

		$("." + element.data("eId") + "_contentTableRow").live('mouseout', function () {
			$(this).removeClass("contentTableRaw-select");
		});
	}

	function createContentPickerPopUpHtml(element, options) {
		var position = element.position();
		var left = position.left;
		var top = position.top + 25;
		var style = "position:absolute;top:" + top + "px;left:" + left + "px;";
		var html = "<div class='contentPickerPopUp' id='cpp_divContentPickerPopUp' style='" + style + "'>" +
						"<div data-bind='if: displaySites'>" +
							"<div class='cpp_siteFilter contentPickerSite clearfix'>" +
								"<h3>Site</h3>" +
								"<div id='cpp_divSiteFilter'>" +
									"<select data-bind=\"options: sitesList, optionsText: 'Text', optionsValue: 'Value', value: selectedSiteId, event: {change: siteSelectionChanged}\"></select>" +
								"</div>" +
							"</div>" +
						"</div>" +
						"<div data-bind='if: displayArticleTypes'>" +
							"<div class='cpp_articleTypeFilter contentPickerArticleType clearfix'>" +
								"<h3>Article Type</h3>" +
								"<div id='cpp_divArticleTypeFilter'>" +
									"<select data-bind=\"options: articleTypesList, optionsText: 'Text', optionsValue: 'Value', value: selectedArticleTypeId, event: {change: articleTypeSelectionChanged}\"></select>" +
								"</div>" +
							"</div>" +
						"</div>" +
						"<div id='cpp_divTabs'>" +
							"<ul>" +
								"<li><a href='#cpp_tabSearch' data-bind='click: searchTabClicked'>Search</a></li>" +
								"<li><a href='#cpp_tabBrowse' data-bind='click: browseTabClicked'>Browse</a></li>" +
							"</ul>" +
							"<div id='cpp_tabSearch'>" +
								"<div>" +
									"<input id='cpp_txtSearch' class='cpp_searchTextBox' type='text' data-bind=\"value: searchText, valueUpdate: 'afterkeydown', event: {keyup: getSearchResults}\"/>" +
								"</div>" +
								"<div id='cpp_divSearchResults'>" +
									"<table id='cpp_tblSearchResults' class='categoryTable common_data_grid' cellpadding='0' cellspacing='0' width='100%'>" +
										"<thead>" +
											"<tr data-bind='foreach: searchColumns'>" +
												"<th data-bind='text: $data, click: $parent.columnHeaderClicked'></th>" +
											"<tr>" +
										"</thead>" +
										"<tbody data-bind='foreach: searchResults'>" +
											"<tr data-bind='foreach: $data.Properties, click: $parent.contentRowSelected' class='" + element.data("eId") + "_contentTableRow'>" +
												"<td data-bind='text: $data'></td>" +
											"<tr>" +
										"</tbody>" +
									"</table>" +
								"</div>" +
							"</div>" +
							"<div id='cpp_tabBrowse'>" +
								"<div id='cpp_divBrowseResults'>" +
									"<table id='cpp_tblBrowseResults' class='categoryTable common_data_grid' cellpadding='0' cellspacing='0' width='100%'>" +
										"<thead>" +
											"<tr data-bind='foreach: browseColumns'>" +
												"<th data-bind='text: $data, click: $parent.columnHeaderClicked'></th>" +
											"<tr>" +
										"</thead>" +
										"<tbody data-bind='foreach: browseResults'>" +
											"<tr data-bind='foreach: $data.Properties, click: $parent.contentRowSelected' class='" + element.data("eId") + "_contentTableRow'>" +
												"<td data-bind='text: $data'></td>" +
											"<tr>" +
										"</tbody>" +
									"</table>" +
								"</div>" +
								"<div id='pager' class='clearfix'></div>" +
							"</div>" +
						"</div>" +
					"</div>";

		element.after(html);
		_activeElement = element;
		_contentPickerDisplay = true;
		$('.cpp_searchTextBox').focus();

		$("#cpp_divTabs").tabs({
	});
}

function dataModel(element, options) {
	var self = this;

	self.displaySites = ko.observable(options.displaySites);
	self.displayArticleTypes = ko.observable(options.displayArticleTypes)
	self.selectedSiteId = ko.observable(options.siteId);
	self.selectedArticleTypeId = ko.observable(options.selectedArticleTypeId);
	self.searchText = ko.observable(options.searchText);
	self.selectedRowClass = ko.observable('');
	self.isSearchTabActive = ko.observable(true);

	self.sitesList = ko.observableArray([]);
	self.articleTypesList = ko.observableArray([]);
	self.searchColumns = ko.observableArray([]);
	self.searchResults = ko.observableArray([]);
	self.browseColumns = ko.observableArray([]);
	self.browseResults = ko.observableArray([]);

	if (self.displaySites()) {
		self.sitesList(getDropDownValues("Site", options).DropDownResults);
	}

	if (self.displayArticleTypes()) {
		self.articleTypesList(getDropDownValues("ArticleType", options).DropDownResults);
	}

	self.siteSelectionChanged = function () {
		options.selectedSiteId = self.selectedSiteId();
		if (options.isArticleCrossPosted && options.selectedSiteId != options.siteId) {
			self.displayArticleTypes(false);
		}
		else {
			self.displayArticleTypes(true);
		}

		if (self.displayArticleTypes()) {
			self.articleTypesList(getDropDownValues("ArticleType", options).DropDownResults);
		}
		options.pageIndex = 1;
		self.loadTabsData();
	};

	self.articleTypeSelectionChanged = function () {
		options.selectedArticleTypeId = self.selectedArticleTypeId();
		options.pageIndex = 1;
		self.loadTabsData();
	};

	self.columnHeaderClicked = function (column) {
		options.sortBy = column;
		options.ascendingSortOrder = !options.ascendingSortOrder;
		self.loadTabsData();
	};

	self.searchTabClicked = function () {
		self.isSearchTabActive(true);
		self.getSearchResults();
	};

	self.browseTabClicked = function () {
		options.pageIndex = 1;
		self.isSearchTabActive(false);
		self.getBrowseResults();
	};

	self.contentRowSelected = function (selection) {
		var index = 0;
		if (self.isSearchTabActive()) {
			index = ko.utils.arrayIndexOf(self.searchColumns(), options.selectionType);
		}
		else {
			index = ko.utils.arrayIndexOf(self.browseColumns(), options.selectionType);
		}
		if (index < 0) {
			index = 0;
		}
		element.val(selection.Properties[index]).change();
		removeContentPickerPopUp();
	};

	self.loadTabsData = function () {
		if (self.isSearchTabActive()) {
			self.getSearchResults();
		}
		else {
			self.getBrowseResults();
		}
	};

	self.getSearchResults = function () {
		options.searchText = self.searchText();
		if (options.searchText.length > 0) {
			var response = getSearchResults(options);
			self.searchColumns(response.Columns);
			self.searchResults(response.Results);
		}
	};

	self.getBrowseResults = function () {
		var response = getBrowseResults(options);
		self.browseColumns(response.Columns);
		self.browseResults(response.Results);
		var pageCount = Math.ceil(response.TotalCount / options.pageSize);
		$("#pager").pager({ pagenumber: options.pageIndex, pagecount: pageCount, buttonClickCallback: self.pageClicked });
	};

	self.pageClicked = function (pageIndex) {
		options.pageIndex = pageIndex;
		self.getBrowseResults();
	};
}

function getDropDownValues(contentType, options) {
	var response = null;
	var urlString = VP.AjaxWebServiceUrl + "/GetContentPickerDropDownValues";
	var optionsJson = ko.toJSON(options);
	var dataString = "{ \"options\": " + optionsJson + ", \"contentType\" : \"" + contentType + "\"}";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		timeout: 3000,
		url: urlString,
		data: dataString,
		dataType: "json",
		contentType: "application/json; charset=utf-8",
		success: function (data) {
			response = data.d;
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	return response;
}

function getSearchResults(options) {
	var response = null;
	var urlString = VP.AjaxWebServiceUrl + "/GetContentPickerSearchResults"; ;
	var optionsJson = ko.toJSON(options);
	var dataString = "{ \"options\": " + optionsJson + "}";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		timeout: 3000,
		url: urlString,
		data: dataString,
		dataType: "json",
		contentType: "application/json; charset=utf-8",
		success: function (data) {
			response = data.d;
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	return response;
}

function getBrowseResults(options) {
	var response = null;
	var urlString = VP.AjaxWebServiceUrl + "/GetContentPickerBrowseResults"; ;
	var optionsJson = ko.toJSON(options);
	var dataString = "{ \"options\": " + optionsJson + "}";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		timeout: 3000,
		url: urlString,
		data: dataString,
		dataType: "json",
		contentType: "application/json; charset=utf-8",
		success: function (data) {
			response = data.d;
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	return response;
}

var _count = 0, _hash = $.multiColumnContentPicker.hash, _activeElement = null, _contentPickerDisplay = false;
})(jQuery, ko);