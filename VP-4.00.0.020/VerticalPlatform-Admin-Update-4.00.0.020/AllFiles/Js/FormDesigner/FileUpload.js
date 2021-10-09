VP.Forms.Designer.FileUploadDesignTimeElement = function () {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.FieldType = 16;
	this.FieldId = 0;
	this.Title = "File Upload";
	this.CssClass = "";
	this.Name = "";
	this.IsRequired = true;
	this.RequiredErrorMessage = "";
	this.MaxSize = 100;
	this.RegularExpression = "";
	this.RegularExpressionMessage = "";
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.GetData = function () {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.CssClass = this.CssClass;
	field.Name = this.Name;
	field.IsRequired = this.IsRequired;
	field.RequiredErrorMessage = this.RequiredErrorMessage;
	field.MaxLength = this.MaxSize;
	field.RegularExpression = this.RegularExpression;
	field.RegularExpressionMessage = this.RegularExpressionMessage;
	return field;
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.Load = function (data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.LoadProperties = function (data) {
	this.FieldId = data.Id;
	if (data.CssClass != null) {
		this.CssClass = data.CssClass;
	}

	if (data.Name != null) {
		this.Name = data.Name;
	}
	this.IsRequired = data.IsRequired;
	if (data.RequiredErrorMessage != null) {
		this.RequiredErrorMessage = data.RequiredErrorMessage;
	}
	this.MaxSize = data.MaxLength;
	if (data.RegularExpression != null) {
		this.RegularExpression = data.RegularExpression;
	}
	if (data.RegularExpressionMessage != null) {
		this.RegularExpressionMessage = data.RegularExpressionMessage;
	}
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.CreateUI = function () {
	if (this._edit) {
		return this.GetHtml();
	}
	else {
		return "<div id='new'>...designing</div>";
	}
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.GetHtml = function () {
	return "<div class=\"containerControl\">" + this.Title + " : " + this.Name + "</div>";
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.PreparePropertyDialog = function () {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);

	var fieldsHtml = this.GetFieldsHtml();

	$("#custom").empty();
	$("#custom").append(
		"<div class='dialog_header clearfix'>" +
		"<h2>" + this.Title + "</h2>" +
		"</div>" +
		"<div class='content_div'>" +
		"<div>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Name</span>" +
		"<span class='popupCol2'><input type='text' id='name' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Max File Size(kb)</span>" +
		"<span class='popupCol2'><input type='text' id='maxSize' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>CSS Class</span>" +
		"<span class='popupCol2'><input type='text' id='cssClass' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Is Required</span>" +
		"<span class='popupCol2'><input type='checkbox' id='required' checked='checked' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Required Error Message</span>" +
		"<span class='popupCol2'><textarea id='requiredMessage'></textarea></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Regular Expression</span>" +
		"<span class='popupCol2'><input type='text' id='regex' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Regular Expression Message</span>" +
		"<span class='popupCol2'><textarea id='regexError'></textarea></span>" +
		"</div>" +
		"<div id='errorMsg' style='color:Red'></div>" +
		"</div>");

	if (this._edit) {
		$("#custom #ddlFields").val(this.FieldId);
		$("#custom #name").val(this.Name);
		$("#custom #cssClass").val(this.CssClass);
		$("#custom #maxSize").val(this.MaxSize);
		if (!this.IsRequired) {
			$("#custom #required").removeAttr("checked");
		}
		$("#custom #requiredMessage").val(this.RequiredErrorMessage);
		$("#custom #regex").val(this.RegularExpression);
		$("#custom #regexError").val(this.RegularExpressionMessage);
	}
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.UpdateProperties = function () {
	if (this.Validate()) {
		var previousFieldId = this.FieldId;
		this.FieldId = $("#custom #ddlFields").val();
		this.Name = $("#custom #name").val();
		this.CssClass = $("#custom #cssClass").val();
		this.MaxSize = $("#custom #maxSize").val();
		this.IsRequired = $("#custom #required").attr("checked");
		this.RequiredErrorMessage = $("#custom #requiredMessage").val();
		this.RegularExpression = $("#custom #regex").val();
		this.RegularExpressionMessage = $("#custom #regexError").val();

		$(this._element).find(".controlUI").empty().append(this.GetHtml());

		this.AddField(previousFieldId);

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply();
	}
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.Validate = function () {
	var valid = true;
	var errorMessage = "";
	if ($("#custom #ddlFields").val() == "-1") {
		valid = false;
		errorMessage += "Please select a field. ";
	}

	var text = $("#custom #maxSize").val();
	if (text == "") {
		valid = false;
		errorMessage += "Please enter a maximum file size. ";
	}
	else {
		if (text.match(/^[0-9]+$/) == null) {
			valid = false;
			errorMessage += "Maximum file size should be a number. ";
		}

		if (parseInt(text) > 500) {
			valid = false;
			$.notify({ message: "Maximum file size should be less than 500kb. File size set to 500kb by default.", type: 'error' });
			$("#custom #maxSize").val("500");
		}
	}

	$("#custom #errorMsg").text(errorMessage);
	return valid;
};

VP.Forms.Designer.FileUploadDesignTimeElement.prototype.CancelProperties = function () {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}

	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
};
