RegisterNamespace("VP.DeleteSubscription");
VP.DeleteSubscription.ModalDialog  = null;
var _fieldIds = null;

VP.DeleteSubscription = function(tabContainerInstanceId)
{
	this._tabContainerInstanceId = tabContainerInstanceId;
	this._tabContainerCssClass = "userMaintenanceTabContainer";
	this._deleteSubscriptionModule = "deleteSubscriptionModule";
	this._userProfileModule = "userProfile";
	this._userSubscriptionModule = "userSubscriptionModule";
	this._element = $("#divDeleteSubscription");
	var that = this;

	$("input[id$='btnDelete']", that._element).click(function()
	{
		_fieldIds =VP.DeleteSubscription.GetFieldIds();
		if (VP.DeleteSubscription.Validate(_fieldIds))
		{
			VP.DeleteSubscription.ShowConfirmUnsubscriptionDialog(that);
		}

	});

	$("input[id$='btnDeleteAll']", that._element).click(function()
	{
		var container = $("#divDeleteSubscription");
		$("#vBtnDelete", container).text("");
		_fieldIds = VP.DeleteSubscription.GetAllFieldIds();
		VP.DeleteSubscription.ShowConfirmUnsubscriptionDialog(that);
	});
};

VP.DeleteSubscription.GetFieldIds = function() 
{
	var chkDeleteNewsletter = $("input[id$='chkDeleteNewsletter']", this._element);
	var chkDeleteOptIn = $("input[id$='chkDeleteOptIn']", this._element);
	var chkDeleteTechnology = $("input[id$='chkDeleteTechnology']", this._element);
	var fieldIds = "";

	if (chkDeleteNewsletter != 'undefined' && chkDeleteNewsletter.attr('checked'))
	{
		fieldIds = $("input[id$='hdnDeleteNewsletter']", this._element).val();
	}

	if (chkDeleteOptIn != 'undefined' && chkDeleteOptIn.attr('checked'))
	{
		if (fieldIds != "") {
			fieldIds = fieldIds + "," + $("input[id$='hdnDeleteOptIn']", this._element).val();
		} else {
			fieldIds = $("input[id$='hdnDeleteOptIn']", this._element).val();
		}

	}

	if (chkDeleteTechnology != 'undefined' && chkDeleteTechnology.attr('checked'))
	{
		if (fieldIds != "")
		{
			fieldIds = fieldIds + "," + $("input[id$='hdnDeleteTechnology']", this._element).val();
		}
		else
		{
			fieldIds = $("input[id$='hdnDeleteTechnology']", this._element).val();
		}

	}

	return fieldIds;
};

VP.DeleteSubscription.GetAllFieldIds = function()
{
	var newsletterFieldIds = "";
	var optInFieldIds = "";
	var technologyFieldIds = "";
	var fieldIds = "";

	newsletterFieldIds = $("input[id$='hdnDeleteNewsletter']", this._element).val();
	optInFieldIds = $("input[id$='hdnDeleteOptIn']", this._element).val();
	technologyFieldIds = $("input[id$='hdnDeleteTechnology']", this._element).val();
	if (newsletterFieldIds == "-1")
	{
		newsletterFieldIds = "";
	}

	if (optInFieldIds == "-1")
	{
		optInFieldIds = "";
	}

	if (technologyFieldIds == "-1")
	{
		technologyFieldIds = "";
	}

	fieldIds = newsletterFieldIds +","+optInFieldIds+","+technologyFieldIds;
	return fieldIds;
};

VP.DeleteSubscription.ShowConfirmUnsubscriptionDialog = function(that)
{
	VP.DeleteSubscription.ShowDialog("30%");
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetConfirmUnsubscribeHtml",
		data: "{}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			VP.DeleteSubscription.ModalDialog.append(msg.d);
			VP.DeleteSubscription.BindToUnsubscriptionEvents(that);
		}
	});
};

VP.DeleteSubscription.DeleteUserSubscriptions = function (that) {
	$.ajax({
		type: "POST",
		dataType: "json",
		async: false,
		url: VP.AjaxWebServiceUrl + "/DeleteUserSubscriptions",
		data: "{'deleteSubscriptionFields':'" + _fieldIds + "'}",
		contentType: "application/json; charset=utf-8",
		success: function (msg) {
			VP.DeleteSubscription.HideDialog();
			VP.DeleteSubscription.ShowUnsubscriptionReasonDialog(that);
		}
	});
};

VP.DeleteSubscription.ShowUnsubscriptionReasonDialog = function(that)
{
	VP.DeleteSubscription.ShowDialog("30%");
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetUnsubscribeReasonHtml",
		data: "{}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			VP.DeleteSubscription.ModalDialog.append(msg.d);
			VP.DeleteSubscription.BindToUnsubscriptionReasonEvents(that);
			VP.DeleteSubscription.DisableTextArea();
		}
	});
};

VP.DeleteSubscription.ShowDialog = function(top)
{
	VP.DeleteSubscription.ModalDialog.empty();
	VP.DeleteSubscription.ModalDialog.css("top", top);
	VP.DeleteSubscription.ModalDialog.jqmShow();
};

VP.DeleteSubscription.HideDialog = function()
{
	VP.DeleteSubscription.ModalDialog.jqmHide();
};

VP.DeleteSubscription.BindToUnsubscriptionEvents = function(that)
{

	$("#btnUnsubscribe",VP.DeleteSubscription.ModalDialog).click(function()
	{
		VP.DeleteSubscription.DeleteUserSubscriptions(that);
	});
	$("#btnDontUnsubscribe",VP.DeleteSubscription.ModalDialog).click(function()
	{
		VP.DeleteSubscription.HideDialog();
	});
	$("#btnEditSubscription",VP.DeleteSubscription.ModalDialog).click(function()
	{
		that.SelectTab(that._userSubscriptionModule);
		VP.DeleteSubscription.HideDialog();
	});
	$("#CloseUnsubscriptionPopup", VP.DeleteSubscription.ModalDialog).click(function()
	{
		VP.DeleteSubscription.HideDialog();
	});
};

VP.DeleteSubscription.BindToUnsubscriptionReasonEvents = function (that) {
	$("#btnSubmitSubscriptionReason", VP.DeleteSubscription.ModalDialog).click(function () {
		if (VP.DeleteSubscription.ValidateReason()) {
			VP.DeleteSubscription.SaveUnsubscriptionReason();
			VP.DeleteSubscription.HideDialog();
			location.href = location.href;
		}

	});

	$('.rbFeedback').click(function () {
		$("#feedbacktext").val("");
		$("#vField").text("");
		$("#feedbacktext").attr("disabled", "disabled");

		if ($('input:radio[name=feedback]:checked').val() == "Other (fill in reason below)") {
			$("#feedbacktext").removeAttr("disabled");
		}
	});

};

VP.DeleteSubscription.SaveUnsubscriptionReason = function()
{
	var feedback = null;
	if ($('input:radio[name=feedback]:checked').val()== "Other (fill in reason below)")
	{
		feedback = $("#feedbacktext").val();
	}
	else
	{
		feedback = $('input:radio[name=feedback]:checked').val();
	}

	$.ajax({
		type: "POST",
		dataType: "json",
		async: false,
		url: VP.AjaxWebServiceUrl + "/SaveUnsubscriptionReason",
		data: "{'feedback':'" + feedback + "','fieldIds':'" + _fieldIds + "'}",
		contentType: "application/json; charset=utf-8",
		success: function(msg) {
		}
	});
};

VP.DeleteSubscription.prototype.SelectTab = function(divClass)
{
	var tabInstance = eval("tab" + this._tabContainerInstanceId);
	var tabHref;
	if ($('div.ui-tabs-panel div.' + divClass,tabInstance._element).parent('div.ui-tabs-panel').length > 0) {
		tabHref = "#" + $('div.ui-tabs-panel div.' + divClass,
				tabInstance._element).parent('div.ui-tabs-panel').attr('id');
		var tabIndex = this.GetTabIndex(tabHref);
		if (tabIndex > -1) {
			tabInstance.SelectTab($("." + this._tabContainerCssClass + " .tab"), tabIndex);
		}

	}

};

VP.DeleteSubscription.prototype.GetTabIndex = function(tabHref)
{
	var tabIndex = 0;

	var selectedIndex = $('.' + this._tabContainerCssClass + ' .tab ul:first').find('li a[href="' + tabHref +
			'"]').parent('li').index();
	if (selectedIndex > -1)
	{
		tabIndex = selectedIndex;
	}

	return tabIndex;
};

VP.DeleteSubscription.Validate = function(_fieldIds) {
	var isValid = true;
	var container = $("#divDeleteSubscription");
	$("#vBtnDelete", container).text("");
	if (_fieldIds == "") {
		$("#vBtnDelete", container).text("Please select at least one option.");
		isValid = false;
	}

	return isValid;
};

VP.DeleteSubscription.DisableTextArea = function() {
	$("#feedbacktext").attr("disabled","disabled");
};

VP.DeleteSubscription.ValidateReason = function() {
	var isValid = true;
	$("#vField").text("");
	if ($('input:radio[name=feedback]:checked').val()== "Other (fill in reason below)")
	{
		if ($("#feedbacktext").val() == "") {
			$("#vField").text("Please fill in the reason below.");
			isValid = false;
		}

	}
	return isValid;
};
