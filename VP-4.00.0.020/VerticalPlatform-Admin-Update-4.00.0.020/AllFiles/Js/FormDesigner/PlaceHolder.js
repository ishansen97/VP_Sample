VP.Forms.Designer.PlaceHolderDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.Title = "PlaceHolder";
	this.FieldType = 14;
	this.FieldId = 0;
	this.Text = "";
	this.IsRequired = true;
	this.RequiredErrorMessage = "";
}

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return "<div class=\"containerControl\">" + this.Text + "</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();

	var that = this;

	var fieldsHtml = this.GetFieldsHtml();

	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div  class='popupRow'>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div>" +
		"<div  class='popupRow'>" +
		"<span class='popupCol1'>Is Required</span>" +
		"<span class='popupCol2'><input type='checkbox' id='chkRequired' checked='checked' /></span>" +
		"</div>" +
		"<div  class='popupRow'>" +
		"<span class='popupCol1'>Required Error Message</span>" +
		"<span class='popupCol2'><textarea id='txtReqErr'></textarea></span>" +
		"</div></div>"
	);

	$("#custom #ddlFields").change(function() {
		that.FieldChange();
	});

	if (this._edit) {
		$("#custom #ddlFields").val(this.FieldId);
		if (this.IsRequired) {
			$("#custom #chkRequired").attr("checked", "checked");
		}
		else {
			$("#custom #chkRequired").removeAttr("checked");
		}
		$("#custom #txtReqErr").val(this.RequiredErrorMessage);
	}
}

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
}

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype.UpdateProperties = function() {

	if ($("#custom #ddlFields").val() == "-1") {
		this.CancelProperties();
		return;
	}

	var previousFieldId = this.FieldId;

	this.FieldId = $("#custom #ddlFields").val();
	this.Text = $("#custom #ddlFields option:selected").text()
	this.IsRequired = $("#custom #chkRequired").attr("checked");
	this.RequiredErrorMessage = $("#custom #txtReqErr").val();

	var html = "<div class=\"containerControl\">" + this.Text + "</div>";

	$(this._element).find(".controlUI").empty().append(html);

	this.AddField(previousFieldId);

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
}

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.FieldText = this.Text;
	field.IsRequired = this.IsRequired;
	field.RequiredErrorMessage = this.RequiredErrorMessage;
	return field;
}

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.PlaceHolderDesignTimeElement.prototype.LoadProperties = function(data) {
	this.Text = data.FieldText;
	this.FieldId = data.Id;
	if (data.IsRequired != null) {
		this.IsRequired = data.IsRequired;
	}
	if (data.RequiredErrorMessage != null) {
		this.RequiredErrorMessage = data.RequiredErrorMessage;
	}
}