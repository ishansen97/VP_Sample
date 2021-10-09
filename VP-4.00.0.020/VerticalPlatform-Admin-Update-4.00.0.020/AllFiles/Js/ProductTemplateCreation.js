$(document).ready(function () {
	var categoryIdOptions = {
		siteId: VP.SiteId,
		type: "Category",
		currentPage: "1",
		pageSize: "15",
		categoryType: "Leaf"
	};

	var specificationTypeOptions = {
		siteId: VP.SiteId,
		type: "SpecificationType",
		currentPage: "1",
		pageSize: "15"
	};

	$("input[type=text][id*=txtCategory]").contentPicker(categoryIdOptions);
	$("input[type=text][id*=txtSpecificationType]").contentPicker(specificationTypeOptions);

	$(".menuHorizontal .menu li a.active").parent().addClass("selected");

	$("div.AdminPanelContent ul.menu a").click(function () {
		if (typeof (Page_ClientValidate) == 'function') var valid = Page_ClientValidate();
		$("div.tabDiv").hide();
		$("div.tabDiv." + $(this).attr("Id")).show();
		$(".menuHorizontal .menu li").removeClass("selected");
		$(this).parent().addClass("selected");
		return false;
	});

	$("div.tabDiv").hide();

	$("div.menuHorizontal > ul.menu > li").each(function () {
		var ele = $(this);
		if (ele.text().trim().length == 0) {
			ele.hide();
		}

	});

	$("div.AdminPanelContent ul.menu a:eq(0)").trigger('click');

});


var actions = [];
var currency = [];
var specifications = [];
var searchGroups = [];


var columnListItem = function (id, name, prefix, checked, isDisabled) {
	var self = this;
	this.id = ko.observable(id);
	this.name = ko.observable(name);
	this.prefix = ko.observable(prefix);
	this.checked = ko.observable(checked);
	this.columnName = ko.observable(self.prefix() + ":" + self.name());
	this.isDisabled = ko.observable(isDisabled);
};

var viewModel = function (actions, searchGroups, specifications, currency) {
	var self = this;
	this.actions = ko.observableArray(actions);
	this.searchGroups = ko.observableArray(searchGroups);
	this.specifications = ko.observableArray(specifications);
	this.currency = ko.observableArray(currency);

	this.checked = ko.computed(function () {
		var selectedList = self.searchGroups().concat(self.actions())
                .concat(self.specifications()).concat(self.currency());

		return ko.utils.arrayFilter(selectedList, function (item) {
			return item.checked();
		});
	});

	this.checkedSearchGroups = ko.computed(

        function () {
        	var selectedList = self.searchGroups();
        	return ko.utils.arrayFilter(selectedList, function (item) {
        		return item.checked() || item.isDisabled();
        	});
        });

	this.checkedActions = ko.computed(

        function () {
        	var selectedList = self.actions();
        	return ko.utils.arrayFilter(selectedList, function (item) {
        		return item.checked() || item.isDisabled();
        	});
        });

	this.checkedSpecifications = ko.computed(

        function () {
        	var selectedList = self.specifications();
        	return ko.utils.arrayFilter(selectedList, function (item) {
        		return item.checked() || item.isDisabled();
        	});
        });

	this.checkedCurrency = ko.computed(

        function () {
        	var selectedList = self.currency();
        	return ko.utils.arrayFilter(selectedList, function (item) {
        		return item.checked() || item.isDisabled();
        	});
        });

};



var vm;

$(function () {
	var url = VP.AjaxWebServiceUrl + "/GetProductUploadMetaDataInformation";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		timeout: 3000,
		url: url,
		data: "{'siteId':" + VP.SiteId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (data) {
			var response = data.d;

			for (var i = 0; i < response.length; i++) {

				var tempObj = response[i];
				if (tempObj.Prefix == "SG") {
					searchGroups.push(new columnListItem(
                        tempObj.Id,
                        tempObj.Name,
                        tempObj.Prefix,
                        false,
						false));

				} else if (tempObj.Prefix == "Action-Product") {

					actions.push(new columnListItem(
                        tempObj.Id,
                        tempObj.Name,
                        tempObj.Prefix,
                        false,
						false));

				} else if (tempObj.Prefix == "Price") {
					currency.push(new columnListItem(
                        tempObj.Id,
                        tempObj.Name,
                        tempObj.Prefix,
                        false,
						false));
				}
			}
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
			alert(errorThrown);
		}
	});


	vm = new viewModel(actions, searchGroups, specifications, currency);


	vm.prefixes = [{
		id: 1,
		name: "Specification Types",
		prefix: "Spec",
		checked: true
	}, {
		id: 2,
		name: "Search Groups",
		prefix: "SG",
		checked: true
	}, {
		id: 3,
		name: "Actions",
		prefix: "Action",
		checked: true
	}];

	ko.applyBindings(vm);

	function updateColumnList(prefix, name, id, forceIdCheck, checkedStatus, isDisabled) {
		var self = this;
		var isItemExists = false;
		var columnName = prefix + ":" + name;
		
		if (id > 0) {
			forceIdCheck = true;
		}

		var listItem = new columnListItem(id, name, prefix, checkedStatus, isDisabled);

		if (prefix == "SG") {

			var exisitingSGs = ko.utils.arrayFilter(vm.searchGroups(), function (item) {
				return (name == item.name() && !forceIdCheck)
				|| (item.name() == name && item.id() == id);
			});
			if (exisitingSGs.length > 0) {

				isItemExists = true;

				for (var i = 0; i < exisitingSGs.length; i++) {
					if (exisitingSGs[i].isDisabled() == false) {
						exisitingSGs[i].checked(checkedStatus);
						exisitingSGs[i].isDisabled(isDisabled);
					}
				}
			}

			if (!isItemExists) {
				vm.searchGroups.push(listItem);
			}

		} else if (prefix == "Action-Product") {

			var exisitingActions = ko.utils.arrayFilter(vm.actions(), function (item) {
				return (name == item.name() && !forceIdCheck)
				|| (item.name() == name && item.id() == id);
			});
			if (exisitingActions.length > 0) {

				isItemExists = true;

				if (exisitingActions[0].isDisabled() == false) {
					exisitingActions[0].checked(checkedStatus);
					exisitingActions[0].isDisabled(isDisabled);
				}
			}

			if (!isItemExists) {
				vm.actions.push(listItem);
			}
		} else if (prefix == "Spec") {

			var exisitingSpecs = ko.utils.arrayFilter(vm.specifications(), function (item) {
				return (name == item.name() && !forceIdCheck)
				|| (item.name() == name && item.id() == id);
			});
			if (exisitingSpecs.length > 0) {

				isItemExists = true;

				if (exisitingSpecs[0].isDisabled() == false) {
					exisitingSpecs[0].checked(checkedStatus);
					exisitingSpecs[0].isDisabled(isDisabled);
				}
			}

			if (!isItemExists) vm.specifications.push(listItem);
		} else if (prefix == "Price") {

			var exisitingCurrencies = ko.utils.arrayFilter(vm.currency(), function (item) {
				return (name == item.name() && !forceIdCheck)
				|| (item.name() == name && item.id() == id);
			});
			if (exisitingCurrencies.length > 0) {

				isItemExists = true;

				if (exisitingCurrencies[0].isDisabled() == false) {
					exisitingCurrencies[0].checked(checkedStatus);
					exisitingCurrencies[0].isDisabled(isDisabled);
				}
			}

			if (!isItemExists)
				vm.currency.push(listItem);
		}



		return isItemExists;
	}


	var excludeSearchGroups = false,
            excludeActions = false,
            excludeSpecTypes = false;

	$("#vwCategory input[type='checkbox']").change(

        function () {

        	var selectionFilter = $(this).val();
        	var includeSelection = $(this).is(":checked");

        	switch (selectionFilter) {

        		case "1":
        			excludeSpecTypes = !includeSelection;
        			break;
        		case "2":
        			excludeSearchGroups = !includeSelection;
        			break;
        		case "3":
        			excludeActions = !includeSelection;
        			break;
        		default:

        	}

        });

	$(".2_contentTableRow").live('click',

        function () {

        	var self = this;
        	$("input[id$='txtSpecificationType']").attr("data-specname",
            $(self).find(".cpp_nameTableColumn").text());
        });

	$('#btnAddSpecificationType').click(
        function () {
        	var self = $(this);
        	var prefix = $(self).parents("[data-prefix]").attr("data-prefix");
        	var specId = $("input[id$='txtSpecificationType']").val();
        	var specName = $("input[id$='txtSpecificationType']").attr("data-specname");
        	var isItemExists = updateColumnList(prefix, specName, specId, false, true, false);
        	if (isItemExists) {
        		var message = "Specification already exists";
        		$.notify({ message: message });
        	}
        });

	$('#btnAddCategory').click(

        function () {

        	var categoryId = $("input[id$='txtCategoryId']").val();
        	if (!categoryId || (excludeSearchGroups && excludeActions && excludeSpecTypes)) {
        		return;
        	}

        	var categoryIdOptions = "{ categoryId:" + categoryId + ", excludeSearchGroups:" + excludeSearchGroups + ", excludeActions:" + excludeActions + ", excludeSpecTypes:" + excludeSpecTypes + "}";
        	var url = VP.AjaxWebServiceUrl + "/GetProductUploadMetaDataInformationForCategory";

        	var response = null;
        	$.ajax({
        		type: "POST",
        		async: false,
        		cache: false,
        		timeout: 3000,
        		url: url,
        		data: categoryIdOptions,
        		contentType: "application/json; charset=utf-8",
        		dataType: "json",
        		success: function (data) {
        			response = data.d;
        			for (var i = 0; i < response.length; i++) {
        				updateColumnList(response[i].Prefix, response[i].Name, 0, false, true, false);
        			}
        		},
        		error: function (XMLHttpRequest, textStatus, errorThrown) {
        			var error = XMLHttpRequest;

        		}
        	});
        });

	vm.checkedSearchGroups.subscribe(

        function (items) {
        	var columns = [];

        	for (var i = 0; i < items.length; i++) {
        		columns.push(items[i].id() + "," + items[i].columnName());
        	}

        	$("[id$='hdfSearchGroups']").val(columns.join("|"));
        });

	vm.checkedActions.subscribe(

        function (items) {
        	var columns = [];

        	for (var i = 0; i < items.length; i++) {
        		columns.push(items[i].id() + "," + items[i].columnName());
        	}

        	$("[id$='hdfActions']").val(columns.join("|"));
        });

	vm.checkedSpecifications.subscribe(

        function (items) {
        	var columns = [];

        	for (var i = 0; i < items.length; i++) {
        		columns.push(items[i].id() + "," + items[i].columnName());
        	}
        	$("[id$='hdfSpecifications']").val(columns.join("|"));
        });

	vm.checkedCurrency.subscribe(

        function (items) {
        	var columns = [];

        	for (var i = 0; i < items.length; i++) {
        		columns.push(items[i].id() + "," + items[i].columnName());
        	}

        	$("[id$='hdfCurrency']").val(columns.join("|"));
        });

	(function rebindPostBackData() {

		var searchGroupsCommaSeperated = $("[id$='hdfSearchGroups']").val().split("|");
		if (searchGroupsCommaSeperated != "") {
			for (var i = 0; i < searchGroupsCommaSeperated.length; i++) {
				var item = searchGroupsCommaSeperated[i];
				var idNamePair = item.split(",");
				var isItemDisabled = idNamePair[2] == undefined ? false : idNamePair[2] == 'true';
				updateColumnList("SG", idNamePair[1].replace("SG:", ""), idNamePair[0], false, true, isItemDisabled);
			}
		}

		var actionsCommaSeperated = $("[id$='hdfActions']").val().split("|");
		if (actionsCommaSeperated != "") {
			for (var i = 0; i < actionsCommaSeperated.length; i++) {
				var item = actionsCommaSeperated[i];
				var idNamePair = item.split(",");
				var isItemDisabled = idNamePair[2] == undefined ? false : idNamePair[2] == 'true';
				updateColumnList("Action-Product", idNamePair[1].replace("Action-Product:", ""), idNamePair[0], false,
					true, isItemDisabled);
			}
		}

		var specsCommaSeperated = $("[id$='hdfSpecifications']").val().split("|");
		if (specsCommaSeperated != "") {
			for (var i = 0; i < specsCommaSeperated.length; i++) {
				var item = specsCommaSeperated[i];
				var idNamePair = item.split(",");
				var isItemDisabled = idNamePair[2] == undefined ? false : idNamePair[2] == 'true';
				updateColumnList("Spec", idNamePair[1].replace("Spec:", ""), idNamePair[0], false,
					true, isItemDisabled);
			}
		}

		var currencyCommaSeperated = $("[id$='hdfCurrency']").val().split("|");
		if (currencyCommaSeperated != "") {
			for (var i = 0; i < currencyCommaSeperated.length; i++) {

				var item = currencyCommaSeperated[i];
				var idNamePair = item.split(",");
				var isItemDisabled = idNamePair[2] == undefined ? false : idNamePair[2] == 'true';
				updateColumnList("Price", idNamePair[1].replace("Price:", ""), idNamePair[0], false, true, isItemDisabled);
			}
		}
	})();

	function clearColumnSelection() {
		for (var i = 0; i < vm.searchGroups().length; i++) {
			if (vm.searchGroups()[i].isDisabled() == false) {
				vm.searchGroups()[i].checked(false);
			}
		}
		for (var i = 0; i < actions.length; i++) {
			actions[i].checked(false);
		}
		for (var i = 0; i < specifications.length; i++) {
			specifications[i].checked(false);
		}
		for (var i = 0; i < currency.length; i++) {
			currency[i].checked(false);
		}
	}

	$("#btnClear").click(function () {
		clearColumnSelection();
	});

	$("#btnSelectSpecifications, #btnSelectSearchGroups, #btnSelectActions, #btnSelectCurrency").change(function () {
		var selectStatus = false;
		if (this.checked) {
			selectStatus = true;
		}

		$("[id$='" + $(this).attr("data-list") + "'] option:not([disabled]!='true')").attr('selected', selectStatus);
		if ($("[id$='" + $(this).attr("data-list") + "'] option:not([disabled]!='true')").length > 0)
			$("[id$='" + $(this).attr("data-list") + "']").focus();

	});

	$("#btnRemoveItem").click(function () {

		var selectedItems = $("select > option:selected");


		if (selectedItems.length == 0) {
			var message = "Please select an item to remove";
			$.notify({ message: message });
		}

		selectedItems.each(function () {
			var selectedItem = $(this);
			var selectedText = selectedItem.text();
			updateColumnList(selectedText.substring(0, selectedText.indexOf(":")),
            selectedText.substring(selectedText.indexOf(":") + 1), selectedItem.attr('value'),
            true, false, false);
		});


	});

});