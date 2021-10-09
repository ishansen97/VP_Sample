VP.ArticleEditor.FlashPlugin = function()
{    
};

VP.ArticleEditor.FlashPlugin.ButtonClass = "wym_tools_flash";
VP.ArticleEditor.FlashPlugin.PluginTypeName = "Flash";
VP.ArticleEditor.FlashPlugin.PluginTypeId = "4";

VP.ArticleEditor.FlashPlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.FlashPlugin.prototype.PlaceholderImage = "flash.gif";

VP.ArticleEditor.FlashPlugin.prototype.InitPlugin = function(resourceCode, editor)
{    
	VP.ArticleEditor.Plugin.prototype.InitPlugin.apply(this);
	this.Resource = new VerticalPlatform.Core.Web.Dto.Articles.FlashResource();
	this.Resource.Id = 0;
	this.Resource.ResourceCode = resourceCode;
	this.Resource.Url = "";
	this.Resource.Width = "";
	this.Resource.Height = "";
	this.Resource.FlashVars = "";
	this.Resource.ResourceType = 4;
	this._editor = editor;
};

VP.ArticleEditor.FlashPlugin.prototype.Load = function(resource)
{
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.Url = resource.Url;
	this.Resource.Width = resource.Width;
	this.Resource.Height = resource.Height;
	this.Resource.FlashVars = resource.FlashVars;
	this.Resource.ResourceType = resource.ResourceType;
};

VP.ArticleEditor.FlashPlugin.prototype.PreparePropertyDialog = function()
{
	
	VP.ArticleEditor.Plugin.prototype.PreparePropertyDialog.apply(this);
	var template = $("#PluginPropertyDialogTemplates #FlashPropertyDialog").clone();
	this._dialogPanel.append(template);
};

VP.ArticleEditor.FlashPlugin.prototype.PopulatePropertyDialog = function()
{
	VP.ArticleEditor.Plugin.prototype.PopulatePropertyDialog.apply(this);
	$("#txtTextFlashUrl", this._dialogPanel).val(this.Resource.Url);
	$("#txtTextFlashWidth", this._dialogPanel).val(this.Resource.Width);
	$("#txtTextFlashHeight", this._dialogPanel).val(this.Resource.Height);
	$("#txtTextFlashVars", this._dialogPanel).val(this.Resource.FlashVars);
};

VP.ArticleEditor.FlashPlugin.prototype.ValidatePropertyDialog = function()
{
	var valid = true;
	
	if($("input[id$='hdnIsTemplate']").val() == "false")
	{
		VP.ArticleEditor.Plugin.prototype.ValidatePropertyDialog.apply(this);
		var url = $("#txtTextFlashUrl", this._dialogPanel).val();
		var width = $("#txtTextFlashWidth", this._dialogPanel).val();
		var height = $("#txtTextFlashHeight", this._dialogPanel).val();
		
		if(url == "")
		{
			this.AddError("#txtTextFlashUrl", "Please enter the video id");
			valid = false;
		}
		
		if(width != "")
		{
			if(isNaN(width))
			{
				this.AddError("#txtTextFlashWidth", "Please enter a numeric value for width");
				valid = false;
			} 
		}
		else{
			 this.AddError("#txtTextFlashWidth", "Please enter a numeric value for width");
			 valid = false;
		}
		
		if(height != "")
		{
			if(isNaN(height))
			{
				this.AddError("#txtTextFlashHeight", "Please enter a numeric value for height");
				valid = false;
			} 
		}else
		{
			this.AddError("#txtTextFlashHeight", "Please enter a numeric value for height");
			valid = false;
		}
	}
	
	return valid;
};

VP.ArticleEditor.FlashPlugin.prototype.SaveProperties = function()
{ 
	VP.ArticleEditor.Plugin.prototype.SaveProperties.apply(this);
	var url = $("#txtTextFlashUrl", this._dialogPanel).val();
	var width = $("#txtTextFlashWidth", this._dialogPanel).val();
	var height = $("#txtTextFlashHeight", this._dialogPanel).val();
	var flashVars = $("#txtTextFlashVars", this._dialogPanel).val();
	
	this.Resource.Url = url;
	this.Resource.Width = width;
	this.Resource.Height = height;
	this.Resource.FlashVars = flashVars;
};