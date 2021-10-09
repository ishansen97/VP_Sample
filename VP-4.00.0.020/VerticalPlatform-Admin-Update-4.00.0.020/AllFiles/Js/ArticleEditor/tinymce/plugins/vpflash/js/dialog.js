tinyMCEPopup.requireLangPack();

var PluginTypeId = "4";
var PluginTypeName = "Flash";

var VPFlashDialog = {
	init : function () {
		var selection, id, alt;
		selection = tinyMCEPopup.editor.selection.getContent();
		id = $(selection).attr('id');
		alt = $(selection).attr('alt');
		
		if ((PluginTypeName == alt) && (id.indexOf("plugin_") != -1)) {
		    var pluginManager, plugin;
		    pluginManager = tinyMCEPopup.editor.pluginManager;
			plugin = pluginManager.GetPluginInstance(id);
			$('#txtUrl').val(plugin.Resource.Url);
			$('#txtWidth').val(plugin.Resource.Width);
			$('#txtHeight').val(plugin.Resource.Height);
			$('#txtVars').val(plugin.Resource.FlashVars);
		}
	},

	insert : function () {
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
			plugin.Resource.Url = $('#txtUrl').val();
			plugin.Resource.Width = $('#txtWidth').val();
			plugin.Resource.Height = $('#txtHeight').val();
			plugin.Resource.FlashVars = $('#txtVars').val();
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
		if ($.trim($('#txtUrl').val()) == "") {
			message += "<li> Please enter Flash URL </li>";
			focus[focus.length] = '#txtUrl';
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

tinyMCEPopup.onInit.add(VPFlashDialog.init, VPFlashDialog);