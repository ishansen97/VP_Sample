RegisterNamespace("VP.Scripting");

VP.Scripting.ScriptingContext = function(campaignTypeId, campaignId) {
	this._campaignTypeId = campaignTypeId;
	this._campaignId = campaignId;
	this._groups = null;
	this._editor = null;
};

VP.Scripting.ScriptingContext.prototype.GetGroups = function() {
	var that = this;
	if (!that._groups) {
		var serviceUrl = VP.ApplicationRoot + "Services/BulkEmailWebService.asmx/GetCampaignTypeContentGroups";

		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: serviceUrl,
			data: "{'campaignTypeId' : " + that._campaignTypeId + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				that._groups = msg.d;
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
			}
		});
	}

	return that._groups;
};

VP.Scripting.ScriptingContext.prototype.GetContentGroup = function(groupName) {
	var group = null;
	if (this._groups) {
		for (var i = 0; i < this._groups.length; i++) {
			if (this._groups[i].GroupName == groupName) {
				group = this._groups[i];
				break;
			}
		}
	}

	return group;
};

VP.Scripting.ScriptingContext.prototype.GetSnippet = function(groupName, language, snippetType, renderType) {
	var group = this.GetContentGroup(groupName);
	var code = "";
	if (group) {
		var snippet = new VP.Scripting.Snippet(language, group.ContentType, group.GroupName,
			snippetType, renderType);
		code = snippet.GetSnippet();
	}

	return code;
}