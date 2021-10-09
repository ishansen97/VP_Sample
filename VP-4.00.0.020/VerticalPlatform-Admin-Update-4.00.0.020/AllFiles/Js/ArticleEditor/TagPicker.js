RegisterNamespace("VP.ArticleEditor.TagPicker");

VP.ArticleEditor.TagPicker = function(textbox)
{
	this._control = textbox;
};

VP.ArticleEditor._buttonId = 0
$.fn.AddTagPicker = function(option){
	return this.each(function() {
		
		VP.ArticleEditor._buttonId ++;
		var inputElement = $(this);
		var that = this;
		inputElement.after('<input type="button" class="TagPicker" id="tagPicker_' + VP.ArticleEditor._buttonId + '"/>');
		
		$("#tagPicker_" + VP.ArticleEditor._buttonId).click(function(){
				var tagPicker = new VP.ArticleEditor.TagPicker(that);
				tagPicker.ShowTagPicker();
		});
	});
};

VP.ArticleEditor.TagPicker.prototype.ShowTagPicker = function()
{
	$("#PluginPropertyDialog").jqm({ modal: true });
	this._dialogPanel = $("#PluginPropertyDialogPane");
	this._dialogPanel.empty();
	var that = this;
	
	var template = $("#PluginPropertyDialogTemplates #TagsSelectorDialog").clone();
	$("#PluginPropertyDialogPane").append(template);
	
	$("#btnSaveProperties").attr('value','Add');
	$("#btnSaveProperties").unbind("click").click(function() {
		$("#PluginPropertyDialog").jqmHide();
		var selectedTag = $(".ddlTags", this._dialogPanel).val();
		var currentValue = that._control.value;
		that._control.value = currentValue + " " + selectedTag;
	});
	
	$("#btnCancelPropertes").unbind("click").click(function() {
		$("#PluginPropertyDialog").jqmHide();
	});

	$("#PluginPropertyDialogErrors").empty();
	$("#PluginPropertyDialog").jqmShow();
};