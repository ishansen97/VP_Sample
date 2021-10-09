VP.Scripting.BaseScript = function() {
	this._language = "";
	this._name = "";
};

VP.Scripting.BaseScript.prototype.ShowDialog = function() {
	$("#propertyDialog").jqmShow();
};

VP.Scripting.BaseScript.prototype.HideDialog = function() {
	$("#propertyDialog").jqmHide();
};

VP.Scripting.BaseScript.prototype.UpdateDialog = function(html) {
	$("#custom").empty().append(html);

	var that = this;

	$("#propertyCancel").unbind('click');
	$("#propertyCancel").click(function() {
		that.CancelProperties();
	});

	$("#propertySave").unbind('click');
	$("#propertySave").click(function() {
		that.UpdateProperties();
	});
};

VP.Scripting.BaseScript.prototype.CancelProperties = function() {
	this.HideDialog();
};

VP.Scripting.BaseScript.prototype.UpdateProperties = function(snippet) {
	if (snippet) {
		VP.Scripting.Context._editor.insert(snippet);
	}

	var html = VP.Scripting.Context._editor.html();

	if (this._language == "Ruby") {
		var re = new RegExp("{#VPX Language=\"Ruby\"#}");
		if (!html.match(re)) {
			VP.Scripting.Context._editor.html("{#VPX Language=\"Ruby\"#}\n" + html);
		}
	}

	this.HideDialog();
};
