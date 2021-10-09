
VP.ArticleEditor.LeadFormResourceEditor = function() {
	VP.ArticleEditor.ResourceEditor.apply(this);
	this._urlRegexp = /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
};

VP.ArticleEditor.LeadFormResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.LeadFormResourceEditor.prototype.LoadEditor = function(element, parentId) {
	this._element = element;
	this._categoryId = -100;
	this._contentId = -100;
	
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	var that = this;
	this.DisplayResourceTypeName("Lead Form Resource");
	var html = $("#LeadFormResourceEditorTemplate").clone();
	$(this._element).append(html);
	
	var txtCategory = $(".txtCategory", this._element);
	var txtCategoryId = $(".txtCategoryId", this._element);
	var txtContent = $(".txtContent", this._element);
	var txtContentId = $(".txtContentId", this._element);
	var chkEnableOverlayPopupButton = $(".chkEnableOverlayPopupButton", this._element);
	var txtOverlayPopupButtonText = $(".txtOverlayPopupButtonText", this._element);
	
	txtCategory.keyup(function() {
		that.GetCategoryAutocomplete();
	});
	
	txtCategory.autocomplete({
		source: []
	});
	
	txtCategoryId.blur(function() {
		if(txtCategoryId.val() != "")
		{
			that._categoryId = txtCategoryId.val();
			that.GetCategoryById(that._categoryId);
			that.GetProducts(that._element);
		}
	});
	
	txtCategoryId.keydown(function() {
		that._categoryId = -100;
		that._contentId = -100;
		txtCategory.val("");
		txtContent.val("");
		txtContentId.val("");
	});
	
	txtCategoryId.keyup(function(){
		if(isNaN(txtCategoryId.val()))
		{
			txtCategoryId.val("");
		}
	});
	
	txtContent.keyup(function() {
		that.GetProducts(that._element);
	});
	txtContent.autocomplete({
		source: []
	});
	txtContent.focus(function() {
		that.GetCategoryById(that._categoryId);
	});
	
	txtContentId.blur(function() {
		if(txtContentId.val() != "")
		{
			that._contentId = txtContentId.val();
			that.GetProductById(that._categoryId, that._contentId);
		}
	});
	
	txtContentId.keydown(function() {
		txtContent.val("");
		that._contentId = -100;
	});
	
	txtContentId.keyup(function() {
		if(isNaN(txtContentId.val()))
		{
			txtContentId.val("");
			that._contentId = -100;
		}
	});

	if (this._resource != null) {
		this.PopulateLeadFormValues();
	}

	chkEnableOverlayPopupButton.change(function () {
		txtOverlayPopupButtonText.attr("disabled", !$(this).is(":checked"));
	});
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.PopulateLeadFormValues = function()
{
	var txtCategory = $(".txtCategory", this._element);
	var txtCategoryId = $(".txtCategoryId", this._element);
	var txtContent = $(".txtContent", this._element);
	var txtContentId = $(".txtContentId", this._element);
	
	if (typeof (this._resource.CategoryId) != 'undefined' && (this._resource.CategoryId != "")) {
		this.GetCategoryById(this._resource.CategoryId);
		this._categoryId = this._resource.CategoryId;
		if(this._resource.CategoryId != -100)
		{
			txtCategoryId.val(this._resource.CategoryId);
		}
	}
	else {
		txtCategory.val("");
	}
	if (typeof (this._resource.ContentIds) != 'undefined' && (this._resource.ContentIds != "")) {
		this.GetProductById(this._resource.CategoryId, this._resource.ContentIds);
		this._contentId = this._resource.ContentIds;
		
		if(this._resource.ContentIds != -100)
		{
			txtContentId.val(this._resource.ContentIds);
		}
	}
	else {
		txtContent.val("");
	}
	if (typeof (this._resource.LeadTypeId) != 'undefined') {
		$(".ddlLeadType", this._element).val(this._resource.LeadTypeId);
	}
	
	if(this._resource.EnableClientSidePaging)
	{
		$(".chkPaging", this._element).attr('checked', 'checked');
	}
	else
	{
		$(".chkPaging", this._element).removeAttr('checked');
	}
	
	if(this._resource.IsRegistrationRequired)
	{
		$(".chkUserRegistration", this._element).attr('checked', 'checked');
	}
	else
	{
		$(".chkUserRegistration", this._element).removeAttr('checked');
	}
	
	if(this._resource.SendConfirmationEmail)
	{
		$(".chkSendEmail", this._element).attr('checked', 'checked');
	}
	else
	{
		$(".chkSendEmail", this._element).removeAttr('checked');
	}
	
	if(typeof (this._resource.RedirectUrl) != 'undefined') 
	{
		$(".txtRedirectUrl", this._element).val(this._resource.RedirectUrl);
	}

	if (this._resource.EnableOverlayForm) {
	    $(".chkEnableOverlay", this._element).attr('checked', 'checked');
	}

	if (typeof (this._resource.OverlayFormTimeDelay) != 'undefined') {
	    $(".txtTimeDelayForOverlay", this._element).val(this._resource.OverlayFormTimeDelay);
	}

	if (typeof (this._resource.OverlayFormScrollHeight) != 'undefined') {
	    $(".txtScrollHeightForOverlay", this._element).val(this._resource.OverlayFormScrollHeight);
	}

	if (this._resource.EnableOverlayPopupButton) {
		$(".chkEnableOverlayPopupButton", this._element).attr('checked', 'checked');
	}

	if (typeof (this._resource.OverlayPopupButtonText) != 'undefined') {
		$(".txtOverlayPopupButtonText", this._element).val(this._resource.OverlayPopupButtonText).attr("disabled", !this._resource.EnableOverlayPopupButton);
  }

  if (typeof (this._resource.DownloadContentUrl) != 'undefined') {
    $(".txtDownloadContentUrl", this._element).val(this._resource.DownloadContentUrl);
	}

	if (typeof (this._resource.DownloadContentLinkText) != 'undefined') {
		$(".txtDownloadContentLinkText", this._element).val(this._resource.DownloadContentLinkText);
	}
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.GetProducts = function(element) {
	var that = this;
	try {
		var categoryId = this._categoryId;
		var txtContent = $("#txtContent", this._element);
		var txtContentId = $(".txtContentId", this._element);
		if (!isNaN(categoryId)) {
			txtContent.autocomplete({
				source: function(request, response) {
					var list = [];
					$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: VP.ArticleEditorWebServiceUrl + "/GetProducts",
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'text': '" + request.term + "', 'categoryId': " + categoryId + "}",
						success: function(msg) {
							list = $.map(msg.d, function(n) {
								return {
									value: n.Id,
									label: n.Name+"(id="+n.Id+")"
								};
							});
						},
						error: function(xmlHttpRequest, textStatus, errorThrown) {
							document.location("../../Error.aspx");
						}
					});
					response(list);
				},
				select: function(event, ui) {
					txtContentId.val(ui.item.value);
					txtContent.val(ui.item.label);
					that._contentId = ui.item.value;
					return false;
				},
				focus: function(event, ui) {
					txtContent.val(ui.item.label);
					return false;
				} 
			});
		}

	} catch (e) { }
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.Save = function() {
	try {
		VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
		this._resource.CategoryId = this._categoryId;
		this._resource.ContentIds = this._contentId;
		this._resource.LeadTypeId = $(".ddlLeadType", this._element).val();
		this._resource.EnableClientSidePaging = $(".chkPaging", this._element).attr("checked");
		this._resource.IsRegistrationRequired = $(".chkUserRegistration", this._element).attr("checked");
		this._resource.RedirectUrl = $(".txtRedirectUrl", this._element).val();
		this._resource.SendConfirmationEmail = $(".chkSendEmail", this._element).attr("checked");
		this._resource.EnableOverlayForm = $(".chkEnableOverlay", this._element).attr("checked");
		this._resource.OverlayFormTimeDelay = $(".txtTimeDelayForOverlay", this._element).val() || 0;
		this._resource.OverlayFormScrollHeight = $(".txtScrollHeightForOverlay", this._element).val() || 0;
		this._resource.EnableOverlayPopupButton = $(".chkEnableOverlayPopupButton", this._element).attr("checked");
    this._resource.OverlayPopupButtonText = $(".txtOverlayPopupButtonText", this._element).val();
		this._resource.DownloadContentUrl = $(".txtDownloadContentUrl", this._element).val();
		this._resource.DownloadContentLinkText = $(".txtDownloadContentLinkText", this._element).val();
	} catch (ex) { }
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.Validate = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);

	if (!isTemplate) {
		if (($("#txtCategory", this._element).val() == "") ||
				!(this._categoryId > 0)) {
			this._errors[this._errors.length] = "Please enter the 'Category'";
			ret = false;
		}
		if (($(".txtContent", this._element).val() == "") ||
				!(this._contentId > 0)) {
			this._errors[this._errors.length] = "Please enter the 'Product'";
			ret = false;
		}
		if($(".txtRedirectUrl", this._element).val() != "")
		{
			if(!this._urlRegexp.test($(".txtRedirectUrl", this._element).val()))
			{
				this._errors[this._errors.length] = "Please enter a valid 'Redirect URL after submitting the lead'";
				ret = false;
			}
		}
		if (isNaN($("#txtTimeDelayForOverlay").val())) {
		    this._errors[this._errors.length] = "Please enter a valid value for the 'time delay'";
		    ret = false;
		}
		if (isNaN($("#txtScrollHeightForOverlay").val())) {
	        this._errors[this._errors.length] = "Please enter a valid value for the 'scroll height'";
	        ret = false;
		}

		if ($(".chkEnableOverlay").is(":checked")) {
			if (!($("#txtTimeDelayForOverlay").val() > 0) && !($("#txtScrollHeightForOverlay").val() > 0) && !($(".txtOverlayPopupButtonText").val())) {
		        this._errors[this._errors.length] = "Please enter a value for Time Delay, Scroll Height or Overlay Button Text for Overlay-form";
		        ret = false;
		    }
		}

		if ($(".chkPaging").is(":checked") && $(".txtDownloadContentUrl", this._element).val() != "") {
			this._errors[this._errors.length] = "Client side paging cannot be enabled with downloadable content'";
			ret = false;
		}
	}

	return ret;
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.GetCategoryAutocomplete = function() {
	try {
		var that = this;
		var txtCategory = $("#txtCategory", this._element);
		var txtCategoryId = $(".txtCategoryId", this._element);
		var txtContentId = $("#txtContentId", this._element);
		var txtContent = $(".txtContent", this._element);
		if (txtCategory.val().trim() != "") {
			txtCategory.autocomplete({
				source: function(request, response) {
					var list = [];
					$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults",
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'siteId' :" + VP.SiteId + ",'contentType' : 'Category', 'searchText' : '" + request.term + "', 'enabled' :" + null + ", 'vendorId' : " + null + "}",
						success: function(msg) {
							list = $.map(msg.d, function(n) {
								return {
									value: n.Id,
									label: n.Name + "(id=" + n.Id + ")"
								};
							});
						},
						error: function(xmlHttpRequest, textStatus, errorThrown) {
							document.location("../../Error.aspx");
						}
					});
					response(list);
				},
				select: function(event, ui) {
					txtContentId.val("");
					txtContent.val("");
					that._contentId = -100;
					txtCategory.val(ui.item.label);
					that._categoryId = ui.item.value;
					txtCategoryId.val(ui.item.value);
					return false;
				},
				focus: function(event, ui) {
					txtCategory.val(ui.item.label);
					return false;
				}
			});
			$("#txtProduct", this._element).val("");
			this._contentId = -100;
		}
		else {
			that._categoryId = -100;
		}
	} catch (e) { }
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.GetCategoryById = function(categoryId) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.ArticleEditorWebServiceUrl + "/GetCategoryById",
		data: "{'categoryId' : " + categoryId + ", 'siteId' : " + VP.SiteId + " }",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			$(".txtCategory", that._element).val(msg.d);
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location("../../Error.aspx");
		}
	});
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.GetProductById = function(categoryId, ContentIds) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.ArticleEditorWebServiceUrl + "/GetProduct",
		data: "{'productId' : " + ContentIds + ", 'categoryId' : " + categoryId + ", 'siteId': " + VP.SiteId + " }",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			$("#txtContent", that._element).val(msg.d);
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location("../../Error.aspx");
		}
	});
}

VP.ArticleEditor.LeadFormResourceEditor.prototype.ValidateResourceObject = function(isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	if (!isTemplate) {
		if (this._resource.CategoryId <= 0) {
			ret = false;
		}
		if (this._resource.ContentIds <= 0) {
			ret = false;
		}
		
		if(this._resource.RedirectUrl != "")
		{
			if(!this._urlRegexp.test(this._resource.RedirectUrl))
			{
				ret = false;
			}
		}
	}
	return ret;
}
