RegisterNamespace("VP.VendorSearch");

$(document).ready(function () {
  $(".searchText").keypress(function (event) {
	if (event.which == 13) {
		event.preventDefault();
			$(".searchButton").click();
		}
	});

	$(".searchButton").click(function () {
		VP.VendorSearch.SearchFor();
	});

	setTimeout(function () {
		VP.VendorSearch.TransferToSearchTab();
	}, 1);
});

VP.VendorSearch.SearchFor = function () {
	var searchTextBox = $(".searchText");
	var enteredText = searchTextBox.val();
	var searchText = VP.VendorSearch.FormatSearchText();
	if (searchText != "") {
		window.location = VP.VendorSearch.UpdateQueryStringParameter(location.href, "search", searchText);
	}
};

VP.VendorSearch.FormatSearchText = function () {
	var searchText = $(".searchText").val();
	searchText = searchText.replace(/</g, '');
	searchText = searchText.replace(/"/g, ' ');
	searchText = searchText.replace(/>/g, '');
	searchText = searchText.replace(/^\s+/, '');
	if (searchText != "") {
		searchText = encodeURIComponent(searchText);
	}

	if (searchText == "") {
		$(".searchText").val(searchText);
	}

	return searchText;
};

VP.VendorSearch.UpdateQueryStringParameter = function (uri, key, value) {
	var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
	var separator = uri.indexOf('?') !== -1 ? "&" : "?";
	uri = uri.replace(location.hash, "");
	if (uri.match(re)) {
	    return uri.replace(re, '$1' + key + "=" + value + '$2');
	}
	else {
	    return uri + separator + key + "=" + value;
	}
};

VP.VendorSearch.GetQueryStringParameter = function (paremeterKey) {
	paremeterKey = paremeterKey.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + paremeterKey + "=([^&#]*)");
	var results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
};

VP.VendorSearch.TransferToSearchTab = function () {
	var searchQuery = VP.VendorSearch.GetQueryStringParameter('search');
	if (searchQuery != "") {
		$(".searchText").val(searchQuery);
		var tabId = $("#hiddenTabId").val();
		var searchTabIndex = VP.VendorSearch.GetSearchTabIndex();
		var tabInstance = eval("tab" + tabId);
		tabInstance.SelectTab($(".vendorProfileTabContainer .tab"), searchTabIndex);
	}
};

VP.VendorSearch.GetSearchTabIndex = function () {
	var searchIndex;
	var headerUl = $(".vendorProfileTabContainer .tab").find('ul');
	if (headerUl != undefined) {
		headerUl.find('li').each(function () {
			if ($(this).text().toLowerCase().match("search")) {
				searchIndex = headerUl.find('li').index($(this));
			}
		});
	}

	if (searchIndex == undefined || searchIndex < 0) {
		searchIndex = 0;
	}

	return searchIndex;
};
