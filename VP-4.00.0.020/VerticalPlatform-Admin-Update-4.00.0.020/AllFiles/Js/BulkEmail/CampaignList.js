RegisterNamespace("VP.Campaign");

$(document).ready(function () {

	var articleOptions = { siteId: VP.SiteId, pageIndex: 1, pageSize: 10, displaySites:true, displayArticleTypes:true, type :'Article'};
	$('input[type=text][id*=associatedArticleSearch]').contentPicker(articleOptions);
	$("input[type=text][id*=scheduledDateTxt]").datepicker();

	var vendorElement = { contentId: "vendorTxt" };
	var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true", bindings: vendorElement };
	$("input[type=text][id*=vendorTxt]").contentPicker(vendorNameOptions);

	$(".campaign_srh_btn").click(function () {
		$(".campaign_srh_pane").toggle("slow");
		$(this).toggleClass("hide_icon");
		$("#divSearchCriteria").toggleClass("hide");
	});

	$(".campaignRow .Click_btn", this).click(function () {
		var summaryDiv = $(this).parent().next().find('div.content_div');
		var campaignId = $(this).next().text();

		if ($(summaryDiv).children().length == 0) {
			VP.Campaign.Summary(campaignId, summaryDiv);
		}

		$(this).parent().next().toggleClass("expanded");
		$(this).toggleClass("collaps_icon");
	});

	if (VP.Campaign.ShowFilter) {
		$(".campaign_srh_pane").css("display", "block");
		$(".campaign_srh_btn").addClass("hide_icon");
		$("#divSearchCriteria").hide();
	}

	$("#divSearchCriteria").append(VP.Campaign.GetSearchCriteriaText());

	$('input[value="statusSuccess"]').parent().parent().addClass('statusSuccess');
	$('input[value="statusError"]').parent().parent().addClass('statusError');
});

VP.Campaign.Summary = function (campaignId, summaryDiv) {
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.ApplicationRoot + "Services/BulkEmailWebService.asmx" + "/GetCampaignSummary",
		data: "{'campaignId' : " + campaignId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			$(summaryDiv).html(msg.d);
		},
		error: function (xmlHttpRequest, textStatus, errorThrown) {
			document.location = "../../Error.aspx";
		}
	});
};

VP.Campaign.Preview = function (campaignId, campaignIdKey, templateTypeKey, templateType) {
	var previewWindow = window.open('CampaignPreview.aspx?' + campaignIdKey + '=' + campaignId + '&' + templateTypeKey + '=' + templateType,
					'Preview', 'location=0,status=1,scrollbars=1,width=700,height=600,toolbar=0,menubar=0,resizable=1');
	if (previewWindow) {
		previewWindow.focus();
	}
};

VP.Campaign.Deploy = function (campaignId, campaignIdKey) {
	var progressWindow = window.open('CampaignDeployProgress.aspx?' + campaignIdKey + '=' + campaignId,
					'Deploy', 'location=0,status=1,scrollbars=1,width=400,height=500,toolbar=0,menubar=0,resizable=1');
	if (progressWindow) {
		progressWindow.focus();
	}
};

VP.Campaign.GetSearchCriteriaText = function () {
	var ddlType = $("select[id$='ddlCampaignType']");
	var ddlStatus = $("select[id$='ddlStatus']");
	var ddlVisibility = $("select[id$='ddlVisibility']");
	var txtName = $("input[id$='txtCampaignName']");
	var ddlCampaignYear = $("select[id$='ddlCampaignYear']");
	var txtId = $("input[id$='txtCampaignId']");
	var txtArticle = $("input[id$='associatedArticleSearch']");

	var searchHtml = "";
	if (ddlType.val() != "-1") {
		searchHtml += " ; <b>Type</b> : " + $("option[selected]", ddlType).text();
	}
	if (ddlCampaignYear.val() != "-1") {
		searchHtml += " ; <b>Scheduled Year</b> : " + $("option[selected]", ddlCampaignYear).text();
	}
	if (txtId.val().trim().length > 0) {
		searchHtml += " ; <b>Id</b> : " + txtId.val().trim();
	}
	if (txtName.val().trim().length > 0) {
		searchHtml += " ; <b>Name</b> : " + txtName.val().trim();
	}
	if (ddlStatus.val() != "-1") {
		searchHtml += " ; <b>Status</b> : " + $("option[selected]", ddlStatus).text();
	}
	if (ddlVisibility.val() != "-1") {
		searchHtml += " ; <b>Visibility</b> : " + $("option[selected]", ddlVisibility).text();
	}
	if (txtArticle.val().trim().length > 0) {
		searchHtml += " ; <b>Article</b> : " + txtArticle.val().trim();
	}

	searchHtml = searchHtml.replace(' ;', '(');

	if (searchHtml.length > 0) {
		searchHtml += " )";
	}
	
	return searchHtml;
};