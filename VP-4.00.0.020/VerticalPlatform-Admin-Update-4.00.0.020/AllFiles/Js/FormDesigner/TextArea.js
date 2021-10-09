VP.Forms.Designer.TextAreaDesignTimeElement = function() {
	VP.Forms.Designer.TextBoxDesignTimeElement.apply(this);
	this.Title = "TextArea";
	this.FieldType = 5;
	this.Placeholder = "";
}

VP.Forms.Designer.TextAreaDesignTimeElement.prototype = Object.create(VP.Forms.Designer.TextBoxDesignTimeElement.prototype);

VP.Forms.Designer.TextAreaDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\">" +
			"<textarea class='field' readonly='readonly'>" + this.Text + "</textarea>" +
			"</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.TextAreaDesignTimeElement.prototype.PreparePropertyDialog = function() {
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
		"<span class='popupCol1'>CSS Class</span>" +
		"<span class='popupCol2'><input type='text' id='txtCSS' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Is Required</span>" +
		"<span class='popupCol2'><input type='checkbox' id='chkRequired' checked='checked' /></span>" +
		"</div>" +
	    "<div>" +
	    "<span class='popupCol1'>Placeholder</span>" +
	    "<span class='popupCol2'><input type='text' id='txtPlaceholder' /></span>" +
	    "</div>" +
		"<div>" +
		"<span class='popupCol1'>Required Error Message</span>" +
		"<span class='popupCol2'><textarea id='txtReqErr'></textarea></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Select Expression</span>" +
		"<span class='popupCol2'><select id='ddlRegex'>" +
				"<option value=''>Other</option>" +
				"<option value='^[0-9]+$'>Numbers</option>" +
				"<option value='^[a-zA-z]+$'>Characters</option>" +
				"<option value='^[a-zA-Z0-9_]+$'>Alphanumeric characters</option>" +
			"</select></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Regular Expression</span>" +
		"<span class='popupCol2'><input type='text' id='txtRegex' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Regular Expression Message</span>" +
		"<span class='popupCol2'><textarea id='txtRegexErr'></textarea></span>" +
		"</div></div>"
	);

	$("#custom #ddlRegex").change(function() {
		that.RegexChange();
	});

	$("#custom #ddlFields").change(function() {
		that.FieldChange();
	});

	if (this._edit) {
		$("#custom #ddlFields").val(this.FieldId);
		$("#custom #txtCSS").val(this._cssClass);
		if (this.IsRequired) {
			$("#custom #chkRequired").attr("checked", "checked");
		}
		else {
			$("#custom #chkRequired").removeAttr("checked");
		}
		$("#custom #txtReqErr").val(this.RequiredErrorMessage);
		$("#custom #ddlRegex").val(this.RegularExpression);
		$("#custom #txtRegex").val(this.RegularExpression);
		if ($("#custom #ddlRegex").val() != "") {
			$("#custom #txtRegex").attr('disabled', 'disabled');
		}
		$("#custom #txtRegexErr").val(this.RegularExpressionMessage);
		$("#custom #txtPlaceholder").val(this.Placeholder);
	}
}

VP.Forms.Designer.TextAreaDesignTimeElement.prototype.UpdateProperties = function() {
	if ($("#custom #ddlFields").val() == "-1") {
		VP.Forms.Designer.TextBoxDesignTimeElement.prototype.CancelProperties.apply(this);
		return;
	}

	var previousFieldId = this.FieldId;
	this.FieldId = $("#custom #ddlFields").val();
	this.Text = $("#ddlFields :selected").text();
	this._cssClass = $("#custom input[type='text']").val();
	this.IsRequired = $("#custom #chkRequired").attr("checked");
	this.RequiredErrorMessage = $("#custom #txtReqErr").val();
	this.RegularExpression = $("#custom #txtRegex").val();
	this.RegularExpressionMessage = $("#custom #txtRegexErr").val();
	this.Placeholder = $("#custom #txtPlaceholder").val();

	var html = "<div class=\"containerControl\">" +
			"<textarea class='field' readonly='readonly'>" + this.Text + "</textarea>" +
			"</div>";

	$(this._element).find(".controlUI").empty().append(html);

	this.AddField(previousFieldId);

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
}