VP.Forms.Designer.DatePickerDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "DatePicker";
	this.FieldType = 12;
	this.FieldId = 0;
	this.Range = 10;
}

VP.Forms.Designer.DatePickerDesignTimeElement.prototype = Object.create(VP.Forms.Designer.TextBoxDesignTimeElement.prototype);

VP.Forms.Designer.DatePickerDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\">" +
			"<input type='text' class='field' value='DatePicker' readonly='readonly'></input>" +
			"</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.DatePickerDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();
	var that = this;

	var fieldsHtml = this.GetFieldsHtml();

	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Range</span>" +
		"<span class='popupCol2'>" +
			"<select id='range'>" +
				"<option value='10'>10</option>" +
				"<option value='20'>20</option>" +
				"<option value='30'>30</option>" +
				"<option value='40'>40</option>" +
				"<option value='50'>50</option>" +
				"<option value='60'>60</option>" +
				"<option value='70'>70</option>" +
				"<option value='80'>80</option>" +
				"<option value='90'>90</option>" +
				"<option value='100'>100</option>" +
			"</select>" +
		"</span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>CSS Class</span>" +
		"<span class='popupCol2'><input type='text' id='txtCSS' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Is Required</span>" +
		"<span class='popupCol2'><input type='checkbox' id='chkRequired' checked='checked' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Required Error Message</span>" +
		"<span class='popupCol2'><textarea id='txtReqErr'></textarea></span>" +
		"</div></div>"
	);

	$("#custom #ddlFields").change(function() {
		that.FieldChange();
	});

	if (this._edit) {
		$("#custom #ddlFields").val(this.FieldId);
		$("#custom #range").val(this.Range);
		$("#custom #txtCSS").val(this._cssClass);
		if (this.IsRequired) {
			$("#custom #chkRequired").attr("checked", "checked");
		}
		else {
			$("#custom #chkRequired").removeAttr("checked");
		}
		$("#custom #txtReqErr").val(this.RequiredErrorMessage);
	}
}

VP.Forms.Designer.DatePickerDesignTimeElement.prototype.UpdateProperties = function() {
	if ($("#custom #ddlFields").val() == "-1") {
		this.CancelProperties();
		return;
	}

	var previousFieldId = this.FieldId;
	this.FieldId = $("#custom #ddlFields").val();
	this.Text = $("#ddlFields :selected").text();
	this.Range = $("#custom #range").val();
	this._cssClass = $("#custom input[type='text']").val();
	this.IsRequired = $("#custom #chkRequired").attr("checked");
	this.RequiredErrorMessage = $("#custom #txtReqErr").val();

	var html = "<div class=\"containerControl\">" +
			"<input type='text' class='field' value='DatePicker' readonly='readonly'></input>" +
			"</div>";

	$(this._element).find(".controlUI").empty().append(html);

	this.AddField(previousFieldId);

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
}

VP.Forms.Designer.DatePickerDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.CssClass = this._cssClass;
	field.IsRequired = this.IsRequired;
	field.RequiredErrorMessage = this.RequiredErrorMessage;
	field.MaxLength = this.Range;

	return field;
}

VP.Forms.Designer.DatePickerDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.DatePickerDesignTimeElement.prototype.LoadProperties = function(data) {
	this.FieldId = data.Id;
	if (data.CssClass != null) {
		this._cssClass = data.CssClass;
	}
	if (data.IsRequired != null) {
		this.IsRequired = data.IsRequired;
	}
	if (data.RequiredErrorMessage != null) {
		this.RequiredErrorMessage = data.RequiredErrorMessage;
	}
	if (data.MaxLength != null) {
		this.Range = data.MaxLength;
	}
}