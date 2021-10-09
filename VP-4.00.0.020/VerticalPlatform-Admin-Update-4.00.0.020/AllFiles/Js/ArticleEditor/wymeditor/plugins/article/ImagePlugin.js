VP.ArticleEditor.ImagePlugin = function() {
};

VP.ArticleEditor.ImagePlugin.ButtonClass = "wym_tools_image";
VP.ArticleEditor.ImagePlugin.PluginTypeName = "Image";
VP.ArticleEditor.ImagePlugin.PluginTypeId = "2";


VP.ArticleEditor.ImagePlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.ImagePlugin.prototype.PlaceholderImage = "image.gif";

VP.ArticleEditor.ImagePlugin.prototype.InitPlugin = function(resourceCode, editor) {
	VP.ArticleEditor.Plugin.prototype.InitPlugin.apply(this);
	this.Resource = new VerticalPlatform.Core.Web.Dto.Articles.ImageResource();
	this.Resource.Id = 0;
	this.Resource.ResourceCode = resourceCode;
	this.Resource.ImageName = "";
	this.Resource.Width = "";
	this.Resource.Height = "";
	this.Resource.ImageCustomCss = "";
	this.Resource.ImageAltTag = "";
	this.Resource.ResourceType = 2;
	this._editor = editor;
};

VP.ArticleEditor.ImagePlugin.prototype.Load = function(resource) {
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.ImageName = resource.ImageName;
	this.Resource.Width = resource.Width;
	this.Resource.Height = resource.Height;
	this.Resource.ImageCustomCss = resource.ImageCustomCss;
	this.Resource.ImageAltTag = resource.ImageAltTag;
	this.Resource.ResourceType = resource.ResourceType;
};

VP.ArticleEditor.ImagePlugin.prototype.PreparePropertyDialog = function() {

	VP.ArticleEditor.Plugin.prototype.PreparePropertyDialog.apply(this);
	var template = $("#PluginPropertyDialogTemplates #ImagePropertyDialog").clone();
	this._dialogPanel.append(template);
};

VP.ArticleEditor.ImagePlugin.prototype.PopulatePropertyDialog = function() {
	var that = this;
	VP.ArticleEditor.Plugin.prototype.PopulatePropertyDialog.apply(this);
	$("#txtImageName", this._dialogPanel).val(this.Resource.ImageName);
	$("#txtImageHeight", this._dialogPanel).val(this.Resource.Height);
	$("#txtImageWidth", this._dialogPanel).val(this.Resource.Width);
	$("#txtImageCustomCss", this._dialogPanel).val(this.Resource.ImageCustomCss);
	$("#txtImageAltTag", this._dialogPanel).val(this.Resource.ImageAltTag);

	$(".ddlImagePluginCssClass", this._dialogPanel).change(function() {
		if ($(".ddlImagePluginCssClass", that._dialogPanel).val() > 0) {
			$("#txtImageCustomCss", that._dialogPanel).val($('option:selected', $(".ddlImagePluginCssClass", that._dialogPanel)).text());
		}
	});
};

VP.ArticleEditor.ImagePlugin.prototype.ValidatePropertyDialog = function() {
	var valid = true;
	
	if($("input[id$='hdnIsTemplate']").val() == "false")
	{
		VP.ArticleEditor.Plugin.prototype.ValidatePropertyDialog.apply(this);
		var name = $.trim($("#txtImageName", this._dialogPanel).val());
		var width = $("#txtImageWidth", this._dialogPanel).val();
		var height = $("#txtImageHeight", this._dialogPanel).val();

		if (name == "") {
			this.AddError("#txtImageName", "Please enter the image name");
			valid = false;
		}

		if (height != "") {
			if (isNaN(height)) {
				this.AddError("#txtImageHeight", "Please enter a numeric value for heigth");
				valid = false;
			}
		}
		else {
			this.AddError("#txtImageHeight", "Please enter a numeric value for height");
			valid = false;
		}

		if (width != "") {
			if (isNaN(width)) {
				this.AddError("#txtImageWidth", "Please enter a numeric value for width");
				valid = false;
			}
		} else {
			this.AddError("#txtImageWidth", "Please enter a numeric value for width");
			valid = false;
		}
	}
	
	return valid;
};

VP.ArticleEditor.ImagePlugin.prototype.SaveProperties = function() {
	VP.ArticleEditor.Plugin.prototype.SaveProperties.apply(this);
	var name = $.trim($("#txtImageName", this._dialogPanel).val());
	var width = $("#txtImageWidth", this._dialogPanel).val();
	var height = $("#txtImageHeight", this._dialogPanel).val();
	var imageCss = $("#txtImageCustomCss", this._dialogPanel).val();
	var imageAlt = $("#txtImageAltTag", this._dialogPanel).val();

	this.Resource.ImageName = name;
	this.Resource.Height = height;
	this.Resource.Width = width;
	this.Resource.ImageCustomCss = imageCss;
	this.Resource.ImageAltTag = imageAlt;
};