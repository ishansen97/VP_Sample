RegisterNamespace("VP.Forms.LeadForm");

VP.Forms.LeadForm.ValidateLeadSubmit = function (isAll, pageId, btnId, btnHiddenLeadSubmit) {
	var ie9 = false;
	var ie10 = false;
	var ie11 = false;
	var edge = false;
	if (navigator.appName == 'Netscape' || navigator.appName == 'Microsoft Internet Explorer') {
		var ua = navigator.userAgent;
		var re = new RegExp("MSIE 9.0");
		if (re.exec(ua) != null) {
			ie9 = true;
		}

		re = new RegExp("MSIE 10.0");
		if (re.exec(ua) != null) {
			ie10 = true;
		}

		re = new RegExp("Trident/7.0"); ///Denotes IE 11
		if (re.exec(ua) != null) {
			ie11 = true;
		}

		re = new RegExp("Edge"); ///Denotes Edge
		if (re.exec(ua) != null) {
			edge = true;
		}
	}

	if (ie9 || ie10 || ie11 || edge) {
		var isValidate = VP.Forms.BaseForm.Validate(isAll, pageId);
		if (isValidate) {
			return true;
		}
		else {
			return false;
		}
	}
	else {
		$("#" + pageId).find("#" + btnId).attr('disabled', 'disabled').addClass('disabled');
		var isValidate = VP.Forms.BaseForm.Validate(isAll, pageId);
		if (isValidate) {
			$("#" + btnHiddenLeadSubmit).click();
			return false;
		}
		else {
			$("#" + pageId).find("#" + btnId).removeAttr('disabled').removeClass('disabled');
			return false;
		}
	}
};

VP.Forms.LeadForm.CheckEmail = function (id) {
	var email = $("#" + id).val();
	if (email != "") {
		var regularExpression = new RegExp(VP.EmailRegEx);
		if (email.match(regularExpression)) {
			var isEmailExist = VP.Forms.BaseForm.CheckEmail(email);
			if (isEmailExist) {
				try {
					VP.Login.ShowLoginDialog(email);
				}
				catch (err) {
				}
			}
		}
	}
};

VP.Forms.LeadForm.ValidateSelectedProductList = function (listId, parentId, requiredErrorMessage) {
	return VP.Forms.BaseForm.ValidateCheckboxlistInput("", listId, requiredErrorMessage, "");
};

VP.Forms.LeadForm.ToggleMoreProducts = function () {
	var moreProductsDiv = $(".leadFormMoreProductList");
	var moreItemsLink = $(".leadFormMoreProductListMoreLink");
	if (moreProductsDiv !== undefined && moreItemsLink !== undefined) {
		moreProductsDiv.slideToggle(500, function () {
			moreItemsLink.text(function () {
				return moreProductsDiv.is(":visible") ? "Less" : "More";
			});
		});
	}
};