VP.Forms.Designer.CheckBoxDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "CheckBox";
	this.FieldType = 15;
	this.FieldId = 0;
	this.Text = "";
};

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();

	var that = this;

	var fieldsHtml = this.GetFieldsHtml();

	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div></div>");

	$("#custom #ddlFields").change(function() {
		that.FieldChange();
	});

	if (this._edit) {
		$("#custom #ddlFields").val(this.FieldId);
	}
};

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype.UpdateProperties = function() {
	if ($("#custom #ddlFields").val() == "-1") {
		this.CancelProperties();
		return;
	}

	var previousFieldId = this.FieldId;
	this.FieldId = $("#custom #ddlFields").val();
	this.Text = $("#ddlFields :selected").text();

	var html = "<div class=\"containerControl\">" +
			"<input type='checkbox' class='field'>[" + this.Text + "]</input>" +
			"</div>";

	$(this._element).find(".controlUI").empty().append(html);

	this.AddField(previousFieldId);

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
};

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.FieldText = this.Text;
	return field;
};

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype.LoadProperties = function(data) {
	this.FieldId = data.Id;
	this.Text = data.FieldText;
};

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
}

VP.Forms.Designer.CheckBoxDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\">" +
			"<input type='checkbox' class='field'>[" + this.Text + "]</input>" +
			"</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}