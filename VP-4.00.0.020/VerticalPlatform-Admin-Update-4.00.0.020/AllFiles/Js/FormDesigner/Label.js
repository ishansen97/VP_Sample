VP.Forms.Designer.LabelDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "Label";
	this.FieldType = 7;
	this.Text = "";
}

VP.Forms.Designer.LabelDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.LabelDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class='containerControl'>" + this.Text + "</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.LabelDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();
	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
		"<span class='popupCol1'>Title</span>" +
		"<span class='popupCol2'><input type='text' class='title' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>CSS Class</span>" +
		"<span class='popupCol2'><input type='text' class='cssClass' /></span>" +
		"</div>" +
		"<div id='errorMsg' style='color:Red'></div></div>");

	if (this._edit) {
		$("#custom .title").val(this.Text);
		$("#custom .cssClass").val(this._cssClass);
	}
}

VP.Forms.Designer.LabelDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
}

VP.Forms.Designer.LabelDesignTimeElement.prototype.UpdateProperties = function() {
	if (validate()) {
		this.Text = $("#custom .title").val();
		this._cssClass = $("#custom .cssClass").val();

		var html = "<div class=\"containerControl\">" + this.Text + "</div>";

		$(this._element).find(".controlUI").empty().append(html);

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply();
	}
}

VP.Forms.Designer.LabelDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.FieldText = this.Text;
	field.CssClass = this._cssClass;
	return field;
}

VP.Forms.Designer.LabelDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.LabelDesignTimeElement.prototype.LoadProperties = function(data) {
	this.Text = data.FieldText;
	if (data.CssClass != null) {
		this._cssClass = data.CssClass;
	}
}

function validate() {
	if ($("#custom .title").val() !== "") {
		return true;
	}
	$("#custom #errorMsg").empty();
	$("#custom #errorMsg").append("Label title cannot be empty");
	return false;
}