VP.Scripting.Plugins = null;

// Global variables that are populated by the server side.
var contentId = 0;
// Campaign type id is used to get the groups.
var campaignTypeId = 0;
var contentTypeId = 0;
var emailTemplateId = 0;
var editable = false;

VP.Scripting.Context = null;

VP.Scripting.ScriptManager = function() {
	VP.Scripting.Plugins = [{ 'name': 'Content Item', 'title': 'Render Content Item', 'css': 'wym_tools_iteration', 'plugin': VP.Scripting.GroupSnippet, 'language': 'Ruby'}];

	this._editor = null;
	this._busyImage = null;
	this._campaingContent = null;

	var that = this;

	$("select[id$='ddlPane']").change(function() {
		var isPrompted = false;
		var campaignContent = that.GetEditorText();
		if (campaignContent != null && typeof (campaignContent) != 'undefined') {
			campaignContent = unescape(campaignContent).replace(/[\n\r\t]/g, '');
			var orginal = that._campaingContent.Content.replace(/[\n\r\t]/g, '');

			if (editable && campaignContent != orginal) {
				$.prompt('Do you want to save and continue?',
						{ callback: function(v, m, f) { that.PromptCallBack(v); }, buttons: { Yes: true, No: false} }
					);
				isPrompted = true;
			}
		}

		if (!isPrompted) {
			if ($("option[selected]", this).val() != '') {
				that.Load();
				that.UnlockButtons();
			}
			else {
				that.RemoveEditor("<h4 class='content_editor_message'>Please select template pane.</h4>");
				that.LockButtons();
			}
		}
	});

	if (editable) {
		$('#btnSave').click(function() {
			that.SaveCampaingContent();
		});
	}
	else {
		this.LockButtons();
	}
};

VP.Scripting.ScriptManager.prototype.PromptCallBack = function(value) {
	if (value) {
		this.SaveCampaingContent();
	}

	if ($("option[selected]", "select[id$='ddlPane']").val() != '') {
		this.Load();
		this.UnlockButtons();
	}
	else {
		this.RemoveEditor("<h4 class='content_editor_message'>Please select template pane.</h4>");
		this.LockButtons();
	}
};


VP.Scripting.ScriptManager.prototype.LockButtons = function() {
	$('#btnSave').attr('disabled', 'disabled');
};

VP.Scripting.ScriptManager.prototype.UnlockButtons = function() {
	$('#btnSave').removeAttr('disabled');
};

VP.Scripting.ScriptManager.prototype.SaveCampaingContent = function() {
	if (editable) {
		var campaignContent = this.GetEditorText();
		this._campaingContent.Content = unescape(campaignContent);
		var that = this;
		var contentData = $.toJSON(this._campaingContent);
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: VP.ApplicationRoot + "Services/BulkEmailWebService.asmx/SaveCampaignPaneContent",
			data: "{'content' : " + contentData + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				$.notify({ message: "Campaign type template pane content saved.", type: 'ok' });
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
				$.notify({ message: "Campaign type template pane content save failed." });
			}
		});
	}
};

VP.Scripting.ScriptManager.prototype.GetEditorText = function() {
	var campaignContent;
	if (WYMeditor.INSTANCES.length > 0) {
		campaignContent = VP.Scripting.Context._editor._wym.xhtml();
	}
	else {
		campaignContent = $("textarea.wymCampaignContentPaneEditor", "#CampaignContentEditorTemplate").val();
	}

	return campaignContent;
};


VP.Scripting.ScriptManager.prototype.Load = function(element) {
	var that = this;
	this.ResetEditor();
	this.LoadContentPane();
	var content = "";
	if (that._campaingContent) {
		content = that._campaingContent.Content;
	}
	var textArea = $("textarea.wymCampaignContentPaneEditor", "#CampaignContentEditorTemplate");
	if (textArea.length > 0) {
		textArea.val(content);
	}
};
VP.Scripting.ScriptManager.prototype.ResetEditor = function() {
	var that = this;
	this.RemoveEditor('');
	$("#CampaignContentEditorTemplate").append("<input type='checkbox' id='chkHtmlView'>Rich editor view</input><br/><textarea class='wymCampaignContentPaneEditor' rows='20' cols='50'></textarea>");
	$("#chkHtmlView", "#CampaignContentEditorTemplate").click(function() {
		that.ToggleHtmlView();
	});
};

VP.Scripting.ScriptManager.prototype.RemoveEditor = function(html) {
	var that = this;
	delete WYMeditor.INSTANCES[0];
	WYMeditor.INSTANCES = [];
	$("#CampaignContentEditorTemplate").empty().html(html);
};

VP.Scripting.ScriptManager.prototype.ToggleHtmlView = function() {
	var that = this;

	if (WYMeditor.INSTANCES.length > 0) {
		var text = this._editor._wym.xhtml();
		delete WYMeditor.INSTANCES[0];
		WYMeditor.INSTANCES = [];

		$("textarea.wymCampaignContentPaneEditor", "#CampaignContentEditorTemplate").remove();
		$(".wym_box", "#CampaignContentEditorTemplate").hide();
		$("#CampaignContentEditorTemplate").append("<textarea class='wymCampaignContentPaneEditor' rows='20' cols='50'></textarea>");
		
		var textArea = $("textarea.wymCampaignContentPaneEditor", "#CampaignContentEditorTemplate");
		textArea.next().remove();
		textArea.val(text);
		textArea.show();
	}
	else {
		var textArea = $("textarea.wymCampaignContentPaneEditor", "#CampaignContentEditorTemplate");
		
		$("textarea.wymCampaignContentPaneEditor").wymeditor({
			postInit: function(wym) {
				that._editor = wym;
				that.Initialize();
			},
			html: textArea.val(),
			containersItems: [
			{ 'name': 'P', 'title': 'Paragraph', 'css': 'wym_containers_p' },
			{ 'name': 'H1', 'title': 'Heading_1', 'css': 'wym_containers_h1' },
			{ 'name': 'H2', 'title': 'Heading_2', 'css': 'wym_containers_h2' },
			{ 'name': 'H3', 'title': 'Heading_3', 'css': 'wym_containers_h3' },
			{ 'name': 'H4', 'title': 'Heading_4', 'css': 'wym_containers_h4' },
			{ 'name': 'H5', 'title': 'Heading_5', 'css': 'wym_containers_h5' },
			{ 'name': 'H6', 'title': 'Heading_6', 'css': 'wym_containers_h6' },
			{ 'name': 'PRE', 'title': 'Preformatted', 'css': 'wym_containers_pre' },
			{ 'name': 'BLOCKQUOTE', 'title': 'Blockquote', 'css': 'wym_containers_blockquote' },
			{ 'name': 'TH', 'title': 'Table_Header', 'css': 'wym_containers_th' },
			{ 'name': 'DIV', 'title': 'Div', 'css': 'wym_containers_div' }
			],
			toolsItems: [{ 'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'}]
		});
	}
};

VP.Scripting.ScriptManager.prototype.Initialize = function(element) {
	$("#propertyDialog").jqm(
	{
		modal: true
	});

	VP.Scripting.Context = new VP.Scripting.ScriptingContext(campaignTypeId, contentId);
	VP.Scripting.Context._editor = this._editor;

	this.CreateToolButtons();
	var busyHtml = "<img id=\"busyIndicator\" src=\"" + this._imageBase + "busy.gif\" />";
	var bottom = $(".wym_area_bottom", this._editor._box);
	bottom.append(busyHtml);
	this._busyImage = $("#busyIndicator", bottom);
	this._busyImage.hide();
};

VP.Scripting.ScriptManager.prototype.LoadContentPane = function() {
	var that = this;
	var campaignPane = $("select[id$='ddlPane']").val();
	var serviceUrl = VP.ApplicationRoot + "Services/BulkEmailWebService.asmx/GetTemplatePaneContent";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: serviceUrl,
		data: "{'contentTypeId' : " + contentTypeId + ",'contentId' : " + contentId +
			", 'emailTemplateId' : " + emailTemplateId + ", 'pane' : '" + campaignPane + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (msg.d) {
				that._campaingContent = msg.d;
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var error = XMLHttpRequest;
		}
	});
};

VP.Scripting.ScriptManager.prototype.CreateToolButtons = function() {
	var toolStrip = $(this._editor._box).find(this._editor._options.toolsSelector
		+ this._editor._options.toolsListSelector);
	$(".wym_tools_undo", toolStrip).remove();

	var that = this;
	for (var i = 0; i < VP.Scripting.Plugins.length; i++) {
		var plugin = VP.Scripting.Plugins[i].plugin;
		var language = VP.Scripting.Plugins[i].language;
		var name = VP.Scripting.Plugins[i].name;
		var html = "<li class=\"" + VP.Scripting.Plugins[i].css + "\" > <a title=\"" + VP.Scripting.Plugins[i].title +
				"\" name=\"" + name + "\" /> </li>";
		toolStrip.append(html);
		var button = $("." + VP.Scripting.Plugins[i].css + " a", toolStrip);
		button.data({ "plugin": plugin, "language": language, "name": name });
		button.mousedown(function() {
			that.ToolButtonClick($(this).data());
		});
	}
};

VP.Scripting.ScriptManager.prototype.ToolButtonClick = function(data) {
	var oPlugin = new data.plugin();
	oPlugin._language = data.language
	oPlugin._name = data.name;
	oPlugin.PreparePropertyDialog();
};

VP.Scripting.ScriptManager.prototype.CancelButtonClick = function(event) {

};

VP.Scripting.ScriptManager.prototype.GetNewResourceId = function() {
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

VP.Scripting.ScriptManager.prototype.Save = function() {
	this._resources = new Array();
	var text = this._editor._wym.xhtml();
	for (name in this._plugins) {
		var index = text.indexOf("<img id=\"" + name + "\"");
		if (index > 0) {
			this._resources[this._resources.length] = this._plugins[name].Resource;
		}
	}
};

VP.Scripting.ScriptManager.prototype.BeginWait = function() {
	this._busyImage.show();
};

VP.Scripting.ScriptManager.prototype.EndWait = function() {
	this._busyImage.hide();
};

