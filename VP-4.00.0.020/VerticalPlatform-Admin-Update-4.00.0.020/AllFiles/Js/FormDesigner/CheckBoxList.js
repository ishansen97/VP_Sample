VP.Forms.Designer.CheckBoxListDesignTimeElement = function() {
	VP.Forms.Designer.ListDesignTimeElement.apply(this);
	this.Title = "CheckBoxList";
	this.FieldType = 3;
	this.Columns = 1;
};

VP.Forms.Designer.CheckBoxListDesignTimeElement.prototype = Object.create(VP.Forms.Designer.ListDesignTimeElement.prototype);

VP.Forms.Designer.CheckBoxListDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();

	var that = this;

	var fieldsHtml = this.GetFieldsHtml();

	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Columns</span>" +
		"<span class='popupCol2'><select id='columns'><option value='1'>One</option><option value='2'>Two</option><option value='3'>" +
		"Three</option><option value='4'>Four</option><option value='5'>Five</option><option value='6'>Six</option></select></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Is Required</span>" +
		"<span class='popupCol2'><input type='checkbox' id='chkRequired' checked='checked' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Required Error Message</span>" +
		"<span class='popupCol2'><textarea id='txtReqErr'></textarea></span>" +
		"</div></div>");

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

	$("#custom #columns").val(this.Columns);
};

VP.Forms.Designer.CheckBoxListDesignTimeElement.prototype.UpdateProperties = function() {
	if ($("#custom #ddlFields").val() == "-1") {
		this.CancelProperties();
		return;
	}

	var previousFieldId = this.FieldId;
	this.FieldId = $("#custom #ddlFields").val();
	this.Columns = $("#custom #columns").val();
	this.IsRequired = $("#custom #chkRequired").attr("checked");
	this.RequiredErrorMessage = $("#custom #txtReqErr").val();

	var fieldOptionsHtml = this.GetFieldOptionsHtml();

	var html = "<div class=\"containerControl\">" + fieldOptionsHtml + "</div>";

	$(this._element).find(".controlUI").empty().append(html);

	this.AddField(previousFieldId);

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
};

VP.Forms.Designer.CheckBoxListDesignTimeElement.prototype.GetData = function() {
	var field = new VerticalPlatform.UI.Forms.Core.Field();
	field.FieldType = this.FieldType;
	field.Id = this.FieldId;
	field.Columns = this.Columns;
	field.IsRequired = this.IsRequired;
	field.RequiredErrorMessage = this.RequiredErrorMessage;
	return field;
};

VP.Forms.Designer.CheckBoxListDesignTimeElement.prototype.LoadProperties = function(data) {
	this.FieldId = data.Id;
	if (data.Columns != null) {
		this.Columns = data.Columns;
	}
	if (data.IsRequired != null) {
		this.IsRequired = data.IsRequired;
	}
	if (data.RequiredErrorMessage != null) {
		this.RequiredErrorMessage = data.RequiredErrorMessage;
	}
};
