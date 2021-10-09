VP.ArticleEditor.Plugin = function () {
};

VP.ArticleEditor.Plugin.prototype.InitPlugin = function () {
	this._errors = new Array();
	this.saved = false;
	this._lastPlugin = null;
	this._base = null;
};
VP.ArticleEditor.Plugin.prototype.PlaceholderImage = "Plugin.png";
VP.ArticleEditor.Plugin.prototype.PluginTypeName = "";

// EmbeddedCodePlugin class
VP.ArticleEditor.EmbeddedCodePlugin = function () {
};

VP.ArticleEditor.EmbeddedCodePlugin.PluginTypeId = "5";

VP.ArticleEditor.EmbeddedCodePlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);
VP.ArticleEditor.EmbeddedCodePlugin.prototype.PlaceholderImage = "embad.jpg";
VP.ArticleEditor.EmbeddedCodePlugin.prototype.PluginTypeName = "EmbeddedCode";

VP.ArticleEditor.EmbeddedCodePlugin.prototype.InitPlugin = function (resourceCode) {
	VP.ArticleEditor.Plugin.prototype.InitPlugin.apply(this);
	this.Resource = new VerticalPlatform.Core.Web.Dto.Articles.EmbeddedCodeResource();
	this.Resource.Id = 0;
	this.Resource.ResourceCode = resourceCode;
	this.Resource.EmbeddedCode = "";
	this.Resource.ResourceType = 5;
};

VP.ArticleEditor.EmbeddedCodePlugin.prototype.Load = function (resource) {
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.EmbeddedCode = resource.EmbeddedCode;
	this.Resource.ResourceType = resource.ResourceType;
};

// VideoPlugin class
VP.ArticleEditor.VideoPlugin = function () {
};

VP.ArticleEditor.VideoPlugin.PluginTypeId = "3";

VP.ArticleEditor.VideoPlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.VideoPlugin.prototype.PlaceholderImage = "video.gif";
VP.ArticleEditor.VideoPlugin.prototype.PluginTypeName = "Video";

VP.ArticleEditor.VideoPlugin.prototype.InitPlugin = function (resourceCode) {
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
};

VP.ArticleEditor.VideoPlugin.prototype.Load = function (resource) {
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

// LinkPlugin class
VP.ArticleEditor.LinkPlugin = function () {
};
 
VP.ArticleEditor.LinkPlugin.PluginTypeId = "1";

VP.ArticleEditor.LinkPlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.LinkPlugin.prototype.PlaceholderImage = "link.gif";
VP.ArticleEditor.LinkPlugin.prototype.PluginTypeName = "Link";

VP.ArticleEditor.LinkPlugin.prototype.InitPlugin = function (resourceCode) {
	VP.ArticleEditor.Plugin.prototype.InitPlugin.apply(this);
	this.Resource = new VerticalPlatform.Core.Web.Dto.Articles.LinkResource();
	this.Resource.Id = 0;
	this.Resource.ResourceCode = resourceCode;
	this.Resource.Url = "http://";
	this.Resource.IsInternalLink = false;
	this.Resource.Text = "";
	this.Resource.Title = "";
	this.Resource.IsOpenInNewWindow = true;
	this.Resource.CustomCss = "";
	this.Resource.LinkImage = "";
	this.Resource.IsNoFollowLink = true;
	this.Resource.UrlId = 0;
	this.Resource.ResourceType = 1;
};

VP.ArticleEditor.LinkPlugin.prototype.Load = function (resource) {
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.Url = resource.Url;
	this.Resource.IsInternalLink = resource.IsInternalLink;
	this.Resource.Text = resource.Text;
	this.Resource.Title = resource.Title;
	this.Resource.IsOpenInNewWindow = resource.IsOpenInNewWindow;
	this.Resource.CustomCss = resource.CustomCss;
	this.Resource.LinkImage = resource.LinkImage;
	this.Resource.IsNoFollowLink = resource.IsNoFollowLink;
	this.Resource.UrlId = resource.UrlId;
	this.Resource.ResourceType = resource.ResourceType;
};

// ImagePlugin class
VP.ArticleEditor.ImagePlugin = function () {
};
 
VP.ArticleEditor.ImagePlugin.PluginTypeId = "2";

VP.ArticleEditor.ImagePlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.ImagePlugin.prototype.PlaceholderImage = "image.gif";
VP.ArticleEditor.ImagePlugin.prototype.PluginTypeName = "Image";

VP.ArticleEditor.ImagePlugin.prototype.InitPlugin = function (resourceCode) {
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
	this.Resource.ImageFigure = "";
	this.Resource.ImageZoom = "";
};

VP.ArticleEditor.ImagePlugin.prototype.Load = function (resource) {
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.ImageName = resource.ImageName;
	this.Resource.Width = resource.Width;
	this.Resource.Height = resource.Height;
	this.Resource.ImageCustomCss = resource.ImageCustomCss;
	this.Resource.ImageAltTag = resource.ImageAltTag;
	this.Resource.ResourceType = resource.ResourceType;
	this.Resource.ImageFigure = resource.ImageFigure;
	this.Resource.ImageZoom = resource.ImageZoom;
};

// FlashPlugin class
VP.ArticleEditor.FlashPlugin = function () {
};

VP.ArticleEditor.FlashPlugin.PluginTypeId = "4";

VP.ArticleEditor.FlashPlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.FlashPlugin.prototype.PlaceholderImage = "flash.gif";
VP.ArticleEditor.FlashPlugin.prototype.PluginTypeName = "Flash";

VP.ArticleEditor.FlashPlugin.prototype.InitPlugin = function (resourceCode, editor) {
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

VP.ArticleEditor.FlashPlugin.prototype.Load = function (resource) {
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.Url = resource.Url;
	this.Resource.Width = resource.Width;
	this.Resource.Height = resource.Height;
	this.Resource.FlashVars = resource.FlashVars;
	this.Resource.ResourceType = resource.ResourceType;
};
