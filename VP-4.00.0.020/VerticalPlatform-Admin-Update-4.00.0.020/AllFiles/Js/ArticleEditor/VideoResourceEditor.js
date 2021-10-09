VP.ArticleEditor.VideoResourceEditor = function()
{
	VP.ArticleEditor.ResourceEditor.apply(this);
	this._regularExpressionTime = new RegExp("^(([0-9]*):([0-5][0-9]))$");
};

VP.ArticleEditor.VideoResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.VideoResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Video Resource");
	var html = $("#VideoResourceEditorTemplate").clone();
	$(element).append(html);
	if (this._resource != null) {
		if (typeof (this._resource.VideoId) != 'undefined') {
			$(".txtVideoId", this._element).val(this._resource.VideoId);
			if (this._resource.IsVideoListing) {
				$(".chkIsVideoListing", this._element).attr('checked', 'checked');
			}
			$(".txtVideoLength", this._element).val(this._resource.VideoLength);
			$(".txtWidth", this._element).val(this._resource.Width);
			$(".txtHeight", this._element).val(this._resource.Height);
			$(".txtPlayerId", this._element).val(this._resource.PlayerId);
			if (this._resource.IsAutoPlay) {
				$(".chkAutoPlay", this._element).attr('checked', 'checked');
			}
		}
	}
}

VP.ArticleEditor.VideoResourceEditor.prototype.Save = function()
{
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this); 
	this._resource.VideoId = $(".txtVideoId", this._element).val();
	this._resource.IsVideoListing = $(".chkIsVideoListing", this._element).attr('checked');
	this._resource.VideoLength = $(".txtVideoLength", this._element).val();
	this._resource.Width = $(".txtWidth", this._element).val();
	this._resource.Height = $(".txtHeight", this._element).val();
	this._resource.PlayerId = $(".txtPlayerId", this._element).val();
	this._resource.IsAutoPlay = $(".chkAutoPlay", this._element).attr('checked');
}

VP.ArticleEditor.VideoResourceEditor.prototype.Validate = function(isTemplate)
{
	var that = this;
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	
	if(!isTemplate)
	{
		if ($(".txtVideoId", this._element).val() == "")
		{
			this._errors[this._errors.length] = "Please enter 'Video Id'";
			ret = false; 
		}
		if ($(".txtVideoLength", this._element).val() == "")
		{
			this._errors[this._errors.length] = "Please enter 'Video Length'";
			ret = false; 
		}
		else if(!this._regularExpressionTime.test($(".txtVideoLength", this._element).val()))
		{
			this._errors[this._errors.length] = "Please enter 'Video Length' in hh:mm format";
			ret = false; 
		}
			
		if ($(".txtWidth", this._element).val() == "" || isNaN($(".txtWidth", this._element).val()))
		{
			this._errors[this._errors.length] = "Please enter Video 'Width'";
			ret = false; 
		}
		if ($(".txtHeight", this._element).val() == "" || isNaN($(".txtHeight", this._element).val()))
		{
			this._errors[this._errors.length] = "Please enter Video 'Hieght'";
			ret = false; 
		}
		if ($(".txtPlayerId", this._element).val() == "")
		{
			this._errors[this._errors.length] = "Please enter 'Player Id'";
			ret = false; 
		}
	}
	
	return ret;
}

VP.ArticleEditor.VideoResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate) {
		if (this._resource.VideoId == "") {
			ret = false;
		}
		if (this._resource.VideoLength == "") {
			ret = false;
		}
		else if(!this._regularExpressionTime.test(this._resource.VideoLength))
		{
			ret = false; 
		}
		if (this._resource.PlayerId == "") {
			ret = false;
		}
		if (this._resource.Width == "") {
			ret = false;
		}
		if (this._resource.Height == "") {
			ret = false;
		}
	}
	return ret;
}
