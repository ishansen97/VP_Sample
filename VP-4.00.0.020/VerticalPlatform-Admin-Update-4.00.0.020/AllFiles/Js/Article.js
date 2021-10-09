var siteId = "";
var txtTitleId = "";
var txtSummaryId = "";
var txtThumbnailImageCode = "";
var txtFixedUrlId = "";
var txtDatePublishedId = "";
var ddlArticleType = "";
var fuThumbnailImage = "";
var imgArticle = "";
var subTitleTextId = "";

var hdnSectionsExistId = "";
var hdnSectionId = "";
var txtSectionPageNumberId = "";
var txtSectionTitleId = "";
var txtSectionTextId = "";
var txtShortTitleId = "";

var imgSectionImageId = "";
var chkSectionImageId = "";

var modalPopupExtenderId = "";
var reorderListId = "";

var lbtnHiddenArticleSectionEditId = "";
var hdnIsArticleTemplate = "";

var txtSynopsisId = "";
var hdnSynopsisRequired = "";
var synopsisLength = 5000;
var shortTitleRequired = "False";

var fixedUrlRegex = /((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)$/;

var articleId = -1;

function ValidateArticle() {
	var errorMessage = "";

	if ($get(ddlArticleType).value === "-100") {
		errorMessage += "Please select an 'Article Type'. ";
	}
	
	if ($get(txtTitleId).value === "") {
		errorMessage += "Please enter the 'Title'. ";
	}

	if ($get(hdnIsArticleTemplate).value === "True" && errorMessage == "") {
		return true;
	}
	else if (($get(hdnIsArticleTemplate).value === "True")) {
		$.notify({ message: errorMessage });
		return false;
	}

	if ($get(fuThumbnailImage).value !== "" && $get(txtThumbnailImageCode).value === "") {
		errorMessage += "'Thumbnail Image Name' field can not be empty. ";
	}

	if (shortTitleRequired != "False") {
		var shortTitle = $("input[id$='txtShortTitle']");
		if (shortTitle.val() === "") {
			errorMessage += "Please enter 'Short Title'. ";
		}
	}

	if ($("input[id$='chkExternalArticle']").attr('checked')) {
		if ($("input[id$='txtExternalUrl']").val() === '') {
			errorMessage += "Please enter the 'External Url'. ";
		}
	}

	if ($("#" + txtDatePublishedId).val() === "") {
		errorMessage += "Please select the 'Date Published'. ";
	}

	var fixedUrl = $("input[id$='txtFixedUrl']");
	if (fixedUrl !== null) {
		var regularExpression = new RegExp(fixedUrlRegex);
		if (fixedUrl.val() === "") {
			errorMessage += "Please enter a 'Fixed URL'. ";
		}
		else if (fixedUrlRegex.test(fixedUrl.val())) {
			errorMessage += "Url should start with '/' and ends with '/'. It should only contain alpha numeric characters and '-'. Example '/id-article-name/'. ";
		}
	}

	var fixedUrlPassword = $("input[id$='txtFixedUrlPassword']");
	if (fixedUrlPassword.length > 0) {
		if (fixedUrlPassword.val().trim() !== "" && (fixedUrlPassword.val().trim().length < 6 ||
	fixedUrlPassword.val().trim().length > 25)) {
			errorMessage += "The 'Fixed Url Password' length should be between 6 to 25 characters.";
		}
	}

	var isSynopsisRequired = $("input[id$='hdnSynopsisRequired']").val();
	if (isSynopsisRequired === "True") {
		if ($("#" + txtSynopsisId).val() === "") {
			errorMessage += "Please enter the 'Synopsis'. ";
		}
	}

	if ($get(txtSynopsisId).value.lenght > synopsisLength) {
		errorMessage += "Please note that the 'Synopsis' length exceeds maximum limit (" + synopsisLength + " characters). ";
	}

	if ($get(txtSynopsisId).value.lenght > synopsisLength) {
		errorMessage += "Please note that the 'Synopsis' length exceeds maximum limit (" + synopsisLength + " characters). ";
	}

	var redirectEnabled = $("input[type=checkbox][id*=enableUrlRedirect]").attr('checked');
	var redirectUrl = $("input[type=text][id*=redirectUrl]").val().trim();

	if (redirectEnabled || redirectUrl.length > 0) {
		var urlValidator = new VP.UrlHelper.UrlValidator(redirectUrl);
		if (!urlValidator.ValidateAbsoluteOrRelativeUrl()) {
			errorMessage += "Please enter a valid url for redirect url eg. http://www.example.com/ or a relative url eg. /example/page/";
		}
	}

	if (errorMessage !== "") {
		$.notify({ message: errorMessage });
		return false;
	}
	else {
		return true;
	}
}

function EditArticle(index) {
	__doPostBack(lbtnHiddenArticleSectionEditId, index);

	return false;
}

$(document).ready(function () {
	$("input[id$='txtDatePublished']").datepicker(
	{
		changeYear: true
	});

	$("input[id$='txtStartDate']").datepicker(
	{
		changeYear: true
	});

	$("input[id$='txtEndDate']").datepicker(
	{
		changeYear: true
	});

	$(".ddlArticleTemplates").change(function() {
		var templateId = $(".ddlArticleTemplates").val();
		if (templateId > 0) {
			if (!confirm("Are you sure you want to apply this template?")) {
				$(".ddlArticleTemplates").val("-1");
			}
		}
	});

	$("input[id$='btnSave']").hide();
	$("input[id$='btnSaveAndEdit']").hide();

	if ($get(hdnIsArticleTemplate).value === "True") {
		$("input[id$='btnSaveArticle']").attr('value', 'Save Article Template');
	}

	$("input[id='btnSaveArticle']").click(function () {
		if (ValidateArticle()) {
			$("input[id='btnSaveArticle']").attr('disabled', 'disabled');
			$("input[id$='btnSave']").click();
		}
	});

	$("input[id='btnSaveAndEditSection']").click(function () {
		if (ValidateArticle()) {
			$("input[id='btnSaveAndEditSection']").attr('disabled', 'disabled');
			$("input[id$='btnSaveAndEdit']").click();
		}
	});

	var options = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", type: "Tag", showName: "true" };
	$("input[type=text][id*=txtSelectArticleTags]").contentPicker(options);

});

function ValidateSections(button) {
	var ret = true;
	if (confirm('Are you sure you want to ' + button.value + ' this article ?')) {
		this.article = null;
		var that = this;
		var ServiceUrl = "../../Services/ArticleEditorService.asmx/";
		articleId = $("input[id$='hdnArticleId']").val();

		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: ServiceUrl + "GetArticle",
			data: "{'articleId' : " + articleId + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				that.article = msg.d;
			},
			error: function(xmlHttpRequest, textStatus, errorThrown) {
				document.location("../../Error.aspx");
			}
		});

		var valicator = new VP.ArticleEditor.ArticleSectionValidator();
		if (!valicator.ValidateArticleSections(that.article)) {
			$.notify({ message: "This article has sections without data. Please edit them before publish." });
			ret = false;
		}
	}
	else {
		ret = false;
	}

	return ret;
}

function ValidateSynopsis() {
	var isSynopsisRequired = $("input[id$='hdnSynopsisRequired']").val();
	if (isSynopsisRequired === "True") {
		if ($("#" + txtSynopsisId).val() === "") {
			$.notify({ message: "Synopsis is required" });
		}
	}

	if ($("#" + txtSynopsisId).val().length > synopsisLength) {
		$.notify({ message: "'Synopsis' length exceeds maximum limit (" + synopsisLength + " characters)." });
		var synopsis = $("#" + txtSynopsisId).val().substring(0, 5000);
		$("#" + txtSynopsisId).val(synopsis);
	}
}
