RegisterNamespace("VP.BulkEmail.FieldConditionEditor");

VP.BulkEmail.FieldConditionEditor = function(fieldElement, segmentCondition, field, segmentTree) {
	VP.BulkEmail.ConditionEditor.apply(this, arguments);
	this.CheckBoxField = 15;
	this.TrueValue = 'True';
	this.FalseValue = 'False';
};

VP.BulkEmail.FieldConditionEditor.prototype = Object.create(VP.BulkEmail.ConditionEditor.prototype);

VP.BulkEmail.FieldConditionEditor.prototype.LoadCondition = function() {
	VP.BulkEmail.ConditionEditor.prototype.LoadCondition.apply(this, arguments);

	var orRuleSection = $("ul.ulSegmentConditions", this._fieldElement);
	var newOrRule = $("<li></li>");
	newOrRule.data("conditionEditor", this);

	$(orRuleSection).append(newOrRule);
	var orUI = $("div.divSegmentConditionTemplate", "#divRuleTemplates").clone();

	if (this._field.TypeId == this.CheckBoxField) {
		$("span.valueSection", orUI).replaceWith("<select class='segmentCondition'></select>");
		if (this.TrueValue == this._segmentCondition.Value) {
			$("select.segmentCondition", orUI).append("<option value='" + this.TrueValue  +
					"' selected='selected'>" + this.TrueValue + "</option>");
			$("select.segmentCondition", orUI).append("<option value='" + this.FalseValue +
					"'>" + this.FalseValue + "</option>");
		}
		else {
			$("select.segmentCondition", orUI).append("<option value='" + this.TrueValue +
					"'>" + this.TrueValue + "</option>");
			$("select.segmentCondition", orUI).append("<option value='" + this.FalseValue +
					"' selected='selected'>" + this.FalseValue + "</option>");
		}
	}
	else if (this._field.Options && this._field.Options.length > 0) {
		$("span.valueSection", orUI).replaceWith("<select class='segmentCondition'></select>");
		this.RemoveOperations($("select.ddlOperations", orUI));

		var fieldOptionIndex = 0;
		for (fieldOptionIndex in this._field.Options) {
			if (this._field.Options[fieldOptionIndex].Id == this._segmentCondition.Value) {
				$("select.segmentCondition", orUI).append("<option value='" + this._field.Options[fieldOptionIndex].Id +
					"' selected='selected'>" + this._field.Options[fieldOptionIndex].Value + "</option>");
			}
			else {
				$("select.segmentCondition", orUI).append("<option value='" + this._field.Options[fieldOptionIndex].Id +
					"'>" + this._field.Options[fieldOptionIndex].Value + "</option>");
			}
		}
	}
	else {
		$("span.valueSection", orUI).replaceWith("<input type='text' class='segmentCondition'/>");
		if (this._segmentCondition.Value) {
			$('input.segmentCondition', orUI).val(this._segmentCondition.Value);
		}
	}

	if (this._segmentCondition.OperatorId) {
		$("select.ddlOperations", orUI).val(this._segmentCondition.OperatorId);
	}

	this._conditionElement = newOrRule;
	$(newOrRule).append(orUI);
	this.InitializeDeleteButton();
};
