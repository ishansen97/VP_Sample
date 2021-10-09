VP.Forms.Designer.HtmlDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "Html";
	this.FieldType = 4;
	this.Text = "";
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.HtmlDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\">" + this.GetEncodedHtml() + "</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.GetEncodedHtml = function() {
	var encodedHtml = this.Text.replace(/</g, '%3C');
	encodedHtml = encodedHtml.replace(/>/g, '%3E');
	return encodedHtml;
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();
	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
		"<textarea class='text' cols='50' rows='10' style='width:485px'></textarea>" +
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
		$("#custom .text").val(this.Text);
	}
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply(this);
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.UpdateProperties = function() {
	if (this.Validate()) {
		this.Text = $("#custom .text").val();

		var html = "<div class=\"containerControl\">" + this.GetEncodedHtml() + "</div>";

		$(this._element).find(".controlUI").empty().append(html);

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
	}
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.FieldText = this.Text;
	return field;
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.LoadProperties = function(data) {
	this.Text = data.FieldText;
}

VP.Forms.Designer.HtmlDesignTimeElement.prototype.Validate = function() {
	var text = $("#custom .text").val();
	if (text == "") {
		$("#custom #errorMsg").text("Required");
		return false;
	}

	return true;
}