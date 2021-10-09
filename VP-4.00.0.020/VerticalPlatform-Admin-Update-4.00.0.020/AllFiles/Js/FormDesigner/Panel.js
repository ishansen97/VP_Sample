VP.Forms.Designer.PanelDesignTimeElement = function() {
	VP.Forms.Designer.ContainerDesignTimeElement.apply(this);
	this.Title = "Panel";
	this.Align = "vertical";
	this.Columns = 1;
	this.FieldType = 10;
	this.Collapsible = false;
	this.LoggedIn = false;
}

VP.Forms.Designer.PanelDesignTimeElement.prototype = Object.create(VP.Forms.Designer.ContainerDesignTimeElement.prototype);

VP.Forms.Designer.PanelDesignTimeElement.prototype.CreateUI = function() {
	var html;
	if (this._edit) {
		html = "<div class=\"controlContainer panel\"></div>";
	}
	else {
		html = "<div class=\"controlContainer panel\"><span class=\"tempPlaceholder\">Drop controls here...</span></div>";
	}
	return html;
}

VP.Forms.Designer.PanelDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();
	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
		"<div class='content_div'><div class='popupRow'>" +
			"<span class='popupCol1'>Align</span>" +
			"<span class='popupCol2'>" +
			"<select id='align'><option value='1'>Vertical</option><option value='0'>Horizontal</option></select>" +
			"</span>" +
			"</div>" +
			"<div class='popupRow'>" +
			"<span class='popupCol1'>Columns</span>" +
			"<span class='popupCol2'><select id='columns'><option value='1'>Single</option><option value='2'>Two</option></select></span>" +
			"</div>" +
			"<div class='popupRow'>" +
			"<span class='popupCol1'>CSS Class</span>" +
			"<span class='popupCol2'><input type='text' /></span>" +
			"</div>" +
			"<div class='popupRow'>" +
			"<span class='popupCol1'>Collapsible</span>" +
			"<span class='popupCol2'><input type='checkbox' id='chkCollapsible' /></span>" +
			"</div>" +
			"<div class='popupRow'>" +
			"<span class='popupCol1'>Logged In</span>" +
			"<span class='popupCol2'><input type='checkbox' id='chkLoggedIn' /></span>" +
			"</div></div>");

	if (this.Align.match("horizontal") == "horizontal") {
		$("#custom #align").val('0');
	}
	else {
		$("#custom #align").val('1');
	}

	$("#custom #columns").val(this.Columns);
	$("#custom input[type='text']").val(this._cssClass);

	if (this.Collapsible) {
		$("#custom #chkCollapsible").attr('checked', 'checked');
	}
	if (this.LoggedIn) {
		$("#custom #chkLoggedIn").attr('checked', 'checked');
	}
}

VP.Forms.Designer.PanelDesignTimeElement.prototype.UpdateProperties = function() {
	var value = $("#custom #align").val();
	if (value == 1) {
		this.Align = "vertical";
		$(this._element).find(".controlDesigner").removeClass('horizontal');
	}
	else {
		this.Align = "horizontal";
		$(this._element).find(".controlDesigner").addClass('horizontal');
	}

	this.Columns = $("#custom #columns").val();
	this._cssClass = $("#custom input[type='text']").val();
	this.Collapsible = $("#custom #chkCollapsible").attr('checked');
	this.LoggedIn = $("#custom #chkLoggedIn").attr('checked');

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
}

VP.Forms.Designer.PanelDesignTimeElement.prototype.ControlAdded = function(designer) {
	$(this._containerElement).find(".tempPlaceholder").remove();
}

VP.Forms.Designer.PanelDesignTimeElement.prototype.ControlDeleted = function() {
	if (this._controlCount == 0) {
		$(this._containerElement).empty().append("<span class=\"tempPlaceholder\">Drop controls here...</span>");
	}
}

VP.Forms.Designer.PanelDesignTimeElement.prototype.GetData = function() {
	var panel = new VerticalPlatform.UI.Forms.Core.Panel();
	panel.FieldType = this.FieldType;
	panel.Children = new Array();
	panel.Align = this.Align;
	panel.Columns = this.Columns;
	panel.CssClass = this._cssClass;
	panel.Collapsible = this.Collapsible;
	panel.LoggedIn = this.LoggedIn;
	var index = 0;
	for (var i in this._children) {
		panel.Children[index] = this._children[i].GetData();
		index++;
	}

	return panel;
}

VP.Forms.Designer.PanelDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.PanelDesignTimeElement.prototype.LoadProperties = function(data) {
	if (data.Align != null) {
		this.Align = data.Align;
	}
	if (data.Columns != null) {
		this.Columns = data.Columns;
	}
	if (data.CssClass != null) {
		this._cssClass = data.CssClass;
	}
	this.Collapsible = data.Collapsible;
	if (data.LoggedIn != null) {
		this.LoggedIn = data.LoggedIn;
	}
}