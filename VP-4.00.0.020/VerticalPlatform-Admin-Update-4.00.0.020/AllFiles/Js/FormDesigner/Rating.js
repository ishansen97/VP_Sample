VP.Forms.Designer.RatingDesignTimeElement = function () {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.FieldType = 17;
	this.FieldId = 0;
	this.Title = "Rating";
	this.CssClass = "";
	this.Name = "";
	this.IsRequired = true;
	this.RequiredErrorMessage = "";
};

VP.Forms.Designer.RatingDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.RatingDesignTimeElement.prototype.GetData = function () {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.Name = this.Name;
	field.CssClass = this.CssClass;
	field.IsRequired = this.IsRequired;
	field.RequiredErrorMessage = this.RequiredErrorMessage;
	return field;
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.Load = function (data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.LoadProperties = function (data) {
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
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.CreateUI = function () {
	if (this._edit) {
		return this.GetHtml();
	}
	else {
		return "<div id='new'>...designing</div>";
	}
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.GetHtml = function () {
	return "<div class=\"containerControl\">" + this.Title + " : " + this.Name + "</div>";
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.PreparePropertyDialog = function () {
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
		if (!this.IsRequired) {
			$("#custom #required").removeAttr("checked");
		}
		$("#custom #requiredMessage").val(this.RequiredErrorMessage);
	}

	$("#custom #ddlFields").change(function () {
		that.FieldChange();
	});
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.UpdateProperties = function () {
	if (this.Validate()) {
		var previousFieldId = this.FieldId;
		this.FieldId = $("#custom #ddlFields").val();
		this.Name = $("#custom #name").val();
		this.CssClass = $("#custom #cssClass").val();
		this.IsRequired = $("#custom #required").attr("checked");
		this.RequiredErrorMessage = $("#custom #requiredMessage").val();

		$(this._element).find(".controlUI").empty().append(this.GetHtml());

		this.AddField(previousFieldId);

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply();
	}
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.Validate = function () {
	var valid = true;
	var errorMessage = "";
	if ($("#custom #ddlFields").val() == "-1") {
		valid = false;
		errorMessage += "Please select a field. ";
	}

	$("#custom #errorMsg").text(errorMessage);
	return valid;
};

VP.Forms.Designer.RatingDesignTimeElement.prototype.CancelProperties = function () {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}

	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
};
