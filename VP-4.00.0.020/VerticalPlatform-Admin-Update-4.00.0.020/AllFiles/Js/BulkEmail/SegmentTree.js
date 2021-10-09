RegisterNamespace("VP.BulkEmail.SegmentTree");

VP.BulkEmail.SegmentTree = function(segmentId) {
	this._segment = [];
	this._currentSegmentFieldId = 0;
	this._currentSegmentConditionId = 0;
	this._serviceUrl = VP.ApplicationRoot + "Services/BulkEmailWebService.asmx";

	if (segmentId > 0) {
		this.LoadSegment(segmentId);
	}
	else {
		this._segment = new VerticalPlatform.Admin.Web.UI.BulkEmail.Segment();
		this._segment.Id = segmentId;
		this._segment.SegmentFields = [];
	}
};

VP.BulkEmail.SegmentTree.prototype.LoadSegment = function(segmentId) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: this._serviceUrl + "/GetSegment",
		data: "{'segmentId' : " + segmentId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			that._segment = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location = "../../Error.aspx";
		}
	});
};

VP.BulkEmail.SegmentTree.prototype.AddSegmentField = function(segmentFieldTypeId, fieldId) {
	var segmentField = new VerticalPlatform.Admin.Web.UI.BulkEmail.SegmentField();

	segmentField.Id = --this._currentSegmentFieldId;
	if (fieldId) {
		segmentField.FieldId = parseInt(fieldId, 10);
	}
	segmentField.TypeId = parseInt(segmentFieldTypeId, 10);
	segmentField.Conditions = [];
	this._segment.SegmentFields.push(segmentField);

	return segmentField;
};

VP.BulkEmail.SegmentTree.prototype.AddSegmentCondition = function(segmentFieldId) {
	var segmentCondition = new VerticalPlatform.Admin.Web.UI.BulkEmail.SegmentCondition();
	segmentCondition.Id = --this._currentSegmentConditionId;

	var index = 0;
	for (index in this._segment.SegmentFields) {
		if (this._segment.SegmentFields[index].Id == parseInt(segmentFieldId, 10)) {
			this._segment.SegmentFields[index].Conditions.push(segmentCondition);
			break;
		}
	}

	return segmentCondition;
};

VP.BulkEmail.SegmentTree.prototype.DeleteSegmentField = function(segmentFieldId) {
	var fieldIndex = 0;
	for (fieldIndex in this._segment.SegmentFields) {
		if (this._segment.SegmentFields[fieldIndex].Id == segmentFieldId) {
			this._segment.SegmentFields.splice(fieldIndex, 1);
			break;
		}
	}
};

VP.BulkEmail.SegmentTree.prototype.DeleteSegmentCondition = function(segmentFieldId, segmentConditionId) {
	var fieldIndex = 0;
	for (fieldIndex in this._segment.SegmentFields) {
		if (this._segment.SegmentFields[fieldIndex].Id == segmentFieldId) {
			var conditionIndex = 0;
			for (conditionIndex in this._segment.SegmentFields[fieldIndex].Conditions) {
				if (this._segment.SegmentFields[fieldIndex].Conditions[conditionIndex].Id == segmentConditionId) {
					this._segment.SegmentFields[fieldIndex].Conditions.splice(conditionIndex, 1);
					break;
				}
			}

			break;
		}
	}
};

VP.BulkEmail.SegmentTree.prototype.GetSegmentCondition = function(segmentFieldId, segmentConditionId) {
	var fieldIndex = 0;
	for (fieldIndex in this._segment.SegmentFields) {
		if (this._segment.SegmentFields[fieldIndex].Id == segmentFieldId) {
			var conditionIndex = 0;
			for (conditionIndex in this._segment.SegmentFields[fieldIndex].Conditions) {
				if (this._segment.SegmentFields[fieldIndex].Conditions[conditionIndex].Id == segmentConditionId) {
					return this._segment.SegmentFields[fieldIndex].Conditions[conditionIndex];
				}
			}

			break;
		}
	}
};

VP.BulkEmail.SegmentTree.prototype.FinalizeTree = function() {
	var fieldIndex = 0;
	var toDelete = [];
	for (fieldIndex in this._segment.SegmentFields) {
		if (this._segment.SegmentFields[fieldIndex].Conditions.length == 0) {
			toDelete.push(this._segment.SegmentFields[fieldIndex].Id);
		}
	}
	
	var deleteIndex = 0;
	for (deleteIndex in toDelete) {
		this.DeleteSegmentField(toDelete[deleteIndex]);
	}
};
