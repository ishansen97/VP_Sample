RegisterNamespace("VP.Search");

var showSearchResults = false;
var minSearchLength = 3;
var latestSearch = "";

$(document).ready(function ()
{
    $("#txtSearchFor").keypress(function(event) {
			if (event.which == 13) {
				VP.Search.SearchFor();
				event.returnValue = false;
				event.cancel = true;
				event.keyCode = 0;
				return false;
			}
		});

		$("#txtSearchFor").keyup(function (event) {
			if (event.which != 13) {
				if (VP.Search.FormatSearchText().length > minSearchLength) {
					$(".autoCompleteSpinner").show();
				}
				latestSearch = VP.Search.RemoveSpecialCharacters();
				VP.Search.AutoCompleteResults();
			}
		});

		if ($(".autoCompleteContainer").length > 0) {
			$(".autoCompleteContainer").hover(function () {
				showSearchResults = true;
			}, function () {
				showSearchResults = false;
			});

			$("body").mouseup(function () {
				if (!showSearchResults) {
					$(".autoCompleteContainer").hide();
				}
			});

			$("#txtSearchFor").focusin(function () {
				showSearchResults = true;
				$(".autoCompleteContainer").show();
			});
		}
		$(".autoCompleteSpinner").hide();

    $("#btnSearch").click(function() {
        VP.Search.SearchFor();
    });
});

VP.Search.SearchFor = function() {
    var searchTextBox = $("#txtSearchFor");
    var enteredText = searchTextBox.val();
    var defaultSearchText = searchTextBox.data("inputPreviewText");
    var searchText = VP.Search.FormatSearchText();
    if (searchText != "" && typeof (defaultSearchText) != 'undefined' && enteredText != defaultSearchText) {
        var searchResultsPageUrl = $('#hdnSearchResultsPageUrl').val() + '?search=' + searchText;
        window.location = searchResultsPageUrl;
        //$("form").attr("action", searchResultsPageUrl);
        //$("form").submit();
    }
};

VP.Search.FormatSearchText = function() {
	var searchText = $("#txtSearchFor").val();
	searchText = searchText.replace(/</g, '');
	searchText = searchText.replace(/"/g, ' ');
	searchText = searchText.replace(/>/g, '');
	searchText = searchText.replace(/^\s+/, '');
	if (searchText != "") {
		searchText = encodeURIComponent(searchText);
	}

	if (searchText == "") {
		$("#txtSearchFor").val(searchText);
	}

	return searchText;
};

VP.Search.AutoCompleteResults = function () {
	var resultHtml;
	var searchText = VP.Search.RemoveSpecialCharacters();
	var size = 5;
	var autoCompleteContainer = $(".autoCompleteContainer");
	var maxLength = truncationLength;

	if (searchText.length > minSearchLength && autoCompleteContainer.length > 0) {
		$.ajax({
			type: "POST",
			async: true,
			cache: false,
			url: VP.AjaxWebServiceUrl + "/GetSearchHeaderAutoCompletedResultsAsync",
			data: "{'siteId' : '" + VP.SiteId + "','searchText' : '" + searchText + "','size' : '" + size + "','maxLength' : '" + maxLength +"'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				if (searchText == latestSearch)
				{
					resultHtml = msg.d.Result;
					autoCompleteContainer.html("");
					autoCompleteContainer.append(resultHtml);
					$(".autoCompleteSpinner").hide();
				}
				$(".autoCompleteContainer").show();
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
				$(".autoCompleteContainer").hide();
				$(".autoCompleteSpinner").hide();
			}
		});
	}
	else
	{
		$(".autoCompleteSpinner").hide();
		autoCompleteContainer.html("");
	}
};


VP.Search.RemoveSpecialCharacters = function () {
	var searchText = $("#txtSearchFor").val();
	searchText = searchText.replace(/</g, '');
	searchText = searchText.replace(/"/g, ' ');
	searchText = searchText.replace(/>/g, '');
	searchText = searchText.replace(/^\s+/, '');
	searchText = searchText.replace(/{/, '');
	searchText = searchText.replace(/}/, '');
	if (searchText == "") {
		$("#txtSearchFor").val(searchText);
	}

	return searchText;
};