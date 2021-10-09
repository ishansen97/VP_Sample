tinyMCEPopup.requireLangPack();

var PluginTypeId = "3";
var PluginTypeName = "Video";

var VPVideoDialog = {
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
			$('#txtIds').val(plugin.Resource.VideoId);
			$('#txtLength').val(plugin.Resource.VideoLength);
			$('#txtWidth').val(plugin.Resource.Width);
			$('#txtHeight').val( plugin.Resource.Height);
			$('#txtPlayerId').val( plugin.Resource.PlayerId);
			$('#cbVideoListing').attr('checked',plugin.Resource.IsVideoListing);
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
			plugin.Resource.VideoId = $('#txtIds').val();
			plugin.Resource.VideoLength = $('#txtLength').val();
			plugin.Resource.Width = $('#txtWidth').val();
			plugin.Resource.Height = $('#txtHeight').val();
			plugin.Resource.PlayerId = $('#txtPlayerId').val();
			plugin.Resource.IsVideoListing = $('#cbVideoListing').attr('checked');
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
		if ($.trim($('#txtIds').val()) == "") {
			message += "<li> Please enter the video id </li>";
			focus[focus.length] = '#txtIds';
			valid = false;
		}
		
		if ($.trim($('#txtLength').val()) != "") {
			var regularExpression = new RegExp("^(([0-9]*):([0-5][0-9]))$");
			if(!regularExpression.test($.trim($('#txtLength').val()))) {
				regularExpression = new RegExp("^(([0-9]*):([6-9][0-9]))$");
				
				if (regularExpression.test($.trim($('#txtLength').val()))) {
					message += "<li> The mm part of the Video Length should be between 0 and 60 </li>";
				} else {
					message += "<li> Please enter Video Length in hh:mm format </li>";
				}
				focus[focus.length] = '#txtLength';
				valid = false;
				
			}
			
		} else {
			message += "<li> Please enter the video length </li>";
			focus[focus.length] = '#txtLength';
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
		
		if ($.trim($('#txtPlayerId').val()) == "") {
			message += "<li> Please enter the player id </li>";
			focus[focus.length] = '#txtPlayerId';
			valid = false;
		}
		
		if (focus.length > 0) {
			$(focus[0]).focus();
		}
		$("ul.errorPanel").html(message);
		
		return valid;
	}
};

tinyMCEPopup.onInit.add(VPVideoDialog.init, VPVideoDialog);