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
	if (tinyMCE.activeEditor != null) {
		campaignContent = tinyMCE.activeEditor.getContent();
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
	if (tinyMCE.activeEditor != null) {
	tinyMCE.activeEditor.remove();
	}
	$("#CampaignContentEditorTemplate").empty().html(html);
};

VP.Scripting.ScriptManager.prototype.ToggleHtmlView = function() {
	var that = this;

	if (tinyMCE.activeEditor != null) {
		var text = tinyMCE.activeEditor.getContent();
		tinyMCE.activeEditor.remove();
		
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
		var scriptingContext = new VP.Scripting.ScriptingContext(campaignTypeId, contentId);
		$("textarea.wymCampaignContentPaneEditor").tinymce({
			// Location of TinyMCE script
			script_url : '../tiny_mce.js',
			// General options
			theme : "advanced",
			plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,advlist,vpgroupsnippet,vpclear",

			// Theme options
			theme_advanced_buttons1 : "vpgroupsnippet,vpclear",
			theme_advanced_buttons2 : "",
			theme_advanced_buttons3 : "",
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
			theme_advanced_statusbar_location : "bottom",
			theme_advanced_resizing : true,
			entity_encoding : "named",
			invalid_elements : "tbody",
			// Example content CSS (should be your site CSS)
			content_css : "css/content.css",
			convert_urls : false,

			// Drop lists for link/image/media/template dialogs
			template_external_list_url : "lists/template_list.js",
			external_link_list_url : "lists/link_list.js",
			external_image_list_url : "lists/image_list.js",
			media_external_list_url : "lists/media_list.js",

			setup : function(ed) {
				tinyMCE.extend(ed,{ScriptingContext:scriptingContext});
			}
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

	//this.CreateToolButtons();
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

VP.Scripting.ScriptManager.prototype.BeginWait = function() {
	this._busyImage.show();
};

VP.Scripting.ScriptManager.prototype.EndWait = function() {
	this._busyImage.hide();
};

