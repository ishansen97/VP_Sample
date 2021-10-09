
VP.ArticleEditor.ResourceSettingEditor = function()
{
	this._errors = [];
	this._resource = [];
};

VP.ArticleEditor.ResourceSettingEditor.prototype.InitEditor = function(resource)
{
	this._resource = resource;
};


VP.ArticleEditor.ResourceSettingEditor.prototype.Save = function()
{
	
};

VP.ArticleEditor.ResourceSettingEditor.prototype.LoadEditor = function(element, parentId) 
{
	
};

VP.ArticleEditor.ResourceSettingEditor.prototype.Save = function()
{

};

VP.ArticleEditor.ResourceSettingEditor.prototype.Validate = function() {
	return true;
};

VP.ArticleEditor.ResourceSettingEditor.prototype.DisplayResourceTypeName = function(resourceTypeName) {
	var container = $(".ArticleContentEdit");
	$(container).prepend("<h4>" + resourceTypeName + " Settings</h4>");
};