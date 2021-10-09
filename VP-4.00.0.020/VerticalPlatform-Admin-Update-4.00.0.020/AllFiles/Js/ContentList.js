RegisterNamespace("VP.Controls.ContentList");

VP.Controls.ContentList = function() {
	this.contentTypeId = "";
	this.autoCompleteMethodPath = "";
	this.contentListDivId = "";
	this.element = "";
	this.categoryProductType = "";
}

VP.Controls.ContentList.prototype.Init = function() {
	var that = this;
	this.element = $("#" + this.contentListDivId);
	if (this.contentTypeId == 1) {
		this.autoCompleteMethodPath = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
		$(".contentValue", this.element).keyup(function(event) {
			that.GetCategoriesAutoComplete();
		});
	}
	else if (this.contentTypeId == 2) {
		this.autoCompleteMethodPath = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
		$(".contentValue", this.element).keyup(function(event) {
		that.GetContentsAutoComplete("Product");
		});
	}
	else if (this.contentTypeId == 4) {
		this.autoCompleteMethodPath = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
		$(".contentValue", this.element).keyup(function(event) {
			that.GetContentsAutoComplete("Article");
		});
	}
	else if (this.contentTypeId == 6) {
		this.autoCompleteMethodPath = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
		$(".contentValue", this.element).keyup(function(event) {
			that.GetContentsAutoComplete("Vendor");
		});
	}
	else if (this.contentTypeId == 10) {
		this.autoCompleteMethodPath = VP.ArticleEditorWebServiceUrl + "/GetFilesAutoComplete";
		$(".contentValue", this.element).keyup(function(event) {
			that.GetContentsAutoComplete();
		});
	}

	$(".contentValue", this.element).autocomplete({
		source: []
	});
}

VP.Controls.ContentList.prototype.GetContentsAutoComplete = function (contentType) {
	var that = this;
	try {
		if ($(".contentValue", this.element).val().trim() != "") {
			$(".contentValue", this.element).autocomplete({
				source: function (request, response) {
					var list = [];
					$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: that.autoCompleteMethodPath,
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'siteId' :" + VP.SiteId + ",'contentType' : '" + contentType + "', 'searchText' : '" + request.term + "', 'enabled' :" + null + ", 'vendorId' : " + null + "}",
						success: function (msg) {
							list = $.map(msg.d, function (n) {
								return {
									value: n.Id,
									label: n.Name + "(id=" + n.Id + ")"
								};
							});
						},
						error: function (xmlHttpRequest, textStatus, errorThrown) {
							document.location("../../Error.aspx");
						}
					});
					response(list);
				},
				select: function (event, ui) {
					$(".contentValue", that.element).val(ui.item.label);
					if ($(".contentId", that.element).length > 0) {
						$(".contentId", that.element).val(ui.item.value);
					}
					$("input:hidden", that.element).val(ui.item.value);
					return false;
				},
				focus: function (event, ui) {
					$(".contentValue", that.element).val(ui.item.label);
					return false;
				}
			});
		}
		else {
			$(".contentValue", this.element).autocomplete({
				source: []
			});
			$("input:hidden", that.element).val("");
			if ($(".contentId", that.element).length > 0) {
				$(".contentId", that.element).val("");
			}
		}

	} catch (e) {
	}
};

VP.Controls.ContentList.prototype.GetCategoriesAutoComplete = function() {
	var that = this;
	if (this.categoryProductType == 0) {
		this.categoryProductType = null;
	}
	try {
		if ($(".contentValue", this.element).val().trim() != "") {

			$(".contentValue", this.element).autocomplete({
				source: function(request, response) {
					var list = [];
					$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: that.autoCompleteMethodPath,
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'siteId' :" + VP.SiteId + ",'contentType' : 'Category', 'searchText' : '" + request.term + "', 'enabled' :" + null + "}",
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
					$(".contentValue", that.element).val(ui.item.label);
					if($(".contentId", that.element).length > 0){
						$(".contentId", that.element).val(ui.item.value);
					}
					$("input:hidden", that.element).val(ui.item.value);
					return false;
				},
				focus: function(event, ui) {
					$(".contentValue", that.element).val(ui.item.label);
					return false;
				}
			});
		}
		else {
			$(".contentValue", this.element).autocomplete({
				source: []
			});
			$("input:hidden", that.element).val("");
			if($(".contentId", that.element).length > 0){
				$(".contentId", that.element).val("");
			}
		}

	} catch (e) { }
};



