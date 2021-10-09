
RegisterNamespace("VP.ArticleEditor");

VP.ArticleEditor.Plugin = function() {
};

VP.ArticleEditor.Plugin.prototype.InitPlugin = function() {
	this._dialogPanel = null;
	this._errors = new Array();
	this._CancelButtonClickEvent = $.Event("CancelButtonClick");
	this.saved = false;
	this._lastPlugin = null;
	this._base = null;
}

VP.ArticleEditor.Plugin.prototype.PlaceholderImage = "Plugin.png";

VP.ArticleEditor.Plugin.prototype.ShowPropertyDialog = function(text, lastPlugin, base) {
	this._lastPlugin = lastPlugin;
	this._base = base;
	this.PreparePropertyDialog();
	if(text != "")
	{
		this.PopulatePropertyDialog(text);
	}
	$("#PluginPropertyDialog").jqmShow();
}

VP.ArticleEditor.Plugin.prototype.PreparePropertyDialog = function() {
	this._dialogPanel = $("#PluginPropertyDialogPane");
	this._dialogPanel.empty();
	var that = this;
	$("#btnSaveProperties").unbind("click").click(function() {
		if (that.ValidatePropertyDialog()) {
			that.SaveProperties();
			$("#PluginPropertyDialog").jqmHide();
			
			if(typeof(that._lastPlugin) != "undefined")
			{
				that._editor.insert(that._lastPlugin);
				that._base.BindEvents();
			}
		}
		else {
			that.ShowErrors();
		}
	});
	$("#btnCancelPropertes").unbind("click").click(function() {
		$("#PluginPropertyDialog").jqmHide();
	});

	$("#PluginPropertyDialogErrors").empty();
};

VP.ArticleEditor.Plugin.prototype.SaveProperties = function() {
	this.saved = true;
}

VP.ArticleEditor.Plugin.prototype.PopulatePropertyDialog = function() {
}

VP.ArticleEditor.Plugin.prototype.ValidatePropertyDialog = function() {
	this._errors = new Array();
	return true;
}

VP.ArticleEditor.Plugin.prototype.ShowErrors = function() {
	var errorList = $("#PluginPropertyDialogErrors");
	errorList.empty();
	var errorHtml = "";
	for (var i = 0; i < this._errors.length; i++) {
		var error = this._errors[i];
		errorHtml += "<li>" + error.Message + "</li>";
		$("#" + error.Field, this._dialogPanel).addClass("invalidField");
	}
	errorList.append(errorHtml);
}

VP.ArticleEditor.Plugin.prototype.AddError = function(field, message) {
	var error = { Field: field, Message: message };
	this._errors[this._errors.length] = error;
}