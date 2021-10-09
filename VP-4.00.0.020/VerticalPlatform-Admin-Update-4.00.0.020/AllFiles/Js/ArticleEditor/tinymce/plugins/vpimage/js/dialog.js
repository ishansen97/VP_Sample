tinyMCEPopup.requireLangPack();

var PluginTypeId = "2";
var PluginTypeName = "Image";

var VPImageDialog = {
	init : function () {
		var selection, id, alt;
		selection = tinyMCEPopup.editor.selection.getContent();
		id = $(selection).attr('id');
		alt = $(selection).attr('alt');
		
		if ((PluginTypeName == alt) && (id.indexOf("plugin_") != -1)) {
			var pluginManager, plugin;
			pluginManager = tinyMCEPopup.editor.pluginManager;
			plugin = pluginManager.GetPluginInstance(id);
			$('#txtImage').val(plugin.Resource.ImageName);
			$('#txtWidth').val(plugin.Resource.Width);
			$('#txtHeight').val(plugin.Resource.Height);
			$('#txtCss').val(plugin.Resource.ImageCustomCss);
			$('#txtAlt').val(plugin.Resource.ImageAltTag);
			if (plugin.Resource.ImageFigure) {
				$('#cbFigure').attr("checked", "checked");
			}
			
			if (plugin.Resource.ImageZoom) {
				$('#cbZoom').attr("checked", "checked");
			}
		}
	},

	insert : function () {
		// Insert the contents from the input into the document
	    var selection, pluginManager, plugin, update, placeHolder;
	    selection = tinyMCEPopup.editor.selection.getContent();
		pluginManager = tinyMCEPopup.editor.pluginManager;
		
		plugin = null;
		update = false;
		if (selection.length > 0) {
			var id, alt;
			id = $(selection).attr('id');
			alt = $(selection).attr('alt');
			
			if ((PluginTypeName == alt) && (id.indexOf("plugin_") != -1)) {
				update = true;
			}
		}
		
		if (update) {
			plugin = pluginManager.GetPluginInstance(id);
		} else {
			plugin = pluginManager.CreatePluginInstance(PluginTypeId);
		}
		
		if (this.validate()) {
			plugin.Resource.ImageName = $('#txtImage').val();
			plugin.Resource.Width = $('#txtWidth').val();
			plugin.Resource.Height = $('#txtHeight').val();
			plugin.Resource.ImageCustomCss = $('#txtCss').val();
			plugin.Resource.ImageAltTag = $('#txtAlt').val();
			plugin.Resource.ImageFigure = $('#cbFigure').attr("checked");
			plugin.Resource.ImageZoom = $('#cbZoom').attr("checked");
			placeHolder = pluginManager.SetPluginInstance(plugin);
			tinyMCEPopup.editor.execCommand('mceInsertContent', false, placeHolder);
			pluginManager.Save();
			tinyMCEPopup.close();
		}
	},
	
	validate : function () {
		var valid, message, focus;
		valid = true;
		message = "";
		focus = new Array();
		if ($.trim($('#txtImage').val()) == "") {
			message += "<li> Please enter the image name </li>";
			focus[focus.length] = '#txtImage';
			valid = false;
		}
		
		if ($.trim($('#txtWidth').val()) == "" || isNaN($('#txtWidth').val())) {
			message += "<li> Please enter a numeric value for width </li>";
			focus[focus.length] = '#txtWidth';
			valid = false;
		}
		
		if ($.trim($('#txtHeight').val()) == "" || isNaN($('#txtHeight').val())) {
			message += "<li> Please enter a numeric value for height </li>";
			focus[focus.length] = '#txtHeight';
			valid = false;
		}
		
		if (focus.length > 0) {
			$(focus[0]).focus();
		}
		$("ul.errorPanel").html(message);
		
		return valid;
	}
};

tinyMCEPopup.onInit.add(VPImageDialog.init, VPImageDialog);