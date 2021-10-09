

VP.ArticleEditor.LinkResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.LinkResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.LinkResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Link Section");
	var html = $("#LinkResourceEditorTemplate").clone();
	var that = this;
	$(this._element).append(html);
	if (this._resource != null) {
		if (typeof (this._resource.Url) != 'undefined') {
			$(".txtUrl", this._element).val(this._resource.Url);
		}
		else {
			$(".txtUrl", this._element).val("http://");
		}
		if (typeof (this._resource.Text) != 'undefined') {
			$(".txtText", this._element).val(this._resource.Text);
		}
		if (typeof (this._resource.Title) != 'undefined') {
			$(".txtTitle", this._element).val(this._resource.Title);
		}
		if (typeof (this._resource.CustomCss) != 'undefined') {
			$(".txtCustomCss", this._element).val(this._resource.CustomCss);
		}

		if (typeof (this._resource.LinkImage) != 'undefined') {
			$(".txtLinkImage", this._element).val(this._resource.LinkImage);
		}
		if (this._resource.IsInternalLink) {
			$(".chkIsInternalLink", this._element).attr('checked', 'checked');
		}

		if (typeof (this._resource.IsOpenInNewWindow) != 'undefined') {
			if (this._resource.IsOpenInNewWindow) {
				$(".chkIsOpenInNewWindow", this._element).attr('checked', 'checked');
			}
		}
		else {
			$(".chkIsOpenInNewWindow", this._element).attr('checked', 'checked');
		}

		if (typeof (this._resource.IsNoFollowLink) != 'undefined') {
			if (this._resource.IsNoFollowLink) {
				$(".nofollowCheck", this._element).attr('checked', 'checked');
			}
		}
		else {
			var defaultNoFollow = this.GetDefaultIsNoFollow();
			if (defaultNoFollow) {
				$(".nofollowCheck", this._element).attr('checked', 'checked');
			}
		}

		this.GetFixedUrlId();

		$(".ddlLinkResourceCssClass", this._element).change(function () {
			if ($(".ddlLinkResourceCssClass", that._element).val() > 0) {
				$(".txtCustomCss", that._element).
						val($('option:selected', $(".ddlLinkResourceCssClass", that._element)).text());
			}
		});

		$(".txtUrl", this._element).blur(function () {
			that.GetFixedUrlId();
		});
	}

	$(".txtText", this._element).AddTagPicker();
	$(".txtTitle", this._element).AddTagPicker();
	$(".txtLinkImage", this._element).AddTagPicker();
	$(".txtUrl", this._element).AddTagPicker();
};

VP.ArticleEditor.LinkResourceEditor.prototype.Save = function () {
	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.Url = $(".txtUrl", this._element).val();
	this._resource.Text = $(".txtText", this._element).val();
	this._resource.Title = $(".txtTitle", this._element).val();
	this._resource.CustomCss = $(".txtCustomCss", this._element).val();
	this._resource.LinkImage = $(".txtLinkImage", this._element).val().trim();
	this._resource.IsInternalLink = $(".chkIsInternalLink", this._element).attr('checked');
	this._resource.IsOpenInNewWindow = $(".chkIsOpenInNewWindow", this._element).attr('checked');
	this._resource.IsNoFollowLink = $(".nofollowCheck", this._element).attr('checked');
	if (typeof (VP.ArticleEditor.LinkResourceEditor.UrlId) == 'undefined') {
		VP.ArticleEditor.LinkResourceEditor.UrlId = -100;
	}
	this._resource.UrlId = VP.ArticleEditor.LinkResourceEditor.UrlId;
};

VP.ArticleEditor.LinkResourceEditor.prototype.Validate = function (isTemplate) {
	var that = this;
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);

	if (!isTemplate) {
		this.GetFixedUrlId();
		var url = $(".txtUrl", this._element).val();
		url = url.replace("http://", "").trim();
		if (url == "") {
			this._errors[this._errors.length] = "Please enter the external 'URL'";
			ret = false;
		}
		if ($(".txtText", this._element).val() == "") {
			this._errors[this._errors.length] = "Please enter the URL 'Text'";
			ret = false;
		}
		if ($(".txtTitle", this._element).val() == "") {
			this._errors[this._errors.length] = "Please enter the URL 'Title'";
			ret = false;
		}
		if (!(VP.ArticleEditor.LinkResourceEditor.UrlId > 0) && ($(".chkIsInternalLink", this._element).attr('checked'))) {
			this._errors[this._errors.length] = "Please enter valid 'URL'";
			ret = false;
		}
	}

	return ret;
};

VP.ArticleEditor.LinkResourceEditor.prototype.GetFixedUrlId = function () {

	if ($(".chkIsInternalLink", this._element).attr('checked') && $(".txtUrl", this._element).val() != "") {
		serviceUrl = "../../Services/ArticleEditorService.asmx/";
		var fixedUrl = $(".txtUrl", this._element).val();
		fixedUrl = fixedUrl.replace("http://", "");
		var that = this;
		var siteId = $("input[id$='hdnSiteId']").val();
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: serviceUrl + "GetFixedUrlIdAndTitle",
			data: "{'internalUrl' : '" + fixedUrl + "','siteId' : '" + siteId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				var urlDetails = msg.d;
				if (urlDetails.length > 0) {
					VP.ArticleEditor.LinkResourceEditor.UrlId = urlDetails[0];
					if (urlDetails.length > 1) {
						$(".txtTitle", that._element).val(urlDetails[1]);
					}
				}
			},
			error: function (xmlHttpRequest, textStatus, errorThrown) {
				document.location("../../Error.aspx");
			}
		});
	}
};

VP.ArticleEditor.LinkResourceEditor.prototype.ValidateResourceObject = function (isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate) {
		if (this._resource.Url == "") {
			ret = false;
		}
		if (this._resource.Text == "") {
			ret = false;
		}
		if (this._resource.Title == "") {
			ret = false;
		}
		if ((this._resource.UrlId <= 0) && (this._resource.IsInternalLink)) {
			ret = false;
		}
	}

	return ret;
};

VP.ArticleEditor.LinkResourceEditor.prototype.GetDefaultIsNoFollow = function () {
	var defaultNoFollow = false;
	var articleId = $("input[id$='hdnArticleId']", window.parent.document)[0].value;
	serviceUrl = "../../../../../Services/ArticleEditorService.asmx/";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: serviceUrl + "GetDefaultIsEnableNoFollow",
		data: "{'articleId' : '" + articleId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			defaultNoFollow = msg.d;
		}
	});

	return defaultNoFollow;
};
