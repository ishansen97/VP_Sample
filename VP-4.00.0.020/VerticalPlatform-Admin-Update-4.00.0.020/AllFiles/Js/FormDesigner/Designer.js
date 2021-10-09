// ---------------  DesignTimeElement ------------------------- //

VP.Forms.Designer.DesignTimeElement = function () {
	this._children = new Array();
	this._editMenu = null;
	this._parent = null;
	this._controlId = null;
	this._element = null;
	this._edit = false;
	this._cssClass = "";
};

VP.Forms.Designer.DesignTimeElement.prototype.Create = function(parent, element, controlId) {
	this._parent = parent;
	this._controlId = controlId;
	var html = "<div id=\"" + controlId + "_designer\" class=\"controlDesigner\">";
	html += "<span class=\"controlUI\">" + this.CreateUI() + "</span><span class=\"editMenu\">" + this.CreateEditMenu() + "</span></div>";
	$(element).append(html);
	this._element = $("#" + controlId + "_designer");
	var that = this;
	$("#" + this._controlId + "_delete").click(function() {
		if (confirm("Are you sure you want to delete this control?")) {
			that._parent.DeleteChild(that._controlId);
		}
	});
	$("#" + this._controlId + "_edit").click(function() {
		that._edit = true;
		that.ShowPropertyDialog();
	});

	$("#" + this._controlId + "_up").click(function() {
		that._parent.MoveUp(that._controlId);
	});

	$("#" + this._controlId + "_down").click(function() {
		that._parent.MoveDown(that._controlId);
	});

	$("#" + this._controlId + "_outerContainer").click(function() {
		that.MoveToOuterContainer();
	});

	$("#" + this._controlId + "_innerContainer").click(function() {
		that.MoveToInnerContainer();
	});

	if (parent != null) {
		var css = parent.CssClass;
		if (css == "horizontal") {
			$(this._element).addClass("horizontal");
		}
	}
};

VP.Forms.Designer.DesignTimeElement.prototype.Load = function (data, parent, element) {
	this.LoadProperties(data);
	this.Create(data.ControlId);
};


VP.Forms.Designer.DesignTimeElement.prototype.LoadProperties = function (data) {
};


VP.Forms.Designer.DesignTimeElement.prototype.GetData = function () {
};


VP.Forms.Designer.DesignTimeElement.prototype.CreateEditMenu = function() {
	var deleteId = this._controlId + "_delete";
	var editId = this._controlId + "_edit";
	var upId = this._controlId + "_up";
	var downId = this._controlId + "_down";
	var outerContainerId = this._controlId + "_outerContainer";
	var innerContainerId = this._controlId + "_innerContainer";
	var html = "<a class=\"deleteIcon\" id=\"" + deleteId + "\" title=\"Delete\" >&nbsp;</a>" +
		"<a class=\"editIcon\" id=\"" + editId + "\" title=\"Edit\">&nbsp;</a>" +
		"<a class=\"upIcon\" id=\"" + upId + "\" title=\"Move Up\">&nbsp;</a>" +
		"<a class=\"downIcon\" id=\"" + downId + "\" title=\"Move Down\">&nbsp;</a>" +
		"<a class=\"outerContainer\" id=\"" + outerContainerId + "\" title=\"Move to outer container\">&nbsp;</a>" +
		"<a class=\"innerContainer\" id=\"" + innerContainerId + "\" title=\"Move to inner container\">&nbsp;</a>";
	return html;
};

VP.Forms.Designer.DesignTimeElement.prototype.GetControlId = function () {
	return this._controlId;
};

VP.Forms.Designer.DesignTimeElement.prototype.CreateUI = function() {
	var html = "<h2 class=\"formTitle\">" + this.Title + "</h2><div class=\"containerControl\"></div>";
	return html;
};

VP.Forms.Designer.DesignTimeElement.prototype.Destroy = function () {
	$(this._element).remove();
};

VP.Forms.Designer.DesignTimeElement.prototype.ShowPropertyDialog = function () {
	var dialog = $("#propertyDialog");
	this.PreparePropertyDialog();
	dialog.jqmShow();
};

VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog = function () {
	var that = this;

	$("#propertyCancel").unbind('click');
	$("#propertyCancel").click(function () {
		that.CancelProperties();
	});

	$("#propertySave").unbind('click');
	$("#propertySave").click(function () {
		that.UpdateProperties();
	});
};

VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties = function () {
	$("#propertyDialog").jqmHide();
};

VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties = function () {
	$("#propertyDialog").jqmHide();
};

VP.Forms.Designer.DesignTimeElement.prototype.GetFieldOptionsHtml = function () {
	var fieldId = this.FieldId;
	var html;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webServiceUrl + "/GetFieldOptionsHtml",
		data: "{'fieldId' : '" + fieldId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			html = msg.d;
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}

	});

	return html;
};

VP.Forms.Designer.DesignTimeElement.prototype.GetFieldsHtml = function () {
	var alreadyAddedFields = VP.Forms.Designer.CanvasInstance._fields[this.FieldType];
	var fieldType = this.FieldType;
	var html;
	if (fieldContentTypeId == 37) {
		var data = "{'siteId' : '" + siteId + "', 'fieldContentTypeId' : '" + fieldContentTypeId + "','fieldTypeId' : '" + fieldType + "'}";
		html = this.GetAjaxResults("/Services/FormService.asmx/GetFieldsHtmlByFieldContentType", data);
	}
	else {
		var data = "{'siteId' : '" + siteId + "','fieldType' : '" + fieldType + "','contentTypeId' : '"
		    + contentTypeId + "','contentId' : '" + contentId + "','leadTypeId' : '" + leadTypeId
		    + "','fieldContentTypeId' : '" + fieldContentTypeId + "','alreadyAddedFields' : '" + alreadyAddedFields + "','fieldId' : '"
			+ this.FieldId + "'}";

		html = this.GetAjaxResults("/Services/FormService.asmx/GetFieldsHtml", data);
	}

	return html;
};

VP.Forms.Designer.DesignTimeElement.prototype.GetAjaxResults = function (url, data) {
	var result;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: url,
		data: data,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			result = msg.d;
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	return result;
};

VP.Forms.Designer.DesignTimeElement.prototype.FieldChange = function () {
	var selectedFieldId = $("#custom #ddlFields").val();
	if (selectedFieldId != "-1") {
		if (this.IsFieldExist(selectedFieldId)) {
			alert('This field already added to the form');
			$("#custom #ddlFields").val(-1);
		}
	}
};

VP.Forms.Designer.DesignTimeElement.prototype.IsFieldExist = function (selectedFieldId) {
	var isExist = false;
	var addedFields = VP.Forms.Designer.CanvasInstance._fields[this.FieldType];
	if (addedFields != null) {
		if (addedFields == selectedFieldId) {
			isExist = true;
		}
		else {
			if (typeof (addedFields) != "number") {
				var addedFieldsArray = addedFields.split(',');
				for (var i = 0; i < addedFieldsArray.length; i++) {
					if (selectedFieldId == addedFieldsArray[i]) {
						isExist = true;
						break;
					}
				}
			}
		}
	}

	return isExist;
};

VP.Forms.Designer.DesignTimeElement.prototype.AddField = function (previousFieldId) {
	if (this._edit) {
		if (this.FieldId != previousFieldId) {
			var addedFields = VP.Forms.Designer.CanvasInstance._fields[this.FieldType];
			if (addedFields != null) {
				var newArray = null;
				if (typeof (addedFields) != "number") {
					var addedFieldsArray = addedFields.split(',');
					for (var i = 0; i < addedFieldsArray.length; i++) {
						if (previousFieldId != addedFieldsArray[i]) {
							if (newArray != null) {
								newArray += "," + addedFieldsArray[i];
							}
							else {
								newArray = addedFieldsArray[i];
							}
						}
					}
				}
				else {
					newArray = addedFields;
				}

				if (newArray == null) {
					newArray = this.FieldId;
				}
				else {
					newArray += "," + this.FieldId;
				}
				VP.Forms.Designer.CanvasInstance._fields[this.FieldType] = newArray;
			}
		}
	}
	else {
		var fieldIds = VP.Forms.Designer.CanvasInstance._fields[this.FieldType];
		if (fieldIds != null) {
			fieldIds += "," + this.FieldId;
		}
		else {
			fieldIds = this.FieldId;
		}
		VP.Forms.Designer.CanvasInstance._fields[this.FieldType] = fieldIds;
	}
};

VP.Forms.Designer.DesignTimeElement.prototype.MoveToOuterContainer = function () {
	if (this._parent != null) {
		if (this._parent.FieldType != 13) {
			var parentId = this._parent._controlId;
			if (this._parent._parent != null) {
				var grandParent = this._parent._parent;

				var arrayIndexId = "";
				var that = this;

				for (var i in grandParent._children) {
					if (grandParent._children[i]._controlId == parentId) {
						$("#" + grandParent._children[i]._controlId + "_designer").after
								($("#" + this._controlId + "_designer"));

						for (var j in grandParent._children[i]._children) {
							if (grandParent._children[i]._children[j]._controlId == this._controlId) {
								arrayIndexId = j;
								delete grandParent._children[i]._children[j];
								break;
							}
						}
					}
				}

				that._parent = grandParent;

				var newChildren = new Array();
				for (var i in grandParent._children) {
					newChildren[i] = grandParent._children[i];

					if (grandParent._children[i]._controlId == parentId) {
						newChildren[arrayIndexId] = that;
					}
				}

				grandParent._children = newChildren;

			}
		}
	}
};

VP.Forms.Designer.DesignTimeElement.prototype.MoveToInnerContainer = function () {
	if (this._parent != null) {
		var parent = this._parent;
		var isFound = false;
		var arrayIndex = "";
		for (var i in parent._children) {
			if (isFound) {
				if (parent._children[i].FieldType != null) {
					if (parent._children[i].FieldType == 10) {
						var that = this;
						$("#" + parent._children[i]._controlId + "_designer .controlContainer").eq(0).append
							($("#" + this._controlId + "_designer"));
						that._parent = parent._children[i];
						delete parent._children[arrayIndex];

						parent._children[i]._children[arrayIndex] = that;
					}
				}
				break;
			}

			if (parent._children[i]._controlId == this._controlId) {
				isFound = true;
				arrayIndex = i;
			}
		}
	}
};
