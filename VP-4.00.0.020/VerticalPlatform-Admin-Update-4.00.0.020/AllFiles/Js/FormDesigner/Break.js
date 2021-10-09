VP.Forms.Designer.BreakDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "";
	this.FieldType = 11;
	this.Text = "";
}

VP.Forms.Designer.BreakDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.BreakDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\"><h3>" + this.Title + "</h3><p>" + this.Text + "</p></div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.BreakDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply(this);
}

VP.Forms.Designer.BreakDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();
	$("#custom").append("<div class='dialog_header clearfix'><h2>Break</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
		"<span class='popupCol1'>Section Break Title</span>" +
		"<span class='popupCol2'><input type='text' /></span>" +
		"</div>" +
		"<div class='popupRow'>" +
		"<span class='popupCol1'>Section Break Text</span>" +
		"<span class='popupCol2'><textarea cols='50' rows='10'></textarea></span>" +
		"</div>" +
		"<div id='errorMsg' style='color:Red'></div></div>");

	$("#custom textarea").bind("keypress", function(event) {
		if (event.stopPropagation) {
			event.stopPropagation();
		}
		else {
			event.cancelBubble = true;
		}
	});

	if (this._edit) {
		$("#custom input[type='text']").val(this.Title);
		$("#custom textarea").val(this.Text);
	}
}

VP.Forms.Designer.BreakDesignTimeElement.prototype.UpdateProperties = function() {
	if (this.Validate()) {
		this.Title = $("#custom input[type='text']").val();
		this.Text = $("#custom textarea").val();

		var html = "<div class=\"containerControl\"><h3>" + this.Title + "</h3><p>" + this.Text + "</p></div>";

		$(this._element).find(".controlUI").empty().append(html);

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
	}
}

VP.Forms.Designer.BreakDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.FieldText = this.Text;
	field.FieldTitle = this.Title;
	return field;
}

VP.Forms.Designer.BreakDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}


VP.Forms.Designer.BreakDesignTimeElement.prototype.LoadProperties = function(data) {
	if (data.FieldText != null) {
		this.Text = data.FieldText;
	}
	if (data.FieldTitle != null) {
		this.Title = data.FieldTitle;
	}
}

VP.Forms.Designer.BreakDesignTimeElement.prototype.Validate = function() {
	var title = $("#custom input[type='text']").val();
	if (title == "") {
		$("#custom #errorMsg").text("Title is required");
		return false;
	}

	return true;
}