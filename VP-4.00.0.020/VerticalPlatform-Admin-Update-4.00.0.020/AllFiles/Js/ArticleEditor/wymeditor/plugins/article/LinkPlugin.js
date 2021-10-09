
VP.ArticleEditor.LinkPlugin = function() {
};

VP.ArticleEditor.LinkPlugin.ButtonClass = "wym_tools_link";
VP.ArticleEditor.LinkPlugin.PluginTypeName = "Link";
VP.ArticleEditor.LinkPlugin.PluginTypeId = "1";

VP.ArticleEditor.LinkPlugin.prototype = Object.create(VP.ArticleEditor.Plugin.prototype);

VP.ArticleEditor.LinkPlugin.prototype.PlaceholderImage = "link.gif";

VP.ArticleEditor.LinkPlugin.prototype.InitPlugin = function(resourceCode, editor) {
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
	this.Resource.UrlId = 0;
	this.Resource.ResourceType = 1;
	this._editor = editor;
};

VP.ArticleEditor.LinkPlugin.prototype.Load = function(resource) {
	this.Resource.Id = resource.Id;
	this.Resource.ResourceCode = resource.ResourceCode;
	this.Resource.Url = resource.Url;
	this.Resource.IsInternalLink = resource.IsInternalLink;
	this.Resource.Text = resource.Text;
	this.Resource.Title = resource.Title;
	this.Resource.IsOpenInNewWindow = resource.IsOpenInNewWindow;
	this.Resource.CustomCss = resource.CustomCss;
	this.Resource.LinkImage = resource.LinkImage;
	this.Resource.UrlId = resource.UrlId;
	this.Resource.ResourceType = resource.ResourceType;
};

VP.ArticleEditor.LinkPlugin.prototype.PreparePropertyDialog = function() {
	VP.ArticleEditor.Plugin.prototype.PreparePropertyDialog.apply(this);
	var template = $("#PluginPropertyDialogTemplates #LinkPropertyDialog").clone();
	$("#PluginPropertyDialogPane").append(template);
}

VP.ArticleEditor.LinkPlugin.prototype.PopulatePropertyDialog = function(text) {
	VP.ArticleEditor.Plugin.prototype.PopulatePropertyDialog.apply(this);
	$("#txtUrl", this._dialogPanel).val(this.Resource.Url);
	var that = this;
	if (this.Resource.IsInternalLink) {
		$("#chkIsInternalLink", this._dialogPanel).attr('checked', 'checked');
	}
	if ((typeof (text) != 'undefined') && (text != null) && (text != "")) {
		$("#txtText", this._dialogPanel).val(text);
	}
	else {
		$("#txtText", this._dialogPanel).val(this.Resource.Text);
	}
	$("#txtTitle", this._dialogPanel).val(this.Resource.Title);
	if (this.Resource.IsOpenInNewWindow) {
		$("#chkIsOpenInNewWindow", this._dialogPanel).attr('checked', 'checked');
	}
	$("#txtCustomCss", this._dialogPanel).val(this.Resource.CustomCss);
	$("#txtLinkImage", this._dialogPanel).val(this.Resource.LinkImage);

	$(".ddlLinkPluginCssClass", this._dialogPanel).change(function() {
		if ($(".ddlLinkPluginCssClass", that._dialogPanel).val() > 0) {
			$("#txtCustomCss", that._dialogPanel).val($('option:selected', $(".ddlLinkPluginCssClass", that._dialogPanel)).text());
		}
	});

	VP.ArticleEditor.LinkPlugin.GetFixedUrlId();
};

VP.ArticleEditor.LinkPlugin.prototype.ValidatePropertyDialog = function() {
	var valid = true;
	if($("input[id$='hdnIsTemplate']").val() == "false")
	{
		VP.ArticleEditor.Plugin.prototype.ValidatePropertyDialog.apply(this);
		VP.ArticleEditor.LinkPlugin.GetFixedUrlId();

		var url = $("#txtUrl", this._dialogPanel).val();
		url = url.replace("http://", "").trim();
		if (url == "") {
			this.AddError("LinkUrl", "Please enter url");
			valid = false;
		}
		var text = $("#txtText", this._dialogPanel).val();
		if (text == "") {
			this.AddError("LinkText", "Please enter url text");
			valid = false;
		}
		var title = $("#txtTitle", this._dialogPanel).val();
		if (title == "") {
			this.AddError("LinkTitle", "Please enter url title");
			valid = false;
		}
		if (!(VP.ArticleEditor.LinkPlugin.UrlId > 0) && ($("#chkIsInternalLink", this._dialogPanel).attr('checked'))) {
			this.AddError("LinkUrlId", "Please enter valid Url");
			valid = false;
		}
	}
	
	return valid;
};

VP.ArticleEditor.LinkPlugin.prototype.SaveProperties = function() {
	VP.ArticleEditor.Plugin.prototype.SaveProperties.apply(this);
	var url = $("#txtUrl", this._dialogPanel).val();
	var text = $("#txtText", this._dialogPanel).val();
	var title = $("#txtTitle", this._dialogPanel).val();
	var customCss = $("#txtCustomCss", this._dialogPanel).val();
	var linkImage = $("#txtLinkImage", this._dialogPanel).val().trim();
	var isInternalLink = $("#chkIsInternalLink", this._dialogPanel).attr('checked');
	var isOpenInNewWindow = $("#chkIsOpenInNewWindow", this._dialogPanel).attr('checked');

	this.Resource.Url = url;
	this.Resource.IsInternalLink = isInternalLink;
	this.Resource.Text = text;
	this.Resource.Title = title;
	this.Resource.IsOpenInNewWindow = isOpenInNewWindow;
	this.Resource.CustomCss = customCss;
	this.Resource.linkImage = linkImage;


	if (typeof (VP.ArticleEditor.LinkPlugin.UrlId) == 'undefined') {
		VP.ArticleEditor.LinkPlugin.UrlId = -100;
	}
	this.Resource.UrlId = VP.ArticleEditor.LinkPlugin.UrlId;
};

VP.ArticleEditor.LinkPlugin.GetFixedUrlId = function() {

	if ($("#chkIsInternalLink", this._dialogPanel).attr('checked') && $("#txtUrl", this._dialogPanel).val() != "") {
		serviceUrl = "../../Services/ArticleEditorService.asmx/";
		var fixedUrl = $("#txtUrl", this._dialogPanel).val();
		fixedUrl = fixedUrl.replace("http://", "");
		var that = this;
		var siteId = $("input[id$='hdnSiteId']")[0].value;
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: serviceUrl + "GetFixedUrlIdAndTitle",
			data: "{'internalUrl' : '" + fixedUrl + "','siteId' : '" + siteId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				var urlDetails = msg.d;
				if (urlDetails.length > 0) {
					VP.ArticleEditor.LinkPlugin.UrlId = urlDetails[0];
					if (urlDetails.length > 1) {
						$("#txtTitle", this._dialogPanel).val(urlDetails[1]);
					}
				}
			},
			error: function(xmlHttpRequest, textStatus, errorThrown) {
				document.location("../../Error.aspx");
			}
		});
	}
}