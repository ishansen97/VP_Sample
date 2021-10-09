tinyMCEPopup.requireLangPack();
var language = 'Ruby';

var SnippetDialog = {
	init : function () {
		// Get the selected contents as text and place it in the input
		var groups, html;
		html = "";
		groups = tinyMCEPopup.editor.ScriptingContext.GetGroups();
		for (var i = 0; i < groups.length; i++) {
			html += "<option>" + groups[i].GroupName + "</option>";
		}
		$('#ddlContentGroups').html(html);
	},

	insert : function () {
		// Insert the contents from the input into the document
		var groupName = $('#ddlContentGroups').val();
		var snippetType = $('#ddlScriptType').val();
		var renderType = $('#ddlRenderType').val();
		var code = tinyMCEPopup.editor.ScriptingContext.GetSnippet(groupName, language, snippetType, renderType);
		
		if (code != "" && language == 'Ruby') {
			var html = tinyMCEPopup.editor.getContent();
			html = html + code;
			
			var re = new RegExp("{#VPX Language=\"Ruby\"#}");
			
			if (!html.match(re)) {
				tinyMCE.activeEditor.setContent("{#VPX Language=\"Ruby\"#}\n" + html);
			} else {
				tinyMCE.activeEditor.setContent(html);
			}
			
		}
		
		tinyMCEPopup.close();
	}
	
};

tinyMCEPopup.onInit.add(SnippetDialog.init, SnippetDialog);