RegisterNamespace("VP.BulkEmail.MultiSelectConditionEditor");

$.fn.sortSelectBox = function () {
	var myOptions = $(' option', this);
	myOptions.sort(function (a, b) {
		if (a.text.toUpperCase() > b.text.toUpperCase())
			return 1;
		else if (a.text.toUpperCase() < b.text.toUpperCase())
			return -1;
		else
			return 0;
	})

	$(this).empty().append(myOptions);
}

VP.BulkEmail.MultiSelectConditionEditor = function (fieldElement, segmentCondition, field, segmentTree) {
	VP.BulkEmail.ConditionEditor.apply(this, arguments);
	this.EqualList = [];
	this.NotEqualList = [];
};

VP.BulkEmail.MultiSelectConditionEditor.prototype = Object.create(VP.BulkEmail.ConditionEditor.prototype);

VP.BulkEmail.MultiSelectConditionEditor.prototype.InitializeEvents = function (multiSelectUI) {
	var equalList, notEqualList, allOptionList, that;
	equalList = $("select.equal_option_list", multiSelectUI);
	notEqualList = $("select.not_equal_option_list", multiSelectUI);
	allOptionList = $("select.all_option_list", multiSelectUI);
	that = this;

	$("a.add_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(allOptionList).find("option:selected").remove().appendTo(equalList);
		that.UpdateConditionList(equalList, that.EqualList);
		$(equalList).sortSelectBox();
	});

	$("a.add_all_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(allOptionList).find("*").remove().appendTo(equalList);
		that.UpdateConditionList(equalList, that.EqualList);
		$(equalList).sortSelectBox();
	});

	$("a.remove_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(equalList).find("option:selected").remove().appendTo(allOptionList);
		that.UpdateConditionList(equalList, that.EqualList);
		$(allOptionList).sortSelectBox();
	});

	$("a.remove_all_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(equalList).find("*").remove().appendTo(allOptionList);
		that.EqualList.splice(0, that.EqualList.length);
		$(allOptionList).sortSelectBox();
	});

	$("a.add_not_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(allOptionList).find("option:selected").remove().appendTo(notEqualList);
		that.UpdateConditionList(notEqualList, that.NotEqualList);
		$(notEqualList).sortSelectBox();
	});

	$("a.add_all_not_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(allOptionList).find("*").remove().appendTo(notEqualList);
		that.UpdateConditionList(notEqualList, that.NotEqualList);
		$(notEqualList).sortSelectBox();
	});

	$("a.remove_not_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(notEqualList).find("option:selected").remove().appendTo(allOptionList);
		that.UpdateConditionList(notEqualList, that.NotEqualList);
		$(allOptionList).sortSelectBox();
	});

	$("a.remove_all_not_equal_option", multiSelectUI).click(function (e) {
		e.preventDefault();
		$(notEqualList).find("*").remove().appendTo(allOptionList);
		that.NotEqualList.splice(0, that.NotEqualList.length);
		$(allOptionList).sortSelectBox();
	});

	$(equalList).sortSelectBox();
	$(notEqualList).sortSelectBox();
};

VP.BulkEmail.MultiSelectConditionEditor.prototype.LoadCondition = function () {
	var orUI, orRuleSection, newOrRule, fieldOptionIndex, optionList;
	this.LoadConditionList();
	orUI = $("div.divSegmentMultiSelectTemplate", "#divRuleTemplates").clone(false);
	$("input.addSegmentCondition", this._fieldElement).remove();
	orRuleSection = $("ul.ulSegmentConditions", this._fieldElement);
	newOrRule = $("<li></li>");
	newOrRule.data("conditionEditor", this);
	$(orRuleSection).append(newOrRule);
	

	if (this._field.Options && this._field.Options.length > 0) {
		for (fieldOptionIndex in this._field.Options) {
			optionList = "select.all_option_list";
			if ($.inArray(this._field.Options[fieldOptionIndex].Id, this.EqualList) > -1) {
				optionList = "select.equal_option_list";
			} else if ($.inArray(this._field.Options[fieldOptionIndex].Id, this.NotEqualList) > -1) {
				optionList = "select.not_equal_option_list";
			}

			$(optionList, orUI).append("<option value='" + this._field.Options[fieldOptionIndex].Id +
					"'>" + this._field.Options[fieldOptionIndex].Value + "</option>");
		}
	}
	
	this.InitializeEvents(orUI);
	this._conditionElement = newOrRule;
	$(newOrRule).append(orUI);
	this.InitializeDeleteButton();
};

VP.BulkEmail.MultiSelectConditionEditor.prototype.LoadConditionList = function () {
	var conditionIndex = 0;
	for (conditionIndex in this._segmentCondition) {
		if (this._segmentCondition[conditionIndex].OperatorId == 1) {
			this.EqualList.push(parseInt(this._segmentCondition[conditionIndex].Value));
		} else {
			this.NotEqualList.push(parseInt(this._segmentCondition[conditionIndex].Value));
		}
	}
};

VP.BulkEmail.MultiSelectConditionEditor.prototype.UpdateConditionList = function (inputControl, selectedList) {
	selectedList.splice(0, selectedList.length);
	$(inputControl).find("*").each(function (i, domElement) {
		selectedList.push(parseInt(domElement.value));
	});
};

VP.BulkEmail.MultiSelectConditionEditor.prototype.ValidateAndPopulate = function () {
	var isValid, conditionIndex, condition, equalInArray, notEqualInArray, deletingList, equalList, notEqualList;
	isValid = true;
	deletingList = [];
	equalList = this.EqualList.slice();
	notEqualList = this.NotEqualList.slice();
	$("div.error", this._conditionElement).remove();

	if (equalList.length == 0 && notEqualList.length == 0) {
		this._conditionElement.append("<div class='error'>Please select and insert at least one option from the option list.</div>");
		isValid = false;
	} else {
		for (conditionIndex in this._segmentCondition) {
			condition = this._segmentTree.GetSegmentCondition(this._segmentFieldId, this._segmentCondition[conditionIndex].Id);
			if (condition != undefined) {
				equalInArray = $.inArray(parseInt(this._segmentCondition[conditionIndex].Value), equalList);
				notEqualInArray = $.inArray(parseInt(this._segmentCondition[conditionIndex].Value), notEqualList);

				if (equalInArray > -1) {
					condition.OperatorId = 1;
					equalList.splice(equalInArray, 1);
				} else if (notEqualInArray > -1) {
					condition.OperatorId = 2;
					notEqualList.splice(notEqualInArray, 1);
				} else {
					deletingList.push(this._segmentCondition[conditionIndex].Id);
				}
			}
		}

		for (conditionIndex in deletingList) {
			this._segmentTree.DeleteSegmentCondition(this._segmentFieldId, deletingList[conditionIndex]);
		}

		for (conditionIndex in equalList) {
			condition = this._segmentTree.AddSegmentCondition(this._segmentFieldId);
			condition.Value = equalList[conditionIndex];
			condition.OperatorId = 1;
		}

		for (conditionIndex in notEqualList) {
			condition = this._segmentTree.AddSegmentCondition(this._segmentFieldId);
			condition.Value = notEqualList[conditionIndex];
			condition.OperatorId = 2;
		}
	}
	return isValid;
};
