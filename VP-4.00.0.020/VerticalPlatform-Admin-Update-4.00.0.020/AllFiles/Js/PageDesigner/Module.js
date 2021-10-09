VP.Pages.Designer.ModuleDesignTimeElement = function(moduleId, moduleText, moduleName) {
	VP.Pages.Designer.DesignTimeElement.apply(this);
	this._type = 'Module';
	this._moduleInstanceId = 0;
	this._moduleId = moduleId;
	this._title = '';
	this._titleLinkUrl = '';
	this._customCssClass = '';
	this._pane = '';
	this._commonModule = false;
	this._sortOrder = 0;
	this._enabled = true;
	this._parentModuleInstanceId = null;
	this._moduleName = moduleName;
	this._moduleText = moduleText;
	this._moduleSettingsAvailable = false;
	this._commonModuleDeleted = false;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype = Object.create(VP.Pages.Designer.DesignTimeElement.prototype);

VP.Pages.Designer.ModuleDesignTimeElement.prototype.CreateUI = function() {
	if (this._edit) {
		return this.GetDisplayUI();
	}
	else {
		return "<div id='new'>...designing</div>";
	}
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.CreateEditMenu = function() {
	if (!VP.Pages.Designer.PageId) {
		var deleteId = this._controlId + "_delete";
		var editId = this._controlId + "_edit";
		var html = "<a class=\"deleteIcon\" id=\"" + deleteId + "\" title=\"Delete\" >&nbsp;</a>" +
			"<a class=\"editIcon\" id=\"" + editId + "\" title=\"Edit\">&nbsp;</a>";

		return html;
	}
	else if (this._commonModule) {
		var upId = this._controlId + "_up";
		var downId = this._controlId + "_down";
		var html = "<a class=\"upIcon\" id=\"" + upId + "\" title=\"Move Up\">&nbsp;</a>" +
			"<a class=\"downIcon\" id=\"" + downId + "\" title=\"Move Down\">&nbsp;</a>";

		return html;
	}
	else {
		return VP.Forms.Designer.DesignTimeElement.prototype.CreateEditMenu.apply(this);
	}
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.Create = function(parent, element, controlId) {
	VP.Forms.Designer.DesignTimeElement.prototype.Create.apply(this, arguments);

	this.SetDisableEventHandler();
	this.SetSettingsEventHandler();
	this.SetCommonDeleteEventHandler();

	if (this._commonModule) {
		$(this._element).addClass("siteModule " + this._moduleName);
	}
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.SetSettingsEventHandler = function() {
	$("#" + this._controlId + "_setting").click(function(event) {
		event.preventDefault();
		var random = Math.floor(Math.random() * 1000000);
		$.popupDialog.openDialog($(this).attr('href') + "&rand=" + random);
	});
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.SetDisableEventHandler = function() {
	if (!VP.Pages.Designer.PageId || !this._commonModule) {
		var that = this;
		$("#" + this._controlId + "_enable").click(function() {
			if ($(this).attr('title') === 'Disable') {
				that.Disable();
			}
			else {
				that._enabled = true;
				$(this).attr('class', 'enableIcon').attr('title', 'Disable');
			}
		});
	}
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.SetCommonDeleteEventHandler = function() {
	var that = this;
	$("#" + this._controlId + "_commonDelete").click(function() {
	if ($(this).attr('class') === 'commonAddIcon') {
			that._commonModuleDeleted = false;
			$(this).attr('class', 'commonDeleteIcon').attr('title', 'Delete site common module from page');
		}
		else {
			that._commonModuleDeleted = true;
			$(this).attr('class', 'commonAddIcon').attr('title', 'Add site common module to page');
		}
	});
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.GetDisplayUI = function() {

	var html = "";
	var enableButtonHtml = this.GetEnableButtonHtml();
	var settingButtonHtml = this.GetSettingButtonHtml();

	if (!VP.Pages.Designer.PageId) {
		html = "<div class=\"containerControl commonModule clearfix\">" +
			"<div class='module_name'><strong>" + this._title + "</strong> (" + this._moduleText + ")" +
			", order:" + this._sortOrder + "</div>" + enableButtonHtml + settingButtonHtml + "</div>";
	}
	else if (this._commonModule) {
		var commonDeleteHtml = this.GetDeleteButtonHtml();
		html = "<div class=\"containerControl commonModule clearfix\">" +
			"<div class='module_name'><strong>" + this._title + "</strong> (" + this._moduleText + ")" +
			"</div>" + enableButtonHtml + commonDeleteHtml + "</div>";
	}
	else {
		html = "<div class=\"containerControl clearfix\">" +
			"<div class='module_name'><strong>" + this._title + "</strong> (" + this._moduleText + ")</div>" +
			enableButtonHtml +
			settingButtonHtml +
			"</div>";
	}

	return html;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.GetEnableButtonHtml = function() {
	var enableButtonHtml = "";
	var enableId = this._controlId + "_enable";
	if (this._enabled) {
		if (VP.Pages.Designer.PageId && this._commonModule) {
			enableButtonHtml = "<a class=\"enableIcon disable\" id=\"" + enableId + "\" title=\"Enable\" >&nbsp;</a>";
		}
		else {
			enableButtonHtml = "<a class=\"enableIcon\" id=\"" + enableId + "\" title=\"Disable\" >&nbsp;</a>";
		}
	}
	else {
		if (VP.Pages.Designer.PageId && this._commonModule) {
			enableButtonHtml = "<a class=\"disableIcon disable\" id=\"" + enableId + "\" title=\"Disable\" >&nbsp;</a>";
		}
		else {
			enableButtonHtml = "<a class=\"disableIcon\" id=\"" + enableId + "\" title=\"Enable\" >&nbsp;</a>";
		}
	}
	
	return enableButtonHtml;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.GetDeleteButtonHtml = function() {
	var commonDeleteButtonHtml = "";
	var commonDeleteId = this._controlId + "_commonDelete";
	if (this._commonModuleDeleted) {
		commonDeleteButtonHtml = "<a class=\"commonAddIcon\" id=\"" + commonDeleteId + "\" title=\"Add site common module to page\" >&nbsp;</a>";
	}
	else {
		commonDeleteButtonHtml = "<a class=\"commonDeleteIcon\" id=\"" + commonDeleteId + "\" title=\"Delete site common module from page\" >&nbsp;</a>";
	}
	
	return commonDeleteButtonHtml;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.GetSettingButtonHtml = function() {
	var settingButtonHtml = "";
	var settingId = this._controlId + "_setting";
	if ((!this._commonModule || !VP.Pages.Designer.PageId) && this._moduleInstanceId > 0 && this._moduleSettingsAvailable) {
		var url = VP.ApplicationRoot + "DialogHost.aspx?pconid=21&mn=" + this._moduleName.replace(/ /g, "") + "&minsid=" + this._moduleInstanceId + 
				"&pid=" + VP.Pages.Designer.PageId;
		settingButtonHtml = "<a class=\"settingsIcon\" id=\"" + settingId + "\" title=\"Settings\" href=\"" + url + "\" >&nbsp;</a>";
	}

	return settingButtonHtml;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);

	var html = "<div id='module' class='dialog_header  clearfix'><h2></h2></div>" +
		"<div class='model_form_raw clearfix'><span class='label'>Title</span><span><input id='title' type='text' value='" + this._title + "' /></span></div>" +
		"<div class='model_form_raw clearfix'><span class='label'>Title Link Url</span><span><input id='titleurl' type='text' value='" + this._titleLinkUrl + "' /></span></div>" +
		"<div class='model_form_raw clearfix'><span class='label'>Custom Css Class</span><span><input id='css' type='text' value='" + this._customCssClass + "' /></span></div>" +
		"<div class='model_form_raw clearfix'><span class='label'>Enabled</span><span><input id='enabled' type='checkbox' /></span></div>";

	if (!VP.Pages.Designer.PageId) {
		html += "<div class='model_form_raw clearfix'><span class='label'>Sort order</span><span><input id='sortorder' type='text' value='" + this._sortOrder.toString() + "' /><span class='error' id='sortordererror' style='display:none'>*</span></span></div>";
	}

	$("#custom").empty().append(html);

	if (this._enabled) {
		$("#custom #enabled").attr('checked', 'checked');
	}

	$("#custom #module h2").text(this._moduleText + " Module");
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.CancelProperties = function() {
	var item = $(this._element).find("#new");
	if (item.length > 0) {
		this._parent.DeleteChild(this._controlId);
	}

	VP.Forms.Designer.DesignTimeElement.prototype.CancelProperties.apply();
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.LoadProperties = function(data) {
	this._moduleInstanceId = data.ModuleInstanceId;
	this._moduleId = data.ModuleId;
	this._title = data.Title;
	this._titleLinkUrl = data.TitleLinkUrl;
	this._customCssClass = data.CustomCssClass;
	this._pane = data.Pane;
	this._commonModule = data.CommonModule;
	this._enabled = data.Enabled;
	this._sortOrder = data.SortOrder;
	this._moduleName = data.ModuleText;
	this._moduleText = data.ModuleText;
	this._moduleSettingsAvailable = data.ModuleSettingsAvailable;
	this._commonModuleDeleted = data.CommonModuleDeleted;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.UpdateProperties = function() {
	if (this.Validate()) {
		this._title = $("#custom #title").val();
		this._titleLinkUrl = $("#custom #titleurl").val();
		this._customCssClass = $("#custom #css").val();
		this._enabled = $("#custom #enabled").attr('checked');

		if (!VP.Pages.Designer.PageId) {
			this._sortOrder = parseInt($("#custom #sortorder").val(), 10);
		}

		var created = false;
		if (this._moduleInstanceId === 0) {
			var moduleInstance = this.GetModuleInstanceData();
			if (VP.Pages.Designer.PageId) {
				moduleInstance.SortOrder = this._parent._controlCount;
			}
			moduleInstance = VP.Pages.Designer.ModuleDesignTimeElement.SaveModuleInstance(moduleInstance,
					this._moduleText);
			if (moduleInstance) {
				this._moduleInstanceId = moduleInstance.ModuleInstanceId;
				this._moduleSettingsAvailable = moduleInstance.ModuleSettingsAvailable;
				created = true;
			}
		}

		$(this._element).find(".controlUI").empty().append(this.GetDisplayUI());

		if (created && !VP.Pages.Designer.PageId) {
			$(this._element).addClass("siteModule " + this._moduleName);
		}

		this.SetSettingsEventHandler();
		this.SetDisableEventHandler();
		this.SetCommonDeleteEventHandler();

		VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply();
	}
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.Validate = function() {
	var isValid = true;
	if (!VP.Pages.Designer.PageId) {
		var sortOrder = $("#custom #sortorder").val();
		if (sortOrder == "") {
			$("#custom #sortordererror").show();
			isValid = false;
			$.notify({ message: 'Please enter sort order.', type: 'error' });
		}
		else {
			if (isNaN(sortOrder)) {
				$("#custom #sortordererror").show();
				isValid = false;
				$.notify({ message: 'Please enter a positive integer for sort order.', type: 'error' });
			}
			else {
				var order = parseInt(sortOrder, 10);
				if (order < 0) {
					$("#custom #sortordererror").show();
					isValid = false;
					$.notify({ message: 'Please enter a positive integer for sort order.', type: 'error' });
				}
				else {
					$("#custom #sortordererror").hide();
				}
			}
		}
	}

	return isValid;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.GetData = function() {
	var moduleInstance = this.GetModuleInstanceData();

	return moduleInstance;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.GetModuleInstanceData = function() {
	var moduleInstance = new VerticalPlatform.Core.Services.UIModuleInstance();
	moduleInstance.ModuleInstanceId = this._moduleInstanceId;
	moduleInstance.ModuleId = this._moduleId;
	moduleInstance.Title = this._title;
	moduleInstance.TitleLinkUrl = this._titleLinkUrl;
	moduleInstance.CustomCssClass = this._customCssClass;
	if (!VP.Pages.Designer.PageId) {
		this._commonModule = true;
	}
	moduleInstance.CommonModule = this._commonModule;
	moduleInstance.Enabled = this._enabled;
	moduleInstance.Pane = this.GetPane();
	moduleInstance.SortOrder = this._sortOrder;
	moduleInstance.ModuleSettingsAvailable = this._moduleSettingsAvailable;
	moduleInstance.CommonModuleDeleted = this._commonModuleDeleted;

	if (this._parent._type !== 'Pane') {
		moduleInstance.ParentModuleInstanceId = this._parent._moduleInstanceId;
	}

	moduleInstance.Children = [];
	return moduleInstance;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.GetPane = function() {
	var parent = this._parent;
	while (parent !== null && parent._type !== 'Pane') {
		parent = parent._parent;
	}

	var pane = "";
	if (parent) {
		pane = parent._subType;
	}

	return pane;
};

VP.Pages.Designer.ModuleDesignTimeElement.SaveModuleInstance = function(moduleInstance, moduleText) {
	var jsonModuleInstance = $.toJSON(moduleInstance);
	var savedModuleInstance = null;
	var webserviceUrl = VP.ApplicationRoot + "Services/PageDesignerService.asmx/SaveModuleInstance";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webserviceUrl,
		data: "{'uiModuleInstance':" + jsonModuleInstance + ",'siteId':" + VP.SiteId + ",'pageId':" + VP.Pages.Designer.PageId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			savedModuleInstance = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			document.location("../../Error.aspx");
		}
	});

	var errorMessage = moduleText + " instance ";
	if (moduleInstance.Title != "") {
		errorMessage += "'" + moduleInstance.Title + "' ";
	}
	
	if (savedModuleInstance != null) {

		$.notify({ message: errorMessage + " saved.", type: "ok" });
	}
	else {
		$.notify({ message: errorMessage + " save failed.", type: "error" });
	}

	return savedModuleInstance;
};

VP.Pages.Designer.ModuleDesignTimeElement.prototype.Disable = function() {
	this._enabled = false;
	$("#" + this._controlId + "_enable").attr('class', 'disableIcon').attr('title', 'Enable');
};
