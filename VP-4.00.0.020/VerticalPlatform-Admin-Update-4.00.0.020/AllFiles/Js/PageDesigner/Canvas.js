VP.Pages.Designer.Canvas = function() {
	this._pageDesigner = null;
	this._deletedModuleInstances = [];
	this._moduleList = [];
};

VP.Pages.Designer.Canvas.prototype.Initialize = function() {
	$(".controlDesigner").live("mouseover", function() {
		$(".editMenu", this).addClass("editMenuHover");
		$(".controlContainer", this).addClass("controlContainerHover");
		$(this).addClass("controlDesignerHover");
	});
	$(".controlDesigner").live("mouseout", function() {
		$(".editMenu", this).removeClass("editMenuHover");
		$(".controlContainer", this).removeClass("controlContainerHover");
		$(this).removeClass("controlDesignerHover");
	});
	$(".toolboxItems").accordion({
		autoHeight: false
	});

	this.GetModules();

};

VP.Pages.Designer.Canvas.prototype.Load = function() {
	var modules = null;
	$("#canvas").empty();
	var webserviceUrl = VP.ApplicationRoot + "Services/PageDesignerService.asmx/GetPageModules";

	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webserviceUrl,
		data: "{'siteId':" + VP.SiteId + ",'pageId':" + VP.Pages.Designer.PageId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			modules = msg.d;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});

	var designer = new VP.Pages.Designer.TemplateDesignTimeElement();
	designer._templateType = VP.Pages.Designer.TemplateType;
	designer.Load(modules, null, $("#canvas"));
	this._formDesigner = designer;
};

VP.Pages.Designer.Canvas.prototype.GetDesignTimeElement = function(module) {
	if (module.IsContainer) {
		return new VP.Pages.Designer.ContainerModuleDesignTimeElement();
	}
	else {
		return new VP.Pages.Designer.ModuleDesignTimeElement();
	}
};

VP.Pages.Designer.Canvas.prototype.Save = function() {
	var successfull = false;
	var message = "";
	var webserviceUrl = VP.ApplicationRoot + "Services/PageDesignerService.asmx/SavePageModuleInstances";
	if (this._formDesigner !== null) {
		if (this.Validate()) {
			var modules = this._formDesigner.GetData();
			var moduleData = $.toJSON(modules);
			var deletedModuleInstances = $.toJSON(this._deletedModuleInstances);
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: webserviceUrl,
				data: "{'moduleInstances' : " + moduleData + ",'deletedModuleInstances':" +
						deletedModuleInstances + ", 'pageId' : " + VP.Pages.Designer.PageId +
						", 'siteId' : " + VP.SiteId + "}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(msg) {
					successfull = true;
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					if (XMLHttpRequest.responseText) {
						if (XMLHttpRequest.responseText.indexOf("VerticalPlatform.Core.Data.ConstraintException") > 0) {
							message = "Common containers cannot be deleted because it has page level children.";
						}
					}
				}
			});
		}
	}

	if (successfull) {
		$.notify({ message: 'Page design saved.', type: 'ok' });
	}
	else {
		var errorMessage = "Page design save failed.";
		if (message.length > 0) {
			errorMessage += " " + message;
		}
		$.notify({ message: errorMessage, type: 'error' });
	}

	this.Load();
	this._deletedModuleInstances = [];
};

VP.Pages.Designer.Canvas.prototype.Validate = function() {
	return true;
};

VP.Pages.Designer.Canvas.prototype.GetModules = function() {
	var moduleList = null;
	var webserviceUrl = VP.ApplicationRoot + "Services/PageDesignerService.asmx/GetModules";
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: webserviceUrl,
			data: "{}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				moduleList = msg.d;
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				document.location("../../Error.aspx");
			}
		});

	this._moduleList = moduleList;
};