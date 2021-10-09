VP.Forms.Designer.ContentPickerDesignTimeElement = function () {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.FieldType = 18;
	this.FieldId = 0;
	this.Title = "Content Picker";
	this.CssClass = "";
	this.Name = "";
	this.ContentTypeId = 0;
	this.IsRequired = true;
	this.RequiredErrorMessage = "";
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.GetData = function () {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.Name = this.Name;
	field.CssClass = this.CssClass;
	field.ContentTypeId = this.ContentTypeId;
	field.IsRequired = this.IsRequired;
	field.RequiredErrorMessage = this.RequiredErrorMessage;
	return field;
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.Load = function (data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.LoadProperties = function (data) {
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
	this.ContentTypeId = data.ContentTypeId;
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.CreateUI = function () {
	if (this._edit) {
		return this.GetHtml();
	}
	else {
		return "<div id='new'>...designing</div>";
	}
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.GetHtml = function () {
	return "<div class=\"containerControl\">" + this.Title + " : " + this.Name + "</div>";
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.PreparePropertyDialog = function () {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);

	var that = this;
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
		"<span class='popupCol1'>Content Type</span>" +
		"<span class='popupCol2'><select id='contentType'>" +
				"<option value='-1'>Select</option>" +
				"<option value='2'>Product</option>" +
				"<option value='6'>Vendor</option>" +
			"</select></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Name</span>" +
		"<span class='popupCol2'><input type='text' id='name' /></span>" +
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
		"<div id='errorMsg' style='color:Red'></div>" +
		"</div>");

	if (this._edit) {
		$("#custom #name").val(this.Name);
		$("#custom #cssClass").val(this.CssClass);
		$("#custom #ddlFields").val(this.FieldId);
		$("#custom #contentType").val(this.ContentTypeId);
		if (!this.IsRequired) {
			$("#custom #required").removeAttr("checked");
		}
		$("#custom #requiredMessage").val(this.RequiredErrorMessage);
	}

	$("#custom #ddlFields").change(function () {
		that.FieldChange();
	});
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.Validate = function () {
	var valid = true;
	var errorMessage = "";
	if ($("#custom #ddlFields").val() == "-1") {
		valid = false;
		errorMessage += "Please select a field. ";
	}

	if ($("#custom #contentType").val() == "-1") {
		valid = false;
		errorMessage += "Please select a content type. ";
	}

	$("#custom #errorMsg").text(errorMessage);
	return valid;
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.UpdateProperties = function () {
	if (this.Validate()) {
		var previousFieldId = this.FieldId;
		this.FieldId = $("#custom #ddlFields").val();
		this.Name = $("#custom #name").val();
		this.CssClass = $("#custom #cssClass").val();
		this.ContentTypeId = $("#custom #contentType").val();
		this.IsRequired = $("#custom #required").attr("checked");
		this.RequiredErrorMessage = $("#custom #requiredMessage").val();

		$(this._element).find(".controlUI").empty().append(this.GetHtml());

		this.AddField(previousFieldId);

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply();
	}
};

VP.Forms.Designer.ContentPickerDesignTimeElement.prototype.CancelProperties = function () {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}

	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
};
