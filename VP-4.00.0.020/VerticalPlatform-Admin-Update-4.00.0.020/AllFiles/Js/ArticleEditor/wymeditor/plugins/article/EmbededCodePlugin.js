VP.ArticleEditor.EmbeddedCodePlugin = function() {
};

VP.ArticleEditor.EmbeddedCodePlugin.ButtonClass = "wym_tools_embeded";
VP.ArticleEditor.EmbeddedCodePlugin.PluginTypeName = "EmbeddedCode";
VP.ArticleEditor.EmbeddedCodePlugin.PluginTypeId = "5";


VP.ArticleEditor.EmbeddedCodePlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.EmbeddedCodePlugin.prototype.PlaceholderImage = "embad.jpg";

VP.ArticleEditor.EmbeddedCodePlugin.prototype.InitPlugin = function(resourceCode, editor) {
	VP.ArticleEditor.Plugin.prototype.InitPlugin.apply(this);
	this.Resource = new VerticalPlatform.Core.Web.Dto.Articles.EmbeddedCodeResource();
	this.Resource.Id = 0;
	this.Resource.ResourceCode = resourceCode;
	this.Resource.EmbeddedCode = "";
	this.Resource.ResourceType = 5;
	this._editor = editor;
};

VP.ArticleEditor.EmbeddedCodePlugin.prototype.Load = function(resource) {
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.EmbeddedCode = resource.EmbeddedCode;
	this.Resource.ResourceType = resource.ResourceType;
};

VP.ArticleEditor.EmbeddedCodePlugin.prototype.PreparePropertyDialog = function() {

	VP.ArticleEditor.Plugin.prototype.PreparePropertyDialog.apply(this);
	var template = $("#PluginPropertyDialogTemplates #EmbeddedCodePropertyDialog").clone();
	this._dialogPanel.append(template);
};

VP.ArticleEditor.EmbeddedCodePlugin.prototype.PopulatePropertyDialog = function() {
	var that = this;
	VP.ArticleEditor.Plugin.prototype.PopulatePropertyDialog.apply(this);
	$("#txtEmbeddedCode", this._dialogPanel).val(this.Resource.EmbeddedCode);
};

VP.ArticleEditor.EmbeddedCodePlugin.prototype.ValidatePropertyDialog = function() {
	var valid = true;
	var code = $("#txtEmbeddedCode", this._dialogPanel).val().trim();

	valid = VP.ArticleEditor.Plugin.prototype.ValidatePropertyDialog.apply(this); ;
	if (code == "") {
		this.AddError("#txtEmbeddedCode", "Please enter Embedded Code");
		valid = false;
	}
	return valid;
};

VP.ArticleEditor.EmbeddedCodePlugin.prototype.SaveProperties = function() {
	VP.ArticleEditor.Plugin.prototype.SaveProperties.apply(this);
	var code = $("#txtEmbeddedCode", this._dialogPanel).val();
	this.Resource.EmbeddedCode = code;
};