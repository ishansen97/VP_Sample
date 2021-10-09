RegisterNamespace("VP.BulkEmail.SegmentRuleManager");

VP.BulkEmail.SegmentRuleManager = function (segmentId, element) {
	this.Region = 1;
	this.Static = 2;
	this.Custom = 3;

	this._element = element;
	this._pageSize = 50;
	this._segmentId = segmentId;
	this._segmentTree = new VP.BulkEmail.SegmentTree(segmentId);
	var that = this;
	this._serviceUrl = VP.ApplicationRoot + "Services/BulkEmailWebService.asmx";

	this.PopulateSegmentFields();

	$("#btnAddSegmentField", this._element).click(function () {
		var segmentFieldTypeId;
		if ($("#ulAdd input[type='radio'][checked]", that._element).val() == 'rbtnRegion') {
			segmentFieldTypeId = that.Region;
		}
		else {
			segmentFieldTypeId = $("select.ddlFieldType", that._element).val();
		}
		var fieldId = $("#ddlField").val();

		if (((segmentFieldTypeId == that.Static || segmentFieldTypeId == that.Custom) && fieldId > 0) ||
				(segmentFieldTypeId) == that.Region) {
			that.AddSegmentField(segmentFieldTypeId);
		}
		else {
			if (segmentFieldTypeId < 0) {
				$.notify({ message: "Please select a field type and a field." });
			}
			else if (!fieldId) {
				$.notify({ message: "Please select a field." });
			}
		}
	});

	$("input.addSegmentCondition", this._element).live("click", function () {
		that.AddSegmentCondition($(this).parents("div.divSegmentFieldTemplate"), null);
	});

	$("span.deleteSegmentField", this._element).live("click", function () {
		that.DeleteSegmentField($(this).parents("div.divSegmentFieldTemplate"));
	});

	$("span.collapseSegmentField", this._element).live("click", function () {
		$(this).parent().find("input.common_text_button").toggle("fast");
		$(this).next().toggle("slow");
		$(this).toggleClass("expandSegmentField");
	});

	$("select.ddlFieldType", this._element).change(function () {
		$("#ddlField").empty().append('<option value="">-Select Field-</option>');
		var fieldSegmentTypeId = $(this).val();
		if (fieldSegmentTypeId && (fieldSegmentTypeId == that.Static || fieldSegmentTypeId == that.Custom)) {
			that.LoadFields(fieldSegmentTypeId);
		}
	});

	$("#ulAdd input[type='radio']", this._element).change(function () {
		switch ($(this).val()) {
			case "rbtnRegion":
				$("select.ddlFieldType", that._element).val("-1").attr("disabled", "disabled");
				$("#ddlField", that._element).empty().append('<option value="">-Select Field-</option>').attr("disabled", "disabled");
				break;
			case "rbtnField":
				$("select.ddlFieldType", that._element).removeAttr("disabled");
				$("#ddlField", that._element).removeAttr("disabled");
				break;
		}
	});

	$("input.btnSaveSegment", this._element).click(function () {
		if (that.ValidateAndPopulateFields()) {
			that.SaveSegment();
		}
	});

	$("#btnPreview", this._element).click(function () {
		if (that.ValidateAndPopulateFields()) {
			that.ShowPreview(1, '');
		}
	});

	$("#divSegmentPreview").jqm({
		modal: true
	});

	$("#btnCloseSegmentPreview", "#divSegmentPreview").click(function () {
		$("#divSegmentPreview").jqmHide();
	});

	$("#btnApplySearch", "#divSegmentPreview").click(function () {
		var text = $("#txtEmailSearch", "#divSegmentPreview").val();
		if (text) {
			that.ShowPreview(1, text);
		}
		else {
			$.notify({ message: "Please enter search text." });
		}
	});

	$("#btnResetSearch", "#divSegmentPreview").click(function () {
		$("#txtEmailSearch", "#divSegmentPreview").val("");
		that.ShowPreview(1, '');
	});
};

VP.BulkEmail.SegmentRuleManager.prototype.PopulateSegmentFields = function () {
	var segment = this._segmentTree._segment;
	var fieldIndex = 0;
	for (fieldIndex in segment.SegmentFields) {
		var field;
		if (segment.SegmentFields[fieldIndex].FieldId) {
			field = this.GetField(segment.SegmentFields[fieldIndex].FieldId);
		}
		else {
			field = null;
		}

		var andUI = this.PopulateSegmentField(segment.SegmentFields[fieldIndex]);
		andUI.data("field", field);
		if (field) {
			$("div.segmentFieldName", andUI).text(field.Name + "(" +
					this.GetSegmentFieldType(segment.SegmentFields[fieldIndex].TypeId) + " Field)");
		}
		else {
			$("div.segmentFieldName", andUI).text("(" +
					this.GetSegmentFieldType(segment.SegmentFields[fieldIndex].TypeId) + ")");
		}

		var conditionIndex = 0;
		var fieldTypeId = -1;
		if (field) {
			fieldTypeId = field.TypeId;
		}

		if (segment.SegmentFields[fieldIndex].TypeId == this.Custom && (fieldTypeId == 1 || fieldTypeId == 3 || fieldTypeId == 6)) {
			this.AddSegmentCondition(andUI, segment.SegmentFields[fieldIndex].Conditions);
		}
		else {
			for (conditionIndex in segment.SegmentFields[fieldIndex].Conditions) {
				this.AddSegmentCondition(andUI, segment.SegmentFields[fieldIndex].Conditions[conditionIndex]);
			}
		}
	}
};

VP.BulkEmail.SegmentRuleManager.prototype.PopulateSegmentField = function(segmentField) {
	var canvas = $("#divRuleCanves", this._element);
	var andUI = $(".divSegmentFieldTemplate", "#divRuleTemplates").clone();
	andUI.data("segmentFieldId", segmentField.Id);
	andUI.data("segmentFieldTypeId", segmentField.TypeId);
	canvas.append(andUI);
	return andUI;
};

VP.BulkEmail.SegmentRuleManager.prototype.AddSegmentField = function(segmentFieldTypeId) {
	var fieldData = $("option[selected]", "#ddlField").data('field');

	var segmentField;
	if (fieldData) {
		segmentField = this._segmentTree.AddSegmentField(segmentFieldTypeId, fieldData.Id);
	}
	else {
		segmentField = this._segmentTree.AddSegmentField(segmentFieldTypeId, null);
	}

	var canvas = $("#divRuleCanves", this._element);
	var andUI = $("div.divSegmentFieldTemplate", "#divRuleTemplates").clone();
	andUI.data("segmentFieldId", segmentField.Id);
	andUI.data("segmentFieldTypeId", segmentField.TypeId);
	andUI.data("field", fieldData);
	if (fieldData) {
		$("div.segmentFieldName", andUI).text(fieldData.Name + "(" + this.GetSegmentFieldType(segmentField.TypeId) + " Field)");
	}
	else {
		$("div.segmentFieldName", andUI).text("(" + this.GetSegmentFieldType(segmentField.TypeId) + ")");
	}
	this.AddSegmentCondition(andUI, null);
	canvas.append(andUI);
};

VP.BulkEmail.SegmentRuleManager.prototype.AddSegmentCondition = function (andElement, segmentCondition) {
	var fieldData = andElement.data("field");
	var fieldTypeId = -1;
	if (fieldData) {
		fieldTypeId = fieldData.TypeId;
	}

	var editor;
	var segmentFieldTypeId = andElement.data("segmentFieldTypeId");
	segmentFieldTypeId = parseInt(segmentFieldTypeId, 10);
	switch (segmentFieldTypeId) {
		case this.Region:
			editor = new VP.BulkEmail.RegionConditionEditor(andElement, segmentCondition, fieldData, this._segmentTree);
			break;
		case this.Static:
			editor = new VP.BulkEmail.FieldConditionEditor(andElement, segmentCondition, fieldData, this._segmentTree);
			break;
		case this.Custom:
			if (fieldTypeId == 1 || fieldTypeId == 3 || fieldTypeId == 6) {
				editor = new VP.BulkEmail.MultiSelectConditionEditor(andElement, segmentCondition, fieldData, this._segmentTree);
			}
			else {
				var condition = segmentCondition;
				if (segmentCondition != null && segmentCondition.length > 0) {
					condition = segmentCondition[0];
				}

				editor = new VP.BulkEmail.FieldConditionEditor(andElement, condition, fieldData, this._segmentTree);
			}
			break;
	}

	editor.LoadCondition();

};

VP.BulkEmail.SegmentRuleManager.prototype.DeleteSegmentField = function(segmentFieldElement) {
	var segmentFieldId = segmentFieldElement.data("segmentFieldId");
	this._segmentTree.DeleteSegmentField(segmentFieldId);
	segmentFieldElement.hide('slow', function() {
		$(this).remove();
	});
};

VP.BulkEmail.SegmentRuleManager.prototype.LoadFields = function(segmentFieldTypeId) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: this._serviceUrl + "/GetFields",
		data: "{'segmentFieldTypeId' : " + segmentFieldTypeId + ", 'siteId' : " + VP.SiteId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			that.RenderFieldDropdown(msg.d);
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location = "../../Error.aspx";
		}
	});
};

VP.BulkEmail.SegmentRuleManager.prototype.RenderFieldDropdown = function(fields) {
	var index;
	for (index in fields.Fields) {
		var option = $('<option value="' + fields.Fields[index].Id + '">' + fields.Fields[index].Name + '</option>');
		option.data('field', fields.Fields[index]);
		$("#ddlField").append(option);
	}
};

VP.BulkEmail.SegmentRuleManager.prototype.GetField = function(fieldId) {
	var that = this;
	var field;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: this._serviceUrl + "/GetField",
		data: "{'fieldId' : " + fieldId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			field = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location = "../../Error.aspx";
		}
	});

	return field;
};

VP.BulkEmail.SegmentRuleManager.prototype.ValidateAndPopulateFields = function() {
	var isValid = true;
	var editorElements = $("div.divSegmentFieldTemplate li", this._element);
	if (editorElements.length > 0) {
		editorElements.each(function() {
			var editor = $(this).data("conditionEditor");
			isValid = isValid && editor.ValidateAndPopulate();
		});
	}
	else {
		isValid = false;
		$.notify({ message: "There is no rule added. Please add atleaset one rule before save." });
	}

	return isValid;
};

VP.BulkEmail.SegmentRuleManager.prototype.SaveSegment = function() {
	var that = this;
	this._segmentTree.FinalizeTree();
	var segmentData = $.toJSON(this._segmentTree._segment);
	var field;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: this._serviceUrl + "/SaveSegment",
		data: "{'segment' : " + segmentData + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			var pageIndex = that.GetPageIndex();
			$.notify({ message: "Segment rule saved successfully.", type: 'ok', time: 950 });
			window.setTimeout("document.location = './SegmentList.aspx?pageInd=" + pageIndex + "';", 1000);
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location = "../../Error.aspx";
		}
	});
};

VP.BulkEmail.SegmentRuleManager.prototype.GetSegmentFieldType = function(segmentFieldTypeIdValue) {
	var segmentFieldText = '';
	var segmentFieldTypeId = parseInt(segmentFieldTypeIdValue, 10);
	switch (segmentFieldTypeId) {
		case this.Region:
			segmentFieldText = "Region";
			break;
		case this.Static:
			segmentFieldText = "Static";
			break;
		case this.Custom:
			segmentFieldText = "Custom";
			break;
	}

	return segmentFieldText;
};

VP.BulkEmail.SegmentRuleManager.prototype.GetPageIndex = function() {
	var name = "pageInd";
	var regexS = "[\\?&]" + name + "=([^&#]*)";
	var regex = new RegExp(regexS);
	var result = regex.exec(window.location.href);
	return result[1];
};

VP.BulkEmail.SegmentRuleManager.prototype.ShowPreview = function(currentPage, searchText) {
	var that = this;
	var startIndex = ((currentPage - 1) * this._pageSize) + 1;
	var endIndex = startIndex + this._pageSize - 1;
	this._segmentTree.FinalizeTree();
	var segmentData = $.toJSON(this._segmentTree._segment);
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: this._serviceUrl + "/GetCampaignRecipientsPreview",
		data: "{'segment' : " + segmentData + ", startIndex : " + startIndex + ", endIndex : " + endIndex +
				", searchText : '" + searchText + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			var a = msg.d;
			var pageSize = that._pageSize;
			var pageCount = Math.ceil(msg.d.TotalCount / pageSize);
			var html = that.GetPreviewHtml(msg.d.EmailList);
			$("#spanTotoalCount", "#divSegmentPreview").text(" " + msg.d.TotalCount + " ");
			$("#divSegmentEmailList", "#divSegmentPreview").text("").prepend(html);
			$("#divSegmentPreviewPager").pager({ pagenumber: currentPage, pagecount: pageCount,
				buttonClickCallback: function(clickedPage) { that.ShowPreview(clickedPage, searchText); }
			});
			document.location = "#scroll";
			$("#divSegmentPreview").jqmShow();
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location = "../../Error.aspx";
		}
	});
};

VP.BulkEmail.SegmentRuleManager.prototype.GetPreviewHtml = function(emailList) {
	var html;
	if (emailList.length > 0) {

		html = "<table id='segmentPreviewTable' width='100%'>";
		var index;
		for (index = 0; index < emailList.length; index = index + 2) {
			html += "<tr class = 'segmentPreviewRow'>" +
				"<td>" + emailList[index] + "</td>";
			if (emailList.length > index + 1) {
				html += "<td>" + emailList[index + 1] + "</td>";
			}

			html += "</tr>";
		}

		html += "<tr><td colspan='2' class='tdPager'><div id='divSegmentPreviewPager'></div></td></tr></table>";
	}
	else {
		html = "<div class='empty'>There are no recipients to display.</div>";
	}

	return html;
};
