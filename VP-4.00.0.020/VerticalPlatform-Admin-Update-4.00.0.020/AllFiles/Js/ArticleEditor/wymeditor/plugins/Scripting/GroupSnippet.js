VP.Scripting.GroupSnippet = function() {

};

VP.Scripting.GroupSnippet.prototype = Object.create(VP.Scripting.BaseScript.prototype);

VP.Scripting.GroupSnippet.prototype.PreparePropertyDialog = function() {
	$(".dialog_header h2", "#propertyDialog").html(this._name);
	var groups = VP.Scripting.Context.GetGroups();
	var html = "";
	if (groups) {
		html += "<div class='clearfix content_popup_span'><span>Content Group</span><select id='ddlContentGroups'>";
		for (var i = 0; i < groups.length; i++) {
			html += "<option>" + groups[i].GroupName + "</option>";
		}
		html += "</select>"
		html += "</div>";
		html += "<div class='clearfix content_popup_span'><span>Script Type</span><select id='ddlScriptType'>" +
					"<option value='Expressions'>Expressions</option>" +
					"<option value='UtilityMethods'>Utility Methods</option>" +
				"</select></div>";
		html += "<div class='clearfix content_popup_span'><span>Render Type</span><select id='ddlRenderType'>" +
					"<option value='Full'>Full</option>" +
					"<option value='Summary'>Summary</option>" +
					"<option value='List'>List</option>" +
				"</select></div>";
	}
	else {
		html = "There are no groups defined.";
	}

	VP.Scripting.BaseScript.prototype.UpdateDialog.apply(this, [html]);
	VP.Scripting.BaseScript.prototype.ShowDialog.apply(this);
};

VP.Scripting.GroupSnippet.prototype.UpdateProperties = function() {
	var snippet = this.GetSnippet();
	VP.Scripting.BaseScript.prototype.UpdateProperties.apply(this, [snippet]);
};

VP.Scripting.GroupSnippet.prototype.GetSnippet = function() {
	var groupName = $('#ddlContentGroups').val();
	var snippetType = $('#ddlScriptType').val();
	var renderType = $('#ddlRenderType').val();
	var group = VP.Scripting.Context.GetContentGroup(groupName);
	var code = "";
	if (group) {
		var snippet = new VP.Scripting.Snippet(this._language, group.ContentType, group.GroupName,
			snippetType, renderType);
		code = snippet.GetSnippet();
	}

	return code;
}
