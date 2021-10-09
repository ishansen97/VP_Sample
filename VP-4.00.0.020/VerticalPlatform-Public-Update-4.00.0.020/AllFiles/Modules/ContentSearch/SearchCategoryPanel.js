RegisterNamespace("VP.SearchCategory");

var ContentType = { 
    Category: 'category',
    Article: 'article'
};

$(document).ready(function () {
	var searchCategory = new VP.SearchCategory.SearchTool();
	$(".category-search-group-0").hide();
	searchCategory.Init();

	if ($('#vendorFilter') !== undefined) {
		$('#vendorFilter').keyup(function () {
			VP.SearchCategory.SearchTool.RunFilter($('.vendors-list li'), $.trim($(this).val()))
		});
	}
});

VP.SearchCategory.SearchTool = function() {
	this.searchContent = $("#divSearchPanel");
	this.searchButton = $(".btnProductSearch", this.searchContent);
	this.searchButtonBottom = $(".btnProductSearchBottom", this.searchContent);
	this.resetButton = $(".btnReset", this.searchContent);
	this.selectedOptions = $("div.selected-group-options", this.searchContent);
	this.selectedVendors = $("div.selected-vendors", this.searchContent);
	this.searchInput = $(".txtSearch", this.searchContent);
	this.selectedContentType = $("#hdnContentType", this.searchContent).val();
};

VP.SearchCategory.SearchTool.prototype.Init = function () {
	var that = this;
	this.selectedSearchOptions = [];
	this.vendorIds = [];
	this.selectedSearchAspect = "0";
	this.searchText = "";
	this.searchKey = "search";
	this.searchOptionsKey = "soids";
	this.searchAspectKey = "said";
	this.vendorsKey = "vids";
	this.currentOption = {};
	this.SetOptionValuesFromQueryString();
	this.PopulateInputControls();
	this.ShowSelectedOptions();
	this.DisableInvalidOptions();

	$(this.searchButton).click(function (e) {
		e.preventDefault();
		that.Search();
	});

	$(this.searchButtonBottom).click(function (e) {
		e.preventDefault();
		that.Search();
	});

	$(this.resetButton).click(function (e) {
		e.preventDefault();
		var reset = confirm("Are you sure you want to clear all filters?");
		if (reset === true) {
			that.ClearSelection();
			categoryUrl = $("#hdnCategoryUrl", this.searchContent).val();
			location.href = categoryUrl;
		} else {
			return false;
		}
	});

	$('h5', this.searchContent).on('click', function (e) {
		if ($(this).parents('.inner').hasClass('show')) {
			$(this).parents('.inner').removeClass('show');
		} else {
			$(this).parents('.inner').addClass('show');
		}
	});

	$("a.option", this.searchContent).on("click", function (e) {
		e.preventDefault();
		that.UpdateGroupOptionList($(this));
		that.DisableInvalidOptions();
	});

	$("a.vendor", this.searchContent).on("click", function (e) {
		e.preventDefault();
		that.UpdateVendorList($(this));
		that.DisableInvalidOptions();
	});

	$("a.guided-option", this.searchContent).on("click", function (e) {
		e.preventDefault();
		that.UpdateGuidedOptions($(this));
	});

	$("a", this.selectedOptions).on("click", function (e) {
		e.preventDefault();
		var option = that.GetOptionIdAttr(that.GetIdValue($(this).attr("id")));
		$("#" + option, this.searchContent).trigger("click");
	});

	$("a", this.selectedVendors).on("click", function (e) {
		e.preventDefault();
		var option = that.GetVendorIdAttr(that.GetIdValue($(this).attr("id")));
		$("#" + option, this.searchContent).trigger("click");
	});

	$("input.searchAspect", this.searchContent).change(function () {
		var selectedAspect = $("input.searchAspect:checked").val();
		if (selectedAspect != "") {
			that.selectedSearchAspect = selectedAspect;
			that.DisableInvalidOptions();
		}
	});

	$(".txtSearch", this.searchContent).change(function () {
		that.searchText = encodeURIComponent($.trim($(this).val()));
	});

	$(".txtSearch", this.searchContent).keypress(function (event) {
		if (event.which == 13) {
			that.searchText = encodeURIComponent($.trim($(this).val()));
			that.Search();
			event.returnValue = false;
			event.cancel = true;
			event.keyCode = 0;
			return false;
		}
	});

	$("a.apply-changes", this.searchContent).hide();
	$("a.apply-changes", this.searchContent).on("click", function (e) {
		e.preventDefault();
		that.Search();
	});

	if (!that.DetectMobile()) {
		that.RepositionAppliedFilters();
	}

	$("a.filterOption").click(function (e) {
		e.preventDefault();
		that.UpdateAppliedFilters($(this));
	});

	$("a.vendorFilter").click(function (e) {
		e.preventDefault();
		that.UpdateAppliedVendorList($(this));
	});
	$(".category-search-group-0").show();
	$(".applied-filters-list").show();
};

VP.SearchCategory.SearchTool.prototype.RepositionAppliedFilters = function () {
	var that = this;
	var divSerachContentHeader = $(".searchCategoryProductCountMessage");
	var alternateSerachContentHeader = $(".searchCategoryMessage");
	var appliedFilters = $(".category-search-group-0");
	$(".category-search-group-0 .inner div").removeClass("filters collapse").addClass("filter-list-container");

	if (divSerachContentHeader.length) {
		appliedFilters.insertAfter(divSerachContentHeader);
	} else {
		appliedFilters.insertBefore(alternateSerachContentHeader);
	}
};

VP.SearchCategory.SearchTool.prototype.MakeVisualTweaks = function() {
	$('.filters-set', this.searchContent).each(function(i, domElement) {
		$(domElement).width($(domElement).width() + 5); 
	});
};

VP.SearchCategory.SearchTool.prototype.SetOptionValuesFromQueryString = function () {
	var search, searchAspect, vendors, subCategoryOptions;
	search = $("#hdnSearchText", this.searchContent).val();
	if (search != undefined && search != "") {
		this.searchText = search;
	}

	searchAspect = $("#hdnSearchAspect", this.searchContent).val();
	if (searchAspect != undefined && searchAspect != "") {
		this.selectedSearchAspect = searchAspect;
	}

	vendors = $("#hdnVendorIds", this.searchContent).val();
	if (vendors != undefined && vendors != "") {
		this.vendorIds = vendors.split(",");
	}

	subCategoryOptions = $("#hdnSearchOptions", this.searchContent).val();
	if (subCategoryOptions != undefined && subCategoryOptions != "") {
		var selectedGroupOptions = this.ReorderOptions(subCategoryOptions);
		this.selectedSearchOptions = selectedGroupOptions.split(",");
	}
};

VP.SearchCategory.SearchTool.prototype.PopulateInputControls = function () {
	$(".txtSearch", this.searchContent).val($("<div/>").html(decodeURIComponent(this.searchText)).text());
	if (this.selectedSearchAspect != "" && $("input.searchAspect", this.searchContent).length > 0) {
		$('input:radio[name=' + this.searchAspectKey + ']').filter('[value="' + this.selectedSearchAspect +
				'"]').attr('checked', true);
	}
	if (this.selectedSearchOptions.length > 0) {
		var that = this;
		$.each(this.selectedSearchOptions, function () {
			var selected = $("#" + that.GetOptionIdAttr(this), that.searchContent);
			if ($(selected).length != 0) {
				var parentUl = $(selected).parent().parent();
				$(selected).parent().addClass("selected");
				parentUl.find('li.any').removeClass("selected");
				that.ShowChildOptionList(selected);
				that.ShowDependentOptionList(selected);
			} else {
				that.SetGuidedOption(this);
			}
		});
	}

	if (this.vendorIds.length > 0) {
		var that = this;
		$.each(this.vendorIds, function () {
			var selected = $("#" + that.GetVendorIdAttr(this), that.searchContent);
			var parentUl = $(selected).parent().parent();
			$(selected).parent().addClass("selected");
		});
	}
};

VP.SearchCategory.SearchTool.prototype.Search = function () {
    var articleEnabled, queryComponents, categoryUrl, searchOptions, that;
    contentType = this.selectedContentType;
	queryComponents = [];
	searchOptions = [];
	categoryUrl = $("#hdnCategoryUrl", this.searchContent).val();
	that = this;

	if (this.searchText != "") {
		queryComponents.push(this.searchKey + "=" + encodeURIComponent(this.searchText));
	}
	if (this.selectedSearchAspect != "") {
		queryComponents.push(this.searchAspectKey + "=" + this.selectedSearchAspect);
	}
	if (this.selectedSearchOptions.length > 0) {
		queryComponents.push(this.searchOptionsKey + "=" + this.selectedSearchOptions.join(","));
	}

	if (this.vendorIds.length > 0) {
		queryComponents.push(this.vendorsKey + "=" + this.vendorIds.join(","));
	}

	if (contentType === ContentType.Category) {
	    if (this.vendorIds.length == 0 && this.selectedSearchOptions.length == 0 && this.searchText == "") {
	        alert('Please enter a search term or choose a filter');
	        return false;
	    } else {
	        this.searchButton.addClass('disabled');
	        this.searchButtonBottom.addClass('disabled');
	    }

	    if (queryComponents.length > 0) {
	        location.href = categoryUrl + "?" + queryComponents.join("&");
	    } else {
	        location.href = categoryUrl;
	    }
	} else if (contentType === ContentType.Article) {
	    this.searchButton.addClass('disabled');
	    this.searchButtonBottom.addClass('disabled');

	    if (queryComponents.length > 0) {
	        location.href = location.pathname + '?' + queryComponents.join('&');
	    } else {
	        location.href = location.pathname;
	    }
	    return false;
    }

};

VP.SearchCategory.SearchTool.prototype.DisableInvalidOptions = function () {
	var that = this;
	var url = VP.AjaxWebServiceUrl + "/GetValidSearchOptions";
	var progressiveEnabled = $("#hdnEnableProgressive", this.searchContent).val();
	var categoryId = $("#hdnSearchCategoryId", this.searchContent).val();
	var searchText = this.searchText.split("'").join("\\'");
	var searchAspect = this.selectedSearchAspect;
	var searchOptions = this.selectedSearchOptions.join(",");
	var vendorIds = this.vendorIds.join(",");
	var contentType = this.selectedContentType;

	if (contentType === ContentType.Category &&
        progressiveEnabled == "true" &&
        (this.vendorIds.length > 0 ||
        this.selectedSearchOptions.length > 0 ||
        this.searchText != ""))
	{
		
		$.ajax({
			type: "POST",
			async: true,
			cache: false,
			url: url,
			data: "{'categoryId' : " + categoryId +
				", 'searchText' : '" + searchText + "'" +
				", 'searchAspect' : " + searchAspect +
				", 'searchOptions' : '" + searchOptions + "'" +
				", 'vendorIds' : '" + vendorIds + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				
				$(that.searchContent).find("ul.search-options-list li").each(function (index) {
					$(this).addClass("invalid");
					var link = $(this).find('a');
					$(link).text($(link).attr("title"));
				});

				$(that.searchContent).find("ul.vendors-list li").each(function (index) {
					$(this).addClass("invalid");
					var link = $(this).find('a');
					$(link).text($(link).attr("title"));
				});

				for (var i = 0; i < msg.d.SearchOptions.length; i++) {
					var optionInfo = msg.d.SearchOptions[i];
					var optionA = $("#oid_" + optionInfo.Id, this.searchContent);
					if ($(optionA).length > 0) {
						var text = $(optionA).attr("title");
						$(optionA).text(text + " (" + optionInfo.Count + ")");
						$(optionA).parent().removeClass("invalid")
					}
				}

				for (var i = 0; i < msg.d.Vendors.length; i++) {
					var vendorInfo = msg.d.Vendors[i];
					var vendorA = $("#vid_" + vendorInfo.Id, this.searchContent);
					if ($(vendorA).length > 0) {
						var text = $(vendorA).attr("title");
						$(vendorA).text(text + " (" + vendorInfo.Count + ")");
						$(vendorA).parent().removeClass("invalid")
					}
				}				
				
			},
			error: function (xmlHttpRequest, textStatus, errorThrown) {
				var message = "";
			},
			complete: function (url, settings) {				
				VP.SearchCategory.SearchTool.prototype.DisableInvalidOptionsCommon(that);				
            }
		});
	} else {
		$(that.searchContent).find("ul.search-options-list li").each(function (index) {
			$(this).removeClass("invalid");
			var link = $(this).find('a');
			$(link).text($(link).attr("title"));
		});

		$(that.searchContent).find("ul.vendors-list li").each(function (index) {
			$(this).removeClass("invalid");
			var link = $(this).find('a');
			$(link).text($(link).attr("title"));
		});

		VP.SearchCategory.SearchTool.prototype.DisableInvalidOptionsCommon(that);
	}	
};

VP.SearchCategory.SearchTool.prototype.DisableInvalidOptionsCommon = function (that) {	
	$(that.searchContent).find("ul.search-options-list li.invalid").each(function () {
		if (!$(this).hasClass('any')) {
			$(this).appendTo($(this).parent());
		}
	});

	$(that.searchContent).find("ul.vendors-list li.invalid").each(function () {
		if (!$(this).hasClass('any')) {
			$(this).appendTo($(this).parent());
		}
	});
}

VP.SearchCategory.SearchTool.prototype.ClearSelection = function () {
	this.selectedSearchOptions = [];
	this.vendorIds = [];
	this.selectedSearchAspect = "0";
	this.searchText = "";
	this.PopulateInputControls();
	$(".guided-options", this.searchContent).html("");
	$(this.searchContent).find("ul.option-list").each(function (index) {
		$(this).find('li.selected').removeClass("selected");
		$(this).find('li.invalid').removeClass("invalid");
		$(this).find('li.any').addClass('selected').prependTo(this);
		if ($(this).parent().parent().parent().hasClass("child-group")) {
			defaultOption = $('li.any', this);
			$(this).empty().append(defaultOption);
			$(this).parent().parent().parent().addClass("hide-group");
		}
	});

	$(this.searchContent).find("ul.option-list li a").each(function (index) {
		$(this).text($(this).attr("title"));
	});

	$("a.apply-changes", this.searchContent).hide();
};

VP.SearchCategory.SearchTool.prototype.GetIdValue = function(idAttr) {
	var idValue = "";
	if (idAttr != "" && idAttr != undefined) {
		idValue = idAttr.split('_')[1];
	}
	return idValue;
};

VP.SearchCategory.SearchTool.prototype.GetOptionIdAttr = function(idValue) {
	return "oid_" + idValue;
};

VP.SearchCategory.SearchTool.prototype.GetVendorIdAttr = function(idValue) {
	return "vid_" + idValue;
};

VP.SearchCategory.SearchTool.prototype.AddSearchOption = function(selectedOption) {
	if ($.inArray(selectedOption, this.selectedSearchOptions) == -1) {
		this.selectedSearchOptions.push(selectedOption);
		this.ShowSelectedOptions();
	}
};

VP.SearchCategory.SearchTool.prototype.RemoveSearchOption = function(selectedOption) {
	if ($.inArray(selectedOption, this.selectedSearchOptions) > -1) {
		this.selectedSearchOptions.splice($.inArray(selectedOption, this.selectedSearchOptions), 1);
		this.ShowSelectedOptions();
	}
};

VP.SearchCategory.SearchTool.prototype.UpdateGroupOptionList = function (current) {
	var currentUl, firstLi, selection, that;
	that = this;
	selection = that.GetIdValue($(current).attr("id"));
	currentUl = $(current).parent().parent();
	firstLi = $(currentUl).find('li.any');

	if ($(current).parent().hasClass("selected")) {
		if (selection != "") {
			$(current).parent().removeClass("selected");
			$('li.any', currentUl).after($(current).parent());
			that.RemoveSearchOption(selection);
			that.ShowChildOptionList(current);
			that.ShowDependentOptionList(current);
			if ($(currentUl).find("li.selected").length == 0) {
				$(firstLi).addClass("selected");
				that.HideChildOptionList(current);
				that.HideDependentOptionList(current);
			}
		}
	} else {
		if (selection == "") {
			$(currentUl).find('li > a').each(function (index) {
				that.RemoveSearchOption(that.GetIdValue($(this).attr("id")));
				$(this).parent().removeClass("selected");
			});
			$(current).parent().addClass("selected");
			that.HideChildOptionList(current);
			that.HideDependentOptionList(current);
		} else {
			$(firstLi).removeClass("selected");
			$(current).parent().addClass("selected");
			that.AddSearchOption(selection);
			that.ShowChildOptionList(current);
			that.ShowDependentOptionList(current);
		}
	}

	applyChangesButton = $(current).parent().parent().parent().parent().parent().find('a.apply-changes');
	applyChangesButton.show();
};

VP.SearchCategory.SearchTool.prototype.UpdateVendorList = function(current) {
	var currentUl, firstLi, selection, that;
	that = this;
	selection = that.GetIdValue($(current).attr("id"));
	currentUl = $(current).parent().parent();
	
	if ($(current).parent().hasClass("selected")) {
		if (selection != "") {
			$(current).parent().removeClass("selected");
			if ($.inArray(selection, this.vendorIds) > -1) {
				this.vendorIds.splice($.inArray(selection, this.vendorIds), 1);
				this.ShowSelectedOptions();
			}
		}
	} else {
		$(current).parent().addClass("selected");
		if ($.inArray(selection, this.vendorIds) == -1) {
			this.vendorIds.push(selection);
			this.ShowSelectedOptions();
		}
	}

	applyChangesButton = $(current).parent().parent().parent().parent().parent().find('a.apply-changes');
	applyChangesButton.show();
};

VP.SearchCategory.SearchTool.prototype.ShowChildOptionList = function(current) {
	var currentUl, childGroupDiv, childGroupUl, parentOptionIds, newOptionHtml, currentOptionList,
		newOptionList, that, childGroupUlId;
	that = this;
	childGroupDiv = $(current).parent().parent().parent().parent().parent().next();
	
	if ($(childGroupDiv).hasClass("child-group")) {
		parentOptionIds = [];
		currentOptionList = [];
		newOptionList = [];
		childGroupUl = $(childGroupDiv).find('ul:first-child');
		currentUl = $(current).parent().parent();
		
		$(currentUl).find('li.selected > a').each(function(index) {
			parentOptionIds.push(that.GetIdValue($(this).attr("id")));
		});
		$(childGroupUl).find('li > a').each(function(index) {
			currentOptionList.push(that.GetIdValue($(this).attr("id")));
		});
		
		childGroupUlId = that.GetIdValue($(childGroupUl).attr("id"));
		newOptionHtml = that.GetGroupOptions(childGroupUlId, parentOptionIds.join(","));
		if (newOptionHtml != "") {
			$(childGroupUl).html(newOptionHtml);
			$(childGroupUl).find('li > a').each(function(index) {
				newOptionList.push(that.GetIdValue($(this).attr("id")));
			});
			that.UpdateSearchOption(currentOptionList, newOptionList);
			$(childGroupUl).find('li > a').each(function(index) {
				if ($(this).attr("id") != "" && $.inArray(that.GetIdValue($(this).attr("id")), that.selectedSearchOptions) > -1) {
					$(this).parent().addClass("selected");
					$(childGroupUl).find('li:first-child').removeClass("selected");
				}
			});
			$(childGroupDiv).removeClass("hide-group");
		} else {
			that.HideChildOptionList(current);
			that.HideDependentOptionList(current);
		}
	}
};

VP.SearchCategory.SearchTool.prototype.ShowDependentOptionList = function (current) {
	var childGroupUl, that;
	that = this;
	if ($(current).hasClass("has-children")) {
		childGroupUl = $(current).next();
		$(childGroupUl).find('li > a').each(function (index) {
			if ($(this).attr("id") != "" && $.inArray(that.GetIdValue($(this).attr("id")), that.selectedSearchOptions) > -1) {
				$(this).parent().addClass("selected");
			}
		});

		$(childGroupUl).removeClass("hide-group");
	} else if ($(current).hasClass("child-option")) {
		childGroupUl = $(current).parent().parent();
		$(childGroupUl).find('li > a').each(function (index) {
			if ($(this).attr("id") != "" && $.inArray(that.GetIdValue($(this).attr("id")), that.selectedSearchOptions) > -1) {
				$(this).parent().addClass("selected");
			}
		});

		$(childGroupUl).removeClass("hide-group");
	}
};

VP.SearchCategory.SearchTool.prototype.UpdateSearchOption = function(currentOptionList, newOptionList) {
	var i;
	for (i = 0; i < currentOptionList.length; i++) {
		if ($.inArray(currentOptionList[i], newOptionList) == -1) {
			this.RemoveSearchOption(currentOptionList[i]);
		}
	}
};

VP.SearchCategory.SearchTool.prototype.HideChildOptionList = function(current) {
	var childGroupDiv, childGroupUl, that, defaultOption;
	that = this;
	childGroupDiv = $(current).parent().parent().parent().parent().parent().next();
	if ($(childGroupDiv).hasClass("child-group")) {
		childGroupUl = $(childGroupDiv).find('ul:first-child');
		$(childGroupUl).find('li > a').each(function(index) {
			that.RemoveSearchOption(that.GetIdValue($(this).attr("id")));
		});
		defaultOption = $('li.any', childGroupUl);
		$(childGroupUl).empty().append(defaultOption);
		$(childGroupDiv).addClass("hide-group");
	}
};

VP.SearchCategory.SearchTool.prototype.HideDependentOptionList = function (current) {
	var childGroupUl, that;
	that = this;
	if ($(current).hasClass("has-children")) {
		childGroupUl = $(current).next();
		$(childGroupUl).find('li > a').each(function (index) {
			that.RemoveSearchOption(that.GetIdValue($(this).attr("id")));
		});
		$(childGroupUl).addClass("hide-group");
	}
};

VP.SearchCategory.SearchTool.prototype.GetGroupOptions = function(searchGroupId, parentOptionIds) {
	var options;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetDependentGroupOptions",
		data: "{'categorySearchGroupId' : '" + searchGroupId + "','parentOptionIds' : '" + parentOptionIds + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			options = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});
	return options;
};

VP.SearchCategory.SearchTool.prototype.GetSearchOptionName = function(searchOptionId) {
	var optionName = "";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetSearchOptionName",
		data: "{'searchOptionId' : '" + searchOptionId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			optionName = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});
	return optionName;
};

VP.SearchCategory.SearchTool.prototype.ReorderOptions = function(OptionIds) {
	var options, child, parent, that, current;
	options = OptionIds.split(',');
	that = this;
	if (options.length > 1) {
		child = [];
		parent = [];
		$.each(options, function() {
			current = $("#" + that.GetOptionIdAttr(this));
			if ($(current).length == 0) {
				child.push(this);
			} else {
				parent.push(this);
			}
		});
		options = parent.concat(child);
	}
	return options.join(',');
};

VP.SearchCategory.SearchTool.prototype.SetGuidedOption = function(optionId) {
	var optionName, guidedOptionHtml;
	optionName = this.GetSearchOptionName(optionId);
	guidedOptionHtml = "<a id='guided_" + optionId + "' href='#' class='guided-option' title='Remove " +
			optionName + " as a search term' ><span>" + optionName + "</span></a>";
	$(".guided-options", this.searchContent).append(guidedOptionHtml);
};

VP.SearchCategory.SearchTool.prototype.UpdateGuidedOptions = function(current) {
	var selection;
	selection = this.GetIdValue($(current).attr("id"));
	this.RemoveSearchOption(selection);
	$(current).detach();
};

VP.SearchCategory.SearchTool.prototype.ShowSelectedOptions = function() {
	var that, selectedOptionHtml;
	that = this;
	$('.filters-set', this.searchContent).each(function(i, domElement) {
		selectedOptionHtml = "";
		$.each(that.selectedSearchOptions, function() {
			var selectedRow = $("#" + that.GetOptionIdAttr(this), domElement);
			if(selectedRow.length > 0) {
				selectedOptionHtml += "<a id='sel_" + this + "' href='#' title='Remove " + selectedRow.text() +
					" as a search term' ><span>" + selectedRow.text() + "</span></a>";
			};
		});
			
		$('.selected-group-options', domElement).html(selectedOptionHtml);
	});
	
	selectedOptionHtml = "";
	$.each(that.vendorIds, function() {
		var selectedRow = $("#" + that.GetVendorIdAttr(this), $('.vendor-list', this.searchContent));
		if(selectedRow.length > 0) {
			selectedOptionHtml += "<a id='sel_" + this + "' href='#' title='Remove " + selectedRow.text() +
				" as a company' ><span>" + selectedRow.text() + "</span></a>";
		};
	});
	
	$(this.selectedVendors).html(selectedOptionHtml);
};

VP.SearchCategory.SearchTool.ClearFilter = function (filterInput, optionsList) {
	if (optionsList != undefined) {
		optionsList.each(function (index) {
			$(this).show();
		});
	}

	if (filterInput != undefined) {
		filterInput.val('');
	}
};

VP.SearchCategory.SearchTool.RunFilter = function(optionsList, filterText) {
	if (optionsList != undefined) {
		optionsList.each(function (index) {
			var innerAnchorTag = $(this).find('a');
			if (innerAnchorTag != undefined) {
				if (innerAnchorTag.attr('title').toLowerCase().indexOf(filterText.toLowerCase()) < 0) {
					$(this).hide();
				}
				else {
					$(this).show();
				}
			}
		});
	}
};

VP.SearchCategory.SearchTool.prototype.UpdateAppliedFilters = function (current) {
	var that;
	that = this;
	selection = that.GetIdValue($(current).attr("id"));
	if (selection)
	{
		that.RemoveSearchOption(selection);
		that.Search();
	}
};

VP.SearchCategory.SearchTool.prototype.RemoveVendor = function (id) {
	if ($.inArray(id, this.vendorIds) > -1) {
		this.vendorIds.splice($.inArray(id, this.vendorIds), 1);
	}
};

VP.SearchCategory.SearchTool.prototype.UpdateAppliedVendorList = function (current) {
	var that;
	that = this;
	selection = that.GetIdValue($(current).attr("id"));
	if (selection) {
		that.RemoveVendor(selection);
		that.Search();
	}
};

VP.SearchCategory.SearchTool.prototype.DetectMobile = function() {
	return $(window).width() <= 1025;
};