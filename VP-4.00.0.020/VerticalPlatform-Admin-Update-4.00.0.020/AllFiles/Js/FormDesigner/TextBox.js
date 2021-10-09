VP.Forms.Designer.TextBoxDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "TextBox";
	this.FieldType = 2;
	this.FieldId = 0;
	this.Text = "";
	this.MaxLength = 0;
	this.IsRequired = true;
	this.RequiredErrorMessage = "";
	this.RegularExpression = "";
	this.RegularExpressionMessage = "";
    this.Placeholder = "";
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\">" +
			"<input type='text' class='field' value='" + this.Text + "' readonly='readonly'></input>" +
			"</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();

	var that = this;

	var fieldsHtml = this.GetFieldsHtml();

	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h3></div>" +
		"<div class='content_div'><div>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div>" +
	    "<div>" +
	    "<span class='popupCol1'>Placeholder</span>" +
	    "<span class='popupCol2'><input type='text' id='txtPlaceholder' /></span>" +
	    "</div>" +
		"<div>" +
		"<span class='popupCol1'>CSS Class</span>" +
		"<span class='popupCol2'><input type='text' id='txtCSS' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Max Length</span>" +
		"<span class='popupCol2'><input type='text' id='txtLength' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Is Required</span>" +
		"<span class='popupCol2'><input type='checkbox' id='chkRequired' checked='checked' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Required Error Message</span>" +
		"<span class='popupCol2'><textarea id='txtReqErr'></textarea></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Select Expression</span>" +
		"<span class='popupCol2'><select id='ddlRegex'>" +
				"<option value=''>Other</option>" +
				"<option value='^([\\w-+]+(?:\\.[\\w-+]+)*(?:[\\+]){0,1})@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([A-Za-z]{2,6}(?:\\.[A-Za-z]{2})?)$'>Email</option>" +
				"<option value='^(((1\\-|\\+1|1|1\\.)?[ ]?(((([\\(]([0-9]{3})[\\)])|([0-9]{3}))[\\.| |\\-]{0,1}|(^[0-9]{3})[\\.|\\-| ]?)([0-9]{3})(\\.|\\-| )?([0-9]{4}))(/[0-9]{4})?[\\)]?)|(([0-9]{3}[-]){3}[0-9]{4}[ ]?[\\(]([0-9]{3}[-]){3}[0-9]{4}[\\)]))([ ]?((((( |X|X.|\\*|/|Extn|Ext|Ext.|Ex|Ex.|Ex:|Xt|Xt.|Extension|#|X\\(0\\)){1})[ ]?(([0-9]){1,7})){0,1})|[\\(]([0-9]{1,7})[\\)]))?$'>US/Canada phone numbers</option>" +
				"<option value='^[0-9]+$'>Numbers</option>" +
				"<option value='^[a-zA-z]+$'>Characters</option>" +
				"<option value='^[a-zA-Z0-9_]+$'>Alphanumeric characters</option>" +
				"<option value='.{6,}'>Text length(6)</option>" +
			"</select></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Regular Expression</span>" +
		"<span class='popupCol2'><input type='text' id='txtRegex' size='50' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Regular Expression Message</span>" +
		"<span class='popupCol2'><textarea id='txtRegexErr'></textarea></span>" +
		"</div>" +
		"<div id='errorMsg' style='color:Red'></div></div>"
	);

	$("#custom #ddlRegex").change(function() {
		that.RegexChange();
	});

	$("#custom #ddlFields").change(function() {
		that.FieldChange();
	});

	if (this._edit) {
	    $("#custom #ddlFields").val(this.FieldId);
        //PlaceHolder
	    $("#custom #txtPlaceholder").val(this.Placeholder);
        //--
		$("#custom #txtCSS").val(this._cssClass);
		$("#custom #txtLength").val(this.MaxLength);
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
	}
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.RegexChange = function() {
	var selectedRegex = $("#custom #ddlRegex").val();
	if (selectedRegex == "") {
		$("#custom #txtRegex").removeAttr('disabled').val("");
	}
	else {
		$("#custom #txtRegex").val($("#custom #ddlRegex").val()).attr('disabled', 'disabled');
	}
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.UpdateProperties = function() {

	if ($("#custom #ddlFields").val() == "-1") {
		this.CancelProperties();
		return;
	}
	if (this.Validate()) {
		var previousFieldId = this.FieldId;

		this.FieldId = $("#custom #ddlFields").val();
		this.Text = $("#ddlFields :selected").text();
		this._cssClass = $("#custom #txtCSS").val();
		this.MaxLength = $("#custom #txtLength").val();
		this.IsRequired = $("#custom #chkRequired").attr("checked");
		this.RequiredErrorMessage = $("#custom #txtReqErr").val();
		this.RegularExpression = $("#custom #txtRegex").val();
		this.RegularExpressionMessage = $("#custom #txtRegexErr").val();
        //PlaceHolder
		this.Placeholder = $("#custom #txtPlaceholder").val();
        //--

		var html = "<div class=\"containerControl\">" +
			"<input type='text' class='field' value='" + this.Text + "' readonly='readonly'></input>" +
			"</div>";

		$(this._element).find(".controlUI").empty().append(html);

		this.AddField(previousFieldId);

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply();
	}
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.FieldText = this.Text;
	field.CssClass = this._cssClass;
	field.MaxLength = this.MaxLength;
	field.IsRequired = this.IsRequired;
	field.RequiredErrorMessage = this.RequiredErrorMessage;
	field.RegularExpression = this.RegularExpression;
	field.RegularExpressionMessage = this.RegularExpressionMessage;
    field.Placeholder = this.Placeholder;
	return field;
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.LoadProperties = function(data) {
	this.Text = data.FieldText;
	this.FieldId = data.Id;
	if (data.CssClass != null) {
		this._cssClass = data.CssClass;
	}
	if (data.MaxLength != null) {
		this.MaxLength = data.MaxLength;
	}
	if (data.IsRequired != null) {
		this.IsRequired = data.IsRequired;
	}
	if (data.RequiredErrorMessage != null) {
		this.RequiredErrorMessage = data.RequiredErrorMessage;
	}
	if (data.RegularExpression != null) {
		this.RegularExpression = data.RegularExpression;
	}
	if (data.RegularExpressionMessage != null) {
		this.RegularExpressionMessage = data.RegularExpressionMessage;
	}
	if (data.PlaceHolder != null) {
	    this.Placeholder = data.PlaceHolder;
    }
}

VP.Forms.Designer.TextBoxDesignTimeElement.prototype.Validate = function() {
	var text = $("#custom #txtLength").val();
	if (text != "") {
		if (text.match(/^[0-9]+$/) == null) {
			$("#custom #errorMsg").text("Max length should be a number");
			return false;
		}
	}

	return true;
}