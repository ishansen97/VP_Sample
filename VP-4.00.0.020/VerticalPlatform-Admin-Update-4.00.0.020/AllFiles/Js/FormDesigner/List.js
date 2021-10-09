VP.Forms.Designer.ListDesignTimeElement = function () {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this.FieldId = 0;
	this.FieldType;
	this.IsRequired = true;
	this.RequiredErrorMessage = "";
	this.Placeholder = "";
	this.Settings = null;
	
}

VP.Forms.Designer.ListDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.ListDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		var fieldOptionsHtml = this.GetFieldOptionsHtml();

		return "<div class=\"containerControl\">" + fieldOptionsHtml + "</div>";
	}
	else {
		return "<div id='new'>...designing</div>";
	}
}

VP.Forms.Designer.ListDesignTimeElement.prototype.PreparePropertyDialog = function () {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();

	var that = this;

	var fieldsHtml = this.GetFieldsHtml();
	var settingsHtml = this.GetSettingsHtml();

	var html = "<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
		"<span class='popupCol1'>Fields</span>" +
		"<span class='popupCol2'>" + fieldsHtml + "</span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>CSS Class</span>" +
		"<span class='popupCol2'><input class='cssclass' type='text' /></span>" +
		"</div>" +
        "<div>" +
		"<span class='popupCol1'>Placeholder</span>" +
		"<span class='popupCol2'><input class='txtPlaceholder' type='text' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Is Required</span>" +
		"<span class='popupCol2'><input type='checkbox' id='chkRequired' checked='checked' /></span>" +
		"</div>" +
		"<div>" +
		"<span class='popupCol1'>Required Error Message</span>" +
		"<span class='popupCol2'><textarea id='txtReqErr'></textarea></span>" +
		"</div>" +
		"<hr>" +
		"<div style='padding-top:15px; padding-bottom:5px;font-size:1.2em;border-bottom:1px solid #EEEEEE; margin-bottom:10px;'><strong>Settings</strong></div>" +
		"<p>(Settings for predefined fields)<p>" +
		"<div style='padding-bottom:10px'><input type='button' id='btnSettings' value='Add Setting' class='btn'></input></div>" +
		"<div id='settings'>" +
		settingsHtml +
		"</div>" +
		"</div>";

	$("#custom").append(html);

	$("#custom #ddlFields").change(function () {
		that.FieldChange();
	});
	$("#custom #btnSettings").click(function () {
		$("#custom #settings").append(that.GetNewSettingsHtml());
	});
	$("#custom .settingdelete").live("click", function () {
		$(this).parent().remove();
	});

	if (this._edit) {
		$("#custom #ddlFields").val(this.FieldId);
		$("#custom .cssclass").val(this._cssClass);
		$("#custom .txtPlaceholder").val(this.Placeholder);
		if (this.IsRequired) {
			$("#custom #chkRequired").attr("checked", "checked");
		}
		else {
			$("#custom #chkRequired").removeAttr("checked");
		}
		$("#custom #txtReqErr").val(this.RequiredErrorMessage);
		
	}
}

VP.Forms.Designer.ListDesignTimeElement.prototype.GetSettingsHtml = function () {
	var settingsHtml = "";
	if (this.Settings != null) {
		var index = 0;
		for (index; index < this.Settings.length; index++) {
			settingsHtml += "<div class='settingrow'>" +
                "<span>Name : <input class='settingname' style=width:150px' type='text' value='" + this.Settings[index].Name + "'></input>&nbsp;</span>" +
                "<span>Value : <input class='settingvalue' style=width:150px' type='text' value='" + this.Settings[index].Value + "'></input>&nbsp;</span>" +
                "<a href='#' class='settingdelete deleteIcon'>&nbsp;</a>" +
                "</div>";
		}
	}

	return settingsHtml;
};

VP.Forms.Designer.ListDesignTimeElement.prototype.GetNewSettingsHtml = function() {
    var settingsHtml = "<div class='settingrow'>" +
        "<span>Name : <input class='settingname' style='width:150px' type='text'></input></span>&nbsp;" +
        "<span>Value : <input class='settingvalue' style=width:150px' type='text'></input></span>&nbsp;" +
        "<a href='#' class='settingdelete deleteIcon'>&nbsp;</a>" +
        "</div>";

    return settingsHtml;
};

VP.Forms.Designer.ListDesignTimeElement.prototype.UpdateSettings = function() {
    this.Settings = null;
    var settings = $("#custom .settingrow");
    if (settings.length > 0) {
        var index = 0;
        for (index; index < settings.length; index++) {

            var name = $(settings[index]).find(".settingname").val();
            var value = $(settings[index]).find(".settingvalue").val();
            if (name != "" && value != "") {
                var s = new VerticalPlatform.UI.Forms.Core.FormElementSetting();
                s.Name = name;
                s.Value = value;

                if (this.Settings == null) {
                    this.Settings = [];
                }

                this.Settings.push(s);
            }
        }
    }
};

VP.Forms.Designer.ListDesignTimeElement.prototype.UpdateProperties = function() {
    if ($("#custom #ddlFields").val() == "-1") {
        this.CancelProperties();
        return;
    }

    var previousFieldId = this.FieldId;
    this.FieldId = $("#custom #ddlFields").val();
    this._cssClass = $("#custom .cssclass").val();
    this.IsRequired = $("#custom #chkRequired").attr("checked");
    this.RequiredErrorMessage = $("#custom #txtReqErr").val();
    this.Placeholder = $("#custom .txtPlaceholder").val();
    this.UpdateSettings();

    var fieldOptionsHtml = this.GetFieldOptionsHtml();

    var html = "<div class=\"containerControl\">" + fieldOptionsHtml + "</div>";

    $(this._element).find(".controlUI").empty().append(html);

    this.AddField(previousFieldId);

    VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
}

VP.Forms.Designer.ListDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}
	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply(this);
}

VP.Forms.Designer.ListDesignTimeElement.prototype.GetData = function() {
    var field = new VerticalPlatform.UI.Forms.Core.Field();
    field.FieldType = this.FieldType;
    field.Id = this.FieldId;
    field.CssClass = this._cssClass;
    field.IsRequired = this.IsRequired;
    field.RequiredErrorMessage = this.RequiredErrorMessage;
    field.PlaceHolder = this.Placeholder;
    field.Settings = this.Settings;
    return field;
}

VP.Forms.Designer.ListDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}


VP.Forms.Designer.ListDesignTimeElement.prototype.LoadProperties = function(data) {
    this.FieldId = data.Id;
    if (data.CssClass != null) {
        this._cssClass = data.CssClass;
    }
    if (data.IsRequired != null) {
        this.IsRequired = data.IsRequired;
    }
    if (data.RequiredErrorMessage != null) {
        this.RequiredErrorMessage = data.RequiredErrorMessage;
    }

    if (data.PlaceHolder != null) {
        this.Placeholder = data.PlaceHolder;
    }

    this.Settings = data.Settings;
}


   