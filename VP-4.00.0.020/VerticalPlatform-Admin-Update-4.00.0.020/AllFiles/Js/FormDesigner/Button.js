VP.Forms.Designer.ButtonDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "Button";
	this.FieldType = 8;
	this.FieldId = 0;
	this.Caption = "";
}

VP.Forms.Designer.ButtonDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.ButtonDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\">" +
			"<input class='form_designer_button btn btn-primary' type='button' value='" + this.Caption + "' />" +
			"</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}


VP.Forms.Designer.ButtonDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);

	var that = this;
	var fieldsHtml = this.GetFieldsHtml();
	$("#custom").empty();
	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>CSS Class</span>" +
		"<span class='popupCol2'><input type='text' /></span>" +
		"</div></div>");

	$("#custom #ddlFields").change(function() {
		that.FieldChange();
	});

	if (this._edit) {
		$("#custom #ddlFields").val(this.FieldId);
		$("#custom input[type='text']").val(this._cssClass);
	}
}

VP.Forms.Designer.ButtonDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply(this);
}

VP.Forms.Designer.ButtonDesignTimeElement.prototype.UpdateProperties = function() {
	if ($("#custom #ddlFields").val() == "-1") {
		this.CancelProperties();
		return;
	}

	var previousFieldId = this.FieldId;
	this.FieldId = $("#custom #ddlFields").val();
	this.Caption = $("#ddlFields :selected").text();
	this._cssClass = $("#custom input[type='text']").val();

	var html = "<div class=\"containerControl\">" +
			"<input type='button' value='" + this.Caption + "' />" +
			"</div>";

	$(this._element).find(".controlUI").empty().append(html);

	this.AddField(previousFieldId);

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply();
}

VP.Forms.Designer.ButtonDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.FieldText = this.Caption;
	field.CssClass = this._cssClass;
	return field;
}

VP.Forms.Designer.ButtonDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.ButtonDesignTimeElement.prototype.LoadProperties = function(data) {
	this.FieldId = data.Id;
	this.Caption = data.FieldText;
	if (data.CssClass != null) {
		this._cssClass = data.CssClass;
	}
}
