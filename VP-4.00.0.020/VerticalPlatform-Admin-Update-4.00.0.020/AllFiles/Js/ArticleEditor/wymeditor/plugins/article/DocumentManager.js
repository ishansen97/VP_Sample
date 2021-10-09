

WYMeditor.editor.prototype.InitDocumentManager = function(resources, disabledResourceTypes, isTemplateRefered) {
	this._documentManager = new VP.ArticleEditor.DocumentManager(this);
	this._documentManager.Initialize(resources, disabledResourceTypes, isTemplateRefered);
};

VP.ArticleEditor.DocumentManager = function(editor) {
	this._editor = editor;
	this._pluginTypes = new Object();
	this._plugins = new Object();
	this._imageBase = "../../../../../App_Themes/Default/Images/ArticleEditor/";
	this._serviceUrl = "../../Services/ArticleEditorService.asmx/";
	this._busyImage = null;
	this._resources = null;
	this.leftAlignClass = "leftAlign";
	this.rightAlignClass = "rightAlign";
	this._disabledResourceTypes = new Object();
	this._isTemplate = false;
};


VP.ArticleEditor.DocumentManager.prototype.LoadPlugins = function() {

	if (this._resources != null && this._resources.length > 0) {
		for (i = 0; i < this._resources.length; i = i + 1) {
			var pluginType = null;
			switch (this._resources[i].__type) {
				case "VerticalPlatform.Core.Web.Dto.Articles.FlashResource":
					pluginType = this._pluginTypes[VP.ArticleEditor.FlashPlugin.PluginTypeId];
					break;

			case "VerticalPlatform.Core.Web.Dto.Articles.VideoResource":
					pluginType = this._pluginTypes[VP.ArticleEditor.VideoPlugin.PluginTypeId];
					break;

				case "VerticalPlatform.Core.Web.Dto.Articles.LinkResource":
					pluginType = this._pluginTypes[VP.ArticleEditor.LinkPlugin.PluginTypeId];
					break;

				case "VerticalPlatform.Core.Web.Dto.Articles.ImageResource":
					pluginType = this._pluginTypes[VP.ArticleEditor.ImagePlugin.PluginTypeId];
					break;
				case "VerticalPlatform.Core.Web.Dto.Articles.EmbeddedCodeResource":
					pluginType = this._pluginTypes[VP.ArticleEditor.EmbeddedCodePlugin.PluginTypeId];
					break;
			}

			var plugin = Object.create(pluginType.prototype);
			plugin.InitPlugin(this._resources[i].ResourceCode, this._editor);
			plugin.Load(this._resources[i]);

			this._plugins[plugin.Resource.ResourceCode] = plugin;
		}
	}

	this.BindEvents();
};

VP.ArticleEditor.DocumentManager.prototype.Initialize = function(resources, disabledResourceTypes, isTemplateRefered) {
	with (VP.ArticleEditor) {
		this._pluginTypes[LinkPlugin.PluginTypeId] = LinkPlugin;
		this._pluginTypes[FlashPlugin.PluginTypeId] = FlashPlugin;
		this._pluginTypes[ImagePlugin.PluginTypeId] = ImagePlugin;
		this._pluginTypes[VideoPlugin.PluginTypeId] = VideoPlugin;
		this._pluginTypes[EmbeddedCodePlugin.PluginTypeId] = EmbeddedCodePlugin;
	}

	$("#PluginPropertyDialog").jqm({ modal: true });
	this._disabledResourceTypes = disabledResourceTypes;
	this._isTemplateRefered = isTemplateRefered;
	this.CreateToolButtons();
	var busyHtml = "<img id=\"busyIndicator\" src=\"" + this._imageBase + "busy.gif\" />";
	var bottom = $(".wym_area_bottom", this._editor._box);
	bottom.append(busyHtml);
	this._busyImage = $("#busyIndicator", bottom);
	this._busyImage.hide();

	this._resources = resources;
	this.LoadPlugins();
};

VP.ArticleEditor.DocumentManager.prototype.CreateToolButtons = function() {
	var toolStrip = $(this._editor._box).find(this._editor._options.toolsSelector
		+ this._editor._options.toolsListSelector);
	$(".wym_tools_link, .wym_tools_unlink", toolStrip).remove();
	$(".wym_tools_indent, .wym_tools_image , .wym_tools_outdent", toolStrip).remove();
	$(".wym_tools_indent, .wym_tools_image", toolStrip).remove();
	$(".wym_tools_preview, .wym_tools_image", toolStrip).remove();

	var that = this;
	for (var i in this._pluginTypes) {
		if (!this.IsInDisabledResourceTypes(i)) {
			var pluginType = this._pluginTypes[i];
			var html = "<li class=\"" + pluginType.ButtonClass + "\" > <a title=\"" + pluginType.PluginTypeName
			+ "\" name=\"" + pluginType.PluginTypeName + "\" /> </li>";
			toolStrip.append(html);
			var button = $("." + pluginType.ButtonClass + " a", toolStrip);
			button.data("PluginTypeId", pluginType.PluginTypeId);
			button.mousedown(function() {
				var pluginId = $(this).data("PluginTypeId");
				that.ToolButtonClick(pluginId);
			});
		}
	}
	
	this.CreateTagsToolButton(toolStrip);

	var html = "<li class=\"wym_tools_preview\" > <a title=\"Preview\" name=\"btnSectionPreview\" /> </li>";
	toolStrip.append(html);
	var sectionPreviewButton = $(".wym_tools_preview a", toolStrip);
	sectionPreviewButton.click(function() {
		that.TextSectionPreviewClick();
	});
};

VP.ArticleEditor.DocumentManager.prototype.CreateTagsToolButton = function(toolStrip)
{
	var that = this;
	var html = "<li class=\"wym_tools_tags\" > <a title=\"Custom Tags\" name=\"Custom Tags\" /> </li>";
	toolStrip.append(html);
	var button = $(".wym_tools_tags a", toolStrip);
	button.mousedown(function() {
		that.CreateTagsToolButtonClick();
	});
};

VP.ArticleEditor.DocumentManager.prototype.CreateTagsToolButtonClick = function()
{
	this._dialogPanel = $("#PluginPropertyDialogPane");
	this._dialogPanel.empty();
	var that = this;
	
	var template = $("#PluginPropertyDialogTemplates #TagsSelectorDialog").clone();
	$("#PluginPropertyDialogPane").append(template);
	
	$("#btnSaveProperties").attr('value','Add');
	$("#btnSaveProperties").unbind("click").click(function() {
		$("#PluginPropertyDialog").jqmHide();
		var selectedTag = $(".ddlTags", this._dialogPanel).val();
		that._editor.insert(selectedTag);
	});
	
	$("#btnCancelPropertes").unbind("click").click(function() {
		$("#PluginPropertyDialog").jqmHide();
	});

	$("#PluginPropertyDialogErrors").empty();
	$("#PluginPropertyDialog").jqmShow();
};

VP.ArticleEditor.DocumentManager.prototype.IsInDisabledResourceTypes = function(resourceType) {
	if (this._isTemplateRefered == true) {
		if (this._disabledResourceTypes != null && this._disabledResourceTypes.length > 0) {
			for (i = 0; i < this._disabledResourceTypes.length; i = i + 1) {
				if (this._disabledResourceTypes[i] == resourceType) {
					return true;
				}
			}
		}
	}

	return false;
};

VP.ArticleEditor.DocumentManager.prototype.Validate = function() {
	var validation = [];
	validation[0] = false;

	// Try to render text resource to find whether it has any html errors.
	this._resources = new Array();
	for (name in this._plugins) {
		var index = this._editor._wym.xhtml().indexOf("<img id=\"" + name);
		if (index > -1) {
			this._resources[this._resources.length] = this._plugins[name].Resource;
		}
	}

	var textResource = new VerticalPlatform.Core.Web.Dto.Articles.TextResource();
	textResource.Text = this._editor._wym.xhtml();
	textResource.Resources = this._resources;
	var siteId = $("input[id$='hdnSiteId']").val();
	var articleId = $("input[id$='hdnArticleId']").val();

	var that = this;
	var textResourceData = $.toJSON(textResource);
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: that._serviceUrl + "GetArticleTextSectionPreview",
		data: "{'textResource' : " + textResourceData + ", 'siteId' : '" + siteId + "', 'articleId' : '" + articleId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (msg.d.substring(0, 5) == "error") {
				validation[0] = false;
				validation[1] = msg.d.substring(6, msg.d.length)
			}
			else {
				validation[0] = true;
			}
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
		}
	});

	return validation;
};

VP.ArticleEditor.DocumentManager.prototype.TextSectionPreviewClick = function() {
	this._resources = new Array();
	for (name in this._plugins) {
		var index = this._editor._wym.xhtml().indexOf("<img id=\"" + name);
		if (index > -1) {
			this._resources[this._resources.length] = this._plugins[name].Resource;
		}
	}

	var textResource = new VerticalPlatform.Core.Web.Dto.Articles.TextResource();
	textResource.Text = this._editor._wym.xhtml();
	textResource.Resources = this._resources;
	var siteId = $("input[id$='hdnSiteId']").val();
	var articleId = $("input[id$='hdnArticleId']").val();

	var that = this;
	var textResourceData = $.toJSON(textResource);
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: that._serviceUrl + "GetArticleTextSectionPreview",
		data: "{'textResource' : " + textResourceData + ", 'siteId' : '" + siteId + "', 'articleId' : '" + articleId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (msg.d.substring(0, 5) == "error") {
				$.notify({ message: "The Text Resource has some HTML. Please correct them and save again. Error details: " 
					+ msg.d.substring(6, msg.d.length) });
			}
			else {
				that.ShowTextResourcePopupPreview(msg.d);
			}
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
		}
	});
};

VP.ArticleEditor.DocumentManager.prototype.ShowTextResourcePopupPreview = function(content) {
	var previewWindow = window.open('ArticlePreview.html', 'ArticlePreview',
				'location=0,status=1,scrollbars=1,width=600,height=400,toolbar=0,menubar=0,resizable=1');
	var htmlSource;

	previewWindow.document.write(content);
	previewWindow.document.close();
	previewWindow.focus();
	return;
};

VP.ArticleEditor.DocumentManager.prototype.ToolButtonClick = function(pluginTypeId) {
	var id = this.GetNewResourceId();

	var pluginType = this._pluginTypes[pluginTypeId];
	var plugin = Object.create(pluginType.prototype);
	plugin.InitPlugin(id, this._editor);
	
	var placeHolder = "<img id=\"" + id + "\" src=\"" + this._imageBase + plugin.PlaceholderImage
			+ "\" alt=\"" + pluginType.PluginTypeName + "\" />";
	
	if (pluginType.PluginTypeId == VP.ArticleEditor.LinkPlugin.PluginTypeId) {
		var txt = "";
		if (this._editor._doc.getSelection) {
			txt = this._editor._doc.getSelection();
		}
		else if (this._editor._doc.selection) {
			txt = this._editor._doc.selection.createRange().text;
		}

		plugin.ShowPropertyDialog(txt, placeHolder, this);
	}
	else {
		plugin.ShowPropertyDialog("", placeHolder, this);
	}

	this._plugins[plugin.Resource.ResourceCode] = plugin;
	var that = this;

	$("#" + plugin.Resource.ResourceCode, this._editor._doc.body).attr('draggable', 'true');
	this.BindEvents();
};

VP.ArticleEditor.DocumentManager.prototype.CancelButtonClick = function(event) {

};

VP.ArticleEditor.DocumentManager.prototype.GetNewResourceId = function() {
	var nextIndex = 1;
	var searching = true;
	var nextPluginId;
	while (searching) {
		nextPluginId = "plugin_" + nextIndex;
		var pluginObject = this._plugins[nextPluginId];

		if (pluginObject == null) {
			searching = false;
		}
		nextIndex = nextIndex + 1;
	}
	return nextPluginId;
};

VP.ArticleEditor.DocumentManager.prototype.BindEvents = function(param) {
	if (param == null) {
		var that = this;
		for (var i in this._plugins) {
			$("#" + this._plugins[i].Resource.ResourceCode, this._editor._doc.body).unbind("dblclick",
						this.PluginLinkClicked);
			$("#" + this._plugins[i].Resource.ResourceCode, this._editor._doc.body).unbind("dragend",
						that.BindEvents);
			$("#" + this._plugins[i].Resource.ResourceCode, this._editor._doc.body).bind("dblclick",
						{ plugin: this._plugins[i] }, this.PluginLinkClicked);
			$("#" + this._plugins[i].Resource.ResourceCode, this._editor._doc.body).bind("dragend",
						{ context: that }, that.BindEvents);
		}
	}
	else {
		var current = param.data.context;
		for (var i in current._plugins) {
			$("#" + current._plugins[i].Resource.ResourceCode, current._editor._doc.body).unbind("dblclick",
						current.PluginLinkClicked);
			$("#" + current._plugins[i].Resource.ResourceCode, current._editor._doc.body).unbind("dragend",
						current.BindEvents);
			$("#" + current._plugins[i].Resource.ResourceCode, current._editor._doc.body).bind("dblclick",
						{ plugin: current._plugins[i] }, current.PluginLinkClicked);
			$("#" + current._plugins[i].Resource.ResourceCode, current._editor._doc.body).bind("dragend",
						{ context: current }, current.BindEvents);
		}
	}
};

VP.ArticleEditor.DocumentManager.prototype.PluginLinkClicked = function(event) {
	var plugin = event.data.plugin;
	plugin.ShowPropertyDialog();
};

VP.ArticleEditor.DocumentManager.prototype.Save = function() {
	this._resources = new Array();
	var text = this._editor._wym.xhtml();
	for (name in this._plugins) {
		var index = text.indexOf("<img id=\"" + name + "\"");
		if (index > -1) {
			this._resources[this._resources.length] = this._plugins[name].Resource;
		}
	}
};

VP.ArticleEditor.DocumentManager.prototype.BeginWait = function() {
	this._busyImage.show();
};

VP.ArticleEditor.DocumentManager.prototype.EndWait = function() {
	this._busyImage.hide();
};