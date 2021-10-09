tinyMCEPopup.requireLangPack();

var PluginTypeId = "5";
var PluginTypeName = "EmbeddedCode";

var EmbeddedCodeDialog = {
	init : function () {
		// Get the selected contents as text and place it in the input
		var selection, id, alt;
		
		selection = tinyMCEPopup.editor.selection.getContent();
		id = $(selection).attr('id');
		alt = $(selection).attr('alt');
		if ((PluginTypeName == alt) && (id.indexOf("plugin_") != -1)) {
		    var pluginManager, plugin;
		    pluginManager = tinyMCEPopup.editor.pluginManager;
			plugin = pluginManager.GetPluginInstance(id);
			$('#txtEmbeddedCode').val(plugin.Resource.EmbeddedCode);
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
			plugin.Resource.EmbeddedCode = $('#txtEmbeddedCode').val();
			placeHolder = pluginManager.SetPluginInstance(plugin); 
			tinyMCEPopup.editor.execCommand('mceInsertContent', false, placeHolder);
			pluginManager.Save();
			tinyMCEPopup.close();
		}
	},
	
	validate : function () {
		var valid, message;
		valid = true;
		message = "";
		if ($.trim($('#txtEmbeddedCode').val()) == "") {
			message += "<li> Please enter Embedded Code </li>";
			$('#txtEmbeddedCode').focus();
			valid = false;
		}
		$("ul.errorPanel").html(message);
		return valid;
	}
};

tinyMCEPopup.onInit.add(EmbeddedCodeDialog.init, EmbeddedCodeDialog);