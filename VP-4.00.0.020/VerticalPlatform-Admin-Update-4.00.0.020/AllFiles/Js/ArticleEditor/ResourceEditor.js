
VP.ArticleEditor.ResourceEditor = function()
{
	this._errors = [];
	this._resource = [];
	this._showApplyButton = true;
};

VP.ArticleEditor.ResourceEditor.prototype.InitEditor = function(resource)
{
	this._resource = resource;
};


VP.ArticleEditor.ResourceEditor.prototype.Save = function()
{
	
};

VP.ArticleEditor.ResourceEditor.prototype.LoadEditor = function(element, parentId) 
{

};

VP.ArticleEditor.ResourceEditor.prototype.Save = function()
{

};

VP.ArticleEditor.ResourceEditor.prototype.Validate = function(isTemplate) {
	return true;
};

VP.ArticleEditor.ResourceEditor.prototype.DisplayResourceTypeName = function(resourceTypeName) {
	var container = $(".ArticleContentEdit");
	$(container).prepend("<h4>" + resourceTypeName + " Properties</h4>");
};

VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	return true;
};

VP.ArticleEditor.ResourceEditor.prototype.IsNullOrUndefined = function (value) {
	if (typeof (value) != 'undefined' && value != null) {
		return true;
	}

	return false;
};

VP.ArticleEditor.ResourceEditor.prototype.IsNullUndefinedOrEmpty = function (value) {
	if (typeof (value) != 'undefined' && value != null && value == '') {
		return true;
	}

	return false;
};