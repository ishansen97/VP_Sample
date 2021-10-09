VP.ArticleEditor.VideoPlugin = function()
{    
};

VP.ArticleEditor.VideoPlugin.ButtonClass = "wym_tools_video";
VP.ArticleEditor.VideoPlugin.PluginTypeName = "Video";
VP.ArticleEditor.VideoPlugin.PluginTypeId = "3";

VP.ArticleEditor.VideoPlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.VideoPlugin.prototype.PlaceholderImage = "Video.gif";

VP.ArticleEditor.VideoPlugin.prototype.InitPlugin = function(resourceCode, editor)
{    
	VP.ArticleEditor.Plugin.prototype.InitPlugin.apply(this);
	this.Resource = new VerticalPlatform.Core.Web.Dto.Articles.VideoResource();
	this.Resource.Id = 0;
	this.Resource.ResourceCode = resourceCode;
	this.Resource.VideoId = "";
	this.Resource.VideoLength = "";
	this.Resource.Width = "";
	this.Resource.Height = "";
	this.Resource.PlayerId = "";
	this.Resource.IsVideoListing = "false";
	this.Resource.ResourceType = 3;
	this._editor = editor;
};

VP.ArticleEditor.VideoPlugin.prototype.Load = function(resource)
{
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.Width = resource.Width;
	this.Resource.Height = resource.Height;
	this.Resource.VideoId = resource.VideoId;
	this.Resource.VideoLength = resource.VideoLength;
	this.Resource.PlayerId = resource.PlayerId;
	this.Resource.IsVideoListing = resource.IsVideoListing;
	this.Resource.ResourceType = resource.ResourceType;
};

VP.ArticleEditor.VideoPlugin.prototype.PreparePropertyDialog = function()
{
	VP.ArticleEditor.Plugin.prototype.PreparePropertyDialog.apply(this);
	var template = $("#PluginPropertyDialogTemplates #VideoPropertyDialog").clone();
	this._dialogPanel.append(template);
};

VP.ArticleEditor.VideoPlugin.prototype.PopulatePropertyDialog = function()
{
	VP.ArticleEditor.Plugin.prototype.PopulatePropertyDialog.apply(this);
	$("#txtVideoId", this._dialogPanel).val(this.Resource.VideoId);   
	$("#txtVideoLength", this._dialogPanel).val(this.Resource.VideoLength);
	$("#txtVideoWidth", this._dialogPanel).val(this.Resource.Width);
	$("#txtVideoHeight", this._dialogPanel).val(this.Resource.Height);   
	$("#txtVideoPlayerId", this._dialogPanel).val(this.Resource.PlayerId);   
	if(this.Resource.IsVideoListing)
	{
		$("#chkIsVideoListing", this._dialogPanel).attr('checked','checked'); 
	}
	else
	{
		$("#chkIsVideoListing", this._dialogPanel).removeAttr('checked');
	}
	
	if(this.Resource.IsAutoPlay)
	{
		$("#chkAutoPlay", this._dialogPanel).attr('checked','checked'); 
	}
	else
	{
		$("#chkAutoPlay", this._dialogPanel).removeAttr('checked');
	}
};

VP.ArticleEditor.VideoPlugin.prototype.ValidatePropertyDialog = function()
{
	var valid = true;
	
	if($("input[id$='hdnIsTemplate']").val() == "false")
	{
		VP.ArticleEditor.Plugin.prototype.ValidatePropertyDialog.apply(this);
		 
		var videoId = $("#txtVideoId", this._dialogPanel).val();
		var videoLength = $("#txtVideoLength", this._dialogPanel).val();
		var videoWidth = $("#txtVideoWidth", this._dialogPanel).val();
		var videoHeight = $("#txtVideoHeight", this._dialogPanel).val();
		var playerId = $("#txtVideoPlayerId", this._dialogPanel).val();
		
		var regularExpression = new RegExp("^(([0-9]*):([0-5][0-9]))$");
		
		if(videoId == "")
		{
			this.AddError("#txtVideoId", "Please enter the video id");
			valid = false;
		}
		
		if(videoLength == "")
		{
			this.AddError("#txtVideoLength", "Please enter the video length");
			valid = false;
		}
		else if(!regularExpression.test(videoLength))
		{
			this.AddError("#txtVideoLength", "Please enter Video Length in hh:mm format");
			valid = false;
		}
		
		if(playerId == "")
		{
			this.AddError("#txtVideoPlayerId", "Please enter the player id");
			valid = false;
		}
		
		if(videoWidth != "")
		{
			if(isNaN(videoWidth))
			{
				this.AddError("#txtVideoWidth", "Please enter a numeric value for width");
				valid = false;
			} 
		}
		else{
			 this.AddError("#txtVideoWidth", "Please enter a numeric value for width");
			 valid = false;
		}
		
		if(videoHeight != "")
		{
			if(isNaN(videoHeight))
			{
				this.AddError("#txtVideoHeight", "Please enter a numeric value for height");
				valid = false;
			} 
		}
		else 
		{
			this.AddError("#txtVideoHeight", "Please enter a numeric value for height");
			valid = false;
		}
	}
	
	return valid;
};

VP.ArticleEditor.VideoPlugin.prototype.SaveProperties = function()
{ 
	VP.ArticleEditor.Plugin.prototype.SaveProperties.apply(this);
	var videoId = $("#txtVideoId", this._dialogPanel).val();
	var videoLength = $("#txtVideoLength", this._dialogPanel).val();
	var videoWidth = $("#txtVideoWidth", this._dialogPanel).val();
	var videoHeight = $("#txtVideoHeight", this._dialogPanel).val();
	var playerId = $("#txtVideoPlayerId", this._dialogPanel).val();
	var isVideoListing = $("#chkIsVideoListing", this._dialogPanel).attr('checked');
	var isAutoPlay = $("#chkAutoPlay", this._dialogPanel).attr('checked');
	
	this.Resource.Width = videoWidth;
	this.Resource.Height = videoHeight;
	this.Resource.VideoId = videoId;
	this.Resource.VideoLength = videoLength;
	this.Resource.PlayerId = playerId;
	this.Resource.IsVideoListing = isVideoListing;
	this.Resource.IsAutoPlay = isAutoPlay;
	this.Resource.IsNewPlayer = isNewPlayer;
};