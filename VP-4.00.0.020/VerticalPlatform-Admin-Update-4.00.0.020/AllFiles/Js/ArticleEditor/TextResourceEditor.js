
VP.ArticleEditor.TextResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
	this._documentManager;
};

VP.ArticleEditor.TextResourceEditor.InitEditor = function(resource) {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.TextResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.TextResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	this.RemoveTextEditor();
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Text Resource");
	var html = $("#TextResourceEditorTemplate").clone();
	$(this._element).append(html);
    
	var that = this;

	var arrayAsJSONText = "[";
	var ArticleSpecificCssArray = $("input[id$='hdnArticleSpecificCssClasses']").val().split("|");
	for (var i = 0; i < ArticleSpecificCssArray.length; i++) {
		var className = ArticleSpecificCssArray[i];
		if (className != "") {
			if (arrayAsJSONText != "[") {
				arrayAsJSONText += ",";
			}
			arrayAsJSONText += '{ "name": "' + className + '", "title": "' + className + '", "css": "' + className +
				'", "expr": "p, h1, h2, h3, h4, h5, h6, div" }';
		}

	}
	arrayAsJSONText += "]";

	var classItems = eval(arrayAsJSONText);
    $(".TextResourceEditor", this._element).val(this._resource.Text);
 
	$(".TextResourceEditor", this._element).tinymce({
			// Location of TinyMCE script
			script_url : '../../js/ArticleEditor/tinymce/tiny_mce.js',

			// General options
			theme : "advanced",
			plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions," +
					"iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu," +
					"paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template," +
					"advlist,spellchecker,vpcustomtags,vpembeddedcode,vpflash,vpimage,vpvideo,vplink," +
					"vppreview,vpresourcecss,vpdiv",

			// Theme options
			theme_advanced_buttons1 : "newdocument,|,bold,italic,underline,strikethrough,|,justifyleft," +
					"justifycenter,justifyright,justifyfull,|,formatselect,fontselect,fontsizeselect",
			theme_advanced_buttons2 : "search,replace,bullist,numlist,|,undo,redo,code,tablecontrols,|," +
					"outdent,indent,spellchecker,|,sub,sup,|,fullscreen",
			theme_advanced_buttons3 : this.BuildPluginString(),
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
			theme_advanced_statusbar_location : "bottom",
			theme_advanced_resizing : true,
			fullscreen_new_window : true,

			// Example content CSS (should be your site CSS)
			content_css : this.GetArticleCssLink(),
			entity_encoding : "numeric",
			convert_urls : false,
            //spellchecker_rpc_url: "/TinyMCE.ashx?module=SpellChecker",
			browser_spellcheck: true,

			// Drop lists for link/image/media/template dialogs
			template_external_list_url : "lists/template_list.js",
			external_link_list_url : "lists/link_list.js",
			external_image_list_url : "lists/image_list.js",
			media_external_list_url : "lists/media_list.js",

			// Replace values for the template plugin
			template_replace_values : {
				username : "Some User",
				staffid : "991234"
			},
			setup : function(ed) {
				tinyMCE.extend(ed,{pluginManager:new VP.ArticleEditor.PluginManager(ed,that._resource.Resources)});
				ed.onDblClick.add(function(ed, e) {
					if ((e.target.nodeName == 'IMG') && (e.target.id.indexOf("plugin_") != -1)) {
						var alt,command;
						alt = e.target.alt;
						switch (alt) {
							case 'EmbeddedCode':
								command = 'mceVPEmbeddedCode';
								break ;
							case 'Video':
								command = 'mceVPVideo';
								break ;
							case 'Image':
								command = 'mceVPImage';
								break ;
							case 'Flash':
								command = 'mceVPFlash';
								break ;
							case 'Link':
								command = 'mceVPLink';
								break ;
							default:
								command = '';
						}
						if (command.length > 0) {
							ed.execCommand(command, false, '');
						}
					}
				});
			}
	});
};

VP.ArticleEditor.TextResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.Text = tinyMCE.activeEditor.getContent();
	this._resource.Resources = tinyMCE.activeEditor.pluginManager._resources;
};

VP.ArticleEditor.TextResourceEditor.prototype.Validate = function(isTemplate) {
	var that = this;
	var ret;

	ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	var htmlValidation = tinyMCE.activeEditor.pluginManager.Validate();
	if (htmlValidation[0] == false) {
		ret = false;
		this._errors[this._errors.length] = 
		"The Text Resource has some HTML. Please correct them and save again. Error details: " + htmlValidation[1];
	}
	
	return ret;
};

VP.ArticleEditor.TextResourceEditor.prototype.RemoveTextEditor = function() {
};

VP.ArticleEditor.TextResourceEditor.prototype.BuildPluginString = function() {
	var vpPlugins = new Array ("vpcustomtags", "vplink", "vpimage", "vpvideo", "vpflash", "vpembeddedcode",
			",vpdiv");
	var activePlugins = new Array();
	for (var i in vpPlugins) {
		if (!this.IsInDisabledResourceTypes(i)) {
			activePlugins.push(vpPlugins[i]);
		}
	}
	var vpPluginString = activePlugins.join(",") + ",vpresourcecsslist,|,vppreview";
	
	return vpPluginString;
};

VP.ArticleEditor.TextResourceEditor.prototype.GetArticleCssLink = function() {
	var articleCssLink = "";
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: VP.ArticleEditorWebServiceUrl + "/GetArticleCssLink",
			data: "{'siteId' : " + VP.SiteId +"}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				if (msg.d != null) {
					articleCssLink = msg.d;
				}
			}
		});
		
	return articleCssLink;
};

VP.ArticleEditor.TextResourceEditor.prototype.IsInDisabledResourceTypes = function(resourceType) {
	var isTemplateRefered = false;
	if (typeof (this._resource.TemplateResourceId) != "undefined") {
		isTemplateRefered = true;
	}
	if (isTemplateRefered == true) {
		if (this._resource.DisabledResourceTypes != null && this._resource.DisabledResourceTypes.length > 0) {
			for (i = 0; i < this._resource.DisabledResourceTypes.length; i = i + 1) {
				if (this._resource.DisabledResourceTypes[i] == resourceType) {
					return true;
				}
			}
		}
	}
	
	return false;
};
