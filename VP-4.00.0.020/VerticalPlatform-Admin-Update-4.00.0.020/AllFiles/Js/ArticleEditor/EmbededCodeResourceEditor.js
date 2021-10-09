VP.ArticleEditor.EmbeddedCodeResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.EmbeddedCodeResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.EmbeddedCodeResourceEditor.prototype.LoadEditor = function(element, parentId) {
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this._element = element;
	this.DisplayResourceTypeName("Embedded Code Resource");
	var html = $("#EmbeddedCodeResourceEditorTemplate").clone();
	$(element).append(html);

	if (this._resource != null) {
		if (typeof (this._resource.EmbeddedCode) != 'undefined') {
			$(".txtEmbeddedCode", this._element).val(this._resource.EmbeddedCode);
		}
	}
	
	$(".txtEmbeddedCode", this._element).AddTagPicker();
}

VP.ArticleEditor.EmbeddedCodeResourceEditor.prototype.Save = function() {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.EmbeddedCode = $(".txtEmbeddedCode", this._element).val();
}

VP.ArticleEditor.EmbeddedCodeResourceEditor.prototype.Validate = function(isTemplate) {
	var that = this;
	var ret = true;
	if(!isTemplate){
		ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
		if ($(".txtEmbeddedCode", this._element).val().trim() == "") {
			this._errors[0] = "Please enter Embedded Code";
			ret = false;
		}
	}
	return ret;
}

VP.ArticleEditor.EmbeddedCodeResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if(!isTemplate){
		if (this._resource.EmbeddedCode.trim() == "") {
			ret = false;
		}
	}
	return ret;
}