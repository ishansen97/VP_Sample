RegisterNamespace("VP.BulkEmail.ConditionEditor");

VP.BulkEmail.ConditionEditor = function(fieldElement, segmentCondition, field, segmentTree) {
	this._fieldElement = fieldElement;
	this._field = field;
	this._segmentCondition = segmentCondition;
	this._segmentTree = segmentTree;
	this._segmentFieldId = fieldElement.data("segmentFieldId");
	this._conditionElement = [];
	this._serviceUrl = VP.ApplicationRoot + "Services/BulkEmailWebService.asmx";
};

VP.BulkEmail.ConditionEditor.prototype.LoadCondition = function() {
	if (!this._segmentCondition) {
		this._segmentCondition = this._segmentTree.AddSegmentCondition(this._segmentFieldId);
	}
};

VP.BulkEmail.ConditionEditor.prototype.DeleteCondition = function() {
	this._conditionElement.hide('slow', function() {
		$(this).remove();
	});
	this._segmentTree.DeleteSegmentCondition(this._segmentFieldId, this._segmentCondition.Id);
};

VP.BulkEmail.ConditionEditor.prototype.ValidateAndPopulate = function() {
	var isValid = true;
	$("div.error", this._conditionElement).remove();
	var condition = this._segmentTree.GetSegmentCondition(this._segmentFieldId, this._segmentCondition.Id);
	condition.OperatorId = parseInt($("select.ddlOperations", this._conditionElement).val(), 10);
	condition.Value = $(".segmentCondition", this._conditionElement).val();
	if (!condition.Value) {
		this._conditionElement.append("<div class='error'>Please enter value for condition.</div>");
		isValid = false;
	}

	return isValid;
};

VP.BulkEmail.ConditionEditor.prototype.InitializeDeleteButton = function() {
	var that = this;
	$("span.deleteSegmentCondition", this._conditionElement).click(function() {
		that.DeleteCondition();
	});
};

VP.BulkEmail.ConditionEditor.prototype.RemoveOperations = function(operationDropdown) {
$("option[value = '3'], option[value = '4'], option[value = '5'], option[value = '6'], option[value = '7'], option[value = '8']",
			operationDropdown).remove();
};
