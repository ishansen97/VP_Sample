
VP.ArticleEditor.PluginManager = function (editor, resources) {
	this._editor = editor;
	this._pluginTypes = new Object();
	this._plugins = new Object();
	this._imageBase = "../../../../../App_Themes/Default/Images/ArticleEditor/";
	this._serviceUrl = "../../Services/ArticleEditorService.asmx/";
	this._articleServiceUrl = "";
	this._busyImage = null;
	this._resources = null;
	this.leftAlignClass = "leftAlign";
	this.rightAlignClass = "rightAlign";
	this.Initialize(resources);
};

VP.ArticleEditor.PluginManager.prototype.LoadPlugins = function () {
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
			plugin.InitPlugin(this._resources[i].ResourceCode);
			plugin.Load(this._resources[i]);
			this._plugins[plugin.Resource.ResourceCode] = plugin;
		}
	}
};

VP.ArticleEditor.PluginManager.prototype.Initialize = function (resources) {
	with (VP.ArticleEditor) {
		this._pluginTypes[LinkPlugin.PluginTypeId] = LinkPlugin;
		this._pluginTypes[FlashPlugin.PluginTypeId] = FlashPlugin;
		this._pluginTypes[ImagePlugin.PluginTypeId] = ImagePlugin;
		this._pluginTypes[VideoPlugin.PluginTypeId] = VideoPlugin;
		this._pluginTypes[EmbeddedCodePlugin.PluginTypeId] = EmbeddedCodePlugin;
	}
	this._resources = resources;
	this.LoadPlugins();
};

VP.ArticleEditor.PluginManager.prototype.Validate = function () {
	var validation = [];
	validation[0] = false;

	// Try to render text resource to find whether it has any html errors.
	this._resources = new Array();
	for (name in this._plugins) {
		var index = this._editor.getContent().indexOf("<img id=\"" + name + "\"");
		if (index > -1) {
			this._resources[this._resources.length] = this._plugins[name].Resource;
		}
	}

	var textResource = new VerticalPlatform.Core.Web.Dto.Articles.TextResource();
	textResource.Text = this._editor.getContent();
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
		success: function (msg) {
			if (msg.d.substring(0, 5) == "error") {
				validation[0] = false;
				validation[1] = msg.d.substring(6, msg.d.length)
			}
			else {
				validation[0] = true;
			}
		},
		error: function (xmlHttpRequest, textStatus, errorThrown) {
		}
	});

	return validation;
};

VP.ArticleEditor.PluginManager.prototype.TextSectionPreview = function () {
	this._resources = new Array();
	for (name in this._plugins) {
		var index = this._editor.getContent().indexOf("<img id=\"" + name + "\"");
		if (index > -1) {
			this._resources[this._resources.length] = this._plugins[name].Resource;
		}
	}

	var textResource = new VerticalPlatform.Core.Web.Dto.Articles.TextResource();
	textResource.Text = this._editor.getContent();
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

VP.ArticleEditor.PluginManager.prototype.ShowTextResourcePopupPreview = function(content) {
	var previewWindow = window.open('ArticlePreview.html', 'ArticlePreview',
				'location=0,status=1,scrollbars=1,width=600,height=400,toolbar=0,menubar=0,resizable=1');
	previewWindow.document.write(content);
	previewWindow.document.close();
	previewWindow.focus();
	return;
};

VP.ArticleEditor.PluginManager.prototype.GetPluginInstance = function (ResourceCode) {
	return this._plugins[ResourceCode];
};

VP.ArticleEditor.PluginManager.prototype.CreatePluginInstance = function (PluginTypeId) {
	var pluginType = this._pluginTypes[PluginTypeId];
	var id = this.GetNewResourceId();
	var plugin = Object.create(pluginType.prototype);
	plugin.InitPlugin(id);
	
	return plugin;
};

VP.ArticleEditor.PluginManager.prototype.SetPluginInstance = function (Plugin) {
	var imageText = this._imageBase + Plugin.PlaceholderImage;	
	if (Plugin.PluginTypeName == "Image") {
		var imageLink = this.ResolveImageLocation(Plugin.Resource.ImageName);
		if ( imageLink!= "") {
			imageText = imageLink + "\" width=\""+Plugin.Resource.Width+"\" height=\""+Plugin.Resource.Height;
		}
	}
	
	var placeHolder = "<img id=\"" + Plugin.Resource.ResourceCode + "\" src=\"" + imageText + 
	"\" alt=\"" + Plugin.PluginTypeName + "\" />";	
	this._plugins[Plugin.Resource.ResourceCode] = Plugin;
	
	return placeHolder;
};

VP.ArticleEditor.PluginManager.prototype.ResolveImageLocation = function (imageName) {
	var siteId = $("input[id$='hdnSiteId']").val();
	var imageLink = "";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: this._serviceUrl + "GetArticleImageLink",
		data: "{'siteId' : '" + siteId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (msg.d != null) {
				imageLink = msg.d + imageName;
			}
		}
	});
	
	return imageLink;
}

VP.ArticleEditor.PluginManager.prototype.GetNewResourceId = function () {
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

VP.ArticleEditor.PluginManager.prototype.Save = function () {
	this._resources = new Array();
	var text = this._editor.getContent();
	for (name in this._plugins) {
		var index = text.indexOf("<img id=\"" + name + "\"");
		if (index > -1) {
			this._resources[this._resources.length] = this._plugins[name].Resource;
		}
	}
};

VP.ArticleEditor.PluginManager.prototype.GetCssClasses = function () {
	var cssClasses = [];
	var cssClasses = $("input[id$='hdnArticleSpecificCssClasses']").val().split('|');
	return cssClasses;
};