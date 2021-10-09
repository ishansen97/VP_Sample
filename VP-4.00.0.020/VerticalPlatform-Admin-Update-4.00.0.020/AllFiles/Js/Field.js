
RegisterNamespace("VP.Forms.Field");

VP.Forms.Field.SelectedLeadTypeId = 0;
VP.Forms.Field.SiteId = 0;
VP.Forms.Field.ContentId = 0;
VP.Forms.Field.ContentTypeId = 0;
VP.Forms.Field.WebServiceUrl = "";
VP.Forms.Field.FieldContentType = 0;


VP.Forms.Field.Initialize = function() {
	$(document).ready(function() {
		$("#dialog").jqm(
		{
			modal: true
		});

		$("#custom #ddlFieldType").change(function() {
			VP.Forms.Field.FieldTypeChange();
		});

		$("#btnAddNew").click(function() {
			VP.Forms.Field.AddNewField();
		});

		$("#custom #btnNewOption").click(function() {
			VP.Forms.Field.AddNewOption();
		});

		$("#custom #btnSave").click(function() {
			VP.Forms.Field.Save();
		});

		$("#custom #btnCancel").click(function() {
			VP.Forms.Field.Cancel();
		});

		$("#custom #btnCancelBottom").click(function() {
			VP.Forms.Field.Cancel();
		});

		$("#custom").keypress(function(event) {
			if (event.which == 13) {
				$("#custom #btnSave").click();
				event.returnValue = false;
				event.cancel = true;
				event.keyCode = 0;
				return false;
			}
		});

		VP.Forms.Field.ShowOptions(false);
	});
}

VP.Forms.Field.AddNewField = function() {
	VP.Forms.Field.ClearAllInputElements();
	$("#custom #fieldTypes").show();
	VP.Forms.Field.OptionCount = 0;
	$("#custom #hdnFieldId").val("0");
	$("#custom #ddlFieldType").val("0");
	VP.Forms.Field.SetDialogTitle("Add new field");
	$("#custom #fieldProperties").hide();
	VP.Forms.Field.ShowModalDialog();
}

VP.Forms.Field.ShowModalDialog = function() {
	$("#dialog").jqmShow();
}

VP.Forms.Field.Cancel = function() {
	if (VP.Forms.Field.ValidateCancel()) {
		VP.Forms.Field.CloseModalDialog();
	}
}

VP.Forms.Field.CloseModalDialog = function() {
	$("#dialog").jqmHide();
}

VP.Forms.Field.ShowFieldTypeProperties = function (fieldType) {
	if (fieldType == 0) {
		$("#custom #fieldProperties").hide();
	}
	else {
		$("#custom #fieldProperties").show();
		$("#custom #chkEnabled").attr('checked', 'checked');
		if (fieldType == 3 || fieldType == 1 || fieldType == 6) {
			VP.Forms.Field.ShowOptions(true);
		}
		else {
			VP.Forms.Field.ShowOptions(false);
		}
	}
}

VP.Forms.Field.ShowOptions = function(show) {
	if (show) {
		$("#custom #fieldOptionsContainer").show();
		$("#custom #addNewFieldOptions").show();
	}
	else {
		$("#custom #fieldOptionsContainer").hide();
		$("#custom #addNewFieldOptions").hide();
	}
};

VP.Forms.Field.FieldTypeChange = function () {
	VP.Forms.Field.ClearAllInputElements();
	var fieldType = $("#custom #ddlFieldType").val();
	VP.Forms.Field.ShowFieldTypeProperties(fieldType);

	if (fieldType == 8 || fieldType == 14) {
		$("#custom #predefinedFields").show();
		VP.Forms.Field.LoadPredefinedFields(fieldType);
	}
	else {
		$("#custom #predefinedFields").hide();
	}

	if (fieldType == 3 || fieldType == 1 || fieldType == 6) {
		VP.Forms.Field.ShowOptions(true);
		VP.Forms.Field.AddFieldOptions(null);
	}
	else {
		VP.Forms.Field.ShowOptions(false);
	}
}

VP.Forms.Field.ClearAllInputElements = function() {
	$("#custom #txtFieldName").val("");
	$("#custom #txtFieldNameAbbreviation").val("");
	$("#custom #txtFieldDescription").val("");
	$("#custom #fieldOptions").empty();
}

VP.Forms.Field.LoadPredefinedFields = function(fieldType) {
	var html;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.Forms.Field.WebServiceUrl + "/GetPredefinedFieldsHtml",
		data: "{'fieldType' : '" + fieldType + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			html = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	$("#custom #preFieldsContainer").empty().append(html);

	$("#custom #ddlPreDefined").unbind().change(function() {
		VP.Forms.Field.PredefinedFieldChange();
	});
}

VP.Forms.Field.PredefinedFieldChange = function() {
	VP.Forms.Field.ClearAllInputElements();
	var predefinedField = $("#custom #ddlPreDefined").val();
	if (predefinedField != "0") {
		$("#custom #txtFieldName").val($('option:selected', $("#custom #ddlPreDefined")).text());
	}
	else {
		var fieldType = $("#custom #ddlFieldType").val();
		if (fieldType == 1 || fieldType == 3 || fieldType == 6) {
			VP.Forms.Field.AddFieldOptions(null);
		}
	}
}

VP.Forms.Field.Edit = function (fieldId) {
	$("#custom #fieldTypes").hide();
	$("#custom #predefinedFields").hide();

	VP.Forms.Field.OptionCount = 0;
	$("#custom #hdnFieldId").val(fieldId);
	var field;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.Forms.Field.WebServiceUrl + "/GetField",
		data: "{'fieldId' : '" + fieldId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			field = msg.d;
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});

	if (field != null) {
		$("#custom #ddlFieldType").val(field.FieldType);
		VP.Forms.Field.ShowFieldTypeProperties(field.FieldType);

		$("#custom #txtFieldName").val(field.FieldText);
		$("#custom #txtFieldNameAbbreviation").val(field.FieldTextAbbreviation);
		$("#custom #txtFieldDescription").val(field.FieldDescription);

		if (field.Enabled) {
			$("#custom #chkEnabled").attr('checked', 'checked');
		}
		else {
			$("#custom #chkEnabled").removeAttr('checked');
		}

		VP.Forms.Field.LoadFieldOptions(field.Id, field.FieldType, field.PredefinedFieldId);

		VP.Forms.Field.SetEditDialogTitle(field.FieldType);

		VP.Forms.Field.ShowModalDialog();
	}
}

VP.Forms.Field.LoadFieldOptions = function(fieldId, fieldType, predefinedFieldId) {
	if (predefinedFieldId == null) {
		if (fieldType == 1 || fieldType == 3 || fieldType == 6) {
			var options;
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: VP.Forms.Field.WebServiceUrl + "/GetFieldOptions",
				data: "{'fieldId' : '" + fieldId + "'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(msg) {
					options = msg.d;
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					var error = XMLHttpRequest;
				}
			});

			VP.Forms.Field.AddFieldOptions(options);

		}
	}
}

VP.Forms.Field.AddFieldOptions = function(options) {
	$("#custom #fieldOptions").empty();
	if (options != null) {
		if (options.length > 0) {
			for (var i = 0; i < options.length; i++) {
				var option = options[i];
				VP.Forms.Field.AddOption(option.FieldOptionValue, option.Id, option.Enabled);
			}
		}
	}
	else {
		for (var i = 1; i < 4; i++) {
			for (var i = 1; i < 4; i++) {
				VP.Forms.Field.AddOption("text" + i, "0", true);
			}
		}
	}
}

VP.Forms.Field.AddNewOption = function() {
	VP.Forms.Field.AddOption("", "0", true);
}

VP.Forms.Field.OptionCount = 0;

VP.Forms.Field.AddOption = function(text, value, enabled) {
	var html = "<div id='Option_" + VP.Forms.Field.OptionCount + "' class='dialogOption'>";

	if (value > 0) {
		html += "<span style='padding-right:5px;'>" + value + " </span>";
	}

	html += "<span>" +
		"<input type='text' class='text' value='" + text + "' size='50' />" +
	"</span>" +
	"<span class='value' style='display:none'>" + value + "</span>";

	if (enabled) {
		html += "<span>" +
				"<input type='checkbox' class='enabled' checked='checked'/>" +
			"</span>";
	}
	else {
		html += "<span>" +
				"<input type='checkbox' class='enabled'/>" +
			"</span>";
	}

	html += "<span>&nbsp;" +
		"<a id='OptionDel_" + VP.Forms.Field.OptionCount + "' class='deleteIcon' onclick='VP.Forms.Field.DeleteOption(\"Option_" + VP.Forms.Field.OptionCount + "\");'></a>" +
		"</span>" +
		"<span>" +
			"<a id='OptionUp_" + VP.Forms.Field.OptionCount + "' class='upIcon' onclick='VP.Forms.Field.MoveUpOption(\"Option_" + VP.Forms.Field.OptionCount + "\");'></a>" +
		"</span>" +
		"<span>" +
			"<a id='OptionDown_" + VP.Forms.Field.OptionCount + "' class='downIcon' onclick='VP.Forms.Field.MoveDownOption(\"Option_" + VP.Forms.Field.OptionCount + "\");'></a>" +
		"</span>" +
		"</div>";

	$("#custom #fieldOptions").append(html);
	VP.Forms.Field.OptionCount++;
}

VP.Forms.Field.SetEditDialogTitle = function(fieldType) {
	VP.Forms.Field.SetDialogTitle($("#custom #ddlFieldType").find("option:selected").text());
}

VP.Forms.Field.SetDialogTitle = function(title) {
	$("#custom h3").text(title);
}

VP.Forms.Field.Save = function() {
	if (VP.Forms.Field.Validate()) {
		var field = new VerticalPlatform.Core.Data.Entities.Field()
		field.Id = $("#custom #hdnFieldId").val();
		field.siteId = VP.Forms.Field.SiteId;
		field.FieldType = $("#custom #ddlFieldType").val();
		field.ContentType = VP.Forms.Field.ContentTypeId;
		field.ContentId = VP.Forms.Field.ContentId;
		field.ActionId = VP.Forms.Field.SelectedLeadTypeId;
		field.FieldContentType = VP.Forms.Field.FieldContentType;
		field.FieldDescription = $("#custom #txtFieldDescription").val();
		field.FieldText = $("#custom #txtFieldName").val();
		field.FieldTextAbbreviation = $("#custom #txtFieldNameAbbreviation").val();
		field.Enabled = $("#custom #chkEnabled").attr('checked');

		var preDefControl = $("#custom #ddlPreDefined");
		if (preDefControl.length > 0) {
			var preId = $(preDefControl).val();
			if (preId != "0") {
				field.PredefinedFieldId = preId;
			}
		}

		var jsonField = $.toJSON(field);

		var fieldId;

		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: VP.Forms.Field.WebServiceUrl + "/SaveField",
			data: "{'field' : " + jsonField + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				if (msg.d.startsWith("-")) {
					$.notify({ message: 'A field already exist with the name ' + field.FieldText, type: 'error' });
				}
				else if (msg.d.startsWith("*")) {
					$.notify({ message: 'A field already exist with the abbreviation ' + field.FieldTextAbbreviation, type: 'error' });
				}
				else {
					fieldId = msg.d;
					VP.Forms.Field.SaveOptions(fieldId);
					VP.Forms.Field.CloseModalDialog();

					$.notify({ message: 'Field \'' + field.FieldText + '\' saved', type: 'ok' });
					$(".hiddenFieldButton").click();
				}
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
			}
		});
	}
}

VP.Forms.Field.SaveOptions = function(fieldId) {
	var options = $("#custom #fieldOptions .dialogOption");
	if (options.length > 0) {
		for (var i = 0; i < options.length; i++) {
			var optionValue = $(options[i]).find(".text").val();
			var optionId = $(options[i]).find(".value").text();
			var enabled = $(options[i]).find(".enabled").attr('checked');
			optionId = VP.Forms.Field.SaveFieldOption(optionId, fieldId, optionValue, enabled, i);
		}
	}
}

VP.Forms.Field.ValidateCancel = function() {
	var isValid = true;
	if ($("#custom #hdnFieldId").val() != "0") {
		var fieldType = $("#custom #ddlFieldType").val();
		var predefinedId = $("#custom #ddlPreDefined").val();
		if (predefinedId == "0") {
			if (fieldType == 1 || fieldType == 3 || fieldType == 6) {

				var options = $("#custom #fieldOptions .dialogOption");
				if (options.length == 0) {
					isValid = false;
				}
				else {
					var isExist = false;
					for (var i = 0; i < options.length; i++) {

						var optionValue = $(options[i]).find(".value").text();
						if (optionValue > 0) {
							isExist = true;
						}
					}

					isValid = isValid && isExist;
				}

				if (!isValid) {
					$.notify({ message: 'Field type should have atleast one option saved.'+
					'Please save a option and exit the dialog', type: 'error' });
				}
			}
		}
	}

	return isValid;
}


VP.Forms.Field.Validate = function() {
	var isValid = true;
	var fieldType = $("#custom #ddlFieldType").val();
	if (fieldType == "0") {
		$.notify({ message: 'Please select a field type.', type: 'error' });
		return false;
	}
	if ($("#custom #txtFieldName").val() == "") {
		isValid = false;
		$.notify({ message: 'Please enter field name.', type: 'error' });
	}
	if (VP.Forms.Field.FieldContentType == 9 && $("#custom #txtFieldNameAbbreviation").val() == "") {
		isValid = false;
		$.notify({ message: 'Please enter field name abbreviation.', type: 'error' });
	}

	if (fieldType == 1 || fieldType == 3 || fieldType == 6) {
		var options = $("#custom #fieldOptions input[type='text']");
		var isOptionsValid = true;
		for (var i = 0; i < options.length; i++) {
			if ($(options[i]).val() == "") {
				isOptionsValid = false;
			}
		}
		if (!isOptionsValid) {
			$.notify({ message: 'Cannot have empty options ', type: 'error' });
			isValid = isOptionsValid && isValid;
		}
	}

	var options = $("#custom #fieldOptions .dialogOption");
	var isOptionNotDuplicated = true;
	if (options.length > 0) {
		for (var i = 0; i < options.length - 1; i++) {
			for (var j = i + 1; j < options.length; j++) {
				if ($(options[i]).find(".text").val().toLowerCase() == $(options[j]).find(".text").val().toLowerCase()) {
					isOptionNotDuplicated = false;
				}
			}
		}
		if (!isOptionNotDuplicated) {
			$.notify({ message: 'Field Option Names Duplicated ', type: 'error' });
			isValid = isOptionNotDuplicated && isValid;
		}
	}

	return isValid;
}


VP.Forms.Field.SaveFieldOption = function(id, fieldId, value, enabled, sortOrder) {
	var option = new VerticalPlatform.Core.Data.Entities.FieldOption();
	option.Id = id;
	option.FieldId = fieldId;
	option.FieldOptionValue = value;
	option.Enabled = enabled;
	option.SortOrder = sortOrder;

	var optionId = 0;

	var jsonFieldOption = $.toJSON(option);

	$.ajax({
		type: "POST",
		async: false,
		url: VP.Forms.Field.WebServiceUrl + "/SaveFieldOption",
		data: "{'option' : " + jsonFieldOption + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			optionId = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}

	});

	return optionId;
}

VP.Forms.Field.DeleteOption = function(optionDiv) {
	var options = $("#custom #fieldOptions .dialogOption");

	var optionId = $("#custom #fieldOptions #" + optionDiv).find(".text").val();
	var optionValue = $("#custom #fieldOptions #" + optionDiv).find(".value").text();
	if (optionValue > 0) {
		if (confirm('Are you sure to delete this option?')) {

			if (VP.Forms.Field.DeleteSavedOptions(optionValue)) {
				$("#custom #fieldOptions #" + optionDiv).remove();
			}
		}
	}
	else {
		$("#custom #fieldOptions #" + optionDiv).remove();
	}
}

VP.Forms.Field.DeleteSavedOptions = function(optionId) {
	var status = false;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.Forms.Field.WebServiceUrl + "/DeleteFieldOption",
		data: "{'optionId' : '" + optionId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (!msg.d) {
				$.notify({ message: 'Cannot delete field option. Its already in use.', type: 'error' });
			}

			status = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}

	});

	return status;
}

VP.Forms.Field.MoveUpOption = function(optionDiv) {
	var options = $("#custom #fieldOptions .dialogOption");
	if (options.length > 1) {
		var previousOption = options[0];
		for (var i = 1; i < options.length; i++) {
			if (optionDiv == options[i].id) {
				$(options[i]).after($(previousOption));
				break;
			}
			previousOption = options[i];
		}
	}
}

VP.Forms.Field.MoveDownOption = function(optionDiv) {
	var options = $("#custom #fieldOptions .dialogOption");
	if (options.length > 1) {
		var nextOption = options[1];
		for (var i = 0; i < options.length - 1; i++) {
			if (optionDiv == options[i].id) {
				$(nextOption).after($(options[i]));
				break;
			}
			nextOption = options[i + 2];
		}
	}
}

VP.Forms.Field.Initialize();